// No external imports needed

enum MotionAssistMode { off, lenient, strict }

class ActivityProfile {
  final String id;
  final String name;
  final String icon; // asset or material name
  final bool usesNoise;
  final int? thresholdDb; // if usesNoise
  final MotionAssistMode motionAssist;

  const ActivityProfile({
    required this.id,
    required this.name,
    required this.icon,
    required this.usesNoise,
    this.thresholdDb,
    this.motionAssist = MotionAssistMode.off,
  });

  ActivityProfile copyWith({
    String? id,
    String? name,
    String? icon,
    bool? usesNoise,
    int? thresholdDb,
    MotionAssistMode? motionAssist,
  }) => ActivityProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        usesNoise: usesNoise ?? this.usesNoise,
        thresholdDb: thresholdDb ?? this.thresholdDb,
        motionAssist: motionAssist ?? this.motionAssist,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'usesNoise': usesNoise,
        'thresholdDb': thresholdDb,
    'motionAssist': motionAssist.name,
      };

  factory ActivityProfile.fromJson(Map<String, dynamic> json) => ActivityProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        usesNoise: json['usesNoise'] as bool? ?? true,
        thresholdDb: json['thresholdDb'] as int?,
        motionAssist: _motionFrom(json['motionAssist'] as String?),
      );

  static MotionAssistMode _motionFrom(String? v) {
    switch (v) {
      case 'lenient':
        return MotionAssistMode.lenient;
      case 'strict':
        return MotionAssistMode.strict;
      default:
        return MotionAssistMode.off;
    }
  }
}

class AmbientSession {
  final String id;
  final String profileId;
  final int plannedSeconds;
  final int actualSeconds;
  final DateTime startedAt;
  final DateTime endedAt;
  final int quietSeconds;
  final int violations;
  final double? ambientScore; // null for active profiles
  final int? motionSamples;
  final String? notes;
  final bool exportedToCalendar;
  final bool syncedToHealth;

  const AmbientSession({
    required this.id,
    required this.profileId,
    required this.plannedSeconds,
    required this.actualSeconds,
    required this.startedAt,
    required this.endedAt,
    required this.quietSeconds,
    required this.violations,
    required this.ambientScore,
    this.motionSamples,
    this.notes,
    this.exportedToCalendar = false,
    this.syncedToHealth = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'plannedSeconds': plannedSeconds,
        'actualSeconds': actualSeconds,
        'startedAt': startedAt.millisecondsSinceEpoch,
        'endedAt': endedAt.millisecondsSinceEpoch,
        'quietSeconds': quietSeconds,
        'violations': violations,
        'ambientScore': ambientScore,
        'motionSamples': motionSamples,
        'notes': notes,
        'exportedToCalendar': exportedToCalendar,
        'syncedToHealth': syncedToHealth,
      };

  factory AmbientSession.fromJson(Map<String, dynamic> json) => AmbientSession(
        id: json['id'] as String,
        profileId: json['profileId'] as String,
        plannedSeconds: json['plannedSeconds'] as int? ?? 0,
        actualSeconds: json['actualSeconds'] as int? ?? 0,
        startedAt: DateTime.fromMillisecondsSinceEpoch(json['startedAt'] as int),
        endedAt: DateTime.fromMillisecondsSinceEpoch(json['endedAt'] as int),
        quietSeconds: json['quietSeconds'] as int? ?? 0,
        violations: json['violations'] as int? ?? 0,
        ambientScore: (json['ambientScore'] as num?)?.toDouble(),
        motionSamples: json['motionSamples'] as int?,
        notes: json['notes'] as String?,
        exportedToCalendar: json['exportedToCalendar'] as bool? ?? false,
        syncedToHealth: json['syncedToHealth'] as bool? ?? false,
      );
}

class QuestState {
  final String cycleId; // yyyy-mm
  final int dayIndex; // 1..30
  final int goalQuietMinutes; // default 20
  final double requiredScore; // default 0.7
  final int progressQuietMinutes; // sum of all per-activity minutes
  final int streakCount;
  final int freezeTokens;
  final DateTime lastUpdatedAt;
  final bool missedYesterday; // for permissive 2-Day Rule
  
  // Per-activity minute tracking
  final int studyMinutes;
  final int readingMinutes;
  final int meditationMinutes;
  final int otherMinutes;

  const QuestState({
    required this.cycleId,
    required this.dayIndex,
    required this.goalQuietMinutes,
    required this.requiredScore,
    required this.progressQuietMinutes,
    required this.streakCount,
    required this.freezeTokens,
    required this.lastUpdatedAt,
    this.missedYesterday = false,
    this.studyMinutes = 0,
    this.readingMinutes = 0,
    this.meditationMinutes = 0,
    this.otherMinutes = 0,
  });

  QuestState copyWith({
    String? cycleId,
    int? dayIndex,
    int? goalQuietMinutes,
    double? requiredScore,
    int? progressQuietMinutes,
    int? streakCount,
    int? freezeTokens,
    DateTime? lastUpdatedAt,
    bool? missedYesterday,
    int? studyMinutes,
    int? readingMinutes,
    int? meditationMinutes,
    int? otherMinutes,
  }) => QuestState(
        cycleId: cycleId ?? this.cycleId,
        dayIndex: dayIndex ?? this.dayIndex,
        goalQuietMinutes: goalQuietMinutes ?? this.goalQuietMinutes,
        requiredScore: requiredScore ?? this.requiredScore,
        progressQuietMinutes: progressQuietMinutes ?? this.progressQuietMinutes,
        streakCount: streakCount ?? this.streakCount,
        freezeTokens: freezeTokens ?? this.freezeTokens,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        missedYesterday: missedYesterday ?? this.missedYesterday,
        studyMinutes: studyMinutes ?? this.studyMinutes,
        readingMinutes: readingMinutes ?? this.readingMinutes,
        meditationMinutes: meditationMinutes ?? this.meditationMinutes,
        otherMinutes: otherMinutes ?? this.otherMinutes,
      );

  Map<String, dynamic> toJson() => {
        'cycleId': cycleId,
        'dayIndex': dayIndex,
        'goalQuietMinutes': goalQuietMinutes,
        'requiredScore': requiredScore,
        'progressQuietMinutes': progressQuietMinutes,
        'streakCount': streakCount,
        'freezeTokens': freezeTokens,
        'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
        'missedYesterday': missedYesterday,
        'studyMinutes': studyMinutes,
        'readingMinutes': readingMinutes,
        'meditationMinutes': meditationMinutes,
        'otherMinutes': otherMinutes,
      };

  factory QuestState.fromJson(Map<String, dynamic> json) => QuestState(
        cycleId: json['cycleId'] as String,
        dayIndex: json['dayIndex'] as int? ?? 1,
        goalQuietMinutes: json['goalQuietMinutes'] as int? ?? 20,
        requiredScore: (json['requiredScore'] as num?)?.toDouble() ?? 0.7,
        progressQuietMinutes: json['progressQuietMinutes'] as int? ?? 0,
        streakCount: json['streakCount'] as int? ?? 0,
        freezeTokens: json['freezeTokens'] as int? ?? 1,
        lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(
          json['lastUpdatedAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        ),
        missedYesterday: json['missedYesterday'] as bool? ?? false,
        studyMinutes: json['studyMinutes'] as int? ?? 0,
        readingMinutes: json['readingMinutes'] as int? ?? 0,
        meditationMinutes: json['meditationMinutes'] as int? ?? 0,
        otherMinutes: json['otherMinutes'] as int? ?? 0,
      );
}
