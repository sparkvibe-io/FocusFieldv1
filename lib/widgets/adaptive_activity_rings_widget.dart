import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/user_preferences_provider.dart';
import '../providers/ambient_quest_provider.dart';
import '../models/ambient_models.dart';
import 'activity_edit_sheet.dart';
import '../utils/responsive_utils.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Adaptive activity rings widget that shows 1-4 activities based on user preferences
class AdaptiveActivityRingsWidget extends ConsumerWidget {
  const AdaptiveActivityRingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(userPreferencesProvider);
    final questState = ref.watch(questStateProvider);

    if (questState == null) {
      return const SizedBox.shrink();
    }

    // Get enabled profile IDs
    final enabledProfileIds = prefs.enabledProfiles;

    if (enabledProfileIds.isEmpty) {
      return const SizedBox.shrink();
    }

    // Build activity data
    final activities =
        enabledProfileIds.map((profileId) {
          final completed = _getCompletedMinutes(profileId, questState);
          // Use per-activity goal if enabled, otherwise use global goal
          final target =
              prefs.perActivityGoalsEnabled && prefs.perActivityGoals != null
                  ? (prefs.perActivityGoals![profileId] ??
                      prefs.globalDailyQuietGoalMinutes)
                  : prefs.globalDailyQuietGoalMinutes;
          // Allow progress to exceed 100% (up to 200%) to show when users exceed their goals
          final progress =
              target > 0 ? (completed / target).clamp(0.0, 2.0) : 0.0;

          return {
            'id': profileId,
            'icon': _getActivityIcon(profileId),
            'label': _getActivityName(profileId, context),
            'completed': completed,
            'target': target,
            'progress': progress,
            'color': _getActivityColor(profileId),
          };
        }).toList();

    // Calculate overall progress
    final totalCompleted = questState.progressQuietMinutes;
    // Sum individual targets if per-activity goals enabled, otherwise use global goal
    final totalTarget =
        prefs.perActivityGoalsEnabled && prefs.perActivityGoals != null
            ? enabledProfileIds.fold<int>(
              0,
              (sum, id) => sum + (prefs.perActivityGoals![id] ?? 0),
            )
            : prefs.globalDailyQuietGoalMinutes;
    // If freeze token was used today, lock overall progress at 100% regardless of subsequent sessions
    final overallProgress =
        questState.freezeTokenUsedToday
            ? 1.0
            : (totalTarget > 0
                ? (totalCompleted / totalTarget).clamp(0.0, 1.0)
                : 0.0);
    final overallPercentage = '${(overallProgress * 100).toInt()}%';

    // Add freeze token badge to Overall label when freeze token is used
    final overallLabel =
        questState.freezeTokenUsedToday ? l10n.ringOverallFrozen : l10n.ringOverall;

    // Clean neutral card background matching industry standards
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.colorScheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: isDark ? 0.4 : 0.15,
            ),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title, Freeze indicator, and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.statSessions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Freeze indicator (always visible for discoverability)
                  InkWell(
                    onTap: () => _showFreezeDialog(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withValues(
                          alpha: questState.freezeTokens > 0 ? 0.15 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('❄️', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '${questState.freezeTokens}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  questState.freezeTokens > 0
                                      ? theme.colorScheme.tertiary
                                      : theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _openEditSheet(context),
                    icon: Icon(
                      Icons.tune,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(l10n.buttonEdit),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      foregroundColor:
                          theme
                              .colorScheme
                              .primary, // Match Settings page vibrancy
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Adaptive rings layout
          _buildAdaptiveLayout(
            context,
            activities,
            overallProgress,
            overallPercentage,
            overallLabel,
          ),
        ],
      ),
    );
  }

  /// Get responsive size multiplier based on screen width
  double _getSizeMultiplier(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < ScreenBreakpoints.phone) return 1.0; // Phone
    if (width < ScreenBreakpoints.tablet) return 1.16; // Small tablet (+16%)
    return 1.36; // Large tablet (+36%)
  }

  Widget _buildAdaptiveLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
    String overallLabel,
  ) {
    final count = activities.length;

    if (count == 1) {
      return _build1ActivityLayout(
        context,
        activities[0],
        overallProgress,
        overallPercentage,
        overallLabel,
      );
    } else if (count == 2) {
      return _build2ActivitiesLayout(
        context,
        activities,
        overallProgress,
        overallPercentage,
        overallLabel,
      );
    } else if (count == 3) {
      return _build3ActivitiesLayout(
        context,
        activities,
        overallProgress,
        overallPercentage,
        overallLabel,
      );
    } else {
      return _build4ActivitiesLayout(
        context,
        activities,
        overallProgress,
        overallPercentage,
        overallLabel,
      );
    }
  }

  /// Helper to build activity widget (ring or flat icon based on mode)
  Widget _buildActivityWidget(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> activity,
    double size,
    double iconSize,
  ) {
    final prefs = ref.watch(userPreferencesProvider);
    final isPerActivityMode = prefs.perActivityGoalsEnabled;

    if (isPerActivityMode) {
      return _buildRing(
        context: context,
        icon: activity['icon'] as IconData,
        label: activity['label'] as String,
        progress: activity['progress'] as double,
        color: activity['color'] as Color,
        size: size,
        iconSize: iconSize,
        showStats: false,
      );
    } else {
      return _buildFlatIcon(
        context: context,
        icon: activity['icon'] as IconData,
        label: activity['label'] as String,
        color: activity['color'] as Color,
        size: size,
        iconSize: iconSize,
        completedMinutes: activity['completed'] as int,
      );
    }
  }

  // Layout 1: Equal sized rings
  Widget _build1ActivityLayout(
    BuildContext context,
    Map<String, dynamic> activity,
    double overallProgress,
    String overallPercentage,
    String overallLabel,
  ) {
    final multiplier = _getSizeMultiplier(context);

    return Consumer(
      builder:
          (context, ref, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Activity: Show ring if per-activity mode, flat icon if global mode
              _buildActivityWidget(
                context,
                ref,
                activity,
                155 * multiplier,
                56 * multiplier,
              ),
              // Overall: Always show ring
              _buildRing(
                context: context,
                label: overallLabel,
                progress: overallProgress,
                color: Theme.of(context).colorScheme.primary,
                size: 155 * multiplier,
                iconSize: 52 * multiplier,
                showStats: true,
                statsText: overallPercentage,
              ),
            ],
          ),
    );
  }

  // Layout 2: 2 activities + larger overall
  Widget _build2ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
    String overallLabel,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Consumer(
      builder:
          (context, ref, _) => Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      activities.map((activity) {
                        return _buildActivityWidget(
                          context,
                          ref,
                          activity,
                          86 * multiplier,
                          38 * multiplier,
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              _buildRing(
                context: context,
                label: overallLabel,
                progress: overallProgress,
                color: Theme.of(context).colorScheme.primary,
                size: 138 * multiplier,
                iconSize: 46 * multiplier,
                showStats: true,
                statsText: overallPercentage,
              ),
            ],
          ),
    );
  }

  // Layout 3: 3 activities + overall
  Widget _build3ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
    String overallLabel,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Consumer(
      builder:
          (context, ref, _) => Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      activities.map((activity) {
                        return _buildActivityWidget(
                          context,
                          ref,
                          activity,
                          60 * multiplier,
                          26 * multiplier,
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              _buildRing(
                context: context,
                label: overallLabel,
                progress: overallProgress,
                color: Theme.of(context).colorScheme.primary,
                size: 125 * multiplier,
                iconSize: 38 * multiplier,
                showStats: true,
                statsText: overallPercentage,
              ),
            ],
          ),
    );
  }

  // Layout 4: 2x2 grid + overall
  Widget _build4ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
    String overallLabel,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Consumer(
      builder:
          (context, ref, _) => Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActivityWidget(
                          context,
                          ref,
                          activities[0],
                          76 * multiplier,
                          34 * multiplier,
                        ),
                        _buildActivityWidget(
                          context,
                          ref,
                          activities[1],
                          76 * multiplier,
                          34 * multiplier,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActivityWidget(
                          context,
                          ref,
                          activities[2],
                          76 * multiplier,
                          34 * multiplier,
                        ),
                        _buildActivityWidget(
                          context,
                          ref,
                          activities[3],
                          76 * multiplier,
                          34 * multiplier,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildRing(
                context: context,
                label: overallLabel,
                progress: overallProgress,
                color: Theme.of(context).colorScheme.primary,
                size: 138 * multiplier,
                iconSize: 46 * multiplier,
                showStats: true,
                statsText: overallPercentage,
              ),
            ],
          ),
    );
  }

  Widget _buildRing({
    required BuildContext context,
    IconData? icon,
    required String label,
    required double progress,
    required Color color,
    required double size,
    required double iconSize,
    required bool showStats,
    String? statsText,
  }) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.18,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: 1.0,
                  color: backgroundColor,
                  strokeWidth: size * 0.10,
                ),
              ),
              // Progress circle
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: progress,
                  color: color,
                  strokeWidth: size * 0.10,
                ),
              ),
              // Center content
              if (showStats && statsText != null)
                Text(
                  statsText,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                )
              else if (icon != null)
                Container(
                  width: size * 0.70,
                  height: size * 0.70,
                  decoration: BoxDecoration(
                    color: color, // Full saturation, no alpha reduction
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: size * 0.15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: iconSize, color: Colors.white),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build flat icon (no progress ring) for Global Mode
  /// Same container size as ring to maintain horizontal proportions
  Widget _buildFlatIcon({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required double size,
    required double iconSize,
    required int completedMinutes,
  }) {
    final theme = Theme.of(context);
    final isUsed = completedMinutes > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Container(
              width:
                  size * 0.82, // Slightly larger than ring's inner icon (0.70)
              height: size * 0.82,
              decoration: BoxDecoration(
                color: color, // Full saturation
                shape: BoxShape.circle,
                // No boxShadow - clean flat appearance
              ),
              child: Icon(
                icon,
                size: iconSize * 1.15, // Slightly larger icon
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Activity label
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        // Minute badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUsed) ...[
              Icon(Icons.check_circle, size: 12, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              '$completedMinutes min',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isUsed
                        ? color
                        : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  int _getCompletedMinutes(String profileId, QuestState questState) {
    switch (profileId) {
      case 'study':
        return questState.studyMinutes;
      case 'reading':
        return questState.readingMinutes;
      case 'meditation':
        return questState.meditationMinutes;
      case 'other':
        return questState.otherMinutes;
      default:
        return 0;
    }
  }

  String _getActivityName(String profileId, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (profileId) {
      case 'study':
        return l10n.onboardingActivityStudyTitle;
      case 'reading':
        return l10n.onboardingActivityReadingTitle;
      case 'meditation':
        return l10n.onboardingActivityMeditationTitle;
      case 'other':
        return l10n.onboardingActivityOtherTitle;
      default:
        return l10n.activityUnknown;
    }
  }

  IconData _getActivityIcon(String profileId) {
    switch (profileId) {
      case 'study':
        return Icons.school_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      case 'meditation':
        return Icons.self_improvement_outlined;
      case 'other':
        return Icons.star_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getActivityColor(String profileId) {
    switch (profileId) {
      case 'study':
        return const Color(0xFF2196F3); // Material Blue 500 - Bright, energetic
      case 'reading':
        return const Color(0xFF9C27B0); // Material Purple 500 - Rich, deep
      case 'meditation':
        return const Color(0xFF4CAF50); // Material Green 500 - Fresh, vibrant
      case 'other':
        return const Color(0xFFFF9800); // Material Orange 500 - Warm, bold
      default:
        return Colors.grey;
    }
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ActivityEditSheet(),
    );
  }

  void _showFreezeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final theme = Theme.of(context);
            final l10n = AppLocalizations.of(context)!;
            final questState = ref.watch(questStateProvider);

            if (questState == null) {
              return AlertDialog(
                title: Text(l10n.errorTitle),
                content: Text(l10n.errorQuestUnavailable),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.buttonOK),
                  ),
                ],
              );
            }

            final hasTokens = questState.freezeTokens > 0;
            final goalMet =
                questState.progressQuietMinutes >= questState.goalQuietMinutes;

            // Three states
            String title;
            String message;
            List<Widget> actions;

            if (!hasTokens) {
              // State 1: No tokens available
              title = l10n.freezeTokenNoTokensTitle;
              message = l10n.freezeTokenNoTokensMessage;
              actions = [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.buttonOK),
                ),
              ];
            } else if (goalMet) {
              // State 2: Goal already met (prevent double-use)
              title = l10n.freezeTokenGoalCompleteTitle;
              message = l10n.freezeTokenGoalCompleteMessage;
              actions = [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.buttonOK),
                ),
              ];
            } else {
              // State 3: Can use freeze token
              title = l10n.freezeTokenUseTitle;
              message =
                  '${l10n.freezeTokenUseMessage}\n\n'
                  'You have ${questState.freezeTokens} token(s). Use one now?';
              actions = [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    // Use freeze token
                    final success =
                        await ref
                            .read(questStateProvider.notifier)
                            .freezeToday();
                    if (context.mounted) {
                      Navigator.pop(context);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.freezeTokenUsedSuccess,
                            ),
                            backgroundColor: theme.colorScheme.tertiary,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.errorFreezeTokenFailed),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(l10n.buttonUseFreeze),
                ),
              ];
            }

            return AlertDialog(
              title: Row(
                children: [
                  const Text('❄️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(message, style: theme.textTheme.bodyMedium),
              actions: actions,
            );
          },
        );
      },
    );
  }
}

/// Custom painter for circular progress rings
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Draw arc from top (270 degrees = -π/2 radians)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
