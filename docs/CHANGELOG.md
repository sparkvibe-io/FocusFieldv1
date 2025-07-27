# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2025-01-XX

### Changed - Documentation Reorganization
- **BREAKING**: Moved `CHANGELOG.md` from root to `docs/CHANGELOG.md`
- **BREAKING**: Moved `MONETIZATION_SETUP.md` from root to `docs/MONETIZATION_SETUP.md`
- **BREAKING**: Moved `iOS_SETUP.md` from `ios/` to `docs/deployment/iOS_SETUP.md`
- **BREAKING**: Moved `ANDROID_SETUP.md` from `android/` to `docs/deployment/ANDROID_SETUP.md`
- Updated documentation standards to enforce root folder contains only `README.md`
- Updated all cross-references to reflect new file locations
- Improved project organization following industry best practices

### Added - Secure Secrets Management System
- **NEW**: Environment variable system using `--dart-define` flags
- **NEW**: `.env` file support for development (added to .gitignore)
- **NEW**: Build scripts (`scripts/build-dev.sh`, `scripts/build-prod.sh`) for secure builds
- **NEW**: API key validation and environment detection
- **NEW**: Comprehensive environment setup documentation
- **SECURITY**: RevenueCat API key now loaded from environment variables
- **SECURITY**: Production builds require API key validation

### Changed - Tier Restructuring
- **BREAKING**: Moved cloud synchronization from Premium to Premium Plus tier
- Premium tier ($1.99/month) now focuses on: extended sessions, analytics, export, themes, support
- Premium Plus tier ($3.99/month) designated as Phase 2 with: cloud sync, AI insights, multi-environments, social features
- Updated all documentation to reflect Phase 1 (Premium only) vs Phase 2 (Premium Plus) approach
- Revised revenue projections to focus on Premium tier for initial launch

### Technical Changes
- Updated `SubscriptionTier.hasCloudSync` to require Premium Plus
- Updated feature descriptions in paywall and feature gate widgets
- Updated app constants to reflect new tier structure

## [v0.1.0] - 2025-01-XX - Initial Development

### Added
- ✅ **Enhanced Progress Ring**: Always-visible interactive control with real-time countdown
- ✅ **Real-Time Noise Chart**: Live visualization with smoothing algorithms
- ✅ **Advanced Theme System**: System/Light/Dark modes with quick switching
- ✅ **Tabbed Settings**: Organized interface with Basic, Advanced, and About sections
- ✅ **Performance Optimization**: Reduced blinking and improved battery efficiency
- ✅ **Compact UI Design**: Single-screen layout with optimized spacing
- ✅ **Subscription Infrastructure**: Complete monetization system with RevenueCat integration
- ✅ **Feature Gating**: Premium feature access control system
- ✅ **Mock Payment System**: Testing infrastructure for subscription flows

### Technical Features
- Riverpod state management with hooks_riverpod
- Custom progress ring widget with countdown display
- Score card widget with statistics display
- Settings bottom sheet with slider controls
- Permission handling with graceful denial support
- JSON serialization for data persistence
- Modular architecture with clear separation of concerns
- Comprehensive constants file for easy i18n and A/B testing
- Production-ready configuration for iOS and Android
- Real-time audio level monitoring using noise_meter package

### Configuration
- Default decibel threshold: 38 dB
- Silence duration: 60 seconds
- Sample interval: 200ms
- Points per success: 1
- Supported platforms: iOS 13.0+, Android API 21+

### Dependencies
- Flutter 3.x
- hooks_riverpod: ^2.4.9
- flutter_hooks: ^0.20.3
- noise_meter: ^5.0.2
- shared_preferences: ^2.2.2
- confetti: ^0.7.0
- permission_handler: ^11.0.1 