import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode, defaultTargetPlatform, TargetPlatform;

class AppConstants {
  // App metadata
  static const String appTitle = 'Focus Field';

  // Silence detection settings
  static const double defaultDecibelThreshold = 38.0; // dB
  static const double decibelMin = 20.0; // global lower bound
  static const double decibelMax = 80.0; // expanded upper bound (was 60)
  static const double highThresholdWarning = 70.0; // caution threshold
  static const int silenceDurationSeconds = 60; // 1 minute (default)
  static const int sampleIntervalMs =
      200; // Sample every 200ms (system constant)

  // Scoring (system constants)
  static const int pointsPerMinute =
      1; // 1 point per minute of successful session

  // Legacy constant (was user-configurable, now system constant)
  static const int pointsPerSuccess =
      1; // Deprecated - use pointsPerMinute instead

  // Development & Testing
  // IMPORTANT:
  //  - isDevelopmentMode defaults to true for local builds (can be flipped with --dart-define IS_DEVELOPMENT=false for prod flavor testing)
  //  - enableMockSubscriptions previously defaulted to true which caused PREMIUM FEATURES TO APPEAR UNLOCKED WITHOUT PURCHASE.
  //    This led to confusion and potential policy risk. It now defaults to false so that, unless explicitly opted-in, the
  //    app behaves like production regarding entitlements. To simulate purchases locally without hitting RevenueCat:
  //      flutter run --dart-define ENABLE_MOCK_SUBSCRIPTIONS=true
  //    In mock mode the last persisted tier (SharedPreferences) is loaded and can be toggled via an internal debug action.
  // Development mode detection
  // - Defaults: debug/profile => development, release => production
  // - Override with: --dart-define IS_DEVELOPMENT=true/false
  static const bool _envIsDevelopment = bool.fromEnvironment(
    'IS_DEVELOPMENT',
    defaultValue: false,
  );
  static bool get isDevelopmentMode => _envIsDevelopment || !kReleaseMode;
  static const bool enableMockSubscriptions = bool.fromEnvironment(
    'ENABLE_MOCK_SUBSCRIPTIONS',
    defaultValue: false,
  );

  // Subscription & Premium Features - Using dart-define for security
  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'REVENUECAT_API_KEY_NOT_SET', // Fallback for development
  );

  // RevenueCat entitlement key used to grant Premium access.
  // This should match the "Identifier" you set for the entitlement in the RevenueCat dashboard
  // (e.g., "premium"). It is NOT the REST object id like "entl...".
  static const String premiumEntitlementKey = String.fromEnvironment(
    'REVENUECAT_ENTITLEMENT_KEY',
    defaultValue: 'Premium',
  );

  // Optional: comma-separated Apple product IDs for diagnostics/testing
  static const String _appleProductIdsCsv = String.fromEnvironment(
    'APPLE_PRODUCT_IDS',
    defaultValue: '',
  );
  static List<String> get appleProductIds {
    if (_appleProductIdsCsv.trim().isEmpty) return const [];
    return _appleProductIdsCsv
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  // Additional API keys for future use
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'FIREBASE_API_KEY_NOT_SET',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '', // Empty default - Sentry disabled if not set
  );

  // Product IDs (these can be public)
  // Normalized product identifiers (store-safe). Use dot notation for broadest compatibility.
  static const String premiumMonthlyProductId = 'premium.tier.monthly';
  static const String premiumYearlyProductId = 'premium.tier.yearly';
  // Premium Plus postponed (future expansion) – identifiers removed for now.

  // RevenueCat Hosted Paywall Identifiers
  // The currently published paywall configured in the RevenueCat dashboard.
  static const String hostedPaywallIdentifier = 'Premium_Current_25';
  // Cache duration for hosted paywall (in minutes) before refetching.
  static const int hostedPaywallCacheMinutes = 30;

  // Feature limits
  static const int freeSessionMaxMinutes =
      30; // Increased due to ads monetization
  static const int premiumSessionMaxMinutes =
      120; // Premium cap aligned with SubscriptionTier
  static const int freeHistoryDays = 7;
  static const int premiumHistoryDays = 90;

  // Ads
  // Test/demo unit ID (safe for development per Google docs)
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  // Production Banner Ad Unit IDs (override-able with --dart-define at build/run time)
  // Android example: ca-app-pub-2086096819226646/3553182566
  // iOS example:     ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY (set from AdMob console)
  static const String androidBannerAdUnitId = String.fromEnvironment(
    'ANDROID_BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-2086096819226646/3553182566',
  );
  static const String iosBannerAdUnitId = String.fromEnvironment(
    'IOS_BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-2086096819226646/9050063581',
  );

  // Optional: when true, if a production ad fails to load in release,
  // the app will attempt one retry with the Google test unit ID to verify integration.
  static const bool fallbackTestAdOnFail = bool.fromEnvironment(
    'ADS_FALLBACK_TEST_ON_FAIL',
    defaultValue: false,
  );

  // Resolve the ad unit id to use at runtime.
  // - In development: always use the Google-provided test unit ID to avoid policy issues.
  // - In production: use platform-specific IDs, falling back to test ID if unset.
  static String get effectiveBannerAdUnitId {
    if (isDevelopmentMode) return testBannerAdUnitId;
    if (kIsWeb) return testBannerAdUnitId; // Ads SDK not supported on web via this plugin
    // Select based on Flutter's target platform
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return (androidBannerAdUnitId.isNotEmpty)
            ? androidBannerAdUnitId
            : testBannerAdUnitId;
      case TargetPlatform.iOS:
        return (iosBannerAdUnitId.isNotEmpty) ? iosBannerAdUnitId : testBannerAdUnitId;
      default:
        return testBannerAdUnitId;
    }
  }

  // Storage keys
  static const String totalPointsKey = 'total_points';
  static const String currentStreakKey = 'current_streak';
  static const String bestStreakKey = 'best_streak';
  static const String lastPlayDateKey = 'last_play_date';
  static const String decibelThresholdKey = 'decibel_threshold';
  static const String subscriptionTierKey = 'subscription_tier';
  static const String lastSyncDateKey = 'last_sync_date';

  // UI string constants removed after full localization migration.
  // Minimal placeholders retained for legacy tests referencing successMessage/failureMessage.
  static const String successMessage = 'Success';
  static const String failureMessage = 'Failed';

  // Legal & Compliance URLs (update these to real hosted policy pages before production release)
  static const String privacyPolicyUrl = 'https://sparkvibe.io/privacy';
  static const String termsOfServiceUrl = 'https://sparkvibe.io/terms';

  // Environment Detection Helpers
  static bool get isProduction => !isDevelopmentMode;
  static bool get isValidRevenueCatKey =>
      revenueCatApiKey != 'REVENUECAT_API_KEY_NOT_SET' &&
      revenueCatApiKey.isNotEmpty;
  static bool get isValidFirebaseKey =>
      firebaseApiKey != 'FIREBASE_API_KEY_NOT_SET' && firebaseApiKey.isNotEmpty;

  // Environment validation
  static String get currentEnvironment {
    if (isDevelopmentMode) return 'development';
    return 'production';
  }

  // API Key validation method
  static void validateConfiguration() {
    if (isProduction && !isValidRevenueCatKey) {
      throw Exception(
        'RevenueCat API key is required for production builds. Use --dart-define REVENUECAT_API_KEY=your_key',
      );
    }
  }
}
