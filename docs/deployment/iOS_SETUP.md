# iOS Platform Setup

Relocated from `ios/iOS_SETUP.md` per documentation standards (centralize under `docs/`).

## Overview
Guide for configuring and building the iOS version of Focus Field.

## Prerequisites
- Xcode (latest stable)
- Apple Developer Account
- CocoaPods installed (`sudo gem install cocoapods`)
- RevenueCat API key (configured via `--dart-define`)

## Configuration Steps
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set the Bundle Identifier: `io.sparkvibe.focusfield`.
3. Ensure signing team is selected (Automatically manage signing ON).
4. Verify `Info.plist` contains:
	- `NSMicrophoneUsageDescription` with clear rationale.
5. Run `pod install` inside `ios/` if dependencies change.

## Debug Run
```bash
flutter run -d ios --dart-define=REVENUECAT_API_KEY=YOUR_KEY
```

## Archive & TestFlight
1. From Xcode: Product > Archive.
2. Validate and upload build.
3. Configure TestFlight testers & internal group.

## Troubleshooting
| Issue | Cause | Fix |
|-------|-------|-----|
| Microphone denied | User rejected | Settings > Privacy > Microphone |
| Pod install fails | Outdated repo | `pod repo update && pod install` |
| Build fails M1 | Ruby/ffi mismatch | `gem install ffi` then pod install |

## Next
- Add screenshots & App Store metadata.
- Validate sandbox subscription purchases.

## Last Updated
August 30, 2025
# iOS Team Configuration
# Copy this file to ios/Runner.xcodeproj/project.xcassets/ and configure your team

# Instructions for setting up iOS development team:
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Select Runner project in the navigator
# 3. Select Runner target under TARGETS
# 4. Go to "Signing & Capabilities" tab
# 5. Check "Automatically manage signing"
# 6. Select your development team from the dropdown
# 7. Choose appropriate bundle identifier (e.g., io.sparkvibe.focusfield)

# For App Store distribution:
# - Ensure you have a valid Apple Developer account
# - Create an App Store Connect record for your app
# - Configure appropriate provisioning profiles
# - Set up App Store Connect metadata and screenshots

# Required permissions for App Store submission:
# - NSMicrophoneUsageDescription (already configured in Info.plist)
# - ITSAppUsesNonExemptEncryption set to false (already configured)

# Build configurations:
# - Debug: For development and testing
# - Release: For App Store submission
# - Profile: For performance profiling

# Minimum iOS version: 13.0
# Supported device families: iPhone and iPad (Universal)
