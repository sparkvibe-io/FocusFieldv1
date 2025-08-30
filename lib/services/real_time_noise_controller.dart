import 'dart:async';
import 'package:silence_score/services/silence_detector.dart';
import 'package:silence_score/utils/throttled_logger.dart';
import 'package:silence_score/utils/debug_log.dart';

/// Aggregates high-frequency realtime decibel readings into a lower frequency
/// smoothed stream (default 1Hz) to reduce UI rebuild pressure.
class RealTimeNoiseController {
  final SilenceDetector _detector;
  final Duration aggregationInterval;
  final bool enabled;

  final StreamController<double> _controller = StreamController<double>.broadcast();
  late final StreamSubscription<double> _subscription;
  Timer? _timer;
  bool _disposed = false;

  // Buffers
  final List<double> _buffer = [];
  double _lastEmitted = 0.0;

  RealTimeNoiseController(
    this._detector, {
    this.aggregationInterval = const Duration(seconds: 1),
    this.enabled = true,
  }) {
    if (!enabled) {
      // Passthrough mode
      _subscription = _detector.realtimeStream.listen((d) {
        if (_disposed) return;
        if (!_isValid(d)) return;
        _controller.add(d);
      });
      return;
    }

    _subscription = _detector.realtimeStream.listen((d) {
      if (_disposed) return;
      if (!_isValid(d)) return;
      _buffer.add(d);
    }, onError: (e) {
      sensorLogger.log('DEBUG: NoiseController stream error: $e');
      DebugLog.d('DEBUG: NoiseController stream error: $e');
    });

    _timer = Timer.periodic(aggregationInterval, (_) => _flush());
  }

  Stream<double> get stream => _controller.stream;

  void _flush() {
    if (_disposed) return;
    if (_buffer.isEmpty) return;
    final avg = _buffer.reduce((a, b) => a + b) / _buffer.length;
    _buffer.clear();
    _lastEmitted = avg;
    _controller.add(avg);
  }

  double get lastValue => _lastEmitted;

  bool _isValid(double d) => !d.isNaN && !d.isInfinite && d >= 0 && d <= 150;

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _timer?.cancel();
    _subscription.cancel();
    _controller.close();
  }
}
