import 'dart:async';
import 'dart:math';
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

  SilenceDetector({
    double threshold = AppConstants.defaultDecibelThreshold,
    int durationSeconds = AppConstants.silenceDurationSeconds,
    int sampleIntervalMs = AppConstants.sampleIntervalMs,
  })  : _threshold = threshold,
        _durationSeconds = durationSeconds,
        _sampleIntervalMs = sampleIntervalMs;

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    return await Permission.microphone.isGranted;
  }

  /// Start listening for silence
  Future<void> startListening({
    required Function(double progress) onProgress,
    required Function(bool success) onComplete,
    required Function(String error) onError,
  }) async {
    try {
      // Check permission first
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          onError(AppConstants.permissionDeniedMessage);
          return;
        }
      }

      // Initialize noise meter
      _noiseMeter = NoiseMeter();
      _readings.clear();

      // Start listening using the correct API
      _subscription = _noiseMeter!.noise.listen(
        (NoiseReading reading) {
          _processReading(reading, onProgress, onComplete);
        },
        onError: (error) {
          onError(AppConstants.noiseMeterError);
        },
      );
    } catch (e) {
      onError(AppConstants.noiseMeterError);
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

    // Calculate progress (0.0 to 1.0)
    final progress = _readings.length / (_durationSeconds * 1000 / _sampleIntervalMs);
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
  }

  /// Dispose resources
  void dispose() {
    _stopListening();
  }

  /// Get current average decibel level
  double get currentAverageDecibel {
    if (_readings.isEmpty) return 0.0;
    return _readings.reduce((a, b) => a + b) / _readings.length;
  }

  /// Get current threshold
  double get threshold => _threshold;

  /// Get current duration in seconds
  int get durationSeconds => _durationSeconds;
} 