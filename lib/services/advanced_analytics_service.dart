import 'dart:math' as math;
import 'package:silence_score/models/silence_data.dart';

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
  final DateTime weekStart; // Normalized week start (Mon)
  final int totalSessions;
  final int completedSessions;
  final double averagePoints;
  final double successRate; // 0-100
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
  final double overallSuccessRate; // 0-100
  final double averageSessionLength; // minutes
  final double consistencyScore; // 0-1
  final double improvementTrend; // percentage points difference (recent - older)
  final int bestTimeOfDay; // 0-23
  final String preferredDuration; // human label

  const PerformanceMetrics({
    required this.overallSuccessRate,
    required this.averageSessionLength,
    required this.consistencyScore,
    required this.improvementTrend,
    required this.bestTimeOfDay,
    required this.preferredDuration,
  });
}

/// Service providing derived / advanced analytics from raw session data.
class AdvancedAnalyticsService {
  AdvancedAnalyticsService._();
  static final AdvancedAnalyticsService instance = AdvancedAnalyticsService._();

  List<WeeklyTrend> generateWeeklyTrends(SilenceData data) {
    final sessions = data.recentSessions;
    if (sessions.isEmpty) return [];
    final Map<DateTime, List<SessionRecord>> grouped = {};
    for (final s in sessions) {
      final weekStart = _weekStart(s.date);
      grouped.putIfAbsent(weekStart, () => []).add(s);
    }
    final trends = grouped.entries.map((e) {
      final list = e.value;
      final completed = list.where((s) => s.completed).length;
      final avgPts = list.isEmpty ? 0.0 : list.map((s) => s.pointsEarned).reduce((a,b)=>a+b) / list.length;
      final successRate = list.isEmpty ? 0.0 : (completed / list.length) * 100;
      final avgNoise = list.isEmpty ? 0.0 : list.map((s)=>s.averageNoise).reduce((a,b)=>a+b)/list.length;
      return WeeklyTrend(
        weekStart: e.key,
        totalSessions: list.length,
        completedSessions: completed,
        averagePoints: avgPts,
        successRate: successRate,
        averageNoise: avgNoise,
      );
    }).toList();
    trends.sort((a,b)=>a.weekStart.compareTo(b.weekStart));
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
        preferredDuration: '5 minutes',
      );
    }

    final completed = sessions.where((s) => s.completed).length;
    final overallSuccessRate = (completed / sessions.length) * 100;
    final averageSessionLength = sessions.map((s) => s.duration).fold<int>(0,(a,b)=>a+b) / sessions.length / 60.0;
    final consistencyScore = _consistencyScore(sessions);
    final improvementTrend = _improvementTrend(sessions);
    final bestHour = _bestTimeOfDay(sessions);
    final preferredDuration = _preferredDuration(sessions);

    return PerformanceMetrics(
      overallSuccessRate: overallSuccessRate,
      averageSessionLength: averageSessionLength,
      consistencyScore: consistencyScore,
      improvementTrend: improvementTrend,
      bestTimeOfDay: bestHour,
      preferredDuration: preferredDuration,
    );
  }

  List<AnalyticsInsight> generateInsights(SilenceData data) {
    final sessions = data.recentSessions;
    final metrics = calculatePerformanceMetrics(data);
    final List<AnalyticsInsight> insights = [];
    if (sessions.isEmpty) {
      insights.add(const AnalyticsInsight(
        title: 'Get Started',
        description: 'Complete your first session to unlock insights',
        value: 'Begin now',
        type: InsightType.recommendation,
        confidence: 1.0,
      ));
      return insights;
    }
    if (metrics.overallSuccessRate >= 80) {
      insights.add(AnalyticsInsight(
        title: 'High Success Rate',
        description: 'You are maintaining strong silent sessions.',
        value: '${metrics.overallSuccessRate.toStringAsFixed(1)}%',
        type: InsightType.achievement,
        confidence: .9,
      ));
    } else if (metrics.overallSuccessRate < 50) {
      insights.add(const AnalyticsInsight(
        title: 'Improve Consistency',
        description: 'Try adjusting environment or threshold for more completed sessions.',
        value: 'Tip',
        type: InsightType.recommendation,
        confidence: .8,
      ));
    }
    if (metrics.improvementTrend > 15) {
      insights.add(const AnalyticsInsight(
        title: 'Trending Up',
        description: 'Recent sessions show noticeable improvement.',
        value: '+Improving',
        type: InsightType.improvement,
        confidence: .85,
      ));
    }
    if (data.currentStreak >= 5) {
      insights.add(AnalyticsInsight(
        title: 'Streak Strength',
        description: 'Great streak of ${data.currentStreak} days!',
        value: '${data.currentStreak} days',
        type: InsightType.achievement,
        confidence: 1.0,
      ));
    }
    return insights;
  }

  // Helpers
  DateTime _weekStart(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday - 1));

  double _consistencyScore(List<SessionRecord> sessions) {
    if (sessions.length < 3) return 0.3; // minimal data
    final sorted = [...sessions]..sort((a,b)=>a.date.compareTo(b.date));
    final intervals = <double>[]; // days
    for (var i=1;i<sorted.length;i++) {
      intervals.add(sorted[i].date.difference(sorted[i-1].date).inHours / 24.0);
    }
    final avg = intervals.reduce((a,b)=>a+b)/intervals.length;
    final variance = intervals.fold<double>(0,(s,v)=>s+math.pow(v-avg,2))/intervals.length;
    final norm = math.max(0, 1 - (variance / 10));
  return norm.clamp(0.0,1.0) as double;
  }

  double _improvementTrend(List<SessionRecord> sessions) {
    if (sessions.length < 4) return 0;
    final sorted = [...sessions]..sort((a,b)=>a.date.compareTo(b.date));
    final mid = sorted.length ~/ 2;
    final older = sorted.take(mid).toList();
    final recent = sorted.skip(mid).toList();
    double rate(List<SessionRecord> list) => list.isEmpty ? 0 : list.where((s)=>s.completed).length / list.length;
    return (rate(recent)-rate(older))*100;
  }

  int _bestTimeOfDay(List<SessionRecord> sessions) {
    final map = <int,List<bool>>{};
    for (final s in sessions) {
      map.putIfAbsent(s.date.hour, ()=>[]).add(s.completed);
    }
    double bestRate = -1; int bestHour = 12;
    map.forEach((hour,list){
      final r = list.where((c)=>c).length / list.length;
      if (r > bestRate) { bestRate = r; bestHour = hour; }
    });
    return bestHour;
  }

  String _preferredDuration(List<SessionRecord> sessions) {
    final buckets = <String,List<bool>>{};
    for (final s in sessions) {
      final minutes = (s.duration/60).round();
      final label = minutes <=2 ? '1-2 min' : minutes<=5 ? '3-5 min' : minutes<=10 ? '6-10 min' : minutes<=20 ? '11-20 min' : '20+ min';
      buckets.putIfAbsent(label, ()=>[]).add(s.completed);
    }
    String best='5 min'; double bestRate=-1;
    buckets.forEach((k,v){
      final r = v.where((c)=>c).length / v.length;
      if (r>bestRate){bestRate=r;best=k;}
    });
    return best;
  }
}