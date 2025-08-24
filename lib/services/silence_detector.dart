import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/services/audio_circuit_breaker.dart';

class SilenceDetector {
  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _subscription;
  final List<double> _readings = [];
  final double _threshold;
  final int _durationSeconds;
  final int _sampleIntervalMs;
  DateTime? _sessionStartTime; // To track the actual start time
  
  // Real-time streaming controllers with proper disposal
  final StreamController<double> _realtimeController = StreamController<double>.broadcast();
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
  bool _audioBufferCrashProtection = false;
  static const int _maxAudioErrors = 3;
  static const Duration _audioErrorWindow = Duration(minutes: 1);

  SilenceDetector({
    double threshold = AppConstants.defaultDecibelThreshold,
    int durationSeconds = AppConstants.silenceDurationSeconds,
    int sampleIntervalMs = AppConstants.sampleIntervalMs,
  })  : _threshold = threshold,
        _durationSeconds = durationSeconds,
        _sampleIntervalMs = sampleIntervalMs;

  /// Request microphone permission by actually trying to access the microphone
  Future<bool> requestPermission() async {
    try {
      if (!kReleaseMode) print('DEBUG: Requesting microphone permission...');
      
      // First check current permission status
      final initialStatus = await Permission.microphone.status;
      if (!kReleaseMode) print('DEBUG: Initial permission status: $initialStatus');
      
      if (initialStatus == PermissionStatus.granted) {
        if (!kReleaseMode) print('DEBUG: Permission already granted');
        return true;
      }
      
      if (initialStatus == PermissionStatus.permanentlyDenied) {
        if (!kReleaseMode) print('DEBUG: Permission permanently denied');
        return false;
      }
      
      // On iOS, we need to actually try to access the microphone to trigger permission dialog
      if (!kReleaseMode) print('DEBUG: Attempting to access microphone to trigger permission dialog...');
      final tempNoiseMeter = NoiseMeter();
      StreamSubscription<NoiseReading>? tempSubscription;
      bool microphoneWorking = false;
      
      try {
        // Try to start listening - this will trigger the iOS permission dialog
        tempSubscription = tempNoiseMeter.noise.listen(
          (NoiseReading reading) {
            // We got a reading, which means permission was granted
            if (!kReleaseMode) print('DEBUG: Successfully accessed microphone, permission granted');
            microphoneWorking = true;
          },
          onError: (error) {
            if (!kReleaseMode) print('DEBUG: Error accessing microphone: $error');
          },
        );
        
        // Wait a bit to see if we get permission or an error
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Clean up the temporary subscription
        tempSubscription.cancel();
        
        if (!kReleaseMode) print('DEBUG: Microphone working: $microphoneWorking');
        
        // If we got microphone readings, permission is granted regardless of what permission_handler says
        if (microphoneWorking) {
          if (!kReleaseMode) print('DEBUG: Microphone access successful, returning true');
          return true;
        }
        
        // Check final permission status as fallback
        final finalStatus = await Permission.microphone.status;
        if (!kReleaseMode) print('DEBUG: Final permission status: $finalStatus');
        
        return finalStatus == PermissionStatus.granted;
        
      } catch (e) {
        if (!kReleaseMode) print('DEBUG: Exception during microphone access: $e');
        tempSubscription?.cancel();
        
        // If we got microphone readings before the exception, permission is still granted
        if (microphoneWorking) {
          if (!kReleaseMode) print('DEBUG: Microphone was working before exception, returning true');
          return true;
        }
        
        // Check if permission was granted despite the exception
        final finalStatus = await Permission.microphone.status;
        if (!kReleaseMode) print('DEBUG: Permission status after exception: $finalStatus');
        return finalStatus == PermissionStatus.granted;
      }
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error requesting permission: $e');
      return false;
    }
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    if (!kReleaseMode) print('DEBUG: Checking permission status: $status');
    return status == PermissionStatus.granted;
  }

  /// Open app settings (useful when permission is permanently denied)
  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error opening app settings: $e');
      return false;
    }
  }

  /// Get permission status for better error handling
  Future<PermissionStatus> getPermissionStatus() async {
    final status = await Permission.microphone.status;
    if (!kReleaseMode) print('DEBUG: Getting permission status: $status');
    return status;
  }

  /// Start listening for silence
  Future<void> startListening({
    required Function(double progress) onProgress,
    required Function(bool success) onComplete,
    required Function(String error) onError,
  }) async {
    try {
      if (!kReleaseMode) print('DEBUG: Starting silence detection...');
      
      // Check circuit breaker state before attempting audio access
      if (_audioExecutor.isBlocked) {
        final retryTime = _audioExecutor.timeUntilRetry;
        final retryMessage = retryTime != null ? 
            ' Audio will be available again in ${retryTime.inSeconds} seconds.' : '';
        onError('Audio access temporarily disabled due to recent errors.$retryMessage');
        return;
      }
      
      // First test if microphone already works with circuit breaker protection
      bool microphoneWorks = await testMicrophoneAccessSafe();
      
      if (!microphoneWorks) {
        if (!kReleaseMode) print('DEBUG: Microphone not working, requesting permission...');
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
        if (!kReleaseMode) print('DEBUG: Microphone still not working after permission request');
        final status = await Permission.microphone.status;
        if (!kReleaseMode) print('DEBUG: Final permission status: $status');
        
        if (status == PermissionStatus.permanentlyDenied) {
          onError('Microphone permission was denied. Please enable it in Settings > Privacy & Security > Microphone > Silence Score.');
        } else if (status == PermissionStatus.restricted) {
          onError('Microphone access is restricted on this device (possibly by parental controls or device management).');
        } else {
          onError('Microphone permission is required to measure silence. Please allow microphone access when prompted.');
        }
        return;
      }

      if (!kReleaseMode) print('DEBUG: Microphone access verified, initializing noise meter...');
      // Initialize noise meter
      _noiseMeter = NoiseMeter();
      _readings.clear();
      _sessionStartTime = DateTime.now(); // Record the session start time

      if (!kReleaseMode) print('DEBUG: Starting noise meter...');
      // Start listening using the correct API
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          _processReading(reading, onProgress, onComplete);
        },
        onError: (error) {
          if (!kReleaseMode) print('DEBUG: Noise meter error: $error');
          onError('Failed to access microphone: ${error.toString()}');
        },
      );
      if (!kReleaseMode) print('DEBUG: Noise meter started successfully');
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Exception in startListening: $e');
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
        if (!kReleaseMode) print('DEBUG: Invalid decibel reading: $decibel, skipping');
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
          if (!kReleaseMode) print('DEBUG: Error emitting to real-time stream: $e');
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
        final success = _checkSuccess();
        onComplete(success);
      }
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error processing reading safely: $e');
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

  /// Check if silence was maintained throughout the duration
  bool _checkSuccess() {
    if (_readings.isEmpty) return false;
    
    // Calculate average decibel level
    final averageDecibel = _readings.reduce((a, b) => a + b) / _readings.length;
    
    // Check if average is below threshold
    return averageDecibel <= _threshold;
  }

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
      
      if (!kReleaseMode) print('DEBUG: Clean state ensured');
      
      // Small delay to ensure cleanup is complete
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error ensuring clean state: $e');
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
      
      if (!kReleaseMode) print('DEBUG: Listening stopped');
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error stopping listening: $e');
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
      if (!kReleaseMode) print('DEBUG: Disposing SilenceDetector');
      
      _isDisposed = true;
      _stopListening();
      
      // Close stream controller
      if (!_realtimeController.isClosed) {
        _realtimeController.close();
      }
      
      // Clear readings
      _readings.clear();
      
      if (!kReleaseMode) print('DEBUG: SilenceDetector disposed successfully');
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error disposing SilenceDetector: $e');
    }
  }

  /// Start ambient monitoring with proper state management
  Future<void> startAmbientMonitoring({
    required Function(String error) onError,
  }) async {
    if (_isDisposed || _isListening || _isAmbientMonitoring) {
      if (!kReleaseMode) print('DEBUG: Cannot start ambient monitoring - already active or disposed');
      return;
    }
    
    try {
      if (!kReleaseMode) print('DEBUG: Starting ambient monitoring...');
      
      // Check circuit breaker state before attempting audio access
      if (_audioExecutor.isBlocked) {
        final retryTime = _audioExecutor.timeUntilRetry;
        final retryMessage = retryTime != null ? 
            ' Audio will be available again in ${retryTime.inSeconds} seconds.' : '';
        onError('Audio access temporarily disabled due to recent errors.$retryMessage');
        return;
      }
      
      // Check if buffer is stable
      if (!_audioExecutor.isBufferStable) {
        onError('Audio system is recovering from recent issues. Please try again in a moment.');
        return;
      }
      
      // Ensure clean state
      await _ensureCleanState();
      
      // Test microphone access first with timeout and circuit breaker protection
      bool microphoneWorks = await _audioExecutor.execute(
        () => testMicrophoneAccessSafe(),
        'safe_microphone_test',
      ).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          if (!kReleaseMode) print('DEBUG: Microphone test timed out');
          return false;
        },
      ) ?? false;
      
      if (!microphoneWorks) {
        if (!kReleaseMode) print('DEBUG: Microphone not working, requesting permission for ambient monitoring...');
        // Try to request permission
        final hasPermission = await requestPermission();
        
        if (hasPermission) {
          // Test again after permission request
          microphoneWorks = await _audioExecutor.execute(
            () => testMicrophoneAccessSafe(),
            'safe_microphone_test',
          ) ?? false;
        }
        
        if (!microphoneWorks) {
          if (!kReleaseMode) print('DEBUG: Microphone still not working after permission request for ambient monitoring');
          final status = await Permission.microphone.status;
          if (!kReleaseMode) print('DEBUG: Final permission status for ambient monitoring: $status');
          
          if (status == PermissionStatus.permanentlyDenied) {
            onError('Microphone permission was denied. Please enable it in Settings > Privacy & Security > Microphone > Silence Score.');
          } else if (status == PermissionStatus.restricted) {
            onError('Microphone access is restricted on this device.');
          } else {
            onError('Unable to access microphone for ambient monitoring. Please check your device settings.');
          }
          return;
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
              if (!kReleaseMode) print('DEBUG: Error processing ambient reading: $e');
              _handleAudioError('Ambient reading processing error: $e');
            }
          }
        },
        onError: (error) {
          if (!_isDisposed && _isAmbientMonitoring) {
            if (!kReleaseMode) print('DEBUG: Ambient monitoring error: $error');
            
            // Check for specific audio buffer errors
            final errorString = error.toString();
            if (errorString.contains('releaseBuffer') || 
                errorString.contains('mUnreleased') || 
                errorString.contains('BufferSizeInFrames') ||
                errorString.contains('AudioRecord') ||
                errorString.contains('AudioTrack')) {
              _handleAudioError('Audio buffer synchronization error: $errorString');
            } else if (errorString.contains('nativeDispatchPlatformMessage') ||
                       errorString.contains('EventChannel') ||
                       errorString.contains('FlutterJNI') ||
                       errorString.contains('DartMessenger') ||
                       errorString.contains('Runtime aborting')) {
              _handleAudioError('Flutter engine communication error: $errorString');
            } else {
              onError('Failed to access microphone: ${error.toString()}');
            }
          }
        },
        cancelOnError: false,
      );
      
      if (!kReleaseMode) print('DEBUG: Ambient monitoring started successfully');
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Exception in startAmbientMonitoring: $e');
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
        if (!kReleaseMode) print('DEBUG: Stopping ambient monitoring');
        _stopListening();
      }
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error stopping ambient monitoring: $e');
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
  Future<NoiseMeter?> _createNoiseMeterSafely() async {
    try {
      // Add a small delay to prevent rapid creation attempts
      await Future.delayed(const Duration(milliseconds: 100));
      
      final noiseMeter = NoiseMeter();
      
      // Give it a moment to initialize
      await Future.delayed(const Duration(milliseconds: 50));
      
      return noiseMeter;
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Failed to create NoiseMeter safely: $e');
      _handleAudioError('NoiseMeter creation error: $e');
      return null;
    }
  }
  
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
    if (!kReleaseMode) print('DEBUG: Audio circuit breaker manually reset');
  }
  
  /// Test microphone with circuit breaker protection (enhanced version)
  Future<bool> testMicrophoneAccessSafe() async {
    if (_isDisposed) return false;
    
    // Check if circuit breaker is blocking audio access
    if (_audioExecutor.isBlocked) {
      if (!kReleaseMode) {
        print('DEBUG: Microphone test blocked by circuit breaker - audio access temporarily disabled');
        final retryTime = _audioExecutor.timeUntilRetry;
        if (retryTime != null) {
          print('DEBUG: Audio retry available in ${retryTime.inSeconds} seconds');
        }
      }
      return false;
    }
    
    // Use circuit breaker to safely execute microphone test
    final result = await _audioExecutor.executeWithTimeout(
      () async {
        if (!kReleaseMode) print('DEBUG: Testing microphone access with circuit breaker protection...');
        
        final testNoiseMeter = NoiseMeter();
        StreamSubscription<NoiseReading>? testSubscription;
        bool microphoneWorking = false;
        
        try {
          final completer = Completer<bool>();
          
          testSubscription = testNoiseMeter.noise.listen(
            (NoiseReading reading) {
              final decibel = reading.meanDecibel;
              if (!kReleaseMode) print('DEBUG: Safe microphone test successful, got reading: $decibel');
              
              if (_isValidDecibel(decibel)) {
                microphoneWorking = true;
                if (!completer.isCompleted) {
                  completer.complete(true);
                }
              } else {
                if (!kReleaseMode) print('DEBUG: Invalid decibel reading in safe test: $decibel');
              }
            },
            onError: (error) {
              if (!kReleaseMode) print('DEBUG: Safe microphone test failed: $error');
              if (!completer.isCompleted) {
                completer.complete(false);
              }
            },
          );
          
          // Wait briefly for a reading - shorter timeout to prevent buffer issues
          await Future.delayed(const Duration(milliseconds: 300));
          
          if (!completer.isCompleted) {
            completer.complete(microphoneWorking);
          }
          
          final testResult = await completer.future;
          await testSubscription.cancel();
          
          // Add small delay to allow native buffers to release
          await Future.delayed(const Duration(milliseconds: 150));
          
          if (!kReleaseMode) print('DEBUG: Safe microphone test result: $testResult');
          return testResult;
          
        } catch (e) {
          if (!kReleaseMode) print('DEBUG: Exception during safe microphone test: $e');
          await testSubscription?.cancel();
          rethrow; // Re-throw to let circuit breaker handle it
        }
      },
      'safe_microphone_test',
      const Duration(milliseconds: 600), // Even shorter timeout to prevent native crashes
    );
    
    if (result == null) {
      if (!kReleaseMode) {
        print('DEBUG: Safe microphone test failed or blocked - circuit breaker may have activated');
      }
      return false;
    }
    
    return result;
  }
  
  /// Handle audio errors and implement backoff
  void _handleAudioError(String error) {
    final now = DateTime.now();
    
    // Reset counter if enough time has passed
    if (_lastAudioError != null && 
        now.difference(_lastAudioError!).inMinutes > _audioErrorWindow.inMinutes) {
      _audioErrorCount = 0;
    }
    
    _audioErrorCount++;
    _lastAudioError = now;
    
    if (!kReleaseMode) {
      print('DEBUG: Audio error #$_audioErrorCount: $error');
    }
    
    // Check for specific audio buffer errors and handle them appropriately
    final errorString = error.toLowerCase();
    if (errorString.contains('releasebuffer') || 
        errorString.contains('munreleased') || 
        errorString.contains('buffersizeinframes') ||
        errorString.contains('audiorecord') ||
        errorString.contains('audiotrack')) {
      
      if (!kReleaseMode) {
        print('DEBUG: Detected audio buffer synchronization error - activating enhanced protection');
      }
      
      // Use the enhanced audio executor to handle buffer errors
      _audioExecutor.execute(
        () async {
          // This will trigger the buffer error detection in SafeAudioExecutor
          throw Exception(error);
        },
        'buffer_error_detection',
      );
    } else if (errorString.contains('nativedispatchplatformmessage') ||
               errorString.contains('eventchannel') ||
               errorString.contains('flutterjni') ||
               errorString.contains('dartmessenger') ||
               errorString.contains('runtime aborting')) {
      
      if (!kReleaseMode) {
        print('DEBUG: Detected Flutter engine communication error - activating enhanced protection');
      }
      
      // Use the enhanced audio executor to handle Flutter engine errors
      _audioExecutor.execute(
        () async {
          // This will trigger the Flutter engine error detection in SafeAudioExecutor
          throw Exception(error);
        },
        'flutter_engine_error_detection',
      );
    }
    
    // Enable crash protection if too many errors
    if (_audioErrorCount >= _maxAudioErrors) {
      _audioBufferCrashProtection = true;
      if (!kReleaseMode) {
        print('DEBUG: Audio buffer crash protection activated after $_audioErrorCount errors');
      }
      
      // Schedule a reset of crash protection
      Timer(const Duration(minutes: 5), () {
        _audioBufferCrashProtection = false;
        _audioErrorCount = 0;
        if (!kReleaseMode) {
          print('DEBUG: Audio buffer crash protection reset');
        }
      });
    }
  }
  
  /// Check if we should skip audio access due to recent errors
  bool _shouldSkipAudioAccess() {
    // Check legacy crash protection
    if (_audioBufferCrashProtection) return true;
    
    // Check enhanced audio executor state
    if (_audioExecutor.isBlocked || !_audioExecutor.isBufferStable || !_audioExecutor.isFlutterStable) {
      if (!kReleaseMode) {
        print('DEBUG: Audio access blocked by enhanced protection (blocked: ${_audioExecutor.isBlocked}, buffer stable: ${_audioExecutor.isBufferStable}, flutter stable: ${_audioExecutor.isFlutterStable})');
      }
      return true;
    }
    
    // Check immediate protection
    if (_audioExecutor.isImmediateProtectionActive) {
      if (!kReleaseMode) {
        print('DEBUG: Audio access blocked by immediate protection');
      }
      return true;
    }
    
    // Check legacy error counting
    if (_lastAudioError != null && _audioErrorCount >= 2) {
      final timeSinceError = DateTime.now().difference(_lastAudioError!);
      return timeSinceError.inSeconds < 30; // Wait 30 seconds after 2 errors
    }
    
    return false;
  }
  
  /// Safely cleanup stream subscription
  Future<void> _safeCleanupSubscription(StreamSubscription<NoiseReading>? subscription) async {
    if (subscription == null) return;
    
    try {
      await subscription.cancel();
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error canceling subscription: $e');
      // Don't propagate subscription cleanup errors
    }
  }

  /// Test if microphone actually works with native crash protection
  Future<bool> testMicrophoneAccess() async {
    try {
      if (!kReleaseMode) print('DEBUG: Testing microphone access...');
      final testNoiseMeter = NoiseMeter();
      StreamSubscription<NoiseReading>? testSubscription;
      bool microphoneWorking = false;
      
      try {
        testSubscription = testNoiseMeter.noise.listen(
          (NoiseReading reading) {
            if (!kReleaseMode) print('DEBUG: Microphone test successful, got reading:  ${reading.meanDecibel}');
            microphoneWorking = true;
          },
          onError: (error) {
            if (!kReleaseMode) print('DEBUG: Microphone test failed: $error');
          },
        );
        
        // Wait briefly for a reading
        await Future.delayed(const Duration(milliseconds: 500));
        
        testSubscription.cancel();
        
        if (!kReleaseMode) print('DEBUG: Microphone test result: $microphoneWorking');
        return microphoneWorking;
      } catch (e) {
        if (!kReleaseMode) print('DEBUG: Exception during microphone test: $e');
        testSubscription?.cancel();
        return false;
      }
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error testing microphone: $e');
      return false;
    }
  }

  /// Get session statistics
  SessionStats getSessionStats() {
    final averageNoise = _readings.isEmpty ? 0.0 : 
        _readings.reduce((a, b) => a + b) / _readings.length;
    final maxNoise = _readings.isEmpty ? 0.0 : _readings.reduce((a, b) => a > b ? a : b);
    final minNoise = _readings.isEmpty ? 0.0 : _readings.reduce((a, b) => a < b ? a : b);
    final silencePercentage = _readings.isEmpty ? 0.0 : 
        (_readings.where((reading) => reading <= _threshold).length / _readings.length) * 100;
    
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
      
      if (!kReleaseMode) print('DEBUG: Readings cleared for new session');
    } catch (e) {
      if (!kReleaseMode) print('DEBUG: Error clearing readings: $e');
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