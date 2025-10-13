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

  const InlineNoisePanel({super.key, required this.threshold, required this.isListening});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.watch(realTimeNoiseControllerProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    // Live values
    final current = useState<double>(0);
    final smoothed = useState<double>(0);

    useEffect(() {
      final sub = controller.stream.listen((d) {
        if (d.isNaN || d.isInfinite) return;
        final clamped = d.clamp(0.0, 120.0);
        current.value = clamped;
        final s = smoothed.value;
        smoothed.value = (s.isNaN || s.isInfinite) ? clamped : s * 0.7 + clamped * 0.3;
      });
      return () => sub.cancel();
    }, [controller]);

    // Start ambient monitoring when not in an active session
    // This effect runs whenever the widget rebuilds to ensure monitoring is always active
    // The silenceDetector provider recreates when threshold changes, so we need to restart monitoring
    useEffect(() {
      if (!isListening) {
        // Get fresh reference to silenceDetector on each rebuild
        final silenceDetector = ref.read(silenceDetectorProvider);

        // Always try to start ambient monitoring when not in a session
        // The detector safely ignores duplicate start requests if already monitoring
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
    }); // No dependencies - runs on every build to handle detector recreation

    // Calculate suggested threshold: current dB + 5, rounded to nearest 5
    int calculateSuggestedThreshold() {
      final raw = (smoothed.value + 5).round();
      return ((raw / 5).round() * 5).clamp(20, 80);
    }

    // Determine if room is too noisy (high threshold warning level)
    final isHighNoise = smoothed.value >= 70.0;

    // Active session state: show chart
    if (isListening) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: context.subtleCardDecoration,
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
                          color: smoothed.value > threshold
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
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

    // Default state: smart threshold suggestions
    final suggestedThreshold = calculateSuggestedThreshold();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: context.subtleCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: dB display
              Expanded(
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
                            color: isHighNoise
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right: threshold suggestion button
              OutlinedButton(
                onPressed: () async {
                  await settingsNotifier.updateSetting('decibelThreshold', suggestedThreshold.toDouble());
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Threshold set to $suggestedThreshold dB'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('Set Threshold: ${suggestedThreshold}dB'),
              ),
            ],
          ),
          // High noise warning (only shown when noise >= 70dB)
          if (isHighNoise) ...[
            const SizedBox(height: 8),
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
}
