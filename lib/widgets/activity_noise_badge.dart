import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;
import '../providers/activity_provider.dart';

/// Activity-aware noise badge that only shows for silence-required activities
/// Shows compact dB reading with pulse animation when noise detected
class ActivityNoiseBadge extends ConsumerStatefulWidget {
  final VoidCallback onTap;

  const ActivityNoiseBadge({
    super.key,
    required this.onTap,
  });

  @override
  ConsumerState<ActivityNoiseBadge> createState() => _ActivityNoiseBadgeState();
}

class _ActivityNoiseBadgeState extends ConsumerState<ActivityNoiseBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityTrackingProvider);
    final selectedActivityKey = activityState.selectedActivity;
    final selectedActivityType = ActivityType.fromKey(selectedActivityKey);

    // Only show for silence-required activities
    if (!selectedActivityType.requiresSilence) {
      return const SizedBox.shrink();
    }

    // TODO: Wire up real-time decibel tracking when available
  const currentDecibels = 35.0; // Placeholder
  const threshold = 38.0; // Placeholder
    final isNoiseDetected = currentDecibels > threshold;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isNoiseDetected
                ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isNoiseDetected
                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5)
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: isNoiseDetected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Animated waveform icon with pulse
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = isNoiseDetected
                      ? 1.0 + (_pulseController.value * 0.2)
                      : 1.0;

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isNoiseDetected
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isNoiseDetected
                            ? Icons.graphic_eq
                            : Icons.graphic_eq_outlined,
                        color: isNoiseDetected
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 12),

              // Noise level display
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Noise Level',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${currentDecibels.toStringAsFixed(1)} dB',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isNoiseDetected
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '/ $threshold dB',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Mini sparkline (simplified visualization)
              _buildMiniSparkline(context, currentDecibels, threshold),

              const SizedBox(width: 8),

              // Expand indicator
              Icon(
                Icons.unfold_more,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniSparkline(
      BuildContext context, double currentDb, double threshold) {
    final percentage = (currentDb / 100).clamp(0.0, 1.0);

    return SizedBox(
      width: 40,
      height: 30,
      child: CustomPaint(
        painter: _MiniSparklinePainter(
          value: percentage,
          threshold: threshold / 100,
          color: currentDb > threshold
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          backgroundColor:
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

/// Simple sparkline painter for noise visualization
class _MiniSparklinePainter extends CustomPainter {
  final double value;
  final double threshold;
  final Color color;
  final Color backgroundColor;

  _MiniSparklinePainter({
    required this.value,
    required this.threshold,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw simplified waveform bars
    const barCount = 5;
    final barWidth = (size.width - (barCount - 1) * 4) / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + 4);
      final randomHeight = (size.height * 0.3) +
          (size.height * 0.7 * math.sin(i * 1.2 + value * math.pi * 2));
      final barHeight = randomHeight.clamp(size.height * 0.2, size.height);

      final barPaint = Paint()
        ..color = value > threshold ? color : color.withValues(alpha: 0.6)
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x + barWidth / 2, size.height),
        Offset(x + barWidth / 2, size.height - barHeight),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_MiniSparklinePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.threshold != threshold;
  }
}
