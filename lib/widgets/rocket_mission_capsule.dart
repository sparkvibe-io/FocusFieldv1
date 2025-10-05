import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/mission_provider.dart';

/// Mission stages for the 30-day journey
enum MissionStage {
  preFlight(0, '🚀 Pre-Flight', 0, 0),
  ignition(1, '🔥 Ignition', 1, 7),
  liftOff(2, '🚀 Lift-off', 8, 14),
  stageSeparation(3, '⚡ Stage Separation', 15, 24),
  orbit(4, '🌟 Orbit', 25, 30);

  final int stageIndex;
  final String label;
  final int startDay;
  final int endDay;

  const MissionStage(this.stageIndex, this.label, this.startDay, this.endDay);

  static MissionStage fromDay(int day) {
    if (day == 0) return MissionStage.preFlight;
    if (day <= 7) return MissionStage.ignition;
    if (day <= 14) return MissionStage.liftOff;
    if (day <= 24) return MissionStage.stageSeparation;
    return MissionStage.orbit;
  }
}

/// Vertical rocket mission capsule showing progress through stages
class RocketMissionCapsule extends ConsumerWidget {
  const RocketMissionCapsule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mission = ref.watch(missionProvider);

    if (mission == null) {
      return const SizedBox.shrink();
    }

    final currentDay = DateTime.now().difference(mission.startDate).inDays.clamp(0, 30);
    final daysRemaining = mission.daysRemaining;
    final currentStage = MissionStage.fromDay(currentDay);

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRocketTrack(context, currentStage, currentDay),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentStage.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
          'Day $currentDay/30 · $daysRemaining days remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withValues(alpha: 0.8),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getMotivationalMessage(currentStage, currentDay),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _buildDailyGoalRing(context, ref, currentStage),
        ],
      ),
    );
  }

  Widget _buildRocketTrack(BuildContext context, MissionStage currentStage, int currentDay) {
    const trackHeight = 66.0;
    const dotSize = 12.0;
    const rocketSize = 24.0;
    final stages = MissionStage.values.where((s) => s != MissionStage.preFlight).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 50,
      height: trackHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 25 - 1,
            top: dotSize / 2,
            bottom: dotSize / 2,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.outline.withValues(alpha: 0.3),
                    colorScheme.primary.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          ...stages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final position = trackHeight - (index * trackHeight / 3) - dotSize / 2;
            final isCompleted = currentStage.stageIndex > stage.stageIndex;
            final isCurrent = currentStage == stage;

            return Positioned(
              top: position,
              left: 25 - dotSize / 2,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : isCurrent ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: isCompleted || isCurrent ? Colors.white : Colors.transparent, width: 2),
                  boxShadow: isCompleted || isCurrent
                      ? [BoxShadow(color: (isCompleted ? Colors.green : colorScheme.primary).withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)]
                      : null,
                ),
                child: isCompleted ? const Icon(Icons.check, size: 8, color: Colors.white) : null,
              ),
            );
          }),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            top: trackHeight - (currentStage.stageIndex * trackHeight / 3) - rocketSize / 2 + dotSize / 2,
            left: 25 - rocketSize / 2,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, math.sin(value * math.pi * 2) * 2),
                  child: Container(
                    width: rocketSize,
                    height: rocketSize,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.6), blurRadius: 12, spreadRadius: 2)],
                    ),
                    child: const Center(child: Text('🚀', style: TextStyle(fontSize: 14))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalRing(BuildContext context, WidgetRef ref, MissionStage currentStage) {
    const progress = 0.0;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(50, 50),
            painter: _CircularProgressPainter(
              progress: progress,
              color: colorScheme.primary,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 4,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('0/1', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer, fontSize: 11)),
              Text('min', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7), fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage(MissionStage stage, int currentDay) {
    switch (stage) {
      case MissionStage.preFlight:
        return 'Ready for launch! 🚀';
      case MissionStage.ignition:
        return 'Building momentum! 🔥';
      case MissionStage.liftOff:
        return 'You\'re rising! 🚀';
      case MissionStage.stageSeparation:
        return 'Breaking barriers! ⚡';
      case MissionStage.orbit:
        return 'Soaring high! 🌟';
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) => oldDelegate.progress != progress;
}
