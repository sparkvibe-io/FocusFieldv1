# Android Setup Guide for SilenceScore

## Overview
# Android Platform Setup

Relocated from `android/ANDROID_SETUP.md` per documentation standards.

## Overview
Steps to configure, build, and release the Android version of SilenceScore.

## Prerequisites
- Android Studio (latest)
- Java 17 toolchain
- Play Console access
- RevenueCat API key

## Configuration
1. Package name: `io.sparkvibe.silencescore` (validate in `android/app/build.gradle`).
2. Microphone permission already declared (`RECORD_AUDIO`).
3. Add release keystore:
     - Place `keystore.jks` outside repo.
     - Reference in `key.properties` (gitignored):
```properties
storePassword=...
keyPassword=...
keyAlias=release
storeFile=/absolute/path/keystore.jks
```
4. Ensure `minSdkVersion` matches noise package requirements.

## Debug Run
```bash
flutter run -d android --dart-define=REVENUECAT_API_KEY=YOUR_KEY
```

## Release Build
```bash
flutter build appbundle --release \
    --dart-define=REVENUECAT_API_KEY=YOUR_KEY \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
```

## Internal Testing
1. Upload AAB to Internal Track.
2. Add tester emails.
3. Accept opt-in link & install.

## Troubleshooting
| Issue | Cause | Fix |
|-------|-------|-----|
| Build fails on API level | minSdk mismatch | Update `compileSdkVersion` & dependencies |
| Microphone not working | Permission denied | App settings > Permissions > Microphone |
| Play upload warning | Missing privacy data | Complete Data Safety form |

## Next
- Validate sandbox subscription purchases.
- Optimize startup time (deferred heavy init).

## Last Updated
August 30, 2025

## Current Configuration
- **Package Name**: `io.sparkvibe.silencescore`
- **Target SDK**: API 35 (Android 14)
- **Minimum SDK**: API 21 (Android 5.0)
- **Compile SDK**: API 35

## Development Environment Setup

### Prerequisites
1. **Android Studio**: Install the latest stable version
2. **Java Development Kit**: JDK 17 or higher (recommended: JDK 21)
3. **Android SDK**: Install via Android Studio SDK Manager
4. **Flutter**: Ensure Flutter is properly installed and configured

### Required Android SDK Components
Install these through Android Studio > SDK Manager:
- Android SDK Platform 35 (Android 14)
- Android SDK Build-Tools 35.0.0
- Android SDK Platform-Tools
- Android SDK Command-line Tools

### Environment Variables
Add these to your shell profile (.bashrc, .zshrc, etc.):
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## App Configuration

### Permissions
The app requires the following permission (already configured in AndroidManifest.xml):
- `RECORD_AUDIO`: Required for measuring sound levels (no audio is stored)

### Application ID
- Current: `io.sparkvibe.silencescore`
- Location: `android/app/build.gradle` and `android/app/build.gradle.kts`

### Version Management
Update versions in `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    versionCode = flutterVersionCode.toInt()
    versionName = flutterVersionName
}
```

## Building the App

### Debug Build
```bash
# From project root
flutter build apk --debug
# or
flutter run
```

### Release Build
```bash
# From project root
flutter build apk --release
# or for App Bundle (recommended for Play Store)
flutter build appbundle --release
```

## App Signing for Release

### 1. Generate Signing Key
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Create key.properties
Create `android/key.properties`:
```properties
storePassword=<your_store_password>
keyPassword=<your_key_password>
keyAlias=upload
storeFile=<path_to_upload_keystore.jks>
```

### 3. Update build.gradle
Add to `android/app/build.gradle.kts`:
```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## Google Play Store Preparation

### 1. App Requirements
- **Target API Level**: Must target API 35 (Android 14) or higher ✅
- **64-bit Support**: Automatically handled by Flutter ✅
- **App Bundle Format**: Use `flutter build appbundle` ✅

### 2. Privacy and Permissions
- **Data Collection**: The app measures sound levels locally, no audio recording or data transmission
- **Permissions Declaration**: Only RECORD_AUDIO permission is required
- **Privacy Policy**: Required if collecting any user data (recommended even for local-only apps)

### 3. App Content
- **App Icon**: Located in `android/app/src/main/res/mipmap-*/`
- **App Name**: Defined in `android/app/src/main/AndroidManifest.xml`
- **Version**: Managed through `pubspec.yaml`

### 4. Play Console Setup
1. Create a Google Play Developer account
2. Create a new app in Play Console
3. Upload signed App Bundle (.aab file)
4. Complete store listing:
   - App description
   - Screenshots (phone, tablet, TV if applicable)
   - App icon and feature graphic
   - Privacy policy URL (if applicable)
   - Content rating questionnaire

### 5. Release Tracks
- **Internal Testing**: For team testing
- **Closed Testing**: For limited external testing
- **Open Testing**: For public beta
- **Production**: For public release

## Security Considerations

### ProGuard/R8 (Code Obfuscation)
Add to `android/app/build.gradle.kts`:
```kotlin
buildTypes {
    release {
        isMinifyEnabled = true
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
}
```

Create `android/app/proguard-rules.pro`:
```proguard
# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
```

### Network Security
Since the app doesn't use network communication, no additional network security configuration is needed.

## Testing

### Unit Tests
```bash
flutter test
```

### Android-specific Tests
```bash
cd android
./gradlew test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Common Issues and Solutions

### 1. Build Errors
- **Gradle Issues**: Run `cd android && ./gradlew clean`
- **SDK Issues**: Ensure all required SDK components are installed
- **Dependency Conflicts**: Check `flutter doctor` for issues

### 2. Signing Issues
- Verify key.properties file path and credentials
- Ensure keystore file exists and is accessible
- Check alias name matches the one used during key generation

### 3. Play Store Rejection
- Ensure target SDK is current (API 35+)
- Verify all required permissions are justified
- Complete privacy and content declarations

## Build Commands Summary

```bash
# Development
flutter run                          # Run in debug mode
flutter build apk --debug           # Debug APK

# Release
flutter build apk --release         # Release APK
flutter build appbundle --release   # Release App Bundle (for Play Store)

# Cleaning
flutter clean                       # Clean Flutter build
cd android && ./gradlew clean       # Clean Android build
```

## File Locations
- **Main Activity**: `android/app/src/main/kotlin/com/sparkvibe/silencescore/MainActivity.kt`
- **Manifest**: `android/app/src/main/AndroidManifest.xml`
- **Build Config**: `android/app/build.gradle.kts`
- **App Icons**: `android/app/src/main/res/mipmap-*/`
- **Strings**: `android/app/src/main/res/values/strings.xml`

## Next Steps for Production
1. ✅ Update package name to `io.sparkvibe.silencescore`
2. ✅ Configure proper permissions
3. ⏳ Set up app signing
4. ⏳ Create app icons for all densities
5. ⏳ Write privacy policy
6. ⏳ Prepare Play Store listing
7. ⏳ Test on various Android devices
8. ⏳ Submit for Play Store review

---

**Note**: This app complies with Android privacy requirements as it only measures sound levels locally without recording or transmitting audio data.
