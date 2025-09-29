import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focus_field/models/silence_data.dart';
import 'package:focus_field/widgets/feature_gate.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:focus_field/services/advanced_analytics_service.dart';
import 'package:focus_field/utils/debug_log.dart';

/// Tabbed widget combining Practice Overview and Advanced Analytics
/// Saves significant vertical space while maintaining full functionality
class TabbedOverviewWidget extends ConsumerStatefulWidget {
  final SilenceData silenceData;

  const TabbedOverviewWidget({
    super.key,
    required this.silenceData,
  });

  @override
  ConsumerState<TabbedOverviewWidget> createState() => _TabbedOverviewWidgetState();
}

class _TabbedOverviewWidgetState extends ConsumerState<TabbedOverviewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // Rebuild to update content height
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dramatic = theme.extension<DramaticThemeStyling>();
    final hasPremium = ref.watch(premiumAccessProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: dramatic?.cardBackgroundGradient,
        color: dramatic?.cardBackgroundGradient == null
            ? theme.colorScheme.surface
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dramatic != null
              ? theme.colorScheme.primary.withValues(alpha: 0.55)
              : theme.colorScheme.primary.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: dramatic != null
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Custom Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Overview Tab
                Expanded(
                  child: _buildTabButton(
                    context: context,
                    index: 0,
                    icon: Icons.insights,
                    label: 'Overview',
                    isSelected: _tabController.index == 0,
                    onTap: () => _tabController.animateTo(0),
                  ),
                ),

                // Analytics Tab
                Expanded(
                  child: _buildTabButton(
                    context: context,
                    index: 1,
                    icon: Icons.analytics,
                    label: 'Analytics',
                    isSelected: _tabController.index == 1,
                    isPremium: true,
                    isLocked: !hasPremium,
                    onTap: () => _handleAnalyticsTab(context),
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          SizedBox(
            height: _getContentHeight(),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview Tab Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildOverviewContent(context),
                ),

                // Analytics Tab Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: hasPremium
                      ? _buildAnalyticsContent(context)
                      : _buildPremiumPlaceholder(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPremium = false,
    bool isLocked = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLocked ? Icons.lock : icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isLocked
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                      : theme.colorScheme.onSurface),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : (isLocked
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : theme.colorScheme.onSurface),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPremium && !isLocked) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PRO',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleAnalyticsTab(BuildContext context) {
    final hasPremium = ref.read(premiumAccessProvider);

    if (hasPremium) {
      _tabController.animateTo(1);
    } else {
      // Show paywall for premium feature
      showPaywall(
        context,
        featureDescription: 'Detailed trends and insights',
      );
    }
  }

  Widget _buildOverviewContent(BuildContext context) {
    // Use the same layout as PracticeOverviewWidget: stats and chart side by side
    final theme = Theme.of(context);
    final dramatic = theme.extension<DramaticThemeStyling>();

    final statsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final entry in [
          (
            widget.silenceData.totalPoints.toString(),
            'Points',
            Icons.stars,
            (dramatic?.statAccentColors != null &&
                    dramatic!.statAccentColors!.isNotEmpty)
                ? dramatic.statAccentColors![0]
                : theme.colorScheme.primary,
          ),
          (
            widget.silenceData.currentStreak.toString(),
            'Streak',
            Icons.local_fire_department,
            (dramatic?.statAccentColors != null &&
                    dramatic!.statAccentColors!.length > 1)
                ? dramatic.statAccentColors![1]
                : theme.colorScheme.secondary,
          ),
          (
            widget.silenceData.totalSessions.toString(),
            'Sessions',
            Icons.play_circle,
            (dramatic?.statAccentColors != null &&
                    dramatic!.statAccentColors!.length > 2)
                ? dramatic.statAccentColors![2]
                : theme.colorScheme.tertiary,
          ),
        ]) ...[
          Flexible(
            child: _buildCompactStat(
              context,
              entry.$1,
              entry.$2,
              entry.$3,
              entry.$4,
            ),
          ),
        ],
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats take remaining width
        Expanded(flex: 5, child: statsRow),
        const SizedBox(width: 12),
        // Chart given a fixed min width suitable for seven bars
        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.topRight,
            child: _build7DayChart(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsContent(BuildContext context) {
    try {
      final svc = AdvancedAnalyticsService.instance;
      final metrics = svc.calculatePerformanceMetrics(widget.silenceData);
      final insights = svc.generateInsights(widget.silenceData);
      final trends = svc.generateWeeklyTrends(widget.silenceData);

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance Metrics - compact version
            _buildPerformanceMetrics(context, metrics),

            if (trends.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTrendsChart(context, trends),
            ],

            if (insights.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInsights(context, insights),
            ],
          ],
        ),
      );
    } catch (e, st) {
      DebugLog.error('TabbedOverviewWidget analytics failed', e, st);
      return _buildAnalyticsError(context);
    }
  }

  Widget _buildPremiumPlaceholder(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Advanced Analytics',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Detailed trends and insights',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => showPaywall(
              context,
              featureDescription: 'Detailed trends and insights',
            ),
            child: const Text('Upgrade to Pro'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 3),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }

  Widget _build7DayChart(BuildContext context) {
    final theme = Theme.of(context);
    final last7Days = _getLast7DaysActivity();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double maxBarVisualHeight = 20;
        const double labelFontSize = 10.0;
        const double spacingBelowBar = 2.0;
        const double safetyBuffer = 6.0;
        const double barAreaHeight =
            maxBarVisualHeight + labelFontSize + spacingBelowBar + safetyBuffer;
        final maxPoints = _getMaxDayPoints();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Last 7 Days',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: barAreaHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final dayData in last7Days) ...[
                      _DayBar(
                        label: dayData.dayLabel,
                        points: dayData.points,
                        maxPoints: maxPoints,
                        maxBarHeight: maxBarVisualHeight,
                        theme: theme,
                      ),
                      if (dayData != last7Days.last) const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<DayActivity> _getLast7DaysActivity() {
    final now = DateTime.now();
    final last7Days = <DayActivity>[];

    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayOfWeek = date.weekday % 7;

      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayPoints = widget.silenceData.recentSessions
          .where(
            (session) =>
                session.date.isAfter(dayStart) &&
                session.date.isBefore(dayEnd) &&
                session.completed,
          )
          .fold(0, (sum, session) => sum + session.pointsEarned);

      last7Days.add(
        DayActivity(
          date: date,
          points: dayPoints,
          dayLabel: dayLabels[dayOfWeek],
        ),
      );
    }

    return last7Days;
  }

  int _getMaxDayPoints() {
    final last7Days = _getLast7DaysActivity();
    final maxPoints = last7Days
        .map((day) => day.points)
        .reduce((a, b) => a > b ? a : b);
    return maxPoints > 0 ? maxPoints : 1;
  }

  double _getContentHeight() {
    // Return appropriate height based on current tab
    if (_tabController.index == 1) {
      // Analytics tab needs much more height for full content
      return 500.0; // Much taller for full analytics content
    }
    return 80.0; // Compact height for overview tab
  }

  Widget _buildPerformanceMetrics(BuildContext context, PerformanceMetrics m) {
    final theme = Theme.of(context);
    final dramatic = theme.extension<DramaticThemeStyling>();
    final isNeon = dramatic != null &&
        dramatic.statAccentColors != null &&
        dramatic.statAccentColors!.contains(const Color(0xFF00F5FF));

    String localizedPreferredDuration(String key) {
      return switch (key) {
        'bucket1to2' => '1-2 min',
        'bucket3to5' => '3-5 min',
        'bucket6to10' => '6-10 min',
        'bucket11to20' => '11-20 min',
        'bucket21to30' => '21-30 min',
        'bucket30plus' => '30+ min',
        _ => key,
      };
    }

    final items = [
      _buildMetricCard(
        context,
        label: 'Success Rate',
        value: '${m.overallSuccessRate.toStringAsFixed(1)}%',
        description: 'Completed sessions ratio',
        icon: isNeon ? Icons.check_circle : Icons.check_circle_outline,
        color: _successRateColor(m.overallSuccessRate),
      ),
      _buildMetricCard(
        context,
        label: 'Avg Session',
        value: '${m.averageSessionLength.toStringAsFixed(1)}m',
        description: 'Avg session length (min)',
        icon: isNeon ? Icons.timer : Icons.timer_outlined,
        color: theme.colorScheme.secondary,
      ),
      _buildMetricCard(
        context,
        label: 'Consistency',
        value: '${(m.consistencyScore * 100).toStringAsFixed(0)}%',
        description: 'Day-to-day stability',
        icon: isNeon ? Icons.trending_up : Icons.show_chart,
        color: _consistencyColor(m.consistencyScore),
      ),
      _buildMetricCard(
        context,
        label: 'Best Time',
        value: _formatHour(m.bestTimeOfDay),
        description: 'Most successful hour',
        icon: isNeon ? Icons.schedule : Icons.access_time,
        color: theme.colorScheme.tertiary,
      ),
      _buildMetricCard(
        context,
        label: 'Preferred Duration',
        value: localizedPreferredDuration(m.preferredDuration),
        description: 'Most successful session length',
        icon: isNeon ? Icons.timelapse : Icons.hourglass_bottom,
        color: theme.colorScheme.primary,
      ),
      _buildMetricCard(
        context,
        label: 'Total Points',
        value: '${widget.silenceData.totalPoints}',
        description: 'Points earned to date',
        icon: isNeon ? Icons.stars : Icons.star_outline,
        color: Colors.amber,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        // First row: 3 metrics
        Row(
          children: items.take(3).map((item) => Expanded(child: item)).toList(),
        ),
        const SizedBox(height: 12),
        // Second row: 3 metrics
        Row(
          children: items.skip(3).take(3).map((item) => Expanded(child: item)).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsChart(BuildContext context, List<WeeklyTrend> trends) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    // Calculate moving average
    final ma = <FlSpot>[];
    for (var i = 0; i < trends.length; i++) {
      final w = trends.sublist((i - 2).clamp(0, i), i + 1);
      final avg = w.map((e) => e.successRate).reduce((a, b) => a + b) / w.length;
      ma.add(FlSpot(i.toDouble(), avg));
    }

    // Calculate overall average
    final overall = trends.isEmpty
        ? 0.0
        : trends.map((e) => e.successRate).reduce((a, b) => a + b) / trends.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Trends',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          height: 140, // Taller chart for better visibility
          padding: const EdgeInsets.all(12),
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
                getDrawingHorizontalLine: (v) => FlLine(
                  color: theme.dividerColor.withValues(alpha: 0.15),
                  strokeWidth: 1,
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots
                      .map((p) => LineTooltipItem(
                            '${p.y.toStringAsFixed(1)}%',
                            theme.textTheme.labelSmall!,
                          ))
                      .toList(),
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (v, meta) => Text(
                      '${v.toInt()}%',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= trends.length) return const SizedBox();
                      final d = trends[i].weekStart;
                      return Text(
                        '${d.month}/${d.day}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: trends[i].isMissing ? 0.35 : 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Main trend line
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < trends.length; i++)
                      FlSpot(i.toDouble(), trends[i].successRate),
                  ],
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
                          color: primary.withValues(alpha: 0.15),
                          strokeWidth: 1.2,
                          strokeColor: primary.withValues(alpha: 0.5),
                        );
                      }
                      return FlDotCirclePainter(
                        radius: 3.5,
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
                // Moving average line
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
                if (trends.length > 1)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, overall),
                      FlSpot((trends.length - 1).toDouble(), overall),
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
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              _legendDot(context, primary),
              const SizedBox(width: 4),
              const Text('Rate', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 8),
              _legendDot(context, primary.withValues(alpha: 0.55), dashed: true),
              const SizedBox(width: 4),
              const Text('MA(3) Moving Avg', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 8),
              _legendDot(context, theme.colorScheme.secondary.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              const Text('Avg (overall)', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsights(BuildContext context, List<AnalyticsInsight> insights) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Insights',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
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
    final color = _insightColor(context, insight.type);
    final icon = _insightIcon(insight.type);
    final theme = Theme.of(context);

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
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    Text(
                      insight.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsError(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Analytics unavailable',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Data will refresh on next launch',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _successRateColor(double v) =>
      v >= 80 ? Colors.green : v >= 60 ? Colors.orange : Colors.red;

  Color _consistencyColor(double c) =>
      c >= 0.8 ? Colors.green : c >= 0.5 ? Colors.orange : Colors.red;

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
}

class DayActivity {
  final DateTime date;
  final int points;
  final String dayLabel;

  DayActivity({
    required this.date,
    required this.points,
    required this.dayLabel,
  });
}

class _DayBar extends StatelessWidget {
  final String label;
  final int points;
  final int maxPoints;
  final double maxBarHeight;
  final ThemeData theme;

  const _DayBar({
    required this.label,
    required this.points,
    required this.maxPoints,
    required this.maxBarHeight,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxPoints == 0 ? 0.0 : (points / maxPoints).clamp(0.0, 1.0);
    final barHeight = (ratio * maxBarHeight).clamp(2, maxBarHeight);
    final active = points > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: barHeight.toDouble(),
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}