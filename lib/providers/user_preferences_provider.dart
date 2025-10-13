import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_preferences.dart';
import '../providers/silence_provider.dart';

/// Provider for user preferences (activity visibility, goals, etc.)
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier(ref);
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final Ref _ref;
  
  UserPreferencesNotifier(this._ref) : super(UserPreferences.defaults()) {
    _load();
  }
  
  Future<void> _load() async {
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      final jsonString = await storage.getString('user_preferences');
      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = UserPreferences.fromJson(json);
      }
    } catch (e) {
      // If loading fails, keep defaults
      state = UserPreferences.defaults();
    }
  }
  
  Future<void> _save() async {
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      final jsonString = jsonEncode(state.toJson());
      await storage.setString('user_preferences', jsonString);
    } catch (_) {
      // Swallow save errors to keep UI responsive
    }
  }
  
  /// Toggle whether a profile is enabled/visible
  Future<void> toggleProfile(String profileId) async {
    final enabled = List<String>.from(state.enabledProfiles);
    if (enabled.contains(profileId)) {
      // Don't allow disabling all profiles
      if (enabled.length > 1) {
        enabled.remove(profileId);
      }
    } else {
      enabled.add(profileId);
    }
    state = state.copyWith(enabledProfiles: enabled);
    await _save();
  }
  
  /// Set which profiles are enabled
  Future<void> setEnabledProfiles(List<String> profileIds) async {
    // Ensure at least one profile is enabled
    if (profileIds.isEmpty) return;
    state = state.copyWith(enabledProfiles: profileIds);
    await _save();
  }
  
  /// Update the global daily quiet goal (in minutes)
  Future<void> setGlobalDailyGoal(int minutes) async {
    if (minutes < 5 || minutes > 120) return; // Sanity check
    state = state.copyWith(globalDailyQuietGoalMinutes: minutes);
    await _save();
  }
  
  /// Remember the last duration used for a specific profile
  Future<void> setLastDuration(String profileId, int seconds) async {
    final updated = Map<String, int>.from(state.lastDurationByProfile);
    updated[profileId] = seconds;
    state = state.copyWith(lastDurationByProfile: updated);
    await _save();
  }
  
  /// Get the last used duration for a profile (or null if never set)
  int? getLastDuration(String profileId) {
    return state.lastDurationByProfile[profileId];
  }
  
  /// Enable/disable advanced mode (per-activity goals)
  Future<void> setPerActivityGoalsEnabled(bool enabled) async {
    state = state.copyWith(perActivityGoalsEnabled: enabled);
    await _save();
  }
  
  /// Set per-activity goals (for advanced mode)
  Future<void> setPerActivityGoals(Map<String, int> goals) async {
    state = state.copyWith(perActivityGoals: goals);
    await _save();
  }
}

