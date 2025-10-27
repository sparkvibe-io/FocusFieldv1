import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/models/ambient_models.dart';
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
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + (s.duration ~/ 60));
    final successfulSessions = sessions.where((s) => s.successful).length;
    final avgAmbientScore = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(0, (sum, s) => sum + s.ambientScore) / sessions.length;

    return SilenceData(
      totalSessions: sessions.length,
      totalMinutes: totalMinutes,
      averageAmbientScore: avgAmbientScore,
      currentStreak: 12, // Impressive but realistic
      longestStreak: 18, // Show historical achievement
      recentSessions: sessions,
      successfulSessionsCount: successfulSessions,
      lastSessionDate: sessions.isNotEmpty ? sessions.first.startTime : null,
    );
  }

  /// Generate demo quest state with realistic progress
  static Map<String, dynamic> generateDemoQuestState() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'dailyGoalMinutes': 30, // Achievable goal
      'todayQuietMinutes': 23, // Almost complete (76% progress - looks good)
      'currentStreak': 12,
      'longestStreak': 18,
      'monthlyFreezeTokensUsed': 0, // Shows discipline
      'lastCompletionDate': today.subtract(const Duration(days: 1)).toIso8601String(),
      'lastFreezeDate': null,
      'consecutiveMissedDays': 0,
      'lifetimeQuietMinutes': 847, // ~14 hours total - realistic for 2 weeks
      'lifetimeSessionCount': 56, // ~4 sessions per day average
    };
  }

  /// Generate realistic sessions with variety
  static List<SilenceSession> _generateDemoSessions(DateTime today) {
    final sessions = <SilenceSession>[];

    // Today's sessions (in progress day)
    sessions.addAll([
      _createSession(
        today.add(const Duration(hours: 9, minutes: 15)),
        duration: 15 * 60,
        ambientScore: 0.85,
        activity: 'study',
      ),
      _createSession(
        today.add(const Duration(hours: 14, minutes: 30)),
        duration: 8 * 60,
        ambientScore: 0.92,
        activity: 'reading',
      ),
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
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  /// Create a single demo session
  static SilenceSession _createSession(
    DateTime startTime, {
    required int duration,
    required double ambientScore,
    required String activity,
  }) {
    final quietSeconds = (duration * ambientScore).round();

    return SilenceSession(
      startTime: startTime,
      endTime: startTime.add(Duration(seconds: duration)),
      duration: duration,
      averageDecibels: 35.0 + ((1.0 - ambientScore) * 15), // 35-50 dB range
      calmPercentage: ambientScore, // Legacy field
      ambientScore: ambientScore,
      quietSeconds: quietSeconds,
      successful: ambientScore >= 0.70,
      activityProfile: activity,
      goalAchieved: ambientScore >= 0.70,
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
