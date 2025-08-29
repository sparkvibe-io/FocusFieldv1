import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/subscription_tier.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// NOTE: RevenueCat prebuilt UI package not available; maintaining custom paywall.

// Restored custom paywall (will later be enhanced with dynamic offerings display).
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
  // Dynamic pricing
  final Map<String, String> _dynamicPriceStrings = {}; // productId -> price string
  bool _attemptedLoad = false;
  // TODO: Remove static fallback once dynamic pricing stable.

  @override
  void initState() {
    super.initState();
    _loadDynamicPrices();
  }

  Future<void> _loadDynamicPrices() async {
    if (_attemptedLoad) return;
    _attemptedLoad = true;
    if (AppConstants.enableMockSubscriptions) return; // skip in mock mode
    if (!AppConstants.isValidRevenueCatKey) return; // missing API key
  // No UI spinner; prices will update in-place when loaded.
    try {
      final service = ref.read(subscriptionServiceProvider);
      final offerings = await service.getOfferings();
      final current = offerings?.current;
      if (current != null) {
        for (final pkg in current.availablePackages) {
          _dynamicPriceStrings[pkg.storeProduct.identifier] = pkg.storeProduct.priceString;
        }
      }
    } catch (_) {
      // silent fallback
    } finally {
  // ignore cleanup flag
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionActions = ref.watch(subscriptionActionsProvider.notifier);
    final subscriptionState = ref.watch(subscriptionActionsProvider);
  final hostedPaywallAsync = ref.watch(hostedPaywallProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            if (widget.featureDescription != null) ...[
              Text(widget.featureDescription!, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
            ],
            Text(
              AppConstants.premiumFeaturesTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._buildFeatureList(context),
            const SizedBox(height: 24),
            // Hosted paywall section (if available)
            hostedPaywallAsync.when(
              data: (data) {
                if (data == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPremiumCard(context),
                      const SizedBox(height: 8),
                      if (!AppConstants.enableMockSubscriptions && AppConstants.isValidRevenueCatKey)
                        Text(
                          'Live offerings unavailable. This can happen if:\n• Purchases not configured early\n• No current Offering set in RevenueCat\n• Product IDs mismatch (check colons)\n• Play Store products not created/published',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 11,
                              ),
                        ),
                    ],
                  );
                }
                return _buildHostedPaywallPackages(context, data);
              },
              loading: () => _buildPremiumCard(context), // show fallback while loading
              error: (_, __) => _buildPremiumCard(context),
            ),
            const SizedBox(height: 16),
            _buildBillingToggle(context),
            const SizedBox(height: 24),
            _buildPurchaseButtons(context, subscriptionActions, subscriptionState),
            const SizedBox(height: 16),
            TextButton(
              onPressed: subscriptionState.isLoading ? null : () => subscriptionActions.restorePurchases(),
              child: Text(
                AppConstants.restorePurchasesText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
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
            const SizedBox(height: 24),
            _buildLegalFooter(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList(BuildContext context) {
    final features = widget.requiredTier == SubscriptionTier.premium
        ? [
            'Extended sessions up to 120 minutes',
            'Advanced analytics and trends',
            'Data export (CSV/PDF)',
            'Premium themes',
            'Priority support',
          ]
        : [
            'All Premium features',
            'Cloud synchronization (Coming Soon)',
            'AI-powered insights (Coming Soon)',
            'Multi-environment profiles (Coming Soon)',
            'Social features (Coming Soon)',
            'Team challenges (Coming Soon)',
            'Advanced customization (Coming Soon)',
          ];
    return features
        .map(
          (f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(f, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          ),
        )
        .toList();
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
            Text(SubscriptionTier.premium.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              _priceDisplay(SubscriptionTier.premium, yearly: _isYearly),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _priceDisplay(SubscriptionTier tier, {required bool yearly}) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        final id = yearly ? AppConstants.premiumYearlyProductId : AppConstants.premiumMonthlyProductId;
        final dyn = _dynamicPriceStrings[id];
        if (dyn != null) return yearly ? '$dyn / year' : '$dyn / month';
        return yearly
            ? '�${SubscriptionTier.premium.yearlyPrice.toStringAsFixed(2)}/year'
            : '�${SubscriptionTier.premium.monthlyPrice.toStringAsFixed(2)}/month';
  // No higher tier implemented yet
  // ignore: no_default_cases
    }
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
          onChanged: (value) => setState(() => _isYearly = value),
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

  Widget _buildPurchaseButtons(BuildContext context, SubscriptionActionsNotifier subscriptionActions, AsyncValue<void> subscriptionState) {
  return ElevatedButton(
        onPressed: subscriptionState.isLoading ? null : () => subscriptionActions.purchasePremium(isYearly: _isYearly),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: subscriptionState.isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(
                AppConstants.subscribeButtonText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
      );
  }

  Widget _buildHostedPaywallPackages(BuildContext context, Map<String, dynamic> paywall) {
    final packages = (paywall['packages'] as List<dynamic>? ?? []);
    if (packages.isEmpty) return _buildPremiumCard(context); // fallback
    // Determine selected package by yearly toggle.
    // We attempt to match on product identifiers containing 'year' or 'month'.
    Map<String, dynamic>? monthly;
    Map<String, dynamic>? yearly;
    for (final p in packages) {
      final id = (p['productIdentifier'] ?? '').toString().toLowerCase();
      if (id.contains('year')) {
        yearly = p as Map<String, dynamic>;
      } else if (id.contains('month')) {
        monthly = p as Map<String, dynamic>;
      }
    }
    final selected = _isYearly ? (yearly ?? monthly ?? packages.first) : (monthly ?? yearly ?? packages.first);
    final priceString = selected['priceString'] ?? '';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Offer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isYearly ? 'Yearly Plan' : 'Monthly Plan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _isYearly ? '$priceString / year' : '$priceString / month',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalFooter(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: [
            _linkButton('Privacy Policy', AppConstants.privacyPolicyUrl),
            _linkButton('Terms of Service', AppConstants.termsOfServiceUrl),
            _linkButton('Manage Subscription', _platformManageUrl()),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Auto-renewing subscription. Cancel anytime in store settings.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _platformManageUrl() {
    // Basic placeholders; real deep links may differ by store region.
    // iOS manage: system Settings / App Store; provide Apple support link.
    // Android manage: Play Store subscriptions list.
    // For now provide platform-neutral help page.
    return 'https://support.google.com/googleplay/answer/7018481';
  }

  Widget _linkButton(String label, String url) {
    return TextButton(
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(label),
    );
  }
}
