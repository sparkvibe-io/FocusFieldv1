# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SilenceScore is a comprehensive Flutter mobile app that measures ambient silence and awards points for maintaining quiet environments. It represents a first-to-market opportunity in the silence measurement category, combining workplace wellness, productivity technology, and ambient environmental monitoring. The app features real-time noise monitoring, session tracking, achievements, and a sophisticated subscription-based monetization system with multiple premium tiers.

## 🚀 **CURRENT STATUS - JULY 27, 2025: MONETIZATION COMPLETE**

### ✅ **READY FOR LAUNCH - Phase 1 Monetization Complete**
- **RevenueCat Integration**: ✅ Complete with API key `sk_OhKOxLUKPtKeNBNWPYGJYoJuVSkOk`
- **Subscription System**: ✅ Premium ($1.99/month), Premium Plus ($3.99/month)
- **Feature Gating**: ✅ All premium features properly restricted
- **Paywall UI**: ✅ Professional subscription interface implemented
- **Package ID**: ✅ Updated to `io.sparkvibe.silencescore` (iOS & Android)
- **Build Verification**: ✅ Android APK builds successfully with monetization
- **Development Mode**: ✅ Mock subscriptions enabled for testing

### 📋 **IMMEDIATE NEXT STEPS (This Week)**
1. **App Store Connect**: Configure subscription products
2. **Google Play Console**: Configure subscription products  
3. **Visual Assets**: Create app icons and store screenshots
4. **Legal Documents**: Finalize privacy policy and terms of service

### 🎯 **Launch Timeline: 6 Weeks Total (Week 1 Complete)**
- **Week 1**: ✅ Monetization infrastructure (COMPLETE - AHEAD OF SCHEDULE)
- **Week 2**: Platform configuration and visual assets
- **Week 3**: Legal documentation and store submission
- **Week 4-6**: Launch marketing and user acquisition

## Common Development Commands

### Running the App
```bash
# Development build with mock subscriptions
./scripts/build-dev.sh

# Run directly with Flutter (requires environment setup)
flutter run --dart-define=REVENUECAT_API_KEY=your_key_here

# Run in debug mode with environment file
flutter run
```

### Building for Production
```bash
# Production build (requires actual API keys)
export REVENUECAT_API_KEY="your_actual_api_key"
./scripts/build-prod.sh

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
- **ThemeProvider** (`lib/providers/theme_provider.dart`): App theming with System/Light/Dark modes ✅
- **NotificationProvider** (`lib/providers/notification_provider.dart`): Smart reminder state management ✅
- **AccessibilityProvider** (`lib/providers/accessibility_provider.dart`): Accessibility features ✅

### Main Screens
- **AppInitializer** (`lib/screens/app_initializer.dart`): App startup with data loading and permission checks
- **HomePage** (`lib/screens/home_page.dart`): Main interface with progress ring, noise chart, and controls
- **SettingsSheet** (`lib/screens/settings_sheet.dart`): Tabbed settings (Basic/Advanced/About)

### Key Widgets
- **ProgressRing** (`lib/widgets/progress_ring.dart`): Interactive session control with countdown timer ✅
- **RealTimeNoiseChart** (`lib/widgets/real_time_noise_chart.dart`): Live decibel visualization using fl_chart ✅
- **SessionHistoryGraph** (`lib/widgets/session_history_graph.dart`): Historical performance tracking ✅
- **FeatureGate** (`lib/widgets/feature_gate.dart`): ✅ **COMPLETE** Premium feature access control
- **PaywallWidget** (`lib/widgets/paywall_widget.dart`): ✅ **COMPLETE** Subscription management UI
- **AdvancedAnalyticsWidget** (`lib/widgets/advanced_analytics_widget.dart`): Premium analytics dashboard ✅
- **NotificationSettingsWidget** (`lib/widgets/notification_settings_widget.dart`): Smart reminder configuration ✅
- **ThemeSelectorWidget** (`lib/widgets/theme_selector_widget.dart`): Advanced theme selection ✅

## Environment Configuration

### Development Setup ✅ **COMPLETE**
1. ✅ `.env` file configured with actual API keys
2. ✅ RevenueCat API key: `sk_OhKOxLUKPtKeNBNWPYGJYoJuVSkOk`
3. ✅ Mock subscriptions enabled for development testing
4. ✅ Build scripts ready for development and production

### Current Environment Configuration ✅ **READY**
- `REVENUECAT_API_KEY`: ✅ `sk_OhKOxLUKPtKeNBNWPYGJYoJuVSkOk` (CONFIGURED)
- `FIREBASE_API_KEY`: ✅ Configured for analytics (optional)
- `IS_DEVELOPMENT`: ✅ `true` (development mode enabled)
- `ENABLE_MOCK_SUBSCRIPTIONS`: ✅ `true` (mock payments for testing)

### Build Scripts
- `./scripts/build-dev.sh`: Development build with mock subscriptions
- `./scripts/build-prod.sh`: Production build with validation

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
- **Premium ($1.99/month)**: Extended sessions, advanced analytics, data export
- **Premium Plus ($3.99/month)**: Cloud sync, AI insights, multi-environment profiles
- Mock subscriptions available for development/testing

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
- **Free Tier**: Basic silence detection, 20 session history limit, 5-minute sessions
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
- ✅ **Package ID**: Updated to `io.sparkvibe.silencescore` (iOS & Android)
- ✅ **Build Verification**: Android APK builds successfully with monetization
- ✅ **Mock Testing**: Development mode allows testing without real payments

#### Revenue System: Production Ready
- ✅ **API Configuration**: RevenueCat API key `sk_OhKOxLUKPtKeNBNWPYGJYoJuVSkOk`
- ✅ **Product IDs**: Premium and Premium Plus subscription products defined
- ✅ **Billing Cycles**: Monthly and yearly options implemented
- ✅ **Feature Restrictions**: Free tier limited to 5-minute sessions, 7-day history
- ✅ **Premium Benefits**: 60-minute sessions, unlimited history, advanced analytics, export

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