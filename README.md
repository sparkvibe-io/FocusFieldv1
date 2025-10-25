# Focus Field

![CI](https://github.com/sparkvibe-io/FocusField/actions/workflows/ci.yml/badge.svg)
![Release Build](https://github.com/sparkvibe-io/FocusField/actions/workflows/release-build.yml/badge.svg)

**A sophisticated Flutter app that measures ambient silence and helps you build focus habits through compassionate quest-based progression.**

First-to-market in the silence measurement category, combining productivity technology with environmental monitoring for deep work sessions.

---

## 🚀 Current Status

**MVP Complete - Ready for Platform Configuration (October 2025)**

### ✅ What's Working
- Ambient Quests system with compassionate streaks (2-day rule + freeze tokens)
- Focus Mode with full-screen overlay and completion states
- RevenueCat + AdMob monetization fully integrated
- Responsive design (phone-first, tablet-adaptive with landscape split-screen)
- 7 languages (EN, ES, DE, FR, JA, PT, PT_BR)
- 6-screen onboarding flow

### 📋 Next Steps
1. Configure App Store Connect & Google Play Console subscriptions
2. Create app icons and store screenshots
3. Finalize legal documents (privacy policy, terms)

> **Detailed changelog**: See [`docs/development/CHANGELOG.md`](docs/development/CHANGELOG.md)

---

## 🎯 Quick Start

### Prerequisites
- Flutter 3.x+, Dart 3.x+
- iOS 15.0+ or Android API 21+
- Microphone access (no audio recording, only decibel measurement)

### Installation

```bash
# 1. Clone repository
git clone https://github.com/sparkvibe-io/FocusField.git
cd FocusField

# 2. Install dependencies
flutter pub get

# 3. Configure environment (copy and edit .env file)
cp .env.example .env
# Edit .env with your RevenueCat API keys

# 4. Run development build (with mock subscriptions)
./scripts/build/build-dev.sh

# OR run directly on device
./scripts/run/ios.sh --debug       # iOS
./scripts/run/android.sh --debug   # Android

# OR run with Flutter directly
flutter run --dart-define=REVENUECAT_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME  # iOS
flutter run --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf  # Android
```

### Production Builds

```bash
# Android
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
./scripts/build/build-prod.sh

# iOS
export REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"
flutter build ios --release --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY"
```

---

## 🌟 Core Features

### Ambient Quest System
- **Ambient Score**: Real-time silence quality metric (`quietSeconds / actualSeconds`)
- **Compassionate Credit**: Earn points proportionally (1 point per quiet minute)
- **70% Threshold**: Sessions with ≥70% calm qualify for quest credit
- **Streak System**: Permissive 2-day rule + monthly freeze token
- **Activity Profiles**: Study, Reading, Meditation (customizable goals 10-60 min)

### Session Management
- **Interactive Progress Ring**: Large countdown control with MM:SS timer
- **Focus Mode**: Full-screen minimal distraction mode with long-press Pause/Stop
- **Quick Selectors**: Instant duration (1-30 min) and threshold (20-80 dB) buttons
- **Real-Time Monitoring**: Live decibel visualization with smoothing algorithms
- **Session History**: 12-week activity heatmap, daily timeline, trend charts

### Analytics & Insights
- **Live Metrics**: Real-time calculations from session history
  - Average daily focus time (last 7 days)
  - Weekly session frequency
  - Ambient score percentage
  - Performance trends with moving averages
- **Advanced Analytics** (Premium): 6 performance metrics, trend charts, data-driven insights
- **Weekly Recap**: Visual summary with achievements

### Customization
- **Activity Management**: Show/hide activities, adjust daily goals (10-60 min)
- **Per-Activity Tracking**: Separate progress for each activity toward global goal
- **Theme System**: High-contrast Light/Dark modes + premium themes
- **Accessibility**: High contrast, large text, vibration feedback
- **Responsive Design**: Optimized for phones (4.7"-6.7") and tablets (7"-13")

### Premium Features
| Feature | Free | Premium ($1.99/mo) | Premium Plus ($3.99/mo) |
|---------|------|-------------------|------------------------|
| Session length | 30 min | 120 min | 120 min |
| History | 7 days | 90 days | Unlimited |
| Analytics | Basic | Advanced | AI insights |
| Export | No | CSV/PDF | Cloud sync |
| Focus durations | 1-30 min | + 1h, 1.5h, 2h | + All |

---

## 📱 Platform Support

### Phones (Primary)
- Optimized for 4.7"-6.7" smartphones (iOS & Android)
- Single-column layout, all features accessible without scrolling

### Tablets (Adaptive)
- Intelligent scaling for 7"-13" tablets
- **Portrait**: Phone layout with proportional scaling (+15-25% fonts, +20-35% widgets)
- **Landscape (≥840dp)**: Split-screen 50/50
  - Left: Today tab + ad footer
  - Right: Sessions tab (no ad)
- **Orientation Policy**: Portrait-only for <840dp (protects ad visibility)

### Responsive Breakpoints
- Phone: <600dp
- Small Tablet: 600-840dp
- Large Tablet: >840dp

---

## 🔐 Permissions & Privacy

### Microphone Access
- **Required**: For ambient noise monitoring
- **iOS**: `NSMicrophoneUsageDescription` in Info.plist
- **Android**: `RECORD_AUDIO` in AndroidManifest.xml

### Privacy Commitment
- ✅ **No audio recording** - Only decibel level measurements
- ✅ **Local storage only** - No cloud transmission (optional Premium sync)
- ✅ **Data export** - CSV/PDF for Premium users
- ✅ **Reset option** - Wipe all local data anytime

---

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.x with Dart 3.x
- **State Management**: Riverpod with hooks_riverpod
- **Noise Detection**: noise_meter package with circuit breaker safeguards
- **Persistence**: SharedPreferences with JSON serialization
- **Monetization**: RevenueCat (subscriptions) + AdMob (banners)
- **Localization**: Flutter gen-l10n (7 languages)

### Project Structure
```
lib/
├── constants/     # Feature flags, config
├── models/        # Data models (JSON serialization)
├── providers/     # Riverpod state management
├── screens/       # Main UI screens
├── services/      # Business logic, APIs
├── theme/         # Design system
├── widgets/       # Reusable components
└── main.dart      # App entry point
```

### Key Components
- **Services**: `SilenceDetector`, `AudioCircuitBreaker`, `StorageService`, `SubscriptionService`
- **Providers**: `questStateProvider`, `silenceDataProvider`, `userPreferencesProvider`, `subscriptionProvider`
- **Widgets**: `ProgressRing`, `FocusModeOverlay`, `RealTimeNoiseChart`, `QuestCapsule`

---

## 🔧 Development

### Common Commands
```bash
# Run tests
./scripts/testing/test.sh
./scripts/testing/test.sh --coverage

# Tools
./scripts/tools/check-localizations.sh
./scripts/tools/coverage-summary.sh
./scripts/tools/fix-lint.sh

# Format code
flutter format .

# Analyze code
flutter analyze

# Generate localizations
flutter gen-l10n

# Clean build
flutter clean && flutter pub get
```

### Environment Variables
```bash
# Development (mock subscriptions)
REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
IS_DEVELOPMENT=true
ENABLE_MOCK_SUBSCRIPTIONS=true

# Production
REVENUECAT_API_KEY=<platform_specific_key>  # See .env.example
IS_DEVELOPMENT=false
ENABLE_MOCK_SUBSCRIPTIONS=false
```

### AdMob Configuration
```bash
# Android
App ID: ca-app-pub-2086096819226646~6517708516
Banner: ca-app-pub-2086096819226646/3553182566

# iOS
App ID: ca-app-pub-2086096819226646~9627636327
Banner: ca-app-pub-2086096819226646/9050063581
```

---

## 🌍 Internationalization

### Supported Languages
- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Portuguese (pt)
- Brazilian Portuguese (pt_BR)
- Japanese (ja)

### Adding Translations
1. Edit `lib/l10n/app_en.arb` (source of truth)
2. Copy keys to all other `app_<locale>.arb` files
3. Add `@key` metadata for placeholders
4. Run `flutter gen-l10n`
5. Validate with completeness tests: `flutter test test/localization_*`

> **Translation guide**: See [`docs/development/INTERNATIONALIZATION.md`](docs/development/) (to be created)

---

## 🔔 Notification System

### Features
- **Smart Daily Reminders**: Learns your preferred practice time (±30 min window)
- **Weekly Progress Summary** (Premium): User-selectable weekday + time
- **Session Completion**: Instant feedback when sessions finish
- **Achievement Notifications**: Milestone unlocks (streaks, perfect sessions)
- **Adaptive Messaging**: Copy adjusts to streak length and session count

### Privacy
- All notifications are local (no server communication)
- Scheduling uses device timezone
- Optional time overrides or smart adaptive mode

---

## 🗺️ Roadmap

### ✅ MVP (Current - Ready for Launch)
- Core Ambient Quests system
- Focus Mode P1 (overlay, completion states, controls)
- Tablet responsive design
- RevenueCat + AdMob monetization
- 7-language localization
- Onboarding flow

### 📋 Post-MVP (P2)
- **iOS Live Activities** (Android notification parity exists)
- **Focus Mode Enhancements**:
  - Breathing animation (8s inhale/exhale cycle)
  - Icon-only buttons
  - Enhanced completion celebration
- **Activity System Expansion**: Custom activity creation
- **Support Resources**: In-app FAQ, help center

### 🔮 Premium Features (P3)
- **Focus Mode Lock**: Prevent exit until completion (Premium)
- **Color Themes**: 4 personalized themes (Midnight/Ocean/Forest/Sunset)
- **Ultra-Minimal Mode**: Ring-only display with long-press reveal
- **Cloud Sync**: Cross-device backup (Premium Plus)
- **AI Insights**: Predictive recommendations (Premium Plus)

> **Detailed roadmap**: See [`docs/business/roadmap.md`](docs/business/roadmap.md)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Follow Dart/Flutter best practices and existing code style
4. Add tests for new functionality
5. Run `flutter analyze` and `flutter test` (all tests must pass)
6. Update documentation for new features
7. Submit a pull request with detailed description

### Development Guidelines
- Follow Dart formatting standards (`dart format .`)
- Write comprehensive tests (unit + widget)
- Ensure accessibility compliance
- Test on both iOS and Android
- Update localization for user-facing strings

---

## 📚 Documentation

### For Developers
- [`CLAUDE.md`](CLAUDE.md) - Development guide for Claude Code
- [`docs/development/CHANGELOG.md`](docs/development/CHANGELOG.md) - Historical completion logs
- [`docs/development/AmbientQuests_Dev_Spec.md`](docs/development/AmbientQuests_Dev_Spec.md) - Quest system specification
- [`docs/MONETIZATION_SETUP.md`](docs/MONETIZATION_SETUP.md) - Subscription setup guide
- [`docs/architecture/`](docs/architecture/) - System design documentation

### For Business
- [`docs/business/phase1-launch-plan.md`](docs/business/phase1-launch-plan.md) - Launch timeline
- [`docs/business/revenue-strategy.md`](docs/business/revenue-strategy.md) - Financial projections
- [`docs/business/roadmap.md`](docs/business/roadmap.md) - 24-month product roadmap

### For Users
- [`docs/user/`](docs/user/) - User guides and tutorials (to be created)

---

## 🔧 Troubleshooting

### Common Issues

**App crashes on startup**
- Clear app data, restart device
- Ensure microphone permissions granted
- Check iOS Settings > Privacy > Microphone > Focus Field
- Check Android Settings > Apps > Focus Field > Permissions

**Audio processing errors**
- App includes automatic recovery (shows "recovering" message)
- Circuit breaker protects against native buffer crashes
- Check microphone isn't in use by another app

**Build errors**
```bash
flutter clean
flutter pub get
flutter run
```

**Reset permissions for testing**
```bash
# iOS Simulator
xcrun simctl privacy booted reset all io.sparkvibe.focusfield

# Android
adb shell pm clear io.sparkvibe.focusfield
```

> **More help**: See [`docs/TROUBLESHOOTING.md`](docs/) (to be created) or open an issue

---

## 📊 Business Context

### Market Position
- **First-to-Market**: Creating the silence measurement app category
- **Target Markets**: US, Canada, UK, Australia (English-speaking)
- **Revenue Model**: Freemium SaaS with dual-tier subscriptions
- **Year 1 Goal**: 15,000 downloads, 8% conversion, $19,080 ARR

### Launch Timeline (6 Weeks)
- **Week 1**: ✅ Monetization infrastructure (COMPLETE)
- **Week 2**: Platform configuration, visual assets
- **Week 3**: Legal docs, store submission
- **Week 4-6**: Marketing, user acquisition

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with Flutter and powered by:
- [noise_meter](https://pub.dev/packages/noise_meter) - Ambient noise detection
- [Riverpod](https://riverpod.dev/) - State management
- [RevenueCat](https://www.revenuecat.com/) - Subscription infrastructure
- [fl_chart](https://pub.dev/packages/fl_chart) - Data visualization

---

**Last Updated**: October 19, 2025 - Code optimization & performance improvements complete

For detailed version history, see [`docs/development/CHANGELOG.md`](docs/development/CHANGELOG.md)
