import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/services/advanced_analytics_service.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:focus_field/utils/debug_log.dart';

class AdvancedAnalyticsWidget extends ConsumerWidget {
  final SilenceData silenceData;
  /// Whether to show the title row with "Advanced Analytics" and "PREMIUM" badge.
  /// Set to false when used within a context where the title is already shown (e.g., Advanced tab).
  final bool showTitle;
  
  const AdvancedAnalyticsWidget({
    super.key,
    required this.silenceData,
    this.showTitle = true,
  });

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

      // Content to display (metrics, trends, insights)
      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 40/60 split: Performance Metrics + Weekly Trends
          _buildMetricsAndTrendsRow(context, metrics, trends, compact: compact),
          // Best Time by Activity section
          if (metrics.bestTimeByActivity.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildBestTimeByActivity(context, metrics.bestTimeByActivity),
          ],
          // Insights section
          if (insights.isNotEmpty) ...[
            const SizedBox(height: 16),
            _insights(context, insights, compact: compact),
          ],
        ],
      );

      // If showTitle is false, return content directly without the container/title
      if (!showTitle) {
        return content;
      }

      // Otherwise, wrap in styled container with ExpansionTile title
      return Container(
        decoration: BoxDecoration(
          gradient: dramatic?.cardBackgroundGradient,
          color:
              dramatic?.cardBackgroundGradient == null
                  ? Theme.of(context).colorScheme.surface
                  : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          leading: Icon(
            Icons.analytics,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.advancedAnalytics,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.premiumBadge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          children: [content],
        ),
      );
    } catch (e, st) {
      DebugLog.error('AdvancedAnalyticsWidget build failed', e, st);
      return _fallbackErrorContainer(context);
    }
  }

  /// 40/60 split: Performance Metrics (left) + Weekly Trends (right)
  /// Wraps on small screens for better mobile experience
  Widget _buildMetricsAndTrendsRow(
    BuildContext context,
    PerformanceMetrics metrics,
    List<WeeklyTrend> trends, {
    required bool compact,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final shouldWrap = screenWidth < 600; // Wrap on phones

    if (shouldWrap) {
      // Vertical stack on small screens
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceMetricsVertical(context, metrics),
          if (trends.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildWeeklyTrendsChart(context, trends, compact: compact),
          ],
        ],
      );
    }

    // Horizontal 40/60 split on larger screens
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left 40%: Performance Metrics (vertical list)
        Expanded(
          flex: 40,
          child: _buildPerformanceMetricsVertical(context, metrics),
        ),
        const SizedBox(width: 16),
        // Right 60%: Weekly Trends
        if (trends.isNotEmpty)
          Expanded(
            flex: 60,
            child: _buildWeeklyTrendsChart(context, trends, compact: compact),
          ),
      ],
    );
  }

  /// Performance Metrics as vertical list (no grid)
  Widget _buildPerformanceMetricsVertical(
    BuildContext context,
    PerformanceMetrics m,
  ) {
    final theme = Theme.of(context);
    
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
          }
          as String;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.performanceMetrics,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        
        // Vertical list of metrics
        _buildMetricRow(
          context,
          icon: Icons.check_circle_outline,
          label: AppLocalizations.of(context)!.successRate,
          value: '${m.overallSuccessRate.toStringAsFixed(1)}%',
          color: _successRateColor(m.overallSuccessRate),
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          context,
          icon: Icons.timer_outlined,
          label: AppLocalizations.of(context)!.avgSession,
          value: '${m.averageSessionLength.toStringAsFixed(1)}m',
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          context,
          icon: Icons.show_chart,
          label: AppLocalizations.of(context)!.consistency,
          value: '${(m.consistencyScore * 100).toStringAsFixed(0)}%',
          color: _consistencyColor(m.consistencyScore),
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          context,
          icon: Icons.hourglass_bottom,
          label: 'Preferred Duration',
          value: localizedPreferredDuration(m.preferredDuration),
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  /// Single metric row: icon + label + value
  Widget _buildMetricRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        // Circular icon container
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        // Label
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Value
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Best Time by Activity widget - shows per-activity best times
  Widget _buildBestTimeByActivity(BuildContext context, Map<String, int> bestTimeByActivity) {
    final theme = Theme.of(context);
    
    if (bestTimeByActivity.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Best Time by Activity',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: bestTimeByActivity.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildActivityTimeRow(
                  context,
                  activityId: entry.key,
                  hour: entry.value,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Individual activity time row
  Widget _buildActivityTimeRow(
    BuildContext context, {
    required String activityId,
    required int hour,
  }) {
    final theme = Theme.of(context);
    final icon = _getActivityIcon(activityId);
    final color = _getActivityColor(activityId);
    final name = _getActivityName(activityId);
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          _formatHour(hour),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Activity helper methods
  IconData _getActivityIcon(String activityId) {
    switch (activityId.toLowerCase()) {
      case 'study':
      case 'studying':
        return Icons.school_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      case 'meditation':
        return Icons.self_improvement_outlined;
      case 'other':
        return Icons.star_outline;
      case 'work':
        return Icons.work_outline;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'family':
        return Icons.people_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getActivityColor(String activityId) {
    switch (activityId.toLowerCase()) {
      case 'study':
      case 'studying':
        return const Color(0xFF8B9DC3); // Soft blue-gray
      case 'reading':
        return const Color(0xFF7BA7BC); // Muted teal-blue
      case 'meditation':
        return const Color(0xFF86B489); // Sage green
      case 'other':
        return const Color(0xFFC4A57B); // Muted amber
      case 'work':
        return const Color(0xFFC6927E); // Muted terracotta
      case 'fitness':
        return const Color(0xFFFA114F); // Pink-red
      case 'family':
        return const Color(0xFF9B59B6); // Purple
      default:
        return Colors.grey;
    }
  }

  String _getActivityName(String activityId) {
    switch (activityId.toLowerCase()) {
      case 'study':
      case 'studying':
        return 'Study';
      case 'reading':
        return 'Reading';
      case 'meditation':
        return 'Meditation';
      case 'other':
        return 'Other';
      case 'work':
        return 'Work';
      case 'fitness':
        return 'Fitness';
      case 'family':
        return 'Family';
      default:
        return activityId;
    }
  }

  /// Weekly Trends Chart with simplified X-axis (week numbers)
  /// Shows up to 8 weeks of data with MA(3) moving average
  Widget _buildWeeklyTrendsChart(
    BuildContext context,
    List<WeeklyTrend> trends, {
    required bool compact,
  }) {
    // Limit to last 8 weeks
    final displayTrends = trends.length > 8 ? trends.sublist(trends.length - 8) : trends;
    
    // Calculate MA(3) moving average
    final ma = <FlSpot>[];
    for (var i = 0; i < displayTrends.length; i++) {
      final w = displayTrends.sublist((i - 2).clamp(0, i), i + 1);
      final avg =
          w.map((e) => e.successRate).reduce((a, b) => a + b) / w.length;
      ma.add(FlSpot(i.toDouble(), avg));
    }
    
    // Calculate overall average
    final overall =
        displayTrends.isEmpty
            ? 0.0
            : displayTrends.map((e) => e.successRate).reduce((a, b) => a + b) /
                displayTrends.length;
    
    final primary = Theme.of(context).colorScheme.primary;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.weeklyTrends,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: compact ? 8 : 12),
        Container(
          height: compact ? 120 : 150,
          padding: EdgeInsets.all(compact ? 8 : 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine:
                    (v) => FlLine(
                      color: theme.dividerColor.withValues(alpha: 0.15),
                      strokeWidth: 1,
                    ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems:
                      (spots) =>
                          spots
                              .map(
                                (p) => LineTooltipItem(
                                  '${p.y.toStringAsFixed(1)}%',
                                  theme.textTheme.labelSmall!,
                                ),
                              )
                              .toList(),
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget:
                        (v, meta) => Text(
                          '${v.toInt()}%',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: 1,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= displayTrends.length) return const SizedBox();
                      
                      // Show as W1, W2, W3, etc. (week number relative to display)
                      return Text(
                        'W${i + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: displayTrends[i].isMissing ? 0.35 : 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Main success rate line
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < displayTrends.length; i++)
                      FlSpot(i.toDouble(), displayTrends[i].successRate),
                  ],
                  isCurved: true,
                  color: primary,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, p, bar, index) {
                      final t = displayTrends[spot.x.toInt()];
                      if (t.isMissing) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: primary.withValues(alpha: 0.15),
                          strokeWidth: 1,
                          strokeColor: primary.withValues(alpha: 0.5),
                        );
                      }
                      return FlDotCirclePainter(
                        radius: 3,
                        color: primary,
                        strokeWidth: 0,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: primary.withValues(alpha: 0.10),
                  ),
                ),
                // MA(3) moving average line
                if (ma.length > 2)
                  LineChartBarData(
                    spots: ma,
                    isCurved: true,
                    color: primary.withValues(alpha: 0.55),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [4, 4],
                  ),
                // Overall average line
                if (displayTrends.length > 1)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, overall),
                      FlSpot((displayTrends.length - 1).toDouble(), overall),
                    ],
                    isCurved: false,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                  ),
              ],
            ),
          ),
        ),
        // Legend
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildLegendItem(context, primary, 'Rate'),
              _buildLegendItem(
                context,
                primary.withValues(alpha: 0.55),
                'MA(3)',
                dashed: true,
              ),
              _buildLegendItem(
                context,
                theme.colorScheme.secondary.withValues(alpha: 0.5),
                'Avg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Compact legend item with dot and label
  Widget _buildLegendItem(
    BuildContext context,
    Color color,
    String label, {
    bool dashed = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _legendDot(context, color, dashed: dashed),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9)),
      ],
    );
  }

  Widget _insights(
    BuildContext context,
    List<AnalyticsInsight> insights, {
    required bool compact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: compact ? 8 : 12),
        ...insights
            .take(3)
            .map(
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _insightCard(context, i),
              ),
            ),
      ],
    );
  }

  Widget _insightCard(BuildContext context, AnalyticsInsight insight) {
    final color = _insightColor(context, insight.type);
    final icon = _insightIcon(insight.type);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    Text(
                      insight.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(BuildContext context, Color color, {bool dashed = false}) =>
      Container(
        width: 12,
        height: 6,
        decoration: BoxDecoration(
          color: dashed ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(3),
          border: dashed ? Border.all(color: color, width: 1) : null,
        ),
      );

  Color _successRateColor(double v) =>
      v >= 80
          ? Colors.green
          : v >= 60
          ? Colors.orange
          : Colors.red;
  Color _consistencyColor(double c) =>
      c >= 0.8
          ? Colors.green
          : c >= 0.5
          ? Colors.orange
          : Colors.red;
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
      border: Border.all(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics unavailable',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
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
