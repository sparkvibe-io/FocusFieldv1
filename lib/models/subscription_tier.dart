enum SubscriptionTier {
  free,
  premium;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      // No Premium Plus currently
    }
  }

  String get description {
    switch (this) {
      case SubscriptionTier.free:
        return 'Basic silence tracking with sessions up to 30 minutes';
      case SubscriptionTier.premium:
        return 'Extended sessions, analytics, and data export';
      // Future higher tier description placeholder removed
    }
  }

  double get monthlyPrice {
    switch (this) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.premium:
        // Legacy static price (will be replaced by dynamic RevenueCat values)
        return 1.99;
      // No higher tier
    }
  }

  double get yearlyPrice {
    switch (this) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.premium:
        // Legacy static price (will be replaced by dynamic RevenueCat values)
        return 19.99; // Updated to align with documentation
      // No higher tier
    }
  }

  int get maxSessionMinutes {
    switch (this) {
      case SubscriptionTier.free:
        return 30; // Increased from 5 now that ads are enabled
      case SubscriptionTier.premium:
        return 120; // Increased to 2 hours
      // No higher tier
    }
  }

  int get historyDays {
    switch (this) {
      case SubscriptionTier.free:
        return 7;
      case SubscriptionTier.premium:
        return 90;
      // No higher tier
    }
  }

  bool get hasAdvancedAnalytics {
    return this != SubscriptionTier.free;
  }

  bool get hasCloudSync {
    return false; // Not yet available
  }

  bool get hasDataExport {
    return this != SubscriptionTier.free;
  }

  bool get hasPremiumThemes {
    return this != SubscriptionTier.free;
  }

  bool get hasMultiEnvironments {
    return false; // Not yet available
  }

  bool get hasAIInsights {
    return false; // Not yet available
  }

  bool get hasSocialFeatures {
    return false; // Not yet available
  }

  // Helper method to check if current tier has access to a feature
  bool hasFeatureAccess(String featureId) {
    switch (featureId) {
      case 'extended_sessions':
        return this != SubscriptionTier.free;
      case 'advanced_analytics':
        return hasAdvancedAnalytics;
      case 'cloud_sync':
        return hasCloudSync;
      case 'data_export':
        return hasDataExport;
      case 'premium_themes':
        return hasPremiumThemes;
      case 'multi_environments':
        return hasMultiEnvironments;
      case 'ai_insights':
        return hasAIInsights;
      case 'social_features':
        return hasSocialFeatures;
      default:
        return true; // Free features are accessible to all tiers
    }
  }

  static SubscriptionTier fromString(String tierString) {
    switch (tierString.toLowerCase()) {
      case 'premium':
        return SubscriptionTier.premium;
      // Future mapping placeholder removed
      default:
        return SubscriptionTier.free;
    }
  }

  @override
  String toString() {
    switch (this) {
      case SubscriptionTier.free:
        return 'free';
      case SubscriptionTier.premium:
        return 'premium';
      // No higher tier
    }
  }
}
