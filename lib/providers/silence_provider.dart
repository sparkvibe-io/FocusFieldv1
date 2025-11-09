import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/services/silence_detector.dart';
import 'package:focus_field/services/storage_service.dart';
import 'package:focus_field/services/real_time_noise_controller.dart';
import 'package:focus_field/utils/debug_log.dart';

// Storage service provider
final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  final storageService = await StorageService.getInstance();
  await storageService.initializeApp();
  return storageService;
});

// App settings provider - loads all settings at once
final appSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final storageService = await ref.watch(storageServiceProvider.future);
  return await storageService.loadAllSettings();
});

// Individual setting providers that depend on the app settings
// Active decibel threshold provider - used for quick threshold selector temporary overrides
final activeDecibelThresholdProvider = StateProvider<double>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.when(
    data: (data) => data['decibelThreshold'] as double,
    loading: () => AppConstants.defaultDecibelThreshold,
    error: (_, __) => AppConstants.defaultDecibelThreshold,
  );
});

// Decibel threshold provider - now uses active threshold for actual detection
final decibelThresholdProvider = Provider<double>((ref) {
  return ref.watch(activeDecibelThresholdProvider);
});

// Active session duration provider - used for quick duration selector temporary overrides
final activeSessionDurationProvider = StateProvider<int>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.when(
    data: (data) => data['sessionDuration'] as int,
    loading: () => AppConstants.silenceDurationSeconds,
    error: (_, __) => AppConstants.silenceDurationSeconds,
  );
});

// Session duration provider - now uses active duration for actual sessions
final sessionDurationProvider = Provider<int>((ref) {
  return ref.watch(activeSessionDurationProvider);
});

// Sample interval and points per success are now system constants
// Use AppConstants.sampleIntervalMs and AppConstants.pointsPerMinute directly

// Settings notifier for managing settings changes
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<Map<String, dynamic>>>((
      ref,
    ) {
      return SettingsNotifier(ref);
    });

class SettingsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      final settings = await storageService.loadAllSettings();
      if (mounted) {
        state = AsyncValue.data(settings);
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    if (!state.hasValue) return;

    try {
      if (!kReleaseMode) {
        DebugLog.d('⚙️ [SettingsNotifier] updateSetting called: $key = $value');
      }

      final storageService = await _ref.read(storageServiceProvider.future);
      final currentSettings = state.value!;
      final updatedSettings = {...currentSettings, key: value};

      // Save individual setting
      await storageService.saveAllSettings({key: value});

      // Update state
      if (mounted) {
        state = AsyncValue.data(updatedSettings);
      }

      if (!kReleaseMode) {
        DebugLog.d(
          '⚙️ [SettingsNotifier] Setting saved, invalidating appSettingsProvider...',
        );
      }

      // Invalidate the app settings provider to refresh dependent providers
      _ref.invalidate(appSettingsProvider);

      if (!kReleaseMode) {
        DebugLog.d('⚙️ [SettingsNotifier] appSettingsProvider invalidated');
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> resetSettings() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      await storageService.resetAllData();
      await _loadSettings();
      _ref.invalidate(appSettingsProvider);
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

// Silence detector provider
// IMPORTANT: This provider should NOT dispose detectors on threshold changes
// because ambient monitoring may be running. Instead, we create new instances
// and let Dart GC clean up old ones when they're no longer referenced.
final silenceDetectorProvider = Provider<SilenceDetector>((ref) {
  final threshold = ref.watch(decibelThresholdProvider);
  final duration = ref.watch(sessionDurationProvider);

  if (!kDebugMode) {
    // Production: create new detector (old ones will be GC'd)
    return SilenceDetector(threshold: threshold, durationSeconds: duration);
  }

  // Debug mode: add logging
  DebugLog.d(
    '🔧 [Provider] Creating new SilenceDetector (threshold: $threshold, duration: ${duration}s)',
  );
  final detector = SilenceDetector(
    threshold: threshold,
    durationSeconds: duration,
  );
  DebugLog.d('🔧 [Provider] Detector created with hash: ${detector.hashCode}');

  // DO NOT dispose detector here - ambient monitoring may be using it
  // The detector will be garbage collected when no longer referenced

  return detector;
});

/// Aggregated real-time noise controller provider (1Hz updates)
final realTimeNoiseControllerProvider = Provider<RealTimeNoiseController>((
  ref,
) {
  final detector = ref.watch(silenceDetectorProvider);
  final controller = RealTimeNoiseController(detector);
  ref.onDispose(controller.dispose);
  return controller;
});

// Silence data provider with async initialization
final silenceDataProvider = FutureProvider<SilenceData>((ref) async {
  final storageService = await ref.watch(storageServiceProvider.future);
  return await storageService.loadSilenceData();
});

// Silence data notifier provider
final silenceDataNotifierProvider =
    StateNotifierProvider<SilenceDataNotifier, AsyncValue<SilenceData>>((ref) {
      return SilenceDataNotifier(ref);
    });

// Silence state provider
final silenceStateProvider =
    StateNotifierProvider<SilenceStateNotifier, SilenceState>((ref) {
      return SilenceStateNotifier();
    });

// Silence state notifier
class SilenceStateNotifier extends StateNotifier<SilenceState> {
  SilenceStateNotifier() : super(const SilenceState());

  void setListening(bool listening) {
    state = state.copyWith(isListening: listening, canStop: listening);
  }

  void setProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void setSuccess(bool? success) {
    state = state.copyWith(success: success);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setCanStop(bool canStop) {
    state = state.copyWith(canStop: canStop);
  }

  void setPaused(bool paused) {
    state = state.copyWith(isPaused: paused);
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void reset() {
    state = const SilenceState();
  }

  void stopSession() {
    state = state.copyWith(
      isListening: false,
      canStop: false,
      progress: 0.0,
      success: null,
      error: null,
      isPaused: false,
    );
  }
}

// Silence data notifier
class SilenceDataNotifier extends StateNotifier<AsyncValue<SilenceData>> {
  final Ref _ref;

  SilenceDataNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      final data = await storageService.loadSilenceData();
      if (mounted) {
        state = AsyncValue.data(data);
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> addSessionRecord(SessionRecord session) async {
    if (!state.hasValue) return;

    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      final currentData = state.value!;

      // Update data with new session
      final updatedData = await storageService.updateStreak(currentData);
      final recentSessions =
          [...updatedData.recentSessions, session]
              .take(100) // Keep last 100 sessions for heatmap (12+ weeks of data)
              .toList();

      final newData = updatedData.copyWith(
        totalPoints: updatedData.totalPoints + session.pointsEarned,
        totalSessions: updatedData.totalSessions + 1,
        recentSessions: recentSessions,
      );

      // Debug logging
      debugPrint('💾 Saving session - Date: ${session.date}, Duration: ${session.duration}s, Minutes: ${session.duration ~/ 60}');
      debugPrint('💾 Total sessions in storage: ${recentSessions.length}');

      // Save data
      await storageService.saveSilenceData(newData);
      await storageService.saveLastSessionDate(session.date);

      if (mounted) {
        state = AsyncValue.data(newData);
        debugPrint('💾 Session saved and state updated');
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> addPoint() async {
    if (!state.hasValue) return;

    try {
      final storageService = await _ref.read(storageServiceProvider.future);

      // Update streak first
      final updatedData = await storageService.updateStreak(state.value!);

      // Add points using the new system constant
      final newData = updatedData.copyWith(
        totalPoints: updatedData.totalPoints + AppConstants.pointsPerMinute,
      );

      // Save and update state
      await storageService.saveSilenceData(newData);
      if (mounted) {
        state = AsyncValue.data(newData);
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> resetData() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      await storageService.resetAllData();
      await _loadData();
      _ref.invalidate(appSettingsProvider);
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

// Silence state model
class SilenceState {
  final bool isListening;
  final double progress;
  final bool? success;
  final String? error;
  final bool canStop; // New field to track if session can be stopped
  final bool? _isPaused; // Internal nullable field for backward compatibility

  const SilenceState({
    this.isListening = false,
    this.progress = 0.0,
    this.success,
    this.error,
    this.canStop = false,
    bool? isPaused,
  }) : _isPaused = isPaused;

  // Safe getter that defaults to false if null
  bool get isPaused => _isPaused ?? false;

  SilenceState copyWith({
    bool? isListening,
    double? progress,
    bool? success,
    String? error,
    bool? canStop,
    bool? isPaused,
  }) {
    return SilenceState(
      isListening: isListening ?? this.isListening,
      progress: progress ?? this.progress,
      success: success ?? this.success,
      error: error ?? this.error,
      canStop: canStop ?? this.canStop,
      isPaused:
          isPaused ??
          this.isPaused, // Use the getter which safely defaults to false
    );
  }
}
