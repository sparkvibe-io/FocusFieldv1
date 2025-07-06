import 'package:flutter/material.dart';
import 'package:silence_score/constants/app_constants.dart';

class ScoreCard extends StatelessWidget {
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;

  const ScoreCard({
    super.key,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Main score row
            _buildScoreRow(
              context,
              AppConstants.totalPointsLabel,
              totalPoints.toString(),
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            
            // Streak information
            Row(
              children: [
                Expanded(
                  child: _buildScoreItem(
                    context,
                    AppConstants.currentStreakLabel,
                    currentStreak.toString(),
                    theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreItem(
                    context,
                    AppConstants.bestStreakLabel,
                    bestStreak.toString(),
                    theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Additional statistics
            _buildAdditionalStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAdditionalStats(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Divider(color: theme.colorScheme.outline),
        const SizedBox(height: 12),
        
        // Performance indicators
        Row(
          children: [
            Expanded(
              child: _buildStatIndicator(
                context,
                'Success Rate',
                _calculateSuccessRate(),
                Icons.check_circle,
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatIndicator(
                context,
                'Avg. Session',
                '${AppConstants.silenceDurationSeconds}s',
                Icons.timer,
                theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Streak status
        _buildStreakStatus(context),
      ],
    );
  }

  Widget _buildStatIndicator(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStatus(BuildContext context) {
    final theme = Theme.of(context);
    
    String statusText;
    Color statusColor;
    IconData statusIcon;
    
    if (currentStreak == 0) {
      statusText = 'Start your streak today!';
      statusColor = theme.colorScheme.onSurfaceVariant;
      statusIcon = Icons.play_arrow;
    } else if (currentStreak == bestStreak) {
      statusText = 'New best streak! 🎉';
      statusColor = theme.colorScheme.primary;
      statusIcon = Icons.emoji_events;
    } else if (currentStreak >= 3) {
      statusText = 'Great momentum! 🔥';
      statusColor = theme.colorScheme.secondary;
      statusIcon = Icons.local_fire_department;
    } else {
      statusText = 'Keep it up! 💪';
      statusColor = theme.colorScheme.tertiary;
      statusIcon = Icons.fitness_center;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            size: 20,
            color: statusColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              statusText,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateSuccessRate() {
    // This is a simplified calculation
    // In a real app, you'd track total attempts vs successes
    if (totalPoints == 0) return '0%';
    
    // Assuming a reasonable success rate based on points
    // This is just for demonstration - real implementation would track actual attempts
    final estimatedAttempts = totalPoints + (totalPoints * 0.3).round(); // Assume 30% failure rate
    final successRate = (totalPoints / estimatedAttempts * 100).round();
    return '$successRate%';
  }
} 