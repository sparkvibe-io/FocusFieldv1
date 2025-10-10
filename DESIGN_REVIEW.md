> Archived Oct 6, 2025 — Superseded by Ambient Quests final plan. See docs/development/AmbientQuests_Dev_Spec.md

# Archived: New Design Implementation Review (Mission-based)

**Date:** October 3, 2025
**Status:** ✅ Ready for Review & Testing
**Compilation:** ✅ No Errors
**Tests:** ✅ 30 Pass, 7 Pre-existing Failures (Unrelated)

## Overview

This document summarized a mission-based habit tracking design. The finalized direction is Ambient Quests. Refer to:
- docs/development/AmbientQuests_Dev_Spec.md
- docs/development/AmbientQuests_Copy_and_MicroInteractions.md

## Design Philosophy

1. **Rocket Journey Metaphor** - Users "rocket to success" through mission stages
2. **Activity-Aware Interface** - Show only relevant widgets per activity type
3. **Focus Over Statistics** - Minimal clutter, emphasis on goals
4. **Modern Minimalism** - Clean, calm, action-oriented
5. **Equal Encouragement** - Free and premium users both see progress and motivation

## Implemented Components

### 1. Activity Chips with Progress Rings ✅
**File:** `lib/widgets/activity_chip.dart`

**Features:**
- Horizontal scrollable activity row
- Circular progress rings showing daily goal completion (e.g., 0/1, 1/1 min)
- Activity icons: 💼 work, 🎓 studying, 📖 reading, 🧘 meditation, 👨‍👩‍👧 family, 💪 fitness
- Green checkmark overlay when daily goal met
- Selection highlighting with primary color
- Add button with premium paywall integration

**Premium Gating:**
- Free: 5 activities maximum
- Premium: Unlimited activities
- Attempting 6th activity shows paywall

**Visual Design:**
- 60x60px circular progress indicators
- Color-coded: gray (0%) → amber (1-99%) → green (100%)
- Activity label below icon
- Goal indicator (e.g., "1/1") below label

---

### 2. Rocket Mission Capsule ✅
**File:** `lib/widgets/rocket_mission_capsule.dart`

**Features:**
- Vertical rocket visualization moving upward through stages
- 4 mission stages based on days:
  - 🔥 **Ignition** (Days 1-7): "Building momentum!"
  - 🚀 **Lift-off** (Days 8-14): "You're rising!"
  - ⚡ **Stage Separation** (Days 15-24): "Breaking barriers!"
  - 🌟 **Orbit** (Days 25-30): "Soaring high!"
- Animated rocket with pulsing bounce effect
- Stage markers: green checkmark (completed), blue glow (current), gray (future)
- Daily micro-goal ring (0/1 min) on right side
- Days remaining counter (e.g., "Day 3/30 · 27 days remaining")
- Motivational message per stage

**Visual Design:**
- 90px height, gradient background (primaryContainer → secondaryContainer)
- Vertical progress track with 4 stage dots
- Rocket moves smoothly between stages with animation
- Beautiful gradient container with shadow

---

### 3. Analytics Button ✅
**File:** `lib/widgets/analytics_button.dart`

**Features:**
- Compact metrics preview: `42 pts · 3🔥 · 12 sessions`
- Analytics icon in circular primaryContainer
- Chevron indicator for "tap to expand"
- Loading state with spinner
- Error state with error icon
- Taps to open full Analytics Modal

**Visual Design:**
- 50px height, surfaceContainerHighest background
- Icon + metrics text + chevron layout
- Smooth border with subtle outline

---

### 4. Activity-Aware Noise Badge ✅
**File:** `lib/widgets/activity_noise_badge.dart`

**Features:**
- **Conditional Display:** Only shows for silence-required activities:
  - ✅ Work, Studying, Reading, Meditation
  - ❌ Gym, Running, Family (hidden)
- Real-time dB display with threshold comparison
- **Pulse animation** when noise exceeds threshold
- Mini sparkline visualization (5 animated bars)
- Color-coded container:
  - Green background: quiet (below threshold)
  - Red background: noisy (above threshold)
- Tap to expand full noise chart (placeholder action)

**Visual Design:**
- Waveform icon that scales/pulses when noisy
- Large dB reading: "35.0 dB / 38 dB"
- Animated sparkline bars on right
- Expand indicator icon

**Note:** Currently uses placeholder values (35 dB / 38 dB threshold) until real-time decibel tracking is wired.

---

### 5. Full-Screen Analytics Modal ✅
**File:** `lib/widgets/analytics_modal.dart`

**Features:**

#### FREE USERS SEE:
1. **Overview Section**
   - 3 metric cards: Points, Streak, Sessions
   - Color-coded icons (amber star, orange flame, green checkmark)

2. **7-Day Activity Chart**
   - Bar chart showing daily points earned
   - Days labeled M-T-W-T-F-S-S
   - Real data from session history

3. **Performance Highlights**
   - Success Rate percentage
   - Average session duration
   - Best streak record

4. **Activity Progress**
   - List of tracked activities with progress bars
   - Goal indicators (e.g., "1/1")
   - Linear progress bars (gray → green)

#### PREMIUM USERS ADDITIONALLY SEE:
5. **Advanced Metrics** (placeholder)
   - 6 detailed performance cards

6. **30-Day Trends Chart** (placeholder)
   - Moving average graph
   - Overall average line

7. **AI Insights** (placeholder)
   - Color-coded recommendations

#### PREMIUM UPSELL (Free Users):
- Large lock icon with gradient background
- "Unlock Advanced Analytics" heading
- Feature list preview
- "Upgrade to Premium" button
- Taps close modal and show paywall

**Visual Design:**
- Draggable bottom sheet (90% screen height)
- Handle bar at top
- Close button in header
- Card-based sections with padding
- Smooth scrolling

---

### 6. Enhanced Activity Provider ✅
**File:** `lib/providers/activity_provider.dart`

**Features:**
- `ActivityType` enum with icons and silence requirements
- `ActivityProgress` model tracking:
  - Daily goal (default 1 minute)
  - Completed minutes today
  - Last update timestamp
  - Progress percentage (0.0 - 1.0)
- Daily reset logic (automatic at midnight)
- JSON persistence via SharedPreferences
- Premium tier checking (5 free, unlimited premium)

**State Management:**
- `ActivityTrackingState` with:
  - Selected activity
  - List of tracked activities with progress
  - Loading state
- Methods:
  - `selectActivity(key)` - Switch active activity
  - `addActivity(key, isPremium)` - Add new activity (checks limit)
  - `removeActivity(key)` - Remove activity
  - `updateProgress(key, minutes)` - Add completed minutes
  - `setGoal(key, minutes)` - Set custom daily goal

---

## Layout Structure (Proposed)

```
┌─────────────────────────────────────────────┐
│ ← [💼0/1] [🎓1/1✓] [📖0/1] [🧘0/1] →       │  80px  - Activity chips (scrollable)
├─────────────────────────────────────────────┤
│           🚀 LIFT-OFF                        │  90px  - Rocket capsule
│         Day 3/30 · 27 days                   │
├─────────────────────────────────────────────┤
│     📊 Analytics                             │  50px  - Analytics button
│     42 pts · 3🔥 · 12 sessions              │
├─────────────────────────────────────────────┤
│     [35.0 dB] 💨 ▂▃▅▃▂                      │  50px  - Noise badge (conditional)
│     / 38 dB                                  │
├─────────────────────────────────────────────┤
│  [5m] [10m] [15m✓] [30m] [60m⭐]           │  50px  - Duration selector (existing)
├─────────────────────────────────────────────┤
│            ╔═══════╗                         │ 240px  - Progress ring (existing)
│            ║ 15:00 ║                         │         PROMINENT
│            ║ Start ║                         │
│            ╚═══════╝                         │
├─────────────────────────────────────────────┤
│       [Ad Banner - 468x60]                   │  60px  - Ad banner
└─────────────────────────────────────────────┘

Total: 620-670px (fits most devices without scroll)
Premium users: No ad = 560-610px
```

## Space Optimization

1. **Compact Rocket Capsule** - Vertical design saves 40px vs horizontal
2. **Analytics Button** - Collapses detailed stats into one tap
3. **Conditional Noise Badge** - Hidden for gym/running (saves 50px)
4. **Modal Strategy** - Detailed analytics don't crowd home screen
5. **Single-line Activity Row** - Horizontal scroll prevents vertical crowding

## Free vs Premium Experience

### Free Users Get:
✅ 5 activity tracking slots
✅ Daily goal progress rings
✅ Rocket mission visualization
✅ Basic analytics (overview, 7-day chart, highlights)
✅ Activity progress bars
✅ All motivational messages
✅ Same visual design quality

### Premium Users Get:
✅ Everything above PLUS:
✅ Unlimited activity tracking (6+)
✅ Advanced metrics dashboard
✅ 30-day trends analysis
✅ AI-powered insights
✅ No ad banner (more screen space)

**Encouragement is equal** - both tiers see progress, streaks, and celebrations.

## File Summary

### New Files Created:
1. `lib/widgets/activity_chip.dart` - Activity chips with progress rings
2. `lib/widgets/rocket_mission_capsule.dart` - Vertical rocket visualization
3. `lib/widgets/analytics_button.dart` - Compact analytics preview button
4. `lib/widgets/activity_noise_badge.dart` - Activity-aware noise display
5. `lib/widgets/analytics_modal.dart` - Full-screen analytics sheet
6. `lib/screens/new_design_preview.dart` - Preview/test screen

### Modified Files:
1. `lib/providers/activity_provider.dart` - Enhanced with progress tracking

## Testing Status

### Compilation: ✅ PASS
```bash
flutter analyze --no-fatal-infos
# Result: 0 errors, 0 warnings
```

### Unit Tests: ✅ PASS
```bash
flutter test
# Result: 30 tests passed, 7 pre-existing failures (localization - unrelated)
```

### Code Quality:
- ✅ Material 3 design compliance
- ✅ Proper error handling
- ✅ Loading states for async data
- ✅ Premium feature gating
- ✅ Accessibility considerations
- ✅ Responsive layouts

## Preview Testing

To preview the new design:

```dart
// Add to your app's routes or navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NewDesignPreview(),
  ),
);
```

The preview screen shows all components in the proposed layout without affecting the existing HomePage.

## Known Limitations / TODO

1. **Real-time Decibels** - Noise badge uses placeholder values (35 dB / 38 dB)
   - Need to wire `currentDecibels` from silence detector
   - Need to add `decibelThreshold` to SilenceState

2. **Daily Goal Ring** - Rocket capsule shows "0/1" placeholder
   - Need to wire actual progress from selected activity

3. **Premium Analytics** - Advanced sections are placeholders
   - 30-day trends chart needs implementation
   - AI insights feature not yet implemented

4. **HomePage Integration** - Components not yet integrated
   - Need to replace existing HomePage widgets
   - Need to handle existing duration selector
   - Need to preserve progress ring functionality

## Next Steps

1. ✅ **Review & Test** - Current stage
2. ⏳ **HomePage Integration** - Wire components into main screen
3. ⏳ **Real-time Data** - Connect noise badge to actual decibel readings
4. ⏳ **Documentation** - Update CLAUDE.md and README.md
5. ⏳ **Polish** - Fine-tune animations, spacing, colors
6. ⏳ **User Testing** - Gather feedback on new design

## Questions for Review

1. **Activity Selection** - Should we auto-select first activity on launch or require user selection?
2. **Noise Badge Expansion** - Should tapping open existing RealTimeNoiseChart or new modal?
3. **Mission Start Date** - Should mission start on first app open or first session completion?
4. **Daily Reset** - Should progress reset at midnight local time or fixed UTC time?
5. **Analytics Modal Height** - Is 90% too tall? Should we make it shorter?

## Design Assets Needed

- [ ] App icon reflecting rocket/mission theme
- [ ] Store screenshots showing new interface
- [ ] Onboarding flow for activity selection
- [ ] Tutorial/tips for mission stages

---

**Ready for integration once reviewed and approved.**
