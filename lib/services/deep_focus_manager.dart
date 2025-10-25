import 'dart:async';

import 'package:flutter/widgets.dart';
// Riverpod not required for lifecycle handling; keep this manager pure.

import '../services/storage_service.dart';

/// DeepFocusManager observes app lifecycle and enforces a "deep focus" rule:
/// - If enabled, when the app goes to background, start a grace timer.
/// - If the app hasn't returned to foreground before grace expires,
///   invoke the onBreach callback so the caller can end/pause the session.
class DeepFocusManager extends WidgetsBindingObserver {
  DeepFocusManager({
    required this.onBreach,
  });
  
  final VoidCallback onBreach;

  Timer? _graceTimer;
  bool _enabledCached = false;
  int _graceSecondsCached = 10;

  Future<void> init() async {
    // Prime cache from storage; subscribe if your storage supports streams later.
    final storage = await StorageService.getInstance();
    final settings = await storage.loadAllSettings();
    _enabledCached = (settings['deepFocusEnabled'] as bool?) ?? false;
    _graceSecondsCached = (settings['deepFocusGraceSeconds'] as int?) ?? 10;
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _graceTimer?.cancel();
  }

  Future<void> refreshSettings() async {
    final storage = await StorageService.getInstance();
    final settings = await storage.loadAllSettings();
    _enabledCached = (settings['deepFocusEnabled'] as bool?) ?? false;
    _graceSecondsCached = (settings['deepFocusGraceSeconds'] as int?) ?? 10;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh settings opportunistically on any lifecycle transition
    // so toggles in Settings take effect without restart.
    // Fire-and-forget; no await in sync override.
    unawaited(refreshSettings());
    if (!_enabledCached) return;

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Start/restart grace timer.
      _startGraceTimer();
    } else if (state == AppLifecycleState.resumed) {
      // Cancel grace upon return.
      _cancelGraceTimer();
    } else if (state == AppLifecycleState.detached) {
      // Treat as immediate breach.
      _breach();
    }
  }

  void _startGraceTimer() {
    _graceTimer?.cancel();
    final duration = Duration(seconds: _graceSecondsCached.clamp(1, 300));
    _graceTimer = Timer(duration, _breach);
  }

  void _cancelGraceTimer() {
    _graceTimer?.cancel();
    _graceTimer = null;
  }

  void _breach() {
    _cancelGraceTimer();
    try {
      onBreach();
    } catch (_) {
      // Swallow to avoid crashing lifecycle callbacks.
    }
  }
}
