> Archived Oct 6, 2025. Superseded by Ambient Quests final plan.

# Archived: Home Migration Plan – Habit‑Forming Dashboard (Oct 5, 2025)

Please use the Ambient Quests spec for the current, final plan:
- docs/development/AmbientQuests_Dev_Spec.md
- docs/development/AmbientQuests_Copy_and_MicroInteractions.md

## Guiding Principles (Always) — historical

1) No scrolling on main pages (Home/Summary/Activity). Design content to fit without vertical scrolling on typical devices. Prefer tabs, carousels, and compact summaries over long lists.
2) Advertisements are always visible. Reserve space or use anchored adaptive banners; ensure controls/content never overlap or obscure ads.
3) Material 3, minimal, and non‑repeatable. Follow Material 3 guidelines, reduce duplication, and show concise, unique information.

## Current Home (Working/Integrated) — historical

- Tabs: Summary and Activity (HomePageElegant)
- Activity tab
  - QuickDurationSelector (1–120m with premium gating)
  - ProgressRing with Start/Stop
  - InlineNoisePanel with live dB header; toggle Chart/Text inline
  - Anchored footer banner ad (adaptive)
  - Session success triggers confetti and accessibility announcements
  - Per-activity Daily Goal (Today) compact bar under chips (X/Y minutes, slim progress, percent chip; micro‑win glow at 5m)
- Summary tab
  - Compact Today’s Focus card (QuestCapsule is canonical; mission capsule removed)
  - Activity Progress mocks present; overflow issues resolved in recent compaction
- System updates
  - RevenueCat API v9 migration and UI purchase flows
  - Color API updated to withValues

## To Migrate (From Legacy Home/V2/Backups) — historical

- Activity selector chips (activity_tracking_provider)
  - Horizontal chips: Studying, Meditation, Work, Noise Monitor + Custom
  - Persist last used; long‑press rename/hide (phase 2)
  - Effect: Data and charts become activity‑aware
- 7‑day stacked bars by activity
  - Each day: total minutes stacked by activity colors; tooltip breakdown
- Today timeline strip
  - Dots by session time sized by minutes; optional line for best hour window (premium)
- Compliments/Nudges strip
  - Context‑aware messages (after‑session, near miss, time‑based)
  - Rate‑limited; avoid banner area
- Heatmap entry point
  - “This month” in Overview opens condensed heatmap
- Weekly recap (free snapshot)
  - Sunday local recap; deep‑dive upsell for premium
- Settings/Theme/Tips entry
  - Gear/star/insight icons in header; open Settings sheet, Theme selector, and Tips

## Data Model (Lightweight) — historical

Add fields to session records (where not present):
- activityType: enum { studying, meditation, work, noise_monitor, custom }
- customActivityLabel?: string
- minutes: int; completed: bool; startedAt/endedAt: DateTime
- decibelAvg/decibelP90?: double; thresholdAtRun: double; notes?: string
- derived: dailyGoalMet, dayOfWeek, hourBucket

## Free vs Premium — historical

- Free: activity tagging, daily goal ring, stacked bars, today timeline, streaks, weekly recap snapshot
- Premium: advanced analytics (already built), multi‑week heatmap, downloadable recap, per‑activity insights

## Implementation Phases — historical

- Phase 0: Instrumentation (1 day)
  - Ensure providers capture per‑activity minutes/sessions; compute daily aggregates
- Phase 1: Overview upgrades (2–3 days)
  - Activity chips + persistence; Daily Goal compact bar ✅; stacked bars (next); today timeline
- Phase 2: Compliments/Nudges (1–2 days)
  - Message rules; rate‑limit; keep away from banner
- Phase 3: Heatmap + Weekly Recap (2 days)
- Phase 4: Premium insights (existing) + A/B tests (ongoing)

## Quality Gates — historical

- Analyzer clean; unit tests for aggregation logic
- Ad safety: content above banner; no overlapping tappables; banner region reserved and visible
- Layout: no vertical scroll on main tabs under common screen sizes; verify on iPhone SE/13/14 Pro Max and common Android sizes
- Accessibility: min 44 px touch targets; reduced motion; localization lengths

## Integration Map (Code Pointers) — historical

- Chips: previously referenced `home_page_elegant_backup.dart` (now deleted). Implement anew using `activityTrackingProvider` or reference `home_page_elegant.dart`.
- Daily ring: reuse `ProgressRing` in a compact mode or build a small `LinearProgress` + percent chip
- Stacked bars: adapt `SessionHistoryGraph` or add a compact fl_chart stacked bar widget
- Timeline strip: small custom painter with dots; feed from today’s sessions
- Compliments: new service powered by existing analytics + session providers
- Heatmap entry: add to Overview header; open a bottom sheet with condensed monthly heatmap
- Weekly recap: simple local computation; present in a modal on Sunday night

## Open Questions — historical

- Goal defaults per activity (10 min) vs user‑configured presets
- Where to place streak display (chip badge vs Today ring footer)
- Premium gating copy for stacked bars breakdown and best hour window
