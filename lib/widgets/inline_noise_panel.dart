import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/widgets/real_time_noise_chart.dart';
import 'package:focus_field/theme/theme_extensions.dart';

/// Inline panel that shows room loudness with smart threshold suggestions.
/// Three states:
/// 1. Normal (quiet): Shows dB + "Set Threshold: XXdB" button
/// 2. High noise (>=70dB): Shows dB + warning message + higher threshold button
/// 3. Active session (isListening): Shows dB + live chart on the right
class InlineNoisePanel extends HookConsumerWidget {
  final double threshold;
  final bool isListening;

  const InlineNoisePanel({
    super.key,
    required this.threshold,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.watch(realTimeNoiseControllerProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    // Live values
    final current = useState<double>(0);
    final smoothed = useState<double>(0);

    // Pulse animation controller for threshold exceeded state
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final pulseAnimation = useAnimation(
      Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
    );

    useEffect(() {
      final sub = controller.stream.listen((d) {
        if (d.isNaN || d.isInfinite) return;
        final clamped = d.clamp(0.0, 120.0);
        current.value = clamped;
        final s = smoothed.value;
        smoothed.value =
            (s.isNaN || s.isInfinite) ? clamped : s * 0.7 + clamped * 0.3;
      });
      return () => sub.cancel();
    }, [controller]);

    // Start/stop pulse animation based on threshold exceeded state
    useEffect(() {
      if (!isListening && smoothed.value > threshold) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [smoothed.value, threshold, isListening]);

    // Start ambient monitoring when not in an active session
    // Only runs when isListening changes, not on every build
    useEffect(
      () {
        if (!isListening) {
          final silenceDetector = ref.read(silenceDetectorProvider);

          // Start ambient monitoring when not in a session
          try {
            silenceDetector.startAmbientMonitoring(
              onError: (error) {
                // Silently handle errors - user will see them if they try to start a session
              },
            );
          } catch (e) {
            // Ignore startup errors
          }
        }

        // Cleanup: stop ambient monitoring when widget unmounts or session starts
        return () {
          if (!isListening) {
            try {
              final detector = ref.read(silenceDetectorProvider);
              detector.stopAmbientMonitoring();
            } catch (_) {}
          }
        };
      },
      [isListening],
    ); // FIXED: Only re-run when listening state changes, not on every build

    // Determine if room is too noisy (high threshold warning level)
    final isHighNoise = smoothed.value >= 70.0;

    // Active session state: show chart
    if (isListening) {
      // Vibrant tint for active listening (use primary color)
      final isDark = theme.brightness == Brightness.dark;
      final tintColor = theme.colorScheme.primary; // Use theme primary color
      final baseDecoration = context.cardDecoration;

      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: baseDecoration.copyWith(
          color:
              isDark
                  ? Color.alphaBlend(
                    tintColor.withValues(alpha: 0.18),
                    theme.colorScheme.surfaceContainerHighest,
                  )
                  : Color.alphaBlend(
                    tintColor.withValues(alpha: 0.12),
                    theme.colorScheme.surfaceContainerHighest,
                  ),
        ),
        child: Row(
          children: [
            // Left: dB display
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room Loudness',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${smoothed.value.toStringAsFixed(1)}dB',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color:
                              smoothed.value > threshold
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right: chart (reduced height)
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 80, // Reduced from context.chartHeight
                child: RealTimeNoiseChart(
                  threshold: threshold,
                  isListening: isListening,
                  showHeader: false, // Hide threshold text header
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Determine color based on noise levels
    final isExceeding = smoothed.value > threshold;
    Color getLoudnessColor() {
      final sc = context.semanticColors;
      if (isHighNoise) return theme.colorScheme.error;
      if (isExceeding) return sc.warning;
      return theme.colorScheme.primary;
    }

    // Vibrant tint for room loudness widget (use primary color)
    final isDark = theme.brightness == Brightness.dark;
    final tintColor = theme.colorScheme.primary; // Use theme primary color
    final baseDecoration = context.cardDecoration;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: baseDecoration.copyWith(
        color:
            isDark
                ? Color.alphaBlend(
                  tintColor.withValues(alpha: 0.18),
                  theme.colorScheme.surfaceContainerHighest,
                )
                : Color.alphaBlend(
                  tintColor.withValues(alpha: 0.12),
                  theme.colorScheme.surfaceContainerHighest,
                ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and current threshold badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Title
              Text(
                'Room Loudness',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              // Right: Current threshold badge (pulses RED when exceeded)
              Opacity(
                opacity: isExceeding ? pulseAnimation : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isExceeding
                            ? theme.colorScheme.errorContainer.withValues(
                              alpha: 0.20,
                            )
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isExceeding
                              ? theme.colorScheme.error.withValues(alpha: 0.6)
                              : theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      width: isExceeding ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isExceeding) ...[
                        Icon(
                          Icons.error_outline,
                          size: 14,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        'Threshold: ${threshold.round()}dB',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isExceeding
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Compact row: Current loudness + threshold selector buttons
          Row(
            children: [
              // Left: Current loudness reading (slightly smaller to fit buttons)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: getLoudnessColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${smoothed.value.toStringAsFixed(1)}dB',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color:
                          isExceeding
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Right: Scrollable threshold selector buttons to prevent overflow
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (final db in const [30, 40, 50, 60, 80])
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: _buildTextThresholdButton(
                            context,
                            theme,
                            db,
                            threshold.round() == db,
                            () async {
                              await settingsNotifier.updateSetting(
                                'decibelThreshold',
                                db.toDouble(),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Threshold set to $db dB'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // High noise warning (only shown when noise >= 70dB)
          if (isHighNoise) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'High noise detected, please proceed to a quieter room for better focus',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build text-only threshold button (matches duration selector style: 1m, 5m, etc.)
  /// Ensures minimum 48x48dp touch target for accessibility (WCAG 2.1 AAA)
  Widget _buildTextThresholdButton(
    BuildContext context,
    ThemeData theme,
    int db,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 48, // Minimum touch target width
            minHeight: 48, // Minimum touch target height
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${db}dB',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
