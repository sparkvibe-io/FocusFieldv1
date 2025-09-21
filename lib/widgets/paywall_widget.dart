import 'package:flutter/material.dart';
// Removed explicit HostedPaywallService import (no direct usage after redesign)
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/models/subscription_tier.dart';
import 'package:focus_field/providers/subscription_provider.dart';
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
  final Map<String, String> _dynamicPriceStrings =
      {}; // productId -> price string
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
          _dynamicPriceStrings[pkg.storeProduct.identifier] =
              pkg.storeProduct.priceString;
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

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section (uses gradient; optionally swap with asset image by adding asset and decoration image)
              SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient (replace with DecorationImage for starry asset if added)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF0D0D17), Color(0xFF111A2A)],
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.10),
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: widget.onDismiss,
                        ),
                      ),
                    ),
                    // Title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          AppLocalizations.of(context)?.paywallTitle ??
                              'Premium',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppConstants.enableMockSubscriptions)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Mock Subscriptions Enabled',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    // Feature bullets
                    ..._buildFeatureList(context),
                    const SizedBox(height: 32),
                    hostedPaywallAsync.when(
                      data: (data) {
                        if (data != null) {
                          return _buildHostedPaywallPackages(context, data);
                        }
                        return _buildPlanCards(context);
                      },
                      loading: () => _buildPlanCards(context),
                      error: (_, __) => _buildPlanCards(context),
                    ),
                    const SizedBox(height: 28),
                    _buildPurchaseButtons(
                      context,
                      subscriptionActions,
                      subscriptionState,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed:
                            subscriptionState.isLoading
                                ? null
                                : () => subscriptionActions.restorePurchases(),
                        child: Text(
                          AppLocalizations.of(context)?.restorePurchases ??
                              'Restore Purchases',
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
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList(BuildContext context) {
    // Implemented premium feature set (kept in sync with README & paywall marketing)
    final l10n = AppLocalizations.of(context);
    final features =
        [
          l10n?.featureExtendSessions,
          l10n?.featureHistory,
          l10n?.featureMetrics,
          l10n?.featureExport,
          l10n?.featureThemes,
          l10n?.featureThreshold,
          l10n?.featureSupport,
        ].whereType<String>().toList();
    return features
        .map(
          (f) => Padding(
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
                  child: Text(f, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildPlanCards(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _planCard(context, yearly: true)),
        const SizedBox(width: 12),
        Expanded(child: _planCard(context, yearly: false)),
      ],
    );
  }

  Widget _planCard(BuildContext context, {required bool yearly}) {
    final isSelected = _isYearly == yearly;
    final l10n = AppLocalizations.of(context);
    final title =
        yearly
            ? (l10n?.yearlyPlanTitle ?? 'Yearly')
            : (l10n?.monthlyPlanTitle ?? 'Monthly');
    final id =
        yearly
            ? AppConstants.premiumYearlyProductId
            : AppConstants.premiumMonthlyProductId;
    final dyn = _dynamicPriceStrings[id];
    // Fallback static pricing (update if actual pricing changes)
    const baseMonthly = 1.99; // monthly price fallback
    const fallbackYearlyTotal = 9.99; // yearly total fallback
    late final String headline; // big number
    late final String subline; // billed at line

    if (yearly) {
      double total = fallbackYearlyTotal;
      if (dyn != null) {
        // Try to parse a numeric value from dynamic yearly price string for monthly equivalent
        final match = RegExp(r'([0-9]+\.?[0-9]*)').firstMatch(dyn);
        final parsed = match != null ? double.tryParse(match.group(1)!) : null;
        if (parsed != null && parsed > 0) total = parsed;
        subline =
            yearly
                ? (l10n != null ? l10n.billedAnnually(dyn) : 'Billed at $dyn')
                : (l10n != null ? l10n.billedMonthly(dyn) : 'Billed at $dyn');
      } else {
        subline =
            l10n != null
                ? l10n.billedAnnually('\$${total.toStringAsFixed(2)}')
                : 'Billed at \$${total.toStringAsFixed(2)}/yr.';
      }
      headline = '\$${(total / 12).toStringAsFixed(2)}/mo';
    } else {
      if (dyn != null) {
        headline = dyn.contains('/mo') ? dyn : '$dyn/mo';
        subline = l10n != null ? l10n.billedMonthly(dyn) : 'Billed at $dyn';
      } else {
        headline = '\$${baseMonthly.toStringAsFixed(2)}/mo';
        subline =
            l10n != null
                ? l10n.billedMonthly('\$${baseMonthly.toStringAsFixed(2)}')
                : 'Billed at \$${baseMonthly.toStringAsFixed(2)}/mo.';
      }
    }

    return GestureDetector(
      onTap: () => setState(() => _isYearly = yearly),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  headline,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subline,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
            if (yearly)
              Positioned(
                top: -14,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n != null ? l10n.savePercent('58') : 'SAVE 58%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: -6,
              right: -6,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1 : 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        final id =
            yearly
                ? AppConstants.premiumYearlyProductId
                : AppConstants.premiumMonthlyProductId;
        final dyn = _dynamicPriceStrings[id];
        if (dyn != null) return yearly ? '$dyn / year' : '$dyn / month';
        return yearly
            ? '�${SubscriptionTier.premium.yearlyPrice.toStringAsFixed(2)}/year'
            : '�${SubscriptionTier.premium.monthlyPrice.toStringAsFixed(2)}/month';
      // No higher tier implemented yet
      // ignore: no_default_cases
    }
  }

  Widget _buildPurchaseButtons(
    BuildContext context,
    SubscriptionActionsNotifier subscriptionActions,
    AsyncValue<void> subscriptionState,
  ) {
    return ElevatedButton(
      onPressed:
          subscriptionState.isLoading
              ? null
              : () => subscriptionActions.purchasePremium(isYearly: _isYearly),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child:
          subscriptionState.isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(
                AppLocalizations.of(context)?.subscribeCta ?? 'Continue',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
    );
  }

  Widget _buildHostedPaywallPackages(
    BuildContext context,
    Map<String, dynamic> paywall,
  ) {
    final l10n = AppLocalizations.of(context);
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
    final selected =
        _isYearly
            ? (yearly ?? monthly ?? packages.first)
            : (monthly ?? yearly ?? packages.first);
    final priceString = selected['priceString'] ?? '';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.paywallTitle ?? 'Current Offer',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isYearly
                  ? (l10n?.yearlyPlanTitle ?? 'Yearly Plan')
                  : (l10n?.monthlyPlanTitle ?? 'Monthly Plan'),
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: [
            _linkButton(
              l10n?.privacyPolicy ?? 'Privacy',
              AppConstants.privacyPolicyUrl,
            ),
            _linkButton(
              l10n?.termsOfService ?? 'Terms',
              AppConstants.termsOfServiceUrl,
            ),
            _linkButton(
              l10n?.manageSubscription ?? 'Manage',
              _platformManageUrl(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n?.legalDisclaimer ??
              'Auto-renewing subscription. Cancel anytime in store settings.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
