# Android Release Quick Start Guide

## 🎯 Goal

Build a signed Android release APK/AAB and upload it to Google Play Console for testing/distribution.

## ⏱️ Estimated Time: 30-45 minutes (first time)

---

## Step 1: Create Keystore (5 minutes)

**What:** A keystore is your cryptographic signing certificate. You need it to publish to Google Play.

**⚠️ CRITICAL:** Back up your keystore and password! If lost, you cannot update your app.

```bash
cd /Users/krishna/Development/FocusField/android

keytool -genkey -v \
  -keystore focusfield-release.jks \
  -alias focusfield \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storetype JKS
```

**You'll be prompted for:**
- Keystore password (choose a strong one, write it down!)
- Key password (can be same as keystore password)
- Your name/organization details

**Result:** File `focusfield-release.jks` created in `android/` directory

**📚 Detailed guide:** `docs/deployment/ANDROID_KEYSTORE_SETUP.md`

---

## Step 2: Configure key.properties (2 minutes)

Update `android/key.properties` with your keystore credentials:

```bash
cd /Users/krishna/Development/FocusField/android
nano key.properties
```

**Content:**
```properties
storeFile=focusfield-release.jks
storePassword=YOUR_ACTUAL_PASSWORD_FROM_STEP1
keyAlias=focusfield
keyPassword=YOUR_ACTUAL_PASSWORD_FROM_STEP1
```

**Save:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

---

## Step 3: Back Up Keystore (5 minutes)

**⚠️ DO NOT SKIP THIS!**

Copy `android/focusfield-release.jks` to 2-3 secure locations:
1. Password manager (1Password, LastPass, etc.)
2. Encrypted cloud storage (Google Drive, Dropbox)
3. External hard drive

**Also save:**
- Keystore password
- Key alias: `focusfield`
- Key password

---

## Step 4: Build Release (5 minutes)

### Using the Build Script (Recommended)

The project includes a build script that handles all configuration automatically:

```bash
cd /Users/krishna/Development/FocusField

# Build AAB (for Play Store - RECOMMENDED)
./scripts/build/build-android-release.sh --aab

# Or build APK (for direct distribution testing)
./scripts/build/build-android-release.sh --apk

# Clean build (removes cached files first)
./scripts/build/build-android-release.sh --aab --clean
```

**What the script does:**
- ✅ Validates keystore and key.properties exist
- ✅ Loads RevenueCat API key from `.env` file
- ✅ Sets production flags (`IS_DEVELOPMENT=false`, `ENABLE_MOCK_SUBSCRIPTIONS=false`)
- ✅ Signs with your keystore automatically
- ✅ Verifies signature after build

**Output locations:**
- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

**Expected output:**
```
✅ Build Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Output: build/app/outputs/bundle/release/app-release.aab
📊 Size: 60M

📤 Next Steps - Upload to Google Play Console:
   1. Go to: https://play.google.com/console
   2. Select your app: Focus Field
   3. Navigate to: Release → Internal Testing
   4. Create new release
   5. Upload: build/app/outputs/bundle/release/app-release.aab
   6. Add release notes and roll out
```

### Script Options

| Option | Description |
|--------|-------------|
| `--aab` | Build App Bundle (Play Store format, default) |
| `--apk` | Build APK (for direct device testing) |
| `--clean` | Clean previous build artifacts first |

### Troubleshooting Build Script

**Error: "bad substitution"**
- This happens on older bash versions (macOS uses bash 3.2 by default)
- Fixed in latest script version
- Alternative: Use manual build command below

**Manual build alternative (if script fails):**
```bash
flutter build appbundle --release \
  --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=IS_DEVELOPMENT=false
```

---

## Step 5: Upload to Google Play Console (10-15 minutes)

### A. Create App (First Time Only)

1. Go to [Google Play Console](https://play.google.com/console)
2. Click **Create app**
3. Fill in:
   - **App name:** Focus Field
   - **Default language:** English (United States)
   - **App or game:** App
   - **Free or paid:** Free
4. Accept declarations
5. Click **Create app**

### B. Complete Store Listing (First Time Only)

1. **Store listing** (left sidebar)
2. Fill in required fields:
   - **Short description:** (80 chars) "Measure ambient silence to build deep focus habits through compassionate progression"
   - **Full description:** See `docs/business/store-listing.md` for copy
   - **App icon:** 512x512 PNG (see `docs/deployment/ICON_PROMPT.md`)
   - **Feature graphic:** 1024x500 PNG
   - **Screenshots:** At least 2 phone screenshots
3. **Content rating:** Complete questionnaire
4. **Target audience:** Complete selection
5. **Privacy policy:** https://sparkvibe.io/privacy (update before launch)

### C. Upload to Internal Testing

**Open Play Console and Finder:**
```bash
# Open Google Play Console in browser
open "https://play.google.com/console"

# Open build output directory for easy access
open build/app/outputs/bundle/release
```

**In Play Console:**

1. Navigate: **Testing** → **Internal testing** (left sidebar)
2. Click **"Create new release"**

3. **Set Up App Signing (FIRST RELEASE ONLY):**

   ⚠️ **CRITICAL DECISION** - Choose one:

   **Option 1: Let Google Manage (RECOMMENDED ✅)**
   - Select: **"Let Google create and manage my app signing key"**
   - Benefits:
     - ✅ Google keeps backup signing key
     - ✅ Can reset if you lose your keystore
     - ✅ Required for Play Integrity API
     - ✅ More secure
   - Your keystore becomes "upload key"
   - Google re-signs with their managed "app signing key"

   **Option 2: Export and Upload (NOT RECOMMENDED)**
   - Only if you have strict security requirements
   - ❌ If you lose keystore, can NEVER update app

   **Select Option 1 and click "Continue"**

4. **Upload AAB File:**

   **Method 1: Drag & Drop (Easiest)**
   - Drag `app-release.aab` from Finder to upload box
   - Wait for upload (1-2 minutes)

   **Method 2: Click Upload**
   - Click "Upload" button
   - Navigate to: `/Users/krishna/Development/FocusField/build/app/outputs/bundle/release/`
   - Select `app-release.aab`
   - Click Open

   Wait for processing: ⏳ 5-20 minutes

5. **Fill Release Details:**

   **Release name:** `1.0.0 (1)`

   **Release notes (English - United States):**
   ```
   Initial internal testing release

   ✨ Features:
   - Focus sessions with real-time ambient noise monitoring
   - Ambient Quest system with daily goals and streaks
   - Premium subscriptions via RevenueCat
   - AdMob integration for free tier
   - Material 3 design with dark/light themes
   - 7 languages: EN, ES, DE, FR, JA, PT, ZH

   🎯 Test Focus:
   - Premium subscription purchase flow
   - Ad display for free users
   - Focus Mode and session tracking
   ```

6. Click **"Save"**
7. Click **"Review release"**
8. Review summary
9. Click **"Start rollout to Internal testing"**

**Status will change:**
- ⏳ Processing → ✅ Available to testers (5-20 minutes)

### D. Add Test Users

1. Still in **Internal testing**
2. Go to **Testers** tab
3. Create **Email list:**
   - Name: Internal Testers
   - Add your Gmail accounts (the ones you'll test with)
4. **Save**
5. **Copy the opt-in URL** (you'll need this)

---

## Step 6: Install on Device (5 minutes)

1. **Open the opt-in URL** from Step 5D on your Android device
2. **Accept** to become a tester
3. **Download from Play Store**
4. **Install and open app**
5. **Test premium purchase flow:**
   - Trigger a premium feature (e.g., extended session)
   - Paywall should appear
   - Select yearly plan
   - Complete test purchase (will be cancelled automatically)

**⚠️ Important:** You MUST install from Play Store (not via `flutter run`) to test purchases!

---

## Step 7: Configure RevenueCat (5-10 minutes)

Now that your app is uploaded, configure subscriptions:

### A. Google Play Console - Create Subscriptions

1. **Monetize** → **Products** → **Subscriptions**
2. **Create subscription:**
   - **Product ID:** `premium` (NO DOTS!)
   - **Name:** Premium
   - **Description:** Premium tier with extended sessions and advanced analytics
3. **Add Base Plans:**
   - Base Plan 1: `premium-tier-monthly`
     - Billing: 1 month
     - Price: $0.99
   - Base Plan 2: `premium-tier-yearly`
     - Billing: 1 year
     - Price: $9.99
4. **Add Offers (optional):**
   - 1-week free trial for each base plan
5. **Activate** the subscription

### B. RevenueCat Dashboard - Configure Products

1. Go to [RevenueCat Dashboard](https://app.revenuecat.com)
2. **Products** → **+ New**
   - Store: Google Play Store
   - Product ID: `premium`
   - Type: Subscription
3. **Entitlements** → **+ New**
   - Identifier: `Premium`
   - Description: Premium tier access
   - Products: Select `premium`
4. **Offerings** → `Premium_Current_25`
   - Add Package 1: Monthly (`premium:premium-tier-monthly`)
   - Add Package 2: Yearly (`premium:premium-tier-yearly`)
   - Set as **Current offering**

**📚 Detailed guide:** `docs/deployment/REVENUECAT_ANDROID_SETUP.md`

---

## ✅ Success Criteria

After completing all steps, verify:

- [ ] Keystore created and backed up in 2+ locations
- [ ] AAB/APK builds successfully without errors
- [ ] App uploaded to Internal Testing in Play Console
- [ ] Test users added and can access opt-in URL
- [ ] App installs from Play Store on test device
- [ ] Google Play subscription `premium` created and Active
- [ ] RevenueCat products, entitlements, and offerings configured
- [ ] Premium purchase flow works on test device
- [ ] After purchase, premium features unlock

---

## 🎉 You're Done!

Your app is now ready for internal testing. Next steps:

### Immediate Testing
- Test all app features thoroughly
- Try premium purchase on multiple test accounts
- Verify ads display correctly for free users
- Test on different Android versions and screen sizes

### Before Public Launch
- [ ] Complete all Play Console requirements (ratings, categories, etc.)
- [ ] Upload final screenshots and graphics
- [ ] Update privacy policy with real URL
- [ ] Configure production subscriptions (not test mode)
- [ ] Prepare marketing materials
- [ ] Set up support email/website
- [ ] Plan launch announcement

### Promotion to Production
1. **Internal Testing** → **Promote release** → **Open testing** (optional)
2. Or directly: **Promote release** → **Production**
3. Submit for review (1-3 days for first submission)
4. Once approved, app goes live!

---

## 📚 Reference Documentation

- **Keystore Setup:** `docs/deployment/ANDROID_KEYSTORE_SETUP.md`
- **Android Studio:** `docs/deployment/ANDROID_STUDIO_SETUP.md`
- **RevenueCat Android:** `docs/deployment/REVENUECAT_ANDROID_SETUP.md`
- **Monetization:** `docs/MONETIZATION_SETUP.md`
- **App Store Build:** `docs/deployment/IOS_APPSTORE_BUILD_GUIDE.md`

---

## 🆘 Troubleshooting

### Build fails with keystore error
- Check passwords in `android/key.properties`
- Verify keystore file exists: `ls -lh android/focusfield-release.jks`

### "Product not available for purchase"
- App must be installed from Play Store (not `flutter run`)
- Subscription must be **Active** status in Play Console
- Test account must be enrolled in Internal Testing

### No premium entitlements after purchase
- Verify RevenueCat entitlement identifier is exactly `Premium`
- Check product is attached to entitlement in RevenueCat dashboard
- Ensure offering is set as "current" in RevenueCat

### Can't find app in Play Store
- Use the opt-in URL from Internal Testing testers tab
- Can't search for internal testing apps - must use direct link
- After promoting to production, can search normally

---

## 🚀 Quick Commands Reference

### Build Commands

```bash
# Navigate to project root
cd /Users/krishna/Development/FocusField

# Build release AAB (Play Store format)
./scripts/build/build-android-release.sh --aab

# Build release APK (direct install)
./scripts/build/build-android-release.sh --apk

# Clean build (removes cached files first)
./scripts/build/build-android-release.sh --aab --clean

# Open build output directory
open build/app/outputs/bundle/release
```

### Upload Commands

```bash
# Open Play Console in browser
open "https://play.google.com/console"

# Open build directory for drag-and-drop upload
open build/app/outputs/bundle/release
```

### Verification Commands

```bash
# Verify signature
jarsigner -verify -verbose build/app/outputs/bundle/release/app-release.aab

# View keystore details
keytool -list -v -keystore android/focusfield-release.jks -alias focusfield

# Check AAB file size
ls -lh build/app/outputs/bundle/release/app-release.aab
```

### Testing Commands

```bash
# Install APK on connected device (for testing only)
adb install build/app/outputs/flutter-apk/app-release.apk

# Clear app data (reset subscription status)
adb shell pm clear io.sparkvibe.focusfield

# Open opt-in URL on device
adb shell am start -a android.intent.action.VIEW \
  -d "YOUR_OPT_IN_URL_HERE"
```

### Keystore Management

```bash
# Generate keystore (one-time setup)
cd android
keytool -genkey -v \
  -keystore focusfield-release.jks \
  -alias focusfield \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storetype JKS

# Back up keystore
cp focusfield-release.jks ~/backup/focusfield-release-backup-$(date +%Y%m%d).jks
```

---

## 📋 Complete Workflow (Copy-Paste Ready)

```bash
# 1. Navigate to project
cd /Users/krishna/Development/FocusField

# 2. Build release AAB
./scripts/build/build-android-release.sh --aab

# 3. Open Play Console and build directory
open "https://play.google.com/console"
open build/app/outputs/bundle/release

# Then in Play Console web interface:
# → Create app (first time only)
# → Testing → Internal testing → Create new release
# → Enable Play App Signing (recommended)
# → Upload: app-release.aab
# → Release name: 1.0.0 (1)
# → Release notes: [Copy from Step 5 above]
# → Save → Review → Start rollout
# → Testers tab → Create email list → Add Gmail accounts
# → Copy opt-in URL
# → Send to test device
# → Install from Play Store
# → Test purchases and ads
```

---

**Need help?** Check the detailed guides in `docs/deployment/` or open an issue.
