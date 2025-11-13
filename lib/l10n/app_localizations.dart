import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Field'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing focus engine…'**
  String get splashLoading;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Train Deeper Focus with Premium'**
  String get paywallTitle;

  /// No description provided for @featureExtendSessions.
  ///
  /// In en, this message translates to:
  /// **'Extend focus sessions from 30 min to 120 min'**
  String get featureExtendSessions;

  /// No description provided for @featureHistory.
  ///
  /// In en, this message translates to:
  /// **'Access 90 days of past sessions'**
  String get featureHistory;

  /// No description provided for @featureMetrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock performance metrics and trend charts'**
  String get featureMetrics;

  /// No description provided for @featureExport.
  ///
  /// In en, this message translates to:
  /// **'Download your session data (CSV / PDF)'**
  String get featureExport;

  /// No description provided for @featureThemes.
  ///
  /// In en, this message translates to:
  /// **'Use the full custom theme pack'**
  String get featureThemes;

  /// No description provided for @featureThreshold.
  ///
  /// In en, this message translates to:
  /// **'Fine-tune threshold with ambient baseline'**
  String get featureThreshold;

  /// No description provided for @featureSupport.
  ///
  /// In en, this message translates to:
  /// **'Faster help and early feature access'**
  String get featureSupport;

  /// No description provided for @subscribeCta.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get subscribeCta;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsOfService;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageSubscription;

  /// No description provided for @legalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Auto-renewing subscription. Cancel anytime in store settings.'**
  String get legalDisclaimer;

  /// Shown in a notification when a user hits a silence milestone (pluralized).
  ///
  /// In en, this message translates to:
  /// **'Great job! {minutes, plural, one {# minute of peaceful silence achieved! ✨} other {# minutes of peaceful silence achieved! ✨}}'**
  String minutesOfSilenceCongrats(int minutes);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @stopSession.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopSession;

  /// No description provided for @pauseSession.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseSession;

  /// No description provided for @resumeSession.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeSession;

  /// No description provided for @sessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get sessionSaved;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @permissionMicrophoneDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get permissionMicrophoneDenied;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @listeningStatus.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listeningStatus;

  /// No description provided for @successPointMessage.
  ///
  /// In en, this message translates to:
  /// **'Silence achieved! +1 point'**
  String get successPointMessage;

  /// No description provided for @tooNoisyMessage.
  ///
  /// In en, this message translates to:
  /// **'Too noisy! Try again'**
  String get tooNoisyMessage;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Press Start to begin your silence journey!'**
  String get welcomeMessage;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// No description provided for @resetDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all your progress?'**
  String get resetDataConfirmation;

  /// No description provided for @resetDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data reset successfully'**
  String get resetDataSuccess;

  /// No description provided for @decibelThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Decibel Threshold'**
  String get decibelThresholdLabel;

  /// No description provided for @decibelThresholdHint.
  ///
  /// In en, this message translates to:
  /// **'Set the maximum allowed noise level (dB)'**
  String get decibelThresholdHint;

  /// No description provided for @microphonePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone Permission'**
  String get microphonePermissionTitle;

  /// No description provided for @microphonePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Focus Field measures ambient sound levels to help you maintain quiet environments.\n\nThe app needs microphone access to detect silence, but does not record any audio.'**
  String get microphonePermissionMessage;

  /// No description provided for @permissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required to measure silence. Please enable it in settings.'**
  String get permissionDeniedMessage;

  /// No description provided for @noiseMeterError.
  ///
  /// In en, this message translates to:
  /// **'Unable to access microphone'**
  String get noiseMeterError;

  /// No description provided for @premiumFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeaturesTitle;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock extended sessions, advanced analytics, and data export'**
  String get premiumDescription;

  /// No description provided for @premiumRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature requires Premium subscription'**
  String get premiumRequiredMessage;

  /// No description provided for @subscriptionSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Successfully subscribed! Enjoy your premium features'**
  String get subscriptionSuccessMessage;

  /// No description provided for @subscriptionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to process subscription. Please try again'**
  String get subscriptionErrorMessage;

  /// No description provided for @restoreSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully'**
  String get restoreSuccessMessage;

  /// No description provided for @restoreErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore'**
  String get restoreErrorMessage;

  /// No description provided for @yearlyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyPlanTitle;

  /// No description provided for @monthlyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPlanTitle;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'SAVE {percent}%'**
  String savePercent(String percent);

  /// No description provided for @billedAnnually.
  ///
  /// In en, this message translates to:
  /// **'Billed at {price}/yr.'**
  String billedAnnually(String price);

  /// No description provided for @billedMonthly.
  ///
  /// In en, this message translates to:
  /// **'Billed at {price}/mo.'**
  String billedMonthly(String price);

  /// No description provided for @mockSubscriptionsBanner.
  ///
  /// In en, this message translates to:
  /// **'Mock Subscriptions Enabled'**
  String get mockSubscriptionsBanner;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Measure Silence, Build Focus'**
  String get splashTagline;

  /// No description provided for @appIconSemantic.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get appIconSemantic;

  /// No description provided for @tabBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get tabBasic;

  /// No description provided for @tabAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get tabAdvanced;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get tabAbout;

  /// No description provided for @resetAllSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset All Settings'**
  String get resetAllSettings;

  /// No description provided for @resetAllSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will reset all settings and data. Cannot be undone.'**
  String get resetAllSettingsDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @allSettingsReset.
  ///
  /// In en, this message translates to:
  /// **'All settings and data have been reset'**
  String get allSettingsReset;

  /// No description provided for @decibelThresholdMaxNoise.
  ///
  /// In en, this message translates to:
  /// **'Decibel Threshold (max noise level)'**
  String get decibelThresholdMaxNoise;

  /// No description provided for @highThresholdWarningText.
  ///
  /// In en, this message translates to:
  /// **'High threshold may ignore meaningful noise events.'**
  String get highThresholdWarningText;

  /// No description provided for @decibelThresholdTooltip.
  ///
  /// In en, this message translates to:
  /// **'Typical quiet spaces: 30–40 dB. Calibrate; raise only if normal hum counts as noise.'**
  String get decibelThresholdTooltip;

  /// No description provided for @sessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Session Duration'**
  String get sessionDuration;

  /// No description provided for @upgradeForMinutes.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for {minutes}m'**
  String upgradeForMinutes(int minutes);

  /// No description provided for @freeUpToMinutes.
  ///
  /// In en, this message translates to:
  /// **'Free: up to {minutes} min'**
  String freeUpToMinutes(int minutes);

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/day'**
  String get perDay;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'/week'**
  String get perWeek;

  /// No description provided for @percentPerWeek.
  ///
  /// In en, this message translates to:
  /// **'%/week'**
  String get percentPerWeek;

  /// No description provided for @noiseCalibration.
  ///
  /// In en, this message translates to:
  /// **'Noise Calibration'**
  String get noiseCalibration;

  /// No description provided for @calibrateBaseline.
  ///
  /// In en, this message translates to:
  /// **'Calibrate baseline'**
  String get calibrateBaseline;

  /// No description provided for @unlockAdvancedCalibration.
  ///
  /// In en, this message translates to:
  /// **'Unlock advanced noise calibration'**
  String get unlockAdvancedCalibration;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get sessionHistory;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @remindersCelebrations.
  ///
  /// In en, this message translates to:
  /// **'Reminders & celebrations'**
  String get remindersCelebrations;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @accessibilityFeatures.
  ///
  /// In en, this message translates to:
  /// **'Accessibility features'**
  String get accessibilityFeatures;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @bundleId.
  ///
  /// In en, this message translates to:
  /// **'Bundle ID'**
  String get bundleId;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings: {error}'**
  String errorLoadingSettings(String error);

  /// No description provided for @exportNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available to export'**
  String get exportNoData;

  /// No description provided for @chooseExportFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose export format for your {sessions} sessions:'**
  String chooseExportFormat(int sessions);

  /// No description provided for @csvSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'CSV Spreadsheet'**
  String get csvSpreadsheet;

  /// No description provided for @rawDataForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Raw data for analysis'**
  String get rawDataForAnalysis;

  /// No description provided for @pdfReport.
  ///
  /// In en, this message translates to:
  /// **'PDF Report'**
  String get pdfReport;

  /// No description provided for @formattedReportWithCharts.
  ///
  /// In en, this message translates to:
  /// **'Formatted report with charts'**
  String get formattedReportWithCharts;

  /// No description provided for @generatingExport.
  ///
  /// In en, this message translates to:
  /// **'Generating {format} export...'**
  String generatingExport(String format);

  /// No description provided for @exportCompleted.
  ///
  /// In en, this message translates to:
  /// **'{format} export completed!'**
  String exportCompleted(String format);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @responseTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Response Time: {time}'**
  String responseTimeLabel(String time);

  /// No description provided for @docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docs;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @emailOpenDescription.
  ///
  /// In en, this message translates to:
  /// **'Opens your email app with system information pre-filled'**
  String get emailOpenDescription;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @briefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description'**
  String get briefDescription;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @issueDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Provide details about your issue...'**
  String get issueDescriptionHint;

  /// No description provided for @openingEmail.
  ///
  /// In en, this message translates to:
  /// **'Opening Email...'**
  String get openingEmail;

  /// No description provided for @openEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get openEmailApp;

  /// No description provided for @fillSubjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Please fill subject and description'**
  String get fillSubjectDescription;

  /// No description provided for @emailOpened.
  ///
  /// In en, this message translates to:
  /// **'Email app opened. Send when ready.'**
  String get emailOpened;

  /// No description provided for @noEmailAppFound.
  ///
  /// In en, this message translates to:
  /// **'No email app found. Contact:'**
  String get noEmailAppFound;

  /// No description provided for @standardSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject: [STANDARD] {subject}'**
  String standardSubject(String subject);

  /// No description provided for @issueLine.
  ///
  /// In en, this message translates to:
  /// **'Issue: {issue}'**
  String issueLine(String issue);

  /// No description provided for @failedOpenFaq.
  ///
  /// In en, this message translates to:
  /// **'Failed to open FAQ: {error}'**
  String failedOpenFaq(String error);

  /// No description provided for @failedOpenDocs.
  ///
  /// In en, this message translates to:
  /// **'Failed to open documentation: {error}'**
  String failedOpenDocs(String error);

  /// No description provided for @accessibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get accessibilitySettings;

  /// No description provided for @vibrationFeedback.
  ///
  /// In en, this message translates to:
  /// **'Vibration Feedback'**
  String get vibrationFeedback;

  /// No description provided for @vibrateOnSessionEvents.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on session events'**
  String get vibrateOnSessionEvents;

  /// No description provided for @voiceAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Voice Announcements'**
  String get voiceAnnouncements;

  /// No description provided for @announceSessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Announce session progress'**
  String get announceSessionProgress;

  /// No description provided for @highContrastMode.
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrastMode;

  /// No description provided for @improveVisualAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Improve visual accessibility'**
  String get improveVisualAccessibility;

  /// No description provided for @largeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text'**
  String get largeText;

  /// No description provided for @increaseTextSize.
  ///
  /// In en, this message translates to:
  /// **'Increase text size'**
  String get increaseTextSize;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @accessibilitySettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Accessibility settings saved'**
  String get accessibilitySettingsSaved;

  /// No description provided for @noiseFloorCalibration.
  ///
  /// In en, this message translates to:
  /// **'Noise Floor Calibration'**
  String get noiseFloorCalibration;

  /// No description provided for @measuringAmbientNoise.
  ///
  /// In en, this message translates to:
  /// **'Measuring ambient noise (≈5s)...'**
  String get measuringAmbientNoise;

  /// No description provided for @couldNotReadMic.
  ///
  /// In en, this message translates to:
  /// **'Could not read microphone'**
  String get couldNotReadMic;

  /// No description provided for @calibrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Calibration failed'**
  String get calibrationFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @previousThreshold.
  ///
  /// In en, this message translates to:
  /// **'Previous: {value} dB'**
  String previousThreshold(double value);

  /// No description provided for @newThreshold.
  ///
  /// In en, this message translates to:
  /// **'New threshold: {value} dB'**
  String newThreshold(double value);

  /// No description provided for @noSignificantChange.
  ///
  /// In en, this message translates to:
  /// **'No significant change detected.'**
  String get noSignificantChange;

  /// No description provided for @highAmbientDetected.
  ///
  /// In en, this message translates to:
  /// **'High ambient environment detected. Consider a quieter space for more sensitivity.'**
  String get highAmbientDetected;

  /// No description provided for @adjustAnytimeSettings.
  ///
  /// In en, this message translates to:
  /// **'You can adjust this anytime in Settings.'**
  String get adjustAnytimeSettings;

  /// No description provided for @toggleThemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleThemeTooltip;

  /// No description provided for @audioChartRecovering.
  ///
  /// In en, this message translates to:
  /// **'Audio chart recovering...'**
  String get audioChartRecovering;

  /// No description provided for @themeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme: {themeName}'**
  String themeChanged(String themeName);

  /// No description provided for @privacyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy coming soon.'**
  String get privacyComingSoon;

  /// No description provided for @ratingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Rating feature coming soon!'**
  String get ratingFeatureComingSoon;

  /// No description provided for @startSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSessionButton;

  /// No description provided for @stopSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopSessionButton;

  /// No description provided for @statusListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get statusListening;

  /// No description provided for @statusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Silence achieved! +1 point'**
  String get statusSuccess;

  /// No description provided for @statusFailure.
  ///
  /// In en, this message translates to:
  /// **'Too noisy! Try again'**
  String get statusFailure;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @upgradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Required'**
  String get upgradeRequired;

  /// No description provided for @exportCsvSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'CSV Spreadsheet'**
  String get exportCsvSpreadsheet;

  /// No description provided for @exportPdfReport.
  ///
  /// In en, this message translates to:
  /// **'PDF Report'**
  String get exportPdfReport;

  /// No description provided for @formattedReportCharts.
  ///
  /// In en, this message translates to:
  /// **'Formatted report with charts'**
  String get formattedReportCharts;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @microphone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get microphone;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessions;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'format'**
  String get format;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @avgSession.
  ///
  /// In en, this message translates to:
  /// **'Avg Session'**
  String get avgSession;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @bestTime.
  ///
  /// In en, this message translates to:
  /// **'Best Time'**
  String get bestTime;

  /// No description provided for @weeklyTrends.
  ///
  /// In en, this message translates to:
  /// **'Weekly Trends'**
  String get weeklyTrends;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analytics'**
  String get advancedAnalytics;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premiumBadge;

  /// No description provided for @bucket1to2.
  ///
  /// In en, this message translates to:
  /// **'1-2 min'**
  String get bucket1to2;

  /// No description provided for @bucket3to5.
  ///
  /// In en, this message translates to:
  /// **'3-5 min'**
  String get bucket3to5;

  /// No description provided for @bucket6to10.
  ///
  /// In en, this message translates to:
  /// **'6-10 min'**
  String get bucket6to10;

  /// No description provided for @bucket11to20.
  ///
  /// In en, this message translates to:
  /// **'11-20 min'**
  String get bucket11to20;

  /// No description provided for @bucket21to30.
  ///
  /// In en, this message translates to:
  /// **'21-30 min'**
  String get bucket21to30;

  /// No description provided for @bucket30plus.
  ///
  /// In en, this message translates to:
  /// **'30+ min'**
  String get bucket30plus;

  /// No description provided for @sessionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistoryTitle;

  /// No description provided for @recentSessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent Session History'**
  String get recentSessionHistory;

  /// Achievement title for completing the very first session
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get achievementFirstStepTitle;

  /// Achievement description: user completed their first session
  ///
  /// In en, this message translates to:
  /// **'Completed your first session'**
  String get achievementFirstStepDesc;

  /// Achievement title for achieving a 3 day streak
  ///
  /// In en, this message translates to:
  /// **'On Fire'**
  String get achievementOnFireTitle;

  /// Achievement description: user achieved a 3 day streak
  ///
  /// In en, this message translates to:
  /// **'3-day streak achieved'**
  String get achievementOnFireDesc;

  /// Achievement title for achieving a 7 day streak
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get achievementWeekWarriorTitle;

  /// Achievement description: user achieved a 7 day streak
  ///
  /// In en, this message translates to:
  /// **'7-day streak achieved'**
  String get achievementWeekWarriorDesc;

  /// Achievement title for reaching 10 total points
  ///
  /// In en, this message translates to:
  /// **'Decade'**
  String get achievementDecadeTitle;

  /// Achievement description: user reached 10 points milestone
  ///
  /// In en, this message translates to:
  /// **'10 points milestone'**
  String get achievementDecadeDesc;

  /// Achievement title for reaching 50 total points
  ///
  /// In en, this message translates to:
  /// **'Half Century'**
  String get achievementHalfCenturyTitle;

  /// Achievement description: user reached 50 points milestone
  ///
  /// In en, this message translates to:
  /// **'50 points milestone'**
  String get achievementHalfCenturyDesc;

  /// Prompt shown when achievements are locked and user has no progress
  ///
  /// In en, this message translates to:
  /// **'Complete sessions to unlock achievements'**
  String get achievementLockedPrompt;

  /// No description provided for @ratingPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Focus Field?'**
  String get ratingPromptTitle;

  /// No description provided for @ratingPromptBody.
  ///
  /// In en, this message translates to:
  /// **'A quick 5-star rating helps others discover calmer focus time.'**
  String get ratingPromptBody;

  /// No description provided for @ratingPromptRateNow.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get ratingPromptRateNow;

  /// No description provided for @ratingPromptLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get ratingPromptLater;

  /// No description provided for @ratingPromptNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks'**
  String get ratingPromptNoThanks;

  /// No description provided for @ratingThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your support!'**
  String get ratingThankYou;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Required'**
  String get notificationPermissionRequired;

  /// No description provided for @notificationPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive gentle reminders and celebrate achievements.'**
  String get notificationPermissionRationale;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get requesting;

  /// No description provided for @enableNotificationsCta.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotificationsCta;

  /// No description provided for @enableNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotificationsTitle;

  /// No description provided for @enableNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Focus Field to send notifications'**
  String get enableNotificationsSubtitle;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Daily Reminders'**
  String get dailyReminderTitle;

  /// No description provided for @dailyReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart or chosen time'**
  String get dailyReminderSubtitle;

  /// No description provided for @dailyTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Time'**
  String get dailyTimeLabel;

  /// No description provided for @dailyTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a fixed time or let Focus Field learn your pattern.'**
  String get dailyTimeHint;

  /// No description provided for @useSmartCta.
  ///
  /// In en, this message translates to:
  /// **'Use Smart'**
  String get useSmartCta;

  /// No description provided for @sessionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Completed'**
  String get sessionCompletedTitle;

  /// No description provided for @sessionCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Celebrate completed sessions'**
  String get sessionCompletedSubtitle;

  /// No description provided for @achievementUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked'**
  String get achievementUnlockedTitle;

  /// No description provided for @achievementUnlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone notifications'**
  String get achievementUnlockedSubtitle;

  /// No description provided for @weeklySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Summary'**
  String get weeklySummaryTitle;

  /// No description provided for @weeklySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly insights (weekday & time)'**
  String get weeklySummarySubtitle;

  /// No description provided for @weeklyTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Time'**
  String get weeklyTimeLabel;

  /// No description provided for @notificationPreview.
  ///
  /// In en, this message translates to:
  /// **'Notification Preview'**
  String get notificationPreview;

  /// No description provided for @dailySilenceReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Focus Reminder'**
  String get dailySilenceReminderTitle;

  /// No description provided for @weeklyProgressReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Report 📊'**
  String get weeklyProgressReportTitle;

  /// No description provided for @achievementUnlockedGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked! 🏆'**
  String get achievementUnlockedGenericTitle;

  /// No description provided for @sessionCompleteSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Complete! 🎉'**
  String get sessionCompleteSuccessTitle;

  /// No description provided for @sessionCompleteEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Ended'**
  String get sessionCompleteEndedTitle;

  /// No description provided for @reminderStartJourney.
  ///
  /// In en, this message translates to:
  /// **'🎯 Start your focus journey today! Build your deep work habit.'**
  String get reminderStartJourney;

  /// No description provided for @reminderRestart.
  ///
  /// In en, this message translates to:
  /// **'🌱 Ready to restart your focus practice? Every moment is a new beginning.'**
  String get reminderRestart;

  /// No description provided for @reminderDayTwo.
  ///
  /// In en, this message translates to:
  /// **'⭐ Day 2 of your focus streak! Consistency builds concentration.'**
  String get reminderDayTwo;

  /// No description provided for @reminderStreakShort.
  ///
  /// In en, this message translates to:
  /// **'🔥 {streak}-day streak! You\'re building a powerful focus habit.'**
  String reminderStreakShort(int streak);

  /// No description provided for @reminderStreakMedium.
  ///
  /// In en, this message translates to:
  /// **'🏆 Amazing {streak}-day streak! Your dedication is inspiring.'**
  String reminderStreakMedium(int streak);

  /// No description provided for @reminderStreakLong.
  ///
  /// In en, this message translates to:
  /// **'👑 Incredible {streak}-day streak! You\'re a focus champion!'**
  String reminderStreakLong(int streak);

  /// No description provided for @achievementFirstSession.
  ///
  /// In en, this message translates to:
  /// **'🎉 First session complete! Welcome to Focus Field!'**
  String get achievementFirstSession;

  /// No description provided for @achievementWeekStreak.
  ///
  /// In en, this message translates to:
  /// **'🌟 7-day streak achieved! Consistency is your superpower!'**
  String get achievementWeekStreak;

  /// No description provided for @achievementMonthStreak.
  ///
  /// In en, this message translates to:
  /// **'🏆 30-day streak unlocked! You\'re unstoppable!'**
  String get achievementMonthStreak;

  /// No description provided for @achievementPerfectSession.
  ///
  /// In en, this message translates to:
  /// **'✨ Perfect session! 100% calm environment maintained!'**
  String get achievementPerfectSession;

  /// No description provided for @achievementLongSession.
  ///
  /// In en, this message translates to:
  /// **'⏰ Extended session master! Your focus grows stronger.'**
  String get achievementLongSession;

  /// No description provided for @achievementGeneric.
  ///
  /// In en, this message translates to:
  /// **'🎊 Achievement unlocked! Keep up the great work!'**
  String get achievementGeneric;

  /// No description provided for @weeklyProgressNone.
  ///
  /// In en, this message translates to:
  /// **'💭 Start your weekly goal! Ready for a focused session?'**
  String get weeklyProgressNone;

  /// No description provided for @weeklyProgressFew.
  ///
  /// In en, this message translates to:
  /// **'🌿 {count} focus minutes this week! Every session counts.'**
  String weeklyProgressFew(int count);

  /// No description provided for @weeklyProgressSome.
  ///
  /// In en, this message translates to:
  /// **'🌊 {count} focus minutes earned! You\'re on track!'**
  String weeklyProgressSome(int count);

  /// No description provided for @weeklyProgressPerfect.
  ///
  /// In en, this message translates to:
  /// **'🎯 {count} focus minutes achieved! Perfect week!'**
  String weeklyProgressPerfect(int count);

  /// No description provided for @tipsHidden.
  ///
  /// In en, this message translates to:
  /// **'Tips hidden - You won\'t see automatic tips anymore. Tap the lightbulb icon anytime to view tips.'**
  String get tipsHidden;

  /// No description provided for @tipsShown.
  ///
  /// In en, this message translates to:
  /// **'Tips enabled - You\'ll see helpful tips as you use the app.'**
  String get tipsShown;

  /// No description provided for @showTips.
  ///
  /// In en, this message translates to:
  /// **'Show Tips'**
  String get showTips;

  /// No description provided for @hideTips.
  ///
  /// In en, this message translates to:
  /// **'Hide Tips'**
  String get hideTips;

  /// No description provided for @tip01.
  ///
  /// In en, this message translates to:
  /// **'Start small—even 2 minutes builds your focus habit.'**
  String get tip01;

  /// No description provided for @tip02.
  ///
  /// In en, this message translates to:
  /// **'Your streak has grace—one miss won\'t break it with the 2-Day Rule.'**
  String get tip02;

  /// No description provided for @tip03.
  ///
  /// In en, this message translates to:
  /// **'Try Study, Reading, or Meditation activities to match your focus style.'**
  String get tip03;

  /// No description provided for @tip04.
  ///
  /// In en, this message translates to:
  /// **'Check your 12-week Heatmap to see how small wins compound over time.'**
  String get tip04;

  /// No description provided for @tip05.
  ///
  /// In en, this message translates to:
  /// **'Watch your live Calm % during sessions—higher scores mean better focus!'**
  String get tip05;

  /// No description provided for @tip06.
  ///
  /// In en, this message translates to:
  /// **'Customize your daily goal (10-60 min) to match your rhythm.'**
  String get tip06;

  /// No description provided for @tip07.
  ///
  /// In en, this message translates to:
  /// **'Use your monthly Freeze Token to protect your streak on tough days.'**
  String get tip07;

  /// No description provided for @tip08.
  ///
  /// In en, this message translates to:
  /// **'After 3 wins, Focus Field suggests a stricter threshold—ready to level up?'**
  String get tip08;

  /// No description provided for @tip09.
  ///
  /// In en, this message translates to:
  /// **'High ambient noise? Raise your threshold to stay in the zone.'**
  String get tip09;

  /// No description provided for @tip10.
  ///
  /// In en, this message translates to:
  /// **'Smart Daily Reminders learn your best time—let them guide you.'**
  String get tip10;

  /// No description provided for @tip11.
  ///
  /// In en, this message translates to:
  /// **'The progress ring is tappable—one tap starts your focus session.'**
  String get tip11;

  /// No description provided for @tip12.
  ///
  /// In en, this message translates to:
  /// **'Enable Keep Screen On to prevent screen lock during focus sessions.'**
  String get tip12;

  /// No description provided for @tip13.
  ///
  /// In en, this message translates to:
  /// **'Session notifications celebrate your wins—enable them for motivation!'**
  String get tip13;

  /// No description provided for @tip14.
  ///
  /// In en, this message translates to:
  /// **'Consistency beats perfection—show up, even on busy days.'**
  String get tip14;

  /// No description provided for @tip15.
  ///
  /// In en, this message translates to:
  /// **'Try different times of day to discover your quiet sweet spot.'**
  String get tip15;

  /// No description provided for @tip16.
  ///
  /// In en, this message translates to:
  /// **'Your daily progress is always visible—tap Go to start anytime.'**
  String get tip16;

  /// No description provided for @tip17.
  ///
  /// In en, this message translates to:
  /// **'Each activity tracks separately toward your goal—variety keeps it fresh.'**
  String get tip17;

  /// No description provided for @tip18.
  ///
  /// In en, this message translates to:
  /// **'Export your data (Premium) to see your complete focus journey.'**
  String get tip18;

  /// No description provided for @tip19.
  ///
  /// In en, this message translates to:
  /// **'Confetti celebrates every completion—small wins deserve recognition!'**
  String get tip19;

  /// No description provided for @tip20.
  ///
  /// In en, this message translates to:
  /// **'Use Focus Mode for distraction-free sessions with hidden controls.'**
  String get tip20;

  /// No description provided for @tip21.
  ///
  /// In en, this message translates to:
  /// **'Your 7-Day Trends reveal patterns—check them weekly for insights.'**
  String get tip21;

  /// No description provided for @tip22.
  ///
  /// In en, this message translates to:
  /// **'Upgrade session duration (Premium) for longer deep focus blocks.'**
  String get tip22;

  /// No description provided for @tip23.
  ///
  /// In en, this message translates to:
  /// **'Focus is a practice—small sessions build the habit you want.'**
  String get tip23;

  /// No description provided for @tip24.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary shows your rhythm—tune it to your schedule.'**
  String get tip24;

  /// No description provided for @tip25.
  ///
  /// In en, this message translates to:
  /// **'Fine-tune your threshold for your space—every room is different.'**
  String get tip25;

  /// No description provided for @tip26.
  ///
  /// In en, this message translates to:
  /// **'Accessibility options help everyone focus—high contrast, large text, vibration.'**
  String get tip26;

  /// No description provided for @tip27.
  ///
  /// In en, this message translates to:
  /// **'Today Timeline shows when you focused—find your productive hours.'**
  String get tip27;

  /// No description provided for @tip28.
  ///
  /// In en, this message translates to:
  /// **'Finish what you start—shorter sessions mean more completions.'**
  String get tip28;

  /// No description provided for @tip29.
  ///
  /// In en, this message translates to:
  /// **'Quiet Minutes add up toward your goal—progress over perfection.'**
  String get tip29;

  /// No description provided for @tip30.
  ///
  /// In en, this message translates to:
  /// **'You\'re one tap away—start a tiny session right now.'**
  String get tip30;

  /// No description provided for @tipInstructionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Notifications to configure reminders and celebrations.'**
  String get tipInstructionNotifications;

  /// No description provided for @tipInstructionWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Notifications → Weekly Summary to pick weekday & time.'**
  String get tipInstructionWeeklySummary;

  /// No description provided for @tipInstructionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Settings → Basic → Decibel Threshold. Calibrate first, then fine‑tune.'**
  String get tipInstructionThreshold;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tipsTitle;

  /// No description provided for @tipInstructionSetTime.
  ///
  /// In en, this message translates to:
  /// **'Settings → Basic → Session duration'**
  String get tipInstructionSetTime;

  /// No description provided for @tipInstructionDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Notifications → Smart Daily Reminders.'**
  String get tipInstructionDailyReminders;

  /// No description provided for @tipInstructionKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Settings → Basic → Keep Screen On toggle.'**
  String get tipInstructionKeepScreenOn;

  /// No description provided for @tipInstructionFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Tap Focus Mode button during an active session.'**
  String get tipInstructionFocusMode;

  /// No description provided for @tipInstructionOpenAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Open Analytics to view trends and averages.'**
  String get tipInstructionOpenAnalytics;

  /// No description provided for @tipInstructionSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Notifications → Session Completed.'**
  String get tipInstructionSessionComplete;

  /// No description provided for @tipInstructionTapRing.
  ///
  /// In en, this message translates to:
  /// **'On Home, tap the progress ring to start/stop.'**
  String get tipInstructionTapRing;

  /// No description provided for @tipInstructionExport.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Export Data.'**
  String get tipInstructionExport;

  /// No description provided for @tipInstructionOpenNoiseChart.
  ///
  /// In en, this message translates to:
  /// **'Start a session to see the real‑time noise chart.'**
  String get tipInstructionOpenNoiseChart;

  /// No description provided for @tipInstructionUpgradeDuration.
  ///
  /// In en, this message translates to:
  /// **'Settings → Basic → Session duration. Upgrade for longer blocks.'**
  String get tipInstructionUpgradeDuration;

  /// No description provided for @tipInstructionAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Accessibility.'**
  String get tipInstructionAccessibility;

  /// No description provided for @tipInstructionStartNow.
  ///
  /// In en, this message translates to:
  /// **'Tap Start Session on the Home screen.'**
  String get tipInstructionStartNow;

  /// No description provided for @tipInstructionHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Summary tab → Show More → Heatmap'**
  String get tipInstructionHeatmap;

  /// No description provided for @tipInstructionTodayTimeline.
  ///
  /// In en, this message translates to:
  /// **'Summary tab → Show More → Today Timeline'**
  String get tipInstructionTodayTimeline;

  /// No description provided for @tipInstruction7DayTrends.
  ///
  /// In en, this message translates to:
  /// **'Summary tab → Show More → 7-Day Trends'**
  String get tipInstruction7DayTrends;

  /// No description provided for @tipInstructionEditActivities.
  ///
  /// In en, this message translates to:
  /// **'Activity tab → tap Edit to show/hide activities'**
  String get tipInstructionEditActivities;

  /// No description provided for @tipInstructionQuestGo.
  ///
  /// In en, this message translates to:
  /// **'Activity tab → Quest Capsule → tap Go'**
  String get tipInstructionQuestGo;

  /// No description provided for @tipInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show tip'**
  String get tipInfoTooltip;

  /// No description provided for @questCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Ambient Quest'**
  String get questCapsuleTitle;

  /// No description provided for @questCapsuleLoading.
  ///
  /// In en, this message translates to:
  /// **'Calm minutes loading…'**
  String get questCapsuleLoading;

  /// No description provided for @questCapsuleProgress.
  ///
  /// In en, this message translates to:
  /// **'Calm {progress}/{goal} min • Streak {streak}'**
  String questCapsuleProgress(int progress, int goal, int streak);

  /// No description provided for @questFreezeButton.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get questFreezeButton;

  /// No description provided for @questFrozenToday.
  ///
  /// In en, this message translates to:
  /// **'Today frozen — you\'re covered.'**
  String get questFrozenToday;

  /// No description provided for @questGoButton.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get questGoButton;

  /// No description provided for @calmPercent.
  ///
  /// In en, this message translates to:
  /// **'Calm {percent}%'**
  String calmPercent(int percent);

  /// No description provided for @calmLabel.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calmLabel;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @freeze.
  ///
  /// In en, this message translates to:
  /// **'freeze'**
  String get freeze;

  /// No description provided for @adaptiveThresholdSuggestion.
  ///
  /// In en, this message translates to:
  /// **'3 wins! Try {threshold} dB?'**
  String adaptiveThresholdSuggestion(int threshold);

  /// No description provided for @adaptiveThresholdNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get adaptiveThresholdNotNow;

  /// No description provided for @adaptiveThresholdTryIt.
  ///
  /// In en, this message translates to:
  /// **'Try It'**
  String get adaptiveThresholdTryIt;

  /// No description provided for @adaptiveThresholdConfirm.
  ///
  /// In en, this message translates to:
  /// **'Threshold set to {threshold} dB'**
  String adaptiveThresholdConfirm(int threshold);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @faqSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search FAQs...'**
  String get faqSearchHint;

  /// No description provided for @faqNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get faqNoResults;

  /// No description provided for @faqNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get faqNoResultsSubtitle;

  /// No description provided for @faqResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 result found} other {{count} results found}}'**
  String faqResultsCount(int count);

  /// No description provided for @faqQ01.
  ///
  /// In en, this message translates to:
  /// **'What is Focus Field and how does it help me focus?'**
  String get faqQ01;

  /// No description provided for @faqA01.
  ///
  /// In en, this message translates to:
  /// **'Focus Field helps you build better focus habits by monitoring ambient noise in your environment. When you start a session (Study, Reading, Meditation, or Other), the app measures how quiet your environment is. The quieter you keep it, the more \"focus minutes\" you earn. This encourages you to find and maintain distraction-free spaces for deep work.'**
  String get faqA01;

  /// No description provided for @faqQ02.
  ///
  /// In en, this message translates to:
  /// **'How does Focus Field measure my focus?'**
  String get faqQ02;

  /// No description provided for @faqA02.
  ///
  /// In en, this message translates to:
  /// **'Focus Field monitors the ambient noise level in your environment during your session. It calculates an \"Ambient Score\" by tracking how many seconds your environment stays below your chosen noise threshold. If your session has at least 70% quiet time (Ambient Score ≥70%), you earn full credit for those quiet minutes.'**
  String get faqA02;

  /// No description provided for @faqQ03.
  ///
  /// In en, this message translates to:
  /// **'Does Focus Field record my audio or conversations?'**
  String get faqQ03;

  /// No description provided for @faqA03.
  ///
  /// In en, this message translates to:
  /// **'No, absolutely not. Focus Field only measures decibel levels (loudness) - it never records, stores, or transmits any audio. Your privacy is completely protected. The app simply checks if your environment is above or below your chosen threshold.'**
  String get faqA03;

  /// No description provided for @faqQ04.
  ///
  /// In en, this message translates to:
  /// **'What activities can I track with Focus Field?'**
  String get faqQ04;

  /// No description provided for @faqA04.
  ///
  /// In en, this message translates to:
  /// **'Focus Field comes with four activity types: Study 📚 (for learning and research), Reading 📖 (for focused reading), Meditation 🧘 (for mindfulness practice), and Other ⭐ (for any focus-requiring activity). All activities use ambient noise monitoring to help you maintain a quiet, focused environment.'**
  String get faqA04;

  /// No description provided for @faqQ05.
  ///
  /// In en, this message translates to:
  /// **'Should I use Focus Field for all my activities?'**
  String get faqQ05;

  /// No description provided for @faqA05.
  ///
  /// In en, this message translates to:
  /// **'Focus Field works best for activities where ambient noise indicates your level of focus. Activities like Study, Reading, and Meditation benefit most from quiet environments. While you can track \"Other\" activities, we recommend using Focus Field primarily for noise-sensitive focus work.'**
  String get faqA05;

  /// No description provided for @faqQ06.
  ///
  /// In en, this message translates to:
  /// **'How do I start a focus session?'**
  String get faqQ06;

  /// No description provided for @faqA06.
  ///
  /// In en, this message translates to:
  /// **'Go to the Sessions tab, select your activity (Study, Reading, Meditation, or Other), choose your session duration (1, 5, 10, 15, 30 minutes, or premium options), tap the Start button on the progress ring, and keep your environment quiet!'**
  String get faqA06;

  /// No description provided for @faqQ07.
  ///
  /// In en, this message translates to:
  /// **'What session durations are available?'**
  String get faqQ07;

  /// No description provided for @faqA07.
  ///
  /// In en, this message translates to:
  /// **'Free users can choose: 1, 5, 10, 15, or 30-minute sessions. Premium users also get: 1 hour, 1.5 hours, and 2-hour extended sessions for longer deep work periods.'**
  String get faqA07;

  /// No description provided for @faqQ08.
  ///
  /// In en, this message translates to:
  /// **'Can I pause or stop a session early?'**
  String get faqQ08;

  /// No description provided for @faqA08.
  ///
  /// In en, this message translates to:
  /// **'Yes! During a session, you\'ll see Pause and Stop buttons above the progress ring. To prevent accidental taps, you need to long-press these buttons. If you stop early, you\'ll still earn points for the quiet minutes you accumulated.'**
  String get faqA08;

  /// No description provided for @faqQ09.
  ///
  /// In en, this message translates to:
  /// **'How do I earn points in Focus Field?'**
  String get faqQ09;

  /// No description provided for @faqA09.
  ///
  /// In en, this message translates to:
  /// **'You earn 1 point per quiet minute. During your session, Focus Field tracks how many seconds your environment stays below the noise threshold. At the end, those quiet seconds are converted to minutes. For example, if you complete a 10-minute session with 8 minutes of quiet time, you earn 8 points.'**
  String get faqA09;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'What is the 70% threshold and why does it matter?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'The 70% threshold determines if your session counts toward your daily goal. If your Ambient Score (quiet time ÷ total time) is at least 70%, your session qualifies for quest credit. Even if you\'re under 70%, you still earn points for every quiet minute!'**
  String get faqA10;

  /// No description provided for @faqQ11.
  ///
  /// In en, this message translates to:
  /// **'What\'s the difference between Ambient Score and points?'**
  String get faqQ11;

  /// No description provided for @faqA11.
  ///
  /// In en, this message translates to:
  /// **'Ambient Score is your session quality as a percentage (quiet seconds ÷ total seconds), determining if you hit the 70% threshold. Points are the actual quiet minutes earned (1 point = 1 minute). Ambient Score = quality, Points = achievement.'**
  String get faqA11;

  /// No description provided for @faqQ12.
  ///
  /// In en, this message translates to:
  /// **'How do streaks work in Focus Field?'**
  String get faqQ12;

  /// No description provided for @faqA12.
  ///
  /// In en, this message translates to:
  /// **'Streaks track consecutive days of meeting your daily goal. Focus Field uses a compassionate 2-Day Rule: Your streak only breaks if you miss two consecutive days. This means you can miss one day and your streak continues if you complete your goal the next day.'**
  String get faqA12;

  /// No description provided for @faqQ13.
  ///
  /// In en, this message translates to:
  /// **'What are freeze tokens and how do I use them?'**
  String get faqQ13;

  /// No description provided for @faqA13.
  ///
  /// In en, this message translates to:
  /// **'Freeze tokens protect your streak when you can\'t complete your goal. You get 1 free freeze token per month. When used, your overall progress shows 100% (goal protected), your streak is safe, and individual activity tracking continues normally. Use it wisely for busy days!'**
  String get faqA13;

  /// No description provided for @faqQ14.
  ///
  /// In en, this message translates to:
  /// **'Can I customize my daily focus goal?'**
  String get faqQ14;

  /// No description provided for @faqA14.
  ///
  /// In en, this message translates to:
  /// **'Yes! Tap Edit on the Sessions card in the Today tab. You can set your global daily goal (10-60 minutes for free, up to 1080 minutes for premium), enable per-activity goals for separate targets, and show/hide specific activities.'**
  String get faqA14;

  /// No description provided for @faqQ15.
  ///
  /// In en, this message translates to:
  /// **'What is the noise threshold and how do I adjust it?'**
  String get faqQ15;

  /// No description provided for @faqA15.
  ///
  /// In en, this message translates to:
  /// **'The threshold is the maximum noise level (in decibels) that counts as \"quiet.\" Default is 40 dB (library quiet). You can adjust it in the Sessions tab: 30 dB (very quiet), 40 dB (library quiet - recommended), 50 dB (moderate office), 60-80 dB (louder environments).'**
  String get faqA15;

  /// No description provided for @faqQ16.
  ///
  /// In en, this message translates to:
  /// **'What is Adaptive Threshold and should I use it?'**
  String get faqQ16;

  /// No description provided for @faqA16.
  ///
  /// In en, this message translates to:
  /// **'After 3 consecutive successful sessions at your current threshold, Focus Field suggests increasing it by 2 dB to challenge yourself. This helps you gradually improve. You can accept or dismiss the suggestion - it only appears once every 7 days.'**
  String get faqA16;

  /// No description provided for @faqQ17.
  ///
  /// In en, this message translates to:
  /// **'What is Focus Mode?'**
  String get faqQ17;

  /// No description provided for @faqA17.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode is a full-screen distraction-free overlay during your session. It shows your countdown timer, live calm percentage, and minimal controls (Pause/Stop via long-press). It removes all other UI elements so you can concentrate fully. Enable it in Settings > Basic > Focus Mode.'**
  String get faqA17;

  /// No description provided for @faqQ18.
  ///
  /// In en, this message translates to:
  /// **'Why does Focus Field need microphone permission?'**
  String get faqQ18;

  /// No description provided for @faqA18.
  ///
  /// In en, this message translates to:
  /// **'Focus Field uses your device\'s microphone to measure ambient noise levels (decibels) during sessions. This is essential to calculate your Ambient Score. Remember: no audio is ever recorded - only noise levels are measured in real-time.'**
  String get faqA18;

  /// No description provided for @faqQ19.
  ///
  /// In en, this message translates to:
  /// **'Can I see my focus patterns over time?'**
  String get faqQ19;

  /// No description provided for @faqA19.
  ///
  /// In en, this message translates to:
  /// **'Yes! The Today tab shows your daily progress, weekly trends, 12-week activity heatmap (like GitHub contributions), and session timeline. Premium users get advanced analytics with performance metrics, moving averages, and AI-powered insights.'**
  String get faqA19;

  /// No description provided for @faqQ20.
  ///
  /// In en, this message translates to:
  /// **'How do notifications work in Focus Field?'**
  String get faqQ20;

  /// No description provided for @faqA20.
  ///
  /// In en, this message translates to:
  /// **'Focus Field has smart reminders: Daily Reminders (learns your preferred focus time or use a fixed time), Session Completion notifications with results, Achievement notifications for milestones, and Weekly Summary (Premium). Enable/customize in Settings > Advanced > Notifications.'**
  String get faqA20;

  /// No description provided for @microphoneSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings Required'**
  String get microphoneSettingsTitle;

  /// No description provided for @microphoneSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'To enable silence detection, manually grant microphone permission:\n\n• iOS: Settings > Privacy & Security > Microphone > Focus Field\n• Android: Settings > Apps > Focus Field > Permissions > Microphone'**
  String get microphoneSettingsMessage;

  /// No description provided for @buttonGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get buttonGrantPermission;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get buttonOpenSettings;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingWelcomeSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Ready to start your first session? 🚀'**
  String get onboardingWelcomeSnackbar;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nFocus Field! 🎯'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey to better focus starts here!\nLet\'s build habits that stick 💪'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingFeatureTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Your Focus'**
  String get onboardingFeatureTrackTitle;

  /// No description provided for @onboardingFeatureTrackDesc.
  ///
  /// In en, this message translates to:
  /// **'See your progress in real-time as you build your focus superpower! 📊'**
  String get onboardingFeatureTrackDesc;

  /// No description provided for @onboardingFeatureRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards'**
  String get onboardingFeatureRewardsTitle;

  /// No description provided for @onboardingFeatureRewardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Every quiet minute counts! Collect points and celebrate your wins 🏆'**
  String get onboardingFeatureRewardsDesc;

  /// No description provided for @onboardingFeatureStreaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Streaks'**
  String get onboardingFeatureStreaksTitle;

  /// No description provided for @onboardingFeatureStreaksDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep the momentum going! Our compassionate system keeps you motivated 🔥'**
  String get onboardingFeatureStreaksDesc;

  /// No description provided for @onboardingEnvironmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Where\'s Your Focus Zone? 🎯'**
  String get onboardingEnvironmentTitle;

  /// No description provided for @onboardingEnvironmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your typical environment so we can optimize for your space!'**
  String get onboardingEnvironmentSubtitle;

  /// No description provided for @onboardingEnvQuietHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiet Home'**
  String get onboardingEnvQuietHomeTitle;

  /// No description provided for @onboardingEnvQuietHomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Bedroom, quiet home office'**
  String get onboardingEnvQuietHomeDesc;

  /// No description provided for @onboardingEnvQuietHomeDb.
  ///
  /// In en, this message translates to:
  /// **'30 dB - Very quiet'**
  String get onboardingEnvQuietHomeDb;

  /// No description provided for @onboardingEnvOfficeTitle.
  ///
  /// In en, this message translates to:
  /// **'Typical Office'**
  String get onboardingEnvOfficeTitle;

  /// No description provided for @onboardingEnvOfficeDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard office, library'**
  String get onboardingEnvOfficeDesc;

  /// No description provided for @onboardingEnvOfficeDb.
  ///
  /// In en, this message translates to:
  /// **'40 dB - Library quiet (Recommended)'**
  String get onboardingEnvOfficeDb;

  /// No description provided for @onboardingEnvBusyTitle.
  ///
  /// In en, this message translates to:
  /// **'Busy Space'**
  String get onboardingEnvBusyTitle;

  /// No description provided for @onboardingEnvBusyDesc.
  ///
  /// In en, this message translates to:
  /// **'Coffee shop, shared workspace'**
  String get onboardingEnvBusyDesc;

  /// No description provided for @onboardingEnvBusyDb.
  ///
  /// In en, this message translates to:
  /// **'50 dB - Moderate noise'**
  String get onboardingEnvBusyDb;

  /// No description provided for @onboardingEnvNoisyTitle.
  ///
  /// In en, this message translates to:
  /// **'Noisy Environment'**
  String get onboardingEnvNoisyTitle;

  /// No description provided for @onboardingEnvNoisyDesc.
  ///
  /// In en, this message translates to:
  /// **'Open office, public space'**
  String get onboardingEnvNoisyDesc;

  /// No description provided for @onboardingEnvNoisyDb.
  ///
  /// In en, this message translates to:
  /// **'60 dB - Higher noise'**
  String get onboardingEnvNoisyDb;

  /// No description provided for @onboardingEnvAdjustNote.
  ///
  /// In en, this message translates to:
  /// **'You can adjust this anytime in Settings'**
  String get onboardingEnvAdjustNote;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Your Daily Goal! 🎯'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How much focused time feels right for you?\n(You can adjust this anytime!)'**
  String get onboardingGoalSubtitle;

  /// No description provided for @onboardingGoalStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get onboardingGoalStartingTitle;

  /// No description provided for @onboardingGoalStartingDuration.
  ///
  /// In en, this message translates to:
  /// **'10-15 minutes'**
  String get onboardingGoalStartingDuration;

  /// No description provided for @onboardingGoalHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Building Habit'**
  String get onboardingGoalHabitTitle;

  /// No description provided for @onboardingGoalHabitDuration.
  ///
  /// In en, this message translates to:
  /// **'20-30 minutes'**
  String get onboardingGoalHabitDuration;

  /// No description provided for @onboardingGoalPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Regular Practice'**
  String get onboardingGoalPracticeTitle;

  /// No description provided for @onboardingGoalPracticeDuration.
  ///
  /// In en, this message translates to:
  /// **'40-60 minutes'**
  String get onboardingGoalPracticeDuration;

  /// No description provided for @onboardingGoalDeepWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get onboardingGoalDeepWorkTitle;

  /// No description provided for @onboardingGoalDeepWorkDuration.
  ///
  /// In en, this message translates to:
  /// **'60+ minutes'**
  String get onboardingGoalDeepWorkDuration;

  /// No description provided for @onboardingGoalAdvice1.
  ///
  /// In en, this message translates to:
  /// **'Perfect start! 🌟 Small steps lead to big wins. You\'ve got this!'**
  String get onboardingGoalAdvice1;

  /// No description provided for @onboardingGoalAdvice2.
  ///
  /// In en, this message translates to:
  /// **'Excellent choice! 🎯 This sweet spot builds lasting habits!'**
  String get onboardingGoalAdvice2;

  /// No description provided for @onboardingGoalAdvice3.
  ///
  /// In en, this message translates to:
  /// **'Ambitious! 💪 You\'re ready to level up your focus game!'**
  String get onboardingGoalAdvice3;

  /// No description provided for @onboardingGoalAdvice4.
  ///
  /// In en, this message translates to:
  /// **'Wow! 🏆 Deep work mode activated! Remember to take breaks!'**
  String get onboardingGoalAdvice4;

  /// No description provided for @onboardingActivitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Activities! ✨'**
  String get onboardingActivitiesTitle;

  /// No description provided for @onboardingActivitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick all that resonate with you!\n(You can always add more later)'**
  String get onboardingActivitiesSubtitle;

  /// No description provided for @onboardingActivityStudyTitle.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get onboardingActivityStudyTitle;

  /// No description provided for @onboardingActivityStudyDesc.
  ///
  /// In en, this message translates to:
  /// **'Learning, coursework, research'**
  String get onboardingActivityStudyDesc;

  /// No description provided for @onboardingActivityReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get onboardingActivityReadingTitle;

  /// No description provided for @onboardingActivityReadingDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep reading, articles, books'**
  String get onboardingActivityReadingDesc;

  /// No description provided for @onboardingActivityMeditationTitle.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get onboardingActivityMeditationTitle;

  /// No description provided for @onboardingActivityMeditationDesc.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness, breathing exercises'**
  String get onboardingActivityMeditationDesc;

  /// No description provided for @onboardingActivityOtherTitle.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingActivityOtherTitle;

  /// No description provided for @onboardingActivityOtherDesc.
  ///
  /// In en, this message translates to:
  /// **'Any focus-requiring activity'**
  String get onboardingActivityOtherDesc;

  /// No description provided for @onboardingActivitiesTip.
  ///
  /// In en, this message translates to:
  /// **'Pro tip: Focus Field shines when quiet = focused! 🤫✨'**
  String get onboardingActivitiesTip;

  /// No description provided for @onboardingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters! 🔒'**
  String get onboardingPermissionTitle;

  /// No description provided for @onboardingPermissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need microphone access to measure ambient noise and help you focus better'**
  String get onboardingPermissionSubtitle;

  /// No description provided for @onboardingPrivacyNoRecordingTitle.
  ///
  /// In en, this message translates to:
  /// **'No Recording'**
  String get onboardingPrivacyNoRecordingTitle;

  /// No description provided for @onboardingPrivacyNoRecordingDesc.
  ///
  /// In en, this message translates to:
  /// **'We only measure noise levels, never record audio'**
  String get onboardingPrivacyNoRecordingDesc;

  /// No description provided for @onboardingPrivacyLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get onboardingPrivacyLocalTitle;

  /// No description provided for @onboardingPrivacyLocalDesc.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device'**
  String get onboardingPrivacyLocalDesc;

  /// No description provided for @onboardingPrivacyFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get onboardingPrivacyFirstTitle;

  /// No description provided for @onboardingPrivacyFirstDesc.
  ///
  /// In en, this message translates to:
  /// **'Your conversations are completely private'**
  String get onboardingPrivacyFirstDesc;

  /// No description provided for @onboardingPermissionNote.
  ///
  /// In en, this message translates to:
  /// **'You can grant permission on the next screen when starting your first session'**
  String get onboardingPermissionNote;

  /// No description provided for @onboardingTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips for Success! 💡'**
  String get onboardingTipsTitle;

  /// No description provided for @onboardingTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These will help you make the most of Focus Field!'**
  String get onboardingTipsSubtitle;

  /// No description provided for @onboardingTip1Title.
  ///
  /// In en, this message translates to:
  /// **'Start Small, Win Big! 🌱'**
  String get onboardingTip1Title;

  /// No description provided for @onboardingTip1Desc.
  ///
  /// In en, this message translates to:
  /// **'Begin with 5-10 minute sessions. Consistency beats perfection!'**
  String get onboardingTip1Desc;

  /// No description provided for @onboardingTip2Title.
  ///
  /// In en, this message translates to:
  /// **'Activate Focus Mode! 🎯'**
  String get onboardingTip2Title;

  /// No description provided for @onboardingTip2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap Focus Mode for immersive, distraction-free experience.'**
  String get onboardingTip2Desc;

  /// No description provided for @onboardingTip3Title.
  ///
  /// In en, this message translates to:
  /// **'Freeze Token = Safety Net! ❄️'**
  String get onboardingTip3Title;

  /// No description provided for @onboardingTip3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use your monthly token on busy days to protect your streak.'**
  String get onboardingTip3Desc;

  /// No description provided for @onboardingTip4Title.
  ///
  /// In en, this message translates to:
  /// **'The 70% Rule Rocks! 📈'**
  String get onboardingTip4Title;

  /// No description provided for @onboardingTip4Desc.
  ///
  /// In en, this message translates to:
  /// **'Aim for 70% quiet time - perfect silence not required!'**
  String get onboardingTip4Desc;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Ready to Launch! 🚀'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your first session and build amazing habits!'**
  String get onboardingReadyDesc;

  /// No description provided for @questMotivation1.
  ///
  /// In en, this message translates to:
  /// **'Success is never ending and failure is never final'**
  String get questMotivation1;

  /// No description provided for @questMotivation2.
  ///
  /// In en, this message translates to:
  /// **'Progress over perfection - every minute counts'**
  String get questMotivation2;

  /// No description provided for @questMotivation3.
  ///
  /// In en, this message translates to:
  /// **'Small steps daily lead to big changes'**
  String get questMotivation3;

  /// No description provided for @questMotivation4.
  ///
  /// In en, this message translates to:
  /// **'You\'re building better habits, one session at a time'**
  String get questMotivation4;

  /// No description provided for @questMotivation5.
  ///
  /// In en, this message translates to:
  /// **'Consistency beats intensity'**
  String get questMotivation5;

  /// No description provided for @questMotivation6.
  ///
  /// In en, this message translates to:
  /// **'Every session is a win, no matter how short'**
  String get questMotivation6;

  /// No description provided for @questMotivation7.
  ///
  /// In en, this message translates to:
  /// **'Focus is a muscle - you\'re getting stronger'**
  String get questMotivation7;

  /// No description provided for @questMotivation8.
  ///
  /// In en, this message translates to:
  /// **'The journey of a thousand miles begins with a single step'**
  String get questMotivation8;

  /// No description provided for @questGo.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get questGo;

  /// No description provided for @questTapStart.
  ///
  /// In en, this message translates to:
  /// **'Tap Start →'**
  String get questTapStart;

  /// No description provided for @todayDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Focus Dashboard'**
  String get todayDashboardTitle;

  /// No description provided for @todayFocusMinutes.
  ///
  /// In en, this message translates to:
  /// **'Focus minutes today'**
  String get todayFocusMinutes;

  /// No description provided for @todayGoalCalm.
  ///
  /// In en, this message translates to:
  /// **'Goal: {goalMinutes} min • Calm ≥{calmPercent}%'**
  String todayGoalCalm(int goalMinutes, int calmPercent);

  /// No description provided for @todayPickMode.
  ///
  /// In en, this message translates to:
  /// **'Pick your mode'**
  String get todayPickMode;

  /// No description provided for @todayDefaultActivities.
  ///
  /// In en, this message translates to:
  /// **'Study • Reading • Meditation'**
  String get todayDefaultActivities;

  /// No description provided for @todayTooltipTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get todayTooltipTips;

  /// No description provided for @todayTooltipTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get todayTooltipTheme;

  /// No description provided for @todayTooltipSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get todayTooltipSettings;

  /// No description provided for @todayThemeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme changed to {themeName}'**
  String todayThemeChanged(String themeName);

  /// No description provided for @todayTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTabToday;

  /// No description provided for @todayTabSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get todayTabSessions;

  /// No description provided for @todayHelperText.
  ///
  /// In en, this message translates to:
  /// **'Set your duration and track your time. Session history and analytics will appear in Summary.'**
  String get todayHelperText;

  /// No description provided for @statPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get statPoints;

  /// No description provided for @statStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get statStreak;

  /// No description provided for @statSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get statSessions;

  /// No description provided for @statSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get statSuccess;

  /// No description provided for @ringProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Ring Progress'**
  String get ringProgressTitle;

  /// No description provided for @ringOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get ringOverall;

  /// No description provided for @ringOverallFrozen.
  ///
  /// In en, this message translates to:
  /// **'Overall ❄️'**
  String get ringOverallFrozen;

  /// No description provided for @sessionCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get sessionCalm;

  /// No description provided for @sessionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get sessionStart;

  /// No description provided for @sessionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get sessionStop;

  /// No description provided for @buttonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get buttonEdit;

  /// No description provided for @durationUpTo1Hour.
  ///
  /// In en, this message translates to:
  /// **'Sessions up to 1 hour'**
  String get durationUpTo1Hour;

  /// No description provided for @durationUpTo1_5Hours.
  ///
  /// In en, this message translates to:
  /// **'Sessions up to 1.5 hours'**
  String get durationUpTo1_5Hours;

  /// No description provided for @durationUpTo2Hours.
  ///
  /// In en, this message translates to:
  /// **'Sessions up to 2 hours'**
  String get durationUpTo2Hours;

  /// No description provided for @durationExtended.
  ///
  /// In en, this message translates to:
  /// **'Extended session durations'**
  String get durationExtended;

  /// No description provided for @durationExtendedAccess.
  ///
  /// In en, this message translates to:
  /// **'Extended session access'**
  String get durationExtendedAccess;

  /// No description provided for @noiseRoomLoudness.
  ///
  /// In en, this message translates to:
  /// **'Room Loudness'**
  String get noiseRoomLoudness;

  /// No description provided for @noiseThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Threshold: {threshold}dB'**
  String noiseThresholdLabel(int threshold);

  /// No description provided for @noiseThresholdSet.
  ///
  /// In en, this message translates to:
  /// **'Threshold set to {db} dB'**
  String noiseThresholdSet(int db);

  /// No description provided for @noiseHighDetected.
  ///
  /// In en, this message translates to:
  /// **'High noise detected, please proceed to a quieter room for better focus'**
  String get noiseHighDetected;

  /// No description provided for @noiseThresholdExceededHint.
  ///
  /// In en, this message translates to:
  /// **'Find a quieter room or increase threshold →'**
  String get noiseThresholdExceededHint;

  /// No description provided for @noiseExceededIncreasePrompt.
  ///
  /// In en, this message translates to:
  /// **'Find a quieter room or increase to {db}dB?'**
  String noiseExceededIncreasePrompt(int db);

  /// No description provided for @noiseHighIncreasePrompt.
  ///
  /// In en, this message translates to:
  /// **'High noise detected. Increase to {db}dB?'**
  String noiseHighIncreasePrompt(int db);

  /// No description provided for @noiseAtMaxThreshold.
  ///
  /// In en, this message translates to:
  /// **'Already at maximum threshold. Please find a quieter room.'**
  String get noiseAtMaxThreshold;

  /// No description provided for @noiseThresholdYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get noiseThresholdYes;

  /// No description provided for @noiseThresholdNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noiseThresholdNo;

  /// No description provided for @trendsInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get trendsInsights;

  /// No description provided for @trendsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get trendsLast7Days;

  /// No description provided for @trendsShareWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Share weekly summary'**
  String get trendsShareWeeklySummary;

  /// No description provided for @trendsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get trendsLoading;

  /// No description provided for @trendsLoadingMetrics.
  ///
  /// In en, this message translates to:
  /// **'Loading metrics...'**
  String get trendsLoadingMetrics;

  /// No description provided for @trendsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get trendsNoData;

  /// No description provided for @trendsWeeklyTotal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Total'**
  String get trendsWeeklyTotal;

  /// No description provided for @trendsBestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get trendsBestDay;

  /// No description provided for @trendsActivityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Activity Heatmap'**
  String get trendsActivityHeatmap;

  /// No description provided for @trendsRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get trendsRecentActivity;

  /// No description provided for @trendsHeatmapError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load heatmap'**
  String get trendsHeatmapError;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @focusModeComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get focusModeComplete;

  /// No description provided for @focusModeGreatSession.
  ///
  /// In en, this message translates to:
  /// **'Great focus session'**
  String get focusModeGreatSession;

  /// No description provided for @focusModeResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get focusModeResume;

  /// No description provided for @focusModePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get focusModePause;

  /// No description provided for @focusModeLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long press to pause or stop'**
  String get focusModeLongPressHint;

  /// No description provided for @activityEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Activities'**
  String get activityEditTitle;

  /// No description provided for @activityRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 10+ min per activity for consistent habit building'**
  String get activityRecommendation;

  /// No description provided for @activityDailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get activityDailyGoals;

  /// No description provided for @activityTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total: {hours}h / 18h'**
  String activityTotalHours(String hours);

  /// No description provided for @activityPerActivity.
  ///
  /// In en, this message translates to:
  /// **'Per-Activity'**
  String get activityPerActivity;

  /// No description provided for @activityExceedsLimit.
  ///
  /// In en, this message translates to:
  /// **'Total exceeds 18-hour daily limit. Please reduce goals.'**
  String get activityExceedsLimit;

  /// No description provided for @activityGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get activityGoalLabel;

  /// No description provided for @activityGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your daily focus target (1 min - 18h)'**
  String get activityGoalDescription;

  /// No description provided for @shareYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Share Your Progress'**
  String get shareYourProgress;

  /// No description provided for @shareTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get shareTimeRange;

  /// No description provided for @shareCardSize.
  ///
  /// In en, this message translates to:
  /// **'Card Size'**
  String get shareCardSize;

  /// No description provided for @analyticsPerformanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get analyticsPerformanceMetrics;

  /// No description provided for @analyticsPreferredDuration.
  ///
  /// In en, this message translates to:
  /// **'Preferred Duration'**
  String get analyticsPreferredDuration;

  /// No description provided for @analyticsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Analytics unavailable'**
  String get analyticsUnavailable;

  /// No description provided for @analyticsRestoreAttempt.
  ///
  /// In en, this message translates to:
  /// **'We\'ll attempt to restore this section on the next app launch.'**
  String get analyticsRestoreAttempt;

  /// No description provided for @audioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio temporarily unavailable'**
  String get audioUnavailable;

  /// No description provided for @audioRecovering.
  ///
  /// In en, this message translates to:
  /// **'Audio processing encountered an issue. Recovering automatically...'**
  String get audioRecovering;

  /// No description provided for @shareQuietMinutes.
  ///
  /// In en, this message translates to:
  /// **'QUIET MINUTES'**
  String get shareQuietMinutes;

  /// No description provided for @shareTopActivity.
  ///
  /// In en, this message translates to:
  /// **'Top Activity'**
  String get shareTopActivity;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Focus Field'**
  String get appName;

  /// No description provided for @sharePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get sharePreview;

  /// No description provided for @sharePinchToZoom.
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom'**
  String get sharePinchToZoom;

  /// No description provided for @shareGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get shareGenerating;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @shareTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get shareTodayLabel;

  /// No description provided for @shareWeeklyLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get shareWeeklyLabel;

  /// No description provided for @shareTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get shareTodayTitle;

  /// No description provided for @shareWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Weekly Focus'**
  String get shareWeeklyTitle;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'My Focus Field Progress'**
  String get shareSubject;

  /// No description provided for @shareFormatSquare.
  ///
  /// In en, this message translates to:
  /// **'1:1 ratio • Universal compatibility'**
  String get shareFormatSquare;

  /// No description provided for @shareFormatPost.
  ///
  /// In en, this message translates to:
  /// **'4:5 ratio • Instagram/Twitter posts'**
  String get shareFormatPost;

  /// No description provided for @shareFormatStory.
  ///
  /// In en, this message translates to:
  /// **'9:16 ratio • Instagram Stories'**
  String get shareFormatStory;

  /// No description provided for @recapWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Recap'**
  String get recapWeeklyTitle;

  /// No description provided for @recapMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get recapMinutes;

  /// No description provided for @recapStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak: {start} → {end} days'**
  String recapStreak(int start, int end);

  /// No description provided for @recapTopActivity.
  ///
  /// In en, this message translates to:
  /// **'Top Activity: '**
  String get recapTopActivity;

  /// No description provided for @practiceOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Overview'**
  String get practiceOverviewTitle;

  /// No description provided for @practiceLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get practiceLast7Days;

  /// No description provided for @audioMultipleErrors.
  ///
  /// In en, this message translates to:
  /// **'Multiple audio errors detected. Component recovering...'**
  String get audioMultipleErrors;

  /// No description provided for @activityCurrentGoal.
  ///
  /// In en, this message translates to:
  /// **'Current goal: {goal}'**
  String activityCurrentGoal(String goal);

  /// No description provided for @activitySaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get activitySaveChanges;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsTooltip.
  ///
  /// In en, this message translates to:
  /// **'View detailed insights'**
  String get insightsTooltip;

  /// No description provided for @statDays.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get statDays;

  /// No description provided for @sessionsTotalToday.
  ///
  /// In en, this message translates to:
  /// **'Total Today {done}/{goal} min, choose any activity'**
  String sessionsTotalToday(int done, int goal);

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @premiumFeatureAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium feature access'**
  String get premiumFeatureAccess;

  /// No description provided for @activityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get activityUnknown;

  /// No description provided for @insightsFirstSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your first session'**
  String get insightsFirstSessionTitle;

  /// No description provided for @insightsFirstSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your focus time, session patterns, and ambient score trends'**
  String get insightsFirstSessionSubtitle;

  /// No description provided for @sessionAmbientLabel.
  ///
  /// In en, this message translates to:
  /// **'Ambient: {percent}%'**
  String sessionAmbientLabel(int percent);

  /// No description provided for @sessionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get sessionSuccess;

  /// No description provided for @sessionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get sessionFailed;

  /// No description provided for @focusModeButton.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusModeButton;

  /// No description provided for @settingsDailyGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get settingsDailyGoalsTitle;

  /// No description provided for @settingsFocusModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Minimize distractions during sessions with a focused overlay'**
  String get settingsFocusModeDescription;

  /// No description provided for @settingsDeepFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Focus'**
  String get settingsDeepFocusTitle;

  /// No description provided for @settingsDeepFocusDescription.
  ///
  /// In en, this message translates to:
  /// **'End session if app is left'**
  String get settingsDeepFocusDescription;

  /// No description provided for @deepFocusDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Focus'**
  String get deepFocusDialogTitle;

  /// No description provided for @deepFocusEnableLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Deep Focus'**
  String get deepFocusEnableLabel;

  /// No description provided for @deepFocusGracePeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Grace period (seconds)'**
  String get deepFocusGracePeriodLabel;

  /// No description provided for @deepFocusExplanation.
  ///
  /// In en, this message translates to:
  /// **'When enabled, leaving the app will end the session after the grace period.'**
  String get deepFocusExplanation;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Focus Field needs notification permission to send you:'**
  String get notificationPermissionExplanation;

  /// No description provided for @notificationBenefitReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily focus reminders'**
  String get notificationBenefitReminders;

  /// No description provided for @notificationBenefitCompletion.
  ///
  /// In en, this message translates to:
  /// **'Session completion alerts'**
  String get notificationBenefitCompletion;

  /// No description provided for @notificationBenefitAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievement celebrations'**
  String get notificationBenefitAchievements;

  /// No description provided for @notificationHowToEnableIos.
  ///
  /// In en, this message translates to:
  /// **'How to enable on iOS:'**
  String get notificationHowToEnableIos;

  /// No description provided for @notificationHowToEnableAndroid.
  ///
  /// In en, this message translates to:
  /// **'How to enable on Android:'**
  String get notificationHowToEnableAndroid;

  /// No description provided for @notificationStepsIos.
  ///
  /// In en, this message translates to:
  /// **'1. Tap \"Open Settings\" below\n2. Tap \"Notifications\"\n3. Enable \"Allow Notifications\"'**
  String get notificationStepsIos;

  /// No description provided for @notificationStepsAndroid.
  ///
  /// In en, this message translates to:
  /// **'1. Tap \"Open Settings\" below\n2. Tap \"Notifications\"\n3. Enable \"All Focus Field notifications\"'**
  String get notificationStepsAndroid;

  /// No description provided for @aboutShowTips.
  ///
  /// In en, this message translates to:
  /// **'Show Tips'**
  String get aboutShowTips;

  /// No description provided for @aboutShowTipsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show helpful tips on app startup and via the lightbulb icon. Tips appear every 2-3 days.'**
  String get aboutShowTipsDescription;

  /// No description provided for @aboutReplayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay Onboarding'**
  String get aboutReplayOnboarding;

  /// No description provided for @aboutReplayOnboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the app tour and setup your preferences again'**
  String get aboutReplayOnboardingDescription;

  /// No description provided for @buttonFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get buttonFaq;

  /// No description provided for @onboardingWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Ready to start your first session? 🚀'**
  String get onboardingWelcomeMessage;

  /// No description provided for @onboardingFeatureEarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards'**
  String get onboardingFeatureEarnTitle;

  /// No description provided for @onboardingFeatureEarnDesc.
  ///
  /// In en, this message translates to:
  /// **'Every quiet minute counts! Collect points and celebrate your wins 🏆'**
  String get onboardingFeatureEarnDesc;

  /// No description provided for @onboardingFeatureBuildTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Streaks'**
  String get onboardingFeatureBuildTitle;

  /// No description provided for @onboardingFeatureBuildDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep the momentum going! Our compassionate system keeps you motivated 🔥'**
  String get onboardingFeatureBuildDesc;

  /// No description provided for @onboardingEnvironmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your typical environment so we can optimize for your space!'**
  String get onboardingEnvironmentDescription;

  /// No description provided for @onboardingEnvQuietHome.
  ///
  /// In en, this message translates to:
  /// **'Quiet Home'**
  String get onboardingEnvQuietHome;

  /// No description provided for @onboardingEnvQuietHomeLevel.
  ///
  /// In en, this message translates to:
  /// **'30 dB - Very quiet'**
  String get onboardingEnvQuietHomeLevel;

  /// No description provided for @onboardingEnvOffice.
  ///
  /// In en, this message translates to:
  /// **'Typical Office'**
  String get onboardingEnvOffice;

  /// No description provided for @onboardingEnvOfficeLevel.
  ///
  /// In en, this message translates to:
  /// **'40 dB - Library quiet (Recommended)'**
  String get onboardingEnvOfficeLevel;

  /// No description provided for @onboardingEnvBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy Space'**
  String get onboardingEnvBusy;

  /// No description provided for @onboardingEnvBusyLevel.
  ///
  /// In en, this message translates to:
  /// **'50 dB - Moderate noise'**
  String get onboardingEnvBusyLevel;

  /// No description provided for @onboardingEnvNoisy.
  ///
  /// In en, this message translates to:
  /// **'Noisy Environment'**
  String get onboardingEnvNoisy;

  /// No description provided for @onboardingEnvNoisyLevel.
  ///
  /// In en, this message translates to:
  /// **'60 dB - Higher noise'**
  String get onboardingEnvNoisyLevel;

  /// No description provided for @onboardingAdjustAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can adjust this anytime in Settings'**
  String get onboardingAdjustAnytime;

  /// No description provided for @starterSessionTip.
  ///
  /// In en, this message translates to:
  /// **'👋 Starting with a {starterMinutes}-minute session to help you get comfortable. Your full {goalMinutes}-minute goal is ready when you are!'**
  String starterSessionTip(int starterMinutes, int goalMinutes);

  /// No description provided for @buttonGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get buttonGotIt;

  /// No description provided for @buttonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get buttonGetStarted;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @errorActivityRequired.
  ///
  /// In en, this message translates to:
  /// **'⚠️ At least one activity must be enabled'**
  String get errorActivityRequired;

  /// No description provided for @errorGoalExceeds.
  ///
  /// In en, this message translates to:
  /// **'Total goals exceed 18-hour daily limit. Please reduce goals.'**
  String get errorGoalExceeds;

  /// No description provided for @messageSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get messageSaved;

  /// No description provided for @errorPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get errorPermissionRequired;

  /// No description provided for @notificationEnableReason.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive reminders and celebrate achievements.'**
  String get notificationEnableReason;

  /// No description provided for @buttonEnableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get buttonEnableNotifications;

  /// No description provided for @buttonRequesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get buttonRequesting;

  /// No description provided for @notificationDailyTime.
  ///
  /// In en, this message translates to:
  /// **'Daily Time'**
  String get notificationDailyTime;

  /// No description provided for @notificationDailyReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder at {time}'**
  String notificationDailyReminderSet(String time);

  /// No description provided for @notificationLearning.
  ///
  /// In en, this message translates to:
  /// **'learning'**
  String get notificationLearning;

  /// No description provided for @notificationSmart.
  ///
  /// In en, this message translates to:
  /// **'Smart ({time})'**
  String notificationSmart(String time);

  /// No description provided for @buttonUseSmart.
  ///
  /// In en, this message translates to:
  /// **'Use Smart'**
  String get buttonUseSmart;

  /// No description provided for @notificationSmartExplanation.
  ///
  /// In en, this message translates to:
  /// **'Choose a fixed time or let Focus Field learn your pattern.'**
  String get notificationSmartExplanation;

  /// No description provided for @notificationSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Completed'**
  String get notificationSessionComplete;

  /// No description provided for @notificationSessionCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Celebrate completed sessions'**
  String get notificationSessionCompleteDesc;

  /// No description provided for @notificationAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked'**
  String get notificationAchievement;

  /// No description provided for @notificationAchievementDesc.
  ///
  /// In en, this message translates to:
  /// **'Milestone notifications'**
  String get notificationAchievementDesc;

  /// No description provided for @notificationWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Summary'**
  String get notificationWeekly;

  /// No description provided for @notificationWeeklyDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly insights (weekday & time)'**
  String get notificationWeeklyDesc;

  /// No description provided for @notificationWeeklyTime.
  ///
  /// In en, this message translates to:
  /// **'Weekly Time'**
  String get notificationWeeklyTime;

  /// No description provided for @notificationMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone notifications'**
  String get notificationMilestone;

  /// No description provided for @notificationWeeklyInsights.
  ///
  /// In en, this message translates to:
  /// **'Weekly insights (weekday & time)'**
  String get notificationWeeklyInsights;

  /// No description provided for @notificationDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get notificationDailyReminder;

  /// No description provided for @notificationComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get notificationComplete;

  /// No description provided for @settingsSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications in device settings'**
  String get settingsSnackbar;

  /// No description provided for @shareCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Card'**
  String get shareCardTitle;

  /// No description provided for @shareYourWeek.
  ///
  /// In en, this message translates to:
  /// **'Share Your Week'**
  String get shareYourWeek;

  /// No description provided for @shareStyleGradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient Style'**
  String get shareStyleGradient;

  /// No description provided for @shareStyleGradientDesc.
  ///
  /// In en, this message translates to:
  /// **'Bold gradient with large numbers'**
  String get shareStyleGradientDesc;

  /// No description provided for @shareWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get shareWeeklySummary;

  /// No description provided for @shareStyleAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement Style'**
  String get shareStyleAchievement;

  /// No description provided for @shareStyleAchievementDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on total quiet minutes'**
  String get shareStyleAchievementDesc;

  /// No description provided for @shareQuietMinutesWeek.
  ///
  /// In en, this message translates to:
  /// **'Quiet Minutes This Week'**
  String get shareQuietMinutesWeek;

  /// No description provided for @shareAchievementMessage.
  ///
  /// In en, this message translates to:
  /// **'Building deeper focus,\\none session at a time'**
  String get shareAchievementMessage;

  /// No description provided for @shareAchievementCard.
  ///
  /// In en, this message translates to:
  /// **'Achievement Card'**
  String get shareAchievementCard;

  /// No description provided for @shareTextOnly.
  ///
  /// In en, this message translates to:
  /// **'Text Only'**
  String get shareTextOnly;

  /// No description provided for @shareTextOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Share as plain text (no image)'**
  String get shareTextOnlyDesc;

  /// No description provided for @shareYourStreak.
  ///
  /// In en, this message translates to:
  /// **'Share Your Streak'**
  String get shareYourStreak;

  /// No description provided for @shareAsCard.
  ///
  /// In en, this message translates to:
  /// **'Share as Card'**
  String get shareAsCard;

  /// No description provided for @shareAsCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Beautiful visual card'**
  String get shareAsCardDesc;

  /// No description provided for @shareStreakCard.
  ///
  /// In en, this message translates to:
  /// **'Streak Card'**
  String get shareStreakCard;

  /// No description provided for @shareAsText.
  ///
  /// In en, this message translates to:
  /// **'Share as Text'**
  String get shareAsText;

  /// No description provided for @shareAsTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Simple text message'**
  String get shareAsTextDesc;

  /// No description provided for @shareErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to share. Please try again.'**
  String get shareErrorFailed;

  /// No description provided for @buttonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get buttonShare;

  /// No description provided for @initializingApp.
  ///
  /// In en, this message translates to:
  /// **'Initializing app...'**
  String get initializingApp;

  /// No description provided for @initializationFailed.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed: {error}'**
  String initializationFailed(String error);

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @settingsLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Settings loading failed: {error}'**
  String settingsLoadingFailed(String error);

  /// No description provided for @loadingUserData.
  ///
  /// In en, this message translates to:
  /// **'Loading user data...'**
  String get loadingUserData;

  /// No description provided for @dataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Data loading failed: {error}'**
  String dataLoadingFailed(String error);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @taglineSilence.
  ///
  /// In en, this message translates to:
  /// **'🤫 Master the Art of Silence'**
  String get taglineSilence;

  /// No description provided for @errorOops.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get errorOops;

  /// No description provided for @buttonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// No description provided for @resetAppData.
  ///
  /// In en, this message translates to:
  /// **'Reset App Data'**
  String get resetAppData;

  /// No description provided for @resetAppDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This will reset all app data and settings to their defaults. This action cannot be undone.\\n\\nDo you want to continue?'**
  String get resetAppDataMessage;

  /// No description provided for @buttonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get buttonReset;

  /// No description provided for @messageDataReset.
  ///
  /// In en, this message translates to:
  /// **'App data has been reset'**
  String get messageDataReset;

  /// No description provided for @errorResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset data: {error}'**
  String errorResetFailed(String error);

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get analyticsOverview;

  /// No description provided for @analyticsPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get analyticsPoints;

  /// No description provided for @analyticsStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get analyticsStreak;

  /// No description provided for @analyticsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get analyticsSessions;

  /// No description provided for @analyticsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get analyticsLast7Days;

  /// No description provided for @analyticsPerformanceHighlights.
  ///
  /// In en, this message translates to:
  /// **'Performance Highlights'**
  String get analyticsPerformanceHighlights;

  /// No description provided for @analyticsSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get analyticsSuccessRate;

  /// No description provided for @analyticsAvgSession.
  ///
  /// In en, this message translates to:
  /// **'Avg Session'**
  String get analyticsAvgSession;

  /// No description provided for @analyticsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get analyticsBestStreak;

  /// No description provided for @analyticsActivityProgress.
  ///
  /// In en, this message translates to:
  /// **'Activity Progress'**
  String get analyticsActivityProgress;

  /// No description provided for @analyticsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Detailed activity tracking coming soon.'**
  String get analyticsComingSoon;

  /// No description provided for @analyticsAdvancedMetrics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Metrics'**
  String get analyticsAdvancedMetrics;

  /// No description provided for @analyticsPremiumContent.
  ///
  /// In en, this message translates to:
  /// **'Premium advanced analytics content here...'**
  String get analyticsPremiumContent;

  /// No description provided for @analytics30DayTrends.
  ///
  /// In en, this message translates to:
  /// **'30-Day Trends'**
  String get analytics30DayTrends;

  /// No description provided for @analyticsTrendsChart.
  ///
  /// In en, this message translates to:
  /// **'Premium trends chart here...'**
  String get analyticsTrendsChart;

  /// No description provided for @analyticsAIInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get analyticsAIInsights;

  /// No description provided for @analyticsAIComingSoon.
  ///
  /// In en, this message translates to:
  /// **'AI-powered insights coming soon...'**
  String get analyticsAIComingSoon;

  /// No description provided for @analyticsUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Advanced Analytics'**
  String get analyticsUnlock;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorQuestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Quest state not available'**
  String get errorQuestUnavailable;

  /// No description provided for @buttonOK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOK;

  /// No description provided for @errorFreezeTokenFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to use freeze token'**
  String get errorFreezeTokenFailed;

  /// No description provided for @buttonUseFreeze.
  ///
  /// In en, this message translates to:
  /// **'Use Freeze'**
  String get buttonUseFreeze;

  /// No description provided for @onboardingDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Your Daily Goal! 🎯'**
  String get onboardingDailyGoalTitle;

  /// No description provided for @onboardingDailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How much focused time feels right for you?\\n(You can adjust this anytime!)'**
  String get onboardingDailyGoalSubtitle;

  /// No description provided for @onboardingGoalGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get onboardingGoalGettingStarted;

  /// No description provided for @onboardingGoalBuildingHabit.
  ///
  /// In en, this message translates to:
  /// **'Building Habit'**
  String get onboardingGoalBuildingHabit;

  /// No description provided for @onboardingGoalRegularPractice.
  ///
  /// In en, this message translates to:
  /// **'Regular Practice'**
  String get onboardingGoalRegularPractice;

  /// No description provided for @onboardingGoalDeepWork.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get onboardingGoalDeepWork;

  /// No description provided for @onboardingProTip.
  ///
  /// In en, this message translates to:
  /// **'Pro tip: Focus Field shines when quiet = focused! 🤫✨'**
  String get onboardingProTip;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters! 🔒'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need microphone access to measure ambient noise and help you focus better'**
  String get onboardingPrivacySubtitle;

  /// No description provided for @onboardingPrivacyNoRecording.
  ///
  /// In en, this message translates to:
  /// **'No Recording'**
  String get onboardingPrivacyNoRecording;

  /// No description provided for @onboardingPrivacyLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get onboardingPrivacyLocalOnly;

  /// No description provided for @onboardingPrivacyLocalOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device'**
  String get onboardingPrivacyLocalOnlyDesc;

  /// No description provided for @onboardingPrivacyFirst.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get onboardingPrivacyFirst;

  /// No description provided for @onboardingPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'You can grant permission on the next screen when starting your first session'**
  String get onboardingPrivacyNote;

  /// No description provided for @insightsFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get insightsFocusTime;

  /// No description provided for @insightsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get insightsSessions;

  /// No description provided for @insightsAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get insightsAverage;

  /// No description provided for @insightsAmbientScore.
  ///
  /// In en, this message translates to:
  /// **'Ambient Score'**
  String get insightsAmbientScore;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeOceanBlue.
  ///
  /// In en, this message translates to:
  /// **'Ocean Blue'**
  String get themeOceanBlue;

  /// No description provided for @themeForestGreen.
  ///
  /// In en, this message translates to:
  /// **'Forest Green'**
  String get themeForestGreen;

  /// No description provided for @themePurpleNight.
  ///
  /// In en, this message translates to:
  /// **'Purple Night'**
  String get themePurpleNight;

  /// No description provided for @themeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get themeGold;

  /// No description provided for @themeSolarSunrise.
  ///
  /// In en, this message translates to:
  /// **'Solar Sunrise'**
  String get themeSolarSunrise;

  /// No description provided for @themeCyberNeon.
  ///
  /// In en, this message translates to:
  /// **'Cyber Neon'**
  String get themeCyberNeon;

  /// No description provided for @themeLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get themeLuxury;

  /// No description provided for @settingsAppTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get settingsAppTheme;

  /// No description provided for @freezeTokenNoTokensTitle.
  ///
  /// In en, this message translates to:
  /// **'No Freeze Tokens'**
  String get freezeTokenNoTokensTitle;

  /// No description provided for @freezeTokenNoTokensMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any freeze tokens available. You earn 1 freeze token per week (max 4).'**
  String get freezeTokenNoTokensMessage;

  /// No description provided for @freezeTokenGoalCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Already Completed'**
  String get freezeTokenGoalCompleteTitle;

  /// No description provided for @freezeTokenGoalCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Your daily goal is already complete! Freeze tokens can only be used when you haven\'t met your goal yet.'**
  String get freezeTokenGoalCompleteMessage;

  /// No description provided for @freezeTokenUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Freeze Token'**
  String get freezeTokenUseTitle;

  /// No description provided for @freezeTokenUseMessage.
  ///
  /// In en, this message translates to:
  /// **'Freeze tokens protect your streak when you miss a day. Using a freeze will count as completing your daily goal.'**
  String get freezeTokenUseMessage;

  /// No description provided for @freezeTokenUsePrompt.
  ///
  /// In en, this message translates to:
  /// **'You have {count} token(s). Use one now?'**
  String freezeTokenUsePrompt(Object count);

  /// No description provided for @freezeTokenUsedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Freeze token used! Goal marked as complete.'**
  String get freezeTokenUsedSuccess;

  /// No description provided for @trendsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get trendsErrorLoading;

  /// No description provided for @trendsPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get trendsPoints;

  /// No description provided for @trendsStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get trendsStreak;

  /// No description provided for @trendsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get trendsSessions;

  /// No description provided for @trendsTopActivity.
  ///
  /// In en, this message translates to:
  /// **'Top Activity'**
  String get trendsTopActivity;

  /// No description provided for @sectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sectionToday;

  /// No description provided for @sectionSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sectionSessions;

  /// No description provided for @sectionInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get sectionInsights;

  /// No description provided for @onboardingGoalAdviceGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Perfect start! 🌟 Small steps lead to big wins. You\'ve got this!'**
  String get onboardingGoalAdviceGettingStarted;

  /// No description provided for @onboardingGoalAdviceBuildingHabit.
  ///
  /// In en, this message translates to:
  /// **'Excellent choice! 🎯 This sweet spot builds lasting habits!'**
  String get onboardingGoalAdviceBuildingHabit;

  /// No description provided for @onboardingGoalAdviceRegularPractice.
  ///
  /// In en, this message translates to:
  /// **'Ambitious! 💪 You\'re ready to level up your focus game!'**
  String get onboardingGoalAdviceRegularPractice;

  /// No description provided for @onboardingGoalAdviceDeepWork.
  ///
  /// In en, this message translates to:
  /// **'Wow! 🏆 Deep work mode activated! Remember to take breaks!'**
  String get onboardingGoalAdviceDeepWork;

  /// No description provided for @onboardingDuration10to15.
  ///
  /// In en, this message translates to:
  /// **'10-15 minutes'**
  String get onboardingDuration10to15;

  /// No description provided for @onboardingDuration20to30.
  ///
  /// In en, this message translates to:
  /// **'20-30 minutes'**
  String get onboardingDuration20to30;

  /// No description provided for @onboardingDuration40to60.
  ///
  /// In en, this message translates to:
  /// **'40-60 minutes'**
  String get onboardingDuration40to60;

  /// No description provided for @onboardingDuration60plus.
  ///
  /// In en, this message translates to:
  /// **'60+ minutes'**
  String get onboardingDuration60plus;

  /// No description provided for @activityStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get activityStudy;

  /// No description provided for @activityReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get activityReading;

  /// No description provided for @activityMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get activityMeditation;

  /// No description provided for @activityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get activityOther;

  /// No description provided for @onboardingTip1Description.
  ///
  /// In en, this message translates to:
  /// **'Begin with 5-10 minute sessions. Consistency beats perfection!'**
  String get onboardingTip1Description;

  /// No description provided for @onboardingTip2Description.
  ///
  /// In en, this message translates to:
  /// **'Tap Focus Mode for immersive, distraction-free experience.'**
  String get onboardingTip2Description;

  /// No description provided for @onboardingTip3Description.
  ///
  /// In en, this message translates to:
  /// **'Use your monthly token on busy days to protect your streak.'**
  String get onboardingTip3Description;

  /// No description provided for @onboardingTip4Description.
  ///
  /// In en, this message translates to:
  /// **'Aim for 70% quiet time - perfect silence not required!'**
  String get onboardingTip4Description;

  /// No description provided for @onboardingLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Ready to Launch! 🚀'**
  String get onboardingLaunchTitle;

  /// No description provided for @onboardingLaunchDescription.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your first session and build amazing habits!'**
  String get onboardingLaunchDescription;

  /// No description provided for @insightsBestTimeByActivity.
  ///
  /// In en, this message translates to:
  /// **'Best Time by Activity'**
  String get insightsBestTimeByActivity;

  /// No description provided for @insightHighSuccessRateTitle.
  ///
  /// In en, this message translates to:
  /// **'High Success Rate'**
  String get insightHighSuccessRateTitle;

  /// No description provided for @insightEnvironmentStabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Environment Stability'**
  String get insightEnvironmentStabilityTitle;

  /// No description provided for @insightLowNoiseSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Noise Success'**
  String get insightLowNoiseSuccessTitle;

  /// No description provided for @insightConsistentPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Consistent Practice'**
  String get insightConsistentPracticeTitle;

  /// No description provided for @insightStreakProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Protection Available'**
  String get insightStreakProtectionTitle;

  /// No description provided for @insightRoomTooNoisyTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Too Noisy'**
  String get insightRoomTooNoisyTitle;

  /// No description provided for @insightIrregularScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Irregular Schedule'**
  String get insightIrregularScheduleTitle;

  /// No description provided for @insightLowAmbientScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Ambient Score'**
  String get insightLowAmbientScoreTitle;

  /// No description provided for @insightNoRecentSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Recent Sessions'**
  String get insightNoRecentSessionsTitle;

  /// No description provided for @insightHighSuccessRateDesc.
  ///
  /// In en, this message translates to:
  /// **'You are maintaining strong silent sessions.'**
  String get insightHighSuccessRateDesc;

  /// No description provided for @insightEnvironmentStabilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Ambient noise is within a moderate, manageable range.'**
  String get insightEnvironmentStabilityDesc;

  /// No description provided for @insightLowNoiseSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your environment is exceptionally quiet during sessions.'**
  String get insightLowNoiseSuccessDesc;

  /// No description provided for @insightConsistentPracticeDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re building a reliable daily practice habit.'**
  String get insightConsistentPracticeDesc;

  /// No description provided for @insightStreakProtectionDesc.
  ///
  /// In en, this message translates to:
  /// **'You have {count} freeze token(s) to protect your streak.'**
  String insightStreakProtectionDesc(Object count);

  /// No description provided for @insightRoomTooNoisyDesc.
  ///
  /// In en, this message translates to:
  /// **'Try finding a quieter space or adjusting your threshold.'**
  String get insightRoomTooNoisyDesc;

  /// No description provided for @insightIrregularScheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'More consistent session times may improve your streak.'**
  String get insightIrregularScheduleDesc;

  /// No description provided for @insightLowAmbientScoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Recent sessions had lower quiet time. Try a quieter environment.'**
  String get insightLowAmbientScoreDesc;

  /// No description provided for @insightNoRecentSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a session today to build your focus habit!'**
  String get insightNoRecentSessionsDesc;

  /// No description provided for @sessionCompleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Great job! {minutes} focus minutes in your session! ✨'**
  String sessionCompleteSuccess(Object minutes);

  /// No description provided for @sessionCompletePartial.
  ///
  /// In en, this message translates to:
  /// **'Good effort! {minutes} minutes completed.'**
  String sessionCompletePartial(Object minutes);

  /// No description provided for @sessionCompleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Session ended. Try again when ready.'**
  String get sessionCompleteFailed;

  /// No description provided for @notificationSessionStarted.
  ///
  /// In en, this message translates to:
  /// **'Session started - stay focused!'**
  String get notificationSessionStarted;

  /// No description provided for @notificationSessionPaused.
  ///
  /// In en, this message translates to:
  /// **'Session paused'**
  String get notificationSessionPaused;

  /// No description provided for @notificationSessionResumed.
  ///
  /// In en, this message translates to:
  /// **'Session resumed'**
  String get notificationSessionResumed;

  /// No description provided for @celebrationEffects.
  ///
  /// In en, this message translates to:
  /// **'Celebration Effects'**
  String get celebrationEffects;

  /// No description provided for @celebrationEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confetti • 1.5s • Chime'**
  String get celebrationEffectsSubtitle;

  /// No description provided for @celebrationEffectsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which celebration effects to show when sessions complete successfully'**
  String get celebrationEffectsDescription;

  /// No description provided for @confetti.
  ///
  /// In en, this message translates to:
  /// **'Confetti'**
  String get confetti;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'activity'**
  String get activity;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'activities'**
  String get activities;

  /// No description provided for @shareCardSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get shareCardSquare;

  /// No description provided for @shareCardPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get shareCardPost;

  /// No description provided for @shareCardStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get shareCardStory;

  /// No description provided for @featureExtendedSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions up to 120 minutes'**
  String get featureExtendedSessions;

  /// No description provided for @featureAdvancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Detailed trends and insights'**
  String get featureAdvancedAnalytics;

  /// No description provided for @featureCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Sync data across devices'**
  String get featureCloudSync;

  /// No description provided for @featureDataExport.
  ///
  /// In en, this message translates to:
  /// **'Export data as CSV/PDF'**
  String get featureDataExport;

  /// No description provided for @featurePremiumThemes.
  ///
  /// In en, this message translates to:
  /// **'Exclusive theme options'**
  String get featurePremiumThemes;

  /// No description provided for @featureMultiEnvironments.
  ///
  /// In en, this message translates to:
  /// **'Custom environment profiles'**
  String get featureMultiEnvironments;

  /// No description provided for @featureAiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI-powered recommendations'**
  String get featureAiInsights;

  /// No description provided for @featureSocialFeatures.
  ///
  /// In en, this message translates to:
  /// **'Challenges and competitions'**
  String get featureSocialFeatures;

  /// No description provided for @settingKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get settingKeepScreenOn;

  /// No description provided for @settingKeepScreenOnDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from locking during sessions'**
  String get settingKeepScreenOnDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'ja', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
    case 'pt': return AppLocalizationsPt();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
