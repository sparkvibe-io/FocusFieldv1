import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/activity_provider.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription_tier.dart';
import '../widgets/feature_gate.dart';

/// Activity chip with circular progress ring showing daily goal completion
class ActivityChip extends ConsumerWidget {
  final ActivityType activityType;
  final ActivityProgress? progress;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityChip({
    super.key,
    required this.activityType,
    this.progress,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final progressValue = progress?.progress ?? 0.0;
    final isCompleted = progress?.isCompleted ?? false;
    final goalIndicator = progress?.goalIndicator ?? '0/1';

    // Progress ring color
    final progressColor = isCompleted
        ? Colors.green
        : (progressValue > 0 ? Colors.amber : colorScheme.outline);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular progress ring with activity icon
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring background
                  CustomPaint(
                    size: const Size(60, 60),
                    painter: _ProgressRingPainter(
                      progress: progressValue,
                      color: progressColor,
                      backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 3,
                    ),
                  ),

                  // Activity icon with selection indicator
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surface,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        activityType.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),

                  // Completion checkmark overlay
                  if (isCompleted)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Activity label
            Text(
              activityType.key,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Goal indicator
            Text(
              goalIndicator,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for circular progress ring
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start at top
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
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

/// Horizontal scrollable activity chips row
class ActivityChipsRow extends ConsumerWidget {
  const ActivityChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityState = ref.watch(activityTrackingProvider);
    final subscription = ref.watch(subscriptionTierProvider);
    final isPremium = subscription.when(
      data: (tier) => tier != SubscriptionTier.free,
      loading: () => false,
      error: (_, __) => false,
    );

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: activityState.trackedActivities.length + 1, // +1 for add button
        itemBuilder: (context, index) {
          // Add button at the end
          if (index == activityState.trackedActivities.length) {
            return _buildAddButton(context, ref, isPremium, activityState);
          }

          final activity = activityState.trackedActivities[index];
          final isSelected = activityState.selectedActivity == activity.type.key;

          return ActivityChip(
            activityType: activity.type,
            progress: activity,
            isSelected: isSelected,
            onTap: () {
              ref.read(activityTrackingProvider.notifier).selectActivity(activity.type.key);
            },
          );
        },
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    WidgetRef ref,
    bool isPremium,
    ActivityTrackingState activityState,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check if user can add more activities
    final canAdd = isPremium || activityState.trackedActivities.length < maxFreeActivities;
    final availableActivities = ActivityType.values
        .where((type) => !activityState.isTracked(type.key))
        .toList();

    if (availableActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showAddActivityDialog(context, ref, isPremium, availableActivities),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                canAdd ? Icons.add : Icons.lock_outline,
                size: 28,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              canAdd ? 'Add' : 'Premium',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddActivityDialog(
    BuildContext context,
    WidgetRef ref,
    bool isPremium,
    List<ActivityType> availableActivities,
  ) {
    final activityState = ref.read(activityTrackingProvider);
    final canAdd = isPremium || activityState.trackedActivities.length < maxFreeActivities;

    if (!canAdd) {
      // Show paywall
      showPaywall(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableActivities.length,
            itemBuilder: (context, index) {
              final activity = availableActivities[index];
              return ListTile(
                leading: Text(activity.icon, style: const TextStyle(fontSize: 28)),
                title: Text(activity.key),
                onTap: () {
                  ref.read(activityTrackingProvider.notifier).addActivity(
                        activity.key,
                        isPremium: isPremium,
                      );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
