import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:silence_score/theme/theme_extensions.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final bool isListening;
  final VoidCallback? onTap;
  final int? sessionDurationSeconds; // Total session duration for countdown

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 320, // Larger for primary control
    this.color,
    this.backgroundColor,
    this.strokeWidth = 18, // Thicker stroke
    required this.isListening,
    this.onTap,
    this.sessionDurationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;
    final dramatic = theme.extension<DramaticThemeStyling>();
    final bgColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final isNeon =
        dramatic?.statAccentColors != null &&
        dramatic!.statAccentColors!.length >= 3 &&
        dramatic.statAccentColors![0].value == 0xFF00F5FF;

    // Ensure progress is within valid bounds
    final clampedProgress = progress.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _ProgressPainter(
                  progress: 1.0, // Full circle for background
                  color: bgColor,
                  strokeWidth: strokeWidth,
                ),
              ),

              // Progress circle (only when listening)
              if (isListening)
                CustomPaint(
                  size: Size(size, size),
                  painter: _ProgressPainter(
                    progress: clampedProgress,
                    color: primaryColor,
                    strokeWidth: strokeWidth,
                    gradient:
                        dramatic?.statAccentColors != null
                            ? (isNeon
                                ? SweepGradient(
                                  startAngle: -math.pi / 2,
                                  endAngle: 3 * math.pi / 2,
                                  colors: [
                                    dramatic.statAccentColors![0],
                                    dramatic.statAccentColors![1],
                                    dramatic.statAccentColors![2],
                                    dramatic.statAccentColors![0],
                                  ],
                                  stops: const [0, 0.33, 0.66, 1.0],
                                )
                                : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    dramatic!.statAccentColors![0].withOpacity(
                                      0.9,
                                    ),
                                    dramatic.statAccentColors!.last.withOpacity(
                                      0.9,
                                    ),
                                  ],
                                ))
                            : null,
                    glow:
                        isNeon
                            ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.45),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: primaryColor.withOpacity(0.25),
                                blurRadius: 48,
                                spreadRadius: 12,
                              ),
                            ]
                            : [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.22),
                                blurRadius: 36,
                                spreadRadius: 6,
                              ),
                            ],
                  ),
                ),

              // Center content with proper constraints and overflow protection
              Container(
                constraints: BoxConstraints(
                  maxWidth: size * 0.75, // Slightly smaller to prevent overflow
                  maxHeight: size * 0.75,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Countdown timer (only when listening)
                      if (isListening && sessionDurationSeconds != null) ...[
                        _buildCountdownText(theme),
                        const SizedBox(height: 8),
                      ],

                      // Icon with responsive size
                      Icon(
                        isListening ? Icons.stop : Icons.play_arrow,
                        size: math.min(
                          size * 0.2,
                          80,
                        ), // Responsive size with max limit
                        color:
                            isListening
                                ? theme.colorScheme.error
                                : primaryColor,
                      ),
                      const SizedBox(height: 6),

                      // Text label
                      Text(
                        isListening ? 'Stop' : 'Start',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isListening
                                  ? theme.colorScheme.error
                                  : primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownText(ThemeData theme) {
    if (sessionDurationSeconds == null) return const SizedBox.shrink();

    // Calculate remaining time
    final totalSeconds = sessionDurationSeconds!;
    final remainingSeconds = (totalSeconds * (1 - progress)).round();

    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return Text(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
        fontSize: math.min(
          size * 0.08,
          24,
        ), // Responsive font size with max limit
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final Gradient? gradient;
  final List<BoxShadow>? glow;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.gradient,
    this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw glow if provided
    if (glow != null && glow!.isNotEmpty) {
      for (final g in glow!) {
        final glowPaint =
            Paint()
              ..color = g.color
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, g.blurRadius)
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          progress * 2 * math.pi,
          false,
          glowPaint,
        );
      }
    }

    final paint =
        Paint()
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    } else {
      paint.color = color;
    }

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      progress * 2 * math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
