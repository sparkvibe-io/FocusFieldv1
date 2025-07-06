import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silence_score/constants/app_constants.dart';

class SilenceDetector {
  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _subscription;
  final List<double> _readings = [];
  final double _threshold;
  final int _durationSeconds;
  final int _sampleIntervalMs;
  DateTime? _sessionStartTime; // To track the actual start time
  
  // Real-time streaming controllers
  final StreamController<double> _realtimeController = StreamController<double>.broadcast();
  Timer? _realtimeTimer;
  double _currentDecibel = 0.0;

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
      print('DEBUG: Requesting microphone permission...');
      
      // First check current permission status
      final initialStatus = await Permission.microphone.status;
      print('DEBUG: Initial permission status: $initialStatus');
      
      if (initialStatus == PermissionStatus.granted) {
        print('DEBUG: Permission already granted');
        return true;
      }
      
      if (initialStatus == PermissionStatus.permanentlyDenied) {
        print('DEBUG: Permission permanently denied');
        return false;
      }
      
      // On iOS, we need to actually try to access the microphone to trigger permission dialog
      print('DEBUG: Attempting to access microphone to trigger permission dialog...');
      final tempNoiseMeter = NoiseMeter();
      StreamSubscription<NoiseReading>? tempSubscription;
      bool microphoneWorking = false;
      
      try {
        // Try to start listening - this will trigger the iOS permission dialog
        tempSubscription = tempNoiseMeter.noise.listen(
          (NoiseReading reading) {
            // We got a reading, which means permission was granted
            print('DEBUG: Successfully accessed microphone, permission granted');
            microphoneWorking = true;
          },
          onError: (error) {
            print('DEBUG: Error accessing microphone: $error');
          },
        );
        
        // Wait a bit to see if we get permission or an error
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Clean up the temporary subscription
        tempSubscription.cancel();
        
        print('DEBUG: Microphone working: $microphoneWorking');
        
        // If we got microphone readings, permission is granted regardless of what permission_handler says
        if (microphoneWorking) {
          print('DEBUG: Microphone access successful, returning true');
          return true;
        }
        
        // Check final permission status as fallback
        final finalStatus = await Permission.microphone.status;
        print('DEBUG: Final permission status: $finalStatus');
        
        return finalStatus == PermissionStatus.granted;
        
      } catch (e) {
        print('DEBUG: Exception during microphone access: $e');
        tempSubscription?.cancel();
        
        // If we got microphone readings before the exception, permission is still granted
        if (microphoneWorking) {
          print('DEBUG: Microphone was working before exception, returning true');
          return true;
        }
        
        // Check if permission was granted despite the exception
        final finalStatus = await Permission.microphone.status;
        print('DEBUG: Permission status after exception: $finalStatus');
        return finalStatus == PermissionStatus.granted;
      }
    } catch (e) {
      print('DEBUG: Error requesting permission: $e');
      return false;
    }
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    print('DEBUG: Checking permission status: $status');
    return status == PermissionStatus.granted;
  }

  /// Open app settings (useful when permission is permanently denied)
  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      print('DEBUG: Error opening app settings: $e');
      return false;
    }
  }

  /// Get permission status for better error handling
  Future<PermissionStatus> getPermissionStatus() async {
    final status = await Permission.microphone.status;
    print('DEBUG: Getting permission status: $status');
    return status;
  }

  /// Start listening for silence
  Future<void> startListening({
    required Function(double progress) onProgress,
    required Function(bool success) onComplete,
    required Function(String error) onError,
  }) async {
    try {
      print('DEBUG: Starting silence detection...');
      
      // First test if microphone already works
      bool microphoneWorks = await testMicrophoneAccess();
      
      if (!microphoneWorks) {
        print('DEBUG: Microphone not working, requesting permission...');
        // Try to request permission
        final hasPermission = await requestPermission();
        
        if (!hasPermission) {
          // Test again after permission request
          microphoneWorks = await testMicrophoneAccess();
        } else {
          microphoneWorks = true;
        }
      }
      
      if (!microphoneWorks) {
        print('DEBUG: Microphone still not working after permission request');
        final status = await Permission.microphone.status;
        print('DEBUG: Final permission status: $status');
        
        if (status == PermissionStatus.permanentlyDenied) {
          onError('Microphone permission was denied. Please enable it in Settings > Privacy & Security > Microphone > Silence Score.');
        } else if (status == PermissionStatus.restricted) {
          onError('Microphone access is restricted on this device (possibly by parental controls or device management).');
        } else {
          onError('Microphone permission is required to measure silence. Please allow microphone access when prompted.');
        }
        return;
      }

      print('DEBUG: Microphone access verified, initializing noise meter...');
      // Initialize noise meter
      _noiseMeter = NoiseMeter();
      _readings.clear();
      _sessionStartTime = DateTime.now(); // Record the session start time

      print('DEBUG: Starting noise meter...');
      // Start listening using the correct API
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          _processReading(reading, onProgress, onComplete);
        },
        onError: (error) {
          print('DEBUG: Noise meter error: $error');
          onError('Failed to access microphone: ${error.toString()}');
        },
      );
      print('DEBUG: Noise meter started successfully');
    } catch (e) {
      print('DEBUG: Exception in startListening: $e');
      onError('Failed to start microphone: ${e.toString()}');
    }
  }

  /// Process each noise reading
  void _processReading(
    NoiseReading reading,
    Function(double progress) onProgress,
    Function(bool success) onComplete,
  ) {
    // Add reading to list
    _readings.add(reading.meanDecibel);
    
    // Update current decibel for real-time display
    _currentDecibel = reading.meanDecibel;
    
    // Emit to real-time stream
    if (!_realtimeController.isClosed) {
      _realtimeController.add(_currentDecibel);
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
  }

  /// Check if silence was maintained throughout the duration
  bool _checkSuccess() {
    if (_readings.isEmpty) return false;
    
    // Calculate average decibel level
    final averageDecibel = _readings.reduce((a, b) => a + b) / _readings.length;
    
    // Check if average is below threshold
    return averageDecibel <= _threshold;
  }

  /// Stop listening
  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _noiseMeter = null;
    _realtimeTimer?.cancel();
    _realtimeTimer = null;
  }

  /// Stop listening externally (for user-initiated stops)
  void stopListening() {
    _stopListening();
  }

  /// Dispose resources
  void dispose() {
    _stopListening();
    if (!_realtimeController.isClosed) {
      _realtimeController.close();
    }
  }

  /// Start ambient monitoring (real-time chart when not in session)
  Future<void> startAmbientMonitoring({
    required Function(String error) onError,
  }) async {
    try {
      if (_subscription != null) return; // Already listening
      
      // Test microphone access first
      final microphoneWorks = await testMicrophoneAccess();
      if (!microphoneWorks) {
        final hasPermission = await requestPermission();
        if (!hasPermission) return;
      }

      _noiseMeter = NoiseMeter();
      
      // Start listening for ambient monitoring
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          _currentDecibel = reading.meanDecibel;
          // Emit to real-time stream for ambient monitoring
          if (!_realtimeController.isClosed) {
            _realtimeController.add(_currentDecibel);
          }
        },
        onError: (error) {
          onError('Failed to access microphone: ${error.toString()}');
        },
      );
    } catch (e) {
      onError('Failed to start ambient monitoring: ${e.toString()}');
    }
  }

  /// Stop ambient monitoring
  void stopAmbientMonitoring() {
    if (_subscription != null) {
      _stopListening();
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

  /// Test if microphone actually works (more reliable than permission status on iOS)
  Future<bool> testMicrophoneAccess() async {
    try {
      print('DEBUG: Testing microphone access...');
      final testNoiseMeter = NoiseMeter();
      StreamSubscription<NoiseReading>? testSubscription;
      bool microphoneWorking = false;
      
      try {
        testSubscription = testNoiseMeter.noise.listen(
          (NoiseReading reading) {
            print('DEBUG: Microphone test successful, got reading: ${reading.meanDecibel}');
            microphoneWorking = true;
          },
          onError: (error) {
            print('DEBUG: Microphone test failed: $error');
          },
        );
        
        // Wait briefly for a reading
        await Future.delayed(const Duration(milliseconds: 500));
        
        testSubscription.cancel();
        
        print('DEBUG: Microphone test result: $microphoneWorking');
        return microphoneWorking;
      } catch (e) {
        print('DEBUG: Exception during microphone test: $e');
        testSubscription?.cancel();
        return false;
      }
    } catch (e) {
      print('DEBUG: Error testing microphone: $e');
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

  /// Clear readings for new session
  void clearReadings() {
    _readings.clear();
    _currentDecibel = 0.0;
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