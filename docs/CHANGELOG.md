# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.5] - 2025-01-27 - Settings Layout Optimization

### 🎨 Enhanced - Settings UI Layout
- **IMPROVED**: Optimized Basic tab layout for better space efficiency
- **IMPROVED**: Moved decibel threshold value to title with parentheses format: "Decibel Threshold (60dB)"
- **IMPROVED**: Moved duration value to title with parentheses format: "Duration (1min)"
- **IMPROVED**: Removed redundant value displays below sliders to save vertical space
- **IMPROVED**: Enhanced accessibility for large text mode with more compact layout

### 🧪 Technical Improvements
- **IMPROVED**: Updated widget tests to handle new text format with `textContaining`
- **IMPROVED**: Maintained all existing functionality while reducing UI footprint
- **IMPROVED**: Consistent parentheses style across all value displays

## [0.1.4] - 2025-01-27 - Manual-Only Tip System

### 🎯 Major - Tip System Redesign
- **BREAKING**: Disabled automatic tip triggers (app start and session completion)
- **NEW**: Tips now only show when user actively clicks the lightbulb icon
- **IMPROVED**: Enhanced user control with manual-only tip display
- **IMPROVED**: Removed session restrictions for lightbulb clicks (unlimited viewing)

### 🔧 Fixed - Button Text Consistency
- **CRITICAL**: Fixed "Mute Tips" button to dynamically show "Hide Tips" or "Show Tips"
- **CRITICAL**: Standardized terminology across settings and tip overlay
- **IMPROVED**: Updated all localization files for consistent language

### 🧪 Technical Improvements
- **IMPROVED**: Updated tests to reflect manual-only tip behavior
- **IMPROVED**: Removed unused session tracking code and methods
- **IMPROVED**: Enhanced TipService with better state management

## [0.1.3] - 2025-01-27 - Tip System Enhancement

### 💡 Enhanced - Tip Information Icon
- **IMPROVED**: Replaced information icon with intuitive lightbulb icon
- **IMPROVED**: Added subtle amber glow effect for new tips with gentle 3-second animation
- **IMPROVED**: Made glow effect theme-adaptive for both light and dark themes
- **IMPROVED**: Enhanced visual hierarchy with background glow and main icon layers

### ⏰ Fixed - Tip Timing & Behavior
- **CRITICAL**: Fixed tip timing to show same tip for 5 minutes instead of new tip on every click
- **CRITICAL**: Added proper "seen" tracking - tips only update when user has actually seen them
- **IMPROVED**: Info button now works even when tips are muted (bypasses mute status)
- **IMPROVED**: Session-based tracking prevents showing same tip twice in one session

### 🎨 Improved - User Experience
- **IMPROVED**: Lightbulb metaphor creates better user understanding ("lightbulb moment")
- **IMPROVED**: Gentle pulsing animation draws attention without being distracting
- **IMPROVED**: Amber color scheme provides warm, encouraging visual feedback
- **IMPROVED**: Accessibility-friendly animation with proper disposal patterns

### 🔧 Technical Improvements
- **IMPROVED**: Added proper tip state management with current tip tracking
- **IMPROVED**: Enhanced animation controller with 3-second duration for smoother effect
- **IMPROVED**: Added theme-adaptive color scheme for glow effect
- **IMPROVED**: Optimized animation performance with proper cleanup

## [0.1.4] - 2025-01-27 - Manual-Only Tip System

### 🚫 Disabled - Automatic Tip Triggers
- **CRITICAL**: Disabled automatic tip display on app start and after sessions
- **CRITICAL**: Tips now only appear when user actively clicks the lightbulb icon
- **IMPROVED**: Eliminated unwanted interruptions during user workflow

### 🎯 Enhanced - User Control
- **IMPROVED**: Users have complete control over when tips are displayed
- **IMPROVED**: Lightbulb glow provides clear visual indication of available tips
- **IMPROVED**: No more unexpected popups during important tasks
- **IMPROVED**: More intentional and respectful user experience

### 🔧 Technical Improvements
- **IMPROVED**: Added session state tracking to prevent multiple tips per session
- **IMPROVED**: Simplified tip service logic by removing automatic triggers
- **IMPROVED**: Enhanced test coverage for manual-only tip behavior
- **IMPROVED**: Better separation between automatic and manual tip display

## [0.1.1] - 2025-01-27 - Critical Stability Release

### 🛡️ Fixed - Critical Crash Issues
- **CRITICAL**: Fixed app crashes during startup due to chart initialization errors
- **CRITICAL**: Resolved memory leaks in RealTimeNoiseChart widget causing performance degradation
- **CRITICAL**: Fixed concurrent stream conflicts in SilenceDetector audio processing
- **CRITICAL**: Added comprehensive NaN/infinite value validation preventing chart crashes
- **MAJOR**: Fixed permission handling race conditions during app initialization
- **MAJOR**: Resolved resource disposal issues causing audio access conflicts
- **MAJOR**: Fixed timer disposal memory leaks in chart widget

### ⚡ Added - Stability Infrastructure
- **ErrorBoundary**: Added error boundary widgets for graceful error handling
- **SafeWidget**: Created safe wrapper for potentially error-prone components  
- **State Management**: Added proper disposal patterns and cleanup methods
- **Data Validation**: Comprehensive input validation for all numeric values
- **Timeout Handling**: Added timeouts for microphone access and permission requests
- **Better Logging**: Improved debug logging with proper kReleaseMode checks
- **Resource Tracking**: Added disposal state tracking to prevent resource leaks

### 🎯 Improved - Performance & UX
- **Chart Performance**: Reduced update frequency from 200ms to 2s for ambient monitoring
- **Memory Management**: Automatic cleanup of old data points (limited to 300 max)
- **Audio Processing**: Better concurrent operation handling and resource management
- **Permission Flow**: More user-friendly permission dialogs and guidance
- **Error Recovery**: Components can recover from temporary failures automatically
- **App Initialization**: Improved startup sequence with proper error handling and timeouts

### 🔧 Changed - Technical Improvements
- **Stream Disposal**: Improved stream subscription cleanup and cancellation patterns
- **Permission Dialogs**: Made dialogs dismissible and less intrusive for better UX
- **Data Limits**: Limited chart data points to prevent memory overflow issues
- **Debug Output**: Wrapped all debug prints with kReleaseMode checks for production
- **Validation**: Added bounds checking for all time and decibel calculations
- **State Flags**: Added proper state management flags to prevent concurrent operations

### 🛡️ Added - Native Audio Crash Protection
- **AudioSafeWidget**: Specialized error boundary for native audio buffer crashes
- **Audio Error Detection**: Automatic detection of audio-related native errors
- **Recovery Mechanisms**: Exponential backoff recovery with automatic retry
- **Error Tracking**: Audio error counting and crash protection activation
- **Resource Management**: Safe NoiseMeter creation and disposal patterns
- **Fallback Processing**: Graceful degradation when audio processing fails

### 📚 Documentation
- **Troubleshooting**: Added comprehensive troubleshooting section to README
- **Architecture**: Updated documentation with stability improvements and patterns
- **Error Handling**: Documented error boundary usage and best practices
- **Performance**: Added guidance for memory management and resource cleanup

### ⚠️ Notes
- This release focuses entirely on stability and crash prevention
- No breaking changes to existing functionality
- Significant reduction in memory usage and app crash rates
- Better user experience with graceful error handling and recovery
- All existing features remain fully functional

## [0.1.2] - 2025-01-27 - Tip Window Internationalization Fix

### 🌐 Fixed - Tip Window Localization
- **CRITICAL**: Fixed tip overlay using wrong localization key (`tipsMuted` instead of `muteTips`)
- **CRITICAL**: Added missing `muteTips` translation key to all supported languages
- **IMPROVED**: Tip window now properly displays localized "Mute Tips" button text
- **IMPROVED**: Toast message "Tips muted" now uses correct localization key

### 🌍 Added - Complete Tip System Internationalization
- **German**: "Tipps stummschalten" for mute button, "Tipps stummgeschaltet" for toast
- **Spanish**: "Silenciar consejos" for mute button, "Consejos silenciados" for toast  
- **French**: "Couper les astuces" for mute button, "Astuces muettes" for toast
- **Japanese**: "ヒントをミュート" for mute button, "ヒントをミュートしました" for toast
- **Portuguese**: "Silenciar dicas" for mute button, "Dicas silenciadas" for toast
- **Portuguese Brazil**: "Silenciar dicas" for mute button, "Dicas silenciadas" for toast

### ✅ Verified - Test Coverage
- All 32 tests passing including 7 localization tests
- Tip service tests specifically verified (3/3 passed)
- No regressions introduced by localization fixes
- Tip overlay widget maintains 89.66% test coverage

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
 - Added RealTimeNoiseController (1Hz aggregation) reducing frame skips on charts
 - Introduced ThrottledLogger for high-frequency debug output suppression
 - Implemented shared single-flight microphone permission Future + short-lived cache
 - Adjusted FeatureGate fallback logic: native paywall dismissal no longer auto-opens custom paywall
 - Refactored paywall launcher to return PaywallAttemptResult (unlocked/dismissed/notShown)
 - Removed unused legacy audio crash protection code paths; consolidated under SafeAudioExecutor

### UI - Notification Settings Redesign (2025-09-05)
- Moved Smart Daily Reminder and Weekly Progress schedule controls into tile footers to prevent overflow and improve discoverability
- Added Wrap-based layouts for footer controls to adapt to smaller screens (no more RIGHT OVERFLOW messages)
- Introduced solid surface background for the settings sheet so the header title is readable over blurred content
- Ensured close (X) icon uses onSurface color for consistent contrast
- Minor copy polish: clarified "Daily Time" and "Weekly Time" labels, kept “Use Smart” action when a fixed time is set

### CI & Tooling (2025-09-05)
- Replaced deprecated `flutter format` with `dart format --output=none --set-exit-if-changed .` in CI
- Kept localization parity and coverage checks stable; scripts remain unchanged in this change set

### Ads Initialization (Follow-up)
- Confirmed AdMob test App IDs present in AndroidManifest and iOS Info.plist to avoid SDK init crashes during development

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