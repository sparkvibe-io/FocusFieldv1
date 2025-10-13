import 'package:focus_field/models/silence_data.dart';

/// Weekly recap data model containing weekly statistics and insights
class WeeklyRecap {
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final int totalSessions;
  final int totalPoints;
  final int totalMinutes;
  final int streakAtStart;
  final int streakAtEnd;
  final double averageSuccessRate;
  final String topActivity;
  final int topActivityCount;
  final List<String> achievements;
  final String personalizedMessage;

  const WeeklyRecap({
    required this.weekStartDate,
    required this.weekEndDate,
    required this.totalSessions,
    required this.totalPoints,
    required this.totalMinutes,
    required this.streakAtStart,
    required this.streakAtEnd,
    required this.averageSuccessRate,
    required this.topActivity,
    required this.topActivityCount,
    required this.achievements,
    required this.personalizedMessage,
  });

  /// Calculate weekly recap from session data
  factory WeeklyRecap.fromSessions({
    required List<SessionRecord> sessions,
    required DateTime weekStart,
    required int initialStreak,
    required int finalStreak,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Filter sessions for this week
    final weekSessions = sessions.where((s) =>
        s.date.isAfter(weekStart) && s.date.isBefore(weekEnd)).toList();

    if (weekSessions.isEmpty) {
      return WeeklyRecap(
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        totalSessions: 0,
        totalPoints: 0,
        totalMinutes: 0,
        streakAtStart: initialStreak,
        streakAtEnd: finalStreak,
        averageSuccessRate: 0.0,
        topActivity: 'None',
        topActivityCount: 0,
        achievements: [],
        personalizedMessage: 'Start your focus journey this week!',
      );
    }

    // Calculate statistics
    final totalSessions = weekSessions.length;
    final totalPoints = weekSessions.fold<int>(0, (sum, s) => sum + s.pointsEarned);
    final totalMinutes = weekSessions.fold<int>(
        0, (sum, s) => sum + (s.duration ~/ 60));
    final successfulSessions = weekSessions.where((s) => s.completed).length;
    final averageSuccessRate = successfulSessions / totalSessions;

    // Find top activity
    final activityCounts = <String, int>{};
    for (final session in weekSessions) {
      final activity = session.activity ?? 'Silence';
      activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
    }
    final topEntry = activityCounts.entries.reduce(
        (a, b) => a.value > b.value ? a : b);
    final topActivity = topEntry.key;
    final topActivityCount = topEntry.value;

    // Generate achievements
    final achievements = <String>[];
    if (totalSessions >= 21) achievements.add('🏆 Daily Dedication');
    if (totalSessions >= 14) achievements.add('⭐ Consistency Champion');
    if (totalSessions >= 7) achievements.add('📅 Week Complete');
    if (totalPoints >= 500) achievements.add('💯 Points Master');
    if (totalMinutes >= 300) achievements.add('⏱️ 5+ Hours');
    if (averageSuccessRate >= 0.9) achievements.add('🎯 90% Success Rate');
    if (finalStreak >= 7) achievements.add('🔥 Week-Long Streak');

    // Generate personalized message
    final message = _generateMessage(
      totalSessions: totalSessions,
      totalPoints: totalPoints,
      streakGrowth: finalStreak - initialStreak,
      successRate: averageSuccessRate,
    );

    return WeeklyRecap(
      weekStartDate: weekStart,
      weekEndDate: weekEnd,
      totalSessions: totalSessions,
      totalPoints: totalPoints,
      totalMinutes: totalMinutes,
      streakAtStart: initialStreak,
      streakAtEnd: finalStreak,
      averageSuccessRate: averageSuccessRate,
      topActivity: topActivity,
      topActivityCount: topActivityCount,
      achievements: achievements,
      personalizedMessage: message,
    );
  }

  static String _generateMessage({
    required int totalSessions,
    required int totalPoints,
    required int streakGrowth,
    required double successRate,
  }) {
    if (totalSessions == 0) {
      return 'Ready to start your focus journey?';
    } else if (totalSessions >= 21) {
      return 'Outstanding! You practiced every day this week. 🌟';
    } else if (totalSessions >= 14) {
      return 'Excellent consistency! You\'re building a strong habit. 💪';
    } else if (streakGrowth >= 7) {
      return 'You added $streakGrowth days to your streak! Keep it going! 🔥';
    } else if (successRate >= 0.9) {
      return 'Impressive ${(successRate * 100).round()}% success rate! 🎯';
    } else if (totalPoints >= 300) {
      return 'Great week! You earned $totalPoints points. ⭐';
    } else if (totalSessions >= 5) {
      return 'Nice progress! You completed $totalSessions sessions. 👏';
    } else {
      return 'Every session counts! Keep building momentum. 🚀';
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'weekStartDate': weekStartDate.millisecondsSinceEpoch,
        'weekEndDate': weekEndDate.millisecondsSinceEpoch,
        'totalSessions': totalSessions,
        'totalPoints': totalPoints,
        'totalMinutes': totalMinutes,
        'streakAtStart': streakAtStart,
        'streakAtEnd': streakAtEnd,
        'averageSuccessRate': averageSuccessRate,
        'topActivity': topActivity,
        'topActivityCount': topActivityCount,
        'achievements': achievements,
        'personalizedMessage': personalizedMessage,
      };

  /// Create from JSON
  factory WeeklyRecap.fromJson(Map<String, dynamic> json) => WeeklyRecap(
        weekStartDate: DateTime.fromMillisecondsSinceEpoch(
            json['weekStartDate'] as int),
        weekEndDate:
            DateTime.fromMillisecondsSinceEpoch(json['weekEndDate'] as int),
        totalSessions: json['totalSessions'] as int,
        totalPoints: json['totalPoints'] as int,
        totalMinutes: json['totalMinutes'] as int,
        streakAtStart: json['streakAtStart'] as int,
        streakAtEnd: json['streakAtEnd'] as int,
        averageSuccessRate: (json['averageSuccessRate'] as num).toDouble(),
        topActivity: json['topActivity'] as String,
        topActivityCount: json['topActivityCount'] as int,
        achievements: (json['achievements'] as List).cast<String>(),
        personalizedMessage: json['personalizedMessage'] as String,
      );
}
