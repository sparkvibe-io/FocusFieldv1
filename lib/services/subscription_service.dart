import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/subscription_tier.dart';

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();
  SubscriptionService._();

  final StreamController<SubscriptionTier> _tierController = StreamController<SubscriptionTier>.broadcast();
  Stream<SubscriptionTier> get tierStream => _tierController.stream;

  SubscriptionTier _currentTier = SubscriptionTier.free;
  bool _isInitialized = false;

  SubscriptionTier get currentTier => _currentTier;
  bool get isInitialized => _isInitialized;

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
        if (!kReleaseMode) print('📱 Subscription service initialized in MOCK MODE');
        if (!kReleaseMode) print('🔧 Environment: ${AppConstants.currentEnvironment}');
        return;
      }

      // Verify RevenueCat API key is set
      if (!AppConstants.isValidRevenueCatKey) {
        throw Exception('RevenueCat API key not configured. Check your environment variables.');
      }

      // Configure RevenueCat for production
      late PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(AppConstants.revenueCatApiKey);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(AppConstants.revenueCatApiKey);
      }

      await Purchases.configure(configuration);

      // Set up listener for purchase updates
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

      // Load initial customer info
      await _refreshCustomerInfo();

      _isInitialized = true;
      if (!kReleaseMode) print('SubscriptionService: Initialized successfully');
    } catch (e) {
      if (!kReleaseMode) print('SubscriptionService: Failed to initialize: $e');
      // Continue with free tier if initialization fails
      await _setCurrentTier(SubscriptionTier.free);
      _isInitialized = true;
    }
  }

  /// Refresh customer info and update subscription tier
  Future<void> _refreshCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final tier = _getTierFromCustomerInfo(customerInfo);
      await _setCurrentTier(tier);
    } catch (e) {
      if (!kReleaseMode) print('SubscriptionService: Failed to refresh customer info: $e');
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
    // Check for Premium Plus first (higher tier)
    if (customerInfo.entitlements.active.containsKey('premium_plus')) {
      return SubscriptionTier.premiumPlus;
    }
    
    // Check for Premium
    if (customerInfo.entitlements.active.containsKey('premium')) {
      return SubscriptionTier.premium;
    }

    // Default to free
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
      
      if (!kReleaseMode) print('SubscriptionService: Tier updated to ${tier.displayName}');
    }
  }

  /// Load tier from storage (for offline access and mock mode)
  Future<void> _loadSavedTier() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tierString = prefs.getString(AppConstants.subscriptionTierKey) ?? 'free';
      final tier = SubscriptionTier.fromString(tierString);
      await _setCurrentTier(tier);
    } catch (e) {
      print('SubscriptionService: Failed to load tier from storage: $e');
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
        print('📱 MOCK: Purchasing Premium ${isYearly ? 'yearly' : 'monthly'}');
        await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
        await _setCurrentTier(SubscriptionTier.premium);
        return true;
      }

      final productId = isYearly 
          ? AppConstants.premiumYearlyProductId 
          : AppConstants.premiumMonthlyProductId;
      
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      
      if (offering == null) {
        throw Exception('No offerings available');
      }

      Package? package;
      for (final pkg in offering.availablePackages) {
        if (pkg.storeProduct.identifier == productId) {
          package = pkg;
          break;
        }
      }

      if (package == null) {
        throw Exception('Product not found: $productId');
      }

      final purchaseResult = await Purchases.purchasePackage(package);
      final tier = _getTierFromCustomerInfo(purchaseResult.customerInfo);
      await _setCurrentTier(tier);

      return tier == SubscriptionTier.premium || tier == SubscriptionTier.premiumPlus;
    } catch (e) {
      if (e is PlatformException) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          print('SubscriptionService: Purchase cancelled by user');
          return false;
        }
      }
      print('SubscriptionService: Purchase failed: $e');
      throw e;
    }
  }

  /// Purchase Premium Plus subscription
  Future<bool> purchasePremiumPlus({bool isYearly = false}) async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        print('📱 MOCK: Purchasing Premium Plus ${isYearly ? 'yearly' : 'monthly'}');
        await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
        await _setCurrentTier(SubscriptionTier.premiumPlus);
        return true;
      }

      final productId = isYearly 
          ? AppConstants.premiumPlusYearlyProductId 
          : AppConstants.premiumPlusMonthlyProductId;
      
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      
      if (offering == null) {
        throw Exception('No offerings available');
      }

      Package? package;
      for (final pkg in offering.availablePackages) {
        if (pkg.storeProduct.identifier == productId) {
          package = pkg;
          break;
        }
      }

      if (package == null) {
        throw Exception('Product not found: $productId');
      }

      final purchaseResult = await Purchases.purchasePackage(package);
      final tier = _getTierFromCustomerInfo(purchaseResult.customerInfo);
      await _setCurrentTier(tier);

      return tier == SubscriptionTier.premiumPlus;
    } catch (e) {
      if (e is PlatformException) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          print('SubscriptionService: Purchase cancelled by user');
          return false;
        }
      }
      print('SubscriptionService: Purchase failed: $e');
      throw e;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        print('📱 MOCK: Restoring purchases');
        await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
        // In mock mode, just reload from storage
        await _loadSavedTier();
        return _currentTier != SubscriptionTier.free;
      }

      final customerInfo = await Purchases.restorePurchases();
      final tier = _getTierFromCustomerInfo(customerInfo);
      await _setCurrentTier(tier);
      return tier != SubscriptionTier.free;
    } catch (e) {
      print('SubscriptionService: Restore failed: $e');
      throw e;
    }
  }

  /// Get available offerings from RevenueCat
  Future<Offerings?> getOfferings() async {
    try {
      // Handle mock mode
      if (AppConstants.enableMockSubscriptions) {
        print('📱 MOCK: Getting offerings');
        // Return null for mock mode since we don't need offerings for testing
        return null;
      }

      return await Purchases.getOfferings();
    } catch (e) {
      print('SubscriptionService: Failed to get offerings: $e');
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
  bool get hasPremiumPlusAccess => _currentTier == SubscriptionTier.premiumPlus;

  /// Get max session duration for current tier
  int get maxSessionMinutes => _currentTier.maxSessionMinutes;

  /// Get history retention days for current tier
  int get historyDays => _currentTier.historyDays;

  /// Dispose resources
  void dispose() {
    _tierController.close();
  }
}
