import 'package:flutter/foundation.dart';
import 'package:silence_score/utils/debug_log.dart';

/// Lightweight throttled logger to reduce spammy debugPrint calls that can
/// contribute to frame drops in debug/profile builds. In release builds this
/// becomes a no-op (unless [alwaysPrintInRelease] is set, which we keep false).
class ThrottledLogger {
  final Duration interval;
  final bool alwaysPrintInRelease;
  DateTime? _lastLogTime;
  String? _lastMessage;

  ThrottledLogger({
    this.interval = const Duration(milliseconds: 800),
    this.alwaysPrintInRelease = false,
  });

  void log(String message, {bool force = false}) {
    if (!DebugLog.enabled) return;
    if (kReleaseMode && !alwaysPrintInRelease && !force) return; // Skip in release
    final now = DateTime.now();

    // If message changed allow immediate output (helps when errors differ)
    final isSameMessage = message == _lastMessage;
    if (_lastLogTime == null || !isSameMessage) {
      _emit(message);
      return;
    }

    if (now.difference(_lastLogTime!) >= interval) {
      _emit(message);
    }
  }

  void _emit(String message) {
    _lastLogTime = DateTime.now();
    _lastMessage = message;
    DebugLog.d(message);
  }
}

/// Global (optional) shared logger for high-frequency sensors.
final ThrottledLogger sensorLogger = ThrottledLogger(interval: const Duration(milliseconds: 900));
