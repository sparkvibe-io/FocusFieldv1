import 'dart:math' as math;
import 'package:focus_field/models/silence_data.dart';

// Insight categories shown in the advanced analytics widget.
enum InsightType { achievement, improvement, warning, recommendation, trend }

class AnalyticsInsight {
  final String title;
  final String description;
  final String value;
  final InsightType type;
  final double confidence; // 0-1 relative strength

  const AnalyticsInsight({
    required this.title,
    required this.description,
    required this.value,
    required this.type,
    required this.confidence,
  });
}

class WeeklyTrend {
  final DateTime
  weekStart; // Normalized week start (Mon) or day (for fallback daily mode)
  final int totalSessions;
  final int completedSessions;
  final double averagePoints;
  final double successRate; // 0-100
  final double averageNoise;
  final bool isMissing; // inserted placeholder week (no sessions)

  const WeeklyTrend({
    required this.weekStart,
    required this.totalSessions,
    required this.completedSessions,
    required this.averagePoints,
    required this.successRate,
    required this.averageNoise,
    this.isMissing = false,
  });
}

class PerformanceMetrics {
  final double overallSuccessRate; // 0-100
  final double averageSessionLength; // minutes
  final double consistencyScore; // 0-1
  final double
  improvementTrend; // percentage points difference (recent - older)
  final int bestTimeOfDay; // 0-23
  final String preferredDuration; // human label
  final Map<String, int> bestTimeByActivity; // activity -> hour (0-23)

  const PerformanceMetrics({
    required this.overallSuccessRate,
    required this.averageSessionLength,
    required this.consistencyScore,
    required this.improvementTrend,
    required this.bestTimeOfDay,
    required this.preferredDuration,
    this.bestTimeByActivity = const {},
  });
}

/// Service providing derived / advanced analytics from raw session data.
class AdvancedAnalyticsService {
  AdvancedAnalyticsService._();
  static final AdvancedAnalyticsService instance = AdvancedAnalyticsService._();

  List<WeeklyTrend> generateWeeklyTrends(SilenceData data) {
    final sessions = data.recentSessions;
    if (sessions.isEmpty) return [];

    // Group actual sessions by week
    final Map<DateTime, List<SessionRecord>> grouped = {};
    for (final s in sessions) {
      final ws = _weekStart(s.date);
      grouped.putIfAbsent(ws, () => []).add(s);
    }

    if (grouped.isEmpty) return [];

    final allWeeks = grouped.keys.toList()..sort();
    final first = allWeeks.first;
    final last = allWeeks.last;

    // DAILY FALLBACK: If data spans only a single week, return 7 daily entries (Mon-Sun)
    if (first == last) {
      final weekStart = first;
      final Map<DateTime, List<SessionRecord>> byDay = {};
      for (final s in sessions) {
        final d = DateTime(s.date.year, s.date.month, s.date.day);
        byDay.putIfAbsent(d, () => []).add(s);
      }
      final List<WeeklyTrend> days = [];
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        final list = byDay[day] ?? const <SessionRecord>[];
        final completed = list.where((s) => s.completed).length;
        final avgPts =
            list.isEmpty
                ? 0.0
                : list.map((s) => s.pointsEarned).reduce((a, b) => a + b) /
                    list.length;
        final successRate =
            list.isEmpty ? 0.0 : (completed / list.length) * 100;
        final avgNoise =
            list.isEmpty
                ? 0.0
                : list.map((s) => s.averageNoise).reduce((a, b) => a + b) /
                    list.length;
        days.add(
          WeeklyTrend(
            weekStart: day,
            totalSessions: list.length,
            completedSessions: completed,
            averagePoints: avgPts,
            successRate: successRate,
            averageNoise: avgNoise,
            isMissing: list.isEmpty,
          ),
        );
      }
      return days;
    }

    // Build continuous week sequence
    final List<DateTime> sequence = [];
    DateTime cursor = first;
    while (!cursor.isAfter(last)) {
      sequence.add(cursor);
      cursor = cursor.add(const Duration(days: 7));
    }

    final List<WeeklyTrend> trends = [];
    for (final weekStart in sequence) {
      final list = grouped[weekStart] ?? const <SessionRecord>[];
      final completed = list.where((s) => s.completed).length;
      final avgPts =
          list.isEmpty
              ? 0.0
              : list.map((s) => s.pointsEarned).reduce((a, b) => a + b) /
                  list.length;
      final successRate = list.isEmpty ? 0.0 : (completed / list.length) * 100;
      final avgNoise =
          list.isEmpty
              ? 0.0
              : list.map((s) => s.averageNoise).reduce((a, b) => a + b) /
                  list.length;
      trends.add(
        WeeklyTrend(
          weekStart: weekStart,
          totalSessions: list.length,
          completedSessions: completed,
          averagePoints: avgPts,
          successRate: successRate,
          averageNoise: avgNoise,
          isMissing: list.isEmpty,
        ),
      );
    }
    return trends;
  }

  PerformanceMetrics calculatePerformanceMetrics(SilenceData data) {
    final sessions = data.recentSessions;
    if (sessions.isEmpty) {
      return const PerformanceMetrics(
        overallSuccessRate: 0,
        averageSessionLength: 0,
        consistencyScore: 0,
        improvementTrend: 0,
        bestTimeOfDay: 12,
        preferredDuration: '10 minutes',
        bestTimeByActivity: {},
      );
    }

    final completed = sessions.where((s) => s.completed).length;
    final overallSuccessRate = (completed / sessions.length) * 100;
    final averageSessionLength =
        sessions.map((s) => s.duration).fold<int>(0, (a, b) => a + b) /
        sessions.length /
        60.0;
    final consistencyScore = _consistencyScore(sessions);
    final improvementTrend = _improvementTrend(sessions);
    final bestHour = _bestTimeOfDay(sessions);
    final preferredDuration = _preferredDuration(sessions);
    final bestTimeByActivity = _bestTimeByActivity(sessions);

    return PerformanceMetrics(
      overallSuccessRate: overallSuccessRate,
      averageSessionLength: averageSessionLength,
      consistencyScore: consistencyScore,
      improvementTrend: improvementTrend,
      bestTimeOfDay: bestHour,
      preferredDuration: preferredDuration,
      bestTimeByActivity: bestTimeByActivity,
    );
  }

  List<AnalyticsInsight> generateInsights(SilenceData data) {
    final sessions = data.recentSessions;
    final metrics = calculatePerformanceMetrics(data);
    final List<AnalyticsInsight> insights = [];
    if (sessions.isEmpty) {
      insights.add(
        const AnalyticsInsight(
          title: 'Get Started',
          description: 'Complete your first session to unlock insights',
          value: 'Begin now',
          type: InsightType.recommendation,
          confidence: 1.0,
        ),
      );
      return insights;
    }
    if (metrics.overallSuccessRate >= 80) {
      insights.add(
        AnalyticsInsight(
          title: 'High Success Rate',
          description: 'You are maintaining strong silent sessions.',
          value: '${metrics.overallSuccessRate.toStringAsFixed(1)}%',
          type: InsightType.achievement,
          confidence: .9,
        ),
      );
    } else if (metrics.overallSuccessRate < 50) {
      insights.add(
        const AnalyticsInsight(
          title: 'Improve Consistency',
          description:
              'Try adjusting environment or threshold for more completed sessions.',
          value: 'Tip',
          type: InsightType.recommendation,
          confidence: .8,
        ),
      );
    }
    if (metrics.improvementTrend > 15) {
      insights.add(
        const AnalyticsInsight(
          title: 'Trending Up',
          description: 'Recent sessions show noticeable improvement.',
          value: '+Improving',
          type: InsightType.improvement,
          confidence: .85,
        ),
      );
    }
    if (metrics.improvementTrend < -10) {
      insights.add(
        AnalyticsInsight(
          title: 'Declining Trend',
          description:
              'Performance has dipped recently compared to earlier sessions.',
          value: '${metrics.improvementTrend.toStringAsFixed(1)} pts',
          type: InsightType.warning,
          confidence: .8,
        ),
      );
    }
    if (data.currentStreak >= 5) {
      insights.add(
        AnalyticsInsight(
          title: 'Streak Strength',
          description: 'Great streak of ${data.currentStreak} days!',
          value: '${data.currentStreak} days',
          type: InsightType.achievement,
          confidence: 1.0,
        ),
      );
    }

    // Environment / noise stability insight (aggregate over all sessions)
    if (sessions.isNotEmpty) {
      final avgNoise =
          sessions.map((s) => s.averageNoise).reduce((a, b) => a + b) /
          sessions.length;
      if (avgNoise < 35) {
        insights.add(
          AnalyticsInsight(
            title: 'Quiet Environment',
            description:
                'Low ambient noise is supporting higher focus potential.',
            value: '${avgNoise.toStringAsFixed(1)} dB',
            type: InsightType.achievement,
            confidence: 0.7,
          ),
        );
      } else if (avgNoise > 55) {
        insights.add(
          AnalyticsInsight(
            title: 'High Ambient Noise',
            description:
                'Consider a quieter space or adjusting threshold for better results.',
            value: '${avgNoise.toStringAsFixed(1)} dB',
            type: InsightType.recommendation,
            confidence: 0.75,
          ),
        );
      } else {
        insights.add(
          AnalyticsInsight(
            title: 'Environment Stability',
            description:
                'Ambient noise is within a moderate, manageable range.',
            value: '${avgNoise.toStringAsFixed(1)} dB',
            type: InsightType.trend,
            confidence: 0.5,
          ),
        );
      }
    }
    return insights;
  }

  // Helpers
  DateTime _weekStart(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));

  /// Calculates consistency score based on regularity of practice sessions.
  /// This measures HABIT CONSISTENCY (how regularly you practice), not session quality variance.
  /// Returns a score from 0 to 1, where 1 = perfectly regular practice intervals.
  /// 
  /// Algorithm: Uses variance of time intervals between sessions to determine
  /// if the user maintains a regular practice schedule (e.g., daily, every other day).
  double _consistencyScore(List<SessionRecord> sessions) {
    if (sessions.length < 3) return 0.3; // minimal data
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    final intervals = <double>[]; // days
    for (var i = 1; i < sorted.length; i++) {
      intervals.add(
        sorted[i].date.difference(sorted[i - 1].date).inHours / 24.0,
      );
    }
    final avg = intervals.reduce((a, b) => a + b) / intervals.length;
    final variance =
        intervals.fold<double>(0, (s, v) => s + math.pow(v - avg, 2)) /
        intervals.length;
    final norm = math.max(0, 1 - (variance / 10));
    return norm.clamp(0.0, 1.0) as double;
  }

  double _improvementTrend(List<SessionRecord> sessions) {
    if (sessions.length < 4) return 0;
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    final mid = sorted.length ~/ 2;
    final older = sorted.take(mid).toList();
    final recent = sorted.skip(mid).toList();
    double rate(List<SessionRecord> list) =>
        list.isEmpty ? 0 : list.where((s) => s.completed).length / list.length;
    return (rate(recent) - rate(older)) * 100;
  }

  int _bestTimeOfDay(List<SessionRecord> sessions) {
    final map = <int, List<bool>>{};
    for (final s in sessions) {
      map.putIfAbsent(s.date.hour, () => []).add(s.completed);
    }
    double bestRate = -1;
    int bestHour = 12;
    map.forEach((hour, list) {
      final r = list.where((c) => c).length / list.length;
      if (r > bestRate) {
        bestRate = r;
        bestHour = hour;
      }
    });
    return bestHour;
  }

  /// Calculates best time of day for each activity type.
  /// Returns map of activity ID -> best hour (0-23) based on success rate.
  Map<String, int> _bestTimeByActivity(List<SessionRecord> sessions) {
    final activityMap = <String, Map<int, List<bool>>>{};
    
    // Group sessions by activity and hour
    for (final s in sessions) {
      final activity = s.activity ?? 'other';
      activityMap.putIfAbsent(activity, () => {});
      activityMap[activity]!.putIfAbsent(s.date.hour, () => []).add(s.completed);
    }
    
    // Find best hour for each activity
    final result = <String, int>{};
    activityMap.forEach((activity, hourMap) {
      double bestRate = -1;
      int bestHour = 12;
      hourMap.forEach((hour, completedList) {
        final rate = completedList.where((c) => c).length / completedList.length;
        if (rate > bestRate) {
          bestRate = rate;
          bestHour = hour;
        }
      });
      result[activity] = bestHour;
    });
    
    return result;
  }

  /// Determines the preferred session duration based on success rate.
  /// Returns the duration bucket (e.g., '1-2 min', '6-10 min') with the highest
  /// completion rate. This helps users identify their optimal focus session length.
  /// 
  /// Returns a localization key (bucket1to2, bucket3to5, etc.) that UI layer
  /// can translate via AppLocalizations.
  String _preferredDuration(List<SessionRecord> sessions) {
    // Use stable bucket keys; UI layer can translate via AppLocalizations.
    String bucketKey(int minutes) {
      if (minutes <= 2) return 'bucket1to2';
      if (minutes <= 5) return 'bucket3to5';
      if (minutes <= 10) return 'bucket6to10';
      if (minutes <= 20) return 'bucket11to20';
      if (minutes <= 30) return 'bucket21to30';
      return 'bucket30plus';
    }

    final buckets = <String, List<bool>>{};
    for (final s in sessions) {
      final minutes = (s.duration / 60).round();
      final key = bucketKey(minutes);
      buckets.putIfAbsent(key, () => []).add(s.completed);
    }
    String best = '';
    double bestRate = -1;
    buckets.forEach((k, v) {
      final r = v.where((c) => c).length / v.length;
      if (r > bestRate) {
        bestRate = r;
        best = k;
      }
    });
    return best; // returns localization key, not raw label
  }
}
