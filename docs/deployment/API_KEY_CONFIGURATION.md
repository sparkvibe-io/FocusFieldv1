# API Key Configuration for Production Builds

This guide explains how to configure RevenueCat and AdMob API keys for production builds of Focus Field.

## Table of Contents
- [Overview](#overview)
- [Setup: Create .env File](#setup-create-env-file)
- [Building for Android](#building-for-android)
- [Building for iOS](#building-for-ios)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

Focus Field uses **build-time configuration** via `--dart-define` flags to inject API keys securely. This approach:
- ✅ Keeps keys out of version control
- ✅ Works consistently across platforms
- ✅ Allows different keys per platform
- ✅ Prevents accidental key exposure

**Do NOT configure keys in Xcode or Android Studio** - use the build scripts instead.

---

## Setup: Create .env File

### 1. Create the .env File

Create a file named `.env` in your project root (`/Users/krishna/Development/FocusField/.env`):

```bash
# RevenueCat API Keys (platform-specific)
REVENUECAT_ANDROID_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
REVENUECAT_IOS_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME

# AdMob Ad Unit IDs (optional - already in code defaults)
ANDROID_BANNER_AD_UNIT_ID=ca-app-pub-2086096819226646/3553182566
IOS_BANNER_AD_UNIT_ID=ca-app-pub-2086096819226646/9050063581
```

### 2. Verify .gitignore

Ensure `.env` is in your `.gitignore` file to prevent committing secrets:

```bash
# Check if .env is ignored
grep -q "^.env$" .gitignore && echo "✅ .env is in .gitignore" || echo "⚠️  Add .env to .gitignore"
```

If not present, add this line to `.gitignore`:
```
.env
```

---

## Building for Android

### Quick Build (Recommended)

```bash
# Set the Android RevenueCat key
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"

# Build both APK and App Bundle
bash scripts/build/build-prod.sh
```

### What This Creates

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
  - Use for testing on devices
  - Not suitable for Play Store

- **App Bundle (AAB)**: `build/app/outputs/bundle/release/app-release.aab`
  - Upload to Google Play Console
  - Optimized for Play Store distribution

### Alternative: Pass Key via Flag

```bash
bash scripts/build/build-prod.sh --rc-key=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
```

### What Happens During Build

The script automatically:
1. Disables mock subscriptions (`ENABLE_MOCK_SUBSCRIPTIONS=false`)
2. Sets production mode (`IS_DEVELOPMENT=false`)
3. Injects your RevenueCat Android key
4. Uses AdMob keys from code defaults (or `.env` file)
5. Builds optimized release artifacts

---

## Building for iOS

### Standard Build

```bash
# Build iOS archive for App Store
flutter build ipa --release \
  --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME" \
  --dart-define=IOS_BANNER_AD_UNIT_ID="ca-app-pub-2086096819226646/9050063581"
```

### What This Creates

- **IPA Archive**: `build/ios/ipa/FocusField.ipa`
  - Ready for TestFlight or App Store submission
  - Includes all required entitlements and provisioning

### Upload to App Store

After building, upload using one of these methods:

**Option 1: Xcode Organizer (Recommended)**
```bash
open build/ios/archive/Runner.xcarchive
```
Then use Xcode's Organizer to validate and upload.

**Option 2: Command Line (Transporter)**
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/FocusField.ipa \
  --username "your-apple-id@email.com" \
  --password "app-specific-password"
```

---

## Security Best Practices

### 1. Never Commit API Keys

**❌ Do NOT:**
- Commit `.env` file to git
- Hardcode keys directly in code (except as last-resort fallbacks)
- Share keys in public channels (Slack, email, etc.)

**✅ Do:**
- Keep `.env` file local only
- Use environment variables in CI/CD pipelines
- Rotate keys if accidentally exposed

### 2. Separate Dev/Prod Keys

Your current setup already handles this correctly:

| Environment | RevenueCat Key | AdMob Behavior |
|-------------|----------------|----------------|
| Development | Mock/Test | Google test ads |
| Production (Android) | `goog_HNK...` | Real Android ads |
| Production (iOS) | `appl_qoF...` | Real iOS ads |

### 3. Key Rotation

If you need to rotate keys:

1. Generate new keys in RevenueCat/AdMob dashboards
2. Update `.env` file with new keys
3. Rebuild and redeploy apps
4. Old keys remain valid until next app update

---

## Troubleshooting

### AdMob Keys Already Configured

**Good news**: Your AdMob keys are already hardcoded as defaults in `lib/constants/app_constants.dart`:

```dart
static const String androidBannerAdUnitId = String.fromEnvironment(
  'ANDROID_BANNER_AD_UNIT_ID',
  defaultValue: 'ca-app-pub-2086096819226646/3553182566', // ✅ Your real key
);
```

**This means**: Even without passing `--dart-define` flags, your production ads will work correctly!

### RevenueCat Key Not Working

**Symptom**: Subscription features don't work in production build

**Solutions**:
1. Verify you're using the correct platform-specific key:
   - Android: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
   - iOS: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`

2. Check key was passed during build:
   ```bash
   # For Android
   grep -r "REVENUECAT_API_KEY" build/app/outputs/flutter-apk/app-release.apk
   # Should show your key is compiled in
   ```

3. Verify key in RevenueCat dashboard is active

### Mock Subscriptions Still Active

**Symptom**: Test subscriptions work in production build

**Cause**: `ENABLE_MOCK_SUBSCRIPTIONS` not disabled

**Solution**: Ensure you're using `build-prod.sh` script (not `build-dev.sh`):
```bash
# ✅ Correct (disables mocks)
bash scripts/build/build-prod.sh

# ❌ Wrong (enables mocks)
bash scripts/build/build-dev.sh
```

### Build Script Not Found

**Symptom**: `bash: scripts/build/build-prod.sh: No such file or directory`

**Solution**: Run from project root:
```bash
cd /Users/krishna/Development/FocusField
bash scripts/build/build-prod.sh
```

---

## Quick Reference

### Your Production Keys

| Service | Platform | Key |
|---------|----------|-----|
| **RevenueCat** | Android | `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf` |
| **RevenueCat** | iOS | `appl_qoFokYDCMBFZLyKXTulaPFkjdME` |
| **AdMob App ID** | Android | `ca-app-pub-2086096819226646~6517708516` |
| **AdMob App ID** | iOS | `ca-app-pub-2086096819226646~9627636327` |
| **AdMob Banner** | Android | `ca-app-pub-2086096819226646/3553182566` |
| **AdMob Banner** | iOS | `ca-app-pub-2086096819226646/9050063581` |

### Common Build Commands

```bash
# Android: Build APK + AAB for Play Store
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
bash scripts/build/build-prod.sh

# iOS: Build IPA for App Store
flutter build ipa --release \
  --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"

# Test production build locally (Android)
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
bash scripts/build/build-prod.sh
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Next Steps

After configuring and building:

1. **Android**: Upload `app-release.aab` to Google Play Console
2. **iOS**: Upload `FocusField.ipa` to App Store Connect
3. **Testing**: Test subscriptions and ads in production environment
4. **Monitoring**: Check RevenueCat and AdMob dashboards for activity

For deployment checklists, see:
- `docs/deployment/APP_STORE_SUBMISSION_CHECKLIST.md` (iOS)
- `docs/deployment/PLAY_STORE_SUBMISSION.md` (Android - if exists)

---

**Last Updated**: 2025-10-26
**Maintained By**: Focus Field Development Team
