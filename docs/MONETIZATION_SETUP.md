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

**IMPORTANT: Platform-Specific Product ID Requirements**

**iOS (App Store Connect):**
- Product IDs can contain dots
- Use: `premium.tier.monthly` and `premium.tier.yearly`

**Android (Google Play Console):**
- Product IDs CANNOT contain dots (platform restriction)
- Use: `premium` as main product ID
- Use Base Plans: `premium-tier-monthly` and `premium-tier-yearly`

**RevenueCat Configuration:**
- iOS: Add product `premium.tier.monthly` and `premium.tier.yearly`
- Android: Add product `premium` with base plans `premium-tier-monthly` and `premium-tier-yearly`
- See `docs/deployment/REVENUECAT_ANDROID_SETUP.md` for detailed Android setup

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
2. Create Auto-Renewable Subscriptions (use these exact product IDs):
  - Premium Monthly: `premium.tier.monthly` ($1.99/month)
  - Premium Yearly: `premium.tier.yearly` ($19.99/year)
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
2. Create subscription with Product ID: `premium` (NO DOTS - Google Play restriction)
3. Add Base Plans under the `premium` product:
   - Base Plan ID: `premium-tier-monthly` ($0.99/month recommended)
   - Base Plan ID: `premium-tier-yearly` ($9.99/year recommended)
4. Configure offers (e.g., 1-week free trial) for each base plan
5. Set pricing for target markets
6. Activate the subscription (set status to "Active")

**CRITICAL:** Product ID must be `premium` (not `premium.tier.monthly`) because Google Play does not allow dots in subscription IDs.

#### Test in Internal Testing
1. Build release APK/AAB with correct dart-defines (see android.sh script)
2. Upload to Internal Testing track in Play Console
3. Add test accounts to testers list
4. Install app via Play Store link (NOT via `flutter run`)
5. Test purchase flows - test purchases are automatically cancelled after 5 minutes

**See detailed setup instructions:** `docs/deployment/REVENUECAT_ANDROID_SETUP.md`

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

## 📣 AdMob Ads Setup (Banners)

This app uses Google Mobile Ads (AdMob) for a single bottom banner. Integration is centralized and follows Google’s guidelines.

### What’s wired
- Android App ID (Manifest): `ca-app-pub-2086096819226646~6517708516`
- Android Banner Unit (Dart): `ca-app-pub-2086096819226646/3553182566`
- iOS: The `GADApplicationIdentifier` is currently the Google test App ID. Replace with your real iOS App ID before release.

### Where to configure
- Android App ID: `android/app/src/main/AndroidManifest.xml`
  - `<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID" android:value="YOUR_ANDROID_APP_ID" />`
- iOS App ID: `ios/Runner/Info.plist`
  - `<key>GADApplicationIdentifier</key><string>YOUR_IOS_APP_ID</string>`
- Banner Unit IDs (Dart): `lib/constants/app_constants.dart`
  - Test unit is always used in development (safe default)
  - Production units can be supplied via `--dart-define` or defaults in constants
    - ANDROID_BANNER_AD_UNIT_ID (default: `ca-app-pub-2086096819226646/3553182566`)
    - IOS_BANNER_AD_UNIT_ID (default: empty, set from AdMob console)

### Dev vs Prod behavior
- Development builds use the official test banner unit (`ca-app-pub-3940256099942544/6300978111`) regardless of platform to avoid policy issues.
- Production builds use platform-specific production unit IDs via `AppConstants.effectiveBannerAdUnitId`.
- Toggle with `--dart-define IS_DEVELOPMENT=false` for production-like runs.

### Policy checklist
- Do not encourage accidental clicks (no buttons directly above the banner).
- Avoid sticky overlapping content; banner sits in a dedicated footer.
- No prohibited content and no personal data collection tied to ads.
- Use Google’s test IDs during development. Only use real IDs in production/test tracks.

### Quick verification
1. Android: Install a build with `IS_DEVELOPMENT=false` on a physical device connected to Play services.
2. Confirm the banner loads without crashing and respects safe area.
3. iOS: Set your real iOS App ID in `Info.plist` and a real banner unit in `IOS_BANNER_AD_UNIT_ID`, then test on device.
4. Optional QA: If a new production unit shows "no fill" initially, set `ADS_FALLBACK_TEST_ON_FAIL=true` for a one-time retry with Google's test unit to verify integration.
