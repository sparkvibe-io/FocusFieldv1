# Focus Field — TODOs & Future Enhancements

This document tracks both immediate pre-release tasks and long-term feature enhancements for Focus Field. Organized by priority with clear acceptance criteria.

Last updated: 2025-10-13

## Assumptions
- One developer (you) maintains the codebase.
- Product not yet released to any store.
- No “repository moved” notes or branding guideline docs are needed.
- Current bundle/package identifiers referenced in docs: `io.sparkvibe.focusfield`.

---

## P0 — Security & Accuracy (Do first)

- [ ] Remove hardcoded secrets from docs
  - File: `CLAUDE.md` contains an example RevenueCat API key. Replace with placeholder and add note to rotate in real systems.
  - Acceptance: Secret no longer present in repo (grep shows none), and `.env` usage documented.

- [ ] Update top-level documentation to the current name and URL
  - Files: `README.md`, `docs/README.md`
  - Replace “Silence Score/SilenceScore” with “Focus Field” in headings and intro copy only where it affects correctness.
  - Update any clone/setup references to: `https://github.com/sparkvibe-io/FocusField.git`
  - Acceptance: Title and quick-start commands are accurate and copy-pasteable.

- [ ] Update developer setup guide URL and paths
  - File: `docs/development/setup-guide.md`
  - Change `git clone` URL and any folder names (e.g., `SilenceScore` → `FocusField`).
  - Acceptance: A fresh clone + `flutter pub get` path flow works as documented.

---

## P1 — Documentation completeness (Single-dev, pre-release)

- [ ] Environment template & notes
  - File: `.env.example` header should say “Focus Field”.
  - Ensure env var usage is consistent in docs (`REVENUECAT_API_KEY`, `IS_DEVELOPMENT`, `ENABLE_MOCK_SUBSCRIPTIONS`).
  - Acceptance: New dev can configure builds with envs without trial-and-error.

- [ ] User-facing references to app name in docs
  - Files: `docs/user/user-guide.md`, `docs/deployment/deployment-guide.md`
  - Update example permission strings (e.g., “Allow Focus Field to send notifications”).
  - Acceptance: No user-facing text in docs refers to “SilenceScore”.

- [ ] Monetization docs sanity pass (text only)
  - File: `docs/MONETIZATION_SETUP.md`
  - Ensure wording aligns with current tiers/features and current identifiers.
  - Acceptance: Steps match the current code paths and flags.

- [ ] Deployment platform docs (alignment only)
  - Files: `docs/deployment/iOS_SETUP.md`, `docs/deployment/ANDROID_SETUP.md`
  - Keep identifiers as-is unless the bundle/package decision (below) changes.
  - Acceptance: A first-time setup follows successfully without guessing.

---

## P2 — QA & release-readiness checklists (documentation)

- [ ] Test plan (manual + automated quick-run)
  - Add a short manual test checklist (microphone permission flows, start/stop session, streak, notifications toggle/scheduling, export CSV/PDF if enabled).
  - Include quick automated commands to run tests and lints.
  - Acceptance: A 15–30 minute pass validates core flows without code changes.

- [ ] Localization integrity
  - Confirm `flutter gen-l10n` runs clean and the localization completeness tests pass.
  - Acceptance: `flutter test` passes for localization tests; no untranslated placeholders.

- [ ] Accessibility checklist
  - Verify large fonts/high contrast modes; basic VoiceOver/TalkBack paths.
  - Acceptance: Primary flows usable with assistive settings ON.

- [ ] Performance & stability checklist
  - Confirm stream cleanup (no leaks), acceptable CPU/battery during sessions, no crashes on permission denial/changes.
  - Acceptance: Manual smoke test shows smooth UI, no obvious battery drain in short tests.

---

## P3 — Scripts & utilities polish

- [ ] Update script banners and echoes
  - Files: `run_ios_revenuecat.sh`, `test_revenuecat_comprehensive.sh`, others
  - Replace “SilenceScore” with “Focus Field” in console output banners.
  - Acceptance: Local script output reflects the new name consistently.

- [ ] Build scripts sanity
  - Files: `scripts/build/build-dev.sh`, `scripts/build/build-prod.sh`
  - Confirm env var usage matches docs; add small hints if needed.
  - Acceptance: One-command dev build works; prod build instructions are accurate (keys via env).

---

## P0.5 — UX Enhancement: Bottom Tab Navigation (FUTURE)

**Status:** MVP Phase 1 ✅ Completed (October 13, 2025)  
**Next Phase:** Full bottom tab architecture (Planned)

### Current State (MVP - Phase 1)
- ✅ Share icon added to Insights card header
- ✅ Renamed "Your Patterns" → "Insights"  
- ✅ Changed "Show More" → Icon-only button with tooltip
- ✅ Implemented 4 shareable card styles (Weekly, Achievement, Streak, Activity Rings)
- ✅ Fixed overflow issues in cards (FittedBox, reduced font sizes)
- ✅ Share functionality integrated into Trends/Insights sheet

### Proposed Phase 2: Bottom Tab Navigation

**Target Structure:**
```
[Today Tab]    - Session controls + today's stats
[Sessions Tab] - History, analytics, trends, export
[Share Tab]    - Shareable achievements, weekly cards
```

**Rationale:**
- Industry standard (Instagram, Strava, Twitter)
- Prominent share placement = viral growth
- Clear content hierarchy
- Scalable (add Profile/Community tab later)

**Implementation Plan:**

1. **Create Tab Structure** (~1 hour)
   - [ ] `lib/screens/tabs/today_tab.dart` - Session ring, quick controls
   - [ ] `lib/screens/tabs/sessions_tab.dart` - History, trends, analytics
   - [ ] `lib/screens/tabs/share_tab.dart` - Shareable cards, achievements
   - [ ] Add BottomNavigationBar to main scaffold

2. **Refactor Today Tab** (~1.5 hours)
   - [ ] Move session ring + timer controls
   - [ ] Move quick duration selector
   - [ ] Add today's session summary (points, sessions, streak)
   - [ ] Keep mission capsule if active

3. **Create Sessions Tab** (~1.5 hours)
   - [ ] Session history list
   - [ ] Weekly trends chart (8 weeks)
   - [ ] Advanced analytics (tabbed: Basic/Advanced)
   - [ ] Heat map widget
   - [ ] Export options (CSV/PDF)

4. **Create Share Tab** (~1 hour)
   - [ ] Hero weekly stat card
   - [ ] 4 card style previews (tap to customize)
   - [ ] Recent achievements section
   - [ ] Streak milestones
   - [ ] Quick share buttons

5. **State & Localization** (~0.5 hours)
   - [ ] Tab index state provider
   - [ ] Persist selected tab preference
   - [ ] Add strings: "Today", "Sessions", "Share"
   - [ ] Translate to supported languages

**Success Metrics to Track:**
- Share button tap rate (target: >10% of users)
- Completed shares (target: >50% of taps)
- User retention after sharing (hypothesis: higher)
- New user acquisition from shares (UTM tracking)

**Design References:**
- [Material 3 Bottom Navigation](https://m3.material.io/components/navigation-bar/overview)
- [Instagram Insights UX](https://business.instagram.com/instagram-insights)
- Strava share features

---

## P4 — Decisions to record (blockers for certain edits)

- [ ] Bundle/Package identifiers
  - Agreed identifier: `io.sparkvibe.focusfield` (update lingering references in docs; platform refactor tracked separately if needed).

- [ ] Support contact
  - Current email(s) in code/docs reference now `focusfield@sparkvibe.io`.
  - Decide whether to keep or move to `focusfield@sparkvibe.io` and update language accordingly.

- [ ] Analytics & trials
  - Decide on enabling analytics (if used) and whether to include a free trial for Premium.

Document decisions here for future reference.

---

## Quick commands (documentation only; run manually when needed)

- Format, analyze, test
  - `dart format --set-exit-if-changed .`
  - `flutter analyze`
  - `flutter test`

- Localization
  - `flutter gen-l10n`

- Builds
  - Dev: `./scripts/build/build-dev.sh`
  - Prod (example): `REVENUECAT_API_KEY=your_actual_key ./scripts/build/build-prod.sh`

---

## Done / Notes
- Keep this file pragmatic—if a section becomes noisy, summarize and link to the relevant doc.
- Avoid adding team/branding/migration sections; this is for a single developer pre-release.
