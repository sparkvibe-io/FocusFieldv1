import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  // Settings
  bool enableVibration = true;
  bool enableVoiceOver = false;
  bool enableHighContrast = false;
  bool enableLargeText = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      if (_flutterTts != null) {
        await _flutterTts!.setLanguage('en-US');
        await _flutterTts!.setPitch(1.0);
        await _flutterTts!.setSpeechRate(0.5);
        await _flutterTts!.setVolume(0.8);
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AccessibilityService: $e');
    }
  }

  void updateSettings({
    bool? vibration,
    bool? voiceOver,
    bool? highContrast,
    bool? largeText,
  }) {
    if (vibration != null) enableVibration = vibration;
    if (voiceOver != null) enableVoiceOver = voiceOver;
    if (highContrast != null) enableHighContrast = highContrast;
    if (largeText != null) enableLargeText = largeText;
  }

  // Vibration feedback
  Future<void> vibrateOnEvent(AccessibilityEvent event) async {
    if (!enableVibration) return;

    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator != true) return;

      switch (event) {
        case AccessibilityEvent.sessionStart:
          await Vibration.vibrate(duration: 200);
          break;
        case AccessibilityEvent.sessionComplete:
          await Vibration.vibrate(pattern: [0, 200, 100, 200]);
          break;
        case AccessibilityEvent.sessionFailed:
          await Vibration.vibrate(pattern: [0, 500]);
          break;
        case AccessibilityEvent.buttonPress:
          await Vibration.vibrate(duration: 50);
          break;
        case AccessibilityEvent.thresholdExceeded:
          await Vibration.vibrate(duration: 100);
          break;
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  // Voice announcements
  Future<void> announce(String message) async {
    if (!enableVoiceOver || !_isInitialized || _flutterTts == null) return;

    try {
      await _flutterTts!.speak(message);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  // Session progress announcements
  Future<void> announceSessionProgress(double progress) async {
    if (!enableVoiceOver) return;

    final percentage = (progress * 100).round();
    if (percentage % 25 == 0 && percentage > 0) {
      await announce('$percentage percent complete');
    }
  }

  Future<void> announceSessionStart(int durationMinutes) async {
    if (!enableVoiceOver) return;
    await announce('Starting $durationMinutes minute silence session');
  }

  Future<void> announceSessionComplete(bool success) async {
    if (!enableVoiceOver) return;
    if (success) {
      await announce('Session completed successfully. Well done!');
    } else {
      await announce('Session incomplete. Try again when ready.');
    }
  }

  Future<void> announceThresholdExceeded() async {
    if (!enableVoiceOver) return;
    await announce('Noise threshold exceeded');
  }

  // Text scaling
  double getTextScaleFactor() {
    return enableLargeText ? 1.3 : 1.0;
  }

  // High contrast theme adjustments
  ColorScheme adjustColorSchemeForContrast(ColorScheme original) {
    if (!enableHighContrast) return original;

    // Determine if the original theme is dark
    final isDark = original.brightness == Brightness.dark;

    if (isDark) {
      // High contrast dark theme
      return original.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        primaryContainer: Colors.grey[800]!,
        onPrimaryContainer: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.black,
        secondaryContainer: Colors.grey[700]!,
        onSecondaryContainer: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        surfaceContainer: Colors.grey[900]!,
        surfaceContainerHighest: Colors.grey[800]!,
        onSurfaceVariant: Colors.white,
        outline: Colors.white70,
        outlineVariant: Colors.white54,
        error: Colors.red[300]!,
        onError: Colors.black,
        errorContainer: Colors.red[900]!,
        onErrorContainer: Colors.red[100]!,
      );
    } else {
      // High contrast light theme
      return original.copyWith(
        primary: Colors.black,
        onPrimary: Colors.white,
        primaryContainer: Colors.grey[200]!,
        onPrimaryContainer: Colors.black,
        secondary: Colors.black,
        onSecondary: Colors.white,
        secondaryContainer: Colors.grey[100]!,
        onSecondaryContainer: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainer: Colors.grey[50]!,
        surfaceContainerHighest: Colors.grey[100]!,
        onSurfaceVariant: Colors.black,
        outline: Colors.black54,
        outlineVariant: Colors.black26,
        error: Colors.red[800]!,
        onError: Colors.white,
        errorContainer: Colors.red[50]!,
        onErrorContainer: Colors.red[900]!,
      );
    }
  }

  // Dispose
  void dispose() {
    _flutterTts?.stop();
    _isInitialized = false;
  }
}

enum AccessibilityEvent {
  sessionStart,
  sessionComplete,
  sessionFailed,
  buttonPress,
  thresholdExceeded,
}
