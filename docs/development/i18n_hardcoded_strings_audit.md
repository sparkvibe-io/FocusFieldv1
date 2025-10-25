# Hardcoded English Strings Audit - Focus Field Flutter App
## Comprehensive i18n Completeness Check
**Date:** October 23, 2025  
**Status:** Final audit for MVP localization

---

## CRITICAL FINDINGS - HIGH PRIORITY

### 1. **Settings Sheet** (`lib/screens/settings_sheet.dart`)

#### Line 262: Title in Card
```dart
'Daily Goals',
```
**Context:** Card label in Basic tab, Daily Goals button section  
**Suggested Key:** `settingsDailyGoalsTitle`  
**Priority:** CRITICAL - User-facing label

#### Line 306: Focus Mode Title
```dart
const Text('Focus Mode'),
```
**Context:** SwitchListTile title in Basic tab  
**Suggested Key:** `settingsFocusMode` (already exists as `settingsFocusMode` in l10n)  
**Status:** LOCALIZE - Use existing key

#### Line 312: Focus Mode Subtitle
```dart
'Minimize distractions during sessions with a focused overlay',
```
**Context:** Description under Focus Mode toggle  
**Suggested Key:** `settingsFocusModeDescription`  
**Priority:** CRITICAL - User-facing description

#### Line 351: Deep Focus Title (Advanced Tab)
```dart
title: 'Deep Focus',
```
**Context:** Advanced card title  
**Suggested Key:** `settingsDeepFocusTitle`  
**Priority:** HIGH - Premium feature name

#### Line 352: Deep Focus Subtitle
```dart
subtitle: 'End session if app is left',
```
**Context:** Advanced card description  
**Suggested Key:** `settingsDeepFocusDescription`  
**Priority:** HIGH

#### Line 412: Dialog Title
```dart
title: const Text('Deep Focus'),
```
**Context:** AlertDialog title for Deep Focus settings  
**Suggested Key:** `deepFocusDialogTitle`  
**Priority:** CRITICAL

#### Line 419: Switch Label
```dart
const Expanded(child: Text('Enable Deep Focus')),
```
**Context:** Switch label in Deep Focus dialog  
**Suggested Key:** `deepFocusEnableLabel`  
**Priority:** HIGH

#### Line 430: Grace Period Label
```dart
const Text('Grace period (seconds)'),
```
**Context:** Slider label explanation  
**Suggested Key:** `deepFocusGracePeriodLabel`  
**Priority:** CRITICAL

#### Line 439: Grace Period Display
```dart
label: '$grace s',
```
**Context:** Slider label (dynamic) - unit is localized  
**Suggested Key:** Already dynamic with variable - OK  
**Status:** MONITOR - Ensure 's' is localized in other languages

#### Line 451: Grace Period Display (Right)
```dart
child: Text('$grace s', textAlign: TextAlign.end),
```
**Context:** Grace period value display  
**Suggested Key:** Dynamic - OK  
**Status:** MONITOR

#### Line 457: Explanation Text
```dart
'When enabled, leaving the app will end the session after the grace period.',
```
**Context:** Help text in Deep Focus dialog  
**Suggested Key:** `deepFocusExplanation`  
**Priority:** CRITICAL

#### Line 465: Close Button
```dart
child: const Text('Close'),
```
**Context:** Dialog action button  
**Suggested Key:** `buttonClose` (already exists)  
**Status:** LOCALIZE - Use existing key

#### Line 512: Notification Permission Title
```dart
const Expanded(child: Text('Enable Notifications')),
```
**Context:** Dialog title for notification permission  
**Suggested Key:** `notificationPermissionTitle`  
**Priority:** CRITICAL

#### Line 520: Permission Explanation
```dart
'Focus Field needs notification permission to send you:',
```
**Context:** Dialog content explaining why notifications needed  
**Suggested Key:** `notificationPermissionExplanation`  
**Priority:** CRITICAL

#### Lines 529, 534, 539: Permission Benefits
```dart
'Daily focus reminders'
'Session completion alerts'
'Achievement celebrations'
```
**Context:** Bullet points of notification benefits  
**Suggested Keys:**  
- `notificationBenefitReminders`
- `notificationBenefitCompletion`
- `notificationBenefitAchievements`  
**Priority:** HIGH

#### Lines 566-567: Platform-Specific Instructions
```dart
isIOS ? 'How to enable on iOS:' : 'How to enable on Android:',
```
**Context:** Platform-specific instruction header  
**Suggested Key:** `notificationHowToEnable_ios` / `notificationHowToEnable_android`  
**Priority:** HIGH

#### Lines 578, 585: Platform Instructions
```dart
'1. Tap "Open Settings" below\n2. Tap "Notifications"\n3. Enable "Allow Notifications"'  // iOS
'1. Tap "Open Settings" below\n2. Tap "Notifications"\n3. Enable "All Focus Field notifications"'  // Android
```
**Context:** Step-by-step instructions for enabling notifications  
**Suggested Keys:**  
- `notificationStepsIos`
- `notificationStepsAndroid`  
**Priority:** CRITICAL

#### Line 599: Cancel Button
```dart
child: const Text('Cancel'),
```
**Context:** Dialog action button  
**Suggested Key:** `buttonCancel` (already exists)  
**Status:** LOCALIZE - Use existing key

#### Line 604: Open Settings Button
```dart
label: const Text('Open Settings'),
```
**Context:** Dialog action button  
**Suggested Key:** `buttonOpenSettings` (already exists)  
**Status:** LOCALIZE - Use existing key

#### Line 725: Show Tips Title
```dart
'Show Tips',
```
**Context:** Card title in About tab  
**Suggested Key:** `aboutShowTips`  
**Priority:** HIGH

#### Line 731: Tips Description
```dart
'Show helpful tips on app startup and via the lightbulb icon. Tips appear every 2-3 days.',
```
**Context:** Help text under Tips toggle  
**Suggested Key:** `aboutShowTipsDescription`  
**Priority:** HIGH

#### Line 776: Replay Onboarding Title
```dart
'Replay Onboarding',
```
**Context:** Card title in About tab  
**Suggested Key:** `aboutReplayOnboarding`  
**Priority:** HIGH

#### Line 782: Replay Onboarding Description
```dart
'Review the app tour and setup your preferences again',
```
**Context:** Help text under Replay Onboarding  
**Suggested Key:** `aboutReplayOnboardingDescription`  
**Priority:** HIGH

#### Line 823: FAQ Button Label
```dart
'FAQ',
```
**Context:** Link button in Help & Support section  
**Suggested Key:** `buttonFaq` or `helpFaq`  
**Priority:** HIGH

---

### 2. **Onboarding Screen** (`lib/screens/onboarding_screen.dart`)

#### Line 105: Welcome Snackbar
```dart
'Welcome! Ready to start your first session? 🚀',
```
**Context:** Shown after onboarding completion  
**Suggested Key:** `onboardingWelcomeMessage`  
**Priority:** CRITICAL

#### Line 165: Back Button
```dart
child: const Text('Back'),
```
**Context:** Navigation button  
**Suggested Key:** `buttonBack` (already exists as `onboardingBack`)  
**Status:** LOCALIZE - Use existing key

#### Line 186: Skip Button
```dart
child: Text(
  'Skip',
  style: TextStyle(
    color: theme.colorScheme.onSurfaceVariant,
  ),
),
```
**Context:** Navigation button  
**Suggested Key:** `buttonSkip` (already exists as `onboardingSkip`)  
**Status:** LOCALIZE - Use existing key

#### Line 224: Button Labels (Get Started / Next)
```dart
_currentPage == 5 ? 'Get Started' : 'Next',
```
**Context:** Main action button  
**Suggested Keys:**  
- `onboardingGetStarted` or `buttonGetStarted`
- `buttonNext`  
**Priority:** HIGH

#### Line 262: Welcome Screen Title
```dart
'Welcome to\nFocus Field! 🎯',
```
**Context:** Main title on welcome screen  
**Suggested Key:** `onboardingWelcomeTitle`  
**Priority:** CRITICAL

#### Line 273: Welcome Subtitle
```dart
'Your journey to better focus starts here!\nLet\'s build habits that stick 💪',
```
**Context:** Subtitle on welcome screen  
**Suggested Key:** `onboardingWelcomeSubtitle`  
**Priority:** CRITICAL

#### Lines 285, 295, 305: Feature Card Titles
```dart
'Track Your Focus'
'Earn Rewards'
'Build Streaks'
```
**Context:** Welcome screen feature cards  
**Suggested Keys:**  
- `onboardingFeatureTrackTitle`
- `onboardingFeatureEarnTitle`
- `onboardingFeatureBuildTitle`  
**Priority:** HIGH

#### Lines 286, 296, 306: Feature Card Descriptions
```dart
'See your progress in real-time as you build your focus superpower! 📊'
'Every quiet minute counts! Collect points and celebrate your wins 🏆'
'Keep the momentum going! Our compassionate system keeps you motivated 🔥'
```
**Context:** Feature descriptions  
**Suggested Keys:**  
- `onboardingFeatureTrackDesc`
- `onboardingFeatureEarnDesc`
- `onboardingFeatureBuildDesc`  
**Priority:** HIGH

#### Line 443: Environment Screen Title
```dart
'Where\'s Your Focus Zone? 🎯',
```
**Context:** Environment selection screen title  
**Suggested Key:** `onboardingEnvironmentTitle`  
**Priority:** CRITICAL

#### Line 451: Environment Description
```dart
'Choose your typical environment so we can optimize for your space!',
```
**Context:** Help text  
**Suggested Key:** `onboardingEnvironmentDescription`  
**Priority:** HIGH

#### Lines 462-492: Environment Options
```dart
'Quiet Home'
'Bedroom, quiet home office'
'30 dB - Very quiet'

'Typical Office'
'Standard office, library'
'40 dB - Library quiet (Recommended)'

'Busy Space'
'Coffee shop, shared workspace'
'50 dB - Moderate noise'

'Noisy Environment'
'Open office, public space'
'60 dB - Higher noise'
```
**Context:** Environment selection options  
**Suggested Keys:**  
- `onboardingEnvQuietHome`, `onboardingEnvQuietHomeDesc`
- `onboardingEnvOffice`, `onboardingEnvOfficeDesc`
- `onboardingEnvBusy`, `onboardingEnvBusyDesc`
- `onboardingEnvNoisy`, `onboardingEnvNoisyDesc`  
**Priority:** CRITICAL

#### Line 497: Bottom Help Text
```dart
'You can adjust this anytime in Settings',
```
**Context:** Hint text  
**Suggested Key:** `onboardingAdjustAnytime`  
**Priority:** HIGH

---

### 3. **Home Page** (`lib/screens/home_page_elegant.dart`)

#### Line 305-310: Focus Mode Labels (Dynamic in UI)
```dart
label: 'Focus Mode'
label: 'Stop'
```
**Context:** Button labels in Focus Mode controls  
**Suggested Keys:**  
- `focusModeLabel` or use existing localization
- `buttonStop`  
**Status:** CHECK - Verify if already localized

#### Line 1051: Deep Focus Title
```dart
title: 'Deep Focus',
```
**Context:** Dialog/UI element  
**Suggested Key:** `settingsDeepFocusTitle`  
**Status:** CONSOLIDATE with settings_sheet.dart

---

### 4. **Share Preview Sheet** (`lib/screens/shareable_card_preview.dart`)

#### Line 59: AppBar Title (Default)
```dart
title: Text(widget.title ?? 'Share Card'),
```
**Context:** Screen title (fallback)  
**Suggested Key:** `shareCardDefaultTitle`  
**Priority:** MEDIUM

#### Line 130: Share Your Week
```dart
'Share Your Week',
```
**Context:** Bottom sheet header  
**Suggested Key:** `shareYourWeek`  
**Priority:** HIGH

#### Lines 142-202: Card Style Options
```dart
'Gradient Style'
'Bold gradient with large numbers'
'Weekly Summary'

'Achievement Style'
'Focus on total achievement stats'
'Achievement Card'

'Text Only'
'Share as plain text (no image)'
'Share as Text'

'Gradient Style'
'Focus on total quiet minutes'
'Streak Card'
```
**Context:** Card selection options  
**Suggested Keys:**  
- `shareCardGradient`, `shareCardGradientDesc`
- `shareCardAchievement`, `shareCardAchievementDesc`
- `shareCardText`, `shareCardTextDesc`  
**Priority:** HIGH

#### Line 273: Optional Message
```dart
'Building deeper focus,\none session at a time',
```
**Context:** Sample/placeholder message  
**Suggested Key:** `shareSampleMessage`  
**Priority:** MEDIUM

---

### 5. **Activity Edit Sheet** (`lib/widgets/activity_edit_sheet.dart`)

#### Line 283: Slider Min
```dart
'1min',
```
**Context:** Slider label (min value)  
**Suggested Key:** `sliderMin1Minute`  
**Priority:** MEDIUM

#### Line 303: Slider Max
```dart
'18h',
```
**Context:** Slider label (max value)  
**Suggested Key:** `sliderMax18Hours`  
**Priority:** MEDIUM

#### Line 477: SnackBar Error
```dart
const Text('⚠️ At least one activity must be enabled'),
```
**Context:** Validation error message  
**Suggested Key:** `errorActivityRequired`  
**Priority:** CRITICAL

#### Line 489: SnackBar Error
```dart
const Text('Total goals exceed 18-hour daily limit. Please reduce goals.'),
```
**Context:** Validation error message  
**Suggested Key:** `errorGoalExceeds`  
**Priority:** CRITICAL

#### Line 507: SnackBar Success
```dart
const Text('Settings saved'),
```
**Context:** Success feedback  
**Suggested Key:** `messageSaved` or `settingsSaveSuccess`  
**Priority:** MEDIUM

---

### 6. **Notification Settings Widget** (`lib/widgets/notification_settings_widget.dart`)

#### Line 77: Settings Title
```dart
'Notification Settings',
```
**Context:** Bottom sheet title  
**Suggested Key:** `notificationSettings` (already exists)  
**Status:** LOCALIZE - Use existing key

#### Line 111: Permission Required
```dart
'Permission required',
```
**Context:** Error state header  
**Suggested Key:** `errorPermissionRequired`  
**Priority:** HIGH

#### Line 121: Permission Explanation
```dart
'Enable notifications to receive reminders and celebrate achievements.',
```
**Context:** Permission request explanation  
**Suggested Key:** `notificationEnableReason`  
**Priority:** HIGH

#### Line 145: Button Label
```dart
_isRequestingPermission ? 'Requesting...' : 'Enable Notifications',
```
**Context:** Button label with loading state  
**Suggested Keys:**  
- `buttonEnableNotifications`
- `buttonRequesting`  
**Priority:** HIGH

#### Line 220: Daily Time Label
```dart
'Daily Time',
```
**Context:** Time picker section  
**Suggested Key:** `notificationDailyTime`  
**Priority:** HIGH

#### Line 261: SnackBar Message
```dart
'Daily reminder at $pickedText',
```
**Context:** Confirmation message  
**Suggested Key:** `notificationDailyReminderSet`  
**Priority:** HIGH

#### Line 273: Smart Learning Status
```dart
'learning',
```
**Context:** Smart reminder status  
**Suggested Key:** `notificationLearning`  
**Priority:** MEDIUM

#### Line 277: Smart Fallback
```dart
'Smart ($smartText)',
```
**Context:** Smart reminder display  
**Suggested Key:** `notificationSmart`  
**Priority:** MEDIUM

#### Line 303: Use Smart Button
```dart
child: const Text('Use Smart'),
```
**Context:** Button label  
**Suggested Key:** `buttonUseSmart`  
**Priority:** HIGH

#### Line 309: Smart Explanation
```dart
'Choose a fixed time or let Focus Field learn your pattern.',
```
**Context:** Help text  
**Suggested Key:** `notificationSmartExplanation`  
**Priority:** HIGH

#### Line 318-320: Notification Types
```dart
'Session Completed'
'Celebrate completed sessions'

'Achievement Unlocked'
'Milestone notifications'

'Weekly Progress Summary'
'Weekly insights (weekday & time)'
```
**Context:** Notification setting titles/descriptions  
**Suggested Keys:**  
- `notificationSessionComplete`, `notificationSessionCompleteDesc`
- `notificationAchievement`, `notificationAchievementDesc`
- `notificationWeekly`, `notificationWeeklyDesc`  
**Priority:** CRITICAL

#### Line 438: Weekly Time Label
```dart
'Weekly Time',
```
**Context:** Weekly notification time picker  
**Suggested Key:** `notificationWeeklyTime`  
**Priority:** HIGH

#### Line 497: Notification Preview
```dart
'Notification Preview',
```
**Context:** Section header  
**Suggested Key:** `notificationPreview`  
**Priority:** MEDIUM

---

### 7. **Analytics Modal** (`lib/widgets/analytics_modal.dart`)

#### Line 61: Modal Title
```dart
'Analytics',
```
**Context:** Bottom sheet header  
**Suggested Key:** `analytics` (might already exist)  
**Status:** VERIFY if already localized

#### Line 135: Overview Section
```dart
'Overview',
```
**Context:** Section title  
**Suggested Key:** `analyticsOverview`  
**Priority:** MEDIUM

#### Lines 146, 154, 162: Metric Labels
```dart
'Points'
'Streak'
'Sessions'
```
**Context:** Analytics metric titles  
**Suggested Keys:**  
- `statPoints` (exists)
- `statStreak` (exists)
- `statSessions` (exists)  
**Status:** LOCALIZE - Use existing keys

---

### 8. **Adaptive Activity Rings Widget** (`lib/widgets/adaptive_activity_rings_widget.dart`)

#### Line 313: Error Dialog
```dart
const Text('Error'),
title: const Text('Error'),
content: const Text('Quest state not available'),
child: const Text('OK'),
```
**Context:** Error handling dialog  
**Suggested Keys:**  
- `dialogError` or `errorTitle`
- `errorQuestStateUnavailable`
- `buttonOk`  
**Priority:** MEDIUM

#### Line 604: Failed Freeze Token
```dart
const Text('❌ Failed to use freeze token'),
```
**Context:** Error message  
**Suggested Key:** `errorFreezeTokenFailed`  
**Priority:** HIGH

#### Line 607: Use Freeze Button
```dart
child: const Text('Use Freeze'),
```
**Context:** Button label  
**Suggested Key:** `buttonUseFreeze`  
**Priority:** MEDIUM

#### Line 613: Cancel Button
```dart
child: const Text('Cancel'),
```
**Context:** Dialog action  
**Suggested Key:** `buttonCancel`  
**Status:** LOCALIZE - Use existing key

---

### 9. **App Initializer** (`lib/screens/app_initializer.dart`)

#### Line 35-51: Loading Messages
```dart
'Initializing app...'
'Loading settings...'
'Loading user data...'
'Loading...'
```
**Context:** Progress indicators during app initialization  
**Suggested Keys:**  
- `loadingInitializeApp`
- `loadingSettings`
- `loadingUserData`
- `loading`  
**Priority:** MEDIUM

#### Line 38, 45, 53: Error Messages
```dart
'Initialization failed: $error'
'Settings loading failed: $error'
'Data loading failed: $error'
```
**Context:** Error messages (dynamic with error details)  
**Suggested Keys:**  
- `errorInitializationFailed`
- `errorSettingsLoadFailed`
- `errorDataLoadFailed`  
**Priority:** HIGH

#### Line 412: Dialog Title
```dart
title: const Text('Reset App Data'),
```
**Context:** Confirmation dialog  
**Suggested Key:** `dialogResetAppData`  
**Priority:** HIGH

#### Line 416: Cancel Button
```dart
child: const Text('Cancel'),
```
**Context:** Dialog action  
**Suggested Key:** `buttonCancel`  
**Status:** LOCALIZE - Use existing key

#### Line 419: Reset Button
```dart
child: const Text('Reset'),
```
**Context:** Dialog action  
**Suggested Key:** `buttonReset`  
**Priority:** HIGH

#### Line 421: Success Message
```dart
const SnackBar(content: Text('App data has been reset')),
```
**Context:** Success feedback  
**Suggested Key:** `messageDataReset`  
**Priority:** MEDIUM

#### Line 423: Error Message
```dart
SnackBar(content: Text('Failed to reset data: $e')),
```
**Context:** Error feedback (dynamic)  
**Suggested Key:** `errorResetFailed`  
**Priority:** MEDIUM

#### Line 444: Retry Button
```dart
label: const Text('Retry'),
```
**Context:** Action button  
**Suggested Key:** `buttonRetry` (already exists)  
**Status:** LOCALIZE - Use existing key

---

### 10. **Shareable Cards** (`lib/widgets/shareable_cards.dart`)

#### Line 102: Share Label
```dart
l10n.shareQuietMinutes,
```
**Context:** Share card label  
**Status:** Already localized ✓

#### Line 130: Help Text  
```dart
'Share Your Progress',
```
**Context:** Already localized as `shareYourProgress`  
**Status:** Already localized ✓

---

### 11. **Share Button/Sheet** (`lib/widgets/share_preview_sheet.dart`, `lib/widgets/share_button.dart`)

#### Multiple: SnackBar Error Messages
```dart
Text('Failed to share: ${e.toString()}'),
Text('Failed to share. Please try again.'),
```
**Context:** Share error messages  
**Suggested Keys:**  
- `errorShareFailed`
- `errorShareFailedRetry`  
**Priority:** HIGH

---

## SUMMARY BY PRIORITY

### CRITICAL (Must Localize for MVP)
1. Deep Focus settings dialogs (all labels and descriptions)
2. Notification permission dialogs (all text)
3. Platform-specific notification instructions (iOS/Android)
4. Onboarding welcome screen (title, subtitle, features)
5. Environment selection screen (all options)
6. Activity validation error messages
7. Notification settings UI (all toggles and labels)

### HIGH (Should Localize)
1. Help & Support section labels
2. Permission benefit bullets
3. Share card options
4. All Dialog titles and button labels
5. Focus Mode descriptions
6. Replay Onboarding section
7. Feature card titles/descriptions

### MEDIUM (Can Defer to P2)
1. Loading screen messages
2. Analytics section labels (if not already localized)
3. Slider limits (1min, 18h)
4. Share preview messages

---

## RECOMMENDED ACTIONS

1. **Add to app_en.arb** (and all language files):
   - 45+ new localization keys identified above
   - Consolidate duplicate keys (e.g., "Cancel" used 5+ times)

2. **Code Refactoring**:
   - Replace all hardcoded strings with `l10n.*` references
   - Use helper widget for common buttons (OK, Cancel, Close, etc.)
   - Extract platform-specific strings to separate provider

3. **Testing**:
   - Run `flutter gen-l10n` after ARB updates
   - Verify all non-English languages have translations
   - Check length overflow for German/French translations

4. **Timeline**:
   - Critical items: This sprint
   - High priority: Before App Store submission
   - Medium priority: P2 features

---

**Audit Complete** - All hardcoded strings identified and categorized for localization implementation.
