import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/services/silence_detector.dart';
import 'package:focus_field/widgets/real_time_noise_chart.dart';
import 'package:focus_field/theme/theme_extensions.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/utils/debug_log.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(realTimeNoiseControllerProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    if (!kReleaseMode) {
      DebugLog.d(
        '🔄 [InlineNoisePanel] Widget rebuilding (isListening: $isListening, threshold: $threshold, controller: ${controller.hashCode})',
      );
    }

    // Live values
    final current = useState<double>(0);
    final smoothed = useState<double>(0);

    // Pulse animation controller for threshold exceeded state
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    // Create animation without useAnimation() to avoid rebuilding entire widget
    // AnimatedBuilder will be used to isolate rebuilds to just the pulsing badge
    final pulseAnimation = useMemoized(
      () => Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
      [animationController],
    );

    useEffect(() {
      if (!kReleaseMode) {
        DebugLog.d(
          '📊 [InlineNoisePanel] Setting up noise stream subscription (controller: ${controller.hashCode})',
        );
      }
      final sub = controller.stream.listen((d) {
        if (d.isNaN || d.isInfinite) return;
        final clamped = d.clamp(0.0, 120.0);
        current.value = clamped;
        final s = smoothed.value;
        smoothed.value =
            (s.isNaN || s.isInfinite) ? clamped : s * 0.7 + clamped * 0.3;
      });
      return () {
        if (!kReleaseMode) {
          DebugLog.d(
            '📊 [InlineNoisePanel] Canceling noise stream subscription (controller: ${controller.hashCode})',
          );
        }
        sub.cancel();
      };
    }, [controller.hashCode]); // Re-subscribe when controller changes

    // Start/stop pulse animation based on threshold exceeded state
    useEffect(() {
      if (!kReleaseMode) {
        DebugLog.d(
          '💫 [InlineNoisePanel] Pulse animation effect triggered (smoothed: ${smoothed.value}, threshold: $threshold, isListening: $isListening)',
        );
      }
      if (!isListening && smoothed.value > threshold) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [smoothed.value, threshold, isListening]);

    // Start ambient monitoring when not in an active session
    // IMPORTANT: This needs to restart when detector changes (threshold update creates new detector)
    final currentDetector = ref.watch(silenceDetectorProvider);

    // Track the previous detector to stop it before starting new one
    final previousDetector = usePrevious(currentDetector);

    useEffect(
      () {
        if (!isListening) {
          // CRITICAL: Stop old detector BEFORE starting new one to avoid conflicts
          if (previousDetector != null &&
              previousDetector.hashCode != currentDetector.hashCode) {
            if (!kReleaseMode) {
              DebugLog.d(
                '🎤 [InlineNoisePanel] Stopping old detector (${previousDetector.hashCode}) before starting new one',
              );
            }
            try {
              previousDetector.stopAmbientMonitoring();
            } catch (_) {}
          }

          // Now start ambient monitoring on the NEW detector
          if (!kReleaseMode) {
            DebugLog.d(
              '🎤 [InlineNoisePanel] Starting ambient monitoring (detector: ${currentDetector.hashCode})',
            );
          }

          try {
            currentDetector.startAmbientMonitoring(
              onError: (error) {
                // Silently handle errors - user will see them if they try to start a session
                if (!kReleaseMode) {
                  DebugLog.d(
                    '🎤 [InlineNoisePanel] Ambient monitoring error: $error',
                  );
                }
              },
            );
          } catch (e) {
            // Ignore startup errors
            if (!kReleaseMode) {
              DebugLog.d(
                '🎤 [InlineNoisePanel] Exception starting ambient monitoring: $e',
              );
            }
          }

          // Cleanup: stop ambient monitoring ONLY if this detector is still current
          // (if detector changed, we already stopped it manually above)
          return () {
            // Check if this is still the current detector before stopping
            final latestDetector = ref.read(silenceDetectorProvider);
            if (latestDetector.hashCode == currentDetector.hashCode) {
              if (!kReleaseMode) {
                DebugLog.d(
                  '🎤 [InlineNoisePanel] Cleanup: stopping ambient monitoring (detector: ${currentDetector.hashCode})',
                );
              }
              try {
                currentDetector.stopAmbientMonitoring();
              } catch (_) {}
            } else {
              if (!kReleaseMode) {
                DebugLog.d(
                  '🎤 [InlineNoisePanel] Cleanup: skipping stop (detector ${currentDetector.hashCode} already replaced by ${latestDetector.hashCode})',
                );
              }
            }
          };
        }

        // No cleanup needed if already listening
        if (!kReleaseMode) {
          DebugLog.d(
            '🎤 [InlineNoisePanel] isListening=true, skipping ambient monitoring',
          );
        }
        return null;
      },
      [isListening, currentDetector.hashCode],
    ); // Re-run when listening state OR detector instance changes

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
                    l10n.noiseRoomLoudness,
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
                l10n.noiseRoomLoudness,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              // Right: Current threshold badge (pulses RED when exceeded)
              // Use AnimatedBuilder to isolate rebuilds to just this badge
              AnimatedBuilder(
                animation: pulseAnimation,
                builder:
                    (context, child) => Opacity(
                      opacity: isExceeding ? pulseAnimation.value : 1.0,
                      child: child,
                    ),
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
                        l10n.noiseThresholdLabel(threshold.round()),
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
          // Single horizontal row: dB reading + (threshold selectors OR contextual message)
          Row(
            children: [
              // Left: Current loudness indicator
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
              const SizedBox(width: 12),
              // Right: Contextual UI - threshold selectors OR message with buttons
              // Fixed height to prevent layout shift between states
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 52, // Consistent height for both states
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:
                        isExceeding
                            ? _buildContextualMessage(
                              context,
                              theme,
                              l10n,
                              smoothed.value,
                              threshold,
                              settingsNotifier,
                              ref,
                            )
                            : _buildThresholdSelectors(
                              context,
                              theme,
                              l10n,
                              threshold,
                              settingsNotifier,
                              ref,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Calculate smart threshold suggestion
  /// Rounds up to next 10dB multiple above current noise
  int _calculateSuggestedThreshold(double currentDb, double currentThreshold) {
    // Round up to next 10dB multiple
    int suggested = ((currentDb / 10).ceil() * 10);

    // Ensure it's higher than current threshold
    if (suggested <= currentThreshold.round()) {
      suggested = currentThreshold.round() + 10;
    }

    // Cap at 80dB max
    return suggested > 80 ? 80 : suggested;
  }

  /// Build threshold selector buttons (shown when NOT exceeding)
  Widget _buildThresholdSelectors(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    double threshold,
    dynamic settingsNotifier,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
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
                  SilenceDetector? detectorBefore;
                  if (!kReleaseMode) {
                    DebugLog.d(
                      '🎚️ [InlineNoisePanel] Threshold button clicked: ${db}dB',
                    );
                    DebugLog.d(
                      '🎚️ [InlineNoisePanel] Current threshold: ${threshold}dB',
                    );
                    detectorBefore = ref.read(silenceDetectorProvider);
                    DebugLog.d(
                      '🎚️ [InlineNoisePanel] Current detector: ${detectorBefore.hashCode}',
                    );
                  }

                  await settingsNotifier.updateSetting(
                    'decibelThreshold',
                    db.toDouble(),
                  );

                  if (!kReleaseMode && detectorBefore != null) {
                    final detectorAfter = ref.read(silenceDetectorProvider);
                    DebugLog.d(
                      '🎚️ [InlineNoisePanel] After update - detector: ${detectorAfter.hashCode}',
                    );
                    DebugLog.d(
                      '🎚️ [InlineNoisePanel] Detector changed: ${detectorBefore.hashCode != detectorAfter.hashCode}',
                    );
                  }

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.noiseThresholdSet(db)),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Build contextual message when threshold is exceeded
  /// Inline compact layout: message text + No/Yes buttons (single row)
  Widget _buildContextualMessage(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    double currentDb,
    double threshold,
    dynamic settingsNotifier,
    WidgetRef ref,
  ) {
    final suggestedThreshold = _calculateSuggestedThreshold(
      currentDb,
      threshold,
    );
    final isAtMax = threshold.round() >= 80;

    // Message text based on conditions
    String message;
    if (isAtMax) {
      message = l10n.noiseAtMaxThreshold;
    } else if (currentDb >= 70.0) {
      message = l10n.noiseHighIncreasePrompt(suggestedThreshold);
    } else {
      message = l10n.noiseExceededIncreasePrompt(suggestedThreshold);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2, // Give more space to message text
          child: Text(
            message,
            textAlign: TextAlign.right, // Right-align text to flow toward button
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.2, // Compact line height for 2 lines
            ),
            maxLines: 2, // Allow 2 lines to show full message
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isAtMax) ...[
          const SizedBox(width: 12),
          // Yes button (primary action)
          FilledButton(
            onPressed: () async {
              SilenceDetector? detectorBefore;
              if (!kReleaseMode) {
                DebugLog.d(
                  '✅ [InlineNoisePanel] Yes button clicked - increasing threshold to ${suggestedThreshold}dB',
                );
                detectorBefore = ref.read(silenceDetectorProvider);
                DebugLog.d(
                  '✅ [InlineNoisePanel] Current detector: ${detectorBefore.hashCode}',
                );
              }

              await settingsNotifier.updateSetting(
                'decibelThreshold',
                suggestedThreshold.toDouble(),
              );

              if (!kReleaseMode && detectorBefore != null) {
                final detectorAfter = ref.read(silenceDetectorProvider);
                DebugLog.d(
                  '✅ [InlineNoisePanel] After update - detector: ${detectorAfter.hashCode}',
                );
              }

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.noiseThresholdSet(suggestedThreshold)),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(48, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Text(
              l10n.noiseThresholdYes,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
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
