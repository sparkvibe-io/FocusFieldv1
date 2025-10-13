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

  UserPreferencesNotifier(this._ref) : super(UserPreferences.defaults()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      final prefs = await storageService.loadUserPreferences();
      state = prefs;
    } catch (_) {
      state = UserPreferences.defaults();
    }
  }

  Future<void> _persist(UserPreferences updated) async {
    state = updated;
    try {
      final storageService = await _ref.read(storageServiceProvider.future);
      await storageService.saveUserPreferences(updated);
    } catch (_) {}
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

  Future<void> updateUserPreferences(UserPreferences newPrefs) async {
    await _persist(newPrefs);
  }
}
