# Focus Field – AI Review Brief: Current Status, Architecture, and Feature Proposals (Oct 6, 2025)

This self-contained brief is designed for AI assistants or product reviewers to quickly understand the Focus Field app, its technical/UX constraints, and to evaluate or extend a set of niche, high-demand feature proposals. It includes enough context to research comparable products and user needs and to suggest reasonable alternatives without requiring access to the codebase.

## Purpose of this brief

- Provide a clear snapshot of the product and architecture as of Oct 2025
- Outline UX, privacy, and monetization constraints that all proposals must respect
- Present a curated, realistic feature proposal set with rationale and feasibility
- Offer research guidance and evaluation criteria for generating additional ideas

If you are an AI assistant, please read this document fully before proposing alternatives. Honor constraints and prefer local-first, privacy-preserving enhancements.

---

## 1) Product overview

Focus Field is a Flutter app that helps users build focus and mindfulness habits by measuring ambient silence (decibel levels) and turning quiet minutes into points, streaks, and trends. It’s privacy-first (no audio recorded), ad-safe for free users, and offers premium analytics and capabilities via subscriptions.

Differentiators:
- Measures silence as a habit signal (not a pure timer)
- Micro-goal “Mission” framing for month-long consistency (feature-flagged)
- Minimal, calm main UI with no scrolling and an always-visible ad banner (free tier)

Primary audiences:
- Individuals seeking focus/mindfulness routines (including ADHD-friendly patterns)
- Students and professionals looking for low-friction habit reinforcement

---

## 2) Current status snapshot (Oct 2025)

- Platforms: iOS 15+ and Android 21+
- Tech: Flutter 3.x, Dart 3.x, Riverpod
- Live features:
  - Real-time silence detection using system microphone, no audio recording
  - Session progress ring with countdown and quick duration chips (1–120m; premium-gated for long sessions)
  - Inline noise panel with sparkline/live dB and expandable full chart
  - Points and streak tracking, weekly trends, export (CSV/PDF)
  - Settings & sheets pattern with tabs (Basic/Advanced/About) and icons
  - Trends “Show More” presented as a bottom-sheet with tabs; Basic tab has fixed-height 7‑day stacked bars
  - Local notifications: daily reminder (smart or fixed), weekly summary (premium), achievement/session
  - Monetization: RevenueCat integration, Premium tier; AdMob banner for free users
  - Local-first storage (SharedPreferences); multi-locale i18n in place
- Historical note: prior “Mission” month-scale UI concept is archived; Ambient Quests is the finalized plan.
- Code health: analyzer clean for changed files; performance safeguards for audio/streams

UX standards (critical):
- No vertical scroll on main tabs (Home: Summary/Activity)
- Ads always visible on main tabs for free users
- Non-main pages open as modal bottom sheets with tab icons; swipe disabled; max height ≈85%

---

## 3) Architecture and key components

- UI: Flutter Material 3, compact cards, Riverpod-driven state
- State management: Riverpod (hooks_riverpod), AsyncValue patterns for async workflows
- Services (representative):
  - SilenceDetector (noise_meter-based decibel sampling, 200ms during sessions; 1Hz ambient)
  - StorageService (SharedPreferences JSON)
  - SubscriptionService (RevenueCat via purchases_flutter)
  - NotificationService (local notifications, timezone-aware scheduling)
  - ExportService (CSV/PDF)
  - AnalyticsService (behavior tracking)
- Providers (representative):
  - SilenceDataNotifier: session records, stats, trends
  - SubscriptionProvider: premium access state
  - activeSessionDurationProvider / activeDecibelThresholdProvider: temporary overrides from quick selectors
  - ThemeProvider, NotificationProvider, AccessibilityProvider
- Data model themes:
  - Session record with start/end, activity, threshold, quiet minutes
  - Aggregations for 7‑day trends, weekly totals, best day
  - Points: 1/min of successful silence

Performance and stability:
- Exponential moving average smoothing
- Aggregated stream for charts (reduces rebuild pressure)
- Error boundaries and recovery for audio pipeline

Privacy:
- No audio recording or cloud sync; decibel levels only
- Local storage; exports initiated by user

---

## 4) Monetization and ads

- Subscriptions via RevenueCat
  - Premium ($1.99/mo typical; dynamic pricing via Offerings)
  - Premium Plus (future, deferred)
- Feature gating via FeatureGate + providers
- AdMob anchored banner for free users (test vs prod units; safe load/teardown)

Environment flags (representative):
- REVENUECAT_API_KEY (platform-specific; redact keys in public docs)
- IS_DEVELOPMENT, ENABLE_MOCK_SUBSCRIPTIONS
- Deprecated: FEATURE_MISSIONS_UI (replaced by Ambient Quests feature flags; see `lib/constants/ambient_flags.dart`)

---

## 5) UX and navigation standards (must-keep constraints)

- Main tabs (Summary/Activity) must not scroll vertically
- Free-tier ads must remain visible and unobscured
- Non-main content opens in modal bottom sheets with icon tabs, swipe disabled
- Accessibility: reduced motion honored; large text and contrast supported; 44px targets
- Internationalization: all user-facing text should use l10n keys

---

## 6) Known non-goals and constraints (near term)

- No cloud sync or backend services (local-first only)
- Avoid heavy OS-level website/app blocking and VPN-style features
- Keep additions low-friction and opt-in; avoid streak anxiety
- Maintain minimal UI and ad safety constraints

---

## 7) Research guidance for idea generation

Suggested sources:
- Competitive product reviews (e.g., Zapier’s 2025 best Pomodoro/focus apps)
- App sites: Forest, Session, Flow, Focused Work, Be Focused, Toggl Track (Pomodoro mode)
- Community feedback: Reddit r/productivity (top of year), r/ADHD (top of year)

What to look for:
- Features users consistently praise (e.g., Deep Focus/app-leave deterrents, Live Activities, quick starts)
- Pain points: streak anxiety, too much friction/complexity, context switching
- Lightweight accountability and sharing patterns that don’t require cloud backends

Evaluation criteria:
- Fits local-first, privacy posture, and no-scroll/ad-safety constraints
- Low/medium implementation effort using existing providers/services
- Platform support: graceful fallbacks on older OS versions
- Clear value for target audiences (ADHD-friendly starts, gentle accountability)

Deliverable format for new ideas:
- Name; rationale with 1–2 user quotes/themes from research (paraphrased)
- Fit & dependencies (providers/services touched; flags; premium gating)
- Complexity (S/M/L) and main risks
- Success criteria/acceptance tests

---

## 8) Proposed features (prioritized; low/medium effort, local-first)

Below proposals are designed to be additive, optional, and respectful of constraints. Each includes why it matters, fit, dependencies, effort, risks, gating, and acceptance criteria.

### A) iOS Live Activities + Dynamic Island session countdown (Priority 1)
- Why: Highly requested for glanceability; parity with top Apple timers
- Fit: Presentation-only layer for existing session state
- Dependencies: ActivityKit (iOS 16+), session stream from SilenceData/active session provider
- Effort: Medium (iOS-only native bridge or plugin); gate by iOS version + feature flag
- Risks: iOS version fragmentation; App Store review nuances
- Gating: Free + Premium; enable/disable in Settings
- Acceptance:
  - Live Activity starts within 300ms of session start on supported devices
  - Shows remaining time and Stop action; cleans up reliably on end/cancel
  - Graceful no-op on iOS <16

### B) Android ongoing notification with progress and actions (Priority 1)
- Why: Standard expectation; helps reduce app switching
- Fit: Uses `flutter_local_notifications` with foreground service when needed
- Dependencies: NotificationService; session provider
- Effort: Small/Medium
- Risks: OEM differences; battery optimizations
- Gating: Free + Premium; Settings toggle
- Acceptance:
  - Persistent notification during session with minute countdown and Stop/Extend
  - Survives short app switches; cleans up on end/cancel

### C) Deep Focus mode (leaving app pauses/ends after grace) (Priority 1)
- Why: Forest-style deterrent for phone distractions; ADHD-friendly
- Fit: App lifecycle observer + configurable grace period (e.g., 10s)
- Dependencies: Settings toggle; AccessibilityProvider for haptics
- Effort: Small
- Risks: Accidental loss of progress without clear warnings
- Gating: Optional, off by default; Premium perk for added control (e.g., longer grace/long-press stop)
- Acceptance:
  - If backgrounded > grace, session auto-ends or pauses per setting
  - Clear messaging; long-press to stop reduces accidental taps

### D) 2‑Day Rule / Streak shield (Priority 2)
- Why: Reduces streak anxiety; common positive habit advice
- Fit: Adjust streak computation; pair with nudge notification
- Dependencies: SilenceData streak logic; NotificationService
- Effort: Small
- Risks: Edge cases around time zones
- Gating: Free; Premium can add “streak freeze token” (see K)
- Acceptance:
  - Missing a single day does not reset streak if previous day was active
  - Clear UX copy in Trends and streak displays

### E) Weekly share card (social-friendly PNG) + quick share (Priority 2)
- Why: Boosts motivation and organic growth
- Fit: Canvas render of 7‑day totals/best day with brand color; `share_plus`
- Dependencies: Trends data; Share service
- Effort: Small/Medium
- Risks: Layout for long locale strings
- Gating: Free; Premium adds alternate themes
- Acceptance:
  - Share sheet opens with generated image <150ms on cached data
  - No-render fallback if no data (motivational graphic)

### F) Calendar export/log (ICS/Add-event) (Priority 2)
- Why: Light-weight time logging; pro users love it
- Fit: One-tap “Log session” to Calendar via plugin or ICS
- Dependencies: ExportService-like helper; platform plugins
- Effort: Small
- Risks: Permissions, platform variance
- Gating: Premium (optional)
- Acceptance:
  - Event created with start/end, activity, notes; user sees confirmation

### G) Adaptive per-activity threshold suggestions (Priority 2)
- Why: Fewer decisions; smart defaults based on past successes
- Fit: Local heuristic per activity; present as “Try X dB?” chip
- Dependencies: SilenceData aggregates; QuickThresholdSelector UI
- Effort: Small
- Risks: Avoid overfitting; respect user overrides
- Gating: Free
- Acceptance:
  - Suggestion shows after 3 successful sessions; dismissible and learnable

### H) iOS/Android Home Screen widgets (start/pause, daily goal) (Priority 3)
- Why: Zero-friction entry; aligns with quick duration chips
- Fit: Use `home_widget` plugin; push snapshot of state (not streaming)
- Dependencies: Providers snapshot; background update constraints
- Effort: Medium
- Risks: Platform limitations; refresh cadence
- Gating: Free
- Acceptance:
  - Widget displays daily goal progress and quick start presets; deep links launch app into session

### I) Weekly summary notification body upgrade (Priority 3)
- Why: Currently a placeholder; personalized summaries delight users
- Fit: Local-only content: weekly total, best day, streak note, one tip
- Dependencies: NotificationService; SilenceData aggregates; l10n
- Effort: Small
- Risks: Localization lengths
- Gating: Premium
- Acceptance:
  - Accurate metrics in body; localized; fires at configured weekday/time

### J) Gentle accountability: share-at-start (Priority 3)
- Why: Body doubling without social backend
- Fit: Optional share intent “I’m focusing for 25m” at session start
- Dependencies: Share service; Settings toggle
- Effort: Small
- Risks: Spamming if overused (mitigate with prompts)
- Gating: Free; Premium templates
- Acceptance:
  - Single-tap flow; end-of-session auto-share optional; respects user toggles

### K) Streak freeze token (limited per month) (Priority 3)
- Why: Popular in habit apps; reduces churn
- Fit: Counter and condition in streak logic; redeem UI
- Dependencies: SilenceData; SubscriptionProvider gating
- Effort: Small
- Risks: Confusion if not explained; analytics needed
- Gating: Premium
- Acceptance:
  - One freeze/month default; visibly applied on miss; streak preserved

### L) Spike counter + recovery meter in-session (Priority 3)
- Why: Adds live feedback without complexity
- Fit: Increment on threshold violations; subtle haptic on spike (opt-in)
- Dependencies: SilenceDetector feed; AccessibilityProvider for haptics
- Effort: Small
- Risks: Over-notification; keep gentle
- Gating: Free
- Acceptance:
  - Spike count visible; optional haptic; no spam; does not disrupt UX

---

## 9) Prioritized shortlist (impact → effort)

1) iOS Live Activities + Android ongoing notification (glanceable control)
2) Deep Focus mode (+ long‑press to stop when enabled)
3) Weekly share card (organic growth) and 2‑Day Rule / Streak shield (reduce anxiety)
4) Calendar export/log (pro workflow) and adaptive threshold suggestions
5) Weekly summary body upgrade; later: widgets and streak freeze

---

## 10) Implementation outlines for top items

### iOS Live Activities
- Contract: Input session start/end + remaining seconds; Output lock-screen/Island countdown with Stop CTA
- Data flow: Session provider → Live Activity bridge → system UI; stop on session end
- Edge cases: iOS <16: no-op; multiple sessions: one at a time
- Testing: Simulate start/stop; background/foreground; failed starts fallback cleanly

### Android ongoing notification
- Contract: Show remaining time; Stop/Extend actions
- Data flow: Session provider → foreground notification; intents routed to app
- Edge cases: OEM battery kill; verify restart behavior; notification channel
- Testing: Exercise during app switch, screen off, and DND

### Deep Focus mode
- Contract: If backgrounded beyond grace (default 10s), auto end or pause per setting
- Data flow: Lifecycle observer → timer → session end/pause; toasts/haptics
- Edge cases: Incoming call; screen off; user returning in grace
- Testing: Automated lifecycle tests + manual device scenarios

---

## 11) Risks and mitigations

- Platform variance (notifications/widgets):
  - Mitigate with feature flags, OS version checks, and clear fallbacks
- Streak logic changes (2‑Day Rule/freeze):
  - Add unit tests around boundaries and time zones
- Distraction penalty (Deep Focus):
  - Default off; clear onboarding; long-press to stop to avoid accidental loss

---

## 12) What to return (AI reviewer)

Please provide:
1) Feedback on the prioritized shortlist: any missing high-leverage items?
2) Red flags vs constraints (no backend, ad safety, no scroll on main tabs)
3) 3–5 alternatives with equal or lower effort; explain fit and value
4) Acceptance tests and edge cases per proposed feature
5) Rollout plan: toggles/flags, premium gating, and a 2–3 sprint sequence

---

## 13) Appendix

Key UX standards:
- Main tabs: no vertical scroll; ad banner always visible (free tier)
- Non-main content: modal bottom sheets with icon tabs; swipe disabled

Representative file map (for orientation; paths may vary slightly):
- lib/
  - services/
    - silence_detector.dart
    - storage_service.dart
    - subscription_service.dart
    - notification_service.dart
    - export_service.dart
  - providers/
    - silence_provider.dart (SilenceDataNotifier, active* providers)
    - subscription_provider.dart
    - theme_provider.dart
    - notification_provider.dart
    - accessibility_provider.dart
  - screens/
    - home_page_elegant.dart (Summary/Activity tabs)
    - settings_sheet.dart
    - trends_sheet.dart (modal; 7‑day stacked bars on Basic tab)
  - widgets/
    - progress_ring.dart
    - real_time_noise_chart.dart
    - quick_duration_selector.dart
    - quick_decibel_selector.dart

Environment / flags (redact secrets when sharing externally):
- REVENUECAT_API_KEY (iOS/Android)
- IS_DEVELOPMENT, ENABLE_MOCK_SUBSCRIPTIONS
- Ambient flags: see `lib/constants/ambient_flags.dart`

Localization:
- l10n/ with multiple locales; generated `app_localizations.dart`; tests guard completeness

Monetization:
- RevenueCat products (dynamic pricing via Offerings); feature gating via providers and `FeatureGate` widget

---

End of brief.
