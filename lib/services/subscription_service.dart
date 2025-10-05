import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/models/subscription_tier.dart';

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance =>
      _instance ??= SubscriptionService._();
  SubscriptionService._();

  final StreamController<SubscriptionTier> _tierController =
      StreamController<SubscriptionTier>.broadcast();
  Stream<SubscriptionTier> get tierStream => _tierController.stream;

  SubscriptionTier _currentTier = SubscriptionTier.free;
  bool _isInitialized = false;

  SubscriptionTier get currentTier => _currentTier;
  bool get isInitialized => _isInitialized;

  // Entitlement key for premium access (configured via AppConstants.premiumEntitlementKey)
  String get _entitlementKeyConfigured => AppConstants.premiumEntitlementKey;

  /// Initialize the subscription service with RevenueCat
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Validate configuration
      AppConstants.validateConfiguration();

      // Check if running in mock mode
      if (AppConstants.enableMockSubscriptions) {
        _isInitialized = true;
        await _loadSavedTier();
        if (!kReleaseMode) {
          debugPrint('📱 Subscription service initialized in MOCK MODE');
        }
        if (!kReleaseMode) {
          debugPrint('🔧 Environment: ${AppConstants.currentEnvironment}');
        }
        return;
      }

      // Verify RevenueCat API key is set
      if (!AppConstants.isValidRevenueCatKey) {
        throw Exception(
          'RevenueCat API key not configured. Pass --dart-define REVENUECAT_API_KEY=XXXX',
        );
      }

      // Configure RevenueCat for production
      late PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(AppConstants.revenueCatApiKey);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(AppConstants.revenueCatApiKey);
      }

      // Enable verbose logging to diagnose configuration issues
      try {
        await Purchases.setLogLevel(LogLevel.debug);
      } catch (_) {}

      await Purchases.configure(configuration);
      // Enable logging in release mode for debugging
  debugPrint('🔧 RevenueCat: Purchases configured (key length ${AppConstants.revenueCatApiKey.length})');
  debugPrint('🔧 RevenueCat: API Key: ${AppConstants.revenueCatApiKey.substring(0, 10)}...');

      // Set up listener for purchase updates
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

      // Load initial customer info
      await _refreshCustomerInfo();

      // Offerings diagnostics: helpful when RC dashboard/App Store Connect setup is incomplete
      try {
        final offerings = await Purchases.getOfferings();
        if (offerings.current == null) {
          debugPrint(
            '🧪 RC Diagnostic: offerings.current is null. All offering keys: '
            '${offerings.all.keys.toList()}'.padRight(0),
          );
          debugPrint(
            '🧪 RC Diagnostic: This often means product IDs in the RC dashboard do not match '
            'App Store Connect, or IAPs/contracts are not fully configured. See https://rev.cat/why-are-offerings-empty',
          );
        } else {
          debugPrint(
            '🧪 RC Diagnostic: current offering = ${offerings.current!.identifier}; '
            'packages=${offerings.current!.availablePackages.length}',
          );
          for (final p in offerings.current!.availablePackages) {
            debugPrint('🧪 RC Diagnostic: package productId=${p.storeProduct.identifier}');
          }
        }
      } catch (e) {
        debugPrint('🧪 RC Diagnostic: getOfferings threw: $e');
      }

      // Platform-specific product diagnostics
      // iOS: verify StoreKit visibility using getProducts with explicit product IDs
      // Android: products use productId + basePlanId; rely on offerings and paywall logs instead of getProducts with iOS-style IDs.
      if (Platform.isIOS) {
        try {
          final configured = AppConstants.appleProductIds;
          final productIds = configured.isNotEmpty
              ? configured
              : <String>{
                  AppConstants.premiumMonthlyProductId,
                  AppConstants.premiumYearlyProductId,
                }.toList();
          final products = await Purchases.getProducts(productIds);
          if (products.isEmpty) {
            debugPrint('🧪 RC Diagnostic: getProducts returned 0 items for $productIds');
          } else {
            for (final p in products) {
              debugPrint('🧪 RC Diagnostic: product fetched id=${p.identifier} title=${p.title} price=${p.priceString}');
            }
          }
        } catch (e) {
          debugPrint('🧪 RC Diagnostic: getProducts threw: $e');
        }
      } else if (Platform.isAndroid) {
        // On Android, log productId:basePlanId from offerings to validate mapping.
        try {
          final offerings = await Purchases.getOfferings();
          if (offerings.current == null) {
            debugPrint('🧪 RC Diagnostic (Android): no current offering');
          } else {
            for (final p in offerings.current!.availablePackages) {
              final id = p.storeProduct.identifier; // e.g., premium:premium-tier-monthly
              final parts = id.split(':');
              final productId = parts.isNotEmpty ? parts.first : id;
              final basePlanId = parts.length > 1 ? parts.last : '';
              debugPrint('🧪 RC Diagnostic (Android): productId=$productId basePlanId=$basePlanId title=${p.storeProduct.title} price=${p.storeProduct.priceString}');
            }
          }
        } catch (e) {
          debugPrint('🧪 RC Diagnostic (Android): offerings inspection failed: $e');
        }
      }

      _isInitialized = true;
  debugPrint('✅ RevenueCat: Initialized successfully');
    } catch (e) {
  debugPrint('❌ RevenueCat: Failed to initialize: $e');
      // Continue with free tier if initialization fails
      await _setCurrentTier(SubscriptionTier.free);
      _isInitialized = true;
    }
  }

  /// Refresh customer info and update subscription tier
  Future<void> _refreshCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      try {
        final active = customerInfo.entitlements.active.keys.toList();
  debugPrint('📊 RevenueCat: Active entitlements: $active');
  debugPrint('📊 RevenueCat: Active subscriptions: ${customerInfo.activeSubscriptions}');
  debugPrint('📊 RevenueCat: All entitlements: ${customerInfo.entitlements.all.keys}');
      } catch (e) {
        debugPrint('⚠️ RevenueCat: Error reading entitlements: $e');
      }
      final tier = _getTierFromCustomerInfo(customerInfo);
      await _setCurrentTier(tier);
    } catch (e) {
  debugPrint('❌ RevenueCat: Failed to refresh customer info: $e');
      await _setCurrentTier(SubscriptionTier.free);
    }
  }

  /// Customer info update listener
  void _onCustomerInfoUpdate(CustomerInfo customerInfo) {
    final tier = _getTierFromCustomerInfo(customerInfo);
    _setCurrentTier(tier);
  }

  /// Determine subscription tier from customer info
  SubscriptionTier _getTierFromCustomerInfo(CustomerInfo customerInfo) {
    try {
      final entitlementKeys = customerInfo.entitlements.active.keys;
      if (!kReleaseMode) {
        debugPrint(
          'SubscriptionService: Evaluating entitlements: $entitlementKeys',
        );
        debugPrint(
          'SubscriptionService: Active store subscriptions: ${customerInfo.activeSubscriptions}',
        );
      }
      // Check for configured entitlement key, case-insensitive
      final configured = _entitlementKeyConfigured;
      for (final key in entitlementKeys) {
        if (key.toLowerCase() == configured.toLowerCase()) {
          debugPrint('✅ RevenueCat: Found premium entitlement: $key');
          return SubscriptionTier.premium;
        }
      }
      
      // Fallback heuristic: any entitlement containing premium (case-insensitive)
      for (final k in entitlementKeys) {
        if (k.toLowerCase().contains('premium')) {
          debugPrint('✅ RevenueCat: Found premium entitlement via fallback: $k');
          return SubscriptionTier.premium;
        }
      }
      
  debugPrint('ℹ️ RevenueCat: No premium entitlements found. Expected key="$_entitlementKeyConfigured". Available: $entitlementKeys');
      // As last resort, if active subscriptions exist but no entitlements matched, stay free (avoid over-granting).
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint('SubscriptionService: Entitlement evaluation error: $e');
      }
    }
    return SubscriptionTier.free;
  }

  /// Set current tier and persist to storage
  Future<void> _setCurrentTier(SubscriptionTier tier) async {
    if (_currentTier != tier) {
      _currentTier = tier;
      _tierController.add(tier);

      // Persist to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.subscriptionTierKey, tier.toString());

      if (!kReleaseMode) {
        debugPrint('SubscriptionService: Tier updated to ${tier.displayName}');
      }
    }
  }

  /// Load tier from storage (for offline access and mock mode)
  Future<void> _loadSavedTier() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tierString =
          prefs.getString(AppConstants.subscriptionTierKey) ?? 'free';
      final tier = SubscriptionTier.fromString(tierString);
      await _setCurrentTier(tier);
    } catch (e) {
      debugPrint('SubscriptionService: Failed to load tier from storage: $e');
      await _setCurrentTier(SubscriptionTier.free);
    }
  }

  /// Load tier from storage (for offline access)
  Future<void> loadTierFromStorage() async {
    await _loadSavedTier();
  }

  /// Purchase Premium subscription
  Future<bool> purchasePremium({bool isYearly = false}) async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        debugPrint(
          '📱 MOCK: Purchasing Premium ${isYearly ? 'yearly' : 'monthly'}',
        );
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Simulate network delay
        await _setCurrentTier(SubscriptionTier.premium);
        return true;
      }

      final offerings = await Purchases.getOfferings();
      if (!kReleaseMode) {
        debugPrint('🧪 RC purchase: offerings keys=${offerings.all.keys.toList()}');
        if (offerings.current == null) {
          debugPrint('🧪 RC purchase: offerings.current is null');
        } else {
          final ids = offerings.current!.availablePackages
              .map((p) => p.storeProduct.identifier)
              .toList();
          debugPrint('🧪 RC purchase: current=${offerings.current!.identifier} packages=$ids');
        }
      }
      final offering = offerings.current;

      if (offering == null) {
        throw Exception('No offerings available');
      }
      // Dynamically select package by heuristic (identifier contains 'year' or 'month')
      Package? package = _selectPackage(offering, yearly: isYearly);
      package ??= offering.availablePackages.isNotEmpty
          ? offering.availablePackages.first
          : null;
      if (package == null) {
        throw Exception('No purchasable packages in current offering');
      }
      debugPrint('🧪 RC purchase: selected package id=${package.storeProduct.identifier} price=${package.storeProduct.priceString}');

      // Updated to new API: use PurchaseParams with Purchases.purchase
      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      final tier = _getTierFromCustomerInfo(purchaseResult.customerInfo);
      try {
        final appUserId = await Purchases.appUserID;
        debugPrint('🧪 RC purchase: appUserId=$appUserId');
      } catch (_) {}
      await _setCurrentTier(tier);
      return tier == SubscriptionTier.premium;
    } catch (e) {
      if (e is PlatformException) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          debugPrint('SubscriptionService: Purchase cancelled by user');
          return false;
        } else if (errorCode ==
            PurchasesErrorCode.productAlreadyPurchasedError) {
          // Refresh customer info to ensure entitlements are applied
          debugPrint(
            'SubscriptionService: Product already purchased – refreshing customer info',
          );
          await _refreshCustomerInfo();
          return _currentTier == SubscriptionTier.premium;
        } else if (errorCode == PurchasesErrorCode.productNotAvailableForPurchaseError && Platform.isAndroid) {
          debugPrint(
            'SubscriptionService: Product not available for purchase on Android. Ensure: '
            '1) App installed from Play Internal Testing (not sideloaded), '
            '2) Tester account is enrolled and signed into Play, '
            '3) Subscription products and base plans are ACTIVE in Play Console.',
          );
          return false;
        }
      }
      debugPrint('SubscriptionService: Purchase failed: $e');
      rethrow;
    }
  }

  /// Purchase Premium Plus subscription

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        debugPrint('📱 MOCK: Restoring purchases');
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Simulate network delay
        // In mock mode, just reload from storage
        await _loadSavedTier();
        return _currentTier != SubscriptionTier.free;
      }

      final customerInfo = await Purchases.restorePurchases();
      try {
        final appUserId = await Purchases.appUserID;
        debugPrint('🧪 RC restore: appUserId=$appUserId');
      } catch (_) {}
      final tier = _getTierFromCustomerInfo(customerInfo);
      await _setCurrentTier(tier);
      return tier != SubscriptionTier.free;
    } catch (e) {
      debugPrint('SubscriptionService: Restore failed: $e');
      rethrow;
    }
  }

  /// Get available offerings from RevenueCat
  Future<Offerings?> getOfferings() async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        debugPrint('📱 MOCK: Getting offerings');
        // Return null for mock mode since we don't need offerings for testing
        return null;
      }
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        debugPrint('🧪 RC getOfferings: current is null; keys=${offerings.all.keys.toList()}');
      } else {
        debugPrint('🧪 RC getOfferings: current=${offerings.current!.identifier} packages=${offerings.current!.availablePackages.length}');
      }
      return offerings;
    } catch (e) {
      debugPrint('SubscriptionService: Failed to get offerings: $e');
      return null;
    }
  }

  /// Check if user has access to a specific feature
  bool hasFeatureAccess(String featureId) {
    return _currentTier.hasFeatureAccess(featureId);
  }

  /// Check if user has premium access (Premium or Premium Plus)
  bool get hasPremiumAccess => _currentTier != SubscriptionTier.free;

  /// Check if user has Premium Plus access
  bool get hasPremiumPlusAccess => false; // Not implemented

  /// Get max session duration for current tier
  int get maxSessionMinutes => _currentTier.maxSessionMinutes;

  /// Get history retention days for current tier
  int get historyDays => _currentTier.historyDays;

  /// Dispose resources
  void dispose() {
    _tierController.close();
    // purchases_flutter currently lacks explicit listener removal API; if added, dispose here.
  }

  // Internal helpers ------------------------------------------------------
  Package? _selectPackage(Offering offering, {required bool yearly}) {
    try {
      Package? monthly;
      Package? yearlyPkg;
      for (final pkg in offering.availablePackages) {
        final id = pkg.storeProduct.identifier.toLowerCase();
        if (id.contains('month')) monthly ??= pkg;
        if (id.contains('year')) yearlyPkg ??= pkg;
      }
      final chosen = yearly ? (yearlyPkg ?? monthly) : (monthly ?? yearlyPkg);
      return chosen;
    } catch (_) {
      return null;
    }
  }

  // DEBUG / DEV UTILITIES -------------------------------------------------
  /// Force a subscription tier in mock mode for fast UI validation.
  /// No-op outside mock mode to avoid accidental misuse.
  Future<void> debugForceTier(SubscriptionTier tier) async {
    if (!AppConstants.enableMockSubscriptions) return; // safety guard
    await _setCurrentTier(tier);
  }
}
