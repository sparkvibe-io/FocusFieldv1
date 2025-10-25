import 'package:flutter/foundation.dart';

/// Centralized debug logging utility.
///
/// Usage: DebugLog.d('message');
/// In release builds all logs are suppressed unless [force] is set.
/// You can also disable at runtime (e.g. privacy mode) by flipping [enabled].
class DebugLog {
  DebugLog._();
  // Can be toggled at runtime (e.g., via a hidden setting). Defaults to true for debug/profile.
  static bool enabled = !kReleaseMode;

  static void d(String message, {bool force = false}) {
    if (!enabled) return; // In release enabled is false, so no logs.
    if (kReleaseMode && !force) return; // Redundant safety.
    debugPrint(message);
  }

  static void error(
    String message,
    Object err,
    StackTrace st, {
    bool force = false,
  }) {
    if (!enabled && !force) return;
    if (kReleaseMode && !force) {
      return; // Only forced errors in release (currently none)
    }
    debugPrint('[ERROR] $message: $err');
    debugPrint(st.toString());
  }

  // Allow temporary enabling in release (e.g., via secret gesture) without code change.
  static void enableTemporarilyForDiagnostics() {
    if (kReleaseMode) {
      enabled = true;
      d(
        '[DebugLog] Temporarily enabled diagnostics in release build',
        force: true,
      );
    }
  }
}
