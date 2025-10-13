# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Focus Field is a comprehensive Flutter mobile app that measures ambient silence and awards points for maintaining quiet environments. It represents a first-to-market opportunity in the silence measurement category, combining workplace wellness, productivity technology, and ambient environmental monitoring. The app features real-time noise monitoring, session tracking, achievements, and a sophisticated subscription-based monetization system with multiple premium tiers.

## 🚀 CURRENT STATUS — Oct 12, 2025: Tablet Responsive Design Complete
### Product Principles (Always)
- No scrolling on main pages (Home/Summary/Activity). Use compact components, tabs, and carousels to fit without vertical scroll.
- Advertisements are always visible (anchored adaptive banner), never obscured by overlays or long content.
- Material 3 with minimal, non‑repeatable content. Prefer concise, unique information over duplicated elements.
- **UI Consistency**: All bottom sheets use same height (85% screen), drag handles, and scrollable content structure.

### ✅ **AMBIENT QUESTS P0 LOOP - COMPLETE** (Oct 9-10, 2025)
**Core Quest Engine**:
- ✅ AmbientSessionEngine fully integrated with session lifecycle (start → 1Hz tick → end)
- ✅ Ambient Score calculation: `quietSeconds / actualSeconds` tracked in real-time
- ✅ Quest updates centralized via QuestStateController
- ✅ Live calm% parity verification (logs difference if >1%)
- ✅ Session state tracks `usesNoise` flag for noise-requiring activities
- ✅ **Activity Profiles (P0)**: 3 quiet-first profiles only (Study, Reading, Meditation)
  - All 3 profiles use noise monitoring (`usesNoise: true`, threshold: 38 dB)
  - Custom activity creation deferred to P2
  - Legacy activity system removed

**Rollover & Streak System**:
- ✅ Daily rollover: resets progress at day change
- ✅ Monthly rollover: replenishes freeze token (max 1 per month)
- ✅ Permissive 2-Day Rule: streak resets only if **two consecutive days** are missed
- ✅ `missedYesterday` flag tracks gap days for accurate streak calculation
- ✅ Freeze token protects streak and counts as goal completion

**Lifecycle Integration**:
- ✅ Session start: launches ambient engine with activity's `requiresSilence` flag
- ✅ 1Hz ticking: subscribes to RealTimeNoiseController stream
- ✅ Session end: persists ambient score, applies quest credit
- ✅ Android STOP action: ends engine and persists partial session
- ✅ Deep Focus breach: ends engine with breach reason

**Analytics & Visualization** (Oct 10, 2025):
- ✅ **12-week Activity Heatmap** (GitHub-style contribution graph)
- ✅ **Today Timeline** (24-hour micro-chart with session dots)
- ✅ **Weekly Target Line** on 7-day trends chart (30min default)
- ✅ **Unified Trends Sheet**: Heatmap integrated into "Show More" Basic tab
- ✅ **Simplified UI**: Single "Show More" button (removed redundant heatmap icon)

Developer notes (compactness and ad safety):
- Duration chips hide while a session is running; inter-chip spacing and paddings reduced.
- Chart height trimmed (approx 110–116 px) and container paddings tightened; threshold quick chips remain available when not listening.
- Right stats rail for Points/Streak/Sessions nests in a darker card to declutter the main list.
- Heatmap scrollable within TrendsSheet, follows standard bottom sheet structure (85% max height)

### ✅ **P1 CORE FEATURES COMPLETE** (Oct 10, 2025)
**Quest Capsule UI**:
- ✅ Ultra-minimal widget created: `lib/widgets/quest_capsule.dart`
- ✅ Shows progress bar, numbers, streak (if >0), freeze token (if >0)
- ✅ Wired to Activity tab in `lib/screens/home_page_elegant.dart`
- ✅ Follows "less is more" principle - no redundant content

**Ambient Score Display**:
- ✅ Already implemented in `lib/widgets/progress_ring.dart:158-177`
- ✅ Shows "85% Calm" inside ring during sessions
- ✅ Only displays for noise-requiring activities
- ✅ Real-time updates via `calmPercent` parameter

**Adaptive Threshold**:
- ✅ Provider created: `lib/providers/adaptive_threshold_provider.dart`
- ✅ Widget created: `lib/widgets/adaptive_threshold_chip.dart`
- ✅ Tracks consecutive wins, suggests +2 dB after 3 successes
- ✅ Wired to Activity tab, shows "3 wins! Try 40 dB?"
- ✅ 7-day dismissal cooldown

**Localization**:
- ✅ All 7 languages updated (EN, ES, DE, FR, JA, PT, PT_BR)
- ✅ 7 new strings added for Quest Capsule & Adaptive Threshold
- ✅ `flutter gen-l10n` verified: 0 untranslated messages

### ✅ **ACTIVITY CUSTOMIZATION SYSTEM COMPLETE** (Oct 11, 2025)
**Per-Activity Tracking**:
- ✅ Quest state tracks Study/Reading/Meditation minutes separately
- ✅ Global progress = sum of all enabled activities
- ✅ Proper rollover logic (resets daily/monthly per-activity data)
- ✅ Activity Progress widget displays actual per-activity minutes

**User Preferences System**:
- ✅ New model: `lib/models/user_preferences.dart`
- ✅ Provider: `lib/providers/user_preferences_provider.dart`
- ✅ Persists: enabled profiles, global goal (10-60 min), last duration per profile
- ✅ Future-ready for advanced mode (per-activity goals)

**Edit Activities Sheet**:
- ✅ Widget: `lib/widgets/activity_edit_sheet.dart`
- ✅ Show/Hide toggles for Study, Reading, Meditation
- ✅ Global daily goal slider (10-60 minutes, default 20)
- ✅ Advanced section (collapsed, ready for per-activity goals in P2)
- ✅ Material Design 3 icons (replaced emojis)
- ✅ Matches Settings sheet UX (85% height, drag handle, scrollable)
- ✅ Wired to Activity Progress "Edit" button

**UI/UX Polish**:
- ✅ **Material Design Icons**: Replaced emojis with Material 3 icons throughout
  - Study: `Icons.school_outlined`
  - Reading: `Icons.menu_book_outlined`
  - Meditation: `Icons.self_improvement_outlined`
- ✅ **Bottom Sheet Consistency**: All sheets match Settings pattern
  - 85% screen height with BoxConstraints
  - Drag handle (40x4px) at top
  - Expanded + SingleChildScrollView for overflow protection
  - Same border radius (20px top corners)
- ✅ **Compact Spacing**: Reduced padding/spacing to fit content without overflow
- ✅ **Activity Filtering**: Summary shows only enabled activities from preferences

**Architecture Changes**:
- ✅ Quest state uses `userPreferences.globalDailyQuietGoalMinutes` instead of hardcoded 20
- ✅ Activity Progress widget reads from `userPreferencesProvider`
- ✅ Session completion updates both per-activity minutes and global progress
- ✅ Profile selection persists across app restarts

### 📋 Remaining Work (P1)
1. **iOS Live Activities**: Match Android ongoing notification parity (see `docs/development/iOS_Live_Activities_Plan.md`)

### 🔮 **Future Enhancements (P2)**
**Activity System Expansion** (Deferred to P2):
- **Custom Activity Creation**: User-defined activities with custom icons, colors, and goals
- **Active Profiles**: Non-quiet activities (Fitness, Family, Custom) that don't use noise monitoring
- **Advanced Activity Features**: Motion assist, health sync, calendar export
- **Feature Flag**: `FF_ACTIVE_PROFILES = false` (currently disabled)

**Why Deferred**: P0 focuses on validating the core quest loop with 3 simple, quiet-first activities. Adding custom activities and active profiles before validating core value would add unnecessary complexity. See `docs/development/AmbientQuests_Dev_Spec.md` lines 198-199 for P2 rollout plan.

### ✅ **READY FOR LAUNCH - Phase 1 Monetization Complete + AdMob Banners**
- **RevenueCat Integration**: ✅ Complete with platform-specific API keys configured
- **iOS API Key**: ✅ `appl_qoFokYDCMBFZLyKXTulaPFkjdME` (configured)
- **Android API Key**: ✅ `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf` (configured)
- **Subscription System**: ✅ Premium ($1.99/month), Premium Plus ($3.99/month)
- **Feature Gating**: ✅ All premium features properly restricted
- **Paywall UI**: ✅ Professional subscription interface implemented
- **Package ID**: ✅ Updated to `io.sparkvibe.focusfield` (iOS & Android)
- **Build Verification**: ✅ iOS & Android builds successfully with monetization
- **Ads (AdMob)**: ✅ Banner wired, dev uses test units, release uses production units; optional QA fallback to test on failure

### 🌙 Ambient Quests Overview
- Quiet-first profiles; Ambient Score = quietSeconds / actualSeconds
- Quest credit when score >= target (default 70%)
- Compassionate streaks: 2-Day Rule + monthly freeze token
- Final docs: `docs/development/AmbientQuests_Dev_Spec.md`, `docs/development/AmbientQuests_Copy_and_MicroInteractions.md`

Developer constraints:
- Keep primary surface simple; avoid crowding the home page.
- Compact noise chart by default; full chart via explicit expand or when activity requires silence (e.g., Meditation, Study, Noise Monitor).
- Respect accessibility (reduced motion), ad safety spacing, and localization length.
- **Development Mode**: ✅ Mock subscriptions available for testing

### 🎯 **Launch Timeline: 6 Weeks Total (Week 1 Complete)**
- **Week 1**: ✅ Monetization infrastructure (COMPLETE - AHEAD OF SCHEDULE)
- **Week 2**: Platform configuration and visual assets
- **Week 3**: Legal documentation and store submission
- **Week 4-6**: Launch marketing and user acquisition

## Common Development Commands

### Running the App
```bash
# Development build with mock subscriptions
./scripts/build/build-dev.sh

# Run directly with Flutter (requires environment setup)
flutter run --dart-define=REVENUECAT_API_KEY=your_key_here

# Run in debug mode with environment file
flutter run
```

### Building for Production
```bash
# Production build (requires actual API keys)
export REVENUECAT_API_KEY="your_actual_api_key"
./scripts/build/build-prod.sh

# Manual production build
flutter build apk --release --dart-define=REVENUECAT_API_KEY=your_key
flutter build appbundle --release --dart-define=REVENUECAT_API_KEY=your_key
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/silence_detector_test.dart
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run linter (no fatal info warnings)
flutter analyze --no-fatal-infos
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build
flutter clean && flutter pub get
```

## AdMob Quick Reference

- Android App ID: `ca-app-pub-2086096819226646~6517708516`
- iOS App ID: `ca-app-pub-2086096819226646~9627636327`
- Android Banner Unit (default): `ca-app-pub-2086096819226646/3553182566`
- iOS Banner Unit (default): `ca-app-pub-2086096819226646/9050063581`
- Dev Mode: test ad unit always; Release: production unit; Optional fallback (QA): `ADS_FALLBACK_TEST_ON_FAIL=true`

## Ambient Quests Implementation Notes (Developers)

Feature flags: see `lib/constants/ambient_flags.dart`
- FF_QUESTS, FF_AMBIENT_SCORE, FF_ADAPTIVE_THRESHOLD (true)
- FF_ACTIVE_PROFILES, FF_HEALTH_SYNC, FF_CALENDAR_EXPORT (false)

### ✅ Completed (P0 - Oct 9-10, 2025):
- ✅ **Ambient Session Engine**: Full lifecycle integration (start/tick/end)
- ✅ **Ambient Score**: Real-time calculation (`quietSeconds / actualSeconds`)
- ✅ **Quest System**: Daily rollover, monthly freeze tokens, 2-Day Rule streaks
- ✅ **Activity Profiles**: Persist selected profile with `requiresSilence` flag
- ✅ **Parity Logging**: Tracks live calm% vs ambient score (±1% tolerance)
- ✅ **Background Safety**: Android STOP action and Deep Focus breach handling
- ✅ **Analytics Widgets**: Heatmap (12-week), Today Timeline, Weekly Target Line

### 🔄 In Progress (P1):
- ⏳ Quest Capsule card on Home (above Today's Goals) showing daily goal progress
- ⏳ Ambient Score inner ring label for live calm% display
- ⏳ Adaptive Threshold chip after 3 wins (suggest +2 dB; ask before applying)
- ⏳ iOS Live Activities (parity with Android ongoing notification)

### 📋 Deferred (P2):
- Health/Calendar integrations (behind flags)
- Multi‑mission programs; complex schedulers
- Custom activity profile creation UI

Acceptance criteria: see `docs/development/AmbientQuests_Dev_Spec.md` (Gherkin tests)

---

## Documentation updates

- Mission/Habit documents have been archived in `docs/archive/`
- Use Ambient Quests docs as the single source of truth



## Architecture Overview

### State Management
- **Riverpod** with `hooks_riverpod` for reactive state management
- **Provider Pattern** with dedicated notifiers for different concerns
- **Async State Handling** using AsyncValue for loading/error states

### Core Services Architecture
- **SilenceDetector** (`lib/services/silence_detector.dart`): Core noise monitoring using `noise_meter` package ✅
- **StorageService** (`lib/services/storage_service.dart`): Data persistence with SharedPreferences ✅
- **SubscriptionService** (`lib/services/subscription_service.dart`): ✅ **COMPLETE** RevenueCat integration for premium features
- **ExportService** (`lib/services/export_service.dart`): Data export functionality (CSV/PDF) ✅
- **AnalyticsService** (`lib/services/analytics_service.dart`): User behavior tracking ✅
- **NotificationService** (`lib/services/notification_service.dart`): Smart reminders and session tracking ✅
- **SupportService** (`lib/services/support_service.dart`): Email support with device info ✅

### Key Providers
- **SilenceDataNotifier** (`lib/providers/silence_provider.dart`): Session data and statistics ✅
- **SubscriptionProvider** (`lib/providers/subscription_provider.dart`): ✅ **COMPLETE** Premium feature management
- **AmbientSessionEngine** (`lib/providers/ambient_quest_provider.dart`): ✅ Real-time ambient score tracking with 1Hz ticks
- **QuestStateController** (`lib/providers/ambient_quest_provider.dart`): ✅ Daily goals, streak management, rollover logic, per-activity minute tracking
- **SelectedProfileNotifier** (`lib/providers/ambient_quest_provider.dart`): ✅ Persisted activity profile selection
- **UserPreferencesNotifier** (`lib/providers/user_preferences_provider.dart`): ✅ **NEW** Manages enabled activities, global goal, last duration per profile
- **AdaptiveThresholdNotifier** (`lib/providers/adaptive_threshold_provider.dart`): ✅ Tracks consecutive wins, suggests threshold increase after 3 successes
- **activeSessionDurationProvider** (`lib/providers/silence_provider.dart`): ✅ Temporary session duration overrides for quick selectors
- **activeDecibelThresholdProvider** (`lib/providers/silence_provider.dart`): ✅ Temporary threshold overrides for quick selectors
- **ThemeProvider** (`lib/providers/theme_provider.dart`): App theming with System/Light/Dark modes ✅
- **NotificationProvider** (`lib/providers/notification_provider.dart`): Smart reminder state management ✅
- **AccessibilityProvider** (`lib/providers/accessibility_provider.dart`): Accessibility features ✅

### Main Screens
- **AppInitializer** (`lib/screens/app_initializer.dart`): App startup with data loading and permission checks
- **HomePage** (`lib/screens/home_page.dart`): Main interface with progress ring, noise chart, and controls
- **SettingsSheet** (`lib/screens/settings_sheet.dart`): Tabbed settings (Basic/Advanced/About)

### Key Widgets
- **ProgressRing** (`lib/widgets/progress_ring.dart`): Interactive session control with countdown timer ✅
- **RealTimeNoiseChart** (`lib/widgets/real_time_noise_chart.dart`): Live decibel visualization with quick threshold selectors ✅
- **SessionHistoryGraph** (`lib/widgets/session_history_graph.dart`): Historical performance tracking ✅
- **SessionHeatmap** (`lib/widgets/session_heatmap.dart`): ✅ 12-week GitHub-style activity heatmap
- **TodayTimelineWidget** (`lib/widgets/today_timeline_widget.dart`): ✅ 24-hour timeline with session dots
- **WeeklyRecapCard** (`lib/widgets/weekly_recap_card.dart`): ✅ Weekly progress summary with achievements
- **QuestCapsule** (`lib/widgets/quest_capsule.dart`): ✅ Ultra-minimal daily quest progress (progress bar, streak, freeze token)
- **AdaptiveThresholdChip** (`lib/widgets/adaptive_threshold_chip.dart`): ✅ Threshold suggestion chip after 3 consecutive wins
- **ActivityEditSheet** (`lib/widgets/activity_edit_sheet.dart`): ✅ **NEW** Bottom sheet for customizing visible activities and daily goal (Material 3 icons, scrollable, 85% height)
- **TabbedOverviewWidget** (`lib/widgets/tabbed_overview_widget.dart`): ✅ Space-optimized tabbed container combining Practice Overview + Advanced Analytics
- **QuickDurationSelector** (`lib/widgets/quick_duration_selector.dart`): ✅ Compact session duration buttons with premium integration
- **QuickDecibelSelector** (`lib/widgets/quick_decibel_selector.dart`): ✅ Instant threshold adjustment buttons (20, 40, 60, 80 dB)
- **FeatureGate** (`lib/widgets/feature_gate.dart`): ✅ **COMPLETE** Premium feature access control
- **PaywallWidget** (`lib/widgets/paywall_widget.dart`): ✅ **COMPLETE** Subscription management UI
- **AdvancedAnalyticsWidget** (`lib/widgets/advanced_analytics_widget.dart`): Premium analytics dashboard ✅
- **NotificationSettingsWidget** (`lib/widgets/notification_settings_widget.dart`): Smart reminder configuration ✅
- **ThemeSelectorWidget** (`lib/widgets/theme_selector_widget.dart`): Advanced theme selection ✅

## Environment Configuration

### Development Setup ✅ **COMPLETE**
1. ✅ `.env` file configured with actual API keys
2. ✅ RevenueCat API key: `<REVENUECAT_API_KEY>`
3. ✅ Mock subscriptions enabled for development testing
4. ✅ Build scripts ready for development and production

### Current Environment Configuration ✅ **READY**
- `REVENUECAT_API_KEY`: ✅ Platform-specific keys configured
  - **iOS**: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
  - **Android**: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- `FIREBASE_API_KEY`: ✅ Configured for analytics (optional)
- `IS_DEVELOPMENT`: ✅ `false` (production mode enabled)
- `ENABLE_MOCK_SUBSCRIPTIONS`: ✅ `false` (real payments for production)

### Build Scripts
- `./scripts/build/build-dev.sh`: Development build with mock subscriptions
- `./scripts/build/build-prod.sh`: Production build with validation

## Core Business Logic

### Silence Detection
- Uses `noise_meter` package to monitor ambient decibel levels
- Default threshold: 38 dB (configurable 20-80 dB)
- Real-time monitoring at 200ms intervals during sessions
- Ambient monitoring at 1Hz when not in active session
- Exponential moving average for noise smoothing

### Point System
- 1 point per minute of successful silence session
- Sessions can be 1-120 minutes (configurable)
- Daily streak tracking with best performance records
- Achievement system with confetti celebrations

### Premium Features (RevenueCat Integration)
- **Premium ($1.99/month)**: Extended sessions (1h, 1.5h, 2h), advanced analytics, data export
- **Premium Plus ($3.99/month)**: Cloud sync, AI insights, multi-environment profiles
- Mock subscriptions available for development/testing

## Recent UI/UX Enhancements ✅ **LATEST UPDATES**

### Quick Selector System
- **Duration Selectors**: Instant access buttons (1, 5, 10, 15, 30 min + premium 1h, 1.5h, 2h) above progress ring
- **Decibel Selectors**: Quick threshold adjustment buttons (20, 40, 60, 80 dB) integrated in noise level widget header
- **Premium Integration**: Premium duration buttons show professional paywall for free users
- **Temporary Override Pattern**: Uses `activeSessionDurationProvider` and `activeDecibelThresholdProvider` for real-time adjustments without affecting persistent settings
- **Responsive Design**: Single-line layout that adapts to different screen sizes

### Tabbed Overview Widget - Space Optimization
- **Combined Layout**: Merges Practice Overview and Advanced Analytics into tabbed interface
- **Space Savings**: ~80px vertical space freed for advertisement placement
- **Overview Tab**: Compact stats (Points, Streak, Sessions) + 7-day activity chart with side-by-side layout
- **Analytics Tab**: Full premium analytics experience (6 performance metrics, trends chart with moving averages, AI insights)
- **Dynamic Height**: Automatically adjusts container size (80px for Overview, 500px for Analytics)
- **Premium Gating**: Analytics tab shows paywall for free users, full content for premium subscribers
- **Tab Controller**: Smooth animations and state management with proper lifecycle handling

### Enhanced User Experience
- **No Advertisement Interference**: Premium users get full screen real estate without ad space constraints
- **Professional Paywall Integration**: Consistent upgrade flow using existing `showPaywall()` system
- **Real-time Feedback**: Immediate visual response to threshold and duration changes
- **Data-driven Charts**: 7-day activity chart shows actual session data with bar heights based on points earned
- **Accessibility**: All components follow Material 3 design guidelines with proper contrast and touch targets

### ✅ **TABLET & RESPONSIVE DESIGN COMPLETE** (Oct 12, 2025)

#### Design Philosophy
- **Phone-First**: Optimized for 4.7"-6.7" smartphones (primary use case)
- **Tablet-Adaptive**: Proportional scaling + intelligent layouts for 7"-13" tablets
- **No Redundancy**: Single ad placement, no duplicate content
- **Master-Detail Pattern**: Landscape tablets show Today + Expanded Trends side-by-side

#### Responsive Breakpoints
```dart
class ScreenBreakpoints {
  static const double phone = 600;      // < 600dp = phone
  static const double tablet = 840;     // 600-840dp = small tablet
  static const double desktop = 1024;   // > 840dp = large tablet/desktop
}
```

#### Tablet Layout Strategy

**Portrait Mode (all tablets):**
- Keep phone layout with proportional scaling
- Scale fonts: 1.15x (small tablet), 1.25x (large tablet)
- Scale widgets: rings +20-35%, touch targets +20%
- Increase padding: +20% spacing throughout

**Landscape Mode (tablets ≥840dp):**
- **Split-Screen Pattern** (50/50 split):
  - **Left Panel (Today - 50%)**: Today tab content
    - Sessions widget (activity rings + overall progress)
    - Quest capsule (daily motivation)
    - Patterns summary with "Show More" link
    - **Single ad placement** (footer) ✅
  - **Right Panel (Sessions - 50%)**: Sessions tab content
    - Activity selection chips (Study/Reading/Meditation)
    - Daily progress indicator (0/10 min)
    - Room loudness monitoring
    - Duration selector chips (1, 5, 10, 15, 30 min + premium)
    - Progress ring with Start button
    - **No advertisement** (cleaner interaction space) ✅

**Orientation Policy** (✅ Implemented):
- **Phones & Small Tablets (<840dp)**: ✅ **Portrait-only** (landscape disabled to protect ad visibility)
- **Large Tablets (≥840dp)**: ✅ **All orientations allowed** (landscape enables master-detail layout)
- **Dynamic Locking**: Orientation restrictions update automatically based on screen width
- **Ad Protection**: Landscape mode on small screens would hide footer ads, so it's disabled

**Implementation**:
- `OrientationLocker` widget in `lib/main.dart` monitors screen width
- Uses `SystemChrome.setPreferredOrientations()` to enforce policy
- Updates orientation restrictions on screen size changes

**Why This Approach:**
- ✅ **Single ad placement** - Only in Today panel (left), not Sessions panel (avoids duplicate ads)
- ✅ **Simultaneous access** - Both Today and Sessions tabs visible without switching
- ✅ **Glanceable progress** - See daily goals and start sessions side-by-side
- ✅ **Natural workflow** - Review progress (left), start session (right)
- ✅ **Maximized interaction space** - Sessions panel clean without ads for better UX

#### Adaptive Sizing Formula
```dart
// Typography scaling
double getTextScale(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 1.0;          // Phone
  if (width < 840) return 1.15;         // Small tablet
  return 1.25;                          // Large tablet (max)
}

// Widget proportional sizing
double getProgressRingSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 206;          // Phone: 206px
  if (width < 840) return 240;          // Small tablet: +16%
  return 280;                           // Large tablet: +36%
}
```

#### Implementation Status
- ✅ **Complete**: Responsive utilities and breakpoints (`lib/utils/responsive_utils.dart`)
- ✅ **Complete**: Adaptive text scaling (main.dart builder)
- ✅ **Complete**: Widget proportional sizing (all major widgets updated)
- ✅ **Complete**: Orientation locking (portrait-only for phones/small tablets)
- ✅ **Complete**: Tablet landscape split-screen layout (≥840dp)
  - Left panel: Today tab with ad at bottom
  - Right panel: Sessions tab without ad
  - 50/50 split with vertical divider
- ✅ **Complete**: Advertisement placement strategy
  - Portrait mode: Ads in both tabs (normal behavior)
  - Landscape mode (tablets ≥840dp): Ad only in Today panel (left side)
  - Conditional rendering via `showAd` parameter in tab builders
- ✅ **Fixed**: Trends sheet overflow (7-day chart bar spacing)
- ✅ **Fixed**: Removed duplicate ads from tablet landscape panels

#### Testing Checklist
- [ ] Test on 7" tablet (600x1024 portrait/landscape)
- [ ] Test on 10" tablet (800x1280 portrait/landscape)
- [ ] Test on 12.9" iPad Pro (1024x1366 portrait/landscape)
- [ ] Verify touch targets ≥48x48dp on all sizes
- [ ] Verify single ad placement in landscape
- [ ] Verify text scaling doesn't break layouts

## Data Models

### Core Models
- **SilenceData** (`lib/models/silence_data.dart`): Session statistics and user progress
- **SubscriptionTier** (`lib/models/subscription_tier.dart`): Premium subscription levels

### Data Storage
- Local storage using SharedPreferences with JSON serialization
- No audio recording - only decibel level measurements
- Data export functionality for session history and statistics

## Testing Strategy

### Unit Tests
- Silence detection logic validation
- Data model serialization/deserialization
- Core service functionality

### Widget Tests
- UI component rendering and interaction
- Theme switching and responsive layout
- Form validation and user input handling

### Key Test Files
- `test/silence_detector_test.dart`: Core noise detection logic
- `test/widget_test.dart`: UI component validation

## Development Notes

### Permissions
- **Microphone**: Required for ambient noise monitoring
- **iOS**: NSMicrophoneUsageDescription in Info.plist
- **Android**: RECORD_AUDIO permission in AndroidManifest.xml
- Privacy-focused: Only measures decibel levels, no audio recording

### Performance Considerations
- Reduced update frequencies for better battery life
- Noise smoothing algorithms to prevent UI flickering
- Efficient state management with Riverpod providers
- Optimized chart rendering with fl_chart

### Theme System
- Material 3 design with dynamic color support
- Three modes: System, Light, Dark themes
- Custom AppTheme with purple night mode
- Consistent color scheme across all components

## Business Context

### Market Position
- **First-to-Market**: Creating the silence measurement app category
- **Target Markets**: Individual productivity users, enterprise teams, educational institutions
- **Revenue Model**: Freemium SaaS with dual-tier subscription system
- **Launch Strategy**: Phase 1 Premium ($1.99/month), Phase 2 Premium Plus ($3.99/month)

### Business Metrics & Goals
- **Year 1 Target**: 15,000 downloads with 8% Premium conversion
- **Revenue Goal**: $19,080 ARR in Year 1
- **Markets**: US, Canada, UK, Australia (English-speaking primary markets)
- **Enterprise Focus**: B2B features and team management capabilities planned

## Monetization System

### Subscription Tiers
- **Free Tier**: Basic silence detection, 20 session history limit, 30-minute sessions
- **Premium Tier ($1.99/month)**: Unlimited history, 60-minute sessions, advanced analytics, data export, premium themes
- **Premium Plus Tier ($3.99/month)**: Cloud sync, AI insights, multi-environment profiles, social features (Phase 2)

### RevenueCat Integration
- Centralized subscription management through RevenueCat
- Mock subscriptions available for development (`ENABLE_MOCK_SUBSCRIPTIONS=true`)
- Feature gating system with `FeatureGate` widget
- Subscription validation and restoration functionality

### Environment Configuration
```bash
# Required for production
REVENUECAT_API_KEY=your_actual_key
IS_DEVELOPMENT=false
ENABLE_MOCK_SUBSCRIPTIONS=false

# Development defaults
REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
IS_DEVELOPMENT=true
ENABLE_MOCK_SUBSCRIPTIONS=true
```

## Documentation Structure

### Comprehensive Documentation (`docs/` folder)
- **Business Strategy** (`docs/business/`): Launch plans, revenue strategy, market analysis
- **Architecture** (`docs/architecture/`): System design and technical overview
- **Development** (`docs/development/`): Setup guides and contribution guidelines
- **Deployment** (`docs/deployment/`): Platform-specific deployment guides
- **User Documentation** (`docs/user/`): User guides and tutorials
- **API Reference** (`docs/api/`): Complete API documentation

### Key Business Documents
- `docs/business/phase1-launch-plan.md` - Immediate launch strategy with detailed timeline
- `docs/MONETIZATION_SETUP.md` - Complete subscription system setup guide
- `docs/business/revenue-strategy.md` - Financial projections and monetization approach
- `docs/business/roadmap.md` - 24-month technical and product development timeline

## Code Conventions

### File Organization
```
lib/
├── constants/     # App-wide constants and configuration
├── models/        # Data models with JSON serialization (includes SubscriptionTier)
├── providers/     # Riverpod state management (includes SubscriptionProvider)
├── screens/       # Main UI screens and navigation
├── services/      # Business logic and external API integration (includes SubscriptionService)
├── theme/         # App theming and design system
├── widgets/       # Reusable UI components (includes FeatureGate, PaywallWidget)
└── main.dart      # App entry point with provider setup
```

### Business Logic Patterns
- **Feature Gating**: All premium features wrapped in `FeatureGate` widgets
- **Subscription Management**: Centralized through `SubscriptionProvider`
- **Revenue Tracking**: Analytics service for subscription events
- **Export Functionality**: PDF/CSV generation for premium users

### State Management Patterns
- Use AsyncNotifier for complex state with async operations
- Implement proper error handling with AsyncValue
- Follow Riverpod best practices for provider dependencies
- Use ref.watch() for reactive updates, ref.read() for one-time access

### Premium Feature Development ✅ **COMPLETE**
- ✅ All premium features implement feature gating with `FeatureGate` widgets
- ✅ Both free and premium user experiences tested with mock subscriptions
- ✅ Graceful degradation for free tier users with upgrade prompts
- ✅ Subscription prompts and upgrade flows fully implemented

## 🚀 **CURRENT LAUNCH STATUS - JULY 27, 2025**

### ✅ **PHASE 1 MONETIZATION COMPLETE**
**Status: READY FOR APP STORE SUBMISSION**

#### Technical Implementation: 100% Complete
- ✅ **RevenueCat Integration**: Complete IAP system with API key configured
- ✅ **Subscription Tiers**: Premium ($1.99/month), Premium Plus ($3.99/month)  
- ✅ **Feature Gating**: All premium features properly restricted
- ✅ **Paywall UI**: Professional subscription purchase interface
- ✅ **State Management**: Riverpod providers for subscription state
- ✅ **Package ID**: Updated to `io.sparkvibe.focusfield` (iOS & Android)
- ✅ **Build Verification**: Android APK builds successfully with monetization
- ✅ **Mock Testing**: Development mode allows testing without real payments

#### Revenue System: Production Ready
- ✅ **API Configuration**: Platform-specific RevenueCat API keys configured
  - **iOS**: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
  - **Android**: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- ✅ **Product IDs**: Premium and Premium Plus subscription products defined
- ✅ **Billing Cycles**: Monthly and yearly options implemented
- ✅ **Feature Restrictions**: Free tier limited to 30-minute sessions, 7-day history
- ✅ **Premium Benefits**: 120-minute sessions, 90-day history, advanced analytics, export

#### Implementation Timeline: Ahead of Schedule
- **Week 1**: ✅ **COMPLETE** - Monetization infrastructure (planned for Days 1-4)
- **Week 2**: 📋 **NEXT** - Platform configuration and visual assets  
- **Week 3**: 📋 **UPCOMING** - Legal documentation and store submission
- **Week 4-6**: 📋 **PLANNED** - Launch marketing and user acquisition

### 📋 **IMMEDIATE NEXT ACTIONS**
1. **App Store Connect**: Configure subscription products with Apple
2. **Google Play Console**: Configure subscription products with Google
3. **Visual Assets**: Create professional app icons and store screenshots
4. **Legal Documents**: Finalize privacy policy and terms of service

### 🎯 **LAUNCH READINESS**
- **Technical**: ✅ 100% Complete (ahead of 6-week timeline)
- **Platform Setup**: 📋 Pending (Week 2 priority)
- **Marketing Assets**: 📋 Pending (Week 2-3)
- **Revenue Generation**: ✅ Ready (switch `ENABLE_MOCK_SUBSCRIPTIONS=false`)

**The app is immediately ready for revenue generation once platform subscriptions are configured.**