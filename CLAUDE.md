# CLAUDE.md

This file provides guidance to Claude Code when working with the Focus Field codebase.

> **Historical Logs**: All completion logs moved to [`docs/development/CHANGELOG.md`](docs/development/CHANGELOG.md)

---

## 🎯 Quick Start

```bash
# Development build (with mock subscriptions)
./scripts/build/build-dev.sh

# Run on iOS/Android
./scripts/run/ios.sh --debug
./scripts/run/android.sh --debug

# Run tests
./scripts/testing/test.sh
./scripts/testing/test.sh --coverage

# Tools
./scripts/tools/check-localizations.sh
./scripts/tools/coverage-summary.sh

# Format & analyze
flutter format . && flutter analyze
```

---

## 🚀 Current Status (Oct 25, 2025)

**MVP Complete - Ready for Platform Configuration**

### ✅ Completed Today (Oct 25)
- **Performance Optimization**: AnimatedBuilder pattern for widget rebuilds
  - Replaced `useAnimation()` with `AnimatedBuilder` in Room Loudness widget
  - Reduced rebuild scope by 95% (only pulse badge rebuilds, not entire widget)
  - Improved battery life and smoother animations
  - File: `lib/widgets/inline_noise_panel.dart`
- **Activity Name Localization**: Fully localized all activity display names
  - Added `getLocalizedActivityName()` helper in `ambient_quest_provider.dart`
  - Updated home page header to show localized activity names (e.g., "学習 • 読書 • 瞑想")
  - Updated shareable cards to use localized names in exported images
  - Files: `home_page_elegant.dart`, `shareable_cards.dart`
- **Session Controls UX**: Improved button layout and visibility
  - Removed "Ambience" label to give buttons more space
  - Restructured layout: Focus Mode (left) | Spacer | Pause + Stop (right)
  - Increased button spacing with `flex: 2` for equal distribution
  - Reduced font to 11pt and padding to 8px for better text fit
  - Full button text now visible in all languages
  - File: `lib/screens/home_page_elegant.dart`
- **Room Loudness Widget Refinement**: Cleaner contextual messaging
  - Removed unnecessary "No" button from threshold suggestions
  - Expanded message text space (70% width vs 50% before)
  - Added fixed height constraint (52px) for consistent layout
  - No more visual jumping between message/threshold selector states
  - File: `lib/widgets/inline_noise_panel.dart`

### ✅ Completed Oct 20
- **i18n Cleanup**: Removed 93 unused FAQ localization keys
- **FAQ System**: 20 comprehensive Q&A entries, fully localized in 7 languages
- **UI Polish**: Redesigned Help & Support section with better tap targets

### What Works Now
- ✅ Ambient Quests system (70% threshold, compassionate credit, 2-day streaks)
- ✅ Focus Mode (full-screen overlay, completion states, long-press controls)
- ✅ Monetization (RevenueCat + AdMob integrated, feature gating complete)
- ✅ Responsive design (phone-first, tablet-adaptive with landscape split-screen)
- ✅ 7 languages (EN, ES, DE, FR, JA, PT, PT_BR) - all core strings localized
- ✅ Onboarding flow (6 screens)
- ✅ **FAQ System** (20 comprehensive Q&A entries with search, fully localized)

### Next Actions
1. Configure App Store Connect & Google Play Console subscriptions
2. Create app icons and store screenshots
3. Finalize legal documents (privacy policy, terms)

### Not Blocking Launch
- iOS Live Activities (Android notification works)
- Focus Mode P2/P3 enhancements (breathing animation, themes)
- Custom activity creation (3 default profiles sufficient)
- ~71 hardcoded UI strings in widgets/screens (non-critical, have fallback text)
  - See `docs/development/i18n_remaining_work.md` for complete list and approach

---

## 📖 Project Overview

**Focus Field** is a Flutter mobile app measuring ambient silence for focus sessions. First-to-market in silence measurement category, combining productivity technology with environmental monitoring.

### Core Concept
- **Real-time noise monitoring** via microphone (decibel levels only, no audio recording)
- **Ambient Score** system: `quietSeconds / actualSeconds` (0.0-1.0)
- **Quest-based progression** with daily goals, streaks, freeze tokens
- **Freemium model**: Premium ($1.99/mo), Premium Plus ($3.99/mo)

---

## ⚡ Product Principles

1. **No Scrolling**: Main pages fit without vertical scroll (compact components, tabs, carousels)
2. **Ads Always Visible**: Anchored adaptive banner, never obscured
3. **Material 3**: Minimal, non-repeatable content (unique information only)
4. **UI Consistency**: All bottom sheets use 85% screen height, drag handles, scrollable content

---

## 🧭 Architecture Quick Reference

### State Management (Riverpod)
```dart
// Reactive state
ref.watch(provider)  // In build methods
ref.read(provider)   // In event handlers
```

### Key Files Lookup

| Component | File Path | Purpose |
|-----------|-----------|---------|
| Noise detection | `lib/services/silence_detector.dart` | Core audio monitoring |
| Ambient scoring | `lib/providers/ambient_quest_provider.dart` | Quest engine, streaks |
| Subscriptions | `lib/services/subscription_service.dart` | RevenueCat integration |
| Main screen | `lib/screens/home_page_elegant.dart` | Tabbed interface |
| Progress ring | `lib/widgets/progress_ring.dart` | Session control |
| Focus Mode | `lib/widgets/focus_mode_overlay.dart` | Full-screen mode |
| Settings | `lib/screens/settings_sheet.dart` | User preferences |

### Core Providers

| Provider | Location | Purpose |
|----------|----------|---------|
| `silenceDataProvider` | `lib/providers/silence_provider.dart` | Session data |
| `questStateProvider` | `lib/providers/ambient_quest_provider.dart` | Daily goals, streaks |
| `userPreferencesProvider` | `lib/providers/user_preferences_provider.dart` | User settings |
| `subscriptionProvider` | `lib/providers/subscription_provider.dart` | Premium status |
| `themeProvider` | `lib/providers/theme_provider.dart` | App theming |

### Feature Flags (`lib/constants/ambient_flags.dart`)

```dart
// Enabled
FF_QUESTS = true
FF_AMBIENT_SCORE = true
FF_ADAPTIVE_THRESHOLD = true

// Disabled (P2)
FF_ACTIVE_PROFILES = false
FF_HEALTH_SYNC = false
FF_CALENDAR_EXPORT = false
```

---

## 🎨 Design System

### Visual Design Patterns
```dart
// Selector button pattern (duration/threshold chips)
// - Selected: Bold + Primary Color
// - Unselected: Normal weight + 70% opacity
// - No backgrounds, minimal padding
// - 48x48dp minimum touch targets

// Duration selectors: 1m 5m 10m 30m ⭐1hr ⭐1.5hr ⭐2hr
// Threshold selectors: 30dB 40dB 50dB 60dB 80dB
```

### Responsive Breakpoints
```dart
class ScreenBreakpoints {
  static const double phone = 600;      // < 600dp
  static const double tablet = 840;     // 600-840dp
  static const double desktop = 1024;   // > 840dp
}
```

### Tablet Layout Strategy
- **Portrait**: Phone layout with proportional scaling (+15-25% fonts, +20-35% widgets)
- **Landscape (≥840dp)**: Split-screen 50/50
  - Left: Today tab + ad footer
  - Right: Sessions tab (no ad)
- **Orientation Lock**: Portrait-only for <840dp (protects ad visibility)

---

## 🧪 Business Logic

### Ambient Score System
```dart
// Calculation (1Hz updates)
ambientScore = quietSeconds / actualSeconds  // Range: 0.0 to 1.0

// Success threshold
session.successful = ambientScore >= 0.70  // 70% quiet

// Compassionate credit
creditedMinutes = quietSeconds / 60  // Proportional points
pointsEarned = creditedMinutes × 1   // 1 point per quiet minute
```

**Example**: 10-minute session, 8 minutes quiet (80% ambient score) → 8 points awarded

### Quest System
- **Daily Goal**: 10-60 minutes (default 20, user-configurable)
- **Streak Rule**: Resets only after 2 consecutive missed days (permissive)
- **Freeze Token**: 1 per month, protects streak + counts as goal completion
- **Activity Profiles**: Study, Reading, Meditation (all use 38 dB threshold)

### Premium Features
| Feature | Free | Premium ($1.99) | Premium Plus ($3.99) |
|---------|------|-----------------|----------------------|
| Session length | 30 min | 120 min | 120 min |
| History | 7 days | 90 days | Unlimited |
| Analytics | Basic | Advanced | AI insights |
| Export | No | CSV/PDF | Cloud sync |
| Focus durations | 1-30 min | + 1h, 1.5h, 2h | + All |

---

## 🔧 Development Conventions

### File Organization
```
lib/
├── constants/     # Feature flags, config
├── models/        # Data models (JSON serialization)
├── providers/     # Riverpod state management
├── screens/       # Main UI screens
├── services/      # Business logic, APIs
├── theme/         # Design system
├── widgets/       # Reusable components
└── main.dart      # App entry
```

### Code Patterns
```dart
// Feature gating
FeatureGate(
  feature: PremiumFeature.extendedSessions,
  child: PremiumContent(),
  fallback: UpgradePrompt(),
)

// Async state handling
ref.watch(dataProvider).when(
  data: (data) => Content(data),
  loading: () => LoadingSpinner(),
  error: (err, stack) => ErrorWidget(err),
)

// Stream subscriptions (always dispose!)
final subscription = stream.listen(handler);
// In dispose:
subscription?.cancel();
```

### Common Commands

| Task | Command |
|------|---------|
| Dev build | `./scripts/build/build-dev.sh` |
| Prod build | `./scripts/build/build-prod.sh` |
| Run tests | `flutter test` |
| Format code | `flutter format .` |
| Analyze | `flutter analyze` |
| Clean | `flutter clean && flutter pub get` |
| Localization | `flutter gen-l10n` |

---

## 🌍 Environment Configuration

### Development (Mock Subscriptions Enabled)
```bash
REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
IS_DEVELOPMENT=true
ENABLE_MOCK_SUBSCRIPTIONS=true
```

### Production
```bash
# iOS
REVENUECAT_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME

# Android
REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf

IS_DEVELOPMENT=false
ENABLE_MOCK_SUBSCRIPTIONS=false
```

### AdMob IDs
```bash
# Android
App ID: ca-app-pub-2086096819226646~6517708516
Banner: ca-app-pub-2086096819226646/3553182566

# iOS
App ID: ca-app-pub-2086096819226646~9627636327
Banner: ca-app-pub-2086096819226646/9050063581
```

---

## 📚 Documentation Structure

### Comprehensive Docs (`docs/`)
- **`business/`**: Launch plans, revenue strategy, market analysis
- **`development/`**: Setup guides, CHANGELOG, implementation specs
- **`deployment/`**: Platform-specific deployment guides
- **`architecture/`**: System design, technical overview
- **`user/`**: User guides, tutorials
- **`api/`**: API documentation

### Key Documents
- [`docs/development/CHANGELOG.md`](docs/development/CHANGELOG.md) - Historical completion logs
- [`docs/development/AmbientQuests_Dev_Spec.md`](docs/development/AmbientQuests_Dev_Spec.md) - Quest system spec
- [`docs/MONETIZATION_SETUP.md`](docs/MONETIZATION_SETUP.md) - Subscription setup guide
- [`docs/business/phase1-launch-plan.md`](docs/business/phase1-launch-plan.md) - Launch timeline
- [`docs/business/roadmap.md`](docs/business/roadmap.md) - 24-month product roadmap

---

## ✅ Testing Strategy

### Unit Tests
- Silence detection logic (`test/silence_detector_test.dart`)
- Data model serialization
- Core service functionality

### Widget Tests
- UI component rendering (`test/widget_test.dart`)
- Theme switching
- Responsive layouts

### Manual Testing Checklist
- [ ] Microphone permissions (iOS NSMicrophoneUsageDescription, Android RECORD_AUDIO)
- [ ] Session lifecycle (start → tick → end → persist)
- [ ] Ambient score calculation accuracy (±1% tolerance)
- [ ] Quest rollover (daily/monthly reset logic)
- [ ] Premium feature gating (paywall triggers)
- [ ] Tablet responsiveness (600dp, 840dp, 1024dp breakpoints)
- [ ] Ad visibility (never obscured by overlays)
- [ ] Localization (all 7 languages render correctly)

---

## 🚨 Performance Guidelines

### Optimization Checklist
- ✅ Debug logs wrapped in `kDebugMode` guards (tree-shaken in release)
- ✅ Stream subscriptions disposed in cleanup methods
- ✅ useEffect hooks return cleanup functions
- ✅ AnimationControllers disposed properly
- ✅ No `ref.watch()` in event handlers (use `ref.read()`)
- ✅ Deprecated APIs migrated (`withOpacity` → `withValues`, etc.)

### Battery Life Considerations
- Noise monitoring at 200ms intervals (efficient)
- Ambient score calculation at 1Hz (low overhead)
- Chart updates throttled to reduce redraws
- Background monitoring optimized (Android STOP action support)

---

## 💼 Business Context

### Market Position
- **First-to-Market**: Creating silence measurement app category
- **Target Markets**: US, Canada, UK, Australia (English-speaking)
- **Revenue Model**: Freemium SaaS, dual-tier subscriptions
- **Year 1 Goal**: 15,000 downloads, 8% conversion, $19,080 ARR

### Launch Timeline (6 Weeks)
- **Week 1**: ✅ Monetization infrastructure (COMPLETE)
- **Week 2**: Platform configuration, visual assets
- **Week 3**: Legal docs, store submission
- **Week 4-6**: Marketing, user acquisition

---

## 🔮 Future Roadmap (P2)

### Focus Mode Enhancements
- Breathing animation (8s cycle: 4s inhale, 4s exhale)
- Icon-only buttons (cleaner minimal design)
- Lock Mode (Premium feature - prevents exit until completion)
- Color themes (Midnight/Ocean/Forest/Sunset)

### Activity System Expansion
- Custom activity creation (user-defined icons, colors, goals)
- Active profiles (non-quiet activities: Fitness, Family, Custom)
- Health sync, calendar export (feature-flagged)

### Support Resources
- In-app FAQ browser
- Documentation widget in Settings
- Web-based help center

**Why Deferred**: MVP validates core value first. P2 features add polish after launch validation.

---

## 🛠️ Permissions & Privacy

- **Microphone**: Required for ambient noise monitoring
  - **iOS**: `NSMicrophoneUsageDescription` in `Info.plist`
  - **Android**: `RECORD_AUDIO` in `AndroidManifest.xml`
- **Privacy-Focused**: Only measures decibel levels, **no audio recording**
- **Data Storage**: Local (SharedPreferences), JSON serialization
- **Export**: CSV/PDF for premium users (session history, statistics)

---

## 📝 Notes for Claude Code

### When Working on This Codebase
1. **Check CHANGELOG first**: Historical context in `docs/development/CHANGELOG.md`
2. **Respect Product Principles**: No scrolling, ads visible, Material 3, UI consistency
3. **Feature flags**: Check `lib/constants/ambient_flags.dart` before implementing features
4. **Localization**: Update all 7 `.arb` files, run `flutter gen-l10n`
5. **Premium features**: Always wrap in `FeatureGate` widget
6. **Tablet support**: Test responsive breakpoints (600dp, 840dp, 1024dp)
7. **Performance**: Wrap debug logs in `kDebugMode`, dispose streams/controllers
8. **Business logic**: Ambient score is **primary success metric** (not legacy average-based)

### Common Pitfalls to Avoid
- ❌ Don't use `ref.watch()` in event handlers (use `ref.read()`)
- ❌ Don't forget stream/controller disposal in cleanup methods
- ❌ Don't hardcode values that should come from providers (e.g., calm %, daily goal)
- ❌ Don't add scrolling to main pages (use tabs/carousels instead)
- ❌ Don't obscure ads with overlays or long content
- ❌ Don't use deprecated APIs (`withOpacity`, `Color.value`, old Share API)

### Legacy Systems to Ignore
- **Mission/Habit System**: Archived in `docs/archive/` (replaced by Ambient Quests)
- **Average-Based Success**: Replaced by Ambient Score system (70% threshold)
- **Emoji Icons**: Replaced with Material Design 3 icons throughout

---

**For detailed technical specs, see linked documentation files above.**
