import 'package:flutter/material.dart';
import 'package:silence_score/models/silence_data.dart';

class SessionHistoryGraph extends StatelessWidget {
  final List<SessionRecord> sessions;
  final int totalSessions;

  const SessionHistoryGraph({
    super.key,
    required this.sessions,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Session History',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '$totalSessions sessions',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: sessions.isEmpty
                ? _buildEmptyState(context)
                : _buildSessionGraph(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 24,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            'Your journey begins here! 🌟',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionGraph(BuildContext context) {
    final theme = Theme.of(context);
    
    // Take last 7 sessions for the graph
    final recentSessions = sessions.take(7).toList().reversed.toList();
    final maxPoints = recentSessions.isNotEmpty 
        ? recentSessions.map((s) => s.pointsEarned).reduce((a, b) => a > b ? a : b)
        : 10;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i < 7; i++)
          _buildBar(
            context,
            i < recentSessions.length ? recentSessions[i] : null,
            maxPoints > 0 ? maxPoints : 10,
          ),
      ],
    );
  }

  Widget _buildBar(BuildContext context, SessionRecord? session, int maxPoints) {
    final theme = Theme.of(context);
    final hasSession = session != null;
    final height = hasSession 
        ? (session.pointsEarned / maxPoints * 35).clamp(3.0, 35.0)
        : 3.0;
    
    final color = hasSession
        ? (session.completed 
            ? theme.colorScheme.primary
            : theme.colorScheme.error)
        : theme.colorScheme.outline.withValues(alpha: 0.3);
    
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
