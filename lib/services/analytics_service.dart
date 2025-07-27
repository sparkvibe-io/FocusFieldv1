import 'dart:math' as math;
import 'package:silence_score/models/silence_data.dart';

class AnalyticsInsight {
  final String title;
  final String description;
  final String value;
  final InsightType type;
  final double confidence;

  const AnalyticsInsight({
    required this.title,
    required this.description,
    required this.value,
    required this.type,
    required this.confidence,
  });
}

enum InsightType {
  improvement,
  warning,
  achievement,
  trend,
  recommendation,
}

class WeeklyTrend {
  final DateTime weekStart;
  final int totalSessions;
  final int completedSessions;
  final double averagePoints;
  final double successRate;
  final double averageNoise;

  const WeeklyTrend({
    required this.weekStart,
    required this.totalSessions,
    required this.completedSessions,
    required this.averagePoints,
    required this.successRate,
    required this.averageNoise,
  });
}

class PerformanceMetrics {
  final double overallSuccessRate;
  final double averageSessionLength;
  final double consistencyScore;
  final double improvementTrend;
  final int bestTimeOfDay;
  final String preferredDuration;

  const PerformanceMetrics({
    required this.overallSuccessRate,
    required this.averageSessionLength,
    required this.consistencyScore,
    required this.improvementTrend,
    required this.bestTimeOfDay,
    required this.preferredDuration,
  });
}

class AdvancedAnalyticsService {
  static AdvancedAnalyticsService? _instance;
  static AdvancedAnalyticsService get instance => _instance ??= AdvancedAnalyticsService._();
  AdvancedAnalyticsService._();

  /// Generate weekly trends from session data
  List<WeeklyTrend> generateWeeklyTrends(SilenceData silenceData) {
    final sessions = silenceData.recentSessions;
    if (sessions.isEmpty) return [];

    // Group sessions by week
    final Map<DateTime, List<SessionRecord>> weeklyGroups = {};
    
    for (final session in sessions) {
      final weekStart = _getWeekStart(session.date);
      weeklyGroups.putIfAbsent(weekStart, () => []).add(session);
    }

    // Calculate trends for each week
    return weeklyGroups.entries.map((entry) {
      final weekSessions = entry.value;
      final completed = weekSessions.where((s) => s.completed).length;
      final totalPoints = weekSessions.fold<int>(0, (sum, s) => sum + s.pointsEarned);
      final averagePoints = weekSessions.isNotEmpty ? totalPoints / weekSessions.length : 0.0;
      final successRate = weekSessions.isNotEmpty ? (completed / weekSessions.length) * 100 : 0.0;
      final averageNoise = weekSessions.isNotEmpty 
          ? weekSessions.fold<double>(0, (sum, s) => sum + s.averageNoise) / weekSessions.length
          : 0.0;

      return WeeklyTrend(
        weekStart: entry.key,
        totalSessions: weekSessions.length,
        completedSessions: completed,
        averagePoints: averagePoints,
        successRate: successRate,
        averageNoise: averageNoise,
      );
    }).toList()..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  }

  /// Calculate comprehensive performance metrics
  PerformanceMetrics calculatePerformanceMetrics(SilenceData silenceData) {
    final sessions = silenceData.recentSessions;
    if (sessions.isEmpty) {
      return const PerformanceMetrics(
        overallSuccessRate: 0.0,
        averageSessionLength: 0.0,
        consistencyScore: 0.0,
        improvementTrend: 0.0,
        bestTimeOfDay: 12,
        preferredDuration: '5 minutes',
      );
    }

    // Overall success rate
    final completedSessions = sessions.where((s) => s.completed).length;
    final overallSuccessRate = (completedSessions / sessions.length) * 100;

    // Average session length
    final averageSessionLength = sessions.fold<double>(0, (sum, s) => sum + s.duration) / sessions.length / 60;

    // Consistency score (based on session frequency and completion rate)
    final consistencyScore = _calculateConsistencyScore(sessions);

    // Improvement trend (last 7 days vs previous 7 days)
    final improvementTrend = _calculateImprovementTrend(sessions);

    // Best time of day (hour with highest success rate)
    final bestTimeOfDay = _findBestTimeOfDay(sessions);

    // Preferred duration
    final preferredDuration = _findPreferredDuration(sessions);

    return PerformanceMetrics(
      overallSuccessRate: overallSuccessRate,
      averageSessionLength: averageSessionLength,
      consistencyScore: consistencyScore,
      improvementTrend: improvementTrend,
      bestTimeOfDay: bestTimeOfDay,
      preferredDuration: preferredDuration,
    );
  }

  /// Generate AI-powered insights based on session data
  List<AnalyticsInsight> generateInsights(SilenceData silenceData) {
    final insights = <AnalyticsInsight>[];
    final sessions = silenceData.recentSessions;
    final metrics = calculatePerformanceMetrics(silenceData);

    if (sessions.isEmpty) {
      insights.add(const AnalyticsInsight(
        title: 'Get Started',
        description: 'Complete your first session to unlock personalized insights',
        value: 'Start practicing',
        type: InsightType.recommendation,
        confidence: 1.0,
      ));
      return insights;
    }

    // Success rate insights
    if (metrics.overallSuccessRate >= 80) {
      insights.add(AnalyticsInsight(
        title: 'Excellent Performance',
        description: 'Your success rate is outstanding! You\'re mastering the art of silence.',
        value: '${metrics.overallSuccessRate.toStringAsFixed(1)}%',
        type: InsightType.achievement,
        confidence: 0.9,
      ));
    } else if (metrics.overallSuccessRate < 50) {
      insights.add(const AnalyticsInsight(
        title: 'Room for Improvement',
        description: 'Consider practicing in a quieter environment or adjusting your decibel threshold.',
        value: 'Try quieter spaces',
        type: InsightType.recommendation,
        confidence: 0.8,
      ));
    }

    // Consistency insights
    if (metrics.consistencyScore >= 0.8) {
      insights.add(const AnalyticsInsight(
        title: 'Great Consistency',
        description: 'You\'re building a strong practice habit. Keep it up!',
        value: 'Well established',
        type: InsightType.achievement,
        confidence: 0.85,
      ));
    } else if (metrics.consistencyScore < 0.4) {
      insights.add(const AnalyticsInsight(
        title: 'Build Consistency',
        description: 'Try setting a daily reminder to practice. Regular sessions lead to better results.',
        value: 'Set daily reminders',
        type: InsightType.recommendation,
        confidence: 0.75,
      ));
    }

    // Improvement trend insights
    if (metrics.improvementTrend > 20) {
      insights.add(const AnalyticsInsight(
        title: 'Improving Fast',
        description: 'Your recent performance shows significant improvement. Great progress!',
        value: 'Strong upward trend',
        type: InsightType.improvement,
        confidence: 0.9,
      ));
    } else if (metrics.improvementTrend < -15) {
      insights.add(const AnalyticsInsight(
        title: 'Performance Dip',
        description: 'Your recent sessions show a decline. Consider what might have changed in your environment.',
        value: 'Review recent changes',
        type: InsightType.warning,
        confidence: 0.7,
      ));
    }

    // Time-based insights
    if (metrics.bestTimeOfDay >= 6 && metrics.bestTimeOfDay <= 10) {
      insights.add(AnalyticsInsight(
        title: 'Morning Person',
        description: 'You perform best in the morning hours. Your environment is quietest then.',
        value: '${_formatHour(metrics.bestTimeOfDay)} peak time',
        type: InsightType.trend,
        confidence: 0.8,
      ));
    } else if (metrics.bestTimeOfDay >= 22 || metrics.bestTimeOfDay <= 5) {
      insights.add(AnalyticsInsight(
        title: 'Night Owl',
        description: 'Late night sessions work best for you. The world is quieter after hours.',
        value: '${_formatHour(metrics.bestTimeOfDay)} peak time',
        type: InsightType.trend,
        confidence: 0.8,
      ));
    }

    // Streak insights
    if (silenceData.currentStreak >= 7) {
      insights.add(AnalyticsInsight(
        title: 'Streak Master',
        description: 'Amazing ${silenceData.currentStreak}-day streak! You\'re building a powerful habit.',
        value: '${silenceData.currentStreak} days',
        type: InsightType.achievement,
        confidence: 1.0,
      ));
    }

    return insights;
  }

  /// Helper method to get the start of the week
  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// Calculate consistency score based on session patterns
  double _calculateConsistencyScore(List<SessionRecord> sessions) {
    if (sessions.length < 3) return 0.5;

    // Calculate average days between sessions
    final sortedSessions = sessions..sort((a, b) => a.date.compareTo(b.date));
    final intervals = <int>[];
    
    for (int i = 1; i < sortedSessions.length; i++) {
      final daysBetween = sortedSessions[i].date.difference(sortedSessions[i - 1].date).inDays;
      intervals.add(daysBetween);
    }

    if (intervals.isEmpty) return 0.5;

    // Calculate variance in intervals (lower variance = more consistent)
    final averageInterval = intervals.fold(0, (sum, interval) => sum + interval) / intervals.length;
    final variance = intervals.fold(0.0, (sum, interval) => sum + math.pow(interval - averageInterval, 2)) / intervals.length;
    
    // Convert to consistency score (0-1, where 1 is most consistent)
    final consistencyScore = math.max(0.0, 1.0 - (variance / 10.0));
    return math.min(1.0, consistencyScore);
  }

  /// Calculate improvement trend comparing recent vs older sessions
  double _calculateImprovementTrend(List<SessionRecord> sessions) {
    if (sessions.length < 4) return 0.0;

    final sortedSessions = sessions..sort((a, b) => a.date.compareTo(b.date));
    final midPoint = sortedSessions.length ~/ 2;
    
    final olderSessions = sortedSessions.take(midPoint).toList();
    final recentSessions = sortedSessions.skip(midPoint).toList();

    final olderSuccessRate = olderSessions.where((s) => s.completed).length / olderSessions.length;
    final recentSuccessRate = recentSessions.where((s) => s.completed).length / recentSessions.length;

    return (recentSuccessRate - olderSuccessRate) * 100;
  }

  /// Find the hour of day with the highest success rate
  int _findBestTimeOfDay(List<SessionRecord> sessions) {
    final hourlyStats = <int, List<bool>>{};
    
    for (final session in sessions) {
      final hour = session.date.hour;
      hourlyStats.putIfAbsent(hour, () => []).add(session.completed);
    }

    double bestSuccessRate = -1;
    int bestHour = 12; // Default to noon
    
    for (final entry in hourlyStats.entries) {
      final successRate = entry.value.where((completed) => completed).length / entry.value.length;
      if (successRate > bestSuccessRate) {
        bestSuccessRate = successRate;
        bestHour = entry.key;
      }
    }

    return bestHour;
  }

  /// Find the most successful session duration
  String _findPreferredDuration(List<SessionRecord> sessions) {
    final durationGroups = <String, List<bool>>{};
    
    for (final session in sessions) {
      final minutes = (session.duration / 60).round();
      String group;
      if (minutes <= 2) group = '1-2 minutes';
      else if (minutes <= 5) group = '3-5 minutes';
      else if (minutes <= 10) group = '6-10 minutes';
      else if (minutes <= 20) group = '11-20 minutes';
      else group = '20+ minutes';
      
      durationGroups.putIfAbsent(group, () => []).add(session.completed);
    }

    double bestSuccessRate = -1;
    String bestDuration = '5 minutes';
    
    for (final entry in durationGroups.entries) {
      final successRate = entry.value.where((completed) => completed).length / entry.value.length;
      if (successRate > bestSuccessRate) {
        bestSuccessRate = successRate;
        bestDuration = entry.key;
      }
    }

    return bestDuration;
  }

  /// Format hour in 12-hour format
  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
} 