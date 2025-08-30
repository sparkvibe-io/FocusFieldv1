import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/services/silence_detector.dart';
import 'package:silence_score/services/storage_service.dart';
import 'package:silence_score/services/real_time_noise_controller.dart';

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
final decibelThresholdProvider = Provider<double>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.when(
    data: (data) => data['decibelThreshold'] as double,
    loading: () => AppConstants.defaultDecibelThreshold,
    error: (_, __) => AppConstants.defaultDecibelThreshold,
  );
});

final sessionDurationProvider = Provider<int>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.when(
    data: (data) => data['sessionDuration'] as int,
    loading: () => AppConstants.silenceDurationSeconds,
    error: (_, __) => AppConstants.silenceDurationSeconds,
  );
});

// Sample interval and points per success are now system constants
// Use AppConstants.sampleIntervalMs and AppConstants.pointsPerMinute directly

// Settings notifier for managing settings changes
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
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
      final storageService = await _ref.read(storageServiceProvider.future);
      final currentSettings = state.value!;
      final updatedSettings = {...currentSettings, key: value};
      
      // Save individual setting
      await storageService.saveAllSettings({key: value});
      
      // Update state
      if (mounted) {
        state = AsyncValue.data(updatedSettings);
      }
      
      // Invalidate the app settings provider to refresh dependent providers
      _ref.invalidate(appSettingsProvider);
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
final silenceDetectorProvider = Provider<SilenceDetector>((ref) {
  final threshold = ref.watch(decibelThresholdProvider);
  final duration = ref.watch(sessionDurationProvider);
  return SilenceDetector(
    threshold: threshold,
    durationSeconds: duration,
  );
});

/// Aggregated real-time noise controller provider (1Hz updates)
final realTimeNoiseControllerProvider = Provider<RealTimeNoiseController>((ref) {
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
final silenceDataNotifierProvider = StateNotifierProvider<SilenceDataNotifier, AsyncValue<SilenceData>>((ref) {
  return SilenceDataNotifier(ref);
});

// Silence state provider
final silenceStateProvider = StateNotifierProvider<SilenceStateNotifier, SilenceState>((ref) {
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
      final recentSessions = [...updatedData.recentSessions, session]
          .take(10) // Keep only last 10 sessions
          .toList();
      
      final newData = updatedData.copyWith(
        totalPoints: updatedData.totalPoints + session.pointsEarned,
        totalSessions: updatedData.totalSessions + 1,
        recentSessions: recentSessions,
      );
      
      // Save data
      await storageService.saveSilenceData(newData);
      await storageService.saveLastSessionDate(session.date);
      
      if (mounted) {
        state = AsyncValue.data(newData);
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

  const SilenceState({
    this.isListening = false,
    this.progress = 0.0,
    this.success,
    this.error,
    this.canStop = false,
  });

  SilenceState copyWith({
    bool? isListening,
    double? progress,
    bool? success,
    String? error,
    bool? canStop,
  }) {
    return SilenceState(
      isListening: isListening ?? this.isListening,
      progress: progress ?? this.progress,
      success: success ?? this.success,
      error: error ?? this.error,
      canStop: canStop ?? this.canStop,
    );
  }
} 