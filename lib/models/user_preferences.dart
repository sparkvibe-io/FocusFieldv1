/// User preferences for activity tracking and goals
class UserPreferences {
  // Which activity profiles are enabled/visible
  final List<String> enabledProfiles;
  
  // Global daily quiet goal in minutes (default: 20)
  final int globalDailyQuietGoalMinutes;
  
  // Last selected duration per profile (in seconds)
  final Map<String, int> lastDurationByProfile;
  
  // Advanced mode: per-activity goals (optional)
  final bool perActivityGoalsEnabled;
  final Map<String, int>? perActivityGoals; // profileId -> minutes
  
  const UserPreferences({
    required this.enabledProfiles,
    required this.globalDailyQuietGoalMinutes,
    required this.lastDurationByProfile,
    this.perActivityGoalsEnabled = false,
    this.perActivityGoals,
  });
  
  // Default preferences (core 3 activities enabled, 10 min goal per activity)
  factory UserPreferences.defaults() => const UserPreferences(
    enabledProfiles: ['study', 'reading', 'meditation'],
    globalDailyQuietGoalMinutes: 10,
    lastDurationByProfile: {},
    perActivityGoalsEnabled: false,
    perActivityGoals: null,
  );
  
  UserPreferences copyWith({
    List<String>? enabledProfiles,
    int? globalDailyQuietGoalMinutes,
    Map<String, int>? lastDurationByProfile,
    bool? perActivityGoalsEnabled,
    Map<String, int>? perActivityGoals,
  }) => UserPreferences(
    enabledProfiles: enabledProfiles ?? this.enabledProfiles,
    globalDailyQuietGoalMinutes: globalDailyQuietGoalMinutes ?? this.globalDailyQuietGoalMinutes,
    lastDurationByProfile: lastDurationByProfile ?? this.lastDurationByProfile,
    perActivityGoalsEnabled: perActivityGoalsEnabled ?? this.perActivityGoalsEnabled,
    perActivityGoals: perActivityGoals ?? this.perActivityGoals,
  );
  
  Map<String, dynamic> toJson() => {
    'enabledProfiles': enabledProfiles,
    'globalDailyQuietGoalMinutes': globalDailyQuietGoalMinutes,
    'lastDurationByProfile': lastDurationByProfile,
    'perActivityGoalsEnabled': perActivityGoalsEnabled,
    'perActivityGoals': perActivityGoals,
  };
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final profiles = (json['enabledProfiles'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? ['study', 'reading', 'meditation'];

    return UserPreferences(
      enabledProfiles: profiles,
      globalDailyQuietGoalMinutes: json['globalDailyQuietGoalMinutes'] as int? ?? 10,
      lastDurationByProfile: (json['lastDurationByProfile'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)) ?? {},
      perActivityGoalsEnabled: json['perActivityGoalsEnabled'] as bool? ?? false,
      perActivityGoals: json['perActivityGoals'] != null
          ? (json['perActivityGoals'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, v as int))
          : null,
    );
  }
}

