
import 'package:flutter/material.dart';
import 'package:silence_score/models/silence_data.dart';
import 'package:silence_score/theme/theme_extensions.dart';

class PracticeOverviewWidget extends StatelessWidget {
  final SilenceData silenceData;

  const PracticeOverviewWidget({
    super.key,
    required this.silenceData,
  });

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final dramatic = theme.extension<DramaticThemeStyling>();
    
    return Container(
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompactHeader(context),
          const SizedBox(height: 8),
          _buildCompactStatsAndChart(context),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.insights,
          color: Theme.of(context).colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          'Practice Overview',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatsAndChart(BuildContext context) {
    // Always place the chart to the right of the stats to conserve vertical space.
    final theme = Theme.of(context);
  final dramatic = theme.extension<DramaticThemeStyling>();
    final statsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final entry in [
          (
            silenceData.totalPoints.toString(),
            'Points',
            Icons.stars,
            (dramatic?.statAccentColors != null && dramatic!.statAccentColors!.isNotEmpty)
                ? dramatic.statAccentColors![0]
                : theme.colorScheme.primary,
          ),
          (
            silenceData.currentStreak.toString(),
            'Streak',
            Icons.local_fire_department,
            (dramatic?.statAccentColors != null && dramatic!.statAccentColors!.length > 1)
                ? dramatic.statAccentColors![1]
                : theme.colorScheme.secondary,
          ),
          (
            silenceData.totalSessions.toString(),
            'Sessions',
            Icons.play_circle,
            (dramatic?.statAccentColors != null && dramatic!.statAccentColors!.length > 2)
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
        // Chart given a fixed min width suitable for seven bars; wraps in Flexible for overflow
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

  Widget _buildCompactStat(BuildContext context, String value, String label, IconData icon, Color color) {
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
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }

  Widget _build7DayChart(BuildContext context) {
    final theme = Theme.of(context);
    final last7Days = _getLast7DaysActivity();
    
    // The chart previously caused a 1px vertical overflow on small layouts because
    // the label + spacing + bar area exceeded the constrained height coming from
    // its parent Row. We reduce the bar area height and allow horizontal scrolling
    // to avoid right overflows on very narrow widths.
    return LayoutBuilder(
      builder: (context, constraints) {
    // Dynamically allocate enough height for bar + spacing + label across devices.
    // (line height varies by font metrics, so we add a small safety buffer.)
    const double maxBarVisualHeight = 20; // visual max for bar itself
    const double labelFontSize = 10.0;
    const double spacingBelowBar = 2.0;
    const double safetyBuffer = 6.0; // accounts for font ascent/descent variance
    final double barAreaHeight =
      maxBarVisualHeight + labelFontSize + spacingBelowBar + safetyBuffer; // ~38
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
              // Allow horizontal scroll if width is too tight for all 7 bars + spacing
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
                      // Horizontal spacing between bars (except last)
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
    
    // Get day labels (S, M, T, W, T, F, S)
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayOfWeek = date.weekday % 7; // Convert to 0-6 (Sunday = 0)
      
      // Calculate points for this day
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final dayPoints = silenceData.recentSessions
          .where((session) => 
              session.date.isAfter(dayStart) && 
              session.date.isBefore(dayEnd) &&
              session.completed)
          .fold(0, (sum, session) => sum + session.pointsEarned);
      
      last7Days.add(DayActivity(
        date: date,
        points: dayPoints,
        dayLabel: dayLabels[dayOfWeek],
      ));
    }
    
    return last7Days;
  }
  
  int _getMaxDayPoints() {
    final last7Days = _getLast7DaysActivity();
    final maxPoints = last7Days.map((day) => day.points).reduce((a, b) => a > b ? a : b);
    return maxPoints > 0 ? maxPoints : 1; // Avoid division by zero
  }
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

// Small reusable widget for an individual day bar to keep build method lean.
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
              height: 1.0, // tighten to reduce risk of overflow
            ),
          ),
        ),
      ],
    );
  }
}