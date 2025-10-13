import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/mission_provider.dart';
import 'package:focus_field/models/mission.dart';

class MissionCapsule extends ConsumerWidget {
  const MissionCapsule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mission = ref.watch(missionProvider);
    if (mission == null) return const SizedBox.shrink();
    final progress = ref.watch(missionProgressProvider);
    final stage = mission.computeStage(totalMicroSessions: progress);
    const totalTarget = 20; // Phase 1 target micro-sessions for the month
    final pct = _clamp01(progress / totalTarget);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
  onTap: () => _showMissionDetails(context, mission, progress, totalTarget),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            _RocketIcon(stage: stage),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _stageLabel(stage),
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _MiniGoalRing(value: pct),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Slim progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.12),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Helper line with remaining days and explicit count
                  Text(
                    'Days remaining: ${mission.daysRemaining} · $progress/$totalTarget micro‑focus sessions',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stageLabel(MissionStage s) => switch (s) {
        MissionStage.preflight => 'Pre‑flight',
        MissionStage.ignition => 'Ignition',
        MissionStage.liftoff => 'Lift‑off',
        MissionStage.stageSeparation => 'Stage separation',
        MissionStage.orbit => 'Orbit',
      };

  double _clamp01(double v) => v.clamp(0.0, 1.0);

  void _showMissionDetails(
    BuildContext context,
    Mission mission,
    int progress,
    int totalTarget,
  ) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Focus Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        tooltip: 'Close',
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re on a 30‑day focus journey. Each completed 1–5 minute session counts as a micro‑focus session. Hit milestones to advance rocket stages.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Text('Stages', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  const Text('• Pre‑flight: 0\n• Ignition: 1+\n• Lift‑off: 5+\n• Stage separation: 12+\n• Orbit: 20+'),
                  const SizedBox(height: 12),
                  Text('Current: $progress/$totalTarget micro‑focus sessions', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RocketIcon extends StatelessWidget {
  final MissionStage stage;
  const _RocketIcon({required this.stage});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final icon = switch (stage) {
      MissionStage.preflight => Icons.rocket_launch_outlined,
      MissionStage.ignition => Icons.rocket_launch,
      MissionStage.liftoff => Icons.rocket_launch,
      MissionStage.stageSeparation => Icons.auto_graph,
      MissionStage.orbit => Icons.public,
    };
    return Icon(icon, color: color, size: 28);
  }
}

class _MiniGoalRing extends StatelessWidget {
  final double value; // 0..1
  const _MiniGoalRing({required this.value});

  @override
  Widget build(BuildContext context) {
  const size = 28.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 3,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          ),
          Text('${(value * 100).round()}%', style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
