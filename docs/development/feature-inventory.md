# Feature Inventory — Status Tracker (Oct 9, 2025)

This inventory consolidates proposed features across Ambient Quests (P0 scope) and the Overview/Dashboard upgrades, mapping each item to its current status with notes and code pointers.

Legend
- Done: Implemented and validated (basic tests or device checks)
- In Progress: Partial implementation or behind a feature flag
- Todo: Not started

## Ambient Quests (P0) — from `docs/development/AmbientQuests_Dev_Spec.md`

- Activity Profiles (quiet-first: Study, Reading, Meditation)
  - Status: In Progress
  - Notes: Profiles scaffolded; selection chips planned. Noise-based profiles leverage existing detector.
  - Next: Persist selected profile; wire noise card visibility by profile.

- Ambient Score (quietSeconds / actualSeconds) for quiet profiles
  - Status: In Progress
  - Notes: Minimal AmbientSessionEngine exists; ring subtitle wiring in progress.
  - Next: Ensure ±1% parity between live vs end-of-session computation; expose quiet-seconds stream.

- Quest Capsule on Home (daily goal progress)
  - Status: In Progress
  - Notes: Capsule scaffold exists; goal ring subtitle partially wired.
  - Next: Finalize Quest state updates on session end; add freeze token interactions.

- Compassionate Streaks (2‑Day Rule + 1 Freeze Token/month)
  - Status: Todo
  - Notes: Model shape defined in spec. Not yet wired.
  - Next: Implement `questServiceProvider` logic + persistence; unit tests for streak transitions.

- Adaptive Threshold Chip (suggestion with 24h cooldown; debug override gesture)
  - Status: Done
  - Notes: Suggestion provider implemented with tests (wins/losses/neutral, override precedence, cooldown). Debug long-press cycles overrides.
  - Code: Providers under `lib/providers/` and UI integration where applicable.

- Live Surfaces: iOS Live Activities and Android ongoing notification
  - Status: Android Done; iOS Todo
  - Notes: Android ongoing session notification added with STOP action and progress updates. iOS Live Activities not yet implemented.
  - Code: `lib/services/notification_service.dart`, app wiring in `app_initializer.dart`, calls from `home_page_elegant.dart`.

- Feature Flags (FF_QUESTS, FF_AMBIENT_SCORE, FF_ADAPTIVE_THRESHOLD, ...)
  - Status: In Progress
  - Notes: Adaptive flags effectively used; dedicated `ambient_flags.dart` to be reviewed/added for completeness.
  - Next: Persist flag overrides via `StorageService`; document defaults.

## Overview/Dashboard Upgrades — from `docs/HighLevelPlan.txt`

- Activity selector chips (Studying, Meditation, Work, Noise Monitor + Custom)
  - Status: Todo
  - Next: Persist last-used; long-press rename/hide; color/labels consistent with profiles.

- Daily goal ring per activity (Today X/Y minutes)
  - Status: Todo
  - Next: Add editable goal per activity in Settings (Focus tab); track progress today.

- 7‑day stacked bars by activity
  - Status: Todo
  - Next: Replace single-color bars; aggregate minutes by activity and day; tooltip breakdown.

- "Today timeline" micro-chart (dots by session time and minutes)
  - Status: Todo
  - Next: Lightweight strip on Overview; compute from session list (multiple per day).

- Weekly target line overlay
  - Status: Todo
  - Next: Draw subtle line for planned vs actual weekly minutes.

- Compliments and nudges (contextual strip)
  - Status: Todo
  - Next: Add `NudgeService` with simple rules engine; rate-limit to max 3/day; copy in `AmbientQuests_Copy_and_MicroInteractions.md`.

- Heatmap entry point → condensed monthly heatmap
  - Status: Todo
  - Next: Tap from Overview header; intensity by daily minutes; streak highlight.

- Keep banner ad safe (no overlap, safe hit targets)
  - Status: In Progress
  - Notes: Recent UI compaction and tab restructuring reduced overflow and preserved ad safety on small screens.

## Infrastructure and App Behavior

- Deep Focus lifecycle (grace-based end on background)
  - Status: Done
  - Notes: Enforced via `DeepFocusManager` observing lifecycle; settings persisted via `StorageService`.
  - Code: `lib/services/deep_focus_manager.dart`, `lib/services/storage_service.dart` (keys, load/save), wiring in `app_initializer.dart`.

- Android ongoing session notification (STOP action)
  - Status: Done
  - Notes: Shows on session start; updates progress; cancels on end/stop/error.
  - Code: `lib/services/notification_service.dart`, usage in `home_page_elegant.dart`.

- Settings restructure (Basic, Focus, Advanced, Info) + overflow fixes
  - Status: Done
  - Notes: New Focus tab houses Adaptive Tuning/Override and Deep Focus. Advanced reverted to four core cards. Compact layout for small screens.
  - Code: `lib/screens/settings_sheet.dart`.

- Android predictive back enabled
  - Status: Done
  - Notes: `android:enableOnBackInvokedCallback="true"` added; warnings resolved during device runs.
  - Code: `android/app/src/main/AndroidManifest.xml`.

- Localization for new labels (Focus tab, Deep Focus)
  - Status: Todo
  - Next: Add l10n keys; run `flutter gen-l10n`; update tests.

## Acceptance & Tests (snapshot)

- Adaptive Threshold: Unit tests covering wins/losses/neutral, override precedence, cooldown — Done.
- Deep Focus: Manual test — background app during session → ends after grace — Done (device-tested on Android).
- Notifications: Android ongoing notification STOP action ends session and clears notification — Done.
- UI: Settings tabs render without overflow on smaller Android devices — Done.
- Localization parity: Pending for new strings.

## Next 1–2 Sprints (suggested)

1) Finish P0 Quest loop
- Wire Ambient Score live + end parity
- Complete Quest state updates and capsule interactions
- Implement 2‑Day Rule + 1 Freeze Token

2) Overview upgrades (free-friendly)
- Activity chips + persistence
- Daily goal ring per activity
- Replace 7‑day bars with stacked bars

3) Platform parity and polish
- iOS Live Activities (or fallback) for sessions
- Localize new labels; accessibility pass for Focus tab
- NudgeService and weekly recap/heatmap entry points

---

Maintained by: Focus Field — Development
