# Development Setup Guide

## Prerequisites

### Required Tools
- **Flutter SDK**: 3.24.0 or higher
- **Dart SDK**: 3.5.0 or higher (included with Flutter)
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Platform Tools**:
  - **Android**: Android Studio with SDK 21+ (Android 5.0+)
  - **iOS**: Xcode 15.0+ (iOS 13.0+)
  - **macOS**: Xcode command line tools

### Environment Setup

#### Install Flutter
```bash
# macOS (using Homebrew)
brew install flutter

# Or download from https://flutter.dev/docs/get-started/install
```

#### Verify Installation
```bash
flutter doctor
```

Ensure all checkmarks are green for your target platforms.

## Project Setup

### Clone Repository
```bash
git clone https://github.com/sparkvibe-io/FocusField.git
cd FocusField
```

### Install Dependencies
```bash
flutter pub get
```

### Configure Development Environment

#### VS Code Extensions (Recommended)
- Flutter
- Dart
- GitLens
- Error Lens
- Material Icon Theme

#### Android Studio Plugins
- Flutter
- Dart

## Running the Application

### Debug Mode
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot
```

### Platform-Specific Commands

#### Android
```bash
# Run on Android device/emulator
flutter run -d android

# Build APK for testing
flutter build apk --debug
```

#### iOS
```bash
# Run on iOS device/simulator
flutter run -d ios

# Build for iOS device
flutter build ios --debug
```

## Development Workflow

### Code Quality

#### Formatting
```bash
# Format all Dart files
flutter format .

# Format specific file
flutter format lib/main.dart
```

#### Analysis
```bash
# Run static analysis
flutter analyze

# Fix common issues automatically
dart fix --apply
```

#### Linting
The project uses `flutter_lints`. Configuration is in `analysis_options.yaml`.

### Testing

#### Run All Tests
```bash
flutter test
```

#### Run Specific Tests
```bash
# Unit tests
flutter test test/silence_detector_test.dart

# Widget tests
flutter test test/widget_test.dart
```

#### Generate Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Hot Reload vs Hot Restart

#### Hot Reload (`r`)
- Preserves app state
- Fast iteration for UI changes
- Use for most development

#### Hot Restart (`R`)
- Resets app state
- Use when changing app initialization
- Use when adding new dependencies

## Project Structure

### Key Directories
```
lib/
├── constants/          # App constants and configuration
│   └── app_constants.dart
├── models/            # Data models
│   └── silence_data.dart
├── providers/         # Riverpod state management
│   ├── silence_provider.dart
│   └── theme_provider.dart
├── screens/           # UI screens
│   ├── home_page.dart
│   └── settings_sheet.dart
├── services/          # Business logic
│   ├── silence_detector.dart
│   └── storage_service.dart
├── theme/             # App theming
│   └── app_theme.dart
├── widgets/           # Reusable components
│   ├── progress_ring.dart
│   ├── real_time_noise_chart.dart
│   └── score_card.dart
└── main.dart          # App entry point
```

### Configuration Files
- `pubspec.yaml` - Dependencies and assets
- `analysis_options.yaml` - Linting rules
- `android/app/build.gradle` - Android configuration
- `ios/Runner/Info.plist` - iOS configuration

## Development Best Practices

### Code Organization
- Follow Dart naming conventions
- Use meaningful variable and function names
- Group related functionality in separate files
- Maintain consistent indentation (2 spaces)

### State Management
- Use Riverpod for all state management
- Prefer immutable state objects
- Handle async operations properly
- Use appropriate provider types

### Widget Development
- Prefer stateless widgets with Riverpod
- Extract complex widgets into separate files
- Use const constructors when possible
- Implement proper dispose methods

### Performance
- Avoid rebuilding expensive widgets
- Use const widgets where possible
- Profile performance regularly
- Optimize audio processing loops

## Debugging

### Flutter Inspector
```bash
# Run with inspector
flutter run --debug
```

Then use the Flutter Inspector in your IDE.

### Debug Console
```dart
// Add debug prints
debugPrint('Debug message');

// Use logging
import 'dart:developer' as developer;
developer.log('Log message');
```

### Platform-Specific Debugging

#### Android
- Use Android Studio's debugger
- Check ADB logs: `adb logcat`
- Use Android emulator extended controls

#### iOS
- Use Xcode debugger
- Check iOS simulator logs
- Use iOS simulator device logs

## Common Issues

### Permission Issues
```bash
# Android: Check permissions in AndroidManifest.xml
# iOS: Check Info.plist for NSMicrophoneUsageDescription
```

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get

# Reset dependencies
rm -rf .packages
rm pubspec.lock
flutter pub get
```

### Audio Issues
- Ensure device has microphone
- Check permission grants
- Test on physical device (not just simulator)

## Continuous Integration

### GitHub Actions
Configuration in `.github/workflows/`:
- Code analysis and formatting checks
- Unit and widget tests
- Build verification for multiple platforms

### Local Pre-commit Checks
```bash
# Run before committing
flutter analyze
flutter test
flutter format --dry-run --set-exit-if-changed .
```

## Release Preparation

### Version Management
Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

### Build for Release
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

**Last Updated**: July 25, 2025  
**Version**: 1.0.0
