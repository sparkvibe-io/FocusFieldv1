# Room Loudness Widget - Threshold Hint Enhancement

**Date**: October 24, 2025
**Component**: `lib/widgets/inline_noise_panel.dart`

## Overview

Enhanced the Room Loudness widget to provide contextual hints when the noise level exceeds the configured threshold, helping users understand their options without increasing the widget's vertical height.

## Design Changes

### Before
- ✅ Orange blinking on threshold badge when exceeded (via `pulseAnimation`)
- ⚠️ Warning only shown when noise ≥ 70dB (very high threshold)
- ❌ No actionable guidance for users when threshold is exceeded

### After
- ✅ Orange blinking on threshold badge when exceeded (unchanged)
- ✅ **NEW**: Contextual hint appears immediately below threshold buttons when ANY threshold is exceeded
- ✅ **NEW**: Smart suggestion with one-tap quick action button to increase threshold
- ✅ Maintains same vertical height (replaces 70dB-only warning with smarter conditional hint)

## Visual Layout

```
┌─────────────────────────────────────────────────────┐
│ Room Loudness              [⚠ Threshold: 40dB]     │ ← Header (blinks orange when exceeded)
│                                                      │
│ 🟠 52.3dB         [30dB] [40dB] [50dB] [60dB] [80dB]│ ← Current level + threshold selectors
│                                                      │
│ ℹ️ Find a quieter room or increase threshold → [50dB]│ ← NEW: Contextual hint with quick action
└─────────────────────────────────────────────────────┘
```

## Behavior States

### State 1: Normal (Below Threshold)
- **Condition**: `currentDb <= threshold`
- **Display**: Header + current dB + threshold buttons
- **No hint shown** (widget is compact)

### State 2: Threshold Exceeded (Moderate Noise)
- **Condition**: `threshold < currentDb < 70dB`
- **Display**:
  - Orange blinking threshold badge in header
  - **INFO hint**: "Find a quieter room or increase threshold →"
  - Quick action button shows next available threshold (e.g., if on 40dB, shows `[50dB]`)
  - Warning color (orange/amber)

### State 3: Threshold Exceeded (High Noise)
- **Condition**: `currentDb >= 70dB`
- **Display**:
  - Red blinking threshold badge in header
  - **WARNING hint**: "High noise detected, please proceed to a quieter room for better focus"
  - Quick action button shows next available threshold (if available)
  - Error color (red)

## Smart Threshold Suggestion Logic

```dart
// Available thresholds
const thresholds = [30, 40, 50, 60, 80];

// If user is on 40dB and exceeding:
// → Suggests 50dB with one-tap button

// If user is on 60dB and exceeding:
// → Suggests 80dB with one-tap button

// If user is on 80dB (max) and exceeding:
// → No quick action button (must find quieter room)
```

## UX Benefits

1. **Immediate Feedback**: Users see helpful guidance the moment threshold is exceeded
2. **Actionable Options**: Clear choice between two actions:
   - Find a quieter room (better for focus)
   - Increase threshold (pragmatic compromise)
3. **One-Tap Solution**: Quick action button reduces friction for threshold adjustment
4. **No Height Increase**: Replaces the previous 70dB-only warning with smarter conditional logic
5. **Fully Localized**: Hint text available in all 7 languages (EN, ES, DE, FR, JA, PT, PT_BR)

## Localization

**New Key Added**: `noiseThresholdExceededHint`

| Language | Translation |
|----------|-------------|
| EN | "Find a quieter room or increase threshold →" |
| ES | "Busque un lugar más silencioso o aumente el umbral →" |
| DE | "Finden Sie einen ruhigeren Raum oder erhöhen Sie den Schwellenwert →" |
| FR | "Trouvez un endroit plus calme ou augmentez le seuil →" |
| JA | "より静かな部屋を見つけるか、しきい値を上げる →" |
| PT | "Encontre um local mais silencioso ou aumente o limite →" |
| PT_BR | "Encontre um local mais silencioso ou aumente o limite →" |

**Existing Key Reused**: `noiseHighDetected` (for ≥70dB case)

## Technical Implementation

### Files Modified
- `lib/widgets/inline_noise_panel.dart` - Added `_buildThresholdHint()` method
- `lib/l10n/app_en.arb` - Added `noiseThresholdExceededHint` key
- `lib/l10n/app_es.arb` - Added localized string
- `lib/l10n/app_de.arb` - Added localized string
- `lib/l10n/app_fr.arb` - Added localized string
- `lib/l10n/app_ja.arb` - Added localized string
- `lib/l10n/app_pt.arb` - Added localized string
- `lib/l10n/app_pt_BR.arb` - Added localized string

### Key Code Changes

**Old Warning Logic** (lines 346-377):
```dart
// High noise warning (only shown when noise >= 70dB)
if (isHighNoise) ...[
  // ... warning container
]
```

**New Contextual Hint Logic** (lines 346-357):
```dart
// Contextual hint: Show when threshold exceeded
if (isExceeding) ...[
  const SizedBox(height: 8),
  _buildThresholdHint(
    context,
    theme,
    l10n,
    smoothed.value,
    threshold,
    settingsNotifier,
  ),
],
```

### New Helper Method

`_buildThresholdHint()` (lines 363-462):
- Determines suggested next threshold from `[30, 40, 50, 60, 80]`
- Chooses appropriate color (warning vs error) based on noise level
- Renders compact single-line hint with icon, text, and optional action button
- One-tap action updates threshold via `settingsNotifier`
- Shows confirmation snackbar after threshold change

## Accessibility

- **Compact Design**: Single-line hint with 6px vertical padding
- **Color Coding**:
  - Warning (orange) for moderate noise (threshold exceeded, <70dB)
  - Error (red) for high noise (≥70dB)
- **Clear Icons**:
  - `info_outline` for moderate noise (actionable)
  - `warning_amber_rounded` for high noise (urgent)
- **Keyboard/Screen Reader**: Button is Material InkWell with proper touch targets

## Material 3 Compliance

- ✅ Uses theme colors (`colorScheme.primary`, `errorContainer`, semantic warning)
- ✅ Proper contrast ratios for text and buttons
- ✅ Rounded corners (6px container, 4px button)
- ✅ Minimal borders with alpha transparency
- ✅ Typography: `labelSmall` for compact hint text

## Testing Checklist

- [ ] Verify hint appears when threshold exceeded (any threshold)
- [ ] Verify hint disappears when noise drops below threshold
- [ ] Verify orange color for moderate noise (<70dB)
- [ ] Verify red color for high noise (≥70dB)
- [ ] Test quick action button (increases threshold by one step)
- [ ] Verify no button shown when at max threshold (80dB)
- [ ] Test snackbar confirmation after threshold change
- [ ] Verify no vertical height increase (same as before)
- [ ] Test all 7 language translations render correctly
- [ ] Verify hint text wraps properly on narrow screens

## Notes

- **Height Budget**: Used existing space from 70dB warning (removed), so no net height increase
- **Smart Timing**: Hint only appears when actionable (threshold exceeded), not always visible
- **Graceful Degradation**: At 80dB threshold, no quick action button (only "find quieter room" option)
- **Consistent with App**: Matches duration selector button style (text-only, colored when selected)
