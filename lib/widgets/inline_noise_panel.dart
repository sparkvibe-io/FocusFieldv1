import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/widgets/real_time_noise_chart.dart';
import 'package:focus_field/constants/ambient_flags.dart';
import 'package:focus_field/providers/ambient_quest_provider.dart';

/// Inline panel that shows a compact noise summary by default with a Chart button.
/// Tapping Chart swaps the panel content with the inline RealTimeNoiseChart.
/// The chart header includes a Text button to toggle back.
class InlineNoisePanel extends HookConsumerWidget {
  final double threshold;
  final bool isListening;

  const InlineNoisePanel({super.key, required this.threshold, required this.isListening});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.watch(realTimeNoiseControllerProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    // UI mode toggle
    final showChart = useState<bool>(false);

    // Live values
    final current = useState<double>(0);
    final smoothed = useState<double>(0);

    // Track last 60 readings (1Hz aggregated), compute simple violations count
    final buffer = useRef<List<(DateTime, double)>>(<(DateTime, double)>[]);
    final violations = useState<int>(0);

    void recomputeViolations() {
      final now = DateTime.now();
      buffer.value = buffer.value.where((e) => now.difference(e.$1).inSeconds <= 60).toList();
      violations.value = buffer.value.where((e) => e.$2 > threshold).length;
    }

    useEffect(() {
      final sub = controller.stream.listen((d) {
        if (d.isNaN || d.isInfinite) return;
        final clamped = d.clamp(0.0, 120.0);
        current.value = clamped;
        final s = smoothed.value;
        smoothed.value = (s.isNaN || s.isInfinite) ? clamped : s * 0.7 + clamped * 0.3;
        buffer.value.add((DateTime.now(), clamped));
        recomputeViolations();
      });
      return () => sub.cancel();
    }, [controller, threshold]);

    if (showChart.value) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Noise Level', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => showChart.value = false,
                  icon: const Icon(Icons.text_fields, size: 16),
                  label: const Text('Text'),
                ),
              ],
            ),
            SizedBox(
              height: 110,
              child: RealTimeNoiseChart(threshold: threshold, isListening: isListening),
            ),
          ],
        ),
      );
    }

    final isNoisy = smoothed.value > threshold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onLongPress: () {
                  // Debug-only cycle: off -> +2 -> -2 -> off
                  bool inDebug = false;
                  assert(() {
                    inDebug = true;
                    return true;
                  }());
                  if (!inDebug) return;
                  final forced = ref.read(debugAdaptiveOverrideProvider);
                  final currentThreshold = ref.read(decibelThresholdProvider).round();
                  if (forced == null) {
                    ref.read(debugAdaptiveOverrideProvider.notifier).state = (currentThreshold + 2).clamp(28, 60);
                  } else if (forced >= currentThreshold) {
                    ref.read(debugAdaptiveOverrideProvider.notifier).state = (currentThreshold - 2).clamp(28, 60);
                  } else {
                    ref.read(debugAdaptiveOverrideProvider.notifier).state = null;
                  }
                },
                child: Text('Noise Level', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
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
                    '${smoothed.value.toStringAsFixed(1)} dB',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isNoisy ? theme.colorScheme.error : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => showChart.value = true,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Chart'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Icon(Icons.rule, size: 16, color: theme.colorScheme.onSurfaceVariant),
              Text(
                'Threshold: ${threshold.toStringAsFixed(0)} dB',
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              Icon(Icons.error_outline, size: 16, color: isNoisy ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant),
              Text(
                'Violations (last 60s): ${violations.value}',
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              if (AmbientFlags.adaptiveThreshold)
                Builder(builder: (context) {
                  final suggestionAsync = ref.watch(adaptiveThresholdProvider);
                  return suggestionAsync.when(
                    data: (value) {
                      if (value == null) return const SizedBox.shrink();
                      final suggestedDb = value.toString();
                      return OutlinedButton.icon(
                        onPressed: () async {
                          await settingsNotifier.updateSetting('decibelThreshold', value.toDouble());
                          // Track last applied to optionally show a small inline hint
                          ref.read(lastAdaptiveAppliedProvider.notifier).state = value;
                          // Persist last applied time for cooldown enforcement
                          final storage = await ref.read(storageServiceProvider.future);
                          await storage.setString('ambient_adaptive_last_applied_ms', DateTime.now().millisecondsSinceEpoch.toString());
                          // Auto-clear the inline hint after a short delay (debug and release)
                          Future.delayed(const Duration(seconds: 2), () {
                            // It's safe to set provider state even if this widget disposes
                            ref.read(lastAdaptiveAppliedProvider.notifier).state = null;
                          });
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Threshold set to $suggestedDb dB'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 14),
                        label: Text('Try $suggestedDb dB'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                }),
            ],
          ),
          // Optional tiny confirmation hint when applied
          Builder(builder: (context) {
            final applied = ref.watch(lastAdaptiveAppliedProvider);
            if (applied == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text('Applied $applied dB', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
