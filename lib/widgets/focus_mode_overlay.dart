import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/widgets/banner_ad_footer.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/utils/debug_log.dart';
import 'dart:math' as math;
import 'package:focus_field/l10n/app_localizations.dart';

/// Full-screen black overlay for minimal distraction during sessions
/// P1 MVP: Black background, glowing progress ring, countdown, Pause/Stop buttons, X exit
class FocusModeOverlay extends ConsumerWidget {
  final double progress; // 0.0 to 1.0
  final int remainingSeconds; // Time remaining in session
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onExit;
  final bool isPaused;

  const FocusModeOverlay({
    super.key,
    required this.progress,
    required this.remainingSeconds,
    required this.onPause,
    required this.onStop,
    required this.onExit,
    this.isPaused = false,
  });

  /// Calculate time display with adaptive intervals based on session duration
  /// - < 1 min: Update every 5 seconds
  /// - 1-10 min: Update every 10 seconds
  /// - 10-60 min: Update every 1 minute
  /// - > 1 hour: Update every 5 minutes
  String _getDiscretTimeDisplay() {
    // Only show 00:00 when session is truly complete
    if (remainingSeconds <= 0) {
      return '00:00';
    }

    // Calculate actual remaining time (always safe, never negative)
    final actualRemaining = remainingSeconds.clamp(0, double.infinity).round();

    // Calculate total duration from remaining and progress
    // When progress is very close to 1.0, use remaining time directly
    int totalSeconds;
    if (progress >= 0.995) {
      // Near completion: use remaining time directly to avoid division issues
      totalSeconds = actualRemaining;
    } else {
      // Normal operation: calculate total from progress
      final progressDivisor = (1 - progress).clamp(0.01, 1.0);
      final calculatedTotal = remainingSeconds / progressDivisor;

      // Safety check for Infinity/NaN
      totalSeconds =
          calculatedTotal.isFinite && calculatedTotal > 0
              ? calculatedTotal.round()
              : actualRemaining;
    }

    // Determine update interval based on total session duration
    int intervalSeconds;
    if (totalSeconds < 60) {
      // < 1 minute: update every 5 seconds
      intervalSeconds = 5;
    } else if (totalSeconds < 600) {
      // 1-10 minutes: update every 10 seconds
      intervalSeconds = 10;
    } else if (totalSeconds < 3600) {
      // 10-60 minutes: update every 1 minute
      intervalSeconds = 60;
    } else {
      // > 1 hour: update every 5 minutes
      intervalSeconds = 300;
    }

    // Round remaining time to nearest interval
    final discreteRemaining = ((actualRemaining / intervalSeconds).round() *
            intervalSeconds)
        .clamp(0, totalSeconds);

    // If discrete calculation results in 0 but we still have remaining time,
    // show the actual remaining time (happens at very end of session)
    final displayTime =
        discreteRemaining == 0 && actualRemaining > 0
            ? actualRemaining
            : discreteRemaining;

    final minutes = displayTime ~/ 60;
    final seconds = displayTime % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Check subscription status to conditionally show ads (consistent with Today/Sessions tabs)
    final hasPremiumAccess = ref.watch(premiumAccessProvider);

    // Debug logging for ad display (development only)
    if (kDebugMode && !hasPremiumAccess) {
      DebugLog.d('[Focus Mode] Rendering ad banner for free user');
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light, // Light status bar icons on dark surface
      child: Material(
        color: scheme.surface, // immersive surface color
        child: Stack(
          children: [
            // Main content - centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Countdown timer above ring
                  Text(
                    _getDiscretTimeDisplay(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: scheme.onSurface,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Minimal glowing progress ring with optional pause icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _FocusModeRing(progress: progress, size: 280),
                      // Show pause icon at center when paused
                      if (isPaused)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.surface.withValues(alpha: 0.6),
                            border: Border.all(
                              color: scheme.onSurface.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.pause,
                            color: scheme.onSurface,
                            size: 48,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 80),

                  // Show completion message when session is done, otherwise show buttons
                  if (remainingSeconds <= 0 && progress >= 0.99)
                    // Session completed - show success message
                    Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: scheme.primary,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.focusModeComplete,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.focusModeGreatSession,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  else
                    // Session in progress - show Pause/Stop buttons
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Pause/Resume button
                            GestureDetector(
                              onLongPress: onPause,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: Text(
                                  isPaused ? l10n.focusModeResume : l10n.focusModePause,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    color: scheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                            // Stop button
                            GestureDetector(
                              onLongPress: onStop,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: Text(
                                  l10n.sessionStop,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    color: scheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Hint text
                        Text(
                          l10n.focusModeLongPressHint,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Exit button (X) - top right
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: IconButton(
                onPressed: onExit,
                icon: Icon(Icons.close, color: scheme.onSurface, size: 28),
                padding: const EdgeInsets.all(12),
              ),
            ),

            // Banner ad - bottom center (only for free users)
            // Main scaffold ad is disposed when Focus Mode activates (conditional rendering)
            // This ensures only ONE ad instance exists at any time
            // UniqueKey ensures Flutter treats this as a separate widget from main page ad
            if (!hasPremiumAccess)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 8,
                left: 0,
                right: 0,
                child: Center(
                  child: FooterBannerAd(
                    key: const ValueKey('focus_mode_ad'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Minimal glowing progress ring for Focus Mode
/// Inspired by sleek meditation app aesthetics with cyan glow
class _FocusModeRing extends StatelessWidget {
  final double progress;
  final double size;

  const _FocusModeRing({required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    // Theme-aware ring/glow colors: prefer primary/tertiary accents
    final cs = Theme.of(context).colorScheme;
    final ringColor = cs.primary;
    final glowColor = cs.primary.withValues(alpha: 0.8);
    final bgColor = cs.onSurfaceVariant.withValues(alpha: 0.14);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FocusModeRingPainter(
          progress: progress.clamp(0.0, 1.0),
          ringColor: ringColor,
          glowColor: glowColor,
          backgroundColor: bgColor,
        ),
      ),
    );
  }
}

/// Custom painter for the glowing Focus Mode ring
class _FocusModeRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color glowColor;
  final Color backgroundColor;

  _FocusModeRingPainter({
    required this.progress,
    required this.ringColor,
    required this.glowColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 40) / 2; // Leave space for glow
    const strokeWidth = 12.0;

    // Draw multiple layers for glow effect (from outer to inner)
    // Outermost glow - very subtle
    final outerGlowPaint =
        Paint()
          ..color = glowColor.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 32
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      outerGlowPaint,
    );

    // Middle glow - more visible
    final middleGlowPaint =
        Paint()
          ..color = glowColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 16
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      middleGlowPaint,
    );

    // Inner glow - bright
    final innerGlowPaint =
        Paint()
          ..color = ringColor.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      innerGlowPaint,
    );

    // Main ring - sharp and bright
    final mainRingPaint =
        Paint()
          ..color = ringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * 2 * math.pi,
      false,
      mainRingPaint,
    );

    // Background ring (very subtle neutral)
    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
