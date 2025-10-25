import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/silence_provider.dart';

/// A compact, low-power noise tile.
///
/// - Does NOT start ambient monitoring.
/// - Shows a simple dB pill only when a session is running (based on cached reading).
/// - Tapping expands a full chart view elsewhere.
class CompactNoiseTile extends ConsumerWidget {
  final VoidCallback onExpand;
  final double threshold;
  final bool isListening;

  const CompactNoiseTile({
    super.key,
    required this.onExpand,
    required this.threshold,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detector = ref.read(silenceDetectorProvider);

    // Avoid any background loops here. Just read the latest cached value.
    final double currentDb = isListening ? detector.currentDecibel : 0.0;
    final bool highlight = currentDb > threshold && currentDb > 0.0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onExpand,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.graphic_eq, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Noise Level',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isListening ? 'Live view' : 'Tap to measure',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _DbPill(db: currentDb, threshold: threshold, highlight: highlight),
            const SizedBox(width: 8),
            Icon(Icons.unfold_more, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _DbPill extends StatelessWidget {
  final double db;
  final double threshold;
  final bool highlight;
  const _DbPill({required this.db, required this.threshold, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasReading = db > 0.0;
    final Color fg = highlight ? theme.colorScheme.onError : theme.colorScheme.onPrimary;
    final Color bg = highlight ? theme.colorScheme.error : theme.colorScheme.primary;
    final String label = hasReading ? '${db.toStringAsFixed(1)} dB' : '— dB';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: hasReading ? bg : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: hasReading
            ? null
            : Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: hasReading ? fg : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
