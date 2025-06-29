class SilenceData {
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPlayDate;

  const SilenceData({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastPlayDate,
  });

  SilenceData copyWith({
    int? totalPoints,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastPlayDate,
  }) {
    return SilenceData(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPlayDate: lastPlayDate ?? this.lastPlayDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastPlayDate': lastPlayDate?.millisecondsSinceEpoch,
    };
  }

  factory SilenceData.fromJson(Map<String, dynamic> json) {
    return SilenceData(
      totalPoints: json['totalPoints'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastPlayDate: json['lastPlayDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayDate'])
          : null,
    );
  }
} 