import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/services/advanced_analytics_service.dart';
import 'package:silence_score/l10n/app_localizations.dart';
import 'package:silence_score/theme/theme_extensions.dart';
import 'package:silence_score/utils/debug_log.dart';

class AdvancedAnalyticsWidget extends ConsumerWidget {
  final SilenceData silenceData;
  const AdvancedAnalyticsWidget({super.key, required this.silenceData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final svc = AdvancedAnalyticsService.instance;
      final metrics = svc.calculatePerformanceMetrics(silenceData);
      final insights = svc.generateInsights(silenceData);
      final trends = svc.generateWeeklyTrends(silenceData);
      // Compact layout currently always true; kept as variable for future expansion.
      const compact = true;

      final dramatic = Theme.of(context).extension<DramaticThemeStyling>();

      return Container(
        decoration: BoxDecoration(
          gradient: dramatic?.cardBackgroundGradient,
          color: dramatic?.cardBackgroundGradient == null
              ? Theme.of(context).colorScheme.surface
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          leading: Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
          title: Row(children: [
            Expanded(
              child: Text(AppLocalizations.of(context)!.advancedAnalytics, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(AppLocalizations.of(context)!.premiumBadge, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
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
    } catch (e, st) {
      DebugLog.error('AdvancedAnalyticsWidget build failed', e, st);
      return _fallbackErrorContainer(context);
    }
  }

  Widget _performanceMetrics(BuildContext context, PerformanceMetrics m, {required bool compact}) {
    final themeMode = Theme.of(context).extension<DramaticThemeStyling>();
    final isNeon = themeMode != null && themeMode.statAccentColors != null && themeMode.statAccentColors!.contains(const Color(0xFF00F5FF));
    String localizedPreferredDuration(String key) {
      final l = AppLocalizations.of(context);
      if (l == null) return key;
      final dyn = l as dynamic;
      return switch (key) {
        'bucket1to2' => (dyn.bucket1to2 ?? '1-2 min'),
        'bucket3to5' => (dyn.bucket3to5 ?? '3-5 min'),
        'bucket6to10' => (dyn.bucket6to10 ?? '6-10 min'),
        'bucket11to20' => (dyn.bucket11to20 ?? '11-20 min'),
        'bucket21to30' => (dyn.bucket21to30 ?? '21-30 min'),
        'bucket30plus' => (dyn.bucket30plus ?? '30+ min'),
        _ => key,
      } as String;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.performanceMetrics, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: compact ? 8 : 12),
        LayoutBuilder(builder: (context, constraints) {
          final w = constraints.maxWidth;
          final twoCol = w < 720;
          final itemSpacing = 12.0;
          final items = [
            _metricCard(
              context,
              label: AppLocalizations.of(context)!.successRate,
              value: '${m.overallSuccessRate.toStringAsFixed(1)}%',
              description: 'Completed sessions ratio',
              icon: isNeon ? Icons.check_circle : Icons.check_circle_outline,
              color: _successRateColor(m.overallSuccessRate),
              compact: compact,
            ),
            _metricCard(
              context,
              label: AppLocalizations.of(context)!.avgSession,
              value: '${m.averageSessionLength.toStringAsFixed(1)}m',
              description: 'Avg session length (min)',
              icon: isNeon ? Icons.timer : Icons.timer_outlined,
              color: Theme.of(context).colorScheme.secondary,
              compact: compact,
            ),
            _metricCard(
              context,
              label: AppLocalizations.of(context)!.consistency,
              value: '${(m.consistencyScore * 100).toStringAsFixed(0)}%',
              description: 'Day-to-day stability',
              icon: isNeon ? Icons.trending_up : Icons.show_chart,
              color: _consistencyColor(m.consistencyScore),
              compact: compact,
            ),
            _metricCard(
              context,
              label: AppLocalizations.of(context)!.bestTime,
              value: _formatHour(m.bestTimeOfDay),
              description: 'Most successful hour',
              icon: isNeon ? Icons.schedule : Icons.access_time,
              color: Theme.of(context).colorScheme.tertiary,
              compact: compact,
            ),
            _metricCard(
              context,
              label: 'Preferred Duration',
              value: localizedPreferredDuration(m.preferredDuration),
              description: 'Most successful session length',
              icon: isNeon ? Icons.timelapse : Icons.hourglass_bottom,
              color: Theme.of(context).colorScheme.primaryContainer,
              compact: compact,
            ),
          ];
          if (twoCol) {
            return Column(children: [
              Row(children: [Expanded(child: items[0]), SizedBox(width: itemSpacing), Expanded(child: items[1])]),
              SizedBox(height: itemSpacing),
              Row(children: [Expanded(child: items[2]), SizedBox(width: itemSpacing), Expanded(child: items[3])]),
              SizedBox(height: itemSpacing),
              Row(children: [Expanded(child: items[4])]),
            ]);
          }
          return Wrap(
            spacing: itemSpacing,
            runSpacing: itemSpacing,
            children: items.map((e) => SizedBox(width: (w - itemSpacing * 4) / 5, child: e)).toList(),
          );
        }),
      ],
    );
  }

  Widget _metricCard(BuildContext context, {required String label, required String value, required String description, required IconData icon, required Color color, required bool compact}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 10 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.75),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
    final primary = Theme.of(context).colorScheme.primary;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Text(AppLocalizations.of(context)!.weeklyTrends, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
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
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 20, getTitlesWidget: (v, meta) {
              final i = v.toInt();
              if (i < 0 || i >= trends.length) return const SizedBox();
              final d = trends[i].weekStart;
              return Text('${d.month}/${d.day}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(trends[i].isMissing ? 0.35 : 1)));
            })),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < trends.length; i++) FlSpot(i.toDouble(), trends[i].successRate)],
              isCurved: true,
              color: primary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, p, bar, index) {
                  final t = trends[spot.x.toInt()];
                  if (t.isMissing) {
                    return FlDotCirclePainter(
                      radius: 3.5,
                      color: primary.withOpacity(0.15),
                      strokeWidth: 1.2,
                      strokeColor: primary.withOpacity(0.5),
                    );
                  }
                  return FlDotCirclePainter(radius: 3.5, color: primary, strokeWidth: 0);
                },
              ),
              belowBarData: BarAreaData(show: true, color: primary.withOpacity(0.10)),
            ),
            if (ma.length > 2)
              LineChartBarData(
                  spots: ma,
                  isCurved: true,
                  color: primary.withOpacity(0.55),
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  dashArray: [4, 4]),
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
          _legendDot(context, primary), const SizedBox(width: 4), const Text('Rate', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8), _legendDot(context, primary.withOpacity(0.55), dashed: true), const SizedBox(width: 4), const Text('MA(3) Moving Avg', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 8), _legendDot(context, Theme.of(context).colorScheme.secondary.withOpacity(0.5)), const SizedBox(width: 4), const Text('Avg (overall)', style: TextStyle(fontSize: 10)),
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

  Widget _fallbackErrorContainer(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics unavailable',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'We\'ll attempt to restore this section on the next app launch.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}