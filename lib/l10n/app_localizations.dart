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
    Locale('pt', 'BR')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Silence Score'**
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
  /// **'Silence Score needs microphone access to measure ambient noise levels. No audio is stored.'**
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
  /// **'Find your quiet'**
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

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

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

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @faqHowWorksQ.
  ///
  /// In en, this message translates to:
  /// **'How does SilenceScore work?'**
  String get faqHowWorksQ;

  /// No description provided for @faqHowWorksA.
  ///
  /// In en, this message translates to:
  /// **'It measures ambient noise – time below threshold earns points.'**
  String get faqHowWorksA;

  /// No description provided for @faqAudioRecordedQ.
  ///
  /// In en, this message translates to:
  /// **'Is audio recorded?'**
  String get faqAudioRecordedQ;

  /// No description provided for @faqAudioRecordedA.
  ///
  /// In en, this message translates to:
  /// **'No. Only decibel levels are sampled; audio is never stored.'**
  String get faqAudioRecordedA;

  /// No description provided for @faqAdjustSensitivityQ.
  ///
  /// In en, this message translates to:
  /// **'Adjust sensitivity?'**
  String get faqAdjustSensitivityQ;

  /// No description provided for @faqAdjustSensitivityA.
  ///
  /// In en, this message translates to:
  /// **'Use Settings > Basic > Decibel Threshold ({min}–{max} dB) and calibrate first.'**
  String faqAdjustSensitivityA(int min, int max);

  /// No description provided for @faqPremiumFeaturesQ.
  ///
  /// In en, this message translates to:
  /// **'Premium features?'**
  String get faqPremiumFeaturesQ;

  /// No description provided for @faqPremiumFeaturesA.
  ///
  /// In en, this message translates to:
  /// **'Extended sessions (up to 120m), advanced analytics, export, themes.'**
  String get faqPremiumFeaturesA;

  /// No description provided for @faqNotificationsQ.
  ///
  /// In en, this message translates to:
  /// **'Notifications?'**
  String get faqNotificationsQ;

  /// No description provided for @faqNotificationsA.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders learn habits and celebrate milestones.'**
  String get faqNotificationsA;

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
  /// **'Enjoying Silence Score?'**
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
  /// **'Allow SilenceScore to send notifications'**
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
  /// **'Choose a fixed time or let SilenceScore learn your pattern.'**
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
  /// **'Daily Silence Reminder'**
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
  /// **'🧘‍♂️ Start your silence journey today! Find your inner peace.'**
  String get reminderStartJourney;

  /// No description provided for @reminderRestart.
  ///
  /// In en, this message translates to:
  /// **'🌱 Ready to restart your silence practice? Every moment is a new beginning.'**
  String get reminderRestart;

  /// No description provided for @reminderDayTwo.
  ///
  /// In en, this message translates to:
  /// **'⭐ Day 2 of your silence streak! Consistency builds tranquility.'**
  String get reminderDayTwo;

  /// No description provided for @reminderStreakShort.
  ///
  /// In en, this message translates to:
  /// **'🔥 {streak}-day streak! You\'re building a powerful habit.'**
  String reminderStreakShort(int streak);

  /// No description provided for @reminderStreakMedium.
  ///
  /// In en, this message translates to:
  /// **'🏆 Amazing {streak}-day streak! Your dedication is inspiring.'**
  String reminderStreakMedium(int streak);

  /// No description provided for @reminderStreakLong.
  ///
  /// In en, this message translates to:
  /// **'👑 Incredible {streak}-day streak! You\'re a silence master!'**
  String reminderStreakLong(int streak);

  /// No description provided for @achievementFirstSession.
  ///
  /// In en, this message translates to:
  /// **'🎉 First session completed! Welcome to your silence journey!'**
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
  /// **'✨ Perfect silence session! Not a sound disturbed your peace.'**
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
  /// **'💭 This week could use some silence. Ready for a peaceful session?'**
  String get weeklyProgressNone;

  /// No description provided for @weeklyProgressFew.
  ///
  /// In en, this message translates to:
  /// **'🌿 {count} sessions this week. Every practice deepens your calm.'**
  String weeklyProgressFew(int count);

  /// No description provided for @weeklyProgressSome.
  ///
  /// In en, this message translates to:
  /// **'🌊 {count} sessions this week! You\'re finding your rhythm.'**
  String weeklyProgressSome(int count);

  /// No description provided for @weeklyProgressPerfect.
  ///
  /// In en, this message translates to:
  /// **'🎯 Perfect week with {count} sessions! Your dedication shines.'**
  String weeklyProgressPerfect(int count);

  /// No description provided for @tipsHidden.
  ///
  /// In en, this message translates to:
  /// **'Tips hidden'**
  String get tipsHidden;

  /// No description provided for @tipsShown.
  ///
  /// In en, this message translates to:
  /// **'Tips shown'**
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
  /// **'Short sessions count—start with 2–3 minutes to build consistency.'**
  String get tip01;

  /// No description provided for @tip02.
  ///
  /// In en, this message translates to:
  /// **'Use Smart Daily Reminders to nudge you at your best time.'**
  String get tip02;

  /// No description provided for @tip03.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate when your environment changes for better accuracy.'**
  String get tip03;

  /// No description provided for @tip04.
  ///
  /// In en, this message translates to:
  /// **'Check Weekly Trends to spot your momentum over time.'**
  String get tip04;

  /// No description provided for @tip05.
  ///
  /// In en, this message translates to:
  /// **'Streaks grow with daily wins—show up, even for one minute.'**
  String get tip05;

  /// No description provided for @tip06.
  ///
  /// In en, this message translates to:
  /// **'High ambient noise? Raise threshold a bit to reduce false fails.'**
  String get tip06;

  /// No description provided for @tip07.
  ///
  /// In en, this message translates to:
  /// **'Try different times of day to find your quiet sweet spot.'**
  String get tip07;

  /// No description provided for @tip08.
  ///
  /// In en, this message translates to:
  /// **'Session complete notifications keep motivation high—enable them!'**
  String get tip08;

  /// No description provided for @tip09.
  ///
  /// In en, this message translates to:
  /// **'Prefer hands‑off? Auto reminders can schedule themselves (Smart).'**
  String get tip09;

  /// No description provided for @tip10.
  ///
  /// In en, this message translates to:
  /// **'Use shorter sessions on busy days to keep your streak alive.'**
  String get tip10;

  /// No description provided for @tip11.
  ///
  /// In en, this message translates to:
  /// **'The progress ring is tappable—start or stop with a single tap.'**
  String get tip11;

  /// No description provided for @tip12.
  ///
  /// In en, this message translates to:
  /// **'Export your data (Premium) to share progress or back it up.'**
  String get tip12;

  /// No description provided for @tip13.
  ///
  /// In en, this message translates to:
  /// **'Average session length helps you choose the right duration.'**
  String get tip13;

  /// No description provided for @tip14.
  ///
  /// In en, this message translates to:
  /// **'Consistency beats intensity—small daily practice compounds.'**
  String get tip14;

  /// No description provided for @tip15.
  ///
  /// In en, this message translates to:
  /// **'Set a gentle goal: 5 quiet minutes is a great baseline.'**
  String get tip15;

  /// No description provided for @tip16.
  ///
  /// In en, this message translates to:
  /// **'The noise chart helps you see spikes—aim for calmer periods.'**
  String get tip16;

  /// No description provided for @tip17.
  ///
  /// In en, this message translates to:
  /// **'Upgrade session duration (Premium) for longer focus blocks.'**
  String get tip17;

  /// No description provided for @tip18.
  ///
  /// In en, this message translates to:
  /// **'High threshold warning guards accuracy—avoid setting it too high.'**
  String get tip18;

  /// No description provided for @tip19.
  ///
  /// In en, this message translates to:
  /// **'Weekdays vary—tune your weekly summary to your schedule.'**
  String get tip19;

  /// No description provided for @tip20.
  ///
  /// In en, this message translates to:
  /// **'Accessibility options: high contrast, large text, and vibration.'**
  String get tip20;

  /// No description provided for @tip21.
  ///
  /// In en, this message translates to:
  /// **'Ambient baseline matters—calibrate when moving to new spaces.'**
  String get tip21;

  /// No description provided for @tip22.
  ///
  /// In en, this message translates to:
  /// **'Quiet wins add up—1 point per minute keeps it simple.'**
  String get tip22;

  /// No description provided for @tip23.
  ///
  /// In en, this message translates to:
  /// **'Confetti celebrates progress—small celebrations reinforce habits.'**
  String get tip23;

  /// No description provided for @tip24.
  ///
  /// In en, this message translates to:
  /// **'Try mornings if evenings are noisy—best time differs for everyone.'**
  String get tip24;

  /// No description provided for @tip25.
  ///
  /// In en, this message translates to:
  /// **'Fine‑tune the decibel threshold for your room’s character.'**
  String get tip25;

  /// No description provided for @tip26.
  ///
  /// In en, this message translates to:
  /// **'Use the moving average to smooth out noisy days.'**
  String get tip26;

  /// No description provided for @tip27.
  ///
  /// In en, this message translates to:
  /// **'Let Weekly Insights remind you of your progress rhythm.'**
  String get tip27;

  /// No description provided for @tip28.
  ///
  /// In en, this message translates to:
  /// **'Finish what you start—short sessions reduce friction to begin.'**
  String get tip28;

  /// No description provided for @tip29.
  ///
  /// In en, this message translates to:
  /// **'Silence is a skill—practice makes patterns, patterns make progress.'**
  String get tip29;

  /// No description provided for @tip30.
  ///
  /// In en, this message translates to:
  /// **'You’re one tap away—start a tiny session now.'**
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

  /// No description provided for @tipInstructionCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Settings → Advanced → Noise Calibration.'**
  String get tipInstructionCalibrate;

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

  /// No description provided for @tipInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show tip'**
  String get tipInfoTooltip;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'ja', 'pt'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
