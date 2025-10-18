import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

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
      totalSeconds = calculatedTotal.isFinite && calculatedTotal > 0
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
    final discreteRemaining = ((actualRemaining / intervalSeconds).round() * intervalSeconds)
        .clamp(0, totalSeconds);

    // If discrete calculation results in 0 but we still have remaining time,
    // show the actual remaining time (happens at very end of session)
    final displayTime = discreteRemaining == 0 && actualRemaining > 0
        ? actualRemaining
        : discreteRemaining;

    final minutes = displayTime ~/ 60;
    final seconds = displayTime % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // White status bar icons on black background
      child: Material(
        color: Colors.black,
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
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Minimal glowing progress ring with optional pause icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _FocusModeRing(
                        progress: progress,
                        size: 280,
                      ),
                      // Show pause icon at center when paused
                      if (isPaused)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.6),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.pause,
                            color: Colors.white,
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
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Session Complete!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Great focus session',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.6),
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
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                child: Text(
                                  isPaused ? 'Resume' : 'Pause',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                            // Stop button
                            GestureDetector(
                              onLongPress: onStop,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Hint text
                        Text(
                          'Long press to pause or stop',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.4),
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
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
                padding: const EdgeInsets.all(12),
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

  const _FocusModeRing({
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Cyan color for the glowing ring effect
    const ringColor = Color(0xFF00F5FF); // Bright cyan
    const glowColor = Color(0xFF00D4FF); // Slightly darker cyan for depth

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FocusModeRingPainter(
          progress: progress.clamp(0.0, 1.0),
          ringColor: ringColor,
          glowColor: glowColor,
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

  _FocusModeRingPainter({
    required this.progress,
    required this.ringColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 40) / 2; // Leave space for glow
    const strokeWidth = 12.0;

    // Draw multiple layers for glow effect (from outer to inner)
    // Outermost glow - very subtle
    final outerGlowPaint = Paint()
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
    final middleGlowPaint = Paint()
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
    final innerGlowPaint = Paint()
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
    final mainRingPaint = Paint()
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

    // Background ring (very subtle dark gray)
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
