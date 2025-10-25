# Comprehensive i18n Audit - All Hardcoded Strings

**Date**: October 20, 2025
**Triggered By**: User testing in Japanese - found most UI still in English
**Status**: 71+ hardcoded strings identified across 18 files

---

## 🎯 EXECUTIVE SUMMARY

### Current Coverage
- ✅ **Settings Screen**: ~90% localized (good)
- ✅ **Permission Dialogs**: 100% localized
- ✅ **FAQ System**: 100% localized
- ⏳ **Onboarding**: Translations ready, code integration pending
- ❌ **Today Tab**: ~5% localized
- ❌ **Sessions Tab**: ~5% localized
- ❌ **Trends/Insights**: ~0% localized
- ❌ **Focus Mode**: ~0% localized

### Findings
- **Total Hardcoded Strings**: 71+
- **Files Affected**: 18
- **Categories**: 10 (buttons, headers, errors, charts, etc.)

---

## 📊 BREAKDOWN BY SCREEN

### 🏠 TODAY TAB (High Priority)
**Impact**: Primary user screen, seen every app launch

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Quest Capsule | 8 motivational messages | quest_capsule.dart | ❌ Not localized |
| Activity Rings | 3 (Edit, Overall, Sessions) | adaptive_activity_rings_widget.dart | ❌ Not localized |
| Stat Labels | 3 (Points, Streak, Sessions) | home_page_elegant.dart | ❌ Not localized |
| Headers | 2 (Your Focus Dashboard, etc.) | home_page_elegant.dart | ❌ Not localized |
| **Total** | **16** | | |

**Quest Capsule Motivational Messages**:
1. "Success is never ending and failure is never final"
2. "Progress over perfection - every minute counts"
3. "Small steps daily lead to big changes"
4. "You're building better habits, one session at a time"
5. "Consistency beats intensity"
6. "Every session is a win, no matter how short"
7. "Focus is a muscle - you're getting stronger"
8. "The journey of a thousand miles begins with a single step"

---

### ⏱️ SESSIONS TAB (High Priority)
**Impact**: Core functionality, used for starting sessions

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Progress Ring | 3 (Start/Stop, Calm) | progress_ring.dart | ❌ Not localized |
| Duration Selector | 5 (premium descriptions) | quick_duration_selector.dart | ❌ Not localized |
| Threshold Panel | 9 (Room Loudness, warnings) | inline_noise_panel.dart | ❌ Not localized |
| Activity Display | 1 (Study • Reading • Meditation) | home_page_elegant.dart | ❌ Not localized |
| Headers | 2 (Pick your mode, etc.) | home_page_elegant.dart | ❌ Not localized |
| **Total** | **20** | | |

**Duration Selector Premium Strings**:
- "Sessions up to 1 hour"
- "Sessions up to 1.5 hours"
- "Sessions up to 2 hours"
- "Extended session durations"
- "Extended session access"

**Inline Noise Panel**:
- "Room Loudness" (header)
- "Threshold: ${threshold}dB" (badge)
- "Threshold set to $db dB" (snackbar)
- "High noise detected, please proceed to a quieter room for better focus" (warning)

---

### 📈 TRENDS/INSIGHTS TAB (High Priority)
**Impact**: Analytics and progress tracking

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Headers | 3 (Insights, Last 7 Days, etc.) | trends_sheet.dart | ❌ Not localized |
| Chart Labels | 7 (Mon, Tue, Wed, Thu, Fri, Sat, Sun) | trends_sheet.dart | ❌ Not localized |
| Stat Chips | 2 (Weekly Total, Best Day) | trends_sheet.dart | ❌ Not localized |
| Loading/Error States | 5 | trends_sheet.dart | ❌ Not localized |
| **Total** | **17** | | |

**Chart Day Labels**: Mon, Tue, Wed, Thu, Fri, Sat, Sun

---

### 🎯 FOCUS MODE (Medium Priority)
**Impact**: Immersive session experience

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Completion Messages | 2 (Session Complete!, Great focus session) | focus_mode_overlay.dart | ❌ Not localized |
| Buttons | 2 (Resume/Pause, Stop) | focus_mode_overlay.dart | ❌ Not localized |
| Hints | 1 (Long press to pause or stop) | focus_mode_overlay.dart | ❌ Not localized |
| **Total** | **5** | | |

---

### ⚙️ DIALOGS & MODALS (Medium Priority)

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Activity Edit Sheet | 8 | activity_edit_sheet.dart | ❌ Not localized |
| Share Preview | 5 | share_preview_sheet.dart | ❌ Not localized |
| Weekly Recap | 5 | weekly_recap_card.dart | ❌ Not localized |
| **Total** | **18** | | |

**Activity Edit Sheet**:
- "Edit Activities" (header)
- "Recommended: 10+ min per activity for consistent habit building"
- "Daily Goals" (section)
- "Total: ${hours}h / 18h"
- "Per-Activity" (toggle)
- "Total exceeds 18-hour daily limit. Please reduce goals." (warning)
- "Goal" (slider label)
- "Set your daily focus target (1 min - 18h)"

---

### 📊 ANALYTICS & CHARTS (Lower Priority)

| Component | Strings | File | Status |
|-----------|---------|------|--------|
| Advanced Analytics | 8 | advanced_analytics_widget.dart | ❌ Not localized |
| Shareable Cards | 5 | shareable_cards.dart | ❌ Not localized |
| Practice Overview | 4 | practice_overview_widget.dart | ❌ Not localized |
| **Total** | **17** | | |

---

## 📋 COMPLETE STRING LIST BY FILE

### 1. **home_page_elegant.dart** (19 strings)

```dart
// Headers
'Your Focus Dashboard'
'Focus minutes today'
'Goal: $goalMinutes min • Calm ≥$calmPercent%'
'Pick your mode'

// Default text
'Study • Reading • Meditation'

// Tooltips
'Tips'
'Theme'
'Settings'

// Snackbar
'Theme changed to ${nextTheme.displayName}'

// Tablet headers
'Today'
'Sessions'

// Helper text
'Set your duration and track your time. Session history and analytics will appear in Summary.'

// Stat labels
'Points'
'Streak'
'Sessions'

// Card titles
'Ring Progress'

// Buttons
'Edit' (x6 instances)
```

### 2. **quest_capsule.dart** (9 strings)

```dart
// Motivational messages (8)
'Success is never ending and failure is never final'
'Progress over perfection - every minute counts'
'Small steps daily lead to big changes'
'You\'re building better habits, one session at a time'
'Consistency beats intensity'
'Every session is a win, no matter how short'
'Focus is a muscle - you\'re getting stronger'
'The journey of a thousand miles begins with a single step'

// Button
'Go'
```

### 3. **trends_sheet.dart** (15 strings)

```dart
// Headers
'Insights'
'Last 7 Days'

// Tooltips
'Share weekly summary'

// Loading states
'Loading...'
'Loading metrics...'

// Empty states
'No data'

// Stat chips
'Weekly Total'
'Best Day'

// Card titles
'Activity Heatmap'
'Recent activity'

// Errors
'Unable to load heatmap'

// Day labels
'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
```

### 4. **progress_ring.dart** (6 strings)

```dart
'Calm'
'Stop'
'Start'
'${minutes}:${seconds}' // Timer format
```

### 5. **focus_mode_overlay.dart** (5 strings)

```dart
'Session Complete!'
'Great focus session'
'Resume'
'Pause'
'Stop'
'Long press to pause or stop'
```

### 6. **quick_duration_selector.dart** (5 strings)

```dart
'Sessions up to 1 hour'
'Sessions up to 1.5 hours'
'Sessions up to 2 hours'
'Extended session durations'
'Extended session access'
```

### 7. **inline_noise_panel.dart** (9 strings)

```dart
'Room Loudness' (x2)
'Threshold: ${threshold.round()}dB'
'Threshold set to $db dB'
'High noise detected, please proceed to a quieter room for better focus'
```

### 8. **activity_edit_sheet.dart** (8 strings)

```dart
'Edit Activities'
'Recommended: 10+ min per activity for consistent habit building'
'Daily Goals'
'Total: ${(_totalMinutes / 60).toStringAsFixed(1)}h / 18h'
'Per-Activity'
'Total exceeds 18-hour daily limit. Please reduce goals.'
'Goal'
'Set your daily focus target (1 min - 18h)'
```

### 9. **adaptive_activity_rings_widget.dart** (5 strings)

```dart
'Sessions'
'Edit'
'Overall'
'Overall ❄️' // With freeze indicator
```

### 10. **advanced_analytics_widget.dart** (8 strings)

```dart
'Performance Metrics'
'Preferred Duration'
'W1', 'W2', 'W3', ... 'W12' // Week labels
'Analytics unavailable'
'We\'ll attempt to restore this section on the next app launch.'
```

### 11. **shareable_cards.dart** (5 strings)

```dart
'QUIET MINUTES'
'Sessions'
'Success Rate'
'Top Activity'
'Focus Field' // Branding
```

### 12. **share_preview_sheet.dart** (5 strings)

```dart
'Share Your Progress'
'Time Range'
'Card Size'
// Plus enum labels: 'Today', 'Weekly', etc.
```

### 13. **weekly_recap_card.dart** (5 strings)

```dart
'Weekly Recap'
'Sessions'
'Points'
'Minutes'
'Streak: ${recap.streakAtStart} → ${recap.streakAtEnd} days'
```

### 14. **practice_overview_widget.dart** (4 strings)

```dart
'Practice Overview'
'Points'
'Streak'
'Sessions'
```

### 15. **audio_safe_widget.dart** (2 strings)

```dart
'Audio temporarily unavailable'
'Audio processing encountered an issue. Recovering automatically...'
```

---

## 🎯 RECOMMENDED PRIORITY

### **Phase 1: Critical (Do First)**
These are seen by users most frequently:

1. **Today Tab** (16 strings)
   - Quest Capsule motivational messages (8)
   - Activity rings labels (3)
   - Stat labels (3)
   - Headers (2)

2. **Sessions Tab** (20 strings)
   - Progress ring controls (3)
   - Threshold panel (9)
   - Duration selector (5)
   - Headers (3)

3. **Navigation** (5 strings)
   - Tab labels
   - Tooltips

**Total Phase 1**: ~41 strings

---

### **Phase 2: Important (Do Second)**
User-facing but less frequently seen:

1. **Trends Tab** (17 strings)
   - Chart labels (7 day names)
   - Headers and stats
   - Loading/error states

2. **Focus Mode** (5 strings)
   - Completion messages
   - Button labels

3. **Activity Edit Sheet** (8 strings)
   - Form labels
   - Warnings

**Total Phase 2**: ~30 strings

---

### **Phase 3: Nice-to-Have (Do Last)**
Lower frequency or less critical:

1. **Analytics Widgets** (17 strings)
2. **Share/Export** (10 strings)
3. **Error States** (5 strings)

**Total Phase 3**: ~32 strings

---

## 📝 ACTION PLAN

### Option A: Systematic Approach (Recommended)
1. Create all 71+ ARB keys at once (one Python script)
2. Generate machine translations for all 7 languages
3. Replace strings file-by-file in priority order
4. Test each screen as completed

**Pros**: Comprehensive, complete coverage
**Cons**: Large upfront work
**Timeline**: 4-6 hours

### Option B: Incremental Approach
1. Start with Phase 1 (Today + Sessions tabs only)
2. Add ~41 ARB keys for these screens
3. Replace strings and test
4. Continue with Phase 2, then Phase 3

**Pros**: Immediate visible progress
**Cons**: Multiple rounds of ARB updates
**Timeline**: 2 hours per phase

### Option C: Screen-by-Screen
1. Pick one screen (e.g., Today Tab)
2. Localize completely
3. Test thoroughly
4. Move to next screen

**Pros**: Manageable chunks, thorough testing
**Cons**: Slowest overall
**Timeline**: 1-2 hours per screen

---

## 🚀 NEXT STEPS

**What would you like to do?**

1. **Option A**: Create all 71+ keys at once and systematically replace (fastest overall)
2. **Option B**: Start with Today + Sessions tabs first (visible impact quickly)
3. **Option C**: Focus on one screen at a time (most thorough)

I can generate:
- ✅ Python script to add all ARB keys with translations
- ✅ Code snippets for each file showing exact replacements
- ✅ Testing checklist for each screen
- ✅ Spreadsheet mapping old strings to new keys

---

## 📊 ESTIMATED EFFORT

| Phase | Strings | Files | Effort | Impact |
|-------|---------|-------|--------|--------|
| Phase 1 (Critical) | 41 | 5 | 2-3 hours | High - Today/Sessions tabs |
| Phase 2 (Important) | 30 | 4 | 2 hours | Medium - Trends/Focus Mode |
| Phase 3 (Nice-to-Have) | 32 | 9 | 2 hours | Low - Analytics/Share |
| **Total** | **103** | **18** | **6-7 hours** | **Complete i18n** |

Note: Counts include duplicates and variations. Actual unique keys needed: ~71

---

**Ready to proceed?** Let me know which approach you prefer!
