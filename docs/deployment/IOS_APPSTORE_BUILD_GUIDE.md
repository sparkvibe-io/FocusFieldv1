# iOS App Store Build & Deployment Guide

**Last Updated**: November 1, 2025
**App**: Focus Field
**Bundle ID**: `io.sparkvibe.focusfield`

---

## 🎯 Quick Start

```bash
# 1. Configure .env with production keys
# 2. Run the build script
bash scripts/build/build-ios-appstore.sh

# 3. Archive and upload via Xcode
open ios/Runner.xcworkspace
# Then: Product > Archive > Distribute App
```

---

## 📚 Table of Contents

1. [How Certificates & Profiles Work](#how-certificates--profiles-work)
2. [Environment Configuration](#environment-configuration)
3. [Build Process](#build-process)
4. [Understanding the Build Script](#understanding-the-build-script)
5. [Xcode Integration](#xcode-integration)
6. [Troubleshooting](#troubleshooting)

---

## How Certificates & Profiles Work

### The Certificate/Profile Relationship

**Important**: Certificates and provisioning profiles are **NOT** referenced directly in build scripts. They're configured in Xcode and used automatically during the build process.

### How It Works:

```
┌─────────────────────────────────────────────────────────────┐
│                     Build Flow                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. You configure in Xcode:                                 │
│     Runner > Signing & Capabilities > Release                │
│     ├─ Provisioning Profile: "Focus Field App Store"        │
│     └─ Code Signing Identity: "Apple Distribution"          │
│                                                              │
│  2. Xcode stores this in: ios/Runner.xcodeproj               │
│     (project.pbxproj file, PROVISIONING_PROFILE setting)    │
│                                                              │
│  3. Build script runs: flutter build ipa --release          │
│     └─ Flutter calls Xcode build system                     │
│        └─ Xcode reads project settings                      │
│           └─ Uses configured profile/certificate            │
│              └─ Signs IPA with Distribution certificate     │
│                                                              │
│  4. Result: Signed IPA ready for App Store                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Points:

1. **Certificates live in Keychain**
   - Location: Keychain Access > My Certificates
   - Name: "Apple Distribution: [Your Name]"
   - Automatically used by Xcode when signing

2. **Provisioning Profiles live in ~/Library**
   - Location: `~/Library/MobileDevice/Provisioning Profiles/`
   - Installed by double-clicking `.mobileprovision` file
   - Xcode finds them automatically

3. **Configuration lives in Xcode project**
   - File: `ios/Runner.xcodeproj/project.pbxproj`
   - Setting: `PROVISIONING_PROFILE_SPECIFIER`
   - Set via: Xcode GUI (Signing & Capabilities tab)

4. **Build scripts DON'T need certificate paths**
   - Scripts pass `--dart-define` flags for API keys
   - Xcode handles certificate/profile selection
   - No need to specify signing in command line

---

## Environment Configuration

### 1. Setup .env File

```bash
cd /Users/krishna/Development/FocusField
cp .env.example .env
nano .env  # or use your editor
```

### 2. Configure Production Keys

**Required for iOS App Store:**

```bash
# .env file
IS_DEVELOPMENT=false
ENABLE_MOCK_SUBSCRIPTIONS=false

# RevenueCat iOS Public API Key (starts with appl_)
REVENUECAT_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME

# Optional (already in Info.plist)
FIREBASE_API_KEY=
SENTRY_DSN=
```

### 3. Verify AdMob Configuration

**AdMob keys are in `ios/Runner/Info.plist` (already configured):**

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-2086096819226646~9627636327</string>
```

**Banner Ad Unit ID is in `lib/constants/app_constants.dart`:**

```dart
static const iosBannerAdUnitId = 'ca-app-pub-2086096819226646/9050063581';
```

### Key Differences: Development vs Production

| Setting | Development | Production (App Store) |
|---------|-------------|------------------------|
| `IS_DEVELOPMENT` | `true` | `false` |
| `ENABLE_MOCK_SUBSCRIPTIONS` | `true` | `false` |
| `REVENUECAT_API_KEY` | Can be test key | **Must be iOS public key (appl_)** |
| AdMob Ads | Uses test ads | Uses real ad units |
| Code Signing | Development certificate | **Distribution certificate** |
| Provisioning Profile | Development profile | **App Store profile** |

---

## Build Process

### Step-by-Step Build

#### Step 1: Pre-Build Checklist

- [ ] Distribution certificate installed (Keychain Access)
- [ ] App Store provisioning profile installed
- [ ] Xcode configured with Release signing
- [ ] `.env` file has production keys
- [ ] Version number updated in `pubspec.yaml`

#### Step 2: Run Build Script

```bash
bash scripts/build/build-ios-appstore.sh
```

**What the script does:**

1. ✅ Validates `.env` exists
2. ✅ Checks RevenueCat iOS key (must start with `appl_`)
3. ✅ Verifies AdMob configuration
4. ✅ Confirms version number with you
5. ✅ Runs `flutter clean` and `flutter pub get`
6. ✅ Builds IPA with production `--dart-define` flags
7. ✅ Shows next steps for Xcode upload

#### Step 3: Verify Build Output

**Check the build log for:**

```
✅ Configuration Validated:
   RevenueCat iOS Key: appl_qoFokYDCM...
   AdMob App ID: ca-app-pub-2086096819226646~9627636327
   AdMob Banner ID: ca-app-pub-2086096819226646/9050063581

✅ iOS Build Completed!
📱 IPA Location: build/ios/ipa/Focus Field.ipa
```

#### Step 4: Archive in Xcode

```bash
# Open workspace (NOT .xcodeproj!)
open ios/Runner.xcworkspace
```

**In Xcode:**

1. Select scheme: **Runner** (top toolbar)
2. Select device: **Any iOS Device (arm64)** (NOT simulator!)
3. Menu: **Product > Archive**
4. Wait for archive to complete (~5-10 min)

#### Step 5: Upload to App Store Connect

**Organizer window opens automatically:**

1. Select your archive
2. Click **Distribute App**
3. Select: **App Store Connect** → Next
4. Select: **Upload** → Next
5. Options:
   - ✅ Upload your app's symbols (for crash reports)
   - ✅ Manage Version and Build Number
6. Signing: **Automatically manage signing** → Next
7. Review summary → **Upload**
8. Wait for upload (~5-15 minutes)

---

## Understanding the Build Script

### What Gets Passed to the Build?

The `build-ios-appstore.sh` script passes these as `--dart-define` flags:

```bash
flutter build ipa --release \
    --dart-define=IS_DEVELOPMENT="false" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="false" \
    --dart-define=REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME" \
    --dart-define=FIREBASE_API_KEY="FIREBASE_API_KEY_NOT_SET" \
    --dart-define=SENTRY_DSN=""
```

### How the App Reads These Values

**In your Flutter code** (`lib/main.dart` or service files):

```dart
// Read the values passed via --dart-define
const isDevMode = bool.fromEnvironment('IS_DEVELOPMENT', defaultValue: false);
const mockSubs = bool.fromEnvironment('ENABLE_MOCK_SUBSCRIPTIONS', defaultValue: false);
const rcKey = String.fromEnvironment('REVENUECAT_API_KEY', defaultValue: '');
```

### Why AdMob Keys Aren't in --dart-define

**AdMob configuration uses platform-native files:**

- **iOS**: `ios/Runner/Info.plist` (GADApplicationIdentifier)
- **Android**: `android/app/src/main/AndroidManifest.xml` (com.google.android.gms.ads.APPLICATION_ID)

These are read by the native AdMob SDK at runtime, not via Dart environment variables.

### Certificate/Profile: Why NOT in the Script?

**Because they're already configured in Xcode:**

```
ios/Runner.xcodeproj/project.pbxproj contains:
PROVISIONING_PROFILE_SPECIFIER = "Focus Field App Store";
CODE_SIGN_IDENTITY = "Apple Distribution";
```

When you run `flutter build ipa`, Flutter calls `xcodebuild`, which reads these settings from the project file.

---

## Xcode Integration

### Where Certificates/Profiles Are Configured

#### 1. Open Project Settings

```bash
open ios/Runner.xcworkspace
```

- Click **Runner** (left panel, blue icon)
- Select **Runner** target (under TARGETS)
- Click **Signing & Capabilities** tab

#### 2. Release Configuration

**For App Store builds, configure Release only:**

```
Release (expanded):
├─ [ ] Automatically manage signing (UNCHECKED for manual control)
├─ Team: [Your Team]
├─ Provisioning Profile: Focus Field App Store
├─ Signing Certificate: Apple Distribution: [Your Name]
└─ Bundle Identifier: io.sparkvibe.focusfield
```

#### 3. Verify Settings

**Check that Release uses:**

- ✅ **Provisioning Profile**: `Focus Field App Store` (NOT development profile)
- ✅ **Code Signing Identity**: `Apple Distribution` (NOT Apple Development)

**Debug can use different settings:**

- Debug can use: Development certificate + Development profile
- Build script only affects Release builds

---

## Troubleshooting

### Issue 1: "Code signing requires a provisioning profile"

**Cause**: Xcode can't find the App Store provisioning profile

**Solution**:
```bash
# 1. Re-download profile from developer portal
# 2. Double-click to install: Focus_Field_App_Store.mobileprovision
# 3. Restart Xcode
# 4. Xcode > Preferences > Accounts > Download Manual Profiles
```

### Issue 2: "No signing certificate found"

**Cause**: Distribution certificate not in Keychain

**Solution**:
```bash
# 1. Download distribution.cer from developer portal
# 2. Double-click to install in Keychain
# 3. Verify: Keychain Access > My Certificates > "Apple Distribution"
```

### Issue 3: "Provisioning profile doesn't include signing certificate"

**Cause**: Profile was created before certificate

**Solution**:
```bash
# 1. Go to developer portal
# 2. Edit App Store provisioning profile
# 3. Select your Distribution certificate
# 4. Re-generate and re-download profile
```

### Issue 4: Build succeeds but upload fails

**Check for:**

```bash
# 1. Correct bundle ID
grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj
# Should show: io.sparkvibe.focusfield

# 2. Correct team ID
# Xcode > Runner > Signing & Capabilities > Team

# 3. Profile matches bundle ID
# Developer portal > Profiles > "Focus Field App Store" > App ID
```

### Issue 5: "Missing compliance documentation"

**Cause**: Export compliance not answered in App Store Connect

**Solution**:
```bash
# 1. Go to App Store Connect
# 2. Select app version
# 3. Answer encryption question:
#    - Does your app use encryption? YES (uses HTTPS)
#    - Does it use exempt encryption? YES (standard HTTPS only)
```

### Issue 6: Wrong RevenueCat key (Android key for iOS build)

**Symptom**: Build succeeds but subscriptions don't work

**Check**:
```bash
# iOS keys start with: appl_
# Android keys start with: goog_

# Verify your .env has the iOS key:
grep REVENUECAT_API_KEY .env
# Should show: REVENUECAT_API_KEY=appl_...
```

---

## Build Verification Checklist

After building, verify these are included:

### 1. Check Build Log Output

```
✅ Configuration Validated:
   RevenueCat iOS Key: appl_qoFokYDCM...  ← Must start with appl_
   AdMob App ID: ca-app-pub-...           ← Matches Info.plist
   AdMob Banner ID: ca-app-pub-...        ← Correct banner unit

✅ Production Settings:
   Environment: Production                 ← IS_DEVELOPMENT=false
   Mock Subscriptions: Disabled            ← ENABLE_MOCK_SUBSCRIPTIONS=false
   Development Mode: Disabled
```

### 2. Verify IPA Signing

```bash
# Check IPA signature
unzip -l "build/ios/ipa/Focus Field.ipa" | grep "embedded.mobileprovision"
# Should show: embedded.mobileprovision (the App Store profile)

# Verify code signing
codesign -dvv "build/ios/ipa/Focus Field.ipa"
# Should show: Authority=Apple Distribution: [Your Name]
```

### 3. Test IPA Locally (Optional)

```bash
# Install on connected device (requires development cert)
# OR use TestFlight after upload for real testing
```

---

## Common Questions

### Q: Do I need to modify the build script for my certificates?

**A**: No! Certificates and profiles are configured in Xcode, not in scripts. The script only passes API keys via `--dart-define`.

### Q: What if I have multiple distribution certificates?

**A**: Xcode will use the one specified in **Signing & Capabilities** for the Release configuration. Make sure the correct one is selected.

### Q: Can I automate the entire upload process?

**A**: Partially. You can use `fastlane` or `xcrun altool` to upload from command line, but Apple recommends using Xcode Organizer for the first submission to catch any issues.

### Q: How do I switch between iOS and Android builds?

**A**: Use different API keys in `.env`:

```bash
# For iOS build
export REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"
bash scripts/build/build-ios-appstore.sh

# For Android build
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
bash scripts/build/build-prod.sh
```

### Q: What happens if the build script doesn't find my .env?

**A**: The script will exit with an error:

```
❌ Error: .env file not found
   Copy .env.example to .env and configure your production keys
```

---

## Quick Reference

### iOS Production Build Command

```bash
bash scripts/build/build-ios-appstore.sh
```

### What It Includes

| Component | Source | How It's Included |
|-----------|--------|-------------------|
| RevenueCat iOS Key | `.env` file | `--dart-define=REVENUECAT_API_KEY` |
| AdMob App ID | `ios/Runner/Info.plist` | Native iOS config |
| AdMob Banner ID | `lib/constants/app_constants.dart` | Dart code constant |
| Distribution Cert | Keychain Access | Xcode project settings |
| App Store Profile | `~/Library/MobileDevice/` | Xcode project settings |
| Production Flags | Script | `--dart-define` flags |

### Required Files

- ✅ `.env` (with iOS keys)
- ✅ `ios/Runner/Info.plist` (with AdMob App ID)
- ✅ `lib/constants/app_constants.dart` (with banner ID)
- ✅ Distribution certificate (in Keychain)
- ✅ App Store profile (installed)
- ✅ Xcode project configured (Signing & Capabilities)

---

## Next Steps After Upload

1. **Wait for Processing** (10-30 minutes)
   - Apple validates the build
   - You'll receive email when ready

2. **Check App Store Connect**
   - URL: https://appstoreconnect.apple.com
   - Status: Processing → Ready to Submit

3. **Complete App Listing**
   - Screenshots (use DEMO_MODE for clean data)
   - Description (from `docs/deployment/store_listing_en.md`)
   - Keywords, pricing, etc.

4. **Submit for Review**
   - Review time: 1-3 days typically
   - Be responsive to reviewer questions

---

**For questions or issues, check:**
- [Apple Developer Documentation](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- Project docs: `docs/deployment/APP_STORE_SUBMISSION_CHECKLIST.md`
