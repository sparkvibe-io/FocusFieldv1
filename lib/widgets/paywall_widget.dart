import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/subscription_tier.dart';
import 'package:silence_score/providers/subscription_provider.dart';

class PaywallWidget extends ConsumerStatefulWidget {
  const PaywallWidget({
    super.key,
    this.requiredTier = SubscriptionTier.premium,
    this.featureDescription,
    this.onDismiss,
  });

  final SubscriptionTier requiredTier;
  final String? featureDescription;
  final VoidCallback? onDismiss;

  @override
  ConsumerState<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends ConsumerState<PaywallWidget> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    final subscriptionActions = ref.watch(subscriptionActionsProvider.notifier);
    final subscriptionState = ref.watch(subscriptionActionsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppConstants.upgradeTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.onDismiss != null)
                IconButton(
                  onPressed: widget.onDismiss,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Feature description
          if (widget.featureDescription != null) ...[
            Text(
              widget.featureDescription!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
          ],

          // Premium Features
          Text(
            AppConstants.premiumFeaturesTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Feature list
          ..._buildFeatureList(context),

          const SizedBox(height: 24),

          // Subscription tiers
          if (widget.requiredTier == SubscriptionTier.premium) 
            _buildPremiumCard(context)
          else 
            _buildBothTiersCard(context),

          const SizedBox(height: 16),

          // Billing toggle
          _buildBillingToggle(context),

          const SizedBox(height: 24),

          // Purchase buttons
          _buildPurchaseButtons(context, subscriptionActions, subscriptionState),

          const SizedBox(height: 16),

          // Restore purchases
          TextButton(
            onPressed: subscriptionState.isLoading 
                ? null 
                : () => subscriptionActions.restorePurchases(),
            child: Text(
              AppConstants.restorePurchasesText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Error display
          if (subscriptionState.hasError) ...[
            const SizedBox(height: 8),
            Text(
              subscriptionState.error.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList(BuildContext context) {
    final features = widget.requiredTier == SubscriptionTier.premium
        ? [
            'Extended sessions up to 60 minutes',
            'Advanced analytics and trends',
            'Data export (CSV/PDF)',
            'Premium themes',
            'Priority support',
          ]
        : [
            'All Premium features',
            'Cloud synchronization',
            'AI-powered insights',
            'Multi-environment profiles',
            'Social features',
            'Team challenges',
            'Advanced customization',
          ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildPremiumCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SubscriptionTier.premium.displayName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              SubscriptionTier.premium.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _isYearly 
                  ? '\$${SubscriptionTier.premium.yearlyPrice}/year'
                  : '\$${SubscriptionTier.premium.monthlyPrice}/month',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (_isYearly) ...[
              const SizedBox(height: 4),
              Text(
                'Save 58% vs monthly',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBothTiersCard(BuildContext context) {
    return Column(
      children: [
        _buildTierCard(context, SubscriptionTier.premium),
        const SizedBox(height: 12),
        _buildTierCard(context, SubscriptionTier.premiumPlus, isRecommended: true),
      ],
    );
  }

  Widget _buildTierCard(BuildContext context, SubscriptionTier tier, {bool isRecommended = false}) {
    return Card(
      elevation: isRecommended ? 4 : 2,
      color: isRecommended 
          ? Theme.of(context).colorScheme.primaryContainer 
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  tier.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isRecommended 
                        ? Theme.of(context).colorScheme.onPrimaryContainer 
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (isRecommended) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      'RECOMMENDED',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              tier.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isRecommended 
                    ? Theme.of(context).colorScheme.onPrimaryContainer 
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isYearly 
                  ? '\$${tier.yearlyPrice}/year'
                  : '\$${tier.monthlyPrice}/month',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isRecommended 
                    ? Theme.of(context).colorScheme.onPrimaryContainer 
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            if (_isYearly) ...[
              const SizedBox(height: 4),
              Text(
                tier == SubscriptionTier.premium 
                    ? 'Save 58% vs monthly'
                    : 'Save 48% vs monthly',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isRecommended 
                      ? Theme.of(context).colorScheme.onPrimaryContainer 
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBillingToggle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Monthly',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: !_isYearly 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: !_isYearly ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: _isYearly,
          onChanged: (value) {
            setState(() {
              _isYearly = value;
            });
          },
        ),
        const SizedBox(width: 12),
        Text(
          'Yearly',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _isYearly 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: _isYearly ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseButtons(
    BuildContext context,
    SubscriptionActionsNotifier subscriptionActions,
    AsyncValue<void> subscriptionState,
  ) {
    if (widget.requiredTier == SubscriptionTier.premium) {
      return ElevatedButton(
        onPressed: subscriptionState.isLoading 
            ? null 
            : () => subscriptionActions.purchasePremium(isYearly: _isYearly),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: subscriptionState.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                AppConstants.subscribeButtonText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            onPressed: subscriptionState.isLoading 
                ? null 
                : () => subscriptionActions.purchasePremiumPlus(isYearly: _isYearly),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: subscriptionState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Subscribe to Premium Plus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: subscriptionState.isLoading 
                ? null 
                : () => subscriptionActions.purchasePremium(isYearly: _isYearly),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Subscribe to Premium',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }
}
