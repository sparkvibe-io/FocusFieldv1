import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

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
                        size: math.min(size * 0.2, 80), // Responsive size with max limit
                        color: isListening ? theme.colorScheme.error : primaryColor,
                      ),
                      const SizedBox(height: 6),
                      
                      // Text label
                      Text(
                        isListening ? 'Stop' : 'Start',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isListening ? theme.colorScheme.error : primaryColor,
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
        fontSize: math.min(size * 0.08, 24), // Responsive font size with max limit
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

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
