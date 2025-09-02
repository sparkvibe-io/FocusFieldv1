class SilenceData {
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPlayDate;
  final int totalSessions;
  final double averageScore;
  final List<SessionRecord> recentSessions;

  const SilenceData({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastPlayDate,
    this.totalSessions = 0,
    this.averageScore = 0.0,
    this.recentSessions = const [],
  });

  SilenceData copyWith({
    int? totalPoints,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastPlayDate,
    int? totalSessions,
    double? averageScore,
    List<SessionRecord>? recentSessions,
  }) {
    return SilenceData(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPlayDate: lastPlayDate ?? this.lastPlayDate,
      totalSessions: totalSessions ?? this.totalSessions,
      averageScore: averageScore ?? this.averageScore,
      recentSessions: recentSessions ?? this.recentSessions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastPlayDate': lastPlayDate?.millisecondsSinceEpoch,
      'totalSessions': totalSessions,
      'averageScore': averageScore,
      'recentSessions':
          recentSessions.map((session) => session.toJson()).toList(),
    };
  }

  factory SilenceData.fromJson(Map<String, dynamic> json) {
    return SilenceData(
      totalPoints: json['totalPoints'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastPlayDate:
          json['lastPlayDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayDate'])
              : null,
      totalSessions: json['totalSessions'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      recentSessions:
          (json['recentSessions'] as List<dynamic>?)
              ?.map(
                (sessionJson) =>
                    SessionRecord.fromJson(sessionJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class SessionRecord {
  final DateTime date;
  final int pointsEarned;
  final double averageNoise;
  final int duration; // in seconds
  final bool completed;

  const SessionRecord({
    required this.date,
    required this.pointsEarned,
    required this.averageNoise,
    required this.duration,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'pointsEarned': pointsEarned,
      'averageNoise': averageNoise,
      'duration': duration,
      'completed': completed,
    };
  }

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      pointsEarned: json['pointsEarned'] ?? 0,
      averageNoise: (json['averageNoise'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 0,
      completed: json['completed'] ?? false,
    );
  }
}
