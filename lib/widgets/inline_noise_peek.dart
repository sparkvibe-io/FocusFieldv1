import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/providers/activity_provider.dart';
import 'package:focus_field/utils/debug_log.dart';

/// A compact decibel pill that shows the current noise level.
/// - Tap: open full-screen/modal chart via callback.
class InlineNoisePeek extends HookConsumerWidget {
  final double threshold;
  final VoidCallback? onTap;
  final bool isListening;

  const InlineNoisePeek({
    super.key,
    required this.threshold,
    required this.isListening,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.watch(realTimeNoiseControllerProvider);
    final selectedActivity = ref.watch(selectedActivityProvider);

    // State
    final current = useState<double>(0);
    final smoothed = useState<double>(0);

    useEffect(() {
      final sub = controller.stream.listen((d) {
        if (d.isNaN || d.isInfinite) return;
        current.value = d.clamp(0.0, 120.0);
        final s = smoothed.value;
        smoothed.value = (s.isNaN || s.isInfinite) ? current.value : s * 0.7 + current.value * 0.3;
      }, onError: (e) {
        DebugLog.d('InlineNoisePeek stream error: $e');
      });
      return () => sub.cancel();
    }, [controller]);

    final emphasis = selectedActivity == 'noise';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (emphasis ? theme.colorScheme.primary : theme.colorScheme.outline)
                .withValues(alpha: emphasis ? 0.45 : 0.2),
          ),
        ),
        child: Row(
          children: [
            // Icon + optional live indicator
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(
                  Icons.graphic_eq,
                  size: 20,
                  color: smoothed.value > threshold
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                if (isListening)
                  _LiveDot(color: theme.colorScheme.primary),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Noise level',
                    style: theme.textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${smoothed.value.toStringAsFixed(1)} dB',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: smoothed.value > threshold
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  final Color color;
  const _LiveDot({required this.color});

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _a = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _a,
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 6, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}
