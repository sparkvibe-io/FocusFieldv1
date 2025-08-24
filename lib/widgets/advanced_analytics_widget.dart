import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/services/analytics_service.dart';

class AdvancedAnalyticsWidget extends ConsumerWidget {
  final SilenceData silenceData;

  const AdvancedAnalyticsWidget({
    super.key,
    required this.silenceData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsService = AdvancedAnalyticsService.instance;
    final insights = analyticsService.generateInsights(silenceData);
    final metrics = analyticsService.calculatePerformanceMetrics(silenceData);
    final weeklyTrends = analyticsService.generateWeeklyTrends(silenceData);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.analytics,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Row(
          children: [
            Text(
              'Advanced Analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'PREMIUM',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPerformanceMetrics(context, metrics),
                if (weeklyTrends.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildTrendsChart(context, weeklyTrends),
                ],
                if (insights.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildInsights(context, insights),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, PerformanceMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            int count;
            if (w >= 900) {
              count = 4;
            } else if (w >= 600) {
              count = 3;
            } else {
              count = 2;
            }
            final aspect = w >= 900 ? 2.8 : (w >= 600 ? 2.6 : 2.4);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              childAspectRatio: aspect,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              children: [
            _buildMetricCard(
              context,
              'Success Rate',
              '${metrics.overallSuccessRate.toStringAsFixed(1)}%',
              Icons.check_circle_outline,
              _getSuccessRateColor(context, metrics.overallSuccessRate),
            ),
            _buildMetricCard(
              context,
              'Avg Session',
              '${metrics.averageSessionLength.toStringAsFixed(1)}m',
              Icons.timer_outlined,
              Theme.of(context).colorScheme.secondary,
            ),
            _buildMetricCard(
              context,
              'Consistency',
              '${(metrics.consistencyScore * 100).toStringAsFixed(0)}%',
              Icons.trending_up,
              _getConsistencyColor(context, metrics.consistencyScore),
            ),
            _buildMetricCard(
              context,
              'Best Time',
              _formatHour(metrics.bestTimeOfDay),
              Icons.schedule,
              Theme.of(context).colorScheme.tertiary,
            ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsChart(BuildContext context, List<WeeklyTrend> trends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Trends',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < trends.length) {
                        final date = trends[index].weekStart;
                        return Text(
                          '${date.month}/${date.day}',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: trends.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.successRate);
                  }).toList(),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
              minY: 0,
              maxY: 100,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsights(BuildContext context, List<AnalyticsInsight> insights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Insights',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...insights.take(3).map((insight) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildInsightCard(context, insight),
        )),
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, AnalyticsInsight insight) {
    final color = _getInsightColor(context, insight.type);
    final icon = _getInsightIcon(insight.type);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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

  Color _getSuccessRateColor(BuildContext context, double successRate) {
    if (successRate >= 80) return Colors.green;
    if (successRate >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getConsistencyColor(BuildContext context, double consistency) {
    if (consistency >= 0.8) return Colors.green;
    if (consistency >= 0.5) return Colors.orange;
    return Colors.red;
  }

  Color _getInsightColor(BuildContext context, InsightType type) {
    switch (type) {
      case InsightType.achievement:
        return Colors.green;
      case InsightType.improvement:
        return Colors.blue;
      case InsightType.warning:
        return Colors.orange;
      case InsightType.recommendation:
        return Theme.of(context).colorScheme.primary;
      case InsightType.trend:
        return Colors.purple;
    }
  }

  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.achievement:
        return Icons.emoji_events;
      case InsightType.improvement:
        return Icons.trending_up;
      case InsightType.warning:
        return Icons.warning;
      case InsightType.recommendation:
        return Icons.lightbulb;
      case InsightType.trend:
        return Icons.insights;
    }
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
} 