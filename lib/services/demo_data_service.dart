import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/utils/debug_log.dart';

/// Service for generating realistic demo data for App Store screenshots
/// Only active when DEMO_MODE=true is passed via --dart-define
class DemoDataService {
  static const bool isDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

  /// Generate a complete demo dataset showcasing app features
  static SilenceData generateDemoData() {
    DebugLog.d('[DemoData] Generating screenshot-ready demo data');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Generate realistic sessions spanning 14 days
    final sessions = _generateDemoSessions(today);

    // Calculate realistic statistics
    final totalPoints = sessions.fold<int>(0, (sum, s) => sum + s.pointsEarned);
    final avgScore = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(0, (sum, s) => sum + (s.ambientScore ?? 0.85)) / sessions.length;

    return SilenceData(
      totalPoints: totalPoints,
      totalSessions: sessions.length,
      averageScore: avgScore,
      currentStreak: 12, // Impressive but realistic
      bestStreak: 18, // Show historical achievement
      recentSessions: sessions,
      lastPlayDate: sessions.isNotEmpty ? sessions.first.date : null,
    );
  }

  /// Generate demo quest state with realistic progress
  static Map<String, dynamic> generateDemoQuestState() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'dailyGoalMinutes': 30, // Achievable goal
      'todayQuietMinutes': 24, // 80% progress - perfect for screenshots
      'currentStreak': 12,
      'longestStreak': 18,
      'monthlyFreezeTokensUsed': 0, // Shows discipline
      'lastCompletionDate': today.subtract(const Duration(days: 1)).toIso8601String(),
      'lastFreezeDate': null,
      'consecutiveMissedDays': 0,
      'lifetimeQuietMinutes': 848, // Updated to match today's 24 min
      'lifetimeSessionCount': 57, // Updated for 3 sessions today
    };
  }

  /// Generate realistic sessions with variety
  static List<SessionRecord> _generateDemoSessions(DateTime today) {
    final sessions = <SessionRecord>[];

    // Use DateTime.now() to ensure sessions are definitely "today" for the app
    final now = DateTime.now();

    // Today's sessions - 80% of daily goal with multiple activities for social sharing
    // Using actual DateTime.now() timestamps to ensure they show as "today" in UI
    sessions.addAll([
      _createSession(
        DateTime(now.year, now.month, now.day, 9, 0), // 9:00 AM today
        duration: 10 * 60, // 10 min meditation
        ambientScore: 0.88,
        activity: 'meditation',
      ),
      _createSession(
        DateTime(now.year, now.month, now.day, 11, 30), // 11:30 AM today
        duration: 8 * 60, // 8 min study
        ambientScore: 0.85,
        activity: 'study',
      ),
      _createSession(
        DateTime(now.year, now.month, now.day, 14, 30), // 2:30 PM today
        duration: 6 * 60, // 6 min reading
        ambientScore: 0.90,
        activity: 'reading',
      ),
      // Total: 24 min = 80% of 30 min goal
    ]);

    // Yesterday - completed goal
    final yesterday = today.subtract(const Duration(days: 1));
    sessions.addAll([
      _createSession(
        yesterday.add(const Duration(hours: 8, minutes: 0)),
        duration: 20 * 60,
        ambientScore: 0.88,
        activity: 'meditation',
      ),
      _createSession(
        yesterday.add(const Duration(hours: 15, minutes: 45)),
        duration: 12 * 60,
        ambientScore: 0.78,
        activity: 'study',
      ),
    ]);

    // Past 12 days - build streak
    for (int i = 2; i <= 13; i++) {
      final date = today.subtract(Duration(days: i));
      final sessionCount = (i % 3) + 1; // 1-3 sessions per day

      for (int j = 0; j < sessionCount; j++) {
        sessions.add(_createSession(
          date.add(Duration(hours: 8 + (j * 4), minutes: (i * 7) % 60)),
          duration: (10 + (i * 3) % 20) * 60, // 10-30 min sessions
          ambientScore: 0.70 + ((i * 0.02) % 0.25), // 70-95% range
          activity: _activityForIndex(i + j),
        ));
      }
    }

    // Sort by most recent first
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  /// Create a single demo session
  static SessionRecord _createSession(
    DateTime date, {
    required int duration,
    required double ambientScore,
    required String activity,
  }) {
    // Calculate points based on duration and ambient score
    final minutes = duration ~/ 60;
    final pointsEarned = (minutes * ambientScore).round();

    return SessionRecord(
      date: date,
      duration: duration,
      averageNoise: 35.0 + ((1.0 - ambientScore) * 15), // 35-50 dB range
      ambientScore: ambientScore,
      pointsEarned: pointsEarned,
      completed: ambientScore >= 0.70,
      activity: activity,
    );
  }

  /// Rotate through activity types for variety
  static String _activityForIndex(int index) {
    const activities = ['study', 'reading', 'meditation', 'other'];
    return activities[index % activities.length];
  }

  /// Generate demo analytics data for charts
  static Map<String, dynamic> generateDemoAnalytics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Generate daily totals for past 30 days
    final dailyMinutes = <DateTime, int>{};
    final dailySessions = <DateTime, int>{};

    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      // Create realistic daily variation
      dailyMinutes[date] = i < 14 ? (20 + (i * 2) % 15) : (10 + (i * 3) % 20);
      dailySessions[date] = i < 14 ? ((i % 3) + 1) : ((i % 2) + 1);
    }

    return {
      'dailyMinutes': dailyMinutes,
      'dailySessions': dailySessions,
      'weeklyAverage': 28.5,
      'monthlyTotal': 847,
      'averageAmbientScore': 0.84,
      'bestDay': today.subtract(const Duration(days: 5)),
      'bestDayMinutes': 45,
    };
  }
}
