import 'package:flutter/foundation.dart';

/// Centralized debug logging utility.
///
/// Usage: DebugLog.d('message');
/// In release builds all logs are suppressed unless [force] is set.
/// You can also disable at runtime (e.g. privacy mode) by flipping [enabled].
class DebugLog {
  DebugLog._();
  static bool enabled = true;

  static void d(String message, {bool force = false}) {
    if (!enabled) return;
    if (kReleaseMode && !force) return;
    debugPrint(message);
  }
}
