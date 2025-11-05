# RevenueCat Android Setup Guide

## Product ID Configuration

### ⚠️ IMPORTANT: Android vs iOS Product ID Differences

**Google Play (Android):**
- Product IDs **CANNOT contain dots (.)**
- Must use hyphens (-) or underscores (_)
- Example: `premium` (not `premium.tier.monthly`)

**App Store (iOS):**
- Product IDs **CAN contain dots**
- Example: `premium.tier.monthly` is valid

### Current Configuration

#### Google Play Console
1. **Subscription Product ID:** `premium`
2. **Base Plans:**
   - `premium-tier-monthly` (e.g., $0.99/month with 1-week free trial)
   - `premium-tier-yearly` (e.g., $9.99/year with 1-week free trial)

#### RevenueCat Dashboard Setup

**Product Configuration:**
```
Store: Google Play Store
Product Identifier: premium
Type: Subscription
```

**Entitlements:**
```
Entitlement Identifier: Premium
Description: Premium tier access
Products: premium (with all base plans)
```

**Offerings Configuration:**
```
Offering Identifier: Premium_Current_25

Packages:
  - Package 1: Monthly
    Product: premium
    Base Plan: premium-tier-monthly

  - Package 2: Yearly
    Product: premium
    Base Plan: premium-tier-yearly
```

### How RevenueCat Works on Android

1. **Product ID** = The main subscription in Google Play Console (e.g., `premium`)
2. **Base Plan ID** = Different billing periods under that product (e.g., `premium-tier-monthly`)
3. **Offer ID** = Optional promotional offers (e.g., `1-week-trial-monthly`)

The full identifier RevenueCat shows in logs is: `productId:basePlanId`
- Example: `premium:premium-tier-monthly`

### Troubleshooting Checklist

#### In Google Play Console:
- [ ] Subscription product `premium` exists and is **Active**
- [ ] Base plans `premium-tier-monthly` and `premium-tier-yearly` are **Active**
- [ ] Pricing is set for at least one country (e.g., United States)
- [ ] App is uploaded to **Internal Testing** track (not sideloaded)
- [ ] Your test account is added to the Internal Testing list
- [ ] Test account is signed into Google Play on the device

#### In RevenueCat Dashboard:
- [ ] Android app is configured with package name `io.sparkvibe.focusfield`
- [ ] Google Play Service Credentials are uploaded (JSON key file)
- [ ] Product `premium` is added under Products tab
- [ ] Entitlement `Premium` exists and has `premium` product attached
- [ ] Offering `Premium_Current_25` has packages configured with correct base plans
- [ ] API key starts with `goog_` (Android public key)

#### In Your Code:
- [ ] Running with `--dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- [ ] Running with `--dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false`
- [ ] App is built in **profile** or **release** mode (not debug)
- [ ] Device is running app installed from Internal Testing (not via `flutter run`)

### Testing Steps

1. **Upload to Internal Testing:**
   ```bash
   # Build release APK
   flutter build apk --release \
     --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf \
     --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false

   # Or build AAB for Play Console
   flutter build appbundle --release \
     --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf \
     --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
   ```

2. **Upload to Play Console** → Internal Testing track

3. **Install via Play Store link** (not `flutter run`)

4. **Test purchase flow:**
   - Tap a premium feature
   - Paywall should appear
   - Select yearly package
   - Complete test purchase (will be cancelled automatically)
   - Premium features should unlock

### Expected Log Output (Success)

```
🧪 RC Diagnostic: current offering = Premium_Current_25; packages=2
🧪 RC Diagnostic: package productId=premium:premium-tier-monthly
🧪 RC Diagnostic: package productId=premium:premium-tier-yearly
💰 Purchase started - product: premium:premium-tier-yearly
📊 RevenueCat: Active entitlements: [Premium]
✅ RevenueCat: Found premium entitlement: Premium
```

### Common Errors

**Error:** `Product not available for purchase`
- **Cause:** App is sideloaded or subscription not Active in Play Console
- **Fix:** Install from Internal Testing track, ensure products are Active

**Error:** `No active entitlements after purchase`
- **Cause:** Entitlement not configured in RevenueCat or product not attached
- **Fix:** Verify Entitlements tab in RevenueCat dashboard

**Error:** `Offerings current is null`
- **Cause:** No offering is set as "current" in RevenueCat
- **Fix:** Go to Offerings → Set `Premium_Current_25` as current offering

### API Key Reference

**Android RevenueCat API Key:**
```
goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
```

**Entitlement Identifier:**
```
Premium
```

**Expected in logs:**
```dart
--dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
--dart-define=REVENUECAT_ENTITLEMENT_KEY=Premium
```

### Next Steps

1. Complete Google Play Console configuration (create subscriptions if missing)
2. Configure RevenueCat dashboard (products, entitlements, offerings)
3. Upload APK to Internal Testing
4. Test purchase flow from Play Store installation
5. Verify entitlements are granted in logs

---

**For iOS setup, see:** `docs/deployment/IOS_APPSTORE_BUILD_GUIDE.md`
