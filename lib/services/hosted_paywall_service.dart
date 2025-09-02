import 'dart:async';
import 'dart:convert';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/constants/app_constants.dart';

/// Service responsible for fetching and caching the RevenueCat Hosted Paywall JSON.
/// Falls back silently if the hosted paywall is unavailable or disabled (e.g. mock mode).
class HostedPaywallService {
  HostedPaywallService._();
  static final HostedPaywallService instance = HostedPaywallService._();

  static const _cacheKey = 'rc_hosted_paywall_cache_json';
  static const _cacheTimestampKey = 'rc_hosted_paywall_cache_ts';

  Map<String, dynamic>? _cachedPaywall; // In-memory parsed JSON

  Future<Map<String, dynamic>?> getHostedPaywall({
    bool forceRefresh = false,
  }) async {
    if (AppConstants.enableMockSubscriptions) {
      // Helpful diagnostic so devs know why hosted paywall is absent.
      if (!kReleaseMode)
        debugPrint(
          'HostedPaywallService: returning null (mock subscriptions enabled)',
        );
      return null; // skip in mock mode
    }
    if (!AppConstants.isValidRevenueCatKey) {
      if (!kReleaseMode)
        debugPrint(
          'HostedPaywallService: returning null (RevenueCat API key not set)',
        );
      return null; // API key missing
    }

    if (!forceRefresh && _cachedPaywall != null) return _cachedPaywall;

    final prefs = await SharedPreferences.getInstance();
    if (!forceRefresh) {
      final ts = prefs.getInt(_cacheTimestampKey);
      if (ts != null) {
        final ageMinutes =
            DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(ts))
                .inMinutes;
        if (ageMinutes < AppConstants.hostedPaywallCacheMinutes) {
          final cachedJson = prefs.getString(_cacheKey);
          if (cachedJson != null) {
            try {
              _cachedPaywall = json.decode(cachedJson) as Map<String, dynamic>;
              return _cachedPaywall;
            } catch (_) {}
          }
        }
      }
    }

    try {
      // purchases_flutter currently exposes offerings but not direct getPaywall API.
      // We fetch offerings and look for a matching paywall via identifier inside availablePackages metadata.
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) {
        if (!kReleaseMode)
          debugPrint(
            'HostedPaywallService: current offering is null. Offerings all keys: ${offerings.all.keys.toList()}',
          );
        return null;
      }

      // Attempt to read attached paywall data if exposed via package metadata (future-proofing)
      final Map<String, dynamic> paywallMap = {
        'identifier': AppConstants.hostedPaywallIdentifier,
        'packages':
            current.availablePackages
                .map(
                  (p) => {
                    'identifier': p.identifier,
                    'productIdentifier': p.storeProduct.identifier,
                    'price': p.storeProduct.price,
                    'priceString': p.storeProduct.priceString,
                    'currencyCode': p.storeProduct.currencyCode,
                  },
                )
                .toList(),
      };
      if (!kReleaseMode)
        debugPrint(
          'HostedPaywallService: constructed pseudo-hosted paywall with ${current.availablePackages.length} packages',
        );
      _cachedPaywall = paywallMap;
      await prefs.setString(_cacheKey, json.encode(_cachedPaywall));
      await prefs.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return _cachedPaywall;
    } catch (e) {
      if (!kReleaseMode)
        debugPrint(
          'HostedPaywallService: failed to fetch offerings/paywall: $e',
        );
      return null; // graceful fallback
    }
  }
}
