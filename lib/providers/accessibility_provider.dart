import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/services/accessibility_service.dart';
import 'package:silence_score/providers/silence_provider.dart';

// Accessibility service provider
final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AccessibilityService();
});

// Individual accessibility setting providers
final enableVibrationProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableVibration'] as bool? ?? true,
    loading: () => true,
    error: (_, __) => true,
  );
});

final enableVoiceOverProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableVoiceOver'] as bool? ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

final enableHighContrastProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableHighContrast'] as bool? ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

final enableLargeTextProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableLargeText'] as bool? ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Text scale factor provider
final textScaleFactorProvider = Provider<double>((ref) {
  final enableLargeText = ref.watch(enableLargeTextProvider);
  return enableLargeText ? 1.3 : 1.0;
});

// Combined accessibility settings provider for easy access
final accessibilitySettingsProvider = Provider<Map<String, bool>>((ref) {
  return {
    'enableVibration': ref.watch(enableVibrationProvider),
    'enableVoiceOver': ref.watch(enableVoiceOverProvider),
    'enableHighContrast': ref.watch(enableHighContrastProvider),
    'enableLargeText': ref.watch(enableLargeTextProvider),
  };
});