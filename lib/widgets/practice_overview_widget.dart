
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
          color: theme.colorScheme.primary.withOpacity(0.2),
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
    return Row(
      children: [
        // Compact stats section - horizontal layout
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCompactStat(
                context,
                silenceData.totalPoints.toString(),
                'Points',
                Icons.stars,
                Theme.of(context).colorScheme.primary,
              ),
              _buildCompactStat(
                context,
                silenceData.currentStreak.toString(),
                'Streak',
                Icons.local_fire_department,
                Theme.of(context).colorScheme.secondary,
              ),
              _buildCompactStat(
                context,
                silenceData.totalSessions.toString(),
                'Sessions',
                Icons.play_circle,
                Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 7-day activity chart
        Expanded(
          flex: 2,
          child: _build7DayChart(context),
        ),
      ],
    );
  }

  Widget _buildCompactStat(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _build7DayChart(BuildContext context) {
    final theme = Theme.of(context);
    final last7Days = _getLast7DaysActivity();
    
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
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: last7Days.map((dayData) {
              final height = (dayData.points / _getMaxDayPoints()).clamp(0.1, 1.0) * 30;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 8,
                    height: height,
                    decoration: BoxDecoration(
                      color: dayData.points > 0 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayData.dayLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 8,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
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
