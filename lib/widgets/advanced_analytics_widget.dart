import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/services/advanced_analytics_service.dart';

class AdvancedAnalyticsWidget extends ConsumerWidget {
  final SilenceData silenceData;
  const AdvancedAnalyticsWidget({super.key, required this.silenceData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = AdvancedAnalyticsService.instance;
    final metrics = svc.calculatePerformanceMetrics(silenceData);
    final insights = svc.generateInsights(silenceData);
    final trends = svc.generateWeeklyTrends(silenceData);
  // Compact layout currently always true; kept as variable to allow future expansion without triggering dead code warnings.
  final compact = true;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        leading: Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
        title: Row(children: [
          Expanded(
            child: Text('Advanced Analytics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('PREMIUM', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          ),
        ]),
        children: [
          _performanceMetrics(context, metrics, compact: compact),
          if (trends.isNotEmpty) ...[
            const SizedBox(height: 12),
            _trendsChart(context, trends, compact: compact),
          ],
          if (insights.isNotEmpty) ...[
            const SizedBox(height: 12),
            _insights(context, insights, compact: compact),
          ],
        ],
      ),
    );
  }

  Widget _performanceMetrics(BuildContext context, PerformanceMetrics m, {required bool compact}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Performance Metrics', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: compact ? 8 : 12),
      LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final count = w >= 900 ? 4 : w >= 600 ? 3 : 2;
        final aspect = w >= 900 ? (compact ? 3.0 : 2.7) : w >= 600 ? (compact ? 2.8 : 2.5) : (compact ? 2.6 : 2.3);
        return GridView.count(
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          childAspectRatio: aspect,
          crossAxisSpacing: 12,
          mainAxisSpacing: 8,
          children: [
            _metricCard(context, 'Success Rate', '${m.overallSuccessRate.toStringAsFixed(1)}%', Icons.check_circle_outline, _successRateColor(m.overallSuccessRate), compact),
            _metricCard(context, 'Avg Session', '${m.averageSessionLength.toStringAsFixed(1)}m', Icons.timer_outlined, Theme.of(context).colorScheme.secondary, compact),
            _metricCard(context, 'Consistency', '${(m.consistencyScore * 100).toStringAsFixed(0)}%', Icons.trending_up, _consistencyColor(m.consistencyScore), compact),
            _metricCard(context, 'Best Time', _formatHour(m.bestTimeOfDay), Icons.schedule, Theme.of(context).colorScheme.tertiary, compact),
          ],
        );
      })
    ]);
  }

  Widget _metricCard(BuildContext context, String label, String value, IconData icon, Color color, bool compact) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: compact ? 8 : 10),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
        ]),
        SizedBox(height: compact ? 2 : 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: compact ? 16 : 18)),
      ]),
    );
  }

  Widget _trendsChart(BuildContext context, List<WeeklyTrend> trends, {required bool compact}) {
    final ma = <FlSpot>[];
    for (var i = 0; i < trends.length; i++) {
      final w = trends.sublist((i - 2).clamp(0, i), i + 1);
      final avg = w.map((e) => e.successRate).reduce((a, b) => a + b) / w.length;
      ma.add(FlSpot(i.toDouble(), avg));
    }
    final overall = trends.isEmpty ? 0.0 : trends.map((e) => e.successRate).reduce((a, b) => a + b) / trends.length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Weekly Trends', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: compact ? 8 : 12),
      Container(
        height: compact ? 110 : 140,
        padding: EdgeInsets.all(compact ? 8 : 12),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
        child: LineChart(LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25, getDrawingHorizontalLine: (v) => FlLine(color: Theme.of(context).dividerColor.withOpacity(0.15), strokeWidth: 1)),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map((p) => LineTooltipItem(
                        '${p.y.toStringAsFixed(1)}%',
                        Theme.of(context).textTheme.labelSmall!,
                      ))
                  .toList(),
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, meta) => Text('${v.toInt()}%', style: Theme.of(context).textTheme.bodySmall))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 20, getTitlesWidget: (v, meta) { final i = v.toInt(); if (i < 0 || i >= trends.length) return const SizedBox(); final d = trends[i].weekStart; return Text('${d.month}/${d.day}', style: Theme.of(context).textTheme.bodySmall); })),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(spots: [for (var i = 0; i < trends.length; i++) FlSpot(i.toDouble(), trends[i].successRate)], isCurved: true, color: Theme.of(context).colorScheme.primary, barWidth: 3, dotData: const FlDotData(show: true), belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withOpacity(0.10))),
            if (ma.length > 2) LineChartBarData(spots: ma, isCurved: true, color: Theme.of(context).colorScheme.primary.withOpacity(0.55), barWidth: 2, dotData: const FlDotData(show: false), dashArray: [4,4]),
            if (trends.length > 1)
              LineChartBarData(
                spots: [
                  FlSpot(0, overall),
                  FlSpot((trends.length - 1).toDouble(), overall),
                ],
                isCurved: false,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                barWidth: 1,
                dotData: const FlDotData(show: false),
              ),
          ],
        )),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(children: [
          _legendDot(context, Theme.of(context).colorScheme.primary), const SizedBox(width: 4), const Text('Rate', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8), _legendDot(context, Theme.of(context).colorScheme.primary.withOpacity(0.55), dashed: true), const SizedBox(width: 4), const Text('MA(3)', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8), _legendDot(context, Theme.of(context).colorScheme.secondary.withOpacity(0.5)), const SizedBox(width: 4), const Text('Avg', style: TextStyle(fontSize: 10)),
        ]),
      ),
    ]);
  }

  Widget _insights(BuildContext context, List<AnalyticsInsight> insights, {required bool compact}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('AI Insights', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: compact ? 8 : 12),
      ...insights.take(3).map((i) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _insightCard(context, i))),
    ]);
  }

  Widget _insightCard(BuildContext context, AnalyticsInsight insight) {
    final color = _insightColor(context, insight.type);
    final icon = _insightIcon(insight.type);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 16, color: Colors.white)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(insight.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: color))),
            Text(insight.value, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 2),
          Text(insight.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ])),
      ]),
    );
  }

  Widget _legendDot(BuildContext context, Color color, {bool dashed = false}) => Container(width: 12, height: 6, decoration: BoxDecoration(color: dashed ? Colors.transparent : color, borderRadius: BorderRadius.circular(3), border: dashed ? Border.all(color: color, width: 1) : null));

  Color _successRateColor(double v) => v >= 80 ? Colors.green : v >= 60 ? Colors.orange : Colors.red;
  Color _consistencyColor(double c) => c >= 0.8 ? Colors.green : c >= 0.5 ? Colors.orange : Colors.red;
  Color _insightColor(BuildContext context, InsightType t) => switch (t) {
        InsightType.achievement => Colors.green,
        InsightType.improvement => Colors.blue,
        InsightType.warning => Colors.orange,
        InsightType.recommendation => Theme.of(context).colorScheme.primary,
        InsightType.trend => Colors.purple,
      };
  IconData _insightIcon(InsightType t) => switch (t) {
        InsightType.achievement => Icons.emoji_events,
        InsightType.improvement => Icons.trending_up,
        InsightType.warning => Icons.warning,
        InsightType.recommendation => Icons.lightbulb,
        InsightType.trend => Icons.insights,
      };
  String _formatHour(int h) {
    if (h == 0) return '12 AM';
    if (h < 12) return '$h AM';
    if (h == 12) return '12 PM';
    return '${h - 12} PM';
  }
}