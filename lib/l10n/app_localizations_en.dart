// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Preparing focus engine…';

  @override
  String get paywallTitle => 'Train Deeper Focus with Premium';

  @override
  String get featureExtendSessions => 'Extend focus sessions from 30 min to 120 min';

  @override
  String get featureHistory => 'Access 90 days of past sessions';

  @override
  String get featureMetrics => 'Unlock performance metrics and trend charts';

  @override
  String get featureExport => 'Download your session data (CSV / PDF)';

  @override
  String get featureThemes => 'Use the full custom theme pack';

  @override
  String get featureThreshold => 'Fine-tune threshold with ambient baseline';

  @override
  String get featureSupport => 'Faster help and early feature access';

  @override
  String get subscribeCta => 'Continue';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get privacyPolicy => 'Privacy';

  @override
  String get termsOfService => 'Terms';

  @override
  String get manageSubscription => 'Manage';

  @override
  String get legalDisclaimer => 'Auto-renewing subscription. Cancel anytime in store settings.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutes of peaceful silence achieved! ✨',
      one: '# minute of peaceful silence achieved! ✨',
    );
    return 'Great job! $_temp0';
  }

  @override
  String get minutes => 'minutes';

  @override
  String get minute => 'minute';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get settings => 'Settings';

  @override
  String get themes => 'Themes';

  @override
  String get analytics => 'Analytics';

  @override
  String get history => 'History';

  @override
  String get startSession => 'Start Session';

  @override
  String get stopSession => 'Stop';

  @override
  String get pauseSession => 'Pause';

  @override
  String get resumeSession => 'Resume';

  @override
  String get sessionSaved => 'Session saved';

  @override
  String get copied => 'Copied';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get permissionMicrophoneDenied => 'Microphone permission denied';

  @override
  String get actionRetry => 'Retry';

  @override
  String get listeningStatus => 'Listening...';

  @override
  String get successPointMessage => 'Silence achieved! +1 point';

  @override
  String get tooNoisyMessage => 'Too noisy! Try again';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get welcomeMessage => 'Press Start to begin your silence journey!';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get resetDataConfirmation => 'Are you sure you want to reset all your progress?';

  @override
  String get resetDataSuccess => 'Data reset successfully';

  @override
  String get decibelThresholdLabel => 'Decibel Threshold';

  @override
  String get decibelThresholdHint => 'Set the maximum allowed noise level (dB)';

  @override
  String get microphonePermissionTitle => 'Microphone Permission';

  @override
  String get microphonePermissionMessage => 'Focus Field measures ambient sound levels to help you maintain quiet environments.\n\nThe app needs microphone access to detect silence, but does not record any audio.';

  @override
  String get permissionDeniedMessage => 'Microphone permission is required to measure silence. Please enable it in settings.';

  @override
  String get noiseMeterError => 'Unable to access microphone';

  @override
  String get premiumFeaturesTitle => 'Premium Features';

  @override
  String get premiumDescription => 'Unlock extended sessions, advanced analytics, and data export';

  @override
  String get premiumRequiredMessage => 'This feature requires Premium subscription';

  @override
  String get subscriptionSuccessMessage => 'Successfully subscribed! Enjoy your premium features';

  @override
  String get subscriptionErrorMessage => 'Unable to process subscription. Please try again';

  @override
  String get restoreSuccessMessage => 'Purchases restored successfully';

  @override
  String get restoreErrorMessage => 'No purchases found to restore';

  @override
  String get yearlyPlanTitle => 'Yearly';

  @override
  String get monthlyPlanTitle => 'Monthly';

  @override
  String savePercent(String percent) {
    return 'SAVE $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Billed at $price/yr.';
  }

  @override
  String billedMonthly(String price) {
    return 'Billed at $price/mo.';
  }

  @override
  String get mockSubscriptionsBanner => 'Mock Subscriptions Enabled';

  @override
  String get splashTagline => 'Find your quiet';

  @override
  String get appIconSemantic => 'App icon';

  @override
  String get tabBasic => 'Basic';

  @override
  String get tabAdvanced => 'Advanced';

  @override
  String get tabAbout => 'About';

  @override
  String get resetAllSettings => 'Reset All Settings';

  @override
  String get resetAllSettingsDescription => 'This will reset all settings and data. Cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get allSettingsReset => 'All settings and data have been reset';

  @override
  String get decibelThresholdMaxNoise => 'Decibel Threshold (max noise level)';

  @override
  String get highThresholdWarningText => 'High threshold may ignore meaningful noise events.';

  @override
  String get decibelThresholdTooltip => 'Typical quiet spaces: 30–40 dB. Calibrate; raise only if normal hum counts as noise.';

  @override
  String get sessionDuration => 'Session Duration';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Upgrade for ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Free: up to $minutes min';
  }

  @override
  String get durationLabel => 'Duration';

  @override
  String get minutesShort => 'min';

  @override
  String get noiseCalibration => 'Noise Calibration';

  @override
  String get calibrateBaseline => 'Calibrate baseline';

  @override
  String get unlockAdvancedCalibration => 'Unlock advanced noise calibration';

  @override
  String get exportData => 'Export Data';

  @override
  String get sessionHistory => 'Session history';

  @override
  String get notifications => 'Notifications';

  @override
  String get remindersCelebrations => 'Reminders & celebrations';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get accessibilityFeatures => 'Accessibility features';

  @override
  String get appInformation => 'App Information';

  @override
  String get version => 'Version';

  @override
  String get bundleId => 'Bundle ID';

  @override
  String get environment => 'Environment';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get support => 'Support';

  @override
  String get rateApp => 'Rate App';

  @override
  String errorLoadingSettings(String error) {
    return 'Error loading settings: $error';
  }

  @override
  String get exportNoData => 'No data available to export';

  @override
  String chooseExportFormat(int sessions) {
    return 'Choose export format for your $sessions sessions:';
  }

  @override
  String get csvSpreadsheet => 'CSV Spreadsheet';

  @override
  String get rawDataForAnalysis => 'Raw data for analysis';

  @override
  String get pdfReport => 'PDF Report';

  @override
  String get formattedReportWithCharts => 'Formatted report with charts';

  @override
  String generatingExport(String format) {
    return 'Generating $format export...';
  }

  @override
  String exportCompleted(String format) {
    return '$format export completed!';
  }

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get close => 'Close';

  @override
  String get supportTitle => 'Support';

  @override
  String responseTimeLabel(String time) {
    return 'Response Time: $time';
  }

  @override
  String get docs => 'Docs';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get emailOpenDescription => 'Opens your email app with system information pre-filled';

  @override
  String get subject => 'Subject';

  @override
  String get briefDescription => 'Brief description';

  @override
  String get description => 'Description';

  @override
  String get issueDescriptionHint => 'Provide details about your issue...';

  @override
  String get openingEmail => 'Opening Email...';

  @override
  String get openEmailApp => 'Open Email App';

  @override
  String get fillSubjectDescription => 'Please fill subject and description';

  @override
  String get emailOpened => 'Email app opened. Send when ready.';

  @override
  String get noEmailAppFound => 'No email app found. Contact:';

  @override
  String standardSubject(String subject) {
    return 'Subject: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Issue: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'Failed to open FAQ: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Failed to open documentation: $error';
  }

  @override
  String get accessibilitySettings => 'Accessibility Settings';

  @override
  String get vibrationFeedback => 'Vibration Feedback';

  @override
  String get vibrateOnSessionEvents => 'Vibrate on session events';

  @override
  String get voiceAnnouncements => 'Voice Announcements';

  @override
  String get announceSessionProgress => 'Announce session progress';

  @override
  String get highContrastMode => 'High Contrast Mode';

  @override
  String get improveVisualAccessibility => 'Improve visual accessibility';

  @override
  String get largeText => 'Large Text';

  @override
  String get increaseTextSize => 'Increase text size';

  @override
  String get save => 'Save';

  @override
  String get accessibilitySettingsSaved => 'Accessibility settings saved';

  @override
  String get noiseFloorCalibration => 'Noise Floor Calibration';

  @override
  String get measuringAmbientNoise => 'Measuring ambient noise (≈5s)...';

  @override
  String get couldNotReadMic => 'Could not read microphone';

  @override
  String get calibrationFailed => 'Calibration failed';

  @override
  String get retry => 'Retry';

  @override
  String previousThreshold(double value) {
    return 'Previous: $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'New threshold: $value dB';
  }

  @override
  String get noSignificantChange => 'No significant change detected.';

  @override
  String get highAmbientDetected => 'High ambient environment detected. Consider a quieter space for more sensitivity.';

  @override
  String get adjustAnytimeSettings => 'You can adjust this anytime in Settings.';

  @override
  String get toggleThemeTooltip => 'Toggle theme';

  @override
  String get audioChartRecovering => 'Audio chart recovering...';

  @override
  String themeChanged(String themeName) {
    return 'Theme: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Start Session';

  @override
  String get stopSessionButton => 'Stop';

  @override
  String get statusListening => 'Listening...';

  @override
  String get statusSuccess => 'Silence achieved! +1 point';

  @override
  String get statusFailure => 'Too noisy! Try again';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get upgradeRequired => 'Upgrade Required';

  @override
  String get exportCsvSpreadsheet => 'CSV Spreadsheet';

  @override
  String get exportPdfReport => 'PDF Report';

  @override
  String get formattedReportCharts => 'Formatted report with charts';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Theme';

  @override
  String get open => 'Open';

  @override
  String get microphone => 'Microphone';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sessions';

  @override
  String get format => 'format';

  @override
  String get successRate => 'Success Rate';

  @override
  String get avgSession => 'Avg Session';

  @override
  String get consistency => 'Consistency';

  @override
  String get bestTime => 'Best Time';

  @override
  String get weeklyTrends => 'Weekly Trends';

  @override
  String get performanceMetrics => 'Performance Metrics';

  @override
  String get advancedAnalytics => 'Advanced Analytics';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get bucket1to2 => '1-2 min';

  @override
  String get bucket3to5 => '3-5 min';

  @override
  String get bucket6to10 => '6-10 min';

  @override
  String get bucket11to20 => '11-20 min';

  @override
  String get bucket21to30 => '21-30 min';

  @override
  String get bucket30plus => '30+ min';

  @override
  String get sessionHistoryTitle => 'Session History';

  @override
  String get recentSessionHistory => 'Recent Session History';

  @override
  String get achievementFirstStepTitle => 'First Step';

  @override
  String get achievementFirstStepDesc => 'Completed your first session';

  @override
  String get achievementOnFireTitle => 'On Fire';

  @override
  String get achievementOnFireDesc => '3-day streak achieved';

  @override
  String get achievementWeekWarriorTitle => 'Week Warrior';

  @override
  String get achievementWeekWarriorDesc => '7-day streak achieved';

  @override
  String get achievementDecadeTitle => 'Decade';

  @override
  String get achievementDecadeDesc => '10 points milestone';

  @override
  String get achievementHalfCenturyTitle => 'Half Century';

  @override
  String get achievementHalfCenturyDesc => '50 points milestone';

  @override
  String get achievementLockedPrompt => 'Complete sessions to unlock achievements';

  @override
  String get ratingPromptTitle => 'Enjoying Focus Field?';

  @override
  String get ratingPromptBody => 'A quick 5-star rating helps others discover calmer focus time.';

  @override
  String get ratingPromptRateNow => 'Rate Now';

  @override
  String get ratingPromptLater => 'Later';

  @override
  String get ratingPromptNoThanks => 'No Thanks';

  @override
  String get ratingThankYou => 'Thanks for your support!';

  @override
  String get notificationSettingsTitle => 'Notification Settings';

  @override
  String get notificationPermissionRequired => 'Notification Permission Required';

  @override
  String get notificationPermissionRationale => 'Enable notifications to receive gentle reminders and celebrate achievements.';

  @override
  String get requesting => 'Requesting...';

  @override
  String get enableNotificationsCta => 'Enable Notifications';

  @override
  String get enableNotificationsTitle => 'Enable Notifications';

  @override
  String get enableNotificationsSubtitle => 'Allow Focus Field to send notifications';

  @override
  String get dailyReminderTitle => 'Smart Daily Reminders';

  @override
  String get dailyReminderSubtitle => 'Smart or chosen time';

  @override
  String get dailyTimeLabel => 'Daily Time';

  @override
  String get dailyTimeHint => 'Choose a fixed time or let Focus Field learn your pattern.';

  @override
  String get useSmartCta => 'Use Smart';

  @override
  String get sessionCompletedTitle => 'Session Completed';

  @override
  String get sessionCompletedSubtitle => 'Celebrate completed sessions';

  @override
  String get achievementUnlockedTitle => 'Achievement Unlocked';

  @override
  String get achievementUnlockedSubtitle => 'Milestone notifications';

  @override
  String get weeklySummaryTitle => 'Weekly Progress Summary';

  @override
  String get weeklySummarySubtitle => 'Weekly insights (weekday & time)';

  @override
  String get weeklyTimeLabel => 'Weekly Time';

  @override
  String get notificationPreview => 'Notification Preview';

  @override
  String get dailySilenceReminderTitle => 'Daily Focus Reminder';

  @override
  String get weeklyProgressReportTitle => 'Weekly Progress Report 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Achievement Unlocked! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session Complete! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session Ended';

  @override
  String get reminderStartJourney => '🎯 Start your focus journey today! Build your deep work habit.';

  @override
  String get reminderRestart => '🌱 Ready to restart your focus practice? Every moment is a new beginning.';

  @override
  String get reminderDayTwo => '⭐ Day 2 of your focus streak! Consistency builds concentration.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak-day streak! You\'re building a powerful focus habit.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Amazing $streak-day streak! Your dedication is inspiring.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Incredible $streak-day streak! You\'re a focus champion!';
  }

  @override
  String get achievementFirstSession => '🎉 First session complete! Welcome to Focus Field!';

  @override
  String get achievementWeekStreak => '🌟 7-day streak achieved! Consistency is your superpower!';

  @override
  String get achievementMonthStreak => '🏆 30-day streak unlocked! You\'re unstoppable!';

  @override
  String get achievementPerfectSession => '✨ Perfect session! 100% calm environment maintained!';

  @override
  String get achievementLongSession => '⏰ Extended session master! Your focus grows stronger.';

  @override
  String get achievementGeneric => '🎊 Achievement unlocked! Keep up the great work!';

  @override
  String get weeklyProgressNone => '💭 Start your weekly goal! Ready for a focused session?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count focus minutes this week! Every session counts.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count focus minutes earned! You\'re on track!';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 $count focus minutes achieved! Perfect week!';
  }

  @override
  String get tipsHidden => 'Tips hidden';

  @override
  String get tipsShown => 'Tips shown';

  @override
  String get showTips => 'Show Tips';

  @override
  String get hideTips => 'Hide Tips';

  @override
  String get tip01 => 'Start small—even 2 minutes builds your focus habit.';

  @override
  String get tip02 => 'Your streak has grace—one miss won\'t break it with the 2-Day Rule.';

  @override
  String get tip03 => 'Try Study, Reading, or Meditation activities to match your focus style.';

  @override
  String get tip04 => 'Check your 12-week Heatmap to see how small wins compound over time.';

  @override
  String get tip05 => 'Watch your live Calm % during sessions—higher scores mean better focus!';

  @override
  String get tip06 => 'Customize your daily goal (10-60 min) to match your rhythm.';

  @override
  String get tip07 => 'Use your monthly Freeze Token to protect your streak on tough days.';

  @override
  String get tip08 => 'After 3 wins, Focus Field suggests a stricter threshold—ready to level up?';

  @override
  String get tip09 => 'High ambient noise? Raise your threshold to stay in the zone.';

  @override
  String get tip10 => 'Smart Daily Reminders learn your best time—let them guide you.';

  @override
  String get tip11 => 'The progress ring is tappable—one tap starts your focus session.';

  @override
  String get tip12 => 'Recalibrate when your environment changes for better accuracy.';

  @override
  String get tip13 => 'Session notifications celebrate your wins—enable them for motivation!';

  @override
  String get tip14 => 'Consistency beats perfection—show up, even on busy days.';

  @override
  String get tip15 => 'Try different times of day to discover your quiet sweet spot.';

  @override
  String get tip16 => 'Your daily progress is always visible—tap Go to start anytime.';

  @override
  String get tip17 => 'Each activity tracks separately toward your goal—variety keeps it fresh.';

  @override
  String get tip18 => 'Export your data (Premium) to see your complete focus journey.';

  @override
  String get tip19 => 'Confetti celebrates every completion—small wins deserve recognition!';

  @override
  String get tip20 => 'Your baseline matters—calibrate when moving to new spaces.';

  @override
  String get tip21 => 'Your 7-Day Trends reveal patterns—check them weekly for insights.';

  @override
  String get tip22 => 'Upgrade session duration (Premium) for longer deep focus blocks.';

  @override
  String get tip23 => 'Focus is a practice—small sessions build the habit you want.';

  @override
  String get tip24 => 'Weekly Summary shows your rhythm—tune it to your schedule.';

  @override
  String get tip25 => 'Fine-tune your threshold for your space—every room is different.';

  @override
  String get tip26 => 'Accessibility options help everyone focus—high contrast, large text, vibration.';

  @override
  String get tip27 => 'Today Timeline shows when you focused—find your productive hours.';

  @override
  String get tip28 => 'Finish what you start—shorter sessions mean more completions.';

  @override
  String get tip29 => 'Quiet Minutes add up toward your goal—progress over perfection.';

  @override
  String get tip30 => 'You\'re one tap away—start a tiny session right now.';

  @override
  String get tipInstructionNotifications => 'Settings → Advanced → Notifications to configure reminders and celebrations.';

  @override
  String get tipInstructionWeeklySummary => 'Settings → Advanced → Notifications → Weekly Summary to pick weekday & time.';

  @override
  String get tipInstructionThreshold => 'Settings → Basic → Decibel Threshold. Calibrate first, then fine‑tune.';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get tipInstructionSetTime => 'Settings → Basic → Session duration';

  @override
  String get tipInstructionDailyReminders => 'Settings → Advanced → Notifications → Smart Daily Reminders.';

  @override
  String get tipInstructionCalibrate => 'Settings → Advanced → Noise Calibration.';

  @override
  String get tipInstructionOpenAnalytics => 'Open Analytics to view trends and averages.';

  @override
  String get tipInstructionSessionComplete => 'Settings → Advanced → Notifications → Session Completed.';

  @override
  String get tipInstructionTapRing => 'On Home, tap the progress ring to start/stop.';

  @override
  String get tipInstructionExport => 'Settings → Advanced → Export Data.';

  @override
  String get tipInstructionOpenNoiseChart => 'Start a session to see the real‑time noise chart.';

  @override
  String get tipInstructionUpgradeDuration => 'Settings → Basic → Session duration. Upgrade for longer blocks.';

  @override
  String get tipInstructionAccessibility => 'Settings → Advanced → Accessibility.';

  @override
  String get tipInstructionStartNow => 'Tap Start Session on the Home screen.';

  @override
  String get tipInstructionHeatmap => 'Summary tab → Show More → Heatmap';

  @override
  String get tipInstructionTodayTimeline => 'Summary tab → Show More → Today Timeline';

  @override
  String get tipInstruction7DayTrends => 'Summary tab → Show More → 7-Day Trends';

  @override
  String get tipInstructionEditActivities => 'Activity tab → tap Edit to show/hide activities';

  @override
  String get tipInstructionQuestGo => 'Activity tab → Quest Capsule → tap Go';

  @override
  String get tipInfoTooltip => 'Show tip';

  @override
  String get questCapsuleTitle => 'Ambient Quest';

  @override
  String get questCapsuleLoading => 'Calm minutes loading…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Calm $progress/$goal min • Streak $streak';
  }

  @override
  String get questFreezeButton => 'Freeze';

  @override
  String get questFrozenToday => 'Today frozen — you\'re covered.';

  @override
  String get questGoButton => 'Go';

  @override
  String calmPercent(int percent) {
    return 'Calm $percent%';
  }

  @override
  String get calmLabel => 'Calm';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get freeze => 'freeze';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3 wins! Try $threshold dB?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Not Now';

  @override
  String get adaptiveThresholdTryIt => 'Try It';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Threshold set to $threshold dB';
  }

  @override
  String get edit => 'Edit';

  @override
  String get start => 'Start';

  @override
  String get error => 'Error';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get faqTitle => 'Frequently Asked Questions';

  @override
  String get faqSearchHint => 'Search FAQs...';

  @override
  String get faqNoResults => 'No results found';

  @override
  String get faqNoResultsSubtitle => 'Try a different search term';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results found',
      one: '1 result found',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => 'What is Focus Field and how does it help me focus?';

  @override
  String get faqA01 => 'Focus Field helps you build better focus habits by monitoring ambient noise in your environment. When you start a session (Study, Reading, Meditation, or Other), the app measures how quiet your environment is. The quieter you keep it, the more \"focus minutes\" you earn. This encourages you to find and maintain distraction-free spaces for deep work.';

  @override
  String get faqQ02 => 'How does Focus Field measure my focus?';

  @override
  String get faqA02 => 'Focus Field monitors the ambient noise level in your environment during your session. It calculates an \"Ambient Score\" by tracking how many seconds your environment stays below your chosen noise threshold. If your session has at least 70% quiet time (Ambient Score ≥70%), you earn full credit for those quiet minutes.';

  @override
  String get faqQ03 => 'Does Focus Field record my audio or conversations?';

  @override
  String get faqA03 => 'No, absolutely not. Focus Field only measures decibel levels (loudness) - it never records, stores, or transmits any audio. Your privacy is completely protected. The app simply checks if your environment is above or below your chosen threshold.';

  @override
  String get faqQ04 => 'What activities can I track with Focus Field?';

  @override
  String get faqA04 => 'Focus Field comes with four activity types: Study 📚 (for learning and research), Reading 📖 (for focused reading), Meditation 🧘 (for mindfulness practice), and Other ⭐ (for any focus-requiring activity). All activities use ambient noise monitoring to help you maintain a quiet, focused environment.';

  @override
  String get faqQ05 => 'Should I use Focus Field for all my activities?';

  @override
  String get faqA05 => 'Focus Field works best for activities where ambient noise indicates your level of focus. Activities like Study, Reading, and Meditation benefit most from quiet environments. While you can track \"Other\" activities, we recommend using Focus Field primarily for noise-sensitive focus work.';

  @override
  String get faqQ06 => 'How do I start a focus session?';

  @override
  String get faqA06 => 'Go to the Sessions tab, select your activity (Study, Reading, Meditation, or Other), choose your session duration (1, 5, 10, 15, 30 minutes, or premium options), tap the Start button on the progress ring, and keep your environment quiet!';

  @override
  String get faqQ07 => 'What session durations are available?';

  @override
  String get faqA07 => 'Free users can choose: 1, 5, 10, 15, or 30-minute sessions. Premium users also get: 1 hour, 1.5 hours, and 2-hour extended sessions for longer deep work periods.';

  @override
  String get faqQ08 => 'Can I pause or stop a session early?';

  @override
  String get faqA08 => 'Yes! During a session, you\'ll see Pause and Stop buttons above the progress ring. To prevent accidental taps, you need to long-press these buttons. If you stop early, you\'ll still earn points for the quiet minutes you accumulated.';

  @override
  String get faqQ09 => 'How do I earn points in Focus Field?';

  @override
  String get faqA09 => 'You earn 1 point per quiet minute. During your session, Focus Field tracks how many seconds your environment stays below the noise threshold. At the end, those quiet seconds are converted to minutes. For example, if you complete a 10-minute session with 8 minutes of quiet time, you earn 8 points.';

  @override
  String get faqQ10 => 'What is the 70% threshold and why does it matter?';

  @override
  String get faqA10 => 'The 70% threshold determines if your session counts toward your daily goal. If your Ambient Score (quiet time ÷ total time) is at least 70%, your session qualifies for quest credit. Even if you\'re under 70%, you still earn points for every quiet minute!';

  @override
  String get faqQ11 => 'What\'s the difference between Ambient Score and points?';

  @override
  String get faqA11 => 'Ambient Score is your session quality as a percentage (quiet seconds ÷ total seconds), determining if you hit the 70% threshold. Points are the actual quiet minutes earned (1 point = 1 minute). Ambient Score = quality, Points = achievement.';

  @override
  String get faqQ12 => 'How do streaks work in Focus Field?';

  @override
  String get faqA12 => 'Streaks track consecutive days of meeting your daily goal. Focus Field uses a compassionate 2-Day Rule: Your streak only breaks if you miss two consecutive days. This means you can miss one day and your streak continues if you complete your goal the next day.';

  @override
  String get faqQ13 => 'What are freeze tokens and how do I use them?';

  @override
  String get faqA13 => 'Freeze tokens protect your streak when you can\'t complete your goal. You get 1 free freeze token per month. When used, your overall progress shows 100% (goal protected), your streak is safe, and individual activity tracking continues normally. Use it wisely for busy days!';

  @override
  String get faqQ14 => 'Can I customize my daily focus goal?';

  @override
  String get faqA14 => 'Yes! Tap Edit on the Sessions card in the Today tab. You can set your global daily goal (10-60 minutes for free, up to 1080 minutes for premium), enable per-activity goals for separate targets, and show/hide specific activities.';

  @override
  String get faqQ15 => 'What is the noise threshold and how do I adjust it?';

  @override
  String get faqA15 => 'The threshold is the maximum noise level (in decibels) that counts as \"quiet.\" Default is 40 dB (library quiet). You can adjust it in the Sessions tab: 30 dB (very quiet), 40 dB (library quiet - recommended), 50 dB (moderate office), 60-80 dB (louder environments).';

  @override
  String get faqQ16 => 'What is Adaptive Threshold and should I use it?';

  @override
  String get faqA16 => 'After 3 consecutive successful sessions at your current threshold, Focus Field suggests increasing it by 2 dB to challenge yourself. This helps you gradually improve. You can accept or dismiss the suggestion - it only appears once every 7 days.';

  @override
  String get faqQ17 => 'What is Focus Mode?';

  @override
  String get faqA17 => 'Focus Mode is a full-screen distraction-free overlay during your session. It shows your countdown timer, live calm percentage, and minimal controls (Pause/Stop via long-press). It removes all other UI elements so you can concentrate fully. Enable it in Settings > Basic > Focus Mode.';

  @override
  String get faqQ18 => 'Why does Focus Field need microphone permission?';

  @override
  String get faqA18 => 'Focus Field uses your device\'s microphone to measure ambient noise levels (decibels) during sessions. This is essential to calculate your Ambient Score. Remember: no audio is ever recorded - only noise levels are measured in real-time.';

  @override
  String get faqQ19 => 'Can I see my focus patterns over time?';

  @override
  String get faqA19 => 'Yes! The Today tab shows your daily progress, weekly trends, 12-week activity heatmap (like GitHub contributions), and session timeline. Premium users get advanced analytics with performance metrics, moving averages, and AI-powered insights.';

  @override
  String get faqQ20 => 'How do notifications work in Focus Field?';

  @override
  String get faqA20 => 'Focus Field has smart reminders: Daily Reminders (learns your preferred focus time or use a fixed time), Session Completion notifications with results, Achievement notifications for milestones, and Weekly Summary (Premium). Enable/customize in Settings > Advanced > Notifications.';

  @override
  String get microphoneSettingsTitle => 'Settings Required';

  @override
  String get microphoneSettingsMessage => 'To enable silence detection, manually grant microphone permission:\n\n• iOS: Settings > Privacy & Security > Microphone > Focus Field\n• Android: Settings > Apps > Focus Field > Permissions > Microphone';

  @override
  String get buttonGrantPermission => 'Grant Permission';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => 'Open Settings';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingWelcomeSnackbar => 'Welcome! Ready to start your first session? 🚀';

  @override
  String get onboardingWelcomeTitle => 'Welcome to\nFocus Field! 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'Your journey to better focus starts here!\nLet\'s build habits that stick 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Track Your Focus';

  @override
  String get onboardingFeatureTrackDesc => 'See your progress in real-time as you build your focus superpower! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Earn Rewards';

  @override
  String get onboardingFeatureRewardsDesc => 'Every quiet minute counts! Collect points and celebrate your wins 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Build Streaks';

  @override
  String get onboardingFeatureStreaksDesc => 'Keep the momentum going! Our compassionate system keeps you motivated 🔥';

  @override
  String get onboardingEnvironmentTitle => 'Where\'s Your Focus Zone? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'Choose your typical environment so we can optimize for your space!';

  @override
  String get onboardingEnvQuietHomeTitle => 'Quiet Home';

  @override
  String get onboardingEnvQuietHomeDesc => 'Bedroom, quiet home office';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Very quiet';

  @override
  String get onboardingEnvOfficeTitle => 'Typical Office';

  @override
  String get onboardingEnvOfficeDesc => 'Standard office, library';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Library quiet (Recommended)';

  @override
  String get onboardingEnvBusyTitle => 'Busy Space';

  @override
  String get onboardingEnvBusyDesc => 'Coffee shop, shared workspace';

  @override
  String get onboardingEnvBusyDb => '50 dB - Moderate noise';

  @override
  String get onboardingEnvNoisyTitle => 'Noisy Environment';

  @override
  String get onboardingEnvNoisyDesc => 'Open office, public space';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Higher noise';

  @override
  String get onboardingEnvAdjustNote => 'You can adjust this anytime in Settings';

  @override
  String get onboardingGoalTitle => 'Set Your Daily Goal! 🎯';

  @override
  String get onboardingGoalSubtitle => 'How much focused time feels right for you?\n(You can adjust this anytime!)';

  @override
  String get onboardingGoalStartingTitle => 'Getting Started';

  @override
  String get onboardingGoalStartingDuration => '10-15 minutes';

  @override
  String get onboardingGoalHabitTitle => 'Building Habit';

  @override
  String get onboardingGoalHabitDuration => '20-30 minutes';

  @override
  String get onboardingGoalPracticeTitle => 'Regular Practice';

  @override
  String get onboardingGoalPracticeDuration => '40-60 minutes';

  @override
  String get onboardingGoalDeepWorkTitle => 'Deep Work';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ minutes';

  @override
  String get onboardingGoalAdvice1 => 'Perfect start! 🌟 Small steps lead to big wins. You\'ve got this!';

  @override
  String get onboardingGoalAdvice2 => 'Excellent choice! 🎯 This sweet spot builds lasting habits!';

  @override
  String get onboardingGoalAdvice3 => 'Ambitious! 💪 You\'re ready to level up your focus game!';

  @override
  String get onboardingGoalAdvice4 => 'Wow! 🏆 Deep work mode activated! Remember to take breaks!';

  @override
  String get onboardingActivitiesTitle => 'Choose Your Activities! ✨';

  @override
  String get onboardingActivitiesSubtitle => 'Pick all that resonate with you!\n(You can always add more later)';

  @override
  String get onboardingActivityStudyTitle => 'Study';

  @override
  String get onboardingActivityStudyDesc => 'Learning, coursework, research';

  @override
  String get onboardingActivityReadingTitle => 'Reading';

  @override
  String get onboardingActivityReadingDesc => 'Deep reading, articles, books';

  @override
  String get onboardingActivityMeditationTitle => 'Meditation';

  @override
  String get onboardingActivityMeditationDesc => 'Mindfulness, breathing exercises';

  @override
  String get onboardingActivityOtherTitle => 'Other';

  @override
  String get onboardingActivityOtherDesc => 'Any focus-requiring activity';

  @override
  String get onboardingActivitiesTip => 'Pro tip: Focus Field shines when quiet = focused! 🤫✨';

  @override
  String get onboardingPermissionTitle => 'Your Privacy Matters! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'We need microphone access to measure ambient noise and help you focus better';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'No Recording';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'We only measure noise levels, never record audio';

  @override
  String get onboardingPrivacyLocalTitle => 'Local Only';

  @override
  String get onboardingPrivacyLocalDesc => 'All data stays on your device';

  @override
  String get onboardingPrivacyFirstTitle => 'Privacy First';

  @override
  String get onboardingPrivacyFirstDesc => 'Your conversations are completely private';

  @override
  String get onboardingPermissionNote => 'You can grant permission on the next screen when starting your first session';

  @override
  String get onboardingTipsTitle => 'Pro Tips for Success! 💡';

  @override
  String get onboardingTipsSubtitle => 'These will help you make the most of Focus Field!';

  @override
  String get onboardingTip1Title => 'Start Small, Win Big! 🌱';

  @override
  String get onboardingTip1Desc => 'Begin with 5-10 minute sessions. Consistency beats perfection!';

  @override
  String get onboardingTip2Title => 'Activate Focus Mode! 🎯';

  @override
  String get onboardingTip2Desc => 'Tap Focus Mode for immersive, distraction-free experience.';

  @override
  String get onboardingTip3Title => 'Freeze Token = Safety Net! ❄️';

  @override
  String get onboardingTip3Desc => 'Use your monthly token on busy days to protect your streak.';

  @override
  String get onboardingTip4Title => 'The 70% Rule Rocks! 📈';

  @override
  String get onboardingTip4Desc => 'Aim for 70% quiet time - perfect silence not required!';

  @override
  String get onboardingReadyTitle => 'You\'re Ready to Launch! 🚀';

  @override
  String get onboardingReadyDesc => 'Let\'s start your first session and build amazing habits!';

  @override
  String get questMotivation1 => 'Success is never ending and failure is never final';

  @override
  String get questMotivation2 => 'Progress over perfection - every minute counts';

  @override
  String get questMotivation3 => 'Small steps daily lead to big changes';

  @override
  String get questMotivation4 => 'You\'re building better habits, one session at a time';

  @override
  String get questMotivation5 => 'Consistency beats intensity';

  @override
  String get questMotivation6 => 'Every session is a win, no matter how short';

  @override
  String get questMotivation7 => 'Focus is a muscle - you\'re getting stronger';

  @override
  String get questMotivation8 => 'The journey of a thousand miles begins with a single step';

  @override
  String get questGo => 'Go';

  @override
  String get questTapStart => 'Tap Start →';

  @override
  String get todayDashboardTitle => 'Your Focus Dashboard';

  @override
  String get todayFocusMinutes => 'Focus minutes today';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Goal: $goalMinutes min • Calm ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Pick your mode';

  @override
  String get todayDefaultActivities => 'Study • Reading • Meditation';

  @override
  String get todayTooltipTips => 'Tips';

  @override
  String get todayTooltipTheme => 'Theme';

  @override
  String get todayTooltipSettings => 'Settings';

  @override
  String todayThemeChanged(String themeName) {
    return 'Theme changed to $themeName';
  }

  @override
  String get todayTabToday => 'Today';

  @override
  String get todayTabSessions => 'Sessions';

  @override
  String get todayHelperText => 'Set your duration and track your time. Session history and analytics will appear in Summary.';

  @override
  String get statPoints => 'Points';

  @override
  String get statStreak => 'Streak';

  @override
  String get statSessions => 'Sessions';

  @override
  String get ringProgressTitle => 'Ring Progress';

  @override
  String get ringOverall => 'Overall';

  @override
  String get ringOverallFrozen => 'Overall ❄️';

  @override
  String get sessionCalm => 'Calm';

  @override
  String get sessionStart => 'Start';

  @override
  String get sessionStop => 'Stop';

  @override
  String get buttonEdit => 'Edit';

  @override
  String get durationUpTo1Hour => 'Sessions up to 1 hour';

  @override
  String get durationUpTo1_5Hours => 'Sessions up to 1.5 hours';

  @override
  String get durationUpTo2Hours => 'Sessions up to 2 hours';

  @override
  String get durationExtended => 'Extended session durations';

  @override
  String get durationExtendedAccess => 'Extended session access';

  @override
  String get noiseRoomLoudness => 'Room Loudness';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Threshold: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Threshold set to $db dB';
  }

  @override
  String get noiseHighDetected => 'High noise detected, please proceed to a quieter room for better focus';

  @override
  String get noiseThresholdExceededHint => 'Find a quieter room or increase threshold →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'Find a quieter room or increase to ${db}dB?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'High noise detected. Increase to ${db}dB?';
  }

  @override
  String get noiseAtMaxThreshold => 'Already at maximum threshold. Please find a quieter room.';

  @override
  String get noiseThresholdYes => 'Yes';

  @override
  String get noiseThresholdNo => 'No';

  @override
  String get trendsInsights => 'Insights';

  @override
  String get trendsLast7Days => 'Last 7 Days';

  @override
  String get trendsShareWeeklySummary => 'Share weekly summary';

  @override
  String get trendsLoading => 'Loading...';

  @override
  String get trendsLoadingMetrics => 'Loading metrics...';

  @override
  String get trendsNoData => 'No data';

  @override
  String get trendsWeeklyTotal => 'Weekly Total';

  @override
  String get trendsBestDay => 'Best Day';

  @override
  String get trendsActivityHeatmap => 'Activity Heatmap';

  @override
  String get trendsRecentActivity => 'Recent activity';

  @override
  String get trendsHeatmapError => 'Unable to load heatmap';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get focusModeComplete => 'Session Complete!';

  @override
  String get focusModeGreatSession => 'Great focus session';

  @override
  String get focusModeResume => 'Resume';

  @override
  String get focusModePause => 'Pause';

  @override
  String get focusModeLongPressHint => 'Long press to pause or stop';

  @override
  String get activityEditTitle => 'Edit Activities';

  @override
  String get activityRecommendation => 'Recommended: 10+ min per activity for consistent habit building';

  @override
  String get activityDailyGoals => 'Daily Goals';

  @override
  String activityTotalHours(String hours) {
    return 'Total: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Per-Activity';

  @override
  String get activityExceedsLimit => 'Total exceeds 18-hour daily limit. Please reduce goals.';

  @override
  String get activityGoalLabel => 'Goal';

  @override
  String get activityGoalDescription => 'Set your daily focus target (1 min - 18h)';

  @override
  String get shareYourProgress => 'Share Your Progress';

  @override
  String get shareTimeRange => 'Time Range';

  @override
  String get shareCardSize => 'Card Size';

  @override
  String get analyticsPerformanceMetrics => 'Performance Metrics';

  @override
  String get analyticsPreferredDuration => 'Preferred Duration';

  @override
  String get analyticsUnavailable => 'Analytics unavailable';

  @override
  String get analyticsRestoreAttempt => 'We\'ll attempt to restore this section on the next app launch.';

  @override
  String get audioUnavailable => 'Audio temporarily unavailable';

  @override
  String get audioRecovering => 'Audio processing encountered an issue. Recovering automatically...';

  @override
  String get shareQuietMinutes => 'QUIET MINUTES';

  @override
  String get shareTopActivity => 'Top Activity';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Preview';

  @override
  String get sharePinchToZoom => 'Pinch to zoom';

  @override
  String get shareGenerating => 'Generating...';

  @override
  String get shareButton => 'Share';

  @override
  String get shareTodayLabel => 'Today';

  @override
  String get shareWeeklyLabel => 'Weekly';

  @override
  String get shareTodayTitle => 'Today\'s Focus';

  @override
  String get shareWeeklyTitle => 'Your Weekly Focus';

  @override
  String get shareSubject => 'My Focus Field Progress';

  @override
  String get shareFormatSquare => '1:1 ratio • Universal compatibility';

  @override
  String get shareFormatPost => '4:5 ratio • Instagram/Twitter posts';

  @override
  String get shareFormatStory => '9:16 ratio • Instagram Stories';

  @override
  String get recapWeeklyTitle => 'Weekly Recap';

  @override
  String get recapMinutes => 'Minutes';

  @override
  String recapStreak(int start, int end) {
    return 'Streak: $start → $end days';
  }

  @override
  String get recapTopActivity => 'Top Activity: ';

  @override
  String get practiceOverviewTitle => 'Practice Overview';

  @override
  String get practiceLast7Days => 'Last 7 Days';

  @override
  String get audioMultipleErrors => 'Multiple audio errors detected. Component recovering...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Current goal: $goal';
  }

  @override
  String get activitySaveChanges => 'Save Changes';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsTooltip => 'View detailed insights';

  @override
  String get statDays => 'DAYS';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Total Today $done/$goal min, choose any activity';
  }

  @override
  String get premiumFeature => 'Premium Feature';

  @override
  String get premiumFeatureAccess => 'Premium feature access';

  @override
  String get activityUnknown => 'Unknown';

  @override
  String get insightsFirstSessionTitle => 'Complete your first session';

  @override
  String get insightsFirstSessionSubtitle => 'Start tracking your focus time, session patterns, and ambient score trends';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Ambient: $percent%';
  }

  @override
  String get sessionSuccess => 'Success';

  @override
  String get sessionFailed => 'Failed';

  @override
  String get focusModeButton => 'Focus Mode';

  @override
  String get settingsDailyGoalsTitle => 'Daily Goals';

  @override
  String get settingsFocusModeDescription => 'Minimize distractions during sessions with a focused overlay';

  @override
  String get settingsDeepFocusTitle => 'Deep Focus';

  @override
  String get settingsDeepFocusDescription => 'End session if app is left';

  @override
  String get deepFocusDialogTitle => 'Deep Focus';

  @override
  String get deepFocusEnableLabel => 'Enable Deep Focus';

  @override
  String get deepFocusGracePeriodLabel => 'Grace period (seconds)';

  @override
  String get deepFocusExplanation => 'When enabled, leaving the app will end the session after the grace period.';

  @override
  String get notificationPermissionTitle => 'Enable Notifications';

  @override
  String get notificationPermissionExplanation => 'Focus Field needs notification permission to send you:';

  @override
  String get notificationBenefitReminders => 'Daily focus reminders';

  @override
  String get notificationBenefitCompletion => 'Session completion alerts';

  @override
  String get notificationBenefitAchievements => 'Achievement celebrations';

  @override
  String get notificationHowToEnableIos => 'How to enable on iOS:';

  @override
  String get notificationHowToEnableAndroid => 'How to enable on Android:';

  @override
  String get notificationStepsIos => '1. Tap \"Open Settings\" below\n2. Tap \"Notifications\"\n3. Enable \"Allow Notifications\"';

  @override
  String get notificationStepsAndroid => '1. Tap \"Open Settings\" below\n2. Tap \"Notifications\"\n3. Enable \"All Focus Field notifications\"';

  @override
  String get aboutShowTips => 'Show Tips';

  @override
  String get aboutShowTipsDescription => 'Show helpful tips on app startup and via the lightbulb icon. Tips appear every 2-3 days.';

  @override
  String get aboutReplayOnboarding => 'Replay Onboarding';

  @override
  String get aboutReplayOnboardingDescription => 'Review the app tour and setup your preferences again';

  @override
  String get buttonFaq => 'FAQ';

  @override
  String get onboardingWelcomeMessage => 'Welcome! Ready to start your first session? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Earn Rewards';

  @override
  String get onboardingFeatureEarnDesc => 'Every quiet minute counts! Collect points and celebrate your wins 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Build Streaks';

  @override
  String get onboardingFeatureBuildDesc => 'Keep the momentum going! Our compassionate system keeps you motivated 🔥';

  @override
  String get onboardingEnvironmentDescription => 'Choose your typical environment so we can optimize for your space!';

  @override
  String get onboardingEnvQuietHome => 'Quiet Home';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Very quiet';

  @override
  String get onboardingEnvOffice => 'Typical Office';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Library quiet (Recommended)';

  @override
  String get onboardingEnvBusy => 'Busy Space';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Moderate noise';

  @override
  String get onboardingEnvNoisy => 'Noisy Environment';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Higher noise';

  @override
  String get onboardingAdjustAnytime => 'You can adjust this anytime in Settings';

  @override
  String get buttonGetStarted => 'Get Started';

  @override
  String get buttonNext => 'Next';

  @override
  String get errorActivityRequired => '⚠️ At least one activity must be enabled';

  @override
  String get errorGoalExceeds => 'Total goals exceed 18-hour daily limit. Please reduce goals.';

  @override
  String get messageSaved => 'Settings saved';

  @override
  String get errorPermissionRequired => 'Permission required';

  @override
  String get notificationEnableReason => 'Enable notifications to receive reminders and celebrate achievements.';

  @override
  String get buttonEnableNotifications => 'Enable Notifications';

  @override
  String get buttonRequesting => 'Requesting...';

  @override
  String get notificationDailyTime => 'Daily Time';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Daily reminder at $time';
  }

  @override
  String get notificationLearning => 'learning';

  @override
  String notificationSmart(String time) {
    return 'Smart ($time)';
  }

  @override
  String get buttonUseSmart => 'Use Smart';

  @override
  String get notificationSmartExplanation => 'Choose a fixed time or let Focus Field learn your pattern.';

  @override
  String get notificationSessionComplete => 'Session Completed';

  @override
  String get notificationSessionCompleteDesc => 'Celebrate completed sessions';

  @override
  String get notificationAchievement => 'Achievement Unlocked';

  @override
  String get notificationAchievementDesc => 'Milestone notifications';

  @override
  String get notificationWeekly => 'Weekly Progress Summary';

  @override
  String get notificationWeeklyDesc => 'Weekly insights (weekday & time)';

  @override
  String get notificationWeeklyTime => 'Weekly Time';

  @override
  String get notificationMilestone => 'Milestone notifications';

  @override
  String get notificationWeeklyInsights => 'Weekly insights (weekday & time)';

  @override
  String get notificationDailyReminder => 'Daily Reminder';

  @override
  String get notificationComplete => 'Session Complete';

  @override
  String get settingsSnackbar => 'Please enable notifications in device settings';

  @override
  String get shareCardTitle => 'Share Card';

  @override
  String get shareYourWeek => 'Share Your Week';

  @override
  String get shareStyleGradient => 'Gradient Style';

  @override
  String get shareStyleGradientDesc => 'Bold gradient with large numbers';

  @override
  String get shareWeeklySummary => 'Weekly Summary';

  @override
  String get shareStyleAchievement => 'Achievement Style';

  @override
  String get shareStyleAchievementDesc => 'Focus on total quiet minutes';

  @override
  String get shareQuietMinutesWeek => 'Quiet Minutes This Week';

  @override
  String get shareAchievementMessage => 'Building deeper focus,\\none session at a time';

  @override
  String get shareAchievementCard => 'Achievement Card';

  @override
  String get shareTextOnly => 'Text Only';

  @override
  String get shareTextOnlyDesc => 'Share as plain text (no image)';

  @override
  String get shareYourStreak => 'Share Your Streak';

  @override
  String get shareAsCard => 'Share as Card';

  @override
  String get shareAsCardDesc => 'Beautiful visual card';

  @override
  String get shareStreakCard => 'Streak Card';

  @override
  String get shareAsText => 'Share as Text';

  @override
  String get shareAsTextDesc => 'Simple text message';

  @override
  String get shareErrorFailed => 'Failed to share. Please try again.';

  @override
  String get buttonShare => 'Share';

  @override
  String get initializingApp => 'Initializing app...';

  @override
  String initializationFailed(String error) {
    return 'Initialization failed: $error';
  }

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Settings loading failed: $error';
  }

  @override
  String get loadingUserData => 'Loading user data...';

  @override
  String dataLoadingFailed(String error) {
    return 'Data loading failed: $error';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get taglineSilence => '🤫 Master the Art of Silence';

  @override
  String get errorOops => 'Oops! Something went wrong';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get resetAppData => 'Reset App Data';

  @override
  String get resetAppDataMessage => 'This will reset all app data and settings to their defaults. This action cannot be undone.\\n\\nDo you want to continue?';

  @override
  String get buttonReset => 'Reset';

  @override
  String get messageDataReset => 'App data has been reset';

  @override
  String errorResetFailed(String error) {
    return 'Failed to reset data: $error';
  }

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsOverview => 'Overview';

  @override
  String get analyticsPoints => 'Points';

  @override
  String get analyticsStreak => 'Streak';

  @override
  String get analyticsSessions => 'Sessions';

  @override
  String get analyticsLast7Days => 'Last 7 Days';

  @override
  String get analyticsPerformanceHighlights => 'Performance Highlights';

  @override
  String get analyticsSuccessRate => 'Success Rate';

  @override
  String get analyticsAvgSession => 'Avg Session';

  @override
  String get analyticsBestStreak => 'Best Streak';

  @override
  String get analyticsActivityProgress => 'Activity Progress';

  @override
  String get analyticsComingSoon => 'Detailed activity tracking coming soon.';

  @override
  String get analyticsAdvancedMetrics => 'Advanced Metrics';

  @override
  String get analyticsPremiumContent => 'Premium advanced analytics content here...';

  @override
  String get analytics30DayTrends => '30-Day Trends';

  @override
  String get analyticsTrendsChart => 'Premium trends chart here...';

  @override
  String get analyticsAIInsights => 'AI Insights';

  @override
  String get analyticsAIComingSoon => 'AI-powered insights coming soon...';

  @override
  String get analyticsUnlock => 'Unlock Advanced Analytics';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorQuestUnavailable => 'Quest state not available';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Failed to use freeze token';

  @override
  String get buttonUseFreeze => 'Use Freeze';

  @override
  String get onboardingDailyGoalTitle => 'Set Your Daily Goal! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'How much focused time feels right for you?\\n(You can adjust this anytime!)';

  @override
  String get onboardingGoalGettingStarted => 'Getting Started';

  @override
  String get onboardingGoalBuildingHabit => 'Building Habit';

  @override
  String get onboardingGoalRegularPractice => 'Regular Practice';

  @override
  String get onboardingGoalDeepWork => 'Deep Work';

  @override
  String get onboardingProTip => 'Pro tip: Focus Field shines when quiet = focused! 🤫✨';

  @override
  String get onboardingPrivacyTitle => 'Your Privacy Matters! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'We need microphone access to measure ambient noise and help you focus better';

  @override
  String get onboardingPrivacyNoRecording => 'No Recording';

  @override
  String get onboardingPrivacyLocalOnly => 'Local Only';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'All data stays on your device';

  @override
  String get onboardingPrivacyFirst => 'Privacy First';

  @override
  String get onboardingPrivacyNote => 'You can grant permission on the next screen when starting your first session';

  @override
  String get insightsFocusTime => 'Focus Time';

  @override
  String get insightsSessions => 'Sessions';

  @override
  String get insightsAverage => 'Average';

  @override
  String get insightsAmbientScore => 'Ambient Score';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOceanBlue => 'Ocean Blue';

  @override
  String get themeForestGreen => 'Forest Green';

  @override
  String get themePurpleNight => 'Purple Night';

  @override
  String get themeGoldLuxury => 'Gold Luxury';

  @override
  String get themeSolarSunrise => 'Solar Sunrise';

  @override
  String get themeCyberNeon => 'Cyber Neon';

  @override
  String get themeMidnightTeal => 'Midnight Teal';

  @override
  String get settingsAppTheme => 'App Theme';

  @override
  String get freezeTokenNoTokensTitle => 'No Freeze Tokens';

  @override
  String get freezeTokenNoTokensMessage => 'You don\'t have any freeze tokens available. You earn 1 freeze token per week (max 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Goal Already Completed';

  @override
  String get freezeTokenGoalCompleteMessage => 'Your daily goal is already complete! Freeze tokens can only be used when you haven\'t met your goal yet.';

  @override
  String get freezeTokenUseTitle => 'Use Freeze Token';

  @override
  String get freezeTokenUseMessage => 'Freeze tokens protect your streak when you miss a day. Using a freeze will count as completing your daily goal.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'You have $count token(s). Use one now?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ Freeze token used! Goal marked as complete.';

  @override
  String get trendsErrorLoading => 'Error loading data';

  @override
  String get trendsPoints => 'Points';

  @override
  String get trendsStreak => 'Streak';

  @override
  String get trendsSessions => 'Sessions';

  @override
  String get trendsTopActivity => 'Top Activity';

  @override
  String get sectionToday => 'Today';

  @override
  String get sectionSessions => 'Sessions';

  @override
  String get sectionInsights => 'Insights';

  @override
  String get onboardingGoalAdviceGettingStarted => 'Perfect start! 🌟 Small steps lead to big wins. You\'ve got this!';

  @override
  String get onboardingGoalAdviceBuildingHabit => 'Excellent choice! 🎯 This sweet spot builds lasting habits!';

  @override
  String get onboardingGoalAdviceRegularPractice => 'Ambitious! 💪 You\'re ready to level up your focus game!';

  @override
  String get onboardingGoalAdviceDeepWork => 'Wow! 🏆 Deep work mode activated! Remember to take breaks!';

  @override
  String get onboardingDuration10to15 => '10-15 minutes';

  @override
  String get onboardingDuration20to30 => '20-30 minutes';

  @override
  String get onboardingDuration40to60 => '40-60 minutes';

  @override
  String get onboardingDuration60plus => '60+ minutes';

  @override
  String get activityStudy => 'Study';

  @override
  String get activityReading => 'Reading';

  @override
  String get activityMeditation => 'Meditation';

  @override
  String get activityOther => 'Other';

  @override
  String get onboardingTip1Description => 'Begin with 5-10 minute sessions. Consistency beats perfection!';

  @override
  String get onboardingTip2Description => 'Tap Focus Mode for immersive, distraction-free experience.';

  @override
  String get onboardingTip3Description => 'Use your monthly token on busy days to protect your streak.';

  @override
  String get onboardingTip4Description => 'Aim for 70% quiet time - perfect silence not required!';

  @override
  String get onboardingLaunchTitle => 'You\'re Ready to Launch! 🚀';

  @override
  String get onboardingLaunchDescription => 'Let\'s start your first session and build amazing habits!';

  @override
  String get insightsBestTimeByActivity => 'Best Time by Activity';

  @override
  String get insightHighSuccessRateTitle => 'High Success Rate';

  @override
  String get insightEnvironmentStabilityTitle => 'Environment Stability';

  @override
  String get insightLowNoiseSuccessTitle => 'Low Noise Success';

  @override
  String get insightConsistentPracticeTitle => 'Consistent Practice';

  @override
  String get insightStreakProtectionTitle => 'Streak Protection Available';

  @override
  String get insightRoomTooNoisyTitle => 'Room Too Noisy';

  @override
  String get insightIrregularScheduleTitle => 'Irregular Schedule';

  @override
  String get insightLowAmbientScoreTitle => 'Low Ambient Score';

  @override
  String get insightNoRecentSessionsTitle => 'No Recent Sessions';

  @override
  String get insightHighSuccessRateDesc => 'You are maintaining strong silent sessions.';

  @override
  String get insightEnvironmentStabilityDesc => 'Ambient noise is within a moderate, manageable range.';

  @override
  String get insightLowNoiseSuccessDesc => 'Your environment is exceptionally quiet during sessions.';

  @override
  String get insightConsistentPracticeDesc => 'You\'re building a reliable daily practice habit.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'You have $count freeze token(s) to protect your streak.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Try finding a quieter space or adjusting your threshold.';

  @override
  String get insightIrregularScheduleDesc => 'More consistent session times may improve your streak.';

  @override
  String get insightLowAmbientScoreDesc => 'Recent sessions had lower quiet time. Try a quieter environment.';

  @override
  String get insightNoRecentSessionsDesc => 'Start a session today to build your focus habit!';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return 'Great job! $minutes focus minutes in your session! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return 'Good effort! $minutes minutes completed.';
  }

  @override
  String get sessionCompleteFailed => 'Session ended. Try again when ready.';

  @override
  String get notificationSessionStarted => 'Session started - stay focused!';

  @override
  String get notificationSessionPaused => 'Session paused';

  @override
  String get notificationSessionResumed => 'Session resumed';
}
