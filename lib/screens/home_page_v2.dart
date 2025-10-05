import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/widgets/banner_ad_footer.dart';

/// New experimental Home screen (mockup) focused on a clean, modern layout
/// Minimal dependencies and placeholders only. We'll later move real widgets in.
class HomePageV2 extends ConsumerWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Focus Field', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Soft gradient background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.08),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                children: [
                  // Top: category chips merged (no duplicate icon grid)
                  const _CategoryChipsRow(),
                  const SizedBox(height: 8),

                  // Middle: content that must fit the screen height without scroll
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final width = c.maxWidth;
                        final height = c.maxHeight;
                        final isWide = width > 700;
                        final ringSize = isWide
                            ? 240.0
                            : (width < 360 ? 170.0 : 200.0);

                        final statsHeight = 76.0;
                        final missionHeight = height - ringSize - statsHeight - 36; // spacing allowance

                        final ringCard = _Card(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Universal Start', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              _QuickDurations(),
                              const SizedBox(height: 8),
                              SizedBox(width: ringSize, height: ringSize, child: _BigRing()),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to start a focused session',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        );

                        final statsRow = SizedBox(
                          height: statsHeight,
                          child: Row(
                            children: const [
                              Expanded(child: _StatTile(label: 'Points', value: '42', icon: Icons.bolt)),
                              SizedBox(width: 8),
                              Expanded(child: _StatTile(label: 'Streak', value: '3', icon: Icons.local_fire_department)),
                              SizedBox(width: 8),
                              Expanded(child: _StatTile(label: 'Sessions', value: '12', icon: Icons.timelapse)),
                            ],
                          ),
                        );

                        final missionCard = SizedBox(
                          height: missionHeight.clamp(120.0, 240.0),
                          child: _Card(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _MissionHeader(),
                                const SizedBox(height: 6),
                                const _CapsuleProgressRow(
                                  icon: Icons.school,
                                  label: 'Study',
                                  progress: 0.6,
                                  goalText: '1h12m / 2h',
                                ),
                                const SizedBox(height: 8),
                                const _CapsuleProgressRow(
                                  icon: Icons.menu_book,
                                  label: 'Reading',
                                  progress: 0.25,
                                  goalText: '15m / 1h',
                                ),
                                const SizedBox(height: 8),
                                const _CapsuleProgressRow(
                                  icon: Icons.fitness_center,
                                  label: 'Gym',
                                  progress: 0.1,
                                  goalText: '6m / 1h',
                                ),
                              ],
                            ),
                          ),
                        );

                        if (isWide) {
                          // Side-by-side on tablets/landscape
                          return Row(
                            children: [
                              Expanded(flex: 10, child: ringCard),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 12,
                                child: Column(
                                  children: [statsRow, const SizedBox(height: 8), missionCard],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Stack vertically on phones
                          return Column(
                            children: [
                              ringCard,
                              const SizedBox(height: 8),
                              statsRow,
                              const SizedBox(height: 8),
                              missionCard,
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  // Bottom: footer ad pinned without scrolling
                  const FooterBannerAd(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BigRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const size = 240.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.secondary.withValues(alpha: 0.15),
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                ],
              ),
            ),
          ),
          // Track background
          Container(
            width: size - 14,
            height: size - 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          // Active arc (static for mockup)
          SizedBox(
            width: size - 14,
            height: size - 14,
            child: CustomPaint(
              painter: _ArcPainter(color: theme.colorScheme.primary, sweep: 0.35),
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('15:00', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              IconButton(
                onPressed: () {},
                iconSize: 36,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                icon: const Icon(Icons.play_arrow),
              ),
              const SizedBox(height: 6),
              Text('Start', style: theme.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.color, required this.sweep});
  final Color color;
  final double sweep; // 0..1
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final bg = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = SweepGradient(colors: [color, color.withValues(alpha: 0.6), color])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    // Background full circle
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.57, 6.283, false, bg);
    // Foreground arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.57, sweep * 6.283, false, fg);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Top filters row replacing the old bottom icon grid
class _CategoryChipsRow extends StatelessWidget {
  const _CategoryChipsRow();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const items = [
      ('studying', Icons.school),
      ('reading', Icons.menu_book),
      ('work', Icons.work_outline),
      ('meditate', Icons.self_improvement),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (label, icon) in items) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                selected: label == 'work',
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
                ),
                onSelected: (_) {},
                selectedColor: theme.colorScheme.primaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MissionHeader extends StatelessWidget {
  const _MissionHeader();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('Mission', style: theme.textTheme.titleMedium),
        const Spacer(),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.tune), label: const Text('Edit')),
      ],
    );
  }
}

// Capsule row + mini 24h timeline chart
class _CapsuleProgressRow extends StatelessWidget {
  const _CapsuleProgressRow({
    required this.icon,
    required this.label,
    required this.progress, // 0..1
    required this.goalText,
  });
  final IconData icon;
  final String label;
  final double progress;
  final String goalText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, size: 18, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(label, style: theme.textTheme.labelLarge)),
                  Text(goalText, style: theme.textTheme.labelLarge?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(color: theme.colorScheme.surfaceContainerHigh),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _MiniTimeline24(),
      ],
    );
  }
}

class _MiniTimeline24 extends StatelessWidget {
  const _MiniTimeline24();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 12 tiny ticks mocked; in real version we can map 24 hours
    final ticks = List<double>.generate(12, (i) => i % 3 == 0 ? 1 : (i % 4 == 0 ? .6 : .3));
    return SizedBox(
      width: 64,
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final t in ticks)
            Container(
              width: 3,
              height: 6 + 14 * t,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

// Removed old _IconBubble grid; merged into top chips

class _QuickDurations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final opts = const [5, 10, 15, 30, 60];
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      children: [
        for (final d in opts)
          ChoiceChip(
            label: Text('${d}m'),
            selected: d == 15,
            onSelected: (_) {},
            selectedColor: theme.colorScheme.primaryContainer,
          ),
      ],
    );
  }
}
