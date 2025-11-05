# App Store Privacy Policy & Terms of Use Setup

**Date**: November 4, 2025
**Status**: Ready to configure
**Applies to**: Apple App Store & Google Play Store submissions

---

## 📋 Overview

This guide shows you exactly where to add your **Privacy Policy** and **Terms of Use** URLs when submitting Focus Field to the App Store and Google Play Store.

### URLs to Use

| Document | URL | Status |
|----------|-----|--------|
| **Privacy Policy** | `https://sparkvibe.io/privacy` | ✅ Ready (privacy.razor created) |
| **Terms of Use** | `https://sparkvibe.io/terms` | ✅ Ready (terms.razor created) |

---

## 🍎 Apple App Store Connect Configuration

### Step 1: Privacy Policy URL (REQUIRED)

**Location**: App Store Connect → Your App → App Information → Privacy Policy URL

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Click on your app ("Focus Field")
3. Navigate to **App Information** (left sidebar)
4. Scroll down to **Privacy Policy URL**
5. Enter: `https://sparkvibe.io/privacy`
6. Click **Save**

**Why it's required**: Apple requires all apps to have a publicly accessible Privacy Policy URL.

---

### Step 2: Terms of Use URL (REQUIRED for Subscription Apps)

Apple rejected your app because apps with **auto-renewable subscriptions** MUST include a Terms of Use (EULA) link.

#### Option 1: Add to App Description (RECOMMENDED - Quickest Fix)

**Location**: App Store Connect → Your App → Version → App Store → Description

1. Go to **App Store Connect** → Your App → **Prepare for Submission**
2. Click **App Store** tab
3. Scroll down to **Description** field
4. **Add this line at the end of your description**:

```
Terms of Use: https://sparkvibe.io/terms
```

**Complete Example**:
```
Focus Field is the first app that measures ambient silence to help you build deep focus habits. Track your environment, not your activity. Privacy-first, compassionate, powerful.

HOW IT WORKS
Start a session, and Focus Field measures ambient noise in real-time...

[... rest of your description ...]

Terms of Use: https://sparkvibe.io/terms
```

5. Click **Save**

---

#### Option 2: Custom EULA in App Store Connect (Alternative)

**Location**: App Store Connect → Your App → App Information → License Agreement

1. Go to **App Store Connect** → Your App → **App Information**
2. Scroll down to **License Agreement**
3. Click **Add Custom License Agreement**
4. You have two choices:
   - **Choice A**: Reference your URL:
     ```
     Please review our complete Terms of Use at: https://sparkvibe.io/terms
     ```
   - **Choice B**: Paste the full text from `docs/legal/TERMS_OF_USE.md`
5. Click **Save**

**Note**: Option 1 (adding to description) is faster and easier for most developers.

---

### Step 3: Support URL (OPTIONAL but Recommended)

**Location**: App Store Connect → Your App → App Information → Support URL

1. Go to **App Store Connect** → Your App → **App Information**
2. Scroll down to **Support URL**
3. Enter: `https://sparkvibe.io/contact` (or `mailto:support@sparkvibe.io`)
4. Click **Save**

---

### Step 4: Marketing URL (OPTIONAL)

**Location**: App Store Connect → Your App → App Information → Marketing URL

1. Go to **App Store Connect** → Your App → **App Information**
2. Scroll down to **Marketing URL**
3. Enter: `https://focusfield.io` (or `https://sparkvibe.io`)
4. Click **Save**

---

### Step 5: Verify In-App Subscription Display (REQUIRED)

Apple also requires that subscription information appears **inside your app**. Verify your paywall includes:

**Required Elements**:
- ✅ Subscription title (e.g., "Premium Monthly")
- ✅ Subscription duration (e.g., "1 month" or "Renews monthly")
- ✅ Subscription price (e.g., "$0.99/month")
- ✅ Clickable link to Privacy Policy
- ✅ Clickable link to Terms of Use

**Where to check**: Open your app → Navigate to paywall/subscription screen → Verify all elements are present.

**File to check**: `lib/widgets/paywall_modal.dart` or similar

If missing, you'll need to add clickable links like this:

```dart
TextButton(
  child: Text("Privacy Policy"),
  onPressed: () => launchUrl(Uri.parse("https://sparkvibe.io/privacy")),
),

TextButton(
  child: Text("Terms of Use"),
  onPressed: () => launchUrl(Uri.parse("https://sparkvibe.io/terms")),
),
```

---

### Step 6: Resubmit for Review

1. Save all changes in App Store Connect
2. Go to **Version** → **Prepare for Submission**
3. Review all information
4. Click **Submit for Review**
5. In **Review Notes**, add:

```
We have added the Terms of Use link to the app description as requested in the previous rejection.

Terms of Use: https://sparkvibe.io/terms
Privacy Policy: https://sparkvibe.io/privacy

All subscription information (title, duration, price) is displayed in the app's paywall screen with clickable links to both Privacy Policy and Terms of Use.
```

**Expected approval time**: 24-48 hours for metadata-only changes

---

## 🤖 Google Play Console Configuration

### Step 1: Privacy Policy URL (REQUIRED)

**Location**: Google Play Console → Your App → App Content → Privacy Policy

1. Log in to [Google Play Console](https://play.google.com/console)
2. Select your app ("Focus Field")
3. Navigate to **Policy** → **App content** (left sidebar)
4. Click on **Privacy policy**
5. Select **With a URL**
6. Enter: `https://sparkvibe.io/privacy`
7. Click **Save**

---

### Step 2: Terms of Use (Optional but Recommended)

**Location**: Google Play Console → Your App → Store Presence → Main Store Listing → App Details

Google Play doesn't have a dedicated "Terms of Use" field, but you should include it in your description:

1. Go to **Store Presence** → **Main store listing**
2. Scroll down to **Full description**
3. Add this at the end of your description:

```
Terms of Use: https://sparkvibe.io/terms
Privacy Policy: https://sparkvibe.io/privacy
```

---

### Step 3: Store Listing Contact Details (REQUIRED)

**Location**: Google Play Console → Your App → Store Presence → Store Settings → Contact Details

1. Go to **Store Presence** → **Store settings**
2. Scroll down to **Contact details**
3. Fill in:
   - **Email**: support@sparkvibe.io
   - **Website** (optional): https://sparkvibe.io or https://focusfield.io
   - **Phone** (optional): Your phone number
4. Click **Save**

---

### Step 4: Data Safety Form (REQUIRED)

**Location**: Google Play Console → Your App → App Content → Data Safety

This is where you declare what data your app collects and how it's used.

#### Data Collection - What to Declare

**1. Audio** (Select "Yes"):
- **Data type**: Microphone audio
- **Is this data collected, shared, or both?**: Collected only
- **Is this data processed ephemerally?**: **YES** ✅
  - Check this box! This is critical for Focus Field
  - Explanation: "We measure decibel levels in real-time and do not store audio files"
- **Is this data required or optional?**: Required
- **Why is this data collected?**: App functionality
- **Data usage description**: "Focus Field measures ambient noise levels (decibels only) to track focus sessions. No audio recordings are stored or transmitted."

**2. Device or Other IDs** (Select "Yes" - for AdMob):
- **Data type**: Device or other IDs
- **Is this data collected, shared, or both?**: Shared with advertising partners
- **Is this data processed ephemerally?**: No
- **Is this data required or optional?**: Optional (only for free tier users)
- **Why is this data collected?**: Advertising
- **Data usage description**: "Device identifiers are used by Google AdMob to serve ads to free tier users. Premium users do not see ads and this data is not collected."

**3. App Activity** (Optional - only if you enable analytics):
- If you enable Firebase Analytics in the future, declare this
- Currently: **NO** (analytics_service.dart is a stub)

**4. NO for everything else**:
- ❌ Location
- ❌ Personal info (name, email, etc.)
- ❌ Financial info
- ❌ Health and fitness
- ❌ Photos and videos
- ❌ Files and docs
- ❌ Calendar
- ❌ Contacts
- ❌ App interactions (beyond audio)

#### Data Security Practices

1. **Is all user data encrypted in transit?**: **YES** ✅
   - Explanation: RevenueCat API calls use HTTPS

2. **Do you provide a way for users to request their data be deleted?**: **YES** ✅
   - Explanation: Users can reset all data in app settings or uninstall the app

3. **Is this data required or optional?**: Depends on data type (see above)

---

### Step 5: App Access

**Location**: Google Play Console → Your App → App Content → App Access

1. Select: **All functionality is available without special access**
2. Click **Save**

(Focus Field doesn't require login)

---

## 📱 In-App Requirements

### iOS Paywall Requirements

Verify your app's paywall (subscription screen) includes:

```dart
// Example from lib/widgets/paywall_modal.dart

// Subscription details
Text("Premium Monthly - \$0.99/month"),
Text("Premium Yearly - \$9.99/year"),

// Legal links
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      child: Text("Privacy Policy"),
      onPressed: () => launchUrl(Uri.parse("https://sparkvibe.io/privacy")),
    ),
    Text(" • "),
    TextButton(
      child: Text("Terms of Use"),
      onPressed: () => launchUrl(Uri.parse("https://sparkvibe.io/terms")),
    ),
  ],
),
```

### Android Paywall Requirements

Same as iOS - ensure both links are clickable and visible.

---

## ✅ Verification Checklist

Before resubmitting to stores, verify:

### App Store Connect:
- [ ] Privacy Policy URL filled in: `https://sparkvibe.io/privacy`
- [ ] Terms of Use link added to app description (at the end)
- [ ] Paywall screen has clickable Privacy Policy link
- [ ] Paywall screen has clickable Terms of Use link
- [ ] Paywall shows subscription title, duration, and price
- [ ] Support email configured: support@sparkvibe.io

### Google Play Console:
- [ ] Privacy Policy URL filled in: `https://sparkvibe.io/privacy`
- [ ] Terms of Use link added to description (at the end)
- [ ] Data Safety form completed:
  - [ ] Audio: Ephemeral processing (YES)
  - [ ] Device IDs: Shared with AdMob (free tier only)
  - [ ] Data encrypted in transit: YES
  - [ ] User can request deletion: YES
- [ ] Contact details filled in (support@sparkvibe.io)
- [ ] Paywall screen has clickable Privacy Policy link
- [ ] Paywall screen has clickable Terms of Use link

### Website:
- [ ] Privacy Policy live at: `https://sparkvibe.io/privacy`
- [ ] Terms of Use live at: `https://sparkvibe.io/terms`
- [ ] Both URLs are publicly accessible (no login required)
- [ ] Both pages load correctly on mobile and desktop
- [ ] Content matches the Razor files you created

---

## 🚀 Deployment Order

To avoid rejection, follow this order:

1. **Deploy Legal Documents to Website** (DO THIS FIRST):
   ```bash
   # Upload privacy.razor and terms.razor to your website
   # Verify they're accessible at:
   # - https://sparkvibe.io/privacy
   # - https://sparkvibe.io/terms
   ```

2. **Update App Store Connect**:
   - Add Privacy Policy URL
   - Add Terms of Use to app description
   - Verify in-app paywall has links

3. **Update Google Play Console**:
   - Add Privacy Policy URL
   - Add Terms of Use to description
   - Complete Data Safety form

4. **Test Links**:
   - Open both URLs in browser (mobile and desktop)
   - Verify they load correctly
   - Verify no broken links

5. **Resubmit App**:
   - iOS: Submit for review with notes about Terms of Use addition
   - Android: Complete production release

---

## 🆘 Common Issues and Fixes

### Issue 1: "Privacy Policy URL returns 404"
**Fix**: Deploy privacy.razor to your website BEFORE submitting to stores

### Issue 2: "Terms of Use not found"
**Fix**: Ensure terms.razor is deployed at `https://sparkvibe.io/terms`

### Issue 3: "In-app subscription info missing"
**Fix**: Check your paywall widget (`lib/widgets/paywall_modal.dart`) includes:
- Subscription name
- Duration
- Price
- Clickable Privacy Policy link
- Clickable Terms of Use link

### Issue 4: "Link not clickable in app"
**Fix**: Use `url_launcher` package (already included in pubspec.yaml):
```dart
import 'package:url_launcher/url_launcher.dart';

TextButton(
  child: Text("Privacy Policy"),
  onPressed: () => launchUrl(Uri.parse("https://sparkvibe.io/privacy")),
),
```

---

## 📚 Related Documents

- **Privacy Policy Source**: `docs/legal/privacy.razor`
- **Terms of Use Source**: `docs/legal/terms.razor`
- **Apple Rejection Fix Guide**: `docs/deployment/APPLE_REJECTION_FIX_GUIDELINE_3.1.2.md`
- **Store Listing Content**: `docs/deployment/store_listing_en.md`
- **Submission Checklist**: `docs/deployment/APP_STORE_SUBMISSION_CHECKLIST.md`

---

## 📞 Support

If you encounter issues during submission:

**Apple Developer Support**: https://developer.apple.com/contact/
**Google Play Support**: https://support.google.com/googleplay/android-developer

**Internal Support**: support@sparkvibe.io

---

**Last Updated**: November 4, 2025
**Ready for**: Apple App Store resubmission & Google Play initial submission
