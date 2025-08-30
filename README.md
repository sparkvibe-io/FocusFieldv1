# Silence Score

A sophisticated Flutter app that measures silence, tracks progress, and provides detailed analytics for mindfulness and focus sessions. Features real-time noise monitoring, comprehensive statistics, achievement system, calibration, and advanced customization options.

## 🌟 Features

### Core Functionality
- **Real-Time Silence Detection**: Ambient noise monitoring using device microphone
- **Interactive Session Progress Ring**: Large countdown control with MM:SS timer
- **Real-Time Noise Chart**: Live decibel visualization with threshold indicators & smoothing (1Hz aggregated controller)
- **Smart Point System**: Earn 1 point per minute of successful quiet time
- **Streak Analytics**: Track daily streaks, best performances, and session history
- **Noise Floor Calibration**: Quick ambient baseline measurement (clamped 20–80 dB)
- **Achievement System**: Visual feedback with confetti celebrations

### Advanced Analytics
- **Weekly Trends & Moving Average**: Recent performance insight
- **Session History Graph**: Visual representation of quiet progress
- **Compact Statistics Display**: Points, streaks, sessions
- **Performance Metrics**: Success rates & averages

### Customization & Settings
- **Tabbed Settings Interface**: Basic, Advanced, About
- **Adjustable Decibel Threshold**: 20–80 dB (default 38) with high-threshold warning ≥70 dB
- **Session Duration**: Free up to 5 minutes; Premium up to 120 minutes
- **Calibration Dialog**: Previous vs new threshold, ambient warnings
- **Theme System**: System / Light / Dark
- **Accessibility Settings**: High contrast, large text, vibration feedback

### User Experience
- **Progress Ring Control**: Start/stop & visual completion
- **Smooth Visual Updates**: Smoothing filters + aggregated controller reduce jitter & frame drops
- **Confetti Celebrations**: Successful session reward
- **Permission Guidance**: Microphone access onboarding
- **Compact Layout**: Key controls on one screen

### Data & Privacy
- **Local Storage Only**: No audio recorded or transmitted
- **Data Export (Premium)**: CSV & PDF reports
- **Reset Option**: Wipes all local settings & history

> Note: Cloud backup / sync is not yet available (local-only). See the "Planned / Not Yet Implemented" section below.

## 📱 Screenshots

*[Screenshots will be added here]*

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart 3.x or higher
- iOS 15.0+ (raised due to Firebase/Firestore & RevenueCat SDK requirements) or Android API level 21+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/silence-score.git
cd silence-score
```

2. Install dependencies:
```bash
flutter pub get
```

3. **Configure Environment** (Important):
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your actual API keys
# Get RevenueCat API key from: https://app.revenuecat.com/projects
vim .env
```

4. Run the app:
```bash
# Development build (with mock subscriptions)
./scripts/build-dev.sh

# Or run directly with Flutter
flutter run --dart-define=REVENUECAT_API_KEY=your_key_here
```

### Environment Configuration

The app uses environment variables for secure API key management:

- **Development**: Uses `.env` file and mock subscriptions by default
- **Production**: Requires actual API keys and disables mocks

**Environment Variables:**
- `REVENUECAT_API_KEY`: RevenueCat subscription management
- `FIREBASE_API_KEY`: Firebase services (optional)
- `IS_DEVELOPMENT`: Enable/disable development mode
- `ENABLE_MOCK_SUBSCRIPTIONS`: Use mock payments for testing

### Building for Production

#### Android
```bash
# Using the secure build script (recommended)
export REVENUECAT_API_KEY="your_actual_api_key"
./scripts/build-prod.sh

# Or manually with dart-define
flutter build apk --release --dart-define=REVENUECAT_API_KEY=your_key
flutter build appbundle --release --dart-define=REVENUECAT_API_KEY=your_key
```

#### iOS
```bash
# Set environment variables
export REVENUECAT_API_KEY="your_actual_api_key"

# Build for iOS
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
  --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
```

#### Development Builds
```bash
# Quick development build with environment file
./scripts/build-dev.sh

# Or run in debug mode
flutter run
```

## 🔐 Permissions

The app requires microphone access to measure ambient noise levels:

- **iOS**: Added `NSMicrophoneUsageDescription` in Info.plist
- **Android**: Added `RECORD_AUDIO` permission in AndroidManifest.xml

**Privacy Note**: No audio is recorded or stored - the app only measures decibel levels in real-time for silence detection. A shared cached permission Future prevents duplicate OS dialogs.

## 🔔 Notification System

SilenceScore includes a flexible, privacy‑friendly local notification system designed to reinforce habit formation without being spammy.

### Architecture
| Component | Responsibility |
|-----------|----------------|
| `NotificationService` | Core API: smart reminder logic, scheduling (daily / weekly), achievement & session notifications |
| `NotificationPermissionHandler` | Isolated permission checks & requests (Android 13+ POST_NOTIFICATIONS, iOS alert/badge/sound) |
| `notification_settings_widget.dart` | User interface for enabling features & picking schedule overrides |
| SharedPreferences (StorageService) | Persists user scheduling overrides (daily time, weekly weekday/time) & last reminder sent date |

### Features
1. Smart Daily Reminders
  - Learns your preferred practice window from recent session start times (keeps last 30) and triggers within ±30 minutes of the most common time.
  - Optional explicit time override: user can pick a fixed daily reminder time; reverting to Smart re-enables adaptive behavior.
2. Weekly Progress Summary (Premium)
  - User‑selectable weekday + time (default Monday @ 09:00) summarizing weekly engagement.
3. Session Completion Notifications
  - Instant feedback when a session finishes (success vs incomplete messaging).
4. Achievement Notifications
  - Milestone unlock messages (first session, streaks, perfect/long sessions, etc.).
5. Adaptive Messaging
  - Reminder & streak copy adjusts to current streak length and total session count.
6. Testability
  - Injected `NowProvider` enables deterministic unit tests; separate permission handler allows logic testing without platform channels.

### Scheduling Behavior
Daily: Uses user override (if set) else computed optimal hour/minute; scheduled with `matchDateTimeComponents: time` so it repeats daily.  
Weekly: Uses stored weekday & time with `matchDateTimeComponents: dayOfWeekAndTime`.  
Both rely on the `timezone` package; zones initialized on service init (skipped in tests).

### Persistence Keys
`dailyReminderHour`, `dailyReminderMinute`, `weeklySummaryWeekday`, `weeklySummaryHour`, `weeklySummaryMinute`, and `last_reminder` (for per‑day guard).

### User Flow
1. User opens Notification Settings sheet; if permission missing, a banner prompts enablement.  
2. Toggling Daily Reminders or Weekly Summary triggers (re) scheduling immediately.  
3. Selecting a time or weekday updates SharedPreferences and reschedules.  
4. Choosing "Use Smart" clears daily fixed time keys and reverts to adaptive reminder scheduling.

### Future Enhancements (Not Yet Implemented)
- Dynamic weekly summary body generation at fire time (currently placeholder text).  
- Advanced analytics injection for richer weekly insights.  
- Quiet hours / do-not-disturb awareness.  
- A/B messaging variants & localization coverage expansion.

### Testing
Unit tests cover smart reminder eligibility (`shouldSendDailyReminder`) with injected clock and controlled session history. Additional scheduling tests verify that enabling features with overrides places correct schedule parameters (see `test/notification_service_test.dart`).


## 🏗️ Architecture

### State Management
- **Riverpod**: Modern state management with hooks_riverpod
- **Provider Pattern**: Clean separation of concerns with dedicated providers
- **Async State Handling**: Robust error handling and loading states

### Core Services
- **Silence Detection**: Advanced noise_meter integration with ambient monitoring & circuit breaker safeguards
- **Data Persistence**: Shared preferences with JSON serialization
- **Permission Handling**: Shared-single-flight permission request + caching with fallback strategies

### UI Components
- **Material 3**: Latest Material Design with dynamic color support
- **Custom Widgets**: Progress rings, charts, score cards, and session displays
- **Responsive Layout**: Adaptive design for various screen sizes
- **Animation System**: Smooth transitions and celebratory animations

### Testing
- **Unit Tests**: Comprehensive silence detection logic testing
- **Widget Tests**: UI component validation
- **Integration Testing**: End-to-end user flow validation

## ⚙️ Configuration

### Default Settings
- **Decibel Threshold**: 38 dB (adjustable 20–80)
- **Session Duration (Free Default)**: 5 minutes (Premium configurable 1–120 minutes)
- **Sample Interval**: 200ms (system constant)
- **Points System**: 1 point per quiet minute
- **Chart Smoothing**: Exponential moving average
- **Theme**: System default

### Advanced Configuration
- **Calibration**: Ambient baseline sets initial threshold
- **High Threshold Warning**: Shown at ≥70 dB to discourage overly permissive settings
- **Export Formats**: CSV raw data, PDF formatted report (Premium)
- **Accessibility**: High contrast mode & scalable text

## 🛠️ Development
### Internationalization (i18n)

The app uses Flutter `gen-l10n` with multiple fully integrated locales.

Supported locales: `en`, `es`, `fr`, `de`, `pt`, `pt_BR`, `ja`.

#### Notification & Dynamic Message Localization
All notification strings (settings UI, reminders, achievements, weekly summaries, streak copy) are fully localized across supported locales.

Dynamic strings with placeholders use explicit metadata blocks in each non‑English ARB (e.g. `@reminderStreakShort`, `@weeklyProgressFew`) to ensure typed method generation (`int streak`, `int count`). This avoids accidental `Object` parameter generation and keeps runtime type safety.

Streak tiers implemented:
- `reminderStreakShort` – early streak encouragement
- `reminderStreakMedium` – mid milestone motivation
- `reminderStreakLong` – long streak celebration

Weekly progress variants:
- `weeklyProgressFew`
- `weeklyProgressSome`
- `weeklyProgressPerfect`

Fixed two‑day copy (`reminderDayTwo`) intentionally kept static (no placeholder) to remove unnecessary function signatures.

#### Adding / Updating Translations
1. Add or edit keys in `app_en.arb` (source of truth). Include `@key` metadata for any placeholder variables.
2. Copy the new key to every other `app_<locale>.arb` with either a real translation or temporary English placeholder.
3. If the string has placeholders, also add the matching `@key` metadata in each locale (copy from English, do not translate placeholder names).
4. Run:
  ```bash
  flutter gen-l10n
  ```
5. Run tests (includes interpolation + completeness checks):
  ```bash
  flutter test
  ```
6. Replace any temporary placeholders with real translations before release.

#### Translation Quality & Style
- Keep punctuation and emoji usage parallel to English where culturally appropriate.
- Avoid translating variable names.
- Preserve capitalization segmentation if it impacts accessibility (screen readers often break on emoji + punctuation).
- Prefer concise motivational tone for reminders; avoid overly formal phrasing.

#### Validation Tests
Added dedicated tests to guard localization integrity:
- `localization_smoke_test.dart` (English interpolation)
- `localization_de_test.dart`, `localization_es_test.dart`, `localization_pt_test.dart`, `localization_pt_br_test.dart`, `localization_ja_test.dart` (per‑locale interpolation checks)
- `localization_completeness_test.dart` ensures every locale ARB contains all keys from English (excludes metadata keys starting with `@`).

If a new locale is introduced without all keys, the completeness test will fail, preventing silent partial localization regressions.

#### Common Pitfalls Prevented
- Missing placeholder metadata → would generate `Object` parameter types (guarded by convention + tests).
- Untranslated new key in one locale → caught by completeness test.
- Placeholder name mismatch → `flutter gen-l10n` failure (resolve by copying `@key` entry exactly).

#### Future i18n Enhancements
- Automated extraction & translation pipeline (e.g. using a script to diff new keys and produce a translator handoff JSON/CSV).
- Pluralization for weekly summaries if variant granularity increases.
- Fallback locale smoke test during CI launch build.

Key files:
- `l10n/l10n.yaml` – configuration
- `lib/l10n/app_en.arb` – source of truth
- `lib/l10n/app_*.arb` – translated locale files
- Generated: `lib/l10n/app_localizations.dart` (do not edit manually)

Add a new locale:
1. Duplicate `app_en.arb` to `app_xx.arb`.
2. Translate values; preserve placeholder keys.
3. Run `flutter gen-l10n` (or just `flutter run`).
4. Ensure the new locale is included in `supportedLocales` if not auto-wired.
5. Validate UI for overflow & multi-byte glyph rendering.
6. Provide translation metadata (`@key` objects) for complex strings / achievements.

Notes:
- Placeholders must match exactly; don't translate variable names.
- Avoid hard-coded text in widgets; everything user-facing should be localized.
- Use plural formatting where counts vary (see `minutesOfSilenceCongrats`).
 - Run `flutter gen-l10n` after any ARB change; commit regenerated files.
 - Completeness & interpolation tests enforce consistency—keep them green before merging.

Translation backlog (if any) is tracked via `untranslated_messages.txt` when running `flutter gen-l10n`.


### Project Structure
```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models and serialization
├── providers/         # Riverpod state management
├── screens/           # Main UI screens and navigation
├── services/          # Business logic and external integrations
├── theme/             # App theming and design system
├── widgets/           # Reusable UI components
└── main.dart          # App entry point and initialization
```

### Key Components

#### Widgets
- `ProgressRing`: Interactive countdown control with MM:SS timer and session progress
- `RealTimeNoiseChart`: Live decibel visualization with smoothing, throttled logging & 1Hz aggregated updates
- `SessionHistoryGraph`: Historical performance tracking with visual trends
- `CompactPointsDisplay`: Streamlined statistics overview with points, streaks, and totals
- `SessionHistoryCard`: Detailed session records with achievements (legacy)
- `ScoreCard`: Comprehensive statistics display (legacy)

#### Services
- `SilenceDetector`: Core noise monitoring, permission coalescing, circuit breaker & analysis
- `StorageService`: Data persistence and management
- `PermissionHandler`: Microphone access management

#### Providers
- `SilenceDataNotifier`: Session data and statistics management
- `SilenceStateProvider`: Real-time session state and progress tracking
- `SettingsNotifier`: Configuration and preferences with tabbed interface
- `ThemeProvider`: Dynamic theme switching (System/Light/Dark modes)

### Running Tests
```bash
# Unit tests for silence detection
flutter test test/silence_detector_test.dart

# Widget tests for UI components
flutter test test/widget_test.dart

# All tests with coverage
flutter test --coverage
```

### Code Quality
The project follows Dart and Flutter best practices:
```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run linter
flutter analyze --no-fatal-infos
```

## 🎯 Advanced Features

### Calibration & Threshold Intelligence
- **Noise Floor Calibration**: ~5s ambient measure; clamps extremes
- **High Ambient Warning**: Alerts on ≥70 dB baseline
- **Manual Fine-Tuning**: Slider always available post-calibration

### Real-Time Monitoring
- **Ambient Noise Tracking**: Continuous background monitoring when not in session
- **Live Visualization**: Real-time decibel level charts with intelligent smoothing algorithms
- **Visual Noise Reduction**: Exponential moving average + aggregation prevents flicker & reduces work
- **Threshold Indicators**: Dynamic visual feedback for noise level status with color-coded responses
- **Performance Optimized**: Aggregated 1Hz stream + throttled logger drastically lowers rebuild pressure

### Interactive Controls
- **Primary Progress Ring**: Large, always-visible control serving as main session interface
- **Countdown Timer**: Real-time MM:SS display showing remaining session time
- **Visual Session State**: Clear start/stop indicators with dynamic sizing and spacing
- **One-Touch Control**: Single tap to start/stop sessions with immediate visual feedback
- **Gesture Optimization**: Entire progress ring area is touch-responsive

_Section de-duplicated; previous duplicate removed._

### User Interface
- **Tabbed Settings**: Organized interface with Basic, Advanced, and About sections
- **Theme Management**: Quick theme cycling with visual feedback (System/Light/Dark)
- **Compact Layout**: Single-screen design eliminating scroll requirements
- **Modern Controls**: Visual sliders with live value indicators and smooth animations
- **Intelligent Spacing**: Optimized component positioning for better user interaction

### Analytics & Insights
- **Performance Metrics**: Success rates, average scores, and trends
- **Session Analytics**: Detailed breakdown of each silence session
- **Progress Tracking**: Visual representation of improvement over time

### Achievement System
- **Milestone Badges**: Unlock achievements for consistent practice
- **Streak Rewards**: Special recognition for maintaining daily habits
- **Progress Celebrations**: Animated rewards for accomplishments

### Data Management
- **Export Functionality**: Download session history and statistics (Premium)
- **Backup/Restore (Planned)**: Cloud sync & cross‑device backup not yet implemented
- **Data Reset**: Clear all data with confirmation dialogs

### Accessibility
- **Screen Reader Support**: Full accessibility for visually impaired users
- **High Contrast Mode**: Enhanced visibility options
- **Large Text Support**: Scalable typography for better readability

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the existing code style
4. Add comprehensive tests for new functionality
5. Run the test suite and ensure all tests pass
6. Update documentation for any new features
7. Submit a pull request with detailed description

### Development Guidelines
- Follow Dart formatting standards
- Write comprehensive tests for new features
- Update documentation for API changes
- Ensure accessibility compliance
- Test on both iOS and Android platforms

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📋 Changelog

See [docs/CHANGELOG.md](docs/CHANGELOG.md) for detailed version history and updates.

### Recent Major Updates (v0.1.1 - Stability Release)

#### 🛡️ **Critical Stability Fixes**
- ✅ **Memory Leak Resolution**: Fixed chart widget memory leaks and resource cleanup
- ✅ **Data Validation**: Comprehensive NaN/infinite value handling prevents crashes
- ✅ **Stream Management**: Resolved concurrent stream conflicts in audio processing
- ✅ **Error Boundaries**: Added graceful error handling for critical components
- ✅ **App Initialization**: Fixed race conditions and permission flow timing
- ✅ **Resource Disposal**: Proper cleanup of audio resources and timers

#### 🎯 **Performance Improvements**
- ✅ **Chart Optimization**: Aggregated 1Hz controller + sliding window memory trimming
- ✅ **Logging Throttling**: High-frequency sensor debug output collapsed (ThrottledLogger)
- ✅ **Permission Coalescing**: Single-flight microphone permission Future prevents duplicates
- ✅ **Audio Processing**: Improved microphone access reliability and error handling
- ✅ **State Management**: Better concurrent operation handling and cleanup
- ✅ **UI Responsiveness**: Error boundaries prevent widget crashes from affecting app

#### 📱 **User Experience Enhancements**
- ✅ **Permission Handling**: More user-friendly permission requests and guidance
- ✅ **Error Recovery**: Automatic component recovery from temporary failures
- ✅ **Graceful Degradation**: App continues functioning even with component errors
- ✅ **Debug Improvements**: Better error reporting for development troubleshooting

### Previous Updates (v0.1.0)
- ✅ **Enhanced Progress Ring**: Always-visible interactive control with real-time countdown
- ✅ **Real-Time Noise Chart**: Live visualization with smoothing algorithms
- ✅ **Advanced Theme System**: System/Light/Dark modes with quick switching
- ✅ **Tabbed Settings**: Organized interface with Basic, Advanced, and About sections
- ✅ **Performance Optimization**: Reduced blinking and improved battery efficiency
- ✅ **Compact UI Design**: Single-screen layout with optimized spacing

### Development Files
**Legacy/Backup Files Created During Development:**
- `lib/screens/home_page_backup.dart` - Original home page before major redesign
- `lib/widgets/progress_ring_old.dart` - Previous progress ring implementation

*These backup files are maintained for reference and can be safely removed in production builds.*

## 🗺️ Roadmap

### Phase 1 Features (Premium Tier - $1.99/month)
- [x] Extended sessions (up to 120 minutes)
- [x] Advanced analytics & weekly trends
- [x] Data export (CSV/PDF)
- [x] Premium themes
- [x] Priority support
- [x] Calibration dialog & high-threshold warnings

### Phase 2 Features (Planned)
- [ ] Cloud synchronization & backup
- [ ] AI-powered insights
- [ ] Multi-environment profiles
- [ ] Social/community features
- [ ] Team collaboration
 - [ ] Spike / interruption detection
 - [ ] Silence quality score metric
 - [ ] Streak goal customization & reminders

### Future Enhancements
- [ ] Sound visualization with waveform display
- [ ] Multiple challenge modes (endurance, precision, etc.)
- [ ] Social sharing and leaderboards
- [ ] Advanced achievement system with unlockable content
- [ ] Background noise calibration wizard
- [ ] Integration with health apps (Apple Health, Google Fit)
- [ ] Custom notification schedules
- [ ] Multi-language support
- [ ] Advanced analytics dashboard

## 🚧 Planned / Not Yet Implemented Features

The following items are referenced in UI placeholders, roadmap checklists, or marketing copy but are NOT yet fully implemented in the current build:

- Cloud synchronization & cross‑device backup (local storage only today)
- AI Insights (label present; no AI-generated analysis yet)
- Multi-environment / profile presets (e.g., Work / Study / Sleep)
- Social or community features (sharing, leaderboards, collaboration)
- Team / group collaboration workspace
- Spike / interruption detection (noise spike event tracking)
- Silence quality score (composite metric beyond average dB)
- Advanced cloud backup / restore flows
- Streak goal customization & proactive reminders/notifications
- Health platform integrations (Apple Health, Google Fit)

Premium Paywall – Currently Delivered:
- Extended sessions (up to 120 minutes)
- 90‑day history retention
- Advanced analytics (performance metrics, trends)
- Data export (CSV / PDF)
- Premium theme pack

Everything else in the premium roadmap is aspirational until moved to the delivered list.

### Technical Improvements
- [ ] Flutter Sound integration for enhanced audio processing
- [ ] Machine learning for adaptive threshold adjustment
- [ ] Cloud backup and cross-device sync
- [ ] Performance optimizations for older devices
- [ ] Enhanced accessibility features
- [ ] Comprehensive integration testing

## 🔧 Troubleshooting

### Common Issues and Solutions

#### App Crashes on Startup
- **Cause**: Usually related to permission handling or initialization
- **Solution**: Clear app data, restart device, ensure microphone permissions are granted
- **Prevention**: v0.1.1 includes comprehensive fixes for startup crashes

#### Real-Time Chart Not Working
- **Cause**: Memory issues or invalid data processing
- **Solution**: Chart will show "temporarily unavailable" and auto-recover
- **Prevention**: v0.1.1 includes chart stability improvements and error boundaries

#### Microphone Permission Issues
- **iOS**: Settings > Privacy & Security > Microphone > Silence Score
- **Android**: Settings > Apps > Silence Score > Permissions > Microphone
- **Note**: App now provides better guidance for permission setup

#### Audio Processing Errors & Native Buffer Crashes
- **Cause**: Native audio buffer errors from underlying noise_meter package
- **Symptoms**: App crashes with "AudioReaderError" or similar native errors
- **Solution**: App now includes automatic recovery - chart shows "recovering" message
- **Prevention**: v0.1.1 includes comprehensive audio crash protection with:
  - Native error detection and graceful handling
  - Automatic component recovery with exponential backoff
  - Audio resource management and cleanup
  - Fallback UI when audio processing fails

#### Memory Usage
- **Optimized**: Chart data is now limited and cleaned up automatically
- **Background**: Ambient monitoring uses reduced frequency updates
- **Resources**: Proper disposal prevents memory leaks

### Development Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### Permission Testing
```bash
# Reset app permissions (iOS Simulator)
xcrun simctl privacy booted reset all com.sparkvibe.silencescore

# Reset app data (Android)
adb shell pm clear com.sparkvibe.silencescore
```

### Getting Help

## 🆘 Support

- **Documentation**: Check this README and [docs folder](docs/)
- **Issues**: Report bugs and feature requests via GitHub Issues
- **Troubleshooting**: See troubleshooting section above for common solutions
- **Discussions**: Join community discussions for help and ideas
- **Privacy**: Review our privacy policy for data handling details

### Reporting Issues

When reporting issues, please include:
- Device model and OS version
- Flutter version (`flutter --version`)
- Steps to reproduce
- Expected vs actual behavior
- Error messages or logs if available

---

**Silence Score** - Transform your environment into a sanctuary of focus and mindfulness. 🧘‍♀️✨ 

## 💰 Monetization & Subscription System

### Status: ⚙️ Implemented (Docs & Dynamic Pricing Update In Progress)

SilenceScore includes a RevenueCat-based subscription system with dynamic product pricing (fetched from live store offerings when available) and a mock mode for local development.

#### Core Infrastructure
- RevenueCat integration via `purchases_flutter`
- Tiered access: Free, Premium, Premium Plus (future expansion)
- Feature gating with `FeatureGate` + Riverpod providers
- Custom paywall (`PaywallWidget`) currently showing dynamic prices when offerings load; will evolve to remote-config / A/B capable layout
- Mock mode (`ENABLE_MOCK_SUBSCRIPTIONS=true`) for development without store connections

#### Product Identifiers (Current)
```
premium.tier:monthly
premium.tier:yearly
```
(Verify colon usage is accepted by both stores; if not, migrate to `premium.tier.monthly` & `premium.tier.yearly`.)

#### Pricing (Live via RevenueCat)
- Prices and localized currency are pulled dynamically from RevenueCat Paywall/Offerings.
- Legacy fallback values (1.99 / 19.99) remain in code only if offerings fail to load.

#### Key Environment Flags
- `REVENUECAT_API_KEY` (required for production builds)
- `IS_DEVELOPMENT` (default true locally)
- `ENABLE_MOCK_SUBSCRIPTIONS` (set false for real purchases)

#### Launch Readiness Checklist (Remaining)
1. Add legal links (Privacy Policy, Terms) to paywall footer
2. Confirm introductory offers / trials (if desired) configured in stores & RevenueCat
3. Turn off mock mode in production build scripts
4. QA sandbox purchases on iOS & internal testing on Android
5. Add refund / manage subscription help link (store-specific deep link)

#### Premium (Phase 1 Active)
- Extended sessions (60m vs 5m free)
- Advanced analytics
- Data export (CSV/PDF)
- Premium themes
- Priority support

#### Future Higher Tier (Deferred)
- Cloud sync, AI insights, multi-environments, social features (not active yet)

#### Notes
- Migration to the official RevenueCat Paywall (for localization & trials) is planned; current widget is an interim custom layout showing dynamic prices.
- Static numeric pricing in `SubscriptionTier` remains only as a fallback.

For detailed setup steps see `docs/MONETIZATION_SETUP.md` (will be updated to reflect the above identifiers and pricing alignment).

## 🔧 Project Status & Development Progress

### ✅ **Completed Core Features**
- **Silence Detection**: Advanced noise monitoring with `noise_meter` integration
- **Real-Time UI**: Interactive progress ring, live noise charts, countdown timers
- **Session Management**: Configurable durations, point scoring, streak tracking
- **Analytics**: Session history, performance metrics, visual trends
- **Settings System**: Tabbed interface with Basic/Advanced/About sections
- **Theme System**: System/Light/Dark modes with quick switching
- **Data Persistence**: Local storage with SharedPreferences
- **Permissions**: Intelligent microphone access management

### ✅ **Completed Monetization System**
- **Subscription Service**: RevenueCat integration with purchase flows
- **Feature Gating**: Premium access control with `FeatureGate` widgets
- **Paywall UI**: Professional subscription interface with billing toggles
- **State Management**: Riverpod providers for subscription state
- **Product Configuration**: Premium ($1.99) and Premium Plus ($3.99) tiers
- **Development Testing**: Mock subscription flows working

### ✅ **Completed Technical Infrastructure**
- **Package Updates**: Bundle ID changed to `io.sparkvibe.silencescore`
- **Build System**: Production-ready with environment variable management
- **API Integration**: RevenueCat, Firebase, notification services
- **Code Quality**: Comprehensive linting, testing, documentation
- **Platform Support**: iOS and Android builds verified

### 📋 **Pending Platform Configuration**
- **App Store Connect**: Subscription product configuration
- **Google Play Console**: Subscription product configuration
- **Store Assets**: App icons, screenshots, metadata preparation
- **Legal Documents**: Privacy policy and terms of service finalization

### 🎯 **Next Immediate Priorities**
1. **Native Paywall Polishing**: Document new dismissal behavior (no forced fallback sheet)
2. **Platform Setup**: Configure App Store and Play Console subscriptions
3. **Visual Assets**: Create app icons and store screenshots
4. **Legal Documents**: Finalize privacy policy and terms
5. **Store Submission**: Submit for app store review
6. **Launch Marketing**: Execute go-to-market strategy

## Last Updated
August 29, 2025 - Added native paywall dismissal handling (suppresses fallback on close), aggregated noise controller, throttled logger, shared permission Future, and documentation updates.