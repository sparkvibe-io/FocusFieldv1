# Firebase + AdMob Integration Setup Guide

## Overview
Google AdMob requires Firebase integration for proper analytics and functionality. This guide walks through the complete setup process.

## Prerequisites
- Google account for Firebase Console
- AdMob account already configured (App IDs: iOS ca-app-pub-2086096819226646~9627636327, Android ca-app-pub-2086096819226646~6517708516)

---

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: **"FocusField"** (or your preferred name)
4. Click **Continue**
5. **Enable Google Analytics** when prompted (REQUIRED for AdMob integration)
6. Select or create a Google Analytics account
7. Click **Create project**
8. Wait for project creation to complete

---

## Step 2: Add iOS App to Firebase

1. In Firebase Console, click the **iOS icon** to add an iOS app
2. Fill in the iOS bundle ID: `io.sparkvibe.focusfield`
3. App nickname (optional): "FocusField iOS"
4. App Store ID (optional): Leave blank for now (will add after App Store submission)
5. Click **Register app**
6. **Download `GoogleService-Info.plist`** file
7. **IMPORTANT**: Place the file in `ios/Runner/` directory (same level as Info.plist)
   ```bash
   # From your downloads folder:
   cp ~/Downloads/GoogleService-Info.plist ios/Runner/
   ```
8. Open Xcode project: `open ios/Runner.xcworkspace`
9. Drag `GoogleService-Info.plist` into the Runner folder in Xcode's Project Navigator
   - **Check**: ✅ "Copy items if needed"
   - **Target**: ✅ Runner
10. Click **Next** in Firebase Console
11. Skip the "Add Firebase SDK" step (already done via pubspec.yaml)
12. Skip initialization code step (will do this next)
13. Click **Continue to console**

---

## Step 3: Add Android App to Firebase

1. In Firebase Console, click the **Android icon** to add an Android app
2. Fill in the Android package name: `io.sparkvibe.focusfield`
3. App nickname (optional): "FocusField Android"
4. Debug signing certificate SHA-1 (optional): Can add later for debugging
5. Click **Register app**
6. **Download `google-services.json`** file
7. Place the file in `android/app/` directory:
   ```bash
   # From your downloads folder:
   cp ~/Downloads/google-services.json android/app/
   ```
8. Click **Next**
9. Skip the gradle modifications step (will do this next)
10. Click **Continue to console**

---

## Step 4: Update Android Build Configuration

### 4.1 Update android/build.gradle

Add the Google Services plugin to the buildscript dependencies:

```gradle
buildscript {
    ext.kotlin_version = '2.1.0'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.7.3'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.0'  // ADD THIS LINE
    }
}
```

### 4.2 Update android/app/build.gradle

Add the plugin at the **bottom** of the file:

```gradle
// ... existing file content ...

apply plugin: 'com.google.gms.google-services'  // ADD THIS LINE AT THE BOTTOM
```

---

## Step 5: Initialize Firebase in Flutter App

Update `lib/main.dart` to initialize Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // ... rest of your existing main() code ...
  runApp(const ProviderScope(child: FocusFieldApp()));
}
```

---

## Step 6: Link AdMob to Firebase

1. Go to [AdMob Console](https://apps.admob.com/)
2. Click **Settings** (gear icon) in the left sidebar
3. Click **Account** → **Account settings**
4. Find the "Link to Firebase" section
5. Click **Link to Firebase**
6. Select the Firebase project you just created ("FocusField")
7. Click **Link**
8. Confirm the linking

**OR** (Alternative path):

1. In Firebase Console, go to your project
2. Click **Project settings** (gear icon)
3. Go to **Integrations** tab
4. Find **Google AdMob** card
5. Click **Link**
6. Select your AdMob account
7. Click **Link AdMob**

---

## Step 7: Verify Setup

### Test iOS Build
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter build ios --debug
```

### Test Android Build
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### Verify Firebase Initialization
Run the app and check logs for:
- iOS: `[Firebase/Core] Configured Firebase with GoogleService-Info.plist`
- Android: `FirebaseApp initialization successful`

---

## Step 8: Update iOS CocoaPods

Since we added Firebase, we need to update iOS dependencies:

```bash
cd ios
pod install
cd ..
```

This will install:
- FirebaseCore
- FirebaseAnalytics
- FirebaseInstallations
- GoogleAppMeasurement
- GoogleUtilities

---

## Troubleshooting

### Issue: "GoogleService-Info.plist not found"
- Ensure file is in `ios/Runner/` directory
- Verify file is added to Xcode project with Runner target checked

### Issue: "google-services.json not found"
- Ensure file is in `android/app/` directory
- Check that `apply plugin: 'com.google.gms.google-services'` is at the bottom of `android/app/build.gradle`

### Issue: Firebase initialization fails
- Check that `Firebase.initializeApp()` is called before `runApp()`
- Verify `WidgetsFlutterBinding.ensureInitialized()` is called first
- Check bundle ID / package name matches exactly in Firebase Console

### Issue: AdMob ads not showing after Firebase setup
- Wait 24 hours for Firebase-AdMob link to fully propagate
- Verify Google Analytics is enabled in Firebase project
- Check AdMob account is properly linked in Firebase Console

---

## Important Notes

1. **Bundle ID / Package Name**: Must match exactly
   - iOS: `io.sparkvibe.focusfield`
   - Android: `io.sparkvibe.focusfield`

2. **Firebase Configuration Files**:
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - Android: `android/app/google-services.json`
   - **DO NOT commit these to public repositories** (add to .gitignore if repo is public)

3. **AdMob-Firebase Link Propagation**: Can take up to 24 hours for full integration

4. **Analytics**: Firebase Analytics will automatically track app events and user behavior

5. **Crashlytics**: Consider enabling Firebase Crashlytics for crash reporting (optional)

---

## Next Steps After Setup

1. Test app on both iOS and Android devices
2. Verify ads are displaying correctly
3. Check Firebase Analytics dashboard for event tracking
4. Monitor AdMob revenue in AdMob Console
5. Set up Firebase Performance Monitoring (optional)
6. Configure Firebase Cloud Messaging for push notifications (optional, future feature)

---

## Resources

- [Firebase Console](https://console.firebase.google.com/)
- [AdMob Console](https://apps.admob.com/)
- [Firebase + AdMob Documentation](https://support.google.com/admob/answer/6383165)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
