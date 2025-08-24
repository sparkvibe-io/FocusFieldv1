
import 'package:flutter/material.dart';
import 'package:silence_score/models/silence_data.dart';

class PracticeOverviewWidget extends StatelessWidget {
  final SilenceData silenceData;

  const PracticeOverviewWidget({
    super.key,
    required this.silenceData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isNarrow = width < 360;
        final statsRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: _buildCompactStat(
                context,
                silenceData.totalPoints.toString(),
                'Points',
                Icons.stars,
                Theme.of(context).colorScheme.primary,
              ),
            ),
            Flexible(
              child: _buildCompactStat(
                context,
                silenceData.currentStreak.toString(),
                'Streak',
                Icons.local_fire_department,
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            Flexible(
              child: _buildCompactStat(
                context,
                silenceData.totalSessions.toString(),
                'Sessions',
                Icons.play_circle,
                Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        );
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              statsRow,
              const SizedBox(height: 12),
              _build7DayChart(context),
            ],
          );
        }
        return Row(
          children: [
            Flexible(flex: 3, child: statsRow),
            const SizedBox(width: 8),
            Flexible(flex: 2, child: _build7DayChart(context)),
          ],
        );
      },
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
        // Target a compact total height <= 48 (label ~12, spacing 2, bars 32)
        const double barAreaHeight = 32;
        const double maxBarVisualHeight = 20; // within barAreaHeight
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
            style: theme.textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}