# Onboarding Implementation

## Overview
A complete user onboarding flow has been implemented for Focus Field to guide new users through the app's features and personalize their initial setup.

## Features

### 6-Screen Onboarding Flow

1. **Welcome Screen**
   - Hero icon with app branding
   - Value proposition: "Build better focus habits by finding and maintaining quiet environments for deep work"
   - Three key features highlighted:
     - Track Your Focus (monitoring ambient noise)
     - Earn Points (1 point per quiet minute)
     - Build Streaks (compassionate 2-Day Rule)

2. **Environment Assessment Screen**
   - Helps users set the right noise threshold based on their typical work environment
   - Four options:
     - 🏠 Quiet Home (30 dB) - bedroom, quiet home office
     - 🏢 Typical Office (40 dB) - standard office, library (Recommended)
     - ☕ Busy Space (50 dB) - coffee shop, shared workspace
     - 🌍 Noisy Environment (60 dB) - open office, public space
   - Selection automatically configures the default noise threshold

3. **Goal Setting Screen**
   - Helps users set a realistic daily focus goal
   - Four options with personalized advice:
     - 🌱 Getting Started (10-15 minutes)
     - 🎯 Building Habit (20-30 minutes - Recommended)
     - 💪 Regular Practice (40-60 minutes)
     - 🏆 Deep Work (60+ minutes)
   - Provides contextual advice based on selection

4. **Activity Selection Screen**
   - Multi-select screen for choosing activities to track
   - Four activity types:
     - 📚 Study - Learning, coursework, research
     - 📖 Reading - Deep reading, articles, books
     - 🧘 Meditation - Mindfulness, breathing exercises
     - ⭐ Other - Any focus-requiring activity
   - Info tip: "Focus Field works best for activities where quiet = better concentration"

5. **Permission Screen**
   - Explains microphone permission requirement
   - Privacy assurances:
     - 🎤 No Recording - only measures noise levels
     - 📱 Local Only - all data stays on device
     - 🛡️ Privacy First - conversations are completely private
   - Note: Permission will be requested when starting first session

6. **Quick Tips Screen**
   - Carousel of helpful tips:
     - ⏱️ Start Small - begin with 5-10 minute sessions
     - 🖥️ Try Focus Mode - distraction-free full-screen experience
     - ❄️ Use Freeze Tokens Wisely - 1 free token per month
     - 📈 The 70% Rule - need 70% quiet time for quest credit

## User Experience Features

### Navigation
- **Page Indicator**: Smooth page indicator (worm effect) showing progress through 6 screens
- **Back Button**: Allows users to go back and change selections
- **Skip Button**: Users can skip onboarding entirely and use default settings
- **Next/Get Started Button**: Large, prominent CTA button at bottom

### Visual Design
- **Material Design**: Uses Material Icons and simple shapes (circles, rounded rectangles)
- **Professional Tone**: Clean, focused design with helpful guidance
- **Color-Coded Cards**: Different color containers for visual variety (primary, secondary, tertiary)
- **Interactive Elements**: Cards with selection state (borders, checkboxes)

### Personalization
Based on user selections during onboarding:
- **Noise Threshold**: Set to 30/40/50/60 dB based on environment selection
- **Daily Goal**: Set to 10/20/40/60 minutes based on goal selection
- **Enabled Activities**: Only selected activities are enabled by default

## Technical Implementation

### Files Created
- `lib/screens/onboarding_screen.dart` - Main onboarding screen implementation

### Files Modified
- `lib/screens/app_initializer.dart` - Added onboarding check on first launch
- `lib/screens/settings_sheet.dart` - Added "Replay Onboarding" button in About tab
- `lib/main.dart` - Added `/home` route
- `pubspec.yaml` - Added `smooth_page_indicator: ^1.2.0+3` package

### State Management
- Uses `ConsumerStatefulWidget` with Riverpod for state management
- Stores user selections in local state during onboarding flow
- Saves preferences using:
  - `UserPreferencesProvider` for app-level preferences
  - `SharedPreferences` for onboarding completion status and threshold

### Onboarding Flow Logic
```dart
// Check if onboarding completed
final onboardingCompleted = SharedPreferences.getBool('onboardingCompleted') ?? false;

// Show onboarding if not completed
if (!onboardingCompleted) {
  return OnboardingScreen(isReplay: false);
}

// Otherwise, show home screen
return HomePageElegant();
```

### Replay Functionality
Users can replay the onboarding from **Settings > About > Replay Onboarding**:
- Opens onboarding in fullscreen dialog mode
- When completed, returns to Settings instead of replacing with home screen
- Allows users to change their initial preferences

## Data Storage

### SharedPreferences Keys
- `onboardingCompleted` (bool) - Whether onboarding has been completed
- `defaultThreshold` (int) - Default noise threshold (30/40/50/60 dB)

### UserPreferences
- `globalDailyQuietGoalMinutes` - Daily goal in minutes
- `enabledProfiles` - List of enabled activity IDs

## User Flows

### First Launch Flow
1. Splash Screen → AppInitializer
2. AppInitializer checks `onboardingCompleted` status
3. If false → Show OnboardingScreen
4. User completes/skips onboarding
5. Preferences saved, `onboardingCompleted` set to true
6. Navigate to HomePageElegant

### Replay Flow
1. User opens Settings → About tab
2. Tap "Replay Onboarding" button
3. OnboardingScreen opens as fullscreen dialog
4. User completes onboarding (can change preferences)
5. Dialog closes, returns to Settings

### Skip Flow
1. User taps "Skip" button during onboarding
2. `onboardingCompleted` set to true immediately
3. Default settings applied
4. Navigate to home screen

## Accessibility
- Uses semantic labels for icons
- Proper contrast ratios
- Large touch targets (minimum 48dp)
- Clear, readable typography
- Supports text scaling

## Future Enhancements (P2)
- Analytics tracking for onboarding completion rate
- A/B testing different onboarding flows
- Optional 1-minute test session at the end
- Animated illustrations instead of simple icons
- Localization for all onboarding content
- Onboarding progress persistence (resume where left off)

## Testing Checklist
- [ ] First launch shows onboarding
- [ ] Onboarding can be completed successfully
- [ ] Onboarding can be skipped
- [ ] Preferences are saved correctly based on selections
- [ ] "Replay Onboarding" button works from Settings
- [ ] Replay mode returns to Settings after completion
- [ ] Back button navigation works correctly
- [ ] Page indicator updates correctly
- [ ] All screens render correctly on different screen sizes
- [ ] No linter errors or build issues

