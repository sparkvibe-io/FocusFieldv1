import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/models/subscription_tier.dart';
import 'package:focus_field/providers/subscription_provider.dart';
import 'package:focus_field/widgets/paywall_widget.dart';
import 'package:focus_field/services/paywall_launcher.dart';

/// Widget that checks if user has access to a feature and shows paywall if not
class FeatureGate extends ConsumerWidget {
  const FeatureGate({
    super.key,
    required this.featureId,
    required this.child,
    this.requiredTier = SubscriptionTier.premium,
    this.fallback,
    this.showPaywall = true,
  });

  final String featureId;
  final Widget child;
  final SubscriptionTier requiredTier;
  final Widget? fallback;
  final bool showPaywall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching premiumAccessProvider ensures rebuild when tier changes
    final _ = ref.watch(premiumAccessProvider);
    final hasAccess = ref.watch(featureAccessProvider(featureId));

    if (hasAccess) {
      return child;
    }

    if (fallback != null) {
      return fallback!;
    }

    if (showPaywall) {
      return _buildPaywallPrompt(context, ref);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPaywallPrompt(BuildContext context, WidgetRef ref) {
    String message = 'Premium Feature';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.lock,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getFeatureDescription(featureId),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => _showPaywall(context, ref),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Upgrade',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFeatureDescription(String featureId) {
    switch (featureId) {
      case 'extended_sessions':
        return 'Sessions up to 120 minutes';
      case 'advanced_analytics':
        return 'Detailed trends and insights';
      case 'cloud_sync':
        return 'Sync data across devices';
      case 'data_export':
        return 'Export data as CSV/PDF';
      case 'premium_themes':
        return 'Exclusive theme options';
      case 'multi_environments':
        return 'Custom environment profiles';
      case 'ai_insights':
        return 'AI-powered recommendations';
      case 'social_features':
        return 'Challenges and competitions';
      default:
        return 'Premium feature access';
    }
  }

  void _showPaywall(BuildContext context, WidgetRef ref) {
    // Try native RevenueCat paywall first (if plugin available)
    PaywallLauncher.presentIfNeeded().then((result) {
      switch (result) {
        case PaywallAttemptResult.unlocked:
          return; // purchase handled
        case PaywallAttemptResult.dismissed:
          // User saw native paywall and closed it; do not force fallback.
          return;
        case PaywallAttemptResult.notShown:
          // Only in this case show custom fallback (e.g. mock mode or error)
          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: PaywallWidget(
                      requiredTier: requiredTier,
                      featureDescription: _getFeatureDescription(featureId),
                      onDismiss: () => Navigator.of(context).pop(),
                    ),
                  ),
            );
          }
          return;
      }
    });
  }
}

/// Helper function to show paywall modal
void showPaywall(
  BuildContext context, {
  SubscriptionTier requiredTier = SubscriptionTier.premium,
  String? featureDescription,
}) {
  PaywallLauncher.presentIfNeeded().then((result) {
    switch (result) {
      case PaywallAttemptResult.unlocked:
        return;
      case PaywallAttemptResult.dismissed:
        return; // do nothing
      case PaywallAttemptResult.notShown:
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: PaywallWidget(
                    requiredTier: requiredTier,
                    featureDescription: featureDescription,
                    onDismiss: () => Navigator.of(context).pop(),
                  ),
                ),
          );
        }
        return;
    }
  });
}

/// Helper function to check feature access and show paywall if needed
bool checkFeatureAccessOrShowPaywall(
  BuildContext context,
  WidgetRef ref,
  String featureId, {
  SubscriptionTier requiredTier = SubscriptionTier.premium,
  String? featureDescription,
}) {
  final hasAccess = ref.read(featureAccessProvider(featureId));

  if (!hasAccess) {
    showPaywall(
      context,
      requiredTier: requiredTier,
      featureDescription: featureDescription,
    );
    return false;
  }

  return true;
}
