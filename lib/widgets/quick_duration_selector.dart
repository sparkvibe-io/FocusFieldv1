import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/widgets/feature_gate.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/models/subscription_tier.dart';

/// Quick duration selector widget that displays duration buttons above the progress ring
class QuickDurationSelector extends ConsumerWidget {
  final List<int> durations;
  final int selectedDurationSeconds;
  final Function(int) onDurationSelected;
  final bool enabled;

  const QuickDurationSelector({
    super.key,
    required this.durations,
    required this.selectedDurationSeconds,
    required this.onDurationSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(durations.length, (i) {
              final minutes = durations[i];
              return Padding(
                padding: EdgeInsets.only(
                  right: i < durations.length - 1 ? 4.0 : 0,
                ),
                child: _buildDurationChip(
                  context,
                  ref,
                  theme,
                  loc,
                  minutes,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AppLocalizations? loc,
    int minutes,
  ) {
    final durationSeconds = minutes * 60;
    final isSelected = selectedDurationSeconds == durationSeconds;
    final isPremium = minutes > AppConstants.freeSessionMaxMinutes;
    final subscriptionTier = ref.watch(subscriptionTierStateProvider);
    final hasPremium = subscriptionTier != SubscriptionTier.free;
    final isDisabled = isPremium && !hasPremium;

    // Create the chip widget
    Widget chip = GestureDetector(
      onTap: (enabled && !isDisabled) ? () => _handleDurationSelection(
        context,
        ref,
        loc,
        minutes,
        isPremium,
        hasPremium,
      ) : (isDisabled ? () => showPaywall(
        context,
        requiredTier: SubscriptionTier.premium,
        featureDescription: _getDurationFeatureDescription(minutes, loc),
      ) : null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), // Further reduced for single line
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDisabled
                  ? theme.colorScheme.surface.withValues(alpha: 0.5)
                  : theme.colorScheme.surface),
          // Removed borders completely
          borderRadius: BorderRadius.circular(12), // Slightly smaller radius
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDuration(minutes),
              style: theme.textTheme.labelSmall?.copyWith( // Changed to labelSmall for compact single line
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : (isDisabled
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                        : theme.colorScheme.onSurface),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isPremium) ...[
              const SizedBox(width: 3), // Reduced spacing
              Icon(
                hasPremium ? Icons.star : Icons.star_outline,
                size: 10, // Made even smaller for single line
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : (isDisabled
                        ? Colors.amber.withValues(alpha: 0.5)
                        : Colors.amber),
              ),
            ],
          ],
        ),
      ),
    );

    // Wrap premium durations with FeatureGate for upgrade prompts
    if (isPremium) {
      return FeatureGate(
        featureId: 'extended_sessions',
        fallback: chip, // Still show the chip, but handle premium logic in tap
        child: chip,
      );
    }

    return chip;
  }

  void _handleDurationSelection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations? loc,
    int minutes,
    bool isPremium,
    bool hasPremium,
  ) {
    final durationSeconds = minutes * 60;

    if (isPremium && !hasPremium) {
      // Use the professional paywall system instead of simple dialog
      showPaywall(
        context,
        requiredTier: SubscriptionTier.premium,
        featureDescription: _getDurationFeatureDescription(minutes, loc),
      );
      return;
    }

    // Set the duration
    onDurationSelected(durationSeconds);
  }

  /// Get feature description for duration-based premium features
  String _getDurationFeatureDescription(int minutes, AppLocalizations? loc) {
    if (minutes == 60) {
      return loc?.durationUpTo1Hour ?? 'Sessions up to 1 hour';
    } else if (minutes == 90) {
      return loc?.durationUpTo1_5Hours ?? 'Sessions up to 1.5 hours';
    } else if (minutes == 120) {
      return loc?.durationUpTo2Hours ?? 'Sessions up to 2 hours';
    } else if (minutes > 30) {
      return loc?.durationExtended ?? 'Extended session durations';
    }
    return loc?.durationExtendedAccess ?? 'Extended session access';
  }

  /// Format duration minutes into a user-friendly string
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return minutes.toString();
    } else if (minutes == 60) {
      return '1h';
    } else if (minutes == 90) {
      return '1.5h';
    } else if (minutes == 120) {
      return '2h';
    } else {
      // For any other hour values
      final hours = minutes / 60;
      if (hours == hours.round()) {
        return '${hours.round()}h';
      } else {
        return '${hours}h';
      }
    }
  }
}