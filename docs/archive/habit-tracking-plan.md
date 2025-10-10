# Archived: Habit Tracking Upgrade Plan (October 2025)

Archived on Oct 6, 2025 in favor of Ambient Quests.

---

# Habit Tracking Upgrade Plan (October 2025)

This document outlines the plan to evolve Focus Field into a habit-forming dashboard suitable for studying, meditation, work, and noise monitoring/reduction—while keeping the free experience motivating and useful.

## Objectives

- Encourage consistent daily practice across multiple activities.
- Make progress obvious at a glance (today + last 7 days).
- Reward frequent, small wins (micro-sessions) and protect streaks.
- Keep it valuable in free; Premium deepens insights, not access.

## Summary of UX Changes

1) Activity chips (Studying, Meditation, Work, Noise Monitor, +Custom)
- Tap to tag the next session; persists last used; long‑press to rename/hide.
- All charts become activity‑aware.

2) Daily goal ring (per activity)
- Small “Today” ring (X/Y minutes) below the top card.
- Default goal 10 min/activity; editable in Settings.
- Micro‑win visuals at 5 min.

3) 7‑day stacked bars (by activity)
- Replace single-color bars with stacked segments per activity.
- Tooltip: total minutes, success rate, sessions count, per-activity split.

4) Today timeline (micro-chart)
- Slim horizontal strip showing today’s session times (dots sized by minutes, colored by activity).
- Reinforces multiple touchpoints in a day.

5) Weekly target line
- Subtle overlay showing weekly minutes goal vs actual.

6) Compliments & nudges (contextual)
- Text strip with brief, rate‑limited messages—after session, near goal, or time‑based.
- Examples in “Compliments Library” below.

7) Heatmap entry point
- “This month” link opens a condensed monthly heatmap (intensity by daily minutes; streak continuity highlighted).

## Data Model Additions

Session fields (non-breaking; defaults for legacy entries):
- `activityType: enum { studying, meditation, work, noise_monitor, custom }`
- `customActivityLabel: String?`
- `minutes: int` (existing derived OK)
- `completed: bool`
- `startedAt, endedAt: DateTime`
- `decibelAvg, decibelP90: double?` (optional for noise insights)
- `thresholdAtRun: double`
- `notes: String?` (optional quick note)

Derived (computed in providers/services):
- `dailyGoalMet: bool`
- `dayOfWeek, hourBucket`

## Free vs Premium

Free (keeps app useful):
- Activity tagging
- Daily goal ring
- 7‑day stacked bars
- Today timeline
- Weekly recap snapshot (local)
- Streak Saver nudges

Premium (deepens insights):
- Advanced analytics tab (existing)
- Multi-week heatmap & downloadable weekly report
- Per-activity trend insights (best time window, noise vs success correlation)

## Implementation Phases

Phase 0 – Instrumentation (1 day)
- Add session metadata fields and safe migrations.
- Provider helpers to aggregate by day/activity.

Phase 1 – Overview upgrades (2–3 days)
- Activity chips + persistence.
- Daily goal ring (per selected activity).
- 7‑day stacked bars by activity.
- Today timeline strip with micro‑session dots.

Phase 2 – Compliments & Nudges (1–2 days)
- NudgeService with simple rules engine and rate limiting.
- Message pools for after‑session, goal‑related, and time‑based nudges.

Phase 3 – Heatmap & Weekly Recap (2 days)
- Condensed monthly heatmap view (free UI, premium deep‑dive CTA).
- Local weekly recap sheet; premium unlocks historical exports and deeper metrics.

Phase 4 – A/B improvements (ongoing)
- Experiment with daily goal defaults (10 vs 15 min), compliment types, and timing.

## Compliments Library (Examples)

After-session
- “Nice consistency—3 sessions today across Study and Work!”
- “Meditation streak saved! A 1‑min micro‑session kept your run alive.”

Goal-related
- “Today’s goal complete in 2 sessions. Want to try a single 10‑minute block tomorrow?”
- “You’re 2 minutes from your weekly goal. One more micro‑session?”

Time-based
- “Your best focus is 6–7 PM. Try another 5 min then?”
- “Morning sessions have higher success—want to schedule a 5‑min start?”

Progress & environment
- “Average noise is down 3 dB this week—great control!”
- “Work sessions shine when you start within 10 minutes of your usual time.”

## Success Metrics

- Activation: % of users who tag an activity in week 1
- Frequency: avg sessions/day; % users with 2+ sessions/day
- Consistency: % users hitting daily goal 3+ days/week
- Streak retention: next‑day open rate after “Streak Saver”
- Premium conversion: deep‑dive taps from weekly recap
- Ads safety: impressions/session without increased accidental CTR

## Edge Cases & Safeguards

- UI clutter: chips scroll; icon+label; truncate long custom names
- Accessibility: targets ≥44 px; high contrast and scalable text
- Battery: compute aggregates on demand; memoize; avoid frame‑loop work
- Ads: keep compliments/nudges well away from the banner footprint
- Rate limiting: max 3 compliments/day; suppress duplicates

## Code Touchpoints

- `lib/widgets/tabbed_overview_widget.dart`: chips, daily ring, stacked bars, today timeline
- `lib/models/*`: session metadata (ActivityType)
- `lib/providers/*`: per‑activity aggregations and goals
- `lib/services/nudge_service.dart`: rules + message selection (new)

## Open Questions

- Should custom activities have icons or just labels?
- Default daily goal per activity or one goal applied to all?
- Do we allow per‑activity ads suppression (e.g., Meditation)? Likely no for phase 1.
