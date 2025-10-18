import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/providers/adaptive_threshold_provider.dart';
import 'package:focus_field/providers/silence_provider.dart';

/// Ultra-minimal adaptive threshold suggestion chip
/// Shows after 3 consecutive wins, suggests +2 dB increase
/// Principle: Simple message, easy to understand, dismissible
class AdaptiveThresholdChip extends ConsumerWidget {
  const AdaptiveThresholdChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final adaptiveState = ref.watch(adaptiveThresholdProvider);
    final suggestedThreshold = ref.watch(suggestedThresholdProvider);

    // Don't show if not needed
    if (!adaptiveState.shouldShowSuggestion) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          const Icon(
            Icons.trending_up,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 10),
          // Message
          Expanded(
            child: Text(
              l10n.adaptiveThresholdSuggestion(suggestedThreshold),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
          // Buttons
          TextButton(
            onPressed: () {
              ref.read(adaptiveThresholdProvider.notifier).dismissSuggestion();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.adaptiveThresholdNotNow,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () async {
              // Update threshold using StateProvider
              ref.read(activeDecibelThresholdProvider.notifier).state = suggestedThreshold.toDouble();
              // Persist to storage
              final storage = await ref.read(storageServiceProvider.future);
              await storage.saveDecibelThreshold(suggestedThreshold.toDouble());
              // Mark as accepted
              ref.read(adaptiveThresholdProvider.notifier).acceptSuggestion();
              // Show confirmation
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.adaptiveThresholdConfirm(suggestedThreshold)),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
            ),
            child: Text(
              l10n.adaptiveThresholdTryIt,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
