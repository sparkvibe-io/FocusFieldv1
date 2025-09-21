# Focus Field Monetization System Setup Guide

## Overview
This guide provides complete setup instructions for Focus Field's subscription monetization system. The infrastructure is fully implemented with centralized configuration, requiring only platform configuration and API key setup to enable revenue generation.

## Prerequisites
- Flutter development environment setup
- Access to RevenueCat dashboard
- App Store Connect developer account
- Google Play Console developer account
- Firebase project access (optional)

## Implementation Status

### Core Infrastructure
- **Subscription Service** (`lib/services/subscription_service.dart`)
- **Subscription Provider** (`lib/providers/subscription_provider.dart`)
- **Feature Gating** (`lib/widgets/feature_gate.dart`)
- **Paywall UI** (`lib/widgets/paywall_widget.dart`)
- **Subscription Tiers** (`lib/models/subscription_tier.dart`)
- **Centralized Config** (`lib/constants/app_constants.dart`)
- **Calibration & Threshold UX** (Premium enhancement context)

### Pricing Strategy
- Premium (single tier): Dynamic (store-side) – reference baseline $1.99/month or $19.99/year
- Localized price strings fetched from RevenueCat offerings / paywall
- Static fallback only if offerings fail to load

### Phase 1 Focus (Premium Tier Only)
Implemented:
- Extended sessions (up to 120 minutes)
- Advanced analytics & weekly trends
- Data export (CSV & PDF)
- Premium themes & customization
- Priority support
- Calibration dialog & high-threshold warnings (available to all, but extended sessions + export remain premium)

### Build Status
- ✅ iOS build successful (sandbox purchase tests pending final store config)
- ✅ Android build successful (dynamic pricing fallback stable)

## 🔧 Required Configuration Steps

### 1. RevenueCat Setup

#### Create RevenueCat Account
1. Go to [RevenueCat Dashboard](https://app.revenuecat.com)
2. Create account and new project
3. Add iOS and Android apps with bundle IDs:
  - iOS: `io.sparkvibe.focusfield`
  - Android: `io.sparkvibe.focusfield`

#### Configure Products
Create the following subscription product identifiers (must match exactly across App Store Connect, Google Play Console, and RevenueCat):
```
premium.tier:monthly  # Monthly (rename to premium.tier.monthly if stores reject colon)
premium.tier:yearly   # Yearly (rename to premium.tier.yearly if needed)
```

#### Update API Key
In `lib/constants/app_constants.dart`, replace:
```dart
static const String revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY_HERE';
```

### 2. App Store Connect Setup (iOS)

#### Create App
1. Login to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app with bundle ID: `io.sparkvibe.focusfield`
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
2. Create new app with package name: `io.sparkvibe.focusfield`
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
2. Create project for `Focus Field`
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
- Session length: **Up to 5 minutes**
- 7-day rolling history
- Basic analytics only
- No data export

### Premium Tier ($1.99 baseline)
- Extended sessions up to 120 minutes
- Weekly trends & advanced analytics
- CSV & PDF export
- Premium themes
- Priority support

### Deferred Higher Tier (Future)
- Cloud synchronization & backup
- AI-powered insights
- Multi-environment profiles
- Social & challenge features

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
1. Validate sandbox purchases (iOS) & internal testing (Android)
2. Add legal links (Privacy/Terms) to paywall footer
3. Store metadata & screenshots finalization
4. Evaluate A/B paywall layout (post-launch)

---
**Status**: 🟡 Store configuration & compliance polishing  
**Next Action**: Finalize product setup + legal links  
**Estimated Remaining Effort**: ~2 hours (store config + QA)  
**Launch Readiness**: Pending sandbox verification & legal footer additions

## Last Updated
August 29, 2025

---

*This setup guide covers the technical configuration required to enable Focus Field's monetization system. Follow all steps in sequence for successful implementation.*
