import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_constants.dart';
import 'audio_circuit_breaker.dart';
import '../utils/debug_log.dart';

class SilenceDetector {
  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _subscription;
  final List<double> _readings = [];
  final double _threshold;
  final int _durationSeconds;
  DateTime? _sessionStartTime; // To track the actual start time

  // Shared permission request future to prevent concurrent OS dialog / status churn
  Future<bool>? _permissionRequestFuture;
  PermissionStatus? _cachedPermissionStatus;
  DateTime? _lastPermissionCheck;

  // Real-time streaming controllers with proper disposal
  final StreamController<double> _realtimeController =
      StreamController<double>.broadcast();
  Timer? _realtimeTimer;
  double _currentDecibel = 0.0;

  // State management for concurrent operations
  bool _isDisposed = false;
  bool _isListening = false;
  bool _isAmbientMonitoring = false;

  // Audio circuit breaker for preventing native crashes
  final SafeAudioExecutor _audioExecutor = SafeAudioExecutor();

  // Audio buffer crash protection (legacy - kept for compatibility)
  int _audioErrorCount = 0;
  DateTime? _lastAudioError;
  static const int _maxAudioErrors = 3;
  static const Duration _audioErrorWindow = Duration(minutes: 1);

  SilenceDetector({
    double threshold = AppConstants.defaultDecibelThreshold,
    int durationSeconds = AppConstants.silenceDurationSeconds,
  }) : _threshold = threshold,
       _durationSeconds = durationSeconds;

  /// Request microphone permission by actually trying to access the microphone
  Future<bool> requestPermission() async {
    // Reuse in-flight request if present
    if (_permissionRequestFuture != null) {
      return _permissionRequestFuture!;
    }
    _permissionRequestFuture = _requestPermissionInternal();
    final result = await _permissionRequestFuture!;
    _permissionRequestFuture = null;
    return result;
  }

  Future<bool> _requestPermissionInternal() async {
    try {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Requesting microphone permission...');
      }

      final initialStatus = await Permission.microphone.status;
      _cachePermissionStatus(initialStatus);
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Initial permission status: $initialStatus');
      }

      if (initialStatus == PermissionStatus.granted) return true;
      if (initialStatus == PermissionStatus.permanentlyDenied) return false;

      if (Platform.isAndroid) {
        final req = await Permission.microphone.request();
        _cachePermissionStatus(req);
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Android permission request result: $req');
        }
        return req == PermissionStatus.granted;
      }

      if (Platform.isIOS || Platform.isMacOS) {
        if (!kReleaseMode) {
          DebugLog.d(
            'DEBUG: Attempting mic access to trigger dialog (iOS/macOS)',
          );
        }
        final tempNoiseMeter = NoiseMeter();
        StreamSubscription<NoiseReading>? tempSubscription;
        bool microphoneWorking = false;
        try {
          tempSubscription = tempNoiseMeter.noise.listen((r) {
            microphoneWorking = true;
          }, onError: (_) {});
          await Future.delayed(const Duration(milliseconds: 900));
          await tempSubscription.cancel();
        } catch (e) {
          if (!kReleaseMode) {
            DebugLog.d('DEBUG: iOS/macOS mic trigger error: $e');
          }
          await tempSubscription?.cancel();
        }
        final finalStatus = await Permission.microphone.status;
        _cachePermissionStatus(finalStatus);
        if (!kReleaseMode) {
          DebugLog.d(
            'DEBUG: iOS/macOS final permission status: $finalStatus micWorking=$microphoneWorking',
          );
        }
        return microphoneWorking || finalStatus == PermissionStatus.granted;
      }

      final fallback = await Permission.microphone.request();
      _cachePermissionStatus(fallback);
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Fallback platform request result: $fallback');
      }
      return fallback == PermissionStatus.granted;
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error requesting permission: $e');
      }
      return false;
    }
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    // Small cache window to reduce status syscalls
    if (_cachedPermissionStatus != null && _lastPermissionCheck != null) {
      if (DateTime.now().difference(_lastPermissionCheck!) <
          const Duration(seconds: 3)) {
        return _cachedPermissionStatus == PermissionStatus.granted;
      }
    }
    final status = await Permission.microphone.status;
    _cachePermissionStatus(status);
    if (!kReleaseMode) {
      DebugLog.d('DEBUG: Checking permission status: $status');
    }
    return status == PermissionStatus.granted;
  }

  void _cachePermissionStatus(PermissionStatus status) {
    _cachedPermissionStatus = status;
    _lastPermissionCheck = DateTime.now();
  }

  /// Open app settings (useful when permission is permanently denied)
  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error opening app settings: $e');
      }
      return false;
    }
  }

  /// Get permission status for better error handling
  Future<PermissionStatus> getPermissionStatus() async {
    final status = await Permission.microphone.status;
    if (!kReleaseMode) {
      DebugLog.d('DEBUG: Getting permission status: $status');
    }
    return status;
  }

  /// Start listening for silence
  Future<void> startListening({
    required Function(double progress) onProgress,
    required Function(bool success) onComplete,
    required Function(String error) onError,
  }) async {
    try {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Starting silence detection...');
      }

      // Android safety: never create NoiseMeter before permission granted
      if (Platform.isAndroid) {
        final granted = await hasPermission();
        if (!granted) {
          final req = await Permission.microphone.request();
          if (req != PermissionStatus.granted) {
            onError('Microphone permission is required to start a session.');
            return;
          }
        }
      }

      // Check circuit breaker state before attempting audio access
      if (_audioExecutor.isBlocked) {
        final retryTime = _audioExecutor.timeUntilRetry;
        final retryMessage =
            retryTime != null
                ? ' Audio will be available again in ${retryTime.inSeconds} seconds.'
                : '';
        onError(
          'Audio access temporarily disabled due to recent errors.$retryMessage',
        );
        return;
      }

      // First test if microphone already works with circuit breaker protection
      bool microphoneWorks = await testMicrophoneAccessSafe();

      if (!microphoneWorks) {
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Microphone not working, requesting permission...');
        }
        // Try to request permission
        final hasPermission = await requestPermission();

        if (!hasPermission) {
          // Test again after permission request
          microphoneWorks = await testMicrophoneAccessSafe();
        } else {
          // Even if permission was granted, test the microphone to make sure it actually works
          microphoneWorks = await testMicrophoneAccessSafe();
        }
      }

      if (!microphoneWorks) {
        if (!kReleaseMode) {
          DebugLog.d(
            'DEBUG: Microphone still not working after permission request',
          );
        }
        final status = await Permission.microphone.status;
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Final permission status: $status');
        }

        if (status == PermissionStatus.permanentlyDenied) {
          onError(
            'Microphone permission was denied. Please enable it in Settings > Privacy & Security > Microphone > Focus Field.',
          );
        } else if (status == PermissionStatus.restricted) {
          onError(
            'Microphone access is restricted on this device (possibly by parental controls or device management).',
          );
        } else {
          onError(
            'Microphone permission is required to measure silence. Please allow microphone access when prompted.',
          );
        }
        return;
      }

      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: Microphone access verified, initializing noise meter...',
        );
      }
      // Initialize noise meter
      _noiseMeter = NoiseMeter();
      _readings.clear();
      _sessionStartTime = DateTime.now(); // Record the session start time

      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Starting noise meter...');
      }
      // Start listening using the correct API
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          _processReading(reading, onProgress, onComplete);
        },
        onError: (error) {
          if (!kReleaseMode) {
            DebugLog.d('DEBUG: Noise meter error: $error');
          }
          onError('Failed to access microphone: ${error.toString()}');
        },
      );
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Noise meter started successfully');
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Exception in startListening: $e');
      }
      onError('Failed to start microphone: ${e.toString()}');
    }
  }

  /// Process each noise reading with crash protection
  void _processReadingSafely(
    NoiseReading reading,
    Function(double progress) onProgress,
    Function(bool success) onComplete,
  ) {
    try {
      final decibel = reading.meanDecibel;

      // Validate decibel reading
      if (!_isValidDecibel(decibel)) {
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Invalid decibel reading: $decibel, skipping');
        }
        return;
      }

      // Add reading to list
      _readings.add(decibel);

      // Update current decibel for real-time display
      _currentDecibel = decibel;

      // Emit to real-time stream safely
      if (!_realtimeController.isClosed) {
        try {
          _realtimeController.add(_currentDecibel);
        } catch (e) {
          if (!kReleaseMode) {
            DebugLog.d('DEBUG: Error emitting to real-time stream: $e');
          }
          // Don't fail the entire reading processing for stream errors
        }
      }

      // Calculate progress based on actual elapsed time for accuracy
      if (_sessionStartTime == null) return; // Should not happen
      final elapsed = DateTime.now().difference(_sessionStartTime!);
      final progress = elapsed.inMilliseconds / (_durationSeconds * 1000);
      onProgress(progress.clamp(0.0, 1.0));

      // Check if we've reached the duration
      if (progress >= 1.0) {
        _stopListening();
        // Legacy parameter - actual success determined by Ambient Score in UI layer
        onComplete(true); // Always true here, real success calculated in home_page_elegant.dart
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error processing reading safely: $e');
      }
      _handleAudioError('Reading processing error: $e');
    }
  }

  /// Process each noise reading (legacy method for backward compatibility)
  void _processReading(
    NoiseReading reading,
    Function(double progress) onProgress,
    Function(bool success) onComplete,
  ) {
    // Use the safe version
    _processReadingSafely(reading, onProgress, onComplete);
  }

  /// Legacy success check removed - now using Ambient Score system
  /// Success is determined by: ambientScore >= 0.70 (70% calm threshold)
  /// Points awarded proportionally based on quiet minutes
  /// See: lib/providers/ambient_quest_provider.dart for Ambient Score calculation

  /// Internal method to ensure clean state before operations
  Future<void> _ensureCleanState() async {
    try {
      // Cancel any existing subscription
      if (_subscription != null) {
        await _subscription!.cancel();
        _subscription = null;
      }

      // Dispose of noise meter
      _noiseMeter = null;

      // Cancel timers
      _realtimeTimer?.cancel();
      _realtimeTimer = null;

      // Reset state flags
      _isListening = false;
      _isAmbientMonitoring = false;

      // Removed debug log - this is called very frequently

      // Small delay to ensure cleanup is complete
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error ensuring clean state: $e');
      }
    }
  }

  /// Stop listening with proper cleanup
  void _stopListening() {
    try {
      _subscription?.cancel();
      _subscription = null;
      _noiseMeter = null;
      _realtimeTimer?.cancel();
      _realtimeTimer = null;
      _isListening = false;
      _isAmbientMonitoring = false;

      // Removed debug log - stopListening is internal, logged at higher level
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error stopping listening: $e');
      }
    }
  }

  /// Stop listening externally (for user-initiated stops)
  void stopListening() {
    if (_isDisposed) return;
    _stopListening();
  }

  /// Dispose resources with proper cleanup
  void dispose() {
    if (_isDisposed) return;

    try {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Disposing SilenceDetector');
      }

      _isDisposed = true;
      _stopListening();

      // Close stream controller
      if (!_realtimeController.isClosed) {
        _realtimeController.close();
      }

      // Clear readings
      _readings.clear();

      if (!kReleaseMode) {
        DebugLog.d('DEBUG: SilenceDetector disposed successfully');
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error disposing SilenceDetector: $e');
      }
    }
  }

  /// Start ambient monitoring with proper state management
  Future<void> startAmbientMonitoring({
    required Function(String error) onError,
  }) async {
    // In widget test environment, skip ambient monitoring to avoid pending timers
    if (kDebugMode && Platform.environment.containsKey('FLUTTER_TEST')) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Skipping ambient monitoring in test environment');
      }
      return;
    }
    if (_isDisposed || _isListening || _isAmbientMonitoring) {
      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: Cannot start ambient monitoring - already active or disposed',
        );
      }
      return;
    }

    try {
      // NOTE: If you see rapid start/stop cycles in logs, investigate what's calling
      // startAmbientMonitoring() and stopAmbientMonitoring() repeatedly.
      // This is likely coming from a provider/widget rebuild loop, not this code.
      if (!kReleaseMode) {
        DebugLog.d('→ Starting ambient monitoring...');
      }

      if (Platform.isAndroid) {
        final granted = await hasPermission();
        if (!granted) {
          final req = await Permission.microphone.request();
          if (req != PermissionStatus.granted) {
            onError('Microphone permission required for ambient monitoring.');
            return;
          }
        }
      }

      // Check circuit breaker state before attempting audio access
      if (_audioExecutor.isBlocked) {
        final retryTime = _audioExecutor.timeUntilRetry;
        final retryMessage =
            retryTime != null
                ? ' Audio will be available again in ${retryTime.inSeconds} seconds.'
                : '';
        onError(
          'Audio access temporarily disabled due to recent errors.$retryMessage',
        );
        return;
      }

      // Check if buffer is stable
      if (!_audioExecutor.isBufferStable) {
        onError(
          'Audio system is recovering from recent issues. Please try again in a moment.',
        );
        return;
      }

      // Ensure clean state (silently)
      await _ensureCleanState();

      // Test microphone access first with timeout and circuit breaker protection
      // NOTE: testMicrophoneAccessSafe() already uses SafeAudioExecutor internally,
      // so we don't need to wrap it again here (avoids duplicate logging)
      bool microphoneWorks = await testMicrophoneAccessSafe();

      if (!microphoneWorks) {
        // Microphone test failed, try requesting permission
        // Removed debug log to reduce noise
        // Try to request permission
        final hasPermission = await requestPermission();

        if (hasPermission) {
          final status = await Permission.microphone.status;
          if (status == PermissionStatus.granted) {
            // Trust granted permission; proceed without immediate retest (iOS latency mitigation)
            microphoneWorks = true;
            if (!kReleaseMode) {
              DebugLog.d(
                'DEBUG: Permission granted; proceeding without immediate mic reading',
              );
            }
          } else {
            // REMOVED DUPLICATE TEST: Don't test again here to avoid duplicate logging
            // The initial test already executed via circuit breaker at line 456
            if (!kReleaseMode) {
              DebugLog.d(
                'DEBUG: Permission status not granted but hasPermission=true; treating as working',
              );
            }
            microphoneWorks = true;
          }
        }
        if (!microphoneWorks) {
          if (!kReleaseMode) {
            DebugLog.d(
              'DEBUG: Microphone still not working after permission request for ambient monitoring',
            );
          }
          final status = await Permission.microphone.status;
          if (!kReleaseMode) {
            DebugLog.d(
              'DEBUG: Final permission status for ambient monitoring: $status',
            );
          }
          if (status == PermissionStatus.permanentlyDenied) {
            onError(
              'Microphone permission was denied. Please enable it in Settings > Privacy & Security > Microphone > Focus Field.',
            );
            return;
          } else if (status == PermissionStatus.restricted) {
            onError('Microphone access is restricted on this device.');
            return;
          } else if (status != PermissionStatus.granted) {
            onError(
              'Unable to access microphone for ambient monitoring. Please check your device settings.',
            );
            return;
          } else {
            if (!kReleaseMode) {
              DebugLog.d(
                'DEBUG: Permission granted but no reading yet – proceeding and awaiting stream',
              );
            }
          }
        }
      }

      _noiseMeter = NoiseMeter();
      _isAmbientMonitoring = true;
      _isListening = false;

      // Start listening for ambient monitoring with enhanced error handling
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          if (!_isDisposed && _isAmbientMonitoring) {
            try {
              final decibel = reading.meanDecibel;
              if (!decibel.isNaN && !decibel.isInfinite && decibel >= 0) {
                _currentDecibel = decibel;
                // Emit to real-time stream for ambient monitoring
                if (!_realtimeController.isClosed) {
                  _realtimeController.add(_currentDecibel);
                }
              }
            } catch (e) {
              if (!kReleaseMode) {
                DebugLog.d('DEBUG: Error processing ambient reading: $e');
              }
              _handleAudioError('Ambient reading processing error: $e');
            }
          }
        },
        onError: (error) {
          if (!_isDisposed && _isAmbientMonitoring) {
            if (!kReleaseMode) {
              DebugLog.d('DEBUG: Ambient monitoring error: $error');
            }

            // Check for specific audio buffer errors
            final errorString = error.toString();
            if (errorString.contains('releaseBuffer') ||
                errorString.contains('mUnreleased') ||
                errorString.contains('BufferSizeInFrames') ||
                errorString.contains('AudioRecord') ||
                errorString.contains('AudioTrack')) {
              _handleAudioError(
                'Audio buffer synchronization error: $errorString',
              );
            } else if (errorString.contains('nativeDispatchPlatformMessage') ||
                errorString.contains('EventChannel') ||
                errorString.contains('FlutterJNI') ||
                errorString.contains('DartMessenger') ||
                errorString.contains('Runtime aborting')) {
              _handleAudioError(
                'Flutter engine communication error: $errorString',
              );
            } else {
              onError('Failed to access microphone: ${error.toString()}');
            }
          }
        },
        cancelOnError: false,
      );

      // Successfully started ambient monitoring
      // Log only important state changes, not routine starts
      DebugLog.d('✓ Ambient monitoring active');
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Exception in startAmbientMonitoring: $e');
      }
      _isAmbientMonitoring = false;
      _handleAudioError('Ambient monitoring startup error: $e');
      onError('Failed to start ambient monitoring: ${e.toString()}');
    }
  }

  /// Stop ambient monitoring with state management
  void stopAmbientMonitoring() {
    if (_isDisposed) return;

    try {
      if (_isAmbientMonitoring) {
        DebugLog.d('⊗ Ambient monitoring stopped');
        _stopListening();
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error stopping ambient monitoring: $e');
      }
    }
  }

  /// Get current average decibel level
  double get currentAverageDecibel {
    if (_readings.isEmpty) return _currentDecibel;
    return _readings.reduce((a, b) => a + b) / _readings.length;
  }

  /// Get current real-time decibel level
  double get currentDecibel => _currentDecibel;

  /// Get current threshold
  double get threshold => _threshold;

  /// Get current duration in seconds
  int get durationSeconds => _durationSeconds;

  /// Create NoiseMeter with native crash protection
  // Removed unused _createNoiseMeterSafely after refactor (aggregation reduced rapid creations)

  /// Check if decibel value is valid and safe
  bool _isValidDecibel(double decibel) {
    return !decibel.isNaN &&
        !decibel.isInfinite &&
        decibel >= 0 &&
        decibel <= 200; // Reasonable upper limit
  }

  /// Check if audio access is currently blocked by circuit breaker
  bool get isAudioBlocked => _audioExecutor.isBlocked;

  /// Get time until audio access might be available again
  Duration? get audioRetryTime => _audioExecutor.timeUntilRetry;

  /// Get circuit breaker state for debugging
  Map<String, dynamic> get audioCircuitState => _audioExecutor.getState();

  /// Reset circuit breaker (for testing or manual recovery)
  void resetAudioCircuitBreaker() {
    _audioExecutor.reset();
    if (!kReleaseMode) {
      DebugLog.d('DEBUG: Audio circuit breaker manually reset');
    }
  }

  /// Test microphone with circuit breaker protection (enhanced version)
  Future<bool> testMicrophoneAccessSafe() async {
    if (_isDisposed) return false;

    // Check if circuit breaker is blocking audio access
    if (_audioExecutor.isBlocked) {
      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: Microphone test blocked by circuit breaker - audio access temporarily disabled',
        );
        final retryTime = _audioExecutor.timeUntilRetry;
        if (retryTime != null) {
          DebugLog.d(
            'DEBUG: Audio retry available in ${retryTime.inSeconds} seconds',
          );
        }
      }
      return false;
    }

    // Use circuit breaker to safely execute microphone test with adaptive timing
    final result = await _audioExecutor.executeWithTimeout(
      () async {
        // Removed debug log - SafeAudioExecutor already logs the operation

        final testNoiseMeter = NoiseMeter();
        StreamSubscription<NoiseReading>? testSubscription;
        bool microphoneWorking = false;

        try {
          final completer = Completer<bool>();
          final bool isApple = Platform.isIOS || Platform.isMacOS;
          final int primaryWaitMs =
              isApple
                  ? 900
                  : 300; // allow more time for first frame on Apple platforms
          final int fallbackExtraMs =
              isApple ? 600 : 0; // extra window if first frame is delayed

          testSubscription = testNoiseMeter.noise.listen(
            (NoiseReading reading) {
              final decibel = reading.meanDecibel;
              // Removed noisy debug log - this happens multiple times per test
              if (_isValidDecibel(decibel)) {
                microphoneWorking = true;
                if (!completer.isCompleted) completer.complete(true);
              }
            },
            onError: (error) {
              if (!kReleaseMode) {
                DebugLog.d('DEBUG: Safe microphone test stream error: $error');
              }
              if (!completer.isCompleted) completer.complete(false);
            },
          );

          // Initial wait window
          await Future.delayed(Duration(milliseconds: primaryWaitMs));
          // If still no reading on Apple platforms, extend once
          if (!microphoneWorking && isApple) {
            if (!kReleaseMode) {
              DebugLog.d(
                'DEBUG: No mic reading yet; extending wait window (Apple)',
              );
            }
            await Future.delayed(Duration(milliseconds: fallbackExtraMs));
          }

          if (!completer.isCompleted) completer.complete(microphoneWorking);

          var testResult = await completer.future;
          await testSubscription.cancel();
          // Small buffer release delay
          await Future.delayed(const Duration(milliseconds: 120));

          // Fallback: if no reading but permission is granted, treat as success to avoid false negatives
          if (!testResult) {
            final perm = await Permission.microphone.status;
            // Removed debug log - less verbose
            if (perm == PermissionStatus.granted) {
              testResult = true;
              // Trust permission status
            }
          }

          // Log only failures for troubleshooting
          if (!testResult && !kReleaseMode) {
            DebugLog.d('⚠ Microphone test failed');
          }
          return testResult;
        } catch (e) {
          if (!kReleaseMode) {
            DebugLog.d('DEBUG: Exception during safe microphone test: $e');
          }
          await testSubscription?.cancel();
          rethrow; // Let circuit breaker handle it
        }
      },
      'safe_microphone_test',
      const Duration(
        seconds: 2,
      ), // longer to accommodate iOS first-frame latency
    );

    if (result == null) {
      // Circuit breaker blocked or test failed
      // Already logged by circuit breaker if needed
      return false;
    }

    return result;
  }

  /// Handle audio errors and implement backoff
  void _handleAudioError(String error) {
    final now = DateTime.now();

    // Reset counter if enough time has passed
    if (_lastAudioError != null &&
        now.difference(_lastAudioError!).inMinutes >
            _audioErrorWindow.inMinutes) {
      _audioErrorCount = 0;
    }

    _audioErrorCount++;
    _lastAudioError = now;

    if (!kReleaseMode) {
      DebugLog.d('DEBUG: Audio error #$_audioErrorCount: $error');
    }

    // Check for specific audio buffer errors and handle them appropriately
    final errorString = error.toLowerCase();
    if (errorString.contains('releasebuffer') ||
        errorString.contains('munreleased') ||
        errorString.contains('buffersizeinframes') ||
        errorString.contains('audiorecord') ||
        errorString.contains('audiotrack')) {
      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: Detected audio buffer synchronization error - activating enhanced protection',
        );
      }

      // Use the enhanced audio executor to handle buffer errors
      _audioExecutor.execute(() async {
        // This will trigger the buffer error detection in SafeAudioExecutor
        throw Exception(error);
      }, 'buffer_error_detection');
    } else if (errorString.contains('nativedispatchplatformmessage') ||
        errorString.contains('eventchannel') ||
        errorString.contains('flutterjni') ||
        errorString.contains('dartmessenger') ||
        errorString.contains('runtime aborting')) {
      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: Detected Flutter engine communication error - activating enhanced protection',
        );
      }

      // Use the enhanced audio executor to handle Flutter engine errors
      _audioExecutor.execute(() async {
        // This will trigger the Flutter engine error detection in SafeAudioExecutor
        throw Exception(error);
      }, 'flutter_engine_error_detection');
    }

    // Enable crash protection if too many errors
    if (_audioErrorCount >= _maxAudioErrors) {
      if (!kReleaseMode) {
        DebugLog.d(
          'DEBUG: High audio error count ($_audioErrorCount) - SafeAudioExecutor should now be throttling access',
        );
      }
      // Reset counter after warning to avoid repeated logs
      _audioErrorCount = 0;
    }
  }

  /// Check if we should skip audio access due to recent errors
  // Removed unused _shouldSkipAudioAccess method (logic consolidated in SafeAudioExecutor checks)

  /// Safely cleanup stream subscription
  // Removed unused _safeCleanupSubscription helper (stream lifecycle simplified)

  /// Test if microphone actually works with native crash protection
  Future<bool> testMicrophoneAccess() async {
    try {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Testing microphone access...');
      }
      final testNoiseMeter = NoiseMeter();
      StreamSubscription<NoiseReading>? testSubscription;
      bool microphoneWorking = false;

      try {
        testSubscription = testNoiseMeter.noise.listen(
          (NoiseReading reading) {
            if (!kReleaseMode) {
              DebugLog.d(
                'DEBUG: Microphone test successful, got reading:  ${reading.meanDecibel}',
              );
            }
            microphoneWorking = true;
          },
          onError: (error) {
            if (!kReleaseMode) {
              DebugLog.d('DEBUG: Microphone test failed: $error');
            }
          },
        );

        // Wait briefly for a reading
        await Future.delayed(const Duration(milliseconds: 500));

        testSubscription.cancel();

        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Microphone test result: $microphoneWorking');
        }
        return microphoneWorking;
      } catch (e) {
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: Exception during microphone test: $e');
        }
        testSubscription?.cancel();
        return false;
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error testing microphone: $e');
      }
      return false;
    }
  }

  /// Get session statistics
  SessionStats getSessionStats() {
    final averageNoise =
        _readings.isEmpty
            ? 0.0
            : _readings.reduce((a, b) => a + b) / _readings.length;
    final maxNoise =
        _readings.isEmpty ? 0.0 : _readings.reduce((a, b) => a > b ? a : b);
    final minNoise =
        _readings.isEmpty ? 0.0 : _readings.reduce((a, b) => a < b ? a : b);
    final silencePercentage =
        _readings.isEmpty
            ? 0.0
            : (_readings.where((reading) => reading <= _threshold).length /
                    _readings.length) *
                100;

    return SessionStats(
      averageNoise: averageNoise,
      maxNoise: maxNoise,
      minNoise: minNoise,
      totalReadings: _readings.length,
      silencePercentage: silencePercentage,
      threshold: _threshold,
      duration: _durationSeconds,
    );
  }

  /// Stream for real-time decibel readings (updates every 500ms)
  Stream<double> get realtimeStream => _realtimeController.stream;

  /// Clear readings for new session with validation
  void clearReadings() {
    if (_isDisposed) return;

    try {
      _readings.clear();
      _currentDecibel = 0.0;
      _sessionStartTime = null;

      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Readings cleared for new session');
      }
    } catch (e) {
      if (!kReleaseMode) {
        DebugLog.d('DEBUG: Error clearing readings: $e');
      }
    }
  }
}

/// Session statistics model
class SessionStats {
  final double averageNoise;
  final double maxNoise;
  final double minNoise;
  final int totalReadings;
  final double silencePercentage;
  final double threshold;
  final int duration;

  const SessionStats({
    required this.averageNoise,
    required this.maxNoise,
    required this.minNoise,
    required this.totalReadings,
    required this.silencePercentage,
    required this.threshold,
    required this.duration,
  });
}
