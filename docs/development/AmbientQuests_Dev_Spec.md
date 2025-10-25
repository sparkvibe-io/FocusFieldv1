# Ambient Quests – Development Spec (Flutter/Riverpod) – Oct 7, 2025

This document maps the Ambient Quests proposal to Focus Field’s Flutter codebase. It is designed to minimize code churn, reuse existing services/providers, and respect UX constraints (no scroll on main tabs, ad safety, local-first privacy).

Contents
- Scope and flags
- Data model (Dart) and storage
- Internal endpoints (use-cases/facade)
- Providers/services mapping
- UI wiring (where to add, not redesign)
- Acceptance criteria and test checklist
- Rollout plan (P0/P1/P2)

---

## 1) Scope and Feature Flags (P0)

P0 capabilities (2–3 sprints):
- Activity Profiles (quiet-first: Study, Reading, Meditation) with usesNoise + threshold.
- Ambient Score for quiet profiles: quietSeconds/actualSeconds.
- Quest Capsule on Home (small card above Today’s Goals) showing daily goal progress.
- Compassionate Streaks: 2‑Day Rule + 1 Freeze Token/month (free); more tokens later for Premium.
- Adaptive Threshold Chip (suggestion based on recent wins/losses; 24h cooldown; debug-only override gesture).
- Live surface: iOS Live Activities and Android ongoing notification (wiring only; plugin selection TBD).

Feature flags (new):
- FF_QUESTS (default true in dev)
- FF_AMBIENT_SCORE (true)
- FF_ADAPTIVE_THRESHOLD (true)
- FF_ACTIVE_PROFILES (false)
- FF_HEALTH_SYNC (false)
- FF_CALENDAR_EXPORT (false)

Implementation: add constants in `lib/constants/ambient_flags.dart` and persist overrides via `StorageService` keys.

---

## 2) Data Model (Dart)

New models (add, do not modify existing `SilenceData` yet):

ActivityProfile
- id: String (e.g., "study", "reading", "meditation")
- name: String (l10n key or display)
- icon: String (asset key/material icon name)
- usesNoise: bool
- thresholdDb: int? (if usesNoise)
- motionAssist: enum { off, lenient, strict }

AmbientSession (separate from legacy `SessionRecord`)
- id: String (uuid)
- profileId: String
- plannedSeconds: int
- actualSeconds: int
- startedAt, endedAt: DateTime
- quietSeconds: int
- violations: int
- ambientScore: double (quietSeconds/actualSeconds for quiet profiles)
- motionSamples: int? (reserved; optional)
- notes: String?
- exportedToCalendar: bool
- syncedToHealth: bool

QuestState
- cycleId: String (yyyy-mm)
- dayIndex: int (1..30)
- goalQuietMinutes: int (default 20)
- requiredScore: double (default 0.7)
- progressQuietMinutes: int
- streakCount: int
- freezeTokens: int (default 1/month for free)
- lastUpdatedAt: DateTime

Storage notes
- Persist via `StorageService` with JSON maps (similar to SilenceData) using getString/setString with JSON.
- Keep `AmbientSession` list small (e.g., last 30) for quick trends.
- Avoid storing raw samples.

---

## 3) Internal Endpoints (Facade Use-Cases)

Expose as Riverpod use-cases; keep signatures stable to allow future cloud mirroring.

POST /session/start
- Body: { profileId, plannedSeconds }
- Returns: { sessionId }

POST /session/end
- Body: { sessionId, reason }
- Returns: AmbientSession

GET /quest/today
- Returns: QuestState (+ today goal)

POST /quest/freeze
- Returns: QuestState (updated)

GET /trends/week?weekOf=YYYY-MM-DD
- Returns: aggregate { quietMinutes, avgAmbientScore, bestWindow }

POST /integrations/health/sync (P2)
POST /integrations/calendar/export (P2)

---

## 4) Providers & Services Mapping

Existing reused:
- `SilenceDetector` for dB stream (we compute quietSeconds locally).
- `StorageService` for persistence.
- `NotificationService` for end-of-session + reminders.
- `AccessibilityService` for haptics.

New providers (added):
- `activityProfilesProvider` (default list + selected profile state)
- `ambientSessionEngineProvider` (start/pause/resume/end; computes Ambient Score)
- `questServiceProvider` (today’s goal, apply session, freeze token, 2‑Day Rule)
- `adaptiveThresholdProvider` (suggestion based on recent wins/losses; 24h cooldown; honors debug override)

Motion assist (P0 v1):
- Stub in model and Quest logic; do not change detector. Optional future: add `MotionMonitor`.

---

## 5) UI Wiring (incremental)

Summary tab
- Replace/augment compact ring with Ambient Quest progress ring (daily goal). Keep Trends unchanged. Small label: "Avg Ambient Score this week: {x%}".

Activity tab
- Profile chips come from `activityProfilesProvider` (quiet-first only).
- Noise card visible only if usesNoise=true (unchanged wiring for dB display).
- Ring center timer unchanged; small inner label shows live Ambient Score (%) for quiet profiles.
- Adaptive Threshold Chip appears near noise card header when suggestion available.

End-of-session sheet
- Show: "You earned {quietMin} Quiet Minutes • Ambient Score {score}%" + one tip.
- CTA: "Shorten tomorrow’s goal" (optional quick set) + Done.

Live surfaces
- iOS: Live Activities (ActivityKit); Android: ongoing notification. Keep feature-flagged per platform.

---

## 6) Acceptance Criteria (P0)

Ambient Score
- Given 25m session with 20m below threshold, ambientScore=0.80 and quietSeconds=1200.
- Live label shows Ambient Score within ±1% of post-session calculation.

Quest Progress & Streak
- Today’s goal 20 quiet minutes @≥70%: when session ends with 22 quiet minutes @82%, progressQuietMinutes≥20 and streak++.
- 2‑Day Rule: missing one day does not reset streak if next day successful.
- Freeze token marks day satisfied and decrements tokens.

Adaptive Threshold
- After 3 wins at same threshold, suggestion chip appears ("Try {db} dB today?"). Accepting sets active threshold for that profile.

Profiles & Noise card
- Active (usesNoise=false) hides noise card; quiet shows it.

Live surfaces
- While RUNNING, live surface shows remaining time and % quiet; Pause/End actions work; clean up reliably on end.

Ad safety & Accessibility
- Ad banner remains visible on both tabs; hit targets ≥44px; labels localized.

---

## 7) Test Checklist

Unit tests
- Ambient score computation and grace handling around spikes.
- QuestService streaks with 2‑Day Rule and Freeze token.
- Threshold suggestion generation + acceptance.

Widget tests
- Noise card visibility toggles by profile. Adaptive chip appears/hides.
- End sheet renders correct summary and CTAs.

Integration checks (manual)
- Live Activities / notification actions; background/foreground transitions.
- Timezone boundary around midnight for streaks.
- Ads unaffected on compact devices.

---

## 8) Rollout Plan

P0 (Weeks 1–3)
- Add models/providers/flags; wire Ambient Score; Quest capsule; compassionate streaks; adaptive threshold; live surfaces.

P1 (Weeks 4–5)
- Spike/Recovery haptics; end-sheet micro-insight; weekly share card; one Best Space & Time insight.

P2 (Weeks 6–8)
- Health/Health Connect write; Calendar export; premium pack (extra freeze tokens, advanced modes, longer sessions).

---

Appendix: Minimal Public APIs (Dart signatures)

See stubs in `lib/models/*.dart` and `lib/providers/ambient_quest_provider.dart` for concrete types.
