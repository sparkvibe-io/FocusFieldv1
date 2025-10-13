import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

/// New circular rings widget that displays 1-4 activities in adaptive layouts
/// 
/// Layout modes based on number of enabled activities:
/// - 1 activity: Large activity ring (left) + Overall ring (right)
/// - 2 activities: 2 small rings in row (left) + Overall ring (right)  
/// - 3 activities: 3 small rings in row (left) + Overall ring (right)
/// - 4 activities: 2x2 grid (left) + Overall ring (right)
class ActivityRingsWidget extends ConsumerWidget {
  final List<Map<String, dynamic>> activities;
  final double overallProgress;
  final String overallPercentageText;
  final int goalMinutes;

  const ActivityRingsWidget({
    super.key,
    required this.activities,
    required this.overallProgress,
    required this.overallPercentageText,
    required this.goalMinutes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activityCount = activities.length;

    if (activityCount == 1) {
      // 1 Activity: Both rings same size, side by side
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSingleActivityRing(context, activities[0]),
            const SizedBox(width: 20),
            _buildOverallRing(context, size: 140),
          ],
        ),
      );
    } else {
      // 2+ Activities: Smaller activity rings + larger overall ring
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Activity rings (adaptive layout)
            Expanded(
              flex: 3,
              child: _buildActivityRingsLayout(context, activityCount),
            ),
            const SizedBox(width: 20),
            // Right side: Larger overall ring (almost half the widget)
            _buildOverallRing(context, size: 160),
          ],
        ),
      );
    }
  }

  Widget _buildActivityRingsLayout(BuildContext context, int count) {
    if (count == 1) {
      return _buildSingleActivityRing(context, activities[0]);
    } else if (count == 2) {
      return _buildTwoActivitiesRow(context);
    } else if (count == 3) {
      return _buildThreeActivitiesRow(context);
    } else {
      return _buildFourActivitiesGrid(context);
    }
  }

  // Layout 1: Single large activity ring (same size as overall)
  Widget _buildSingleActivityRing(BuildContext context, Map<String, dynamic> activity) {
    return _buildActivityRing(
      context: context,
      icon: activity['icon'] as IconData,
      label: activity['label'] as String,
      completed: activity['completed'] as int,
      target: activity['target'] as int,
      color: activity['color'] as Color,
      size: 140,
      iconSize: 40,
      showLabel: true,
    );
  }

  // Layout 2: Two activities in a row (smaller rings)
  Widget _buildTwoActivitiesRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: activities.map((activity) {
        return _buildActivityRing(
          context: context,
          icon: activity['icon'] as IconData,
          label: activity['label'] as String,
          completed: activity['completed'] as int,
          target: activity['target'] as int,
          color: activity['color'] as Color,
          size: 80,
          iconSize: 26,
          showLabel: true,
        );
      }).toList(),
    );
  }

  // Layout 3: Three activities in a row
  Widget _buildThreeActivitiesRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: activities.map((activity) {
        return Flexible(
          child: _buildActivityRing(
            context: context,
            icon: activity['icon'] as IconData,
            label: activity['label'] as String,
            completed: activity['completed'] as int,
            target: activity['target'] as int,
            color: activity['color'] as Color,
            size: 75,
            iconSize: 24,
            showLabel: true,
          ),
        );
      }).toList(),
    );
  }

  // Layout 4: Four activities in 2x2 grid
  Widget _buildFourActivitiesGrid(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActivityRing(
              context: context,
              icon: activities[0]['icon'] as IconData,
              label: activities[0]['label'] as String,
              completed: activities[0]['completed'] as int,
              target: activities[0]['target'] as int,
              color: activities[0]['color'] as Color,
              size: 70,
              iconSize: 22,
              showLabel: true,
            ),
            _buildActivityRing(
              context: context,
              icon: activities[1]['icon'] as IconData,
              label: activities[1]['label'] as String,
              completed: activities[1]['completed'] as int,
              target: activities[1]['target'] as int,
              color: activities[1]['color'] as Color,
              size: 70,
              iconSize: 22,
              showLabel: true,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Bottom row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActivityRing(
              context: context,
              icon: activities[2]['icon'] as IconData,
              label: activities[2]['label'] as String,
              completed: activities[2]['completed'] as int,
              target: activities[2]['target'] as int,
              color: activities[2]['color'] as Color,
              size: 70,
              iconSize: 22,
              showLabel: true,
            ),
            _buildActivityRing(
              context: context,
              icon: activities[3]['icon'] as IconData,
              label: activities[3]['label'] as String,
              completed: activities[3]['completed'] as int,
              target: activities[3]['target'] as int,
              color: activities[3]['color'] as Color,
              size: 70,
              iconSize: 22,
              showLabel: true,
            ),
          ],
        ),
      ],
    );
  }

  // Single activity ring component
  Widget _buildActivityRing({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int completed,
    required int target,
    required Color color,
    required double size,
    required double iconSize,
    required bool showLabel,
  }) {
    final theme = Theme.of(context);
    final progress = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
    
    // Background ring color - visible dark gray with opacity
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
              // Icon in center
              Icon(
                icon,
                size: iconSize,
                color: color,
              ),
            ],
          ),
        ),
        if (showLabel) ...[
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
      ],
    );
  }

  // Overall progress ring (right side) - size adapts based on activity count
  Widget _buildOverallRing(BuildContext context, {required double size}) {
    final theme = Theme.of(context);
    
    // Background ring color - visible dark gray with opacity
    final backgroundColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    // Adjust text size based on ring size
    final textSize = size > 150 ? theme.textTheme.displaySmall : theme.textTheme.headlineMedium;

    return SizedBox(
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
              progress: overallProgress,
              color: theme.colorScheme.primary,
              strokeWidth: size * 0.10,
            ),
          ),
          // Percentage text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                overallPercentageText,
                style: textSize?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'Overall',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
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

