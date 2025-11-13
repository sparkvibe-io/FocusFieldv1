# Feature: Graduated Starter Session Duration

**Date**: November 5, 2025
**Status**: ✅ Implemented and Tested
**Type**: UX Enhancement

---

## 🎯 Overview

The **Starter Session** feature provides new users with a gentle, graduated introduction to Focus Field based on their stated goals from onboarding. Instead of immediately defaulting to their full daily goal (which could be 60 minutes), users start with a shorter, more achievable session duration that scales with their ambition level.

### The Problem We Solved

**Before**: User completes onboarding → selects "Building Habit (20 min)" as daily goal → arrives at Sessions screen showing 20-minute duration → feels overwhelmed → quits before trying

**After**: User completes onboarding → selects "Building Habit (20 min)" as daily goal → arrives at Sessions screen showing 5-minute starter duration with helpful tip → completes quick session → gains confidence → progresses naturally to full goal

---

## 📊 User Experience Flow

### Onboarding

1. User selects daily goal on onboarding screen:
   - 🌱 **Getting Started** (10 min goal)
   - 🎯 **Building Habit** (20 min goal)
   - 💪 **Regular Practice** (40 min goal)
   - 🏆 **Deep Work** (60 min goal)

2. System calculates starter duration:
   ```
   10 min goal → 1 min starter session
   20 min goal → 5 min starter session
   40 min goal → 10 min starter session
   60 min goal → 15 min starter session
   ```

3. Both values saved to user preferences:
   - `globalDailyQuietGoalMinutes`: User's stated goal (10/20/40/60)
   - `starterSessionMinutes`: Calculated starter duration (1/5/10/15)

### First Session

1. User lands on Sessions tab
2. Duration selector shows **starter duration** (not full goal)
3. Friendly tip appears:
   ```
   👋 Starting with a 5-minute session to help you get comfortable.
   Your full 20-minute goal is ready when you are!
   ```
4. User can:
   - **Accept**: Start with starter duration (builds confidence)
   - **Change**: Manually select different duration (clears starter mode)
   - **Dismiss tip**: Tap "Got it" button

### Graduation

**Automatic graduation** happens when user manually changes duration:
- User taps any duration button (1m, 5m, 10m, etc.)
- System clears `starterSessionMinutes` (sets to `null`)
- Future sessions use `globalDailyQuietGoalMinutes`
- No more tip shown

**Persistence**: Starter duration persists across app restarts until manually changed.

---

## 🏗️ Technical Implementation

### Data Model Changes

**File**: `lib/models/user_preferences.dart`

Added new field:
```dart
// Starter session duration in minutes (for first-time users)
// null = user has manually changed duration, use globalDailyQuietGoalMinutes
// non-null = use this duration until user manually changes it
final int? starterSessionMinutes;
```

Updated methods:
- Constructor: Added `starterSessionMinutes` parameter
- `copyWith()`: Added `starterSessionMinutes` parameter
- `toJson()`: Added serialization
- `fromJson()`: Added deserialization
- `defaults()`: Defaults to `null`

### Onboarding Logic

**File**: `lib/screens/onboarding_screen.dart:66-74`

```dart
// Set starter session duration based on goal (graduated complexity)
final starterDurations = {
  10: 1,   // Getting Started → 1 min (quick win)
  20: 5,   // Building Habit → 5 min (taste test)
  40: 10,  // Regular Practice → 10 min (reasonable challenge)
  60: 15,  // Deep Work → 15 min (respects ambition)
};
final starterDuration = starterDurations[goal]!;

// Save both goal and starter duration
await ref.read(userPreferencesProvider.notifier).updateUserPreferences(
  prefs.copyWith(
    globalDailyQuietGoalMinutes: goal,
    starterSessionMinutes: starterDuration,
    enabledProfiles: _selectedActivities.toList(),
  ),
);
```

### Session Screen Initialization

**File**: `lib/screens/home_page_elegant.dart:292-341`

```dart
// Initialize session duration from user preferences on first build
if (_selectedDurationMinutes == -1) {
  final userPrefs = ref.read(userPreferencesProvider);

  // Use starter duration if available (until user manually changes it)
  if (userPrefs.starterSessionMinutes != null) {
    _selectedDurationMinutes = userPrefs.starterSessionMinutes!;

    // Show helpful tip about starter duration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.starterSessionTip(
                      userPrefs.starterSessionMinutes!,
                      userPrefs.globalDailyQuietGoalMinutes,
                    ),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: l10n.buttonGotIt,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  } else {
    // No starter duration: use full goal
    _selectedDurationMinutes = userPrefs.globalDailyQuietGoalMinutes;
  }
}
```

### Manual Duration Change

**File**: `lib/screens/home_page_elegant.dart:4037-4048` (regular durations) and `4105-4114` (premium durations)

```dart
onPressed: () {
  setState(() => _selectedDurationMinutes = minutes);
  ref.read(activeSessionDurationProvider.notifier).state = minutes * 60;

  // Clear starter duration when user manually changes duration
  final userPrefs = ref.read(userPreferencesProvider);
  if (userPrefs.starterSessionMinutes != null) {
    ref.read(userPreferencesProvider.notifier).updateUserPreferences(
      userPrefs.copyWith(starterSessionMinutes: null),
    );
  }
},
```

---

## 🌍 Localization

### English (`app_en.arb:959-970`)

```json
"starterSessionTip": "👋 Starting with a {starterMinutes}-minute session to help you get comfortable. Your full {goalMinutes}-minute goal is ready when you are!",
"@starterSessionTip": {
  "placeholders": {
    "starterMinutes": {"type": "int"},
    "goalMinutes": {"type": "int"}
  }
},
"buttonGotIt": "Got it",
```

### Translations Provided

- ✅ **Spanish (es)**: "Comenzando con una sesión de {starterMinutes} minutos..."
- ✅ **German (de)**: "Beginne mit einer {starterMinutes}-minütigen Sitzung..."
- ✅ **French (fr)**: "Commençons par une session de {starterMinutes} minutes..."
- ✅ **Portuguese (pt)**: "Começando com uma sessão de {starterMinutes} minutos..."
- ✅ **Brazilian Portuguese (pt_BR)**: Same as pt
- ✅ **Japanese (ja)**: "{starterMinutes}分のセッションから始めて..."
- ✅ **Chinese (zh)**: "从{starterMinutes}分钟的练习开始..."

---

## 📋 Testing Scenarios

### Test 1: Getting Started (10 min goal)
1. Complete onboarding, select "Getting Started" (10 min)
2. Navigate to Sessions tab
3. **Expected**: Duration shows **1 minute**
4. **Expected**: Tip shows "Starting with a 1-minute session... full 10-minute goal..."
5. Start session, complete it
6. Restart app
7. **Expected**: Duration still shows **1 minute** (persists)
8. Tap "5m" button
9. **Expected**: Duration changes to 5 minutes, starter mode cleared
10. Restart app
11. **Expected**: Duration shows **10 minutes** (full goal)

### Test 2: Building Habit (20 min goal)
1. Complete onboarding, select "Building Habit" (20 min)
2. **Expected**: Starter duration = **5 minutes**
3. **Expected**: Tip shows "... full 20-minute goal..."

### Test 3: Regular Practice (40 min goal)
1. Complete onboarding, select "Regular Practice" (40 min)
2. **Expected**: Starter duration = **10 minutes**
3. **Expected**: Tip shows "... full 40-minute goal..."

### Test 4: Deep Work (60 min goal)
1. Complete onboarding, select "Deep Work" (60 min)
2. **Expected**: Starter duration = **15 minutes**
3. **Expected**: Tip shows "... full 60-minute goal..."

### Test 5: Skip Onboarding
1. Skip onboarding
2. **Expected**: Duration shows **10 minutes** (default goal)
3. **Expected**: No starter duration, no tip

### Test 6: Premium Durations
1. Complete onboarding with any goal
2. Get premium subscription
3. Tap premium duration (60m, 90m, 120m, or 240m)
4. **Expected**: Starter mode cleared immediately
5. Restart app
6. **Expected**: Duration uses full goal (no more starter)

### Test 7: Tip Dismissal
1. Complete onboarding
2. See tip on Sessions tab
3. Tap "Got it" button
4. **Expected**: Tip disappears
5. **Expected**: Starter duration still active (persists)
6. Restart app
7. **Expected**: Tip shows again (tip dismissal not persisted, only duration)

---

## 🎨 Design Decisions

### Why Graduated Durations?

**Rejected Approach**: Fixed 5-minute starter for everyone
- **Problem**: Ignores user's self-assessment
- **Problem**: Patronizing for confident users who picked "Deep Work"

**Chosen Approach**: Scale starter duration with goal
- ✅ Respects user's stated ambition
- ✅ Still achievable (10-25% of goal)
- ✅ Balances challenge and success
- ✅ Natural progression feel

### Why Clear on Manual Change?

**Rejected Approach**: Clear after first completed session
- **Problem**: User might fail first session (noisy environment)
- **Problem**: Requires tracking session count
- **Problem**: Complex state management

**Chosen Approach**: Clear when user manually changes duration
- ✅ User-controlled graduation
- ✅ Simple state management (one boolean check)
- ✅ Respects user agency
- ✅ No failed session penalty

### Why Show Tip Every Time?

**Rejected Approach**: Show tip once, remember dismissal
- **Problem**: Requires additional state (tipDismissed flag)
- **Problem**: User might not read it the first time
- **Problem**: More complex data model

**Chosen Approach**: Show tip whenever starter duration is active
- ✅ Simple logic: `if (starterSessionMinutes != null) show tip`
- ✅ Reinforces the message
- ✅ User can always dismiss if annoying
- ✅ No additional state needed

### Starter Duration Formula

| Goal | Starter | Ratio | Psychology |
|------|---------|-------|------------|
| 10 min | 1 min | 10% | "This will take 60 seconds" ← almost trivial |
| 20 min | 5 min | 25% | "Just 5 minutes" ← manageable chunk |
| 40 min | 10 min | 25% | "Quick 10-minute test" ← reasonable |
| 60 min | 15 min | 25% | "Sample 15 minutes" ← respects ambition |

**Design principle**: Lower ratios for beginners (confidence boost), higher ratios for experts (respect capability).

---

## 🔮 Future Enhancements

### Considered but Deferred

1. **Multi-step Graduation**
   - Idea: 1 min → 5 min → 10 min → full goal
   - Why deferred: Adds complexity, might feel forced
   - Could add if user feedback suggests need

2. **Completion-Based Graduation**
   - Idea: Clear starter after 3 successful sessions
   - Why deferred: Penalizes users in noisy environments
   - Could add as "auto-graduate" preference

3. **Adaptive Starter Duration**
   - Idea: Adjust based on success rate
   - Why deferred: Requires session history analysis
   - P2 feature for AI insights

4. **Configurable Starter Mode**
   - Idea: Settings toggle for "always use starter" vs "skip starter"
   - Why deferred: Minimal user demand expected
   - Could add if power users request it

---

## 📊 Success Metrics

To evaluate this feature's impact, track:

1. **First Session Completion Rate**: % of users who complete their first session
2. **Starter → Goal Graduation Rate**: % of users who manually change duration
3. **Time to Graduation**: Days between onboarding and first manual duration change
4. **Retention Impact**: 7-day retention for starter users vs. non-starter users
5. **Session Frequency**: Average sessions per week in first month

**Hypothesis**: Starter session users will have:
- Higher first session completion (target: +20%)
- Better 7-day retention (target: +15%)
- More frequent sessions (target: +2 sessions/week)

---

## 🐛 Known Limitations

1. **No Tip Persistence**: Tip shows every app launch (until graduation)
   - **Impact**: Minor annoyance for users who reopen app frequently
   - **Mitigation**: "Got it" button provides quick dismissal
   - **Fix**: Could add `tipDismissedAt` timestamp if users complain

2. **No Completion-Based Graduation**: User must manually change duration
   - **Impact**: Some users might stay in starter mode indefinitely
   - **Mitigation**: Tip constantly reminds them of full goal
   - **Fix**: Could add auto-graduate after X successful sessions

3. **No Per-Activity Starter Durations**: Same starter for all activities
   - **Impact**: User might want different starters for Study vs Meditation
   - **Mitigation**: Manual change works per-activity via `lastDurationByProfile`
   - **Fix**: Could add `starterSessionByProfile` map (complex)

---

## 🔗 Related Files

| File | Purpose |
|------|---------|
| `lib/models/user_preferences.dart` | Data model with `starterSessionMinutes` field |
| `lib/screens/onboarding_screen.dart` | Calculates and saves starter duration |
| `lib/screens/home_page_elegant.dart` | Uses starter duration, shows tip, clears on change |
| `lib/l10n/app_*.arb` | Localization for tip message and button |
| `docs/development/BUGFIX_ONBOARDING_DURATION.md` | Previous fix (context) |

---

## 📝 Changelog

### v1.0.0 (November 5, 2025)

**Added**:
- Graduated starter session durations (1/5/10/15 min based on goal)
- `starterSessionMinutes` field to `UserPreferences` model
- Onboarding logic to calculate and save starter duration
- Session screen logic to use starter duration on first launch
- Friendly tip SnackBar explaining starter duration
- Manual duration change clears starter mode (graduation)
- Full localization for tip message (7 languages)

**Changed**:
- `_selectedDurationMinutes` initialization from `-1` (sentinel)
- Onboarding now saves both goal and starter duration

**Fixed**:
- Duration selector now respects user's onboarding choice (indirectly via starter)

---

**Last Updated**: November 5, 2025
**Implemented By**: Claude Code
**Verified**: ✅ Compiles without errors, all tests pass
