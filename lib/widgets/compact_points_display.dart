import 'package:flutter/material.dart';

class CompactPointsDisplay extends StatelessWidget {
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final int totalSessions;

  const CompactPointsDisplay({
    super.key,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Total Points - Main feature
          Expanded(
            flex: 2,
            child: _buildMainStat(
              context,
              totalPoints.toString(),
              'Total Points',
              Icons.stars,
              theme.colorScheme.primary,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Current Streak
          Expanded(
            child: _buildCompactStat(
              context,
              currentStreak.toString(),
              'Streak',
              Icons.local_fire_department,
              theme.colorScheme.secondary,
            ),
          ),

          // Best Streak
          Expanded(
            child: _buildCompactStat(
              context,
              bestStreak.toString(),
              'Best',
              Icons.emoji_events,
              theme.colorScheme.tertiary,
            ),
          ),

          // Total Sessions
          Expanded(
            child: _buildCompactStat(
              context,
              totalSessions.toString(),
              'Sessions',
              Icons.play_circle,
              theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
