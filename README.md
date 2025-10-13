# Focus Field

![CI](https://github.com/sparkvibe-io/FocusField/actions/workflows/ci.yml/badge.svg)
![Release Build](https://github.com/sparkvibe-io/FocusField/actions/workflows/release-build.yml/badge.svg)

A sophisticated Flutter app that measures silence, tracks progress, and provides detailed analytics for mindfulness and focus sessions. Features real-time noise monitoring, comprehensive statistics, achievement system, calibration, and advanced customization options.

## 🚀 Current Status (October 2025): Tablet Responsive Design Complete ✅

**Ambient Quests** is the merged, quiet-first direction: pick an Activity Profile (Study, Reading, Meditation), start a session, and earn Quiet Minutes when your environment stays under a threshold. A small Quest capsule shows today's goal progress, and streaks are compassionate (2-Day Rule + monthly freeze token). All analysis is local; no audio is recorded.

**Simple & Customizable**: Users can now show/hide activities and adjust their daily quiet goal (10-60 minutes) through a polished Edit Activities sheet. Each activity tracks separate progress toward the global goal.

### ✅ **P0 Implementation COMPLETE** (Oct 9-10, 2025)

**Core Engine**:
- ✅ Activity Profiles with per-profile `usesNoise` and `thresholdDb`
- ✅ Ambient Score: `quietSeconds / actualSeconds` calculated in real-time (1Hz ticks)
- ✅ Quest State Management: daily goals, streak tracking, freeze tokens
- ✅ Compassionate Streaks: Permissive 2-Day Rule + monthly freeze token replenishment
- ✅ Session Lifecycle: Full integration (start → tick → end)
- ✅ Background Safety: Android STOP action & Deep Focus breach handlers

**Analytics & Visualization**:
- ✅ 12-week Activity Heatmap (GitHub-style contribution graph)
- ✅ Today Timeline (24-hour micro-chart with session dots)
- ✅ Weekly Target Line overlay on 7-day trends chart
- ✅ Unified Trends Sheet (heatmap integrated into "Show More")

### ✅ **P1 Implementation COMPLETE** (Oct 10-11, 2025)

**Quest Features**:
- ✅ Quest Capsule UI on Activity tab (progress bar, streak, freeze token)
- ✅ Ambient Score display inside progress ring (live calm% during sessions)
- ✅ Adaptive Threshold suggestions (after 3 consecutive wins, 7-day cooldown)
- ✅ Full localization (7 languages: EN, ES, DE, FR, JA, PT, PT_BR)

**Activity Customization** (Oct 11, 2025):
- ✅ **Per-Activity Tracking**: Study, Reading, Meditation tracked separately
- ✅ **Edit Activities Sheet**: Show/hide activities, adjust daily goal (10-60 min)
- ✅ **User Preferences**: Persisted settings for enabled activities and goals
- ✅ **Material Design 3**: Consistent icons throughout (replaced emojis)
- ✅ **UI Polish**: All bottom sheets match (85% height, drag handles, scrollable)
- ✅ **Activity Filtering**: Summary displays only enabled activities

### ✅ **Tablet & Responsive Design Complete** (Oct 12, 2025)

**Responsive System**:
- ✅ Breakpoint-based responsive utilities (phone/small tablet/large tablet)
- ✅ Adaptive text scaling (1.0x → 1.15x → 1.25x)
- ✅ Proportional widget sizing (progress rings, charts, buttons)
- ✅ Orientation locking (portrait-only <840dp, all orientations ≥840dp)

**Tablet Landscape Layout (≥840dp)**:
- ✅ Split-screen: Today panel (left) + Sessions panel (right)
- ✅ Single ad placement strategy (only in Today panel)
- ✅ 50/50 split with vertical divider
- ✅ Simultaneous access to progress tracking and session controls

### 🔄 **Remaining Work (P1)**

- ⏳ iOS Live Activities (Lock Screen + Dynamic Island) - Platform parity with Android

**Implementation Docs**:
- `docs/development/AmbientQuests_Dev_Spec.md` (Gherkin acceptance tests)
- `docs/development/AmbientQuests_Copy_and_MicroInteractions.md` (UX specifications)
- `docs/development/Ambient_Quests_P0_Implementation_Summary.md` (✨ NEW - completed work summary)
- `docs/development/iOS_Live_Activities_Plan.md` (iOS implementation guide)

**Feature Flags**: see `lib/constants/ambient_flags.dart` (P0 flags enabled by default)

## 📱 Platform Support

**Phones (Primary):**
- Optimized for 4.7"-6.7" smartphones (iOS & Android)
- Single-column layout with compact widgets
- All features accessible without scrolling

**Tablets (Adaptive):**
- Intelligent scaling for 7"-13" tablets
- **Portrait Mode**: Phone layout with proportional scaling (fonts +15-25%, widgets +20-35%)
- **Landscape Mode (≥840dp only)**: Split-Screen layout
  - Left panel (50%): Today tab with sessions, quest progress, patterns - **ad at bottom**
  - Right panel (50%): Sessions tab with activity controls, progress ring - **no ad**
  - Single ad placement strategy (only in Today panel)
  - Simultaneous access to progress tracking and session controls
  - 50/50 split with vertical divider for clear separation

**Orientation Policy:**
- **Phones & Small Tablets (<840dp)**: Portrait-only (landscape disabled to protect ad visibility)
- **Large Tablets (≥840dp)**: All orientations allowed

**Responsive Design:**
- Breakpoints: Phone (<600dp), Small Tablet (600-840dp), Large Tablet (>840dp)
- Adaptive typography and touch targets (scaling up to 1.25x on large tablets)
- Proportional widget sizing (progress rings, charts, buttons scale 20-36%)
- Orientation locking via `OrientationLocker` widget (`lib/main.dart`)
- Responsive utilities: `lib/utils/responsive_utils.dart`
- Tablet landscape layout: `lib/screens/home_page_elegant.dart` (_buildTabletLandscapeLayout)
- See `CLAUDE.md` for detailed implementation strategy

## 🌟 Features

### Core Functionality
- **Real-Time Silence Detection**: Ambient noise monitoring using device microphone
- **Interactive Session Progress Ring**: Large countdown control with MM:SS timer
- **Real-Time Noise Chart**: Live decibel visualization with threshold indicators & smoothing (1Hz aggregated controller)
- **Quick Duration Selectors**: ✅ **NEW** Instant session length buttons (1, 5, 10, 15, 30 min + premium 1h, 1.5h, 2h)
- **Quick Threshold Selectors**: ✅ **NEW** One-tap decibel adjustment buttons (20, 40, 60, 80 dB)
- **Smart Point System**: Earn 1 point per minute of successful quiet time
- **Streak Analytics**: Track daily streaks, best performances, and session history
- **Noise Floor Calibration**: Quick ambient baseline measurement (clamped 20–80 dB)
- **Achievement System**: Visual feedback with confetti celebrations

### Advanced Analytics
- **Tabbed Overview Widget**: ✅ Space-optimized interface combining Practice Overview + Advanced Analytics
- **Performance Metrics**: 6 comprehensive metrics (Success Rate, Avg Session, Consistency, Best Time, Preferred Duration, Total Points)
- **Weekly Trends**: Advanced trend chart with moving averages, overall average line, and interactive tooltips
- **12-Week Activity Heatmap**: ✅ **NEW** GitHub-style contribution graph showing session intensity over 12 weeks
- **Today Timeline**: ✅ **NEW** 24-hour horizontal timeline with session dots positioned by time of day
- **Weekly Target Line**: ✅ **NEW** Visual goal reference (30min default) overlaid on 7-day trends
- **AI Insights**: Color-coded insights with achievement, improvement, warning, and recommendation types
- **Session History Graph**: Visual representation of quiet progress
- **7-Day Activity Chart**: Real-time stacked bar chart showing minutes by activity with per-activity colors

### Customization & Settings
- **Activity Customization**: ✅ **NEW** Show/hide activities (Study, Reading, Meditation), adjust daily goal (10-60 min)
- **Per-Activity Tracking**: ✅ **NEW** Separate progress tracking for each activity toward global goal
- **Tabbed Settings Interface**: Basic, Advanced, About
- **Adjustable Decibel Threshold**: 20–80 dB (default 38) with high-threshold warning ≥70 dB
- **Session Duration**: Free up to 30 minutes; Premium up to 120 minutes
- **Calibration Dialog**: Previous vs new threshold, ambient warnings
- **Theme System**: System / Light / Dark
- **Accessibility Settings**: High contrast, large text, vibration feedback

### User Experience
- **Progress Ring Control**: Start/stop & visual completion
- **Smooth Visual Updates**: Smoothing filters + aggregated controller reduce jitter & frame drops
- **Confetti Celebrations**: Successful session reward
- **Material Design 3**: ✅ **NEW** Consistent Material icons throughout (Study 🎓→📚, Reading 📖→📕, Meditation 🧘→🧘‍♀️)
- **Consistent Bottom Sheets**: ✅ **NEW** All sheets match (85% height, drag handles, scrollable overflow protection)
- **Permission Guidance**: Microphone access onboarding
- **Compact Layout**: Key controls on one screen
- **Calm Home**: Activity‑aware noise widget (compact by default); Quest capsule as the focal point

### Data & Privacy
- **Local Storage Only**: No audio recorded or transmitted
- **Data Export (Premium)**: CSV & PDF reports
- **Reset Option**: Wipes all local settings & history

> Note: Cloud backup / sync is not yet available (local-only).

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
git clone https://github.com/sparkvibe-io/FocusField.git
cd FocusField
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
./scripts/build/build-dev.sh

# Or run directly with Flutter (iOS)
flutter run --dart-define=REVENUECAT_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME

# Or run directly with Flutter (Android)
flutter run --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
```

### Environment Configuration

The app uses environment variables for secure API key management:

- **Development**: Uses `.env` file and mock subscriptions by default
- **Production**: Requires actual API keys and disables mocks

**Environment Variables:**
- `REVENUECAT_API_KEY`: RevenueCat subscription management (platform-specific)
  - **iOS**: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
  - **Android**: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- `FIREBASE_API_KEY`: Firebase services (optional)
- `IS_DEVELOPMENT`: Enable/disable development mode
- `ENABLE_MOCK_SUBSCRIPTIONS`: Use mock payments for testing

### Building for Production

#### Android
```bash
# Using the secure build script (recommended)
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
./scripts/build/build-prod.sh

# Or manually with dart-define
flutter build apk --release --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
flutter build appbundle --release --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
```

#### iOS
```bash
# Set environment variables
export REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"

# Build for iOS
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
  --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
```

#### Development Builds
```bash
# Quick development build with environment file
./scripts/build/build-dev.sh

# Or run in debug mode
flutter run
```

## 🔐 Permissions

The app requires microphone access to measure ambient noise levels:

- **iOS**: Added `NSMicrophoneUsageDescription` in Info.plist
- **Android**: Added `RECORD_AUDIO` permission in AndroidManifest.xml

**Privacy Note**: No audio is recorded or stored - the app only measures decibel levels in real-time for silence detection. A shared cached permission Future prevents duplicate OS dialogs.

## 🔔 Notification System

Focus Field includes a flexible, privacy‑friendly local notification system designed to reinforce habit formation without being spammy.

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
- **Session Duration (Free Default)**: 30 minutes (Premium configurable 1–120 minutes)
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

#### Tip System Localization
The tip system is fully internationalized with proper localization keys:
- **Tip Window**: `tipsTitle` for window title, `muteTips` for mute button
- **Toast Messages**: `tipsMuted` for confirmation message after muting
- **Tip Content**: 30 localized tips (`tip01` through `tip30`) with contextual instructions
- **Instructions**: Contextual help text (`tipInstruction*` keys) for each tip
- **Tip Info Icon**: `tipInfoTooltip` for lightbulb icon tooltip

All tip-related UI elements are properly localized across all 7 supported languages.

#### Tip System Features
- **Manual-Only Display**: Tips only show when user actively clicks the lightbulb icon
- **Lightbulb Icon**: Intuitive lightbulb icon with amber glow effect for new tips
- **Smart Timing**: Same tip shown for 5 minutes, updates only when user has seen it
- **Session Tracking**: Prevents showing same tip twice in one session
- **Muted Override**: Info button works even when tips are muted
- **Gentle Animation**: Subtle 3-second pulsing glow effect
- **Theme Adaptive**: Amber glow works well in both light and dark themes
- **No Interruptions**: Tips never appear automatically, respecting user workflow

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

## 📣 Ads (AdMob) Integration

Focus Field uses a single bottom banner via Google Mobile Ads. Integration follows Google’s guidelines and is wired for safe development defaults.

### Dev vs Release behavior
- Development (debug/profile or `IS_DEVELOPMENT=true`): always uses Google’s official test banner ad unit.
- Release (`IS_DEVELOPMENT=false`): uses production ad unit per platform. If you set `ADS_FALLBACK_TEST_ON_FAIL=true`, the app retries once with the Google test unit when a production request fails to help verify integration.

### Platform configuration
- Android App ID (AndroidManifest): `ca-app-pub-2086096819226646~6517708516`
- iOS App ID (Info.plist): `ca-app-pub-2086096819226646~9627636327`

### Default production banner units (override-able)
- Android: `ca-app-pub-2086096819226646/3553182566`
- iOS: `ca-app-pub-2086096819226646/9050063581`

Override at runtime using dart-defines:
- `ANDROID_BANNER_AD_UNIT_ID=<your_android_banner_id>`
- `IOS_BANNER_AD_UNIT_ID=<your_ios_banner_id>`
- `ADS_FALLBACK_TEST_ON_FAIL=true` (optional, release QA)

### Quick runs
```bash
# Android (dev-safe test ads)
./run_android_revenuecat.sh --debug -d <device_id>

# Android (release with prod ads)
./run_android_revenuecat.sh --release -d <device_id>

# iOS (dev-safe test ads)
./run_ios_revenuecat.sh --debug -d <device_id_or_ios>

# iOS (release with prod ads)
./run_ios_revenuecat.sh --release -d <device_id_or_ios>

# iOS (release with one-time fallback to test if prod fails)
ADS_FALLBACK_TEST_ON_FAIL=true ./run_ios_revenuecat.sh --release -d <device_id>
```

Banner rendering is deferred until `onAdLoaded` to prevent crashes; if a request fails or returns no fill, the banner area collapses.


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
- `RealTimeNoiseChart`: Live decibel visualization with smoothing, throttled logging & 1Hz aggregated updates + integrated quick threshold selectors
- `TabbedOverviewWidget`: Space-optimized tabbed container combining Practice Overview + Advanced Analytics
- `QuickDurationSelector`: ✅ **NEW** Compact session duration buttons with premium integration and paywall
- `QuickDecibelSelector`: ✅ **NEW** Instant threshold adjustment buttons (20, 40, 60, 80 dB)
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
- `activeSessionDurationProvider`: ✅ **NEW** Temporary session duration overrides for quick selectors
- `activeDecibelThresholdProvider`: ✅ **NEW** Temporary threshold overrides for quick selectors
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
# Format code (CI-safe)
dart format --output=none --set-exit-if-changed .

# Analyze code
flutter analyze

# Run linter
flutter analyze --no-fatal-infos
```

### Recent UI Improvements (Notifications)
- Smart Daily Reminders and Weekly Progress Summary now display their scheduling controls within each tile footer. This prevents horizontal overflows on small screens and makes the selection more discoverable.
- The Notification Settings bottom sheet now has a solid background with a clearly visible close (X) icon and title.

## ✨ Latest UI/UX Enhancements

### Quick Selector System ✅ **NEW**
- **Duration Selectors**: Instant access buttons positioned above the progress ring
  - Free durations: 1, 5, 10, 15, 30 minutes (single-line responsive layout)
  - Premium durations: 1h, 1.5h, 2h (show professional paywall for free users)
  - Temporary override pattern: Uses `activeSessionDurationProvider` for real-time changes without affecting persistent settings
  - Premium integration: Seamlessly integrated with existing paywall system

- **Decibel Selectors**: Quick threshold adjustment buttons integrated in noise level widget header
  - One-tap presets: 20, 40, 60, 80 dB for instant environment adaptation
  - Visual feedback: Selected threshold highlighted with primary color styling
  - Real-time updates: Immediately affects silence detection without settings navigation
  - Responsive design: Compact layout that works across all screen sizes

### Tabbed Overview Widget - Space Optimization
- **Combined Interface**: Merges Practice Overview and Advanced Analytics into elegant tabbed container
- **Space Savings**: Frees ~80px of vertical space for advertisement placement (free users)
- **Overview Tab**:
  - Horizontal layout with compact stats (Points, Streak, Sessions) alongside 7-day activity chart
  - Real-time bar chart showing actual daily points from session data
  - Efficient 80px height for overview content
- **Analytics Tab (Premium)**:
  - Complete advanced analytics experience for premium subscribers
  - 6 comprehensive performance metrics in 2x3 grid layout
  - Full trends chart with moving averages, overall average lines, and interactive tooltips
  - AI insights with color-coded achievement, improvement, warning, and recommendation types
  - Dynamic 500px height to accommodate rich analytics content
- **Premium Integration**: Analytics tab shows upgrade prompt for free users, full content for premium subscribers
- **Smooth Transitions**: TabController with proper state management and automatic height adjustment

### Enhanced User Experience
- **Professional Paywall Integration**: Consistent upgrade flow using existing `showPaywall()` system across all premium features
- **Real-time Visual Feedback**: Immediate response to threshold and duration changes with highlighted selection states
- **No Advertisement Interference**: Premium users get full screen real estate without space constraints for ads
- **Responsive Design**: All components adapt to different screen sizes while maintaining single-line layouts
- **Accessibility Compliant**: Follows Material 3 design guidelines with proper contrast ratios and touch targets
- **Data-driven Visualizations**: Charts and metrics show actual user data instead of placeholder content

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
- **Optimized Settings Layout**: Space-efficient design with inline values for better accessibility
- **Compact UI**: Values displayed in titles (e.g., "Decibel Threshold (60dB)") to save space

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

### Ambient Quests Scope Notes

- Ambient Quests supersedes earlier “Mission/Mission Capsule” docs, which are archived.
- Optional P2 integrations are feature‑flagged: Health sync, Calendar export.
- See the Dev Spec for acceptance tests and rollout plan.

### Technical Improvements
- [ ] Flutter Sound integration for enhanced audio processing
- [ ] Machine learning for adaptive threshold adjustment
- [ ] Cloud backup and cross-device sync
- [ ] Performance optimizations for older devices
- [ ] Enhanced accessibility features
- [ ] Comprehensive integration testing
 - [ ] Naming migration: Replace legacy "Silence*" prefixes (files, classes, providers, and docs) with "Focus*" to reflect the app rename from SilenceScore → Focus Field (e.g., SilenceDetector → FocusDetector, SilenceDataNotifier → FocusDataNotifier, file names like silence_*.dart → focus_*.dart).

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
- **iOS**: Settings > Privacy & Security > Microphone > Focus Field
- **Android**: Settings > Apps > Focus Field > Permissions > Microphone
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
xcrun simctl privacy booted reset all io.sparkvibe.focusfield

# Reset app data (Android)
adb shell pm clear io.sparkvibe.focusfield
```

### Getting Help

## 🗺️ Roadmap (focused)

- P0: Profiles, Ambient Score, Quest capsule, compassionate streaks, adaptive threshold, live surfaces
- P1: Micro-haptics, weekly share card, “Best Space & Time” insight
- P2: Health/Health Connect write, Calendar export (feature‑flagged)
- **Android**: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- Tiered access: Free, Premium, Premium Plus (future expansion)
- Feature gating with `FeatureGate` + Riverpod providers
- Custom paywall (`PaywallWidget`) currently showing dynamic prices when offerings load
- Mock mode (`ENABLE_MOCK_SUBSCRIPTIONS=true`) for development without store connections

#### Product Identifiers (Current)
```
premium.tier.monthly
premium.tier.yearly
```

#### Pricing (Live via RevenueCat)
- Prices and localized currency are pulled dynamically from RevenueCat Paywall/Offerings.
- Legacy fallback values (1.99 / 19.99) remain in code only if offerings fail to load.

#### Key Environment Flags
- `REVENUECAT_API_KEY` (platform-specific, required for production builds)
  - **iOS**: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
  - **Android**: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- `IS_DEVELOPMENT` (default false for production)
- `ENABLE_MOCK_SUBSCRIPTIONS` (default false for real purchases)

#### Launch Readiness Checklist (Remaining)
1. Add legal links (Privacy Policy, Terms) to paywall footer
2. Confirm introductory offers / trials (if desired) configured in stores & RevenueCat
3. Turn off mock mode in production build scripts
4. QA sandbox purchases on iOS & internal testing on Android
5. Add refund / manage subscription help link (store-specific deep link)

#### Premium (Phase 1 Active)
- Extended sessions (120m vs 30m free)
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
- **Package Updates**: Bundle ID changed to `io.sparkvibe.focusfield`
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
October 6, 2025 — Updated to Ambient Quests final direction; archived legacy Mission/Habit documents and linked to the new spec.