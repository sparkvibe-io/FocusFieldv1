import 'package:flutter/material.dart';
import 'package:silence_score/models/silence_data.dart';

// Session history and achievements widget
class SessionHistoryCard extends StatelessWidget {
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPlayDate;
  final int totalSessions;
  final double averageScore;
  final List<SessionRecord> recentSessions;

  const SessionHistoryCard({
    super.key,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    this.lastPlayDate,
    required this.totalSessions,
    required this.averageScore,
    required this.recentSessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Session History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Achievement badges
            _buildAchievementBadges(context),
            
            const SizedBox(height: 16),
            
            // Recent sessions
            if (recentSessions.isNotEmpty) ...[
              Divider(color: theme.colorScheme.outline),
              const SizedBox(height: 8),
              _buildRecentSessions(context),
            ],
            
            const SizedBox(height: 16),
            
            // Quick stats
            _buildQuickStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadges(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = <Widget>[];
    
    // First session achievement
    if (totalPoints >= 1) {
      achievements.add(_buildAchievementBadge(
        context,
        'First Step',
        'Completed your first session',
        Icons.star,
        theme.colorScheme.primary,
      ));
    }
    
    // Streak achievements
    if (currentStreak >= 3) {
      achievements.add(_buildAchievementBadge(
        context,
        'On Fire',
        '3-day streak achieved',
        Icons.local_fire_department,
        theme.colorScheme.secondary,
      ));
    }
    
    if (currentStreak >= 7) {
      achievements.add(_buildAchievementBadge(
        context,
        'Week Warrior',
        '7-day streak achieved',
        Icons.emoji_events,
        theme.colorScheme.tertiary,
      ));
    }
    
    // Points achievements
    if (totalPoints >= 10) {
      achievements.add(_buildAchievementBadge(
        context,
        'Decade',
        '10 points milestone',
        Icons.diamond,
        Colors.purple,
      ));
    }
    
    if (totalPoints >= 50) {
      achievements.add(_buildAchievementBadge(
        context,
        'Half Century',
        '50 points milestone',
        Icons.workspace_premium,
        Colors.amber,
      ));
    }
    
    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Complete sessions to unlock achievements',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: achievements,
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      width: 100, // Fixed width to prevent overflow
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Recent Sessions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentSessions.length,
            itemBuilder: (context, index) {
              final session = recentSessions[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: session.completed 
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: session.completed 
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          session.completed ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: session.completed 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDate(session.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.pointsEarned} pts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${session.averageNoise.toStringAsFixed(1)} dB avg',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${session.duration}s',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStat(
            context,
            'Total Sessions',
            totalSessions.toString(),
            Icons.play_circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuickStat(
            context,
            'Avg Score',
            averageScore.toStringAsFixed(1),
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuickStat(
            context,
            'Best Streak',
            bestStreak.toString(),
            Icons.star,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.isAtSameMomentAs(today)) {
      return 'Today at ${_formatTime(date)}';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
} 