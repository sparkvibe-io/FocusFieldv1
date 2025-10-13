# Ambient Quests P0 Implementation Summary

**Status**: ✅ **COMPLETE**
**Date**: October 9-10, 2025
**Engineer**: Claude (GPT-5)
**Review**: Krishna

---

## 🎯 Overview

The Ambient Quests P0 loop is now **fully functional**. This implementation brings the core quest mechanics into the session lifecycle, enabling daily goals, compassionate streaks, and real-time ambient score tracking.

---

## ✅ What Was Completed

### 1. **Ambient Session Engine Integration**

**File**: `lib/providers/ambient_quest_provider.dart`

#### Changes:
- **AmbientSessionState** now tracks `sessionUsesNoise` flag
- **Engine lifecycle**:
  - `start()`: Accepts `usesNoise` parameter, initializes state
  - `tick()`: Updates `quietSeconds` and `violations` every second (1Hz)
  - `end()`: Calculates final ambient score, persists session history
- **Ambient Score**: Only calculated and stored when `sessionUsesNoise == true`
- **Parity Logging**: Logs warning if live calm% differs from ambient score by >1%

#### Key Methods:
```dart
Future<String> start({required int plannedSeconds, required bool usesNoise})
void tick({required bool usesNoise, required double currentDb, required int thresholdDb, required int deltaSeconds})
Future<AmbientSession?> end({required String reason, required int plannedSeconds})
```

---

### 2. **Quest State & Rollover Logic**

**File**: `lib/providers/ambient_quest_provider.dart`

#### Features:
- **Daily Rollover**: Resets `progressQuietMinutes` at day change
- **Monthly Rollover**:
  - New `cycleId` (YYYY-MM format)
  - Replenishes `freezeTokens` to 1
  - Preserves streak
- **Permissive 2-Day Rule**:
  - Tracks `missedYesterday` flag
  - Streak resets **only if two consecutive days are missed**
  - More forgiving than strict "miss one day = reset"

#### Key Methods:
```dart
Future<void> _rolloverIfNeeded()  // Called on load, applySession, freezeToday
Future<void> applySession(AmbientSession session)
Future<bool> freezeToday()
```

#### Rollover Logic:
```dart
// Month change
if (cycleId != currentCycleId) {
  - Reset cycle ID
  - Reset daily progress
  - Replenish freeze token to 1
  - Keep streak intact
  - Clear missedYesterday flag
}

// Day change
if (today > lastUpdatedDay) {
  - Reset daily progress
  - If missedYesterday AND yesterdayMissed → reset streak
  - Update missedYesterday flag based on goal completion
}
```

---

### 3. **Session Lifecycle Integration**

**File**: `lib/screens/home_page_elegant.dart`

#### On Session Start:
```dart
// Determine if activity requires silence
final selectedType = ActivityType.fromKey(selectedKey);
final usesNoise = selectedType.requiresSilence;

// Start ambient engine
await ref.read(ambientSessionEngineProvider.notifier).start(
  plannedSeconds: sessionDuration,
  usesNoise: usesNoise,
);

// Subscribe to 1Hz noise stream
_ambientTickSub = noiseController.stream.listen((db) {
  ref.read(ambientSessionEngineProvider.notifier).tick(
    usesNoise: usesNoise,
    currentDb: db,
    thresholdDb: threshold,
    deltaSeconds: 1,
  );
});
```

#### On Session End:
```dart
// End engine and get session data
final session = await ref.read(ambientSessionEngineProvider.notifier).end(
  reason: success ? 'completed' : 'failed',
  plannedSeconds: plannedSeconds,
);

// Log parity check
if (session?.ambientScore != null) {
  final ambientPercent = session!.ambientScore! * 100;
  final liveCalmPercent = liveCalm ?? 0.0;
  if ((ambientPercent - liveCalmPercent).abs() > 1.0) {
    debugPrint('⚠️ Parity check: ambient=${ambientPercent.toStringAsFixed(1)}% vs live=${liveCalmPercent.toStringAsFixed(1)}%');
  }
}

// Apply quest credit
if (session != null) {
  await ref.read(questStateControllerProvider.notifier).applySession(session);
}
```

---

### 4. **Background Safety & Edge Cases**

**File**: `lib/screens/app_initializer.dart`

#### Android STOP Action:
```dart
if (action == 'STOP') {
  ref.read(silenceStateProvider.notifier).stopSession();
  await notificationService.cancelOngoingSession();

  // End ambient engine to persist partial session
  await ref.read(ambientSessionEngineProvider.notifier).end(
    reason: 'stopped_from_notification',
    plannedSeconds: plannedSeconds,
  );
}
```

#### Deep Focus Breach:
```dart
deepFocusManager.onBreach = () async {
  ref.read(silenceStateProvider.notifier).stopSession();
  await notificationService.cancelOngoingSession();

  // End ambient engine with breach reason
  await ref.read(ambientSessionEngineProvider.notifier).end(
    reason: 'deep_focus_breach',
    plannedSeconds: plannedSeconds,
  );
};
```

---

### 5. **Activity Profile Persistence**

**File**: `lib/providers/ambient_quest_provider.dart`

#### Change:
- `selectedProfileIdProvider` changed from `StateProvider` to `StateNotifierProvider`
- New `SelectedProfileNotifier` class:
  - Loads saved profile ID from storage on init
  - `setProfile()` method persists selection

#### Usage:
```dart
// Get selected profile
final profileId = ref.watch(selectedProfileIdProvider);

// Change profile
await ref.read(selectedProfileIdProvider.notifier).setProfile('reading');
```

---

### 6. **Analytics Widgets (Oct 10, 2025)**

#### **SessionHeatmap** (`lib/widgets/session_heatmap.dart`)
- 12-week GitHub-style contribution heatmap
- Color intensity based on session minutes
- Month labels (Jun, Jul, Aug, Sep)
- Day labels (Mon, Wed, Fri)
- Legend: Less → More gradient
- Horizontal scrolling for long timeframes

#### **TodayTimelineWidget** (`lib/widgets/today_timeline_widget.dart`)
- 24-hour horizontal timeline
- Session dots positioned by time of day
- Colored by success/failure
- Current time indicator line
- Tooltips with session details

#### **Weekly Target Line** (in `lib/screens/trends_sheet.dart`)
- Horizontal line at 30 minutes (default daily goal)
- Only shown if maxDay >= targetMinutes
- Subtle tertiary color with glow effect
- Visual reference for goal achievement

#### **TrendsSheet Integration**
- Heatmap added to Basic tab (below 7-day chart)
- Unified "Show More" button (removed separate heatmap icon)
- Standard 85% max height bottom sheet
- Scrollable content within sheet

---

## 🧪 Testing & Quality Gates

### Static Analysis
```bash
flutter analyze --no-fatal-infos
```
**Result**: ✅ Only info-level lints (no errors or warnings)

### Unit Tests
```bash
flutter test
```
**Result**: ✅ All tests passed

### Build Verification
```bash
./scripts/build/build-dev.sh
```
**Result**: ✅ APK built successfully

---

## 📊 Files Changed

| File | Changes |
|------|---------|
| `lib/providers/ambient_quest_provider.dart` | Engine lifecycle, rollover logic, quest state management |
| `lib/screens/home_page_elegant.dart` | Session start/tick/end integration, parity logging |
| `lib/screens/app_initializer.dart` | STOP action and Deep Focus breach handlers |
| `lib/models/ambient_models.dart` | Added `missedYesterday` field to QuestState |
| `lib/screens/trends_sheet.dart` | Added heatmap to Basic tab, weekly target line |
| `lib/widgets/session_heatmap.dart` | **NEW** 12-week activity heatmap widget |
| `lib/widgets/today_timeline_widget.dart` | **NEW** 24-hour session timeline |
| `lib/widgets/weekly_recap_card.dart` | **NEW** Weekly summary card |
| `lib/l10n/*.arb` | Added localized strings for "Calm" and "Calm %" |

---

## 🔧 Technical Details

### Ambient Score Calculation
```dart
final score = quietSeconds / max(1, elapsedSeconds);
// Returns 0.0 to 1.0 (0% to 100%)
```

### Streak Reset Logic
```dart
// Permissive 2-Day Rule
final yesterdayMissed = progressQuietMinutes < goalQuietMinutes;
final resetStreak = yesterdayMissed && state.missedYesterday;

if (resetStreak) {
  streakCount = 0;
}
```

### Freeze Token
```dart
// Replenished monthly (max 1)
if (cycleId != currentCycleId) {
  freezeTokens = 1;
}

// Consuming token
if (freezeTokens > 0) {
  progressQuietMinutes = goalQuietMinutes;  // Mark as complete
  freezeTokens -= 1;
  missedYesterday = false;  // Protect streak
}
```

---

## 🎨 UX Improvements

### Simplified Trends Interface
**Before**: Two buttons (Grid icon + "Show More")
**After**: One button ("Show More")

**Benefit**: Less visual clutter, cleaner card header, better discoverability

### Heatmap Integration
**Before**: Separate HeatmapSheet bottom sheet
**After**: Integrated into TrendsSheet Basic tab

**Benefit**: Unified trends data, consistent navigation, one less modal

---

## 📋 Next Steps (P1)

### 1. **Quest Capsule UI** (2-3 days)
**Goal**: Show daily progress on Home screen

**Design**:
```
┌─────────────────────────────────┐
│ 🎯 Today's Quest                │
│ ████████░░ 12/30 min (40%)      │
│ Streak: 5 days • 1 freeze token │
└─────────────────────────────────┘
```

**Location**: Above "Today's Goals" card on Summary tab
**Flag**: `AmbientFlags.quests` (already true)

**Files to modify**:
- Create `lib/widgets/quest_capsule.dart`
- Wire in `lib/screens/home_page_elegant.dart` (Summary tab)

---

### 2. **Ambient Score Display** (1 day)
**Goal**: Show live calm% inside progress ring for noise-requiring activities

**Design**:
```
Progress Ring
    ↓
┌─────────────┐
│     85%     │  ← Inner label
│    Calm     │
└─────────────┘
```

**Conditions**:
- Only show when `selectedActivity.requiresSilence == true`
- Updates in real-time during session
- Hides for non-noise activities (Work, Family, etc.)

**Files to modify**:
- `lib/widgets/progress_ring.dart` (add inner text widget)
- `lib/screens/home_page_elegant.dart` (pass calm% to ring)

---

### 3. **Adaptive Threshold Chip** (2 days)
**Goal**: Suggest threshold increase after 3 consecutive successful sessions

**Logic**:
```dart
// Track recent wins
final recentSessions = last 5 sessions;
final consecutiveWins = count consecutive completed sessions;

if (consecutiveWins >= 3) {
  // Show suggestion chip
  showAdaptiveThresholdSuggestion(currentThreshold + 2);
}
```

**Design**:
```
┌──────────────────────────────────────────┐
│ 💡 You're crushing it!                   │
│ Try increasing to 40 dB for more points? │
│ [Maybe Later] [Increase Threshold]       │
└──────────────────────────────────────────┘
```

**Files to create**:
- `lib/providers/adaptive_tuning_provider.dart` (track suggestion state)
- `lib/widgets/adaptive_threshold_chip.dart` (UI component)

**Files to modify**:
- `lib/screens/home_page_elegant.dart` (show chip in Activity tab)

---

### 4. **iOS Live Activities** (3-5 days)
**Goal**: Match Android ongoing notification parity

**See**: `docs/development/iOS_Live_Activities_Plan.md` (complete plan)

**Summary**:
- Create WidgetKit extension
- Implement ActivityKit integration
- Design Lock Screen + Dynamic Island UI
- Add Flutter platform channel
- Test on physical device (iOS 16.1+)

**Priority**: P1 (high user value, platform parity)

---

### 5. **Localization** (1 day)
**Goal**: Translate new Ambient Quests strings

**Strings to add**:
- Quest capsule labels
- Freeze token UI text
- Adaptive threshold suggestions
- Ambient score tooltips

**Files to modify**:
- `lib/l10n/app_en.arb` (English template)
- `lib/l10n/app_*.arb` (all language files)

---

## 🚀 Launch Readiness

### P0 (MVP) Status: ✅ **COMPLETE**
- [x] Ambient session engine
- [x] Quest state management
- [x] Daily/monthly rollover
- [x] 2-Day Rule streaks
- [x] Freeze tokens
- [x] Session lifecycle integration
- [x] Background safety
- [x] Analytics widgets

### P1 (Polish) Status: 🔄 **IN PROGRESS**
- [ ] Quest Capsule UI
- [ ] Ambient Score inner ring label
- [ ] Adaptive Threshold suggestions
- [ ] iOS Live Activities
- [ ] Localization

### P2 (Future) Status: 📋 **DEFERRED**
- [ ] Health/Calendar integrations
- [ ] Multi-mission programs
- [ ] Custom activity profiles
- [ ] Social features

---

## 📊 Metrics & Monitoring

### Parity Checks
**Logged**: Ambient score vs. live calm% difference
**Threshold**: >1% triggers warning
**Action**: Review noise detection logic if frequent

### Streak Accuracy
**Logged**: Daily rollover events
**Verification**: Check `missedYesterday` flag persistence
**Action**: Monitor for unexpected streak resets

### Freeze Token Usage
**Logged**: Token consumption events
**Expected**: ~1 use per month per user
**Action**: Analyze usage patterns for UX insights

---

## 🎓 Developer Notes

### Testing Rollover Logic
```dart
// Simulate day change
final controller = ref.read(questStateControllerProvider.notifier);
await controller.load(); // Triggers rollover check

// Simulate month change
// Manually edit stored cycleId in SharedPreferences
```

### Debugging Parity Issues
```dart
// Enable verbose logging in home_page_elegant.dart
if ((ambientPercent - liveCalmPercent).abs() > 1.0) {
  debugPrint('⚠️ Parity check: ambient=${ambientPercent.toStringAsFixed(1)}% vs live=${liveCalmPercent.toStringAsFixed(1)}%');
  debugPrint('   quietSeconds=${session.quietSeconds}, elapsedSeconds=${state.elapsedSeconds}');
}
```

### Testing Freeze Tokens
```dart
// Check token availability
final questState = ref.read(questStateControllerProvider);
print('Freeze tokens: ${questState?.freezeTokens ?? 0}');

// Use token
final success = await ref.read(questStateControllerProvider.notifier).freezeToday();
print('Freeze applied: $success');
```

---

## ✅ Sign-Off

**Implementation**: ✅ Complete
**Testing**: ✅ Passed
**Documentation**: ✅ Updated
**Build**: ✅ Verified

**Ready for**: P1 polish features (Quest Capsule, Ambient Score display, Adaptive Threshold, iOS Live Activities)

---

**Questions or issues?** Review:
- `docs/development/AmbientQuests_Dev_Spec.md` (Gherkin acceptance tests)
- `docs/development/AmbientQuests_Copy_and_MicroInteractions.md` (UX specs)
- `docs/development/iOS_Live_Activities_Plan.md` (iOS implementation plan)
