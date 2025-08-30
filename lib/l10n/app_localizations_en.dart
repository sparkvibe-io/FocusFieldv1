// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Preparing focus engine…';

  @override
  String get paywallTitle => 'Train Deeper Focus with Premium';

  @override
  String get featureExtendSessions => 'Extend focus sessions from 5 min to 120 min';

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
  String get microphonePermissionMessage => 'Silence Score needs microphone access to measure ambient noise levels. No audio is stored.';

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
  String get faqHowWorksQ => 'How does SilenceScore work?';

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
}
