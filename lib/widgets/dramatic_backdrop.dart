import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focus_field/theme/theme_extensions.dart';

/// Fullscreen animated backdrop for premium themes (cyberNeon, luxury).
///
/// - Uses DramaticThemeStyling.appBackgroundGradient as the base layer.
/// - If neonAnimated is true, gently animates the gradient direction and
///   overlays a few soft moving neon blobs using provided neonColors or
///   statAccentColors.
/// - Respects reduced motion via MediaQuery.disableAnimations.
class DramaticBackdrop extends StatefulWidget {
  final Widget child;

  const DramaticBackdrop({super.key, required this.child});

  @override
  State<DramaticBackdrop> createState() => _DramaticBackdropState();
}

class _DramaticBackdropState extends State<DramaticBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // very slow, subtle movement
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dramatic = theme.extension<DramaticThemeStyling>();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // If no dramatic gradient configured, return child as-is.
    if (dramatic?.appBackgroundGradient == null) {
      return widget.child;
    }

    final animate = (dramatic?.neonAnimated ?? false) && !reduceMotion;

    return Stack(
      children: [
        // Animated gradient layer (or static if animations disabled)
        Positioned.fill(
          child: animate
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _controller.value * 2 * math.pi; // 0..2π
                    // Animate begin/end around the unit circle for gentle drift
                    final begin = Alignment(
                      math.cos(t) * 0.8,
                      math.sin(t) * 0.8,
                    );
                    final end = Alignment(
                      math.cos(t + math.pi) * 0.8,
                      math.sin(t + math.pi) * 0.8,
                    );
                    final g = dramatic!.appBackgroundGradient!;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: begin,
                          end: end,
                          colors: g.colors,
                          stops: g.stops,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: dramatic!.appBackgroundGradient,
                  ),
                ),
        ),

        // Neon blobs overlay for extra "flashy" feel (kept subtle to avoid distraction)
        if (animate)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final sz = MediaQuery.sizeOf(context);
                  final neonColors = dramatic!.neonColors ??
                      dramatic.statAccentColors ??
                      [theme.colorScheme.primary];

                  // Up to three moving blobs using available colors
                  final blobs = <Widget>[];
                  final count = math.min(3, neonColors.length);
                  for (var i = 0; i < count; i++) {
                    final phase = (i / count) * 2 * math.pi;
                    final t = _controller.value * 2 * math.pi;
                    final r = 0.35 + i * 0.06; // orbit radius fraction
                    final cx = 0.5 + r * math.cos(t + phase);
                    final cy = 0.5 + r * math.sin(t * 0.9 + phase);
                    final size = math.max(sz.width, sz.height) * (0.7 - i * 0.12);
                    blobs.add(
                      _NeonBlob(
                        color: neonColors[i].withValues(alpha: 0.10 + 0.04 * (2 - i)),
                        diameter: size,
                        center: Offset(cx * sz.width, cy * sz.height),
                        blurSigma: 60 + i * 8.0,
                      ),
                    );
                  }
                  return Stack(children: blobs);
                },
              ),
            ),
          ),

        // Foreground app content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _NeonBlob extends StatelessWidget {
  final Color color;
  final double diameter;
  final Offset center;
  final double blurSigma;

  const _NeonBlob({
    required this.color,
    required this.diameter,
    required this.center,
    required this.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: center.dx - diameter / 2,
      top: center.dy - diameter / 2,
      width: diameter,
      height: diameter,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Use a radial gradient to simulate a soft neon glow
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.0),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.7),
              blurRadius: blurSigma,
              spreadRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
