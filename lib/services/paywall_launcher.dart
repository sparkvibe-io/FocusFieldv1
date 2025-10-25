import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:focus_field/services/subscription_service.dart';
import 'package:focus_field/models/subscription_tier.dart';
import 'package:focus_field/constants/app_constants.dart';

/// Unified helper for showing RevenueCat native paywalls with graceful fallbacks.
enum PaywallAttemptResult { unlocked, dismissed, notShown }

class PaywallLauncher {
  PaywallLauncher._();

  /// Attempt to show native paywall if user lacks entitlement. Returns:
  /// unlocked  -> user purchased/restored (unlock granted)
  /// dismissed -> paywall was shown but user closed it without purchase
  /// notShown  -> paywall not shown (mock mode, already unlocked, error)
  static Future<PaywallAttemptResult> presentIfNeeded({
    String entitlementKey = AppConstants.premiumEntitlementKey,
  }) async {
    try {
      if (AppConstants.enableMockSubscriptions) {
        if (!kReleaseMode) {
          log('RC PaywallIfNeeded skipped: mock subscriptions enabled');
        }
        return PaywallAttemptResult.notShown; // trigger fallback custom paywall
      }
      // Ensure Purchases configured
      final service = SubscriptionService.instance;
      if (!service.isInitialized) {
        await service.initialize();
      }
      if (service.isInitialized &&
          service.currentTier != SubscriptionTier.free) {
        // Already unlocked, nothing to show
        return PaywallAttemptResult.notShown;
      }
      if (!kReleaseMode) {
        log('🚀 RevenueCat: Attempting to present paywall for entitlement: $entitlementKey');
      }
      // Snapshot offerings for context before showing the paywall
      try {
        final offerings = await Purchases.getOfferings();
        if (offerings.current == null) {
          if (!kReleaseMode) log('🧪 RC Paywall: offerings.current is null; keys=${offerings.all.keys.toList()}');
        } else {
          final pkgIds = offerings.current!.availablePackages
              .map((p) => p.storeProduct.identifier)
              .toList();
          if (!kReleaseMode) log('🧪 RC Paywall: current=${offerings.current!.identifier} packages=$pkgIds');
        }
      } catch (e) {
        if (!kReleaseMode) log('🧪 RC Paywall: offerings snapshot failed: $e');
      }

      final result = await RevenueCatUI.presentPaywallIfNeeded(entitlementKey);
      if (!kReleaseMode) log('📱 RevenueCat: PaywallIfNeeded result: $result');
      if (_didUnlock(result)) {
        if (!kReleaseMode) log('✅ RevenueCat: User unlocked via paywall');
        return PaywallAttemptResult.unlocked;
      }
      // Post-dismiss diagnostics to help explain why no unlock
      try {
        final info = await Purchases.getCustomerInfo();
        if (!kReleaseMode) log('🧪 RC Paywall: post-dismiss active entitlements: ${info.entitlements.active.keys.toList()}');
      } catch (_) {}
      try {
        final appUserId = await Purchases.appUserID;
        if (!kReleaseMode) log('🧪 RC Paywall: appUserId=$appUserId');
      } catch (_) {}
      try {
        final offerings = await Purchases.getOfferings();
        if (offerings.current == null) {
          if (!kReleaseMode) log('👋 RevenueCat: User dismissed paywall (hint: no current offering)');
        } else if (offerings.current!.availablePackages.isEmpty) {
          if (!kReleaseMode) log('👋 RevenueCat: User dismissed paywall (hint: offering has 0 packages)');
        } else {
          if (!kReleaseMode) log('👋 RevenueCat: User dismissed paywall');
        }
      } catch (_) {
        if (!kReleaseMode) log('👋 RevenueCat: User dismissed paywall');
      }
      return PaywallAttemptResult.dismissed; // shown & closed without unlock
    } catch (e, st) {
      if (!kReleaseMode) {
        log('❌ RevenueCat: presentPaywallIfNeeded error: $e', stackTrace: st);
      }
      return PaywallAttemptResult.notShown;
    }
  }

  static Future<bool> present({Offering? offering}) async {
    try {
      if (AppConstants.enableMockSubscriptions) {
        if (!kReleaseMode) {
          log('RC presentPaywall skipped: mock subscriptions enabled');
        }
        return false;
      }
      final service = SubscriptionService.instance;
      if (!service.isInitialized) {
        await service.initialize();
      }
      final result = await RevenueCatUI.presentPaywall(offering: offering);
      if (!kReleaseMode) log('RC Paywall result: $result');
      return _didUnlock(result);
    } catch (e, st) {
      if (!kReleaseMode) log('RC presentPaywall error: $e', stackTrace: st);
      return false;
    }
  }

  /// Present a specific offering by identifier (fetches offerings first). Falls back to generic present.
  static Future<bool> presentOffering(String offeringId) async {
    try {
      if (AppConstants.enableMockSubscriptions) {
        if (!kReleaseMode) {
          log('RC presentOffering skipped: mock subscriptions enabled');
        }
        return false;
      }
      final service = SubscriptionService.instance;
      if (!service.isInitialized) {
        await service.initialize();
      }
      final offerings = await Purchases.getOfferings();
      final off = offerings.all[offeringId];
      if (off == null) {
        if (!kReleaseMode) {
          log(
            'RC presentOffering: offering "$offeringId" not found. Falling back.',
          );
        }
        return present();
      }
      return present(offering: off);
    } catch (e, st) {
      if (!kReleaseMode) log('RC presentOffering error: $e', stackTrace: st);
      return present();
    }
  }

  static bool _didUnlock(PaywallResult result) {
    return result == PaywallResult.purchased ||
        result == PaywallResult.restored; // treat restored as unlocked
  }

  /// Manual inline paywall widget (native) for embedding if needed.
  static Widget inlinePaywall({Offering? offering, VoidCallback? onDismiss}) {
    return PaywallView(
      offering: offering,
      onDismiss: onDismiss,
      onRestoreCompleted: (_) {},
    );
  }
}
