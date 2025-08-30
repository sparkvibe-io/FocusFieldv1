class AppConstants {
  // App metadata
  static const String appTitle = 'Silence Score';
  static const String appVersion = '0.1.0';
  
  // Silence detection settings
  static const double defaultDecibelThreshold = 38.0; // dB
  static const double decibelMin = 20.0; // global lower bound
  static const double decibelMax = 80.0; // expanded upper bound (was 60)
  static const double highThresholdWarning = 70.0; // caution threshold
  static const int silenceDurationSeconds = 60; // 1 minute (default)
  static const int sampleIntervalMs = 200; // Sample every 200ms (system constant)
  
  // Scoring (system constants)
  static const int pointsPerMinute = 1; // 1 point per minute of successful session
  
  // Legacy constant (was user-configurable, now system constant)
  static const int pointsPerSuccess = 1; // Deprecated - use pointsPerMinute instead
  
  // Development & Testing
  static const bool isDevelopmentMode = bool.fromEnvironment('IS_DEVELOPMENT', defaultValue: true);
  static const bool enableMockSubscriptions = bool.fromEnvironment('ENABLE_MOCK_SUBSCRIPTIONS', defaultValue: true);
  
  // Subscription & Premium Features - Using dart-define for security
  static const String revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'REVENUECAT_API_KEY_NOT_SET', // Fallback for development
  );
  
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
  // Product identifiers (current live offering). NOTE: Colons in product IDs may not be accepted by all stores;
  // verify with App Store / Play Console. If invalid, prefer dots/underscores (e.g. premium.tier.monthly).
  static const String premiumMonthlyProductId = 'premium.tier:monthly';
  static const String premiumYearlyProductId = 'premium.tier:yearly';
  // Premium Plus postponed (future expansion) – identifiers removed for now.

  // RevenueCat Hosted Paywall Identifiers
  // The currently published paywall configured in the RevenueCat dashboard.
  static const String hostedPaywallIdentifier = 'Premium_Current_25';
  // Cache duration for hosted paywall (in minutes) before refetching.
  static const int hostedPaywallCacheMinutes = 30;
  
  // Feature limits
  static const int freeSessionMaxMinutes = 5;
  static const int premiumSessionMaxMinutes = 60; // legacy cap (kept for backward compatibility only)
  // Premium actual limit now 120 minutes (see SubscriptionTier.premium.maxSessionMinutes)
  static const int freeHistoryDays = 7;
  static const int premiumHistoryDays = 90;
  
  // Storage keys
  static const String totalPointsKey = 'total_points';
  static const String currentStreakKey = 'current_streak';
  static const String bestStreakKey = 'best_streak';
  static const String lastPlayDateKey = 'last_play_date';
  static const String decibelThresholdKey = 'decibel_threshold';
  static const String subscriptionTierKey = 'subscription_tier';
  static const String lastSyncDateKey = 'last_sync_date';
  
  // UI string constants removed after full localization migration.

  // Legal & Compliance URLs (update these to real hosted policy pages before production release)
  static const String privacyPolicyUrl = 'https://sparkvibe.io/privacy';
  static const String termsOfServiceUrl = 'https://sparkvibe.io/terms';
  
  // Environment Detection Helpers
  static bool get isProduction => !isDevelopmentMode;
  static bool get isValidRevenueCatKey => revenueCatApiKey != 'REVENUECAT_API_KEY_NOT_SET' && revenueCatApiKey.isNotEmpty;
  static bool get isValidFirebaseKey => firebaseApiKey != 'FIREBASE_API_KEY_NOT_SET' && firebaseApiKey.isNotEmpty;
  
  // Environment validation
  static String get currentEnvironment {
    if (isDevelopmentMode) return 'development';
    return 'production';
  }
  
  // API Key validation method
  static void validateConfiguration() {
    if (isProduction && !isValidRevenueCatKey) {
      throw Exception('RevenueCat API key is required for production builds. Use --dart-define REVENUECAT_API_KEY=your_key');
    }
  }
} 