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
  
  // UI strings
  static const String stopButtonText = 'Stop';
  static const String listeningText = 'Listening...';
  static const String successMessage = 'Silence achieved! +1 point';
  static const String failureMessage = 'Too noisy! Try again';
  static const String totalPointsLabel = 'Total Points';
  static const String currentStreakLabel = 'Current Streak';
  static const String bestStreakLabel = 'Best Streak';
  static const String welcomeMessage = 'Press Start to begin your silence journey!';
  static const String settingsTitle = 'Settings';
  static const String resetDataText = 'Reset All Data';
  static const String resetDataConfirmation = 'Are you sure you want to reset all your progress?';
  static const String resetDataSuccess = 'Data reset successfully';
  static const String decibelThresholdLabel = 'Decibel Threshold';
  static const String decibelThresholdHint = 'Set the maximum allowed noise level (dB)';
  
  // Permission strings
  static const String microphonePermissionTitle = 'Microphone Permission';
  static const String microphonePermissionMessage = 'Silence Score needs microphone access to measure ambient noise levels. No audio is stored.';
  static const String permissionDeniedMessage = 'Microphone permission is required to measure silence. Please enable it in settings.';
  
  // Error messages
  static const String noiseMeterError = 'Unable to access microphone';
  static const String generalError = 'Something went wrong. Please try again.';
  
  // Premium & Subscription strings
  static const String upgradeTitle = 'Upgrade to Premium';
  static const String premiumFeaturesTitle = 'Premium Features';
  static const String premiumDescription = 'Unlock extended sessions, advanced analytics, and data export';
  static const String subscribeButtonText = 'Subscribe Now';
  static const String restorePurchasesText = 'Restore Purchases';
  static const String premiumRequiredMessage = 'This feature requires Premium subscription';
  static const String subscriptionSuccessMessage = 'Successfully subscribed! Enjoy your premium features';
  static const String subscriptionErrorMessage = 'Unable to process subscription. Please try again';
  static const String restoreSuccessMessage = 'Purchases restored successfully';
  static const String restoreErrorMessage = 'No purchases found to restore';

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