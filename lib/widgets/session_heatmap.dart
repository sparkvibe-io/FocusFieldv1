import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/silence_data.dart';

/// GitHub-style heatmap showing session activity over the past 12 weeks
class SessionHeatmap extends StatelessWidget {
  final List<SessionRecord> sessions;
  final int weeks;

  const SessionHeatmap({
    super.key,
    required this.sessions,
    this.weeks = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate start date (weeks ago, starting from Monday)
    final startDate = _getMondayOfWeek(today.subtract(Duration(days: weeks * 7)));

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        _buildMonthLabels(startDate, weeks, theme),
        const SizedBox(height: 8),

        // Heatmap grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day labels (Mon, Wed, Fri)
            _buildDayLabels(theme),
            const SizedBox(width: 8),

            // Grid of weeks
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(weeks, (weekIndex) {
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
                  );
                },
              ),
            ),
          ],
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

    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
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
    final intensity = minutes == 0 ? 0.0 : (minutes / maxMinutes).clamp(0.2, 1.0);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Tooltip(
      message: '${dateFormat.format(date)}\n$minutes minutes',
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: minutes == 0
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.primary.withOpacity(intensity),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: intensity == 0
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primary.withOpacity(intensity),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 0.5,
        ),
      ),
    );
  }

  DateTime _getMondayOfWeek(DateTime date) {
    final weekday = date.weekday;
    final monday = date.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }
}
