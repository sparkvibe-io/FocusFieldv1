# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Focus Field is a comprehensive Flutter mobile app that measures ambient silence and awards points for maintaining quiet environments. It represents a first-to-market opportunity in the silence measurement category, combining workplace wellness, productivity technology, and ambient environmental monitoring. The app features real-time noise monitoring, session tracking, achievements, and a sophisticated subscription-based monetization system with multiple premium tiers.

## 🚀 CURRENT STATUS — Oct 5, 2025: Today Goal Bar, Activity Chips, Inline Noise Panel, Ads
### Product Principles (Always)
- No scrolling on main pages (Home/Summary/Activity). Use compact components, tabs, and carousels to fit without vertical scroll.
- Advertisements are always visible (anchored adaptive banner), never obscured by overlays or long content.
- Material 3 with minimal, non‑repeatable content. Prefer concise, unique information over duplicated elements.


Highlights since last update:
- New Home: `HomePageElegant` with Summary and Activity tabs is live (Legacy home retained).
- Activity tab: duration chips (1–120m; premium-gated), glowing progress ring with Start/Stop, compact status line.
- Today compact goal bar: Per‑activity X/Y minutes with slim progress and percent chip appears under the activity chips; uses activity color and adds a subtle glow at 5 minutes (micro‑win). Progress updates automatically after each successful session.
- Inline Noise Visualization: `InlineNoisePanel` toggles Text ↔ Chart inline; `RealTimeNoiseChart` header shows current dB instead of a duplicate title; padding reduced to preserve ad visibility.
- Ads: Footer banner is consistently visible on Activity after compaction passes.
- Deprecations: Color API modernized (withValues), RevenueCat purchase API upgraded to `Purchases.purchase(PurchaseParams.package(...))`.
- Accessibility: Confetti and accessibility feedback on session success; status announcements wired.

Ignition Capsule integration (Mission):
- A compact rocket “Mission capsule” with stages (Pre‑flight → Ignition → Lift‑off → Stage Separation → Orbit) is implemented as `MissionCapsule` and can be merged visually with Today’s Mission.
- The attached “Ignition” mock aligns with our capsule; plan is to render Today’s Mission as the upper row (title + CTA) and host the capsule body below: stage label on the left, slim progress bar across, and a mini ring at top‑right showing percent.
- Wire: `Feature flag` controls visibility via `AppConstants.featureMissionsUi` (Dart define FEATURE_MISSIONS_UI=true).

Developer notes (compactness and ad safety):
- Duration chips hide while a session is running; inter-chip spacing and paddings reduced.
- Chart height trimmed (approx 110–116 px) and container paddings tightened; threshold quick chips remain available when not listening.
- Right stats rail for Points/Streak/Sessions nests in a darker card to declutter the main list.

Open items:
- Finish merging Today’s Mission card and Mission Capsule into a single cohesive “Mission” card on Summary.
- Optional: shrink inline chart a few more pixels on compact devices; convert Chart/Text toggles to icon‑only below a width threshold.
- Lint polish (const hints, minor style) — non‑functional.

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

### 🌙 Mission-Based Habit Builder (Month Scale)
- Direction: Move beyond weekly stats into a month-long "Mission" with stages (Ignition → Lift-off → Stage Separation → Orbit) driven by tiny daily goals (default 1 minute/activity).
- Home must remain calm and uncluttered. Noise widget becomes activity-aware (compact by default; full chart only when relevant or expanded).
- Phase 1 has been APPROVED (see docs/development/habit-tracking-plan.md) and should be gated behind a feature flag.

Feature flag:
- `FEATURE_MISSIONS_UI` (default false; already wired as `AppConstants.featureMissionsUi`). When true, show: Activity chips, Mission capsule (rocket with stages), Daily goal ring, compact noise panel with expand.

Developer constraints:
- Keep primary surface simple; avoid crowding the home page.
- Compact noise chart by default; full chart via explicit expand or when activity requires silence (e.g., Meditation, Study, Noise Monitor).
- Respect accessibility (reduced motion), ad safety spacing, and localization length.
- **Development Mode**: ✅ Mock subscriptions available for testing

### 📋 Immediate Next Steps
1. **App Store Connect**: Configure subscription products
2. **Google Play Console**: Configure subscription products  
3. **Visual Assets**: Create app icons and store screenshots
4. **Legal Documents**: Finalize privacy policy and terms of service
5. **Ad Serving**: Allow time for new iOS banner unit to begin serving; validate fill; consider anchored adaptive size
6. Mission UI: Merge Today’s Mission + Mission Capsule; align to attached “Ignition” look (stage label left, slim bar, mini ring percent top‑right).
7. Home Migration: Implement habit‑forming dashboard elements per `docs/development/home_migration_plan.md` (activity chips, per‑activity daily goal compact bar ✅, 7‑day stacked bars, today timeline, compliments strip, heatmap entry, weekly recap) while enforcing: no-scroll main tabs, always-visible ads, and M3 minimalism.

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

## Phase 1 Implementation Notes (Developers)

Scope (behind `FEATURE_MISSIONS_UI`):
- Activity chips + provider, persistence of last selection
- Mission model with fixed 30-day window, default per-activity goal 1 minute/day
- Mission capsule (rocket stages): Pre‑flight, Ignition, Lift‑off, Stage Separation, Orbit
- Daily goal ring for selected activity
- Noise widget modes: off/compact/full; compact = sparkline + dB badge; full = existing chart
- First 1-minute session celebration (balloons/confetti)

Non-goals (Phase 1):
- No multi-mission Programs, no heatmap yet, no export
- No complex notification scheduler changes; reuse existing daily reminder with adjusted copy

Acceptance Criteria:
- Home stays visually calm, no vertical crowding
- Users can complete a 1-minute session immediately after onboarding and see a brief celebration
- Mission stage transitions are deterministic and recorded locally

---

## Habit‑Forming Dashboard Migration Plan (Oct 5, 2025)

See `docs/development/home_migration_plan.md` for a living plan. Summary:

- What’s live now: Two‑tab Home (Summary/Activity), Quick Duration chips, ProgressRing with Start/Stop, InlineNoisePanel with live dB header, anchored banner ad, Mission capsule behind feature flag, confetti/a11y, updated purchases API.
- To migrate from legacy Home: settings entry, theme selector access, tips/compliments surface, activity selector chips, per‑activity daily goal ring, 7‑day stacked bars by activity, today timeline strip, heatmap entry, weekly recap. Free vs Premium gating preserved.
- Phases: 0) instrumentation, 1) overview upgrades (chips/ring/stacked bars/timeline), 2) compliments & nudges, 3) heatmap + weekly recap, 4) premium insights (already implemented) & A/B tests.
- Quality gates: analyzer clean, ad safety (no overlap), 44px touch targets, reduced motion honored, localization length.



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
- **activeSessionDurationProvider** (`lib/providers/silence_provider.dart`): ✅ **NEW** Temporary session duration overrides for quick selectors
- **activeDecibelThresholdProvider** (`lib/providers/silence_provider.dart`): ✅ **NEW** Temporary threshold overrides for quick selectors
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
- **TabbedOverviewWidget** (`lib/widgets/tabbed_overview_widget.dart`): ✅ **NEW** Space-optimized tabbed container combining Practice Overview + Advanced Analytics
- **QuickDurationSelector** (`lib/widgets/quick_duration_selector.dart`): ✅ **NEW** Compact session duration buttons with premium integration
- **QuickDecibelSelector** (`lib/widgets/quick_decibel_selector.dart`): ✅ **NEW** Instant threshold adjustment buttons (20, 40, 60, 80 dB)
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