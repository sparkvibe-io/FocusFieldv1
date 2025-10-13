import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/silence_data.dart';

/// Compact timeline showing today's sessions as dots on a 24-hour scale
class TodayTimelineWidget extends StatelessWidget {
  final List<SessionRecord> sessions;
  final double height;

  const TodayTimelineWidget({
    super.key,
    required this.sessions,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    // Filter today's sessions
    final todaySessions = sessions
        .where((s) => s.timestamp.isAfter(today) && s.timestamp.isBefore(tomorrow))
        .toList();

    if (todaySessions.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No sessions today',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                return Stack(
                  children: [
                    // Background timeline bar
                    Positioned(
                      left: 0,
                      right: 0,
                      top: height / 2 - 1,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.surfaceContainerHighest,
                              theme.colorScheme.primary.withOpacity(0.3),
                              theme.colorScheme.surfaceContainerHighest,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Session dots
                    ...todaySessions.map((session) {
                      final sessionTime = session.timestamp;
                      final minutesSinceMidnight =
                          sessionTime.hour * 60 + sessionTime.minute;
                      final position = (minutesSinceMidnight / (24 * 60)) * width;

                      return Positioned(
                        left: position - 8,
                        top: height / 2 - 8,
                        child: _SessionDot(
                          session: session,
                          theme: theme,
                        ),
                      );
                    }),

                    // Current time indicator
                    if (now.isAfter(today) && now.isBefore(tomorrow))
                      Positioned(
                        left: _getCurrentTimePosition(now, width) - 1,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12 AM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '6 AM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '12 PM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '6 PM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '11 PM',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getCurrentTimePosition(DateTime now, double width) {
    final minutesSinceMidnight = now.hour * 60 + now.minute;
    return (minutesSinceMidnight / (24 * 60)) * width;
  }
}

class _SessionDot extends StatelessWidget {
  final SessionRecord session;
  final ThemeData theme;

  const _SessionDot({
    required this.session,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm();

    return Tooltip(
      message: '${timeFormat.format(session.timestamp)} • '
          '${session.duration ~/ 60}min • '
          '${session.success ? "✓" : "×"}',
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: session.success
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
          border: Border.all(
            color: theme.colorScheme.surface,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (session.success
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error)
                  .withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: session.success
            ? Icon(
                Icons.check,
                size: 10,
                color: theme.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
