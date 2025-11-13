import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_preferences.dart';
import '../providers/silence_provider.dart';

/// Provider for user preferences (activity visibility, goals, etc.)
final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
      return UserPreferencesNotifier(ref);
    });

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final Ref _ref;
  bool _hasBeenExplicitlySet = false;  // Track if state was manually updated

  UserPreferencesNotifier(this._ref) : super(UserPreferences.defaults()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      final prefs = await storageService.loadUserPreferences();

      // Only update state if it hasn't been explicitly set (avoid race condition)
      if (!_hasBeenExplicitlySet) {
        state = prefs;
        if (kDebugMode) {
          debugPrint('🎓 UserPrefs: Loaded from storage: ${prefs.enabledProfiles}');
        }
      } else {
        if (kDebugMode) {
          debugPrint('🎓 UserPrefs: Skipping load (state already set): ${state.enabledProfiles}');
        }
      }
    } catch (e) {
      if (!_hasBeenExplicitlySet) {
        state = UserPreferences.defaults();
      }
      if (kDebugMode) {
        debugPrint('🎓 UserPrefs: Load failed, using ${_hasBeenExplicitlySet ? 'current state' : 'defaults'}: ${state.enabledProfiles}');
        debugPrint('🎓 UserPrefs: Load error: $e');
      }
    }
  }

  Future<void> _persist(UserPreferences updated) async {
    _hasBeenExplicitlySet = true;  // Mark that state has been explicitly updated
    state = updated;
    if (kDebugMode) {
      debugPrint('🎓 UserPrefs: State updated to: ${updated.enabledProfiles}');
    }
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      await storageService.saveUserPreferences(updated);
      if (kDebugMode) {
        debugPrint('🎓 UserPrefs: Saved to storage: ${updated.enabledProfiles}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🎓 UserPrefs: Save failed: $e');
      }
    }
  }

  Future<void> setEnabledProfiles(List<String> enabledProfiles) async {
    final updated = state.copyWith(enabledProfiles: enabledProfiles);
    await _persist(updated);
  }

  Future<void> setGlobalDailyGoal(int minutes) async {
    final sanitizedMinutes = minutes.clamp(0, 1440).toInt();
    final updated = state.copyWith(
      globalDailyQuietGoalMinutes: sanitizedMinutes,
    );
    await _persist(updated);
  }

  Future<void> setPerActivityGoalsEnabled(bool enabled) async {
    final updated = state.copyWith(
      perActivityGoalsEnabled: enabled,
      perActivityGoals: enabled ? state.perActivityGoals : null,
    );
    await _persist(updated);
  }

  Future<void> setPerActivityGoals(Map<String, int>? goals) async {
    final sanitized = goals?.map(
      (key, value) => MapEntry(key, value.clamp(0, 1440).toInt()),
    );
    final updated = state.copyWith(perActivityGoals: sanitized);
    await _persist(updated);
  }

  Future<void> setLastDurationForProfile(String profileId, int seconds) async {
    final updatedDurations = Map<String, int>.from(state.lastDurationByProfile)
      ..[profileId] = seconds.clamp(0, 24 * 60 * 60).toInt();
    final updated = state.copyWith(lastDurationByProfile: updatedDurations);
    await _persist(updated);
  }

  Future<void> updateFocusModeEnabled(bool enabled) async {
    final updated = state.copyWith(focusModeEnabled: enabled);
    await _persist(updated);
  }

  Future<void> updateKeepScreenOn(bool enabled) async {
    final updated = state.copyWith(keepScreenOn: enabled);
    await _persist(updated);
  }

  Future<void> updateCelebrationConfettiEnabled(bool enabled) async {
    final updated = state.copyWith(enableCelebrationConfetti: enabled);
    await _persist(updated);
  }

  // New celebration settings methods
  Future<void> updateCelebrationEffectsEnabled(bool enabled) async {
    final updated = state.copyWith(enableCelebrationEffects: enabled);
    await _persist(updated);
  }

  Future<void> updateCelebrationDuration(double duration) async {
    final updated = state.copyWith(celebrationDuration: duration);
    await _persist(updated);
  }

  Future<void> updateCelebrationType(CelebrationType type) async {
    final updated = state.copyWith(celebrationType: type);
    await _persist(updated);
  }

  Future<void> updateCelebrationSound(bool enabled) async {
    final updated = state.copyWith(celebrationSound: enabled);
    await _persist(updated);
  }

  Future<void> updateCelebrationSoundType(CelebrationSoundType type) async {
    final updated = state.copyWith(celebrationSoundType: type);
    await _persist(updated);
  }

  Future<void> updateUserPreferences(UserPreferences newPrefs) async {
    await _persist(newPrefs);
  }
}
