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

    // Generate realistic sessions spanning 21 days (3 weeks)
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

  /// Generate demo quest state with realistic progress showing improvement journey
  static Map<String, dynamic> generateDemoQuestState() {
    final now = DateTime.now();

    return {
      // Core quest fields
      'cycleId': '${now.year}-${now.month.toString().padLeft(2, '0')}',
      'dayIndex': now.day,
      'goalQuietMinutes': 30, // Achievable goal
      'requiredScore': 0.7,
      'progressQuietMinutes': 23, // 77% progress - shows incomplete for screenshots
      'currentStreak': 12, // Strong streak showing consistency (after 2 missed days early on)
      'longestStreak': 12, // Same as current - they're on their best streak!
      'freezeTokens': 1, // Show available freeze token for discoverability
      'lastUpdatedAt': now.millisecondsSinceEpoch,
      'lastFreezeReplenishment': now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      'missedYesterday': false,
      'freezeTokenUsedToday': false,
      // Per-activity minutes for today (must match session data)
      'studyMinutes': 7,      // 7 min study session at 11:30 AM
      'readingMinutes': 6,    // 6 min reading session at 2:30 PM
      'meditationMinutes': 10, // 10 min meditation session at 9:00 AM
      'otherMinutes': 0,      // No "other" activity today
      // Total: 23 min = 77% of 30 min goal (shows as incomplete for screenshots)
    };
  }

  /// Generate realistic sessions with variety showing upward trending improvement
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
        duration: 7 * 60, // 7 min study
        ambientScore: 0.85,
        activity: 'study',
      ),
      _createSession(
        DateTime(now.year, now.month, now.day, 14, 30), // 2:30 PM today
        duration: 6 * 60, // 6 min reading
        ambientScore: 0.90,
        activity: 'reading',
      ),
      // Total: 23 min = 77% of 30 min goal (incomplete for screenshots)
    ]);

    // Yesterday - completed goal comfortably
    final yesterday = today.subtract(const Duration(days: 1));
    sessions.addAll([
      _createSession(
        yesterday.add(const Duration(hours: 8, minutes: 0)),
        duration: 15 * 60,
        ambientScore: 0.92,
        activity: 'meditation',
      ),
      _createSession(
        yesterday.add(const Duration(hours: 11, minutes: 30)),
        duration: 8 * 60,
        ambientScore: 0.86,
        activity: 'study',
      ),
      _createSession(
        yesterday.add(const Duration(hours: 15, minutes: 45)),
        duration: 12 * 60,
        ambientScore: 0.88,
        activity: 'reading',
      ),
    ]);

    // Past 21 days (3 weeks) - showing upward trending improvement
    // Week 1 (21-15 days ago): Building phase - Lower performance, establishing consistency
    for (int i = 21; i >= 15; i--) {
      final date = today.subtract(Duration(days: i));
      final missedDay = i == 20 || i == 17; // Missed 2 days early on (shows compassionate 2-day rule)

      if (!missedDay) {
        final sessionCount = 1 + (i % 2); // 1-2 sessions per day
        for (int j = 0; j < sessionCount; j++) {
          sessions.add(_createSession(
            date.add(Duration(hours: 9 + (j * 5), minutes: (i * 11) % 60)),
            duration: (8 + (i % 7)) * 60, // 8-14 min sessions (shorter, building)
            ambientScore: 0.68 + ((i + j) * 0.01) % 0.10, // 68-78% (below 70% sometimes)
            activity: _activityForIndex(i + j),
          ));
        }
      }
    }

    // Week 2 (14-8 days ago): Improvement phase - Better consistency and scores
    for (int i = 14; i >= 8; i--) {
      final date = today.subtract(Duration(days: i));
      final sessionCount = 2 + (i % 2); // 2-3 sessions per day

      for (int j = 0; j < sessionCount; j++) {
        sessions.add(_createSession(
          date.add(Duration(hours: 8 + (j * 4), minutes: (i * 13) % 60)),
          duration: (14 + (i % 8)) * 60, // 14-21 min sessions (approaching goal)
          ambientScore: 0.75 + ((i + j) * 0.015) % 0.13, // 75-88% (consistently above 70%)
          activity: _activityForIndex(i + j),
        ));
      }
    }

    // Week 3 (7-2 days ago): Peak performance - Excellent consistency and scores
    for (int i = 7; i >= 2; i--) {
      final date = today.subtract(Duration(days: i));
      final sessionCount = 2 + (i % 2); // 2-3 sessions per day

      for (int j = 0; j < sessionCount; j++) {
        sessions.add(_createSession(
          date.add(Duration(hours: 8 + (j * 4), minutes: (i * 17) % 60)),
          duration: (18 + (i % 10)) * 60, // 18-27 min sessions (exceeding goal)
          ambientScore: 0.84 + ((i + j) * 0.015) % 0.11, // 84-95% (excellent performance)
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

  /// Generate demo analytics data showing upward trending improvement
  static Map<String, dynamic> generateDemoAnalytics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Generate daily totals for past 30 days with upward trend
    final dailyMinutes = <DateTime, int>{};
    final dailySessions = <DateTime, int>{};
    int totalMinutes = 0;

    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));

      // Create upward trending pattern
      int minutes;
      int sessions;

      if (i < 10) {
        // Recent 10 days: Peak performance (30-45 min/day)
        minutes = 32 + (i % 13);
        sessions = 2 + (i % 2);
      } else if (i < 20) {
        // Middle 10 days: Improvement phase (20-32 min/day)
        minutes = 20 + (i % 12);
        sessions = 2 + (i % 2);
      } else {
        // Oldest 10 days: Building phase (10-22 min/day, with 2 missed days)
        if (i == 28 || i == 24) {
          // Missed days
          minutes = 0;
          sessions = 0;
        } else {
          minutes = 10 + (i % 10);
          sessions = 1 + (i % 2);
        }
      }

      dailyMinutes[date] = minutes;
      dailySessions[date] = sessions;
      totalMinutes += minutes;
    }

    return {
      'dailyMinutes': dailyMinutes,
      'dailySessions': dailySessions,
      'weeklyAverage': 38.2, // Recent week average (showing improvement)
      'monthlyTotal': totalMinutes,
      'averageAmbientScore': 0.84, // Overall average across all sessions
      'bestDay': today.subtract(const Duration(days: 3)),
      'bestDayMinutes': 45,
    };
  }
}
