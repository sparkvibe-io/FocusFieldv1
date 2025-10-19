import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math' as math;

/// Test showcase widget to display all 4 activity ring layouts with mock data
class ActivityRingsTestShowcase extends ConsumerWidget {
  const ActivityRingsTestShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(context, '1 Activity Layout'),
          _buildLayout1Activity(context),
          const Divider(height: 32),
          
          _buildSectionHeader(context, '2 Activities Layout'),
          _buildLayout2Activities(context),
          const Divider(height: 32),
          
          _buildSectionHeader(context, '3 Activities Layout'),
          _buildLayout3Activities(context),
          const Divider(height: 32),
          
          _buildSectionHeader(context, '4 Activities Layout'),
          _buildLayout4Activities(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Layout 1: 1 Activity - Equal sized rings
  Widget _buildLayout1Activity(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ring Progress (20min/20min)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRing(
                context: context,
                icon: Icons.school_outlined,
                label: 'Study',
                progress: 0.75,
                color: const Color(0xFF7F6BB0),
                size: 140,
                iconSize: 40,
                showStats: false,
              ),
              _buildRing(
                context: context,
                label: 'Overall',
                progress: 0.67,
                color: Theme.of(context).colorScheme.primary,
                size: 140,
                iconSize: 40,
                showStats: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Layout 2: 2 Activities - Smaller activity rings + larger overall
  Widget _buildLayout2Activities(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ring Progress (1.2h/2h)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rings
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRing(
                      context: context,
                      icon: Icons.school_outlined,
                      label: 'Study',
                      progress: 0.60,
                      color: const Color(0xFF7F6BB0),
                      size: 75,
                      iconSize: 28,
                      showStats: false,
                    ),
                    _buildRing(
                      context: context,
                      icon: Icons.menu_book_outlined,
                      label: 'Reading',
                      progress: 0.80,
                      color: const Color(0xFF5B9BD5),
                      size: 75,
                      iconSize: 28,
                      showStats: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildRing(
                context: context,
                label: 'Overall',
                progress: 0.67,
                color: Theme.of(context).colorScheme.primary,
                size: 120,
                iconSize: 36,
                showStats: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Layout 3: 3 Activities - Three rings + larger overall
  Widget _buildLayout3Activities(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ring Progress (1.6h/2h)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rings - optimized spacing and proportions
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRing(
                      context: context,
                      icon: Icons.school_outlined,
                      label: 'Study',
                      progress: 0.60,
                      color: const Color(0xFF7F6BB0),
                      size: 62,
                      iconSize: 24,
                      showStats: false,
                    ),
                    _buildRing(
                      context: context,
                      icon: Icons.menu_book_outlined,
                      label: 'Reading',
                      progress: 0.80,
                      color: const Color(0xFF5B9BD5),
                      size: 62,
                      iconSize: 24,
                      showStats: false,
                    ),
                    _buildRing(
                      context: context,
                      icon: Icons.self_improvement_outlined,
                      label: 'Meditation',
                      progress: 0.40,
                      color: const Color(0xFF70AD47),
                      size: 62,
                      iconSize: 24,
                      showStats: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildRing(
                context: context,
                label: 'Overall',
                progress: 0.67,
                color: Theme.of(context).colorScheme.primary,
                size: 98,
                iconSize: 30,
                showStats: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Layout 4: 4 Activities - 2x2 grid + larger overall
  Widget _buildLayout4Activities(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ring Progress (5h/7h)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rings
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRing(
                          context: context,
                          icon: Icons.school_outlined,
                          label: 'Study',
                          progress: 0.60,
                          color: const Color(0xFF7F6BB0),
                          size: 65,
                          iconSize: 24,
                          showStats: false,
                        ),
                        _buildRing(
                          context: context,
                          icon: Icons.menu_book_outlined,
                          label: 'Reading',
                          progress: 0.80,
                          color: const Color(0xFF5B9BD5),
                          size: 65,
                          iconSize: 24,
                          showStats: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRing(
                          context: context,
                          icon: Icons.work_outline,
                          label: 'Work',
                          progress: 0.90,
                          color: const Color(0xFFFF8C42),
                          size: 65,
                          iconSize: 24,
                          showStats: false,
                        ),
                        _buildRing(
                          context: context,
                          icon: Icons.directions_run_outlined,
                          label: 'Running',
                          progress: 0.50,
                          color: const Color(0xFFB565D8),
                          size: 65,
                          iconSize: 24,
                          showStats: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildRing(
                context: context,
                label: 'Overall',
                progress: 0.67,
                color: Theme.of(context).colorScheme.primary,
                size: 120,
                iconSize: 36,
                showStats: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRing({
    required BuildContext context,
    IconData? icon,
    required String label,
    required double progress,
    required Color color,
    required double size,
    required double iconSize,
    required bool showStats,
  }) {
  final theme = Theme.of(context);
  final backgroundColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.18);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: 1.0,
                  color: backgroundColor,
                  strokeWidth: size * 0.10,
                ),
              ),
              // Progress circle
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: progress,
                  color: color,
                  strokeWidth: size * 0.10,
                ),
              ),
              // Center content
              if (showStats)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                )
              else if (icon != null)
                // Icon with colored background circle
                Container(
                  width: size * 0.55,
                  height: size * 0.55,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? theme.colorScheme.onPrimary,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Custom painter for circular progress rings
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (270 degrees = -π/2 radians)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

