# SilenceScore Monetization System Setup Guide

## Overview
This guide provides complete setup instructions for SilenceScore's subscription monetization system. The infrastructure is fully implemented with centralized configuration, requiring only platform configuration and API key setup to enable revenue generation.

## Prerequisites
- Flutter development environment setup
- Access to RevenueCat dashboard
- App Store Connect developer account
- Google Play Console developer account
- Firebase project access (optional)

## Implementation Status

### Core Infrastructure
- **Subscription Service** (`lib/services/subscription_service.dart`): RevenueCat integration with purchase flows
- **Subscription Provider** (`lib/providers/subscription_provider.dart`): Riverpod state management
- **Feature Gating** (`lib/widgets/feature_gate.dart`): Access control for premium features
- **Paywall UI** (`lib/widgets/paywall_widget.dart`): Subscription purchase interface
- **Subscription Tiers** (`lib/models/subscription_tier.dart`): Three-tier system (Free, Premium, Premium Plus)
- **Centralized Config** (`lib/constants/app_constants.dart`): Single source of truth for all settings

### Pricing Strategy
- **Premium**: $1.99/month or $19.99/year
- **Premium Plus**: $3.99/month or $39.99/year (Phase 2)
- **Feature Limits**: Session history (20/unlimited), analytics depth, export capabilities

### Phase 1 Focus (Premium Tier Only)
- Extended sessions (up to 60 minutes)
- Advanced analytics and trends
- Data export functionality (CSV/PDF)
- Premium themes and customization
- Priority support

### Build Status
- ✅ iOS build successful
- ✅ Android build successful (minSdkVersion updated to 23 for Firebase compatibility)

## 🔧 Required Configuration Steps

### 1. RevenueCat Setup

#### Create RevenueCat Account
1. Go to [RevenueCat Dashboard](https://app.revenuecat.com)
2. Create account and new project
3. Add iOS and Android apps with bundle IDs:
   - iOS: `io.sparkvibe.silencescore`
   - Android: `io.sparkvibe.silencescore`

#### Configure Products
Create the following subscription products in RevenueCat:
```
Premium Monthly: silence_score_premium_monthly
Premium Yearly: silence_score_premium_yearly
Premium Plus Monthly: silence_score_premium_plus_monthly
Premium Plus Yearly: silence_score_premium_plus_yearly
```

#### Update API Key
In `lib/constants/app_constants.dart`, replace:
```dart
static const String revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY_HERE';
```

### 2. App Store Connect Setup (iOS)

#### Create App
1. Login to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app with bundle ID: `io.sparkvibe.silencescore`
3. Fill app metadata, description, screenshots

#### Configure Subscriptions
1. Go to **Features** → **In-App Purchases**
2. Create Auto-Renewable Subscriptions:
   - Premium Monthly: `silence_score_premium_monthly` ($1.99/month)
   - Premium Yearly: `silence_score_premium_yearly` ($19.99/year)
   - Premium Plus Monthly: `silence_score_premium_plus_monthly` ($3.99/month)
   - Premium Plus Yearly: `silence_score_premium_plus_yearly` ($39.99/year)
3. Create subscription groups and configure pricing

#### Test in Sandbox
1. Create sandbox test accounts
2. Test purchase flows
3. Verify subscription state management

### 3. Google Play Console Setup (Android)

#### Create App
1. Login to [Google Play Console](https://play.google.com/console)
2. Create new app with package name: `io.sparkvibe.silencescore`
3. Complete store listing

#### Configure Subscriptions
1. Go to **Monetize** → **Products** → **Subscriptions**
2. Create subscriptions matching iOS products
3. Set up pricing for different markets
4. Configure base plans and offers

#### Test in Internal Testing
1. Upload signed APK to internal testing
2. Add test accounts
3. Test purchase flows

### 4. Firebase Setup (Optional but Recommended)

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project for `SilenceScore`
3. Add iOS and Android apps

#### Configure Authentication
1. Enable authentication providers (if needed for user accounts)
2. Configure settings in Firebase console

#### Configure Firestore
1. Create Firestore database
2. Set up collections for user data and subscription history
3. Configure security rules

## 🚀 Testing Instructions

### Local Testing
1. Update RevenueCat API key in `app_constants.dart`
2. Run app in debug mode
3. Test paywall UI and navigation

### Sandbox Testing
1. iOS: Use TestFlight with sandbox purchases
2. Android: Use internal testing track
3. Test all subscription tiers and billing cycles
4. Verify feature gating works correctly

### Production Testing
1. Create production builds
2. Test with real payment methods in sandbox
3. Verify analytics and user journey

## 📊 Feature Gating Implementation

The system automatically gates features based on subscription tier:

### Free Tier Limitations
- Session history: Last 20 sessions only
- Basic analytics only
- No export functionality
- 5-minute session limit

### Premium Tier ($1.99) - Phase 1
- Unlimited session history
- Advanced analytics and trends
- Data export (CSV/PDF)
- Extended sessions (60 minutes)
- Premium themes
- Priority support

### Premium Plus Tier ($3.99) - Phase 2
- All Premium features
- Cloud synchronization and backup
- AI-powered insights
- Multi-environment profiles
- Social features and challenges
- Advanced customization options

### Usage Example
```dart
// In any widget, wrap premium features:
FeatureGate(
  feature: 'advanced_analytics',
  child: AdvancedAnalyticsWidget(),
  fallback: UpgradePromptWidget(),
)

// Or check programmatically:
final canAccess = await checkFeatureAccessOrShowPaywall(
  context,
  'export_data',
  showPaywall: true,
);
```

## 🎯 Launch Checklist

### Pre-Launch
- [ ] RevenueCat API key configured
- [ ] App Store Connect subscriptions created and approved
- [ ] Google Play Console subscriptions created
- [ ] Sandbox testing completed successfully
- [ ] Privacy policy updated with subscription terms
- [ ] App metadata and screenshots prepared

### Launch Day
- [ ] Submit iOS app for review
- [ ] Publish Android app to production
- [ ] Monitor subscription analytics
- [ ] Test customer support flow
- [ ] Monitor for any issues or crashes

### Post-Launch
- [ ] Analyze conversion rates
- [ ] A/B test paywall variations
- [ ] Monitor customer feedback
- [ ] Optimize pricing based on data
- [ ] Plan feature updates for premium tiers

## 🔍 Monitoring and Analytics

### Key Metrics to Track
- Paywall conversion rate
- Subscription tier distribution
- Churn rate by tier
- Feature usage by subscription status
- Customer lifetime value

### Tools Integration
- RevenueCat dashboard for subscription analytics
- Firebase Analytics for user behavior
- App Store Connect/Google Play Console for app performance

## 🆘 Troubleshooting

### Common Issues
1. **RevenueCat API errors**: Check API key and product IDs
2. **Purchase failures**: Verify App Store/Play Console configuration
3. **Feature gate not working**: Check subscription provider state
4. **Build failures**: Ensure all dependencies are compatible

### Support Resources
- RevenueCat documentation: [docs.revenuecat.com](https://docs.revenuecat.com)
- Flutter in-app purchases guide
- App Store Connect developer support
- Google Play Console help center

## 📝 Next Development Priorities

1. **Phase 1 Revenue System** (Priority 1)
   - Configure RevenueCat API key
   - Set up App Store/Play Console subscriptions
   - Complete Premium tier features
   - End-to-end testing

2. **Phase 1 Premium Features** (Priority 2)
   - Extended session implementation
   - Advanced analytics dashboard
   - Data export functionality (CSV/PDF)
   - Premium themes and customization
   - Priority support system

3. **Phase 2 Planning** (Priority 3)
   - Premium Plus tier architecture design
   - Cloud sync infrastructure planning
   - AI insights framework development
   - Social features and multi-environment design

---

**Status**: 🟡 Ready for Configuration
**Next Action**: Set up RevenueCat account and obtain API key
**Estimated Setup Time**: 2-4 hours for complete configuration
**Launch Ready**: After successful sandbox testing

## Related Documents
- [docs/business/phase1-launch-plan.md](docs/business/phase1-launch-plan.md) - Complete launch strategy
- [docs/business/implementation-analysis.md](docs/business/implementation-analysis.md) - Technical implementation roadmap
- [docs/business/revenue-strategy.md](docs/business/revenue-strategy.md) - Revenue model and pricing strategy

## Last Updated
January 27, 2025

---

*This setup guide covers the technical configuration required to enable SilenceScore's monetization system. Follow all steps in sequence for successful implementation.*
