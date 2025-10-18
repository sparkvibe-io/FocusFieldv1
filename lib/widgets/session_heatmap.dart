import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/silence_data.dart';

/// GitHub-style heatmap showing session activity over the past 2 months (or current month if new user)
class SessionHeatmap extends StatelessWidget {
  final List<SessionRecord> sessions;
  final int? weeks;

  const SessionHeatmap({
    super.key,
    required this.sessions,
    this.weeks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Determine appropriate number of weeks to show
    final weeksToShow = weeks ?? _determineWeeksToShow(today);

    // Calculate start date (weeks ago, starting from Monday)
    // Subtract (weeksToShow - 1) weeks to include the current week
    final startDate = _getMondayOfWeek(today.subtract(Duration(days: (weeksToShow - 1) * 7)));

    // Build a map of date -> total minutes
    final Map<DateTime, int> dailyMinutes = {};
    for (final session in sessions) {
      final date = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );
      if (date.isBefore(startDate) || date.isAfter(today)) continue;

      dailyMinutes[date] = (dailyMinutes[date] ?? 0) + (session.duration ~/ 60);
    }

    // Find max minutes for color scaling
    final maxMinutes = dailyMinutes.values.isEmpty
        ? 1
        : dailyMinutes.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Month labels
        _buildMonthLabels(startDate, weeksToShow, theme),
        const SizedBox(height: 8),

        // Heatmap grid - centered
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Day labels (Mon, Wed, Fri)
              _buildDayLabels(theme),
              const SizedBox(width: 8),

              // Grid of weeks
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(weeksToShow, (weekIndex) {
                    final weekStart = startDate.add(Duration(days: weekIndex * 7));
                    return _buildWeekColumn(
                      context,
                      weekStart,
                      dailyMinutes,
                      maxMinutes,
                      theme,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Legend
        _buildLegend(theme),
      ],
    );
  }

  Widget _buildMonthLabels(DateTime startDate, int weeks, ThemeData theme) {
    final labels = <String>[];
    String? lastMonth;

    for (var i = 0; i < weeks; i++) {
      final weekStart = startDate.add(Duration(days: i * 7));
      final month = DateFormat('MMM').format(weekStart);
      if (month != lastMonth) {
        labels.add(month);
        lastMonth = month;
      } else {
        labels.add('');
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: labels
              .map((label) => SizedBox(
                    width: 16,
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDayLabels(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _dayLabel('Mon', theme),
        _dayLabel('', theme), // Tue
        _dayLabel('Wed', theme),
        _dayLabel('', theme), // Thu
        _dayLabel('Fri', theme),
        _dayLabel('', theme), // Sat
        _dayLabel('', theme), // Sun
      ],
    );
  }

  Widget _dayLabel(String text, ThemeData theme) {
    return SizedBox(
      height: 14,
      width: 32,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: theme.textTheme.labelSmall,
        ),
      ),
    );
  }

  Widget _buildWeekColumn(
    BuildContext context,
    DateTime weekStart,
    Map<DateTime, int> dailyMinutes,
    int maxMinutes,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(
        children: List.generate(7, (dayIndex) {
          final date = weekStart.add(Duration(days: dayIndex));
          final minutes = dailyMinutes[date] ?? 0;
          return _buildDaySquare(context, date, minutes, maxMinutes, theme);
        }),
      ),
    );
  }

  Widget _buildDaySquare(
    BuildContext context,
    DateTime date,
    int minutes,
    int maxMinutes,
    ThemeData theme,
  ) {
    // More vibrant colors: higher minimum intensity and blended colors
    final intensity = minutes == 0 ? 0.0 : (minutes / maxMinutes).clamp(0.5, 1.0);
    final dateFormat = DateFormat('MMM d, yyyy');

    // Create vibrant color by blending primary with surface
    final Color squareColor;
    if (minutes == 0) {
      // Empty state: subtle but visible outline style (GitHub-like)
      squareColor = theme.colorScheme.surfaceContainerHighest;
    } else {
      // Blend primary color with surface for vibrant look
      squareColor = Color.lerp(
        theme.colorScheme.primary.withValues(alpha: 0.5),
        theme.colorScheme.primary,
        intensity,
      )!;
    }

    return Tooltip(
      message: '${dateFormat.format(date)}\n$minutes minutes',
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: squareColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            // Empty squares have more visible border (GitHub-style)
            color: minutes == 0
                ? theme.colorScheme.outline.withValues(alpha: 0.4)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: minutes == 0 ? 1.0 : 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        _legendSquare(theme, 0.0),
        _legendSquare(theme, 0.25),
        _legendSquare(theme, 0.5),
        _legendSquare(theme, 0.75),
        _legendSquare(theme, 1.0),
        const SizedBox(width: 6),
        Text(
          'More',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _legendSquare(ThemeData theme, double intensity) {
    // Match the vibrant color scheme from _buildDaySquare
    final Color squareColor;
    if (intensity == 0) {
      squareColor = theme.colorScheme.surfaceContainerHighest;
    } else {
      squareColor = Color.lerp(
        theme.colorScheme.primary.withValues(alpha: 0.5),
        theme.colorScheme.primary,
        intensity,
      )!;
    }

    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: squareColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          // Empty legend square has more visible border
          color: intensity == 0
              ? theme.colorScheme.outline.withValues(alpha: 0.4)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: intensity == 0 ? 1.0 : 0.5,
        ),
      ),
    );
  }

  /// Determines optimal weeks to show: Always 12 weeks (3 months)
  /// Shows empty squares for dates without data, providing consistent view
  int _determineWeeksToShow(DateTime today) {
    // Always show 12 weeks ending with current week (3-month view)
    // New users see empty squares, established users see colored squares
    // This provides a consistent, predictable view
    return 12;
  }

  DateTime _getMondayOfWeek(DateTime date) {
    final weekday = date.weekday;
    final monday = date.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }
}
