# Deployment Guide

## Overview

This guide covers deploying Focus Field to production app stores and distribution platforms. The deployment process varies by platform and includes build optimization, code signing, and store submission procedures.

## Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Code formatted (`flutter format`)
- [ ] Documentation updated
- [ ] Changelog updated

### Version Management
- [ ] Version bumped in `pubspec.yaml`
- [ ] Build number incremented
- [ ] Git tagged with version
- [ ] Release notes prepared

### Testing
- [ ] Tested on physical devices
- [ ] Tested on minimum OS versions
- [ ] Performance profiling completed
- [ ] Memory leak testing done
- [ ] Audio functionality verified

### Legal and Compliance
- [ ] Privacy policy updated
- [ ] Terms of service reviewed
- [ ] App store guidelines compliance checked
- [ ] Third-party license compliance verified

## Build Configuration

### Release Build Setup

#### 1. Update Version Information

**pubspec.yaml**:
```yaml
version: 1.0.0+1  # version+build_number
```

**Version Naming Convention**:
- Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
- Example: `1.2.3+15`
- Increment build number for each release
- Increment version for user-facing changes

#### 2. Optimize Build Settings

**android/app/build.gradle**:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
  applicationId "io.sparkvibe.focusfield"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }
    }
}
```

## Platform-Specific Deployment

## Android Deployment

### 1. Code Signing Setup

#### Generate Upload Key
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### Configure Gradle
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 2. Build Release APK/AAB

#### App Bundle (Recommended)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### APK (Direct Distribution)
```bash
flutter build apk --release
```

Output: `build/app/outputs/apk/release/app-release.apk`

### 3. Google Play Store Submission

#### Prerequisites
- Google Play Developer account ($25 one-time fee)
- App signed with upload key
- All required metadata prepared

#### Submission Steps
1. **Login** to [Google Play Console](https://play.google.com/console)
2. **Create App** listing
3. **Upload** app bundle
4. **Complete** store listing:
   - App description
   - Screenshots (phone, tablet, TV if applicable)
   - Feature graphic
   - App icon
   - Content rating questionnaire
   - Privacy policy link
5. **Set Pricing** and distribution
6. **Submit** for review

#### Required Assets
- **App Icon**: 512x512 PNG
- **Feature Graphic**: 1024x500 PNG
- **Screenshots**: Various sizes by device type
- **Privacy Policy**: Hosted URL required

### 4. Alternative Android Distribution

#### Direct APK Distribution
```bash
# Build optimized APK
flutter build apk --release --target-platform android-arm64

# For multiple architectures
flutter build apk --release --split-per-abi
```

#### F-Droid Preparation
- Ensure all dependencies are open source
- Remove proprietary libraries
- Follow F-Droid packaging guidelines

## iOS Deployment

### 1. Apple Developer Setup

#### Prerequisites
- Apple Developer account ($99/year)
- Xcode with latest iOS SDK
- Valid development certificates

#### Certificate Management
1. **Generate** certificates in Xcode or Developer Portal
2. **Download** provisioning profiles
3. **Configure** automatic signing in Xcode

### 2. Xcode Configuration

#### 1. Open iOS Project
```bash
open ios/Runner.xcworkspace
```

#### 2. Configure Signing
- Select your team in "Signing & Capabilities"
- Ensure "Automatically manage signing" is enabled
- Verify bundle identifier matches App Store listing

#### 3. Update Info.plist
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Focus Field needs microphone access to measure ambient noise levels for silence scoring.</string>

<key>CFBundleVersion</key>
<string>1</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### 3. Build for Release

#### Archive Build
1. **Select** "Any iOS Device" as build target
2. **Product** → **Archive** in Xcode
3. **Validate** the archive
4. **Export** for App Store distribution

#### Command Line Build
```bash
flutter build ios --release
```

### 4. App Store Connect Submission

#### Prerequisites
- App registered in App Store Connect
- Metadata and assets prepared
- TestFlight testing completed (recommended)

#### Submission Process
1. **Upload** using Xcode Organizer or Transporter
2. **Complete** App Store listing:
   - App description and keywords
   - Screenshots for all device sizes
   - App preview videos (optional)
   - Age rating information
   - Privacy details
3. **Submit** for App Review
4. **Respond** to any feedback from Apple

#### Required Assets
- **App Icon**: 1024x1024 PNG (no transparency)
- **Screenshots**: Device-specific sizes
- **App Preview**: Optional video demos

## macOS Deployment

### 1. macOS App Store

#### Code Signing
```bash
# Build for Mac App Store
flutter build macos --release
```

#### Notarization
- Required for distribution outside Mac App Store
- Uses Apple's notarization service
- Automated through Xcode or command line tools

### 2. Direct Distribution

#### Create DMG
```bash
# Build standalone app
flutter build macos --release

# Create distributable DMG
# Use create-dmg or similar tools
```

## Web Deployment

### 1. Build Web Version

```bash
# Build for web
flutter build web --release
```

Output: `build/web/`

### 2. Hosting Options

#### GitHub Pages
```bash
# Deploy to gh-pages branch
flutter build web --base-href "/FocusField/"
# Push build/web contents to gh-pages branch
```

#### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize and deploy
firebase init hosting
firebase deploy
```

#### Traditional Web Hosting
- Upload `build/web/` contents to web server
- Configure server for SPA routing
- Ensure HTTPS for microphone access

## Continuous Integration/Continuous Deployment

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Stores

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
          
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Run tests
        run: flutter test
        
      - name: Build APK
        run: flutter build apk --release
        
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: io.sparkvibe.focusfield
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Build iOS
        run: flutter build ios --release --no-codesign
        
      - name: Archive and Upload
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/iphoneos/Runner.app
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

### Environment Secrets

Configure in repository settings:
- `SERVICE_ACCOUNT_JSON`: Google Play upload credentials
- `APPSTORE_ISSUER_ID`: App Store Connect API issuer ID
- `APPSTORE_API_KEY_ID`: App Store Connect API key ID
- `APPSTORE_API_PRIVATE_KEY`: App Store Connect API private key

## Post-Deployment

### Monitoring

#### App Store Performance
- Download and usage statistics
- User reviews and ratings
- Crash reports and analytics

#### Error Tracking
- Integrate with services like Sentry or Crashlytics
- Monitor performance metrics
- Track user engagement

### Updates and Maintenance

#### Release Schedule
- Regular security updates
- Feature releases based on user feedback
- Bug fixes as needed

#### Versioning Strategy
- Semantic versioning for all releases
- Clear changelog for each version
- Backward compatibility considerations

## Troubleshooting

### Common Build Issues

#### Android
```bash
# Clean build artifacts
flutter clean
cd android && ./gradlew clean
cd .. && flutter pub get

# Update dependencies
flutter pub upgrade
```

#### iOS
```bash
# Clean Xcode build
cd ios
rm -rf Pods/
rm Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### Store Rejection Issues

#### Common Android Rejections
- Missing privacy policy
- Inadequate permission explanations
- Targeting policy violations
- Content policy violations

#### Common iOS Rejections
- Missing usage descriptions
- Incomplete metadata
- Design guideline violations
- Performance issues

### Support Resources

- [Flutter Deployment Documentation](https://flutter.dev/docs/deployment)
- [Google Play Developer Policies](https://play.google.com/about/developer-content-policy/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Flutter Community Discord](https://discord.gg/flutter)

---

**Last Updated**: July 25, 2025  
**Version**: 1.0.0
