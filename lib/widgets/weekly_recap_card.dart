import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weekly_recap.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Beautiful card displaying weekly recap statistics and achievements
class WeeklyRecapCard extends StatelessWidget {
  final WeeklyRecap recap;
  final VoidCallback? onTap;

  const WeeklyRecapCard({
    super.key,
    required this.recap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('MMM d', locale);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.recapWeeklyTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dateFormat.format(recap.weekStartDate)} - ${dateFormat.format(recap.weekEndDate)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.schedule_rounded,
                      label: l10n.statSessions,
                      value: recap.totalSessions.toString(),
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.stars_rounded,
                      label: l10n.statPoints,
                      value: recap.totalPoints.toString(),
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.timer_outlined,
                      label: l10n.recapMinutes,
                      value: recap.totalMinutes.toString(),
                      theme: theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Streak Change
              if (recap.streakAtEnd != recap.streakAtStart)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
          color: recap.streakAtEnd > recap.streakAtStart
            ? Theme.of(context).extension<SemanticColors>()?.success.withValues(alpha: 0.1) ?? Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.1)
            : Theme.of(context).extension<SemanticColors>()?.warning.withValues(alpha: 0.1) ?? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        recap.streakAtEnd > recap.streakAtStart
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 20,
            color: recap.streakAtEnd > recap.streakAtStart
              ? Theme.of(context).extension<SemanticColors>()?.onSuccess ?? Theme.of(context).colorScheme.onTertiaryContainer
              : Theme.of(context).extension<SemanticColors>()?.onWarning ?? Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.recapStreak(recap.streakAtStart, recap.streakAtEnd),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
              color: recap.streakAtEnd > recap.streakAtStart
                ? Theme.of(context).extension<SemanticColors>()?.onSuccess ?? Theme.of(context).colorScheme.onTertiaryContainer
                : Theme.of(context).extension<SemanticColors>()?.onWarning ?? Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              if (recap.streakAtEnd != recap.streakAtStart)
                const SizedBox(height: 16),

              // Top Activity
              if (recap.totalSessions > 0)
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.recapTopActivity,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${recap.topActivity} (${recap.topActivityCount}×)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              if (recap.totalSessions > 0) const SizedBox(height: 16),

              // Achievements
              if (recap.achievements.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recap.achievements
                      .map((achievement) => Chip(
                            label: Text(
                              achievement,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.secondaryContainer,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              if (recap.achievements.isNotEmpty) const SizedBox(height: 16),

              // Personalized Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recap.personalizedMessage,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
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
      ),
    );
  }
}
