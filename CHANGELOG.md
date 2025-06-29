# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-XX

### Added
- Initial release of Silence Score app
- Core silence detection functionality using noise_meter plugin for real-time audio level monitoring
- 60-second timer with visual progress ring
- Point system with +1 point per successful silence session
- Streak tracking (current and best streaks)
- Local data persistence using shared_preferences
- Material 3 UI with light/dark mode support
- Confetti animation on successful silence achievement
- Settings screen with decibel threshold adjustment (20-60 dB)
- Data reset functionality
- Microphone permission handling for iOS and Android
- Unit tests for silence detection logic
- Widget tests for main UI components
- Comprehensive error handling and user feedback
- Friendly welcome message for new users
- Responsive design for different screen sizes

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
- Supported platforms: iOS 12.0+, Android API 21+

### Dependencies
- Flutter 3.x
- hooks_riverpod: ^2.4.9
- flutter_hooks: ^0.20.3
- noise_meter: ^5.0.2
- shared_preferences: ^2.2.2
- confetti: ^0.7.0
- permission_handler: ^11.0.1 