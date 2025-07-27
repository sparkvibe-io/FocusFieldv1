enum SubscriptionTier {
  free,
  premium,
  premiumPlus;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.premiumPlus:
        return 'Premium Plus';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionTier.free:
        return 'Basic silence tracking with 5-minute sessions';
      case SubscriptionTier.premium:
        return 'Extended sessions, analytics, and data export';
      case SubscriptionTier.premiumPlus:
        return 'AI insights, cloud sync, multi-environments, and social features';
    }
  }

  double get monthlyPrice {
    switch (this) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.premium:
        return 1.99;
      case SubscriptionTier.premiumPlus:
        return 3.99;
    }
  }

  double get yearlyPrice {
    switch (this) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.premium:
        return 9.99;
      case SubscriptionTier.premiumPlus:
        return 24.99;
    }
  }

  int get maxSessionMinutes {
    switch (this) {
      case SubscriptionTier.free:
        return 5;
      case SubscriptionTier.premium:
        return 60;
      case SubscriptionTier.premiumPlus:
        return 120;
    }
  }

  int get historyDays {
    switch (this) {
      case SubscriptionTier.free:
        return 7;
      case SubscriptionTier.premium:
        return 90;
      case SubscriptionTier.premiumPlus:
        return 365;
    }
  }

  bool get hasAdvancedAnalytics {
    return this != SubscriptionTier.free;
  }

  bool get hasCloudSync {
    return this == SubscriptionTier.premiumPlus;
  }

  bool get hasDataExport {
    return this != SubscriptionTier.free;
  }

  bool get hasPremiumThemes {
    return this != SubscriptionTier.free;
  }

  bool get hasMultiEnvironments {
    return this == SubscriptionTier.premiumPlus;
  }

  bool get hasAIInsights {
    return this == SubscriptionTier.premiumPlus;
  }

  bool get hasSocialFeatures {
    return this == SubscriptionTier.premiumPlus;
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
      case 'premiumplus':
      case 'premium_plus':
        return SubscriptionTier.premiumPlus;
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
      case SubscriptionTier.premiumPlus:
        return 'premiumplus';
    }
  }
}
