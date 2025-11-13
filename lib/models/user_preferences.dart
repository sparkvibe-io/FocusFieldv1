/// Celebration effect types
enum CelebrationType {
  confetti,
  sparkles,
  fireworks;

  String get displayName {
    switch (this) {
      case CelebrationType.confetti:
        return 'Confetti';
      case CelebrationType.sparkles:
        return 'Sparkles';
      case CelebrationType.fireworks:
        return 'Fireworks';
    }
  }

  String get emoji {
    switch (this) {
      case CelebrationType.confetti:
        return '🎊';
      case CelebrationType.sparkles:
        return '✨';
      case CelebrationType.fireworks:
        return '🎆';
    }
  }
}

/// Celebration sound types
enum CelebrationSoundType {
  chime,
  applause,
  musicNote;

  String get displayName {
    switch (this) {
      case CelebrationSoundType.chime:
        return 'Chime';
      case CelebrationSoundType.applause:
        return 'Applause';
      case CelebrationSoundType.musicNote:
        return 'Note';
    }
  }
}

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

  // Focus Mode: minimal distraction during sessions
  final bool focusModeEnabled;

  // Wake Lock: keep screen on during sessions
  final bool keepScreenOn;

  // Celebration Effects: show confetti on successful sessions (legacy, now uses enableCelebrationEffects)
  final bool enableCelebrationConfetti;

  // New celebration settings
  final bool enableCelebrationEffects; // Master toggle for all celebrations
  final double celebrationDuration; // 1.0-5.0 seconds, default 1.5
  final CelebrationType celebrationType; // confetti, sparkles, fireworks
  final bool celebrationSound; // Enable/disable sound
  final CelebrationSoundType celebrationSoundType; // chime, applause, musicNote

  // Starter session duration in minutes (for first-time users)
  // null = user has manually changed duration, use globalDailyQuietGoalMinutes
  // non-null = use this duration until user manually changes it
  final int? starterSessionMinutes;

  const UserPreferences({
    required this.enabledProfiles,
    required this.globalDailyQuietGoalMinutes,
    required this.lastDurationByProfile,
    this.perActivityGoalsEnabled = false,
    this.perActivityGoals,
    this.focusModeEnabled = false,
    this.keepScreenOn = true,
    this.enableCelebrationConfetti = true, // Legacy, kept for backward compatibility
    this.enableCelebrationEffects = true,
    this.celebrationDuration = 1.5,
    this.celebrationType = CelebrationType.confetti,
    this.celebrationSound = true,
    this.celebrationSoundType = CelebrationSoundType.chime,
    this.starterSessionMinutes,
  });
  
  // Default preferences (core 3 activities enabled, 10 min goal per activity)
  // Default celebration: 1.5s confetti with chime sound (kid-friendly)
  factory UserPreferences.defaults() => const UserPreferences(
    enabledProfiles: ['study', 'reading', 'meditation'],
    globalDailyQuietGoalMinutes: 10,
    lastDurationByProfile: {},
    perActivityGoalsEnabled: false,
    perActivityGoals: null,
    focusModeEnabled: false,
    keepScreenOn: true,
    enableCelebrationConfetti: true,
    enableCelebrationEffects: true,
    celebrationDuration: 1.5,
    celebrationType: CelebrationType.confetti,
    celebrationSound: true,
    celebrationSoundType: CelebrationSoundType.chime,
    starterSessionMinutes: null,
  );
  
  UserPreferences copyWith({
    List<String>? enabledProfiles,
    int? globalDailyQuietGoalMinutes,
    Map<String, int>? lastDurationByProfile,
    bool? perActivityGoalsEnabled,
    Map<String, int>? perActivityGoals,
    bool? focusModeEnabled,
    bool? keepScreenOn,
    bool? enableCelebrationConfetti,
    bool? enableCelebrationEffects,
    double? celebrationDuration,
    CelebrationType? celebrationType,
    bool? celebrationSound,
    CelebrationSoundType? celebrationSoundType,
    int? starterSessionMinutes,
  }) => UserPreferences(
    enabledProfiles: enabledProfiles ?? this.enabledProfiles,
    globalDailyQuietGoalMinutes: globalDailyQuietGoalMinutes ?? this.globalDailyQuietGoalMinutes,
    lastDurationByProfile: lastDurationByProfile ?? this.lastDurationByProfile,
    perActivityGoalsEnabled: perActivityGoalsEnabled ?? this.perActivityGoalsEnabled,
    perActivityGoals: perActivityGoals ?? this.perActivityGoals,
    focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
    keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    enableCelebrationConfetti: enableCelebrationConfetti ?? this.enableCelebrationConfetti,
    enableCelebrationEffects: enableCelebrationEffects ?? this.enableCelebrationEffects,
    celebrationDuration: celebrationDuration ?? this.celebrationDuration,
    celebrationType: celebrationType ?? this.celebrationType,
    celebrationSound: celebrationSound ?? this.celebrationSound,
    celebrationSoundType: celebrationSoundType ?? this.celebrationSoundType,
    starterSessionMinutes: starterSessionMinutes ?? this.starterSessionMinutes,
  );
  
  Map<String, dynamic> toJson() => {
    'enabledProfiles': enabledProfiles,
    'globalDailyQuietGoalMinutes': globalDailyQuietGoalMinutes,
    'lastDurationByProfile': lastDurationByProfile,
    'perActivityGoalsEnabled': perActivityGoalsEnabled,
    'perActivityGoals': perActivityGoals,
    'focusModeEnabled': focusModeEnabled,
    'keepScreenOn': keepScreenOn,
    'enableCelebrationConfetti': enableCelebrationConfetti,
    'enableCelebrationEffects': enableCelebrationEffects,
    'celebrationDuration': celebrationDuration,
    'celebrationType': celebrationType.name,
    'celebrationSound': celebrationSound,
    'celebrationSoundType': celebrationSoundType.name,
    'starterSessionMinutes': starterSessionMinutes,
  };
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final profiles = (json['enabledProfiles'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? ['study', 'reading', 'meditation'];

    // Parse celebration type from string
    CelebrationType celebrationType = CelebrationType.confetti;
    final celebrationTypeStr = json['celebrationType'] as String?;
    if (celebrationTypeStr != null) {
      try {
        celebrationType = CelebrationType.values.byName(celebrationTypeStr);
      } catch (_) {
        celebrationType = CelebrationType.confetti;
      }
    }

    // Parse sound type from string
    CelebrationSoundType soundType = CelebrationSoundType.chime;
    final soundTypeStr = json['celebrationSoundType'] as String?;
    if (soundTypeStr != null) {
      try {
        soundType = CelebrationSoundType.values.byName(soundTypeStr);
      } catch (_) {
        soundType = CelebrationSoundType.chime;
      }
    }

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
      focusModeEnabled: json['focusModeEnabled'] as bool? ?? false,
      keepScreenOn: json['keepScreenOn'] as bool? ?? true,
      enableCelebrationConfetti: json['enableCelebrationConfetti'] as bool? ?? true,
      enableCelebrationEffects: json['enableCelebrationEffects'] as bool? ?? true,
      celebrationDuration: (json['celebrationDuration'] as num?)?.toDouble() ?? 1.5,
      celebrationType: celebrationType,
      celebrationSound: json['celebrationSound'] as bool? ?? true,
      celebrationSoundType: soundType,
      starterSessionMinutes: json['starterSessionMinutes'] as int?,
    );
  }
}

