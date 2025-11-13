# Bug Fix: Onboarding Duration Not Applied to Sessions Screen

**Date**: November 5, 2025
**Issue**: Session duration defaults to 1 minute instead of user's onboarding selection
**Status**: ✅ Fixed

---

## 🐛 Problem Description

After completing onboarding and selecting a daily goal (e.g., "Building Habit" = 20 minutes or "Regular Practice" = 40 minutes), users were redirected to the Sessions screen where the default session duration displayed as **10 minutes** instead of their selected goal.

### User Flow

1. User completes onboarding
2. Selects daily goal:
   - 🌱 Getting Started → 10 minutes
   - 🎯 Building Habit → 20 minutes
   - 💪 Regular Practice → 40 minutes
   - 🏆 Deep Work → 60 minutes
3. Navigates to Sessions tab
4. **Bug**: Duration selector shows 10 minutes (or 1 minute in code) instead of selected goal

---

## 🔍 Root Cause Analysis

### The Flow

**Onboarding saves to user preferences** (`onboarding_screen.dart:54-74`):
```dart
Future<void> _completeOnboarding() async {
  // Set goal based on selection
  final goals = [10, 20, 40, 60];
  final goal = goals[_selectedGoal]; // User's selected goal

  // Update preferences
  await ref
      .read(userPreferencesProvider.notifier)
      .updateUserPreferences(
        prefs.copyWith(
          globalDailyQuietGoalMinutes: goal, // ✅ Saved correctly
          // ...
        ),
      );

  // Navigate to Sessions screen
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const HomePageElegant(initialTab: 1),
    ),
  );
}
```

**Sessions screen ignores user preferences** (`home_page_elegant.dart:64`):
```dart
// ❌ BEFORE (Bug)
int _selectedDurationMinutes = 1; // Hardcoded to 1 minute
```

### The Problem

The `_selectedDurationMinutes` state variable in `HomePageElegant` was initialized to `1` minute and **never read from user preferences**. Even though the onboarding flow correctly saved the user's goal to `globalDailyQuietGoalMinutes`, the Sessions screen didn't use this value.

---

## ✅ Solution

Initialize `_selectedDurationMinutes` from user preferences on the first build.

### Changes Made

**File**: `lib/screens/home_page_elegant.dart`

1. **Initialize to sentinel value** (line 64-65):
   ```dart
   // Sessions tab: selected session duration in minutes
   // Initialize to -1 to indicate it hasn't been set yet from user preferences
   int _selectedDurationMinutes = -1;
   ```

2. **Read from preferences on first build** (lines 292-296):
   ```dart
   @override
   Widget build(BuildContext context) {
     // ... theme, l10n, size, orientation setup ...

     // Initialize session duration from user preferences on first build
     if (_selectedDurationMinutes == -1) {
       final userPrefs = ref.read(userPreferencesProvider);
       _selectedDurationMinutes = userPrefs.globalDailyQuietGoalMinutes;
     }

     // ... rest of build method ...
   }
   ```

### Why This Works

1. **Sentinel value pattern**: Using `-1` allows us to detect when the value hasn't been initialized yet
2. **Build-time initialization**: Since `UserPreferences` is loaded asynchronously via Riverpod, we can't access it in `initState()`. The `build()` method is the earliest point where we can safely read from the provider
3. **One-time initialization**: The `if` check ensures we only set the value once on first build, preserving any manual changes the user makes during the session
4. **Respects skip behavior**: If the user skips onboarding, `globalDailyQuietGoalMinutes` defaults to `10` minutes (see `user_preferences.dart:35`), which is appropriate

---

## 📋 Testing Checklist

- [ ] Complete onboarding with "Getting Started" (10 min) → Sessions shows 10 min
- [ ] Complete onboarding with "Building Habit" (20 min) → Sessions shows 20 min
- [ ] Complete onboarding with "Regular Practice" (40 min) → Sessions shows 40 min
- [ ] Complete onboarding with "Deep Work" (60 min) → Sessions shows 60 min
- [ ] Skip onboarding → Sessions shows 10 min (default)
- [ ] Change duration manually in Sessions → Selection persists during session
- [ ] Restart app → Last manually selected duration is remembered (via `lastDurationByProfile`)

---

## 🔗 Related Files

| File | Purpose |
|------|---------|
| `lib/screens/onboarding_screen.dart` | Saves user's goal selection to preferences |
| `lib/screens/home_page_elegant.dart` | **Fixed**: Now reads goal from preferences on init |
| `lib/models/user_preferences.dart` | Data model with `globalDailyQuietGoalMinutes` field |
| `lib/providers/user_preferences_provider.dart` | Riverpod state management for preferences |

---

## 📊 Onboarding Goal Mapping

| Onboarding Option | Display Text | Goal Value | Index |
|-------------------|-------------|------------|-------|
| 🌱 Getting Started | "10-15 minutes" | 10 minutes | 0 |
| 🎯 Building Habit | "20-30 minutes" | 20 minutes | 1 (default) |
| 💪 Regular Practice | "40-60 minutes" | 40 minutes | 2 |
| 🏆 Deep Work | "60+ minutes" | 60 minutes | 3 |

**Source**: `onboarding_screen.dart:24-25` (default), `onboarding_screen.dart:63-64` (mapping)

---

## 🚀 Impact

### Before Fix
- User selects 20 min goal → sees 1 min (or 10 min) in Sessions
- Confusing UX: "Why doesn't the app remember my choice?"
- Requires manual adjustment every time

### After Fix
- User selects 20 min goal → sees 20 min in Sessions ✅
- Seamless onboarding experience
- User can start a session immediately without adjustments

---

## 📝 Additional Notes

### Why Not Use `lastDurationByProfile`?

The `UserPreferences` model has a `lastDurationByProfile` map that stores the last selected duration for each activity profile (study, reading, meditation). However, this is for **per-activity persistence**, not initial onboarding setup.

**Difference**:
- `globalDailyQuietGoalMinutes`: User's stated daily goal from onboarding (10-60 minutes)
- `lastDurationByProfile`: Last manually selected duration for each activity (1-120 minutes)

We use `globalDailyQuietGoalMinutes` as the **initial value** because:
1. It represents the user's intent from onboarding
2. It provides a good starting point aligned with their stated goal
3. Users can still manually adjust the duration, which gets saved to `lastDurationByProfile`

### Future Enhancement

Consider adding a "Remember last duration" preference toggle to let users choose between:
- **Always use goal**: Reset to `globalDailyQuietGoalMinutes` on each launch
- **Remember last**: Use `lastDurationByProfile[currentActivity]` if available

---

**Last Updated**: November 5, 2025
**Fixed By**: Claude Code
**Verified**: ✅ Compiles without errors
