import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/user_preferences_provider.dart';
import '../providers/ambient_quest_provider.dart';
import '../models/ambient_models.dart';
import 'activity_edit_sheet.dart';
import '../utils/responsive_utils.dart';

/// Adaptive activity rings widget that shows 1-4 activities based on user preferences
class AdaptiveActivityRingsWidget extends ConsumerWidget {
  const AdaptiveActivityRingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
    final activities = enabledProfileIds.map((profileId) {
      final completed = _getCompletedMinutes(profileId, questState);
      // Use per-activity goal if enabled, otherwise use global goal
      final target = prefs.perActivityGoalsEnabled && prefs.perActivityGoals != null
          ? (prefs.perActivityGoals![profileId] ?? prefs.globalDailyQuietGoalMinutes)
          : prefs.globalDailyQuietGoalMinutes;
      final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;

      return {
        'id': profileId,
        'icon': _getActivityIcon(profileId),
        'label': _getActivityName(profileId),
        'completed': completed,
        'target': target,
        'progress': progress,
        'color': _getActivityColor(profileId),
      };
    }).toList();

    // Calculate overall progress
    final totalCompleted = questState.progressQuietMinutes;
    // Sum individual targets if per-activity goals enabled, otherwise use global goal
    final totalTarget = prefs.perActivityGoalsEnabled && prefs.perActivityGoals != null
        ? enabledProfileIds.fold<int>(0, (sum, id) => sum + (prefs.perActivityGoals![id] ?? 0))
        : prefs.globalDailyQuietGoalMinutes;
    final overallProgress = totalTarget > 0 ? (totalCompleted / totalTarget).clamp(0.0, 1.0) : 0.0;
    final overallPercentage = '${(overallProgress * 100).toInt()}%';

    // Inverse background: darker in light mode, lighter in dark mode
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title, Freeze indicator, and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sessions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Freeze indicator
                  if (questState.freezeTokens > 0) ...[
                    InkWell(
                      onTap: () => _showFreezeDialog(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
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
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton.icon(
                    onPressed: () => _openEditSheet(context),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Adaptive rings layout
          _buildAdaptiveLayout(context, activities, overallProgress, overallPercentage),
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
  ) {
    final count = activities.length;

    if (count == 1) {
      return _build1ActivityLayout(context, activities[0], overallProgress, overallPercentage);
    } else if (count == 2) {
      return _build2ActivitiesLayout(context, activities, overallProgress, overallPercentage);
    } else if (count == 3) {
      return _build3ActivitiesLayout(context, activities, overallProgress, overallPercentage);
    } else {
      return _build4ActivitiesLayout(context, activities, overallProgress, overallPercentage);
    }
  }

  // Layout 1: Equal sized rings
  Widget _build1ActivityLayout(
    BuildContext context,
    Map<String, dynamic> activity,
    double overallProgress,
    String overallPercentage,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRing(
          context: context,
          icon: activity['icon'] as IconData,
          label: activity['label'] as String,
          progress: activity['progress'] as double,
          color: activity['color'] as Color,
          size: 155 * multiplier,
          iconSize: 56 * multiplier,
          showStats: false,
        ),
        _buildRing(
          context: context,
          label: 'Overall',
          progress: overallProgress,
          color: Theme.of(context).colorScheme.primary,
          size: 155 * multiplier,
          iconSize: 52 * multiplier,
          showStats: true,
          statsText: overallPercentage,
        ),
      ],
    );
  }

  // Layout 2: 2 activities + larger overall
  Widget _build2ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: activities.map((activity) {
              return _buildRing(
                context: context,
                icon: activity['icon'] as IconData,
                label: activity['label'] as String,
                progress: activity['progress'] as double,
                color: activity['color'] as Color,
                size: 86 * multiplier,
                iconSize: 38 * multiplier,
                showStats: false,
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        _buildRing(
          context: context,
          label: 'Overall',
          progress: overallProgress,
          color: Theme.of(context).colorScheme.primary,
          size: 138 * multiplier,
          iconSize: 46 * multiplier,
          showStats: true,
          statsText: overallPercentage,
        ),
      ],
    );
  }

  // Layout 3: 3 activities + overall
  Widget _build3ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: activities.map((activity) {
              return _buildRing(
                context: context,
                icon: activity['icon'] as IconData,
                label: activity['label'] as String,
                progress: activity['progress'] as double,
                color: activity['color'] as Color,
                size: 60 * multiplier,
                iconSize: 26 * multiplier,
                showStats: false,
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        _buildRing(
          context: context,
          label: 'Overall',
          progress: overallProgress,
          color: Theme.of(context).colorScheme.primary,
          size: 125 * multiplier,
          iconSize: 38 * multiplier,
          showStats: true,
          statsText: overallPercentage,
        ),
      ],
    );
  }

  // Layout 4: 2x2 grid + overall
  Widget _build4ActivitiesLayout(
    BuildContext context,
    List<Map<String, dynamic>> activities,
    double overallProgress,
    String overallPercentage,
  ) {
    final multiplier = _getSizeMultiplier(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRing(
                    context: context,
                    icon: activities[0]['icon'] as IconData,
                    label: activities[0]['label'] as String,
                    progress: activities[0]['progress'] as double,
                    color: activities[0]['color'] as Color,
                    size: 76 * multiplier,
                    iconSize: 34 * multiplier,
                    showStats: false,
                  ),
                  _buildRing(
                    context: context,
                    icon: activities[1]['icon'] as IconData,
                    label: activities[1]['label'] as String,
                    progress: activities[1]['progress'] as double,
                    color: activities[1]['color'] as Color,
                    size: 76 * multiplier,
                    iconSize: 34 * multiplier,
                    showStats: false,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRing(
                    context: context,
                    icon: activities[2]['icon'] as IconData,
                    label: activities[2]['label'] as String,
                    progress: activities[2]['progress'] as double,
                    color: activities[2]['color'] as Color,
                    size: 76 * multiplier,
                    iconSize: 34 * multiplier,
                    showStats: false,
                  ),
                  _buildRing(
                    context: context,
                    icon: activities[3]['icon'] as IconData,
                    label: activities[3]['label'] as String,
                    progress: activities[3]['progress'] as double,
                    color: activities[3]['color'] as Color,
                    size: 76 * multiplier,
                    iconSize: 34 * multiplier,
                    showStats: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildRing(
          context: context,
          label: 'Overall',
          progress: overallProgress,
          color: Theme.of(context).colorScheme.primary,
          size: 138 * multiplier,
          iconSize: 46 * multiplier,
          showStats: true,
          statsText: overallPercentage,
        ),
      ],
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
    final backgroundColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

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
                    color: color.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white,
                  ),
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

  String _getActivityName(String profileId) {
    switch (profileId) {
      case 'study':
        return 'Study';
      case 'reading':
        return 'Reading';
      case 'meditation':
        return 'Meditation';
      case 'other':
        return 'Other';
      default:
        return 'Unknown';
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
        return const Color(0xFF8B9DC3); // Soft blue-gray
      case 'reading':
        return const Color(0xFF7BA7BC); // Muted teal-blue
      case 'meditation':
        return const Color(0xFF86B489); // Sage green
      case 'other':
        return const Color(0xFFC4A57B); // Muted amber
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
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              const Text('❄️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Use Freeze Token',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Freeze tokens protect your streak when you miss a day. '
            'Using a freeze will save your streak even if you don\'t complete your daily goal.\n\n'
            'Do you want to use a freeze token now?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                // TODO: Implement freeze usage logic
                // - Decrement freeze token count
                // - Apply freeze to current/previous day
                // - Update quest state
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Freeze token used successfully'),
                    backgroundColor: theme.colorScheme.tertiary,
                  ),
                );
              },
              child: const Text('Use Freeze'),
            ),
          ],
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

    final paint = Paint()
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

