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
  String get microphonePermissionMessage => 'Focus Field needs microphone access to measure ambient noise levels. No audio is stored.';

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
  String get faq => 'FAQ';

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
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get faqHowWorksQ => 'How does Focus Field work?';

  @override
  String get faqHowWorksA => 'It measures ambient noise – time below threshold earns points.';

  @override
  String get faqAudioRecordedQ => 'Is audio recorded?';

  @override
  String get faqAudioRecordedA => 'No. Only decibel levels are sampled; audio is never stored.';

  @override
  String get faqAdjustSensitivityQ => 'Adjust sensitivity?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Use Settings > Basic > Decibel Threshold ($min–$max dB) and calibrate first.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Premium features?';

  @override
  String get faqPremiumFeaturesA => 'Extended sessions (up to 120m), advanced analytics, export, themes.';

  @override
  String get faqNotificationsQ => 'Notifications?';

  @override
  String get faqNotificationsA => 'Smart reminders learn habits and celebrate milestones.';

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
  String get dailySilenceReminderTitle => 'Daily Silence Reminder';

  @override
  String get weeklyProgressReportTitle => 'Weekly Progress Report 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Achievement Unlocked! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session Complete! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session Ended';

  @override
  String get reminderStartJourney => '🧘‍♂️ Start your silence journey today! Find your inner peace.';

  @override
  String get reminderRestart => '🌱 Ready to restart your silence practice? Every moment is a new beginning.';

  @override
  String get reminderDayTwo => '⭐ Day 2 of your silence streak! Consistency builds tranquility.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak-day streak! You\'re building a powerful habit.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Amazing $streak-day streak! Your dedication is inspiring.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Incredible $streak-day streak! You\'re a silence master!';
  }

  @override
  String get achievementFirstSession => '🎉 First session completed! Welcome to your silence journey!';

  @override
  String get achievementWeekStreak => '🌟 7-day streak achieved! Consistency is your superpower!';

  @override
  String get achievementMonthStreak => '🏆 30-day streak unlocked! You\'re unstoppable!';

  @override
  String get achievementPerfectSession => '✨ Perfect silence session! Not a sound disturbed your peace.';

  @override
  String get achievementLongSession => '⏰ Extended session master! Your focus grows stronger.';

  @override
  String get achievementGeneric => '🎊 Achievement unlocked! Keep up the great work!';

  @override
  String get weeklyProgressNone => '💭 This week could use some silence. Ready for a peaceful session?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count sessions this week. Every practice deepens your calm.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count sessions this week! You\'re finding your rhythm.';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 Perfect week with $count sessions! Your dedication shines.';
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
}
