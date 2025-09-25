// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Fokus-Engine wird vorbereitet…';

  @override
  String get paywallTitle => 'Trainiere tiefere Fokussierung mit Premium';

  @override
  String get featureExtendSessions => 'Verlängere Sitzungen von 30 auf 120 Minuten';

  @override
  String get featureHistory => 'Greife auf 90 Tage Verlauf zu';

  @override
  String get featureMetrics => 'Schalte Leistungsmetriken und Trenddiagramme frei';

  @override
  String get featureExport => 'Exportiere Sitzungsdaten (CSV / PDF)';

  @override
  String get featureThemes => 'Nutze das komplette Themenpaket';

  @override
  String get featureThreshold => 'Feinabstimmung des Schwellenwerts mit Umgebungsbasis';

  @override
  String get featureSupport => 'Schnellerer Support & früher Zugriff';

  @override
  String get subscribeCta => 'Weiter';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get termsOfService => 'AGB';

  @override
  String get manageSubscription => 'Verwalten';

  @override
  String get legalDisclaimer => 'Automatisch verlängerndes Abo. Jederzeit im Store kündbar.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# Minuten Stille erreicht ✨',
      one: '# Minute stille erreicht ✨',
    );
    return 'Starke Leistung! $_temp0';
  }

  @override
  String get minutes => 'Minuten';

  @override
  String get minute => 'Minute';

  @override
  String get exportCsv => 'CSV exportieren';

  @override
  String get exportPdf => 'PDF exportieren';

  @override
  String get settings => 'Einstellungen';

  @override
  String get themes => 'Themen';

  @override
  String get analytics => 'Analytik';

  @override
  String get history => 'Verlauf';

  @override
  String get startSession => 'Sitzung starten';

  @override
  String get stopSession => 'Stopp';

  @override
  String get pauseSession => 'Pause';

  @override
  String get resumeSession => 'Fortsetzen';

  @override
  String get sessionSaved => 'Sitzung gespeichert';

  @override
  String get copied => 'Kopiert';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get permissionMicrophoneDenied => 'Mikrofonberechtigung verweigert';

  @override
  String get actionRetry => 'Erneut';

  @override
  String get listeningStatus => 'Hört zu...';

  @override
  String get successPointMessage => 'Stille erreicht! +1 Punkt';

  @override
  String get tooNoisyMessage => 'Zu laut! Versuche es erneut';

  @override
  String get totalPoints => 'Gesamtpunkte';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get welcomeMessage => 'Drücke Start, um zu beginnen';

  @override
  String get resetAllData => 'Alle Daten zurücksetzen';

  @override
  String get resetDataConfirmation => 'Fortschritt wirklich zurücksetzen?';

  @override
  String get resetDataSuccess => 'Daten zurückgesetzt';

  @override
  String get decibelThresholdLabel => 'Dezibel-Schwelle';

  @override
  String get decibelThresholdHint => 'Maximale Geräuschpegelgrenze festlegen (dB)';

  @override
  String get microphonePermissionTitle => 'Mikrofonberechtigung';

  @override
  String get microphonePermissionMessage => 'Focus Field benötigt Mikrofonzugriff zur Messung. Kein Audio wird gespeichert.';

  @override
  String get permissionDeniedMessage => 'Mikrofon erforderlich. In den Einstellungen aktivieren.';

  @override
  String get noiseMeterError => 'Mikrofon nicht verfügbar';

  @override
  String get premiumFeaturesTitle => 'Premium-Funktionen';

  @override
  String get premiumDescription => 'Schalte erweiterte Sitzungen, Analytik und Export frei';

  @override
  String get premiumRequiredMessage => 'Funktion nur für Premium';

  @override
  String get subscriptionSuccessMessage => 'Abo erfolgreich!';

  @override
  String get subscriptionErrorMessage => 'Abo fehlgeschlagen';

  @override
  String get restoreSuccessMessage => 'Käufe wiederhergestellt';

  @override
  String get restoreErrorMessage => 'Keine Käufe gefunden';

  @override
  String get yearlyPlanTitle => 'Jährlich';

  @override
  String get monthlyPlanTitle => 'Monatlich';

  @override
  String savePercent(String percent) {
    return 'SPARE $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Abgerechnet $price/Jahr';
  }

  @override
  String billedMonthly(String price) {
    return 'Abgerechnet $price/Monat';
  }

  @override
  String get mockSubscriptionsBanner => 'Mock-Abos aktiv';

  @override
  String get splashTagline => 'Finde deine Ruhe';

  @override
  String get appIconSemantic => 'App-Symbol';

  @override
  String get tabBasic => 'Basis';

  @override
  String get tabAdvanced => 'Erweitert';

  @override
  String get tabAbout => 'Info';

  @override
  String get resetAllSettings => 'Alle Einstellungen zurücksetzen';

  @override
  String get resetAllSettingsDescription => 'Dies setzt alle Einstellungen und Daten zurück. Nicht rückgängig.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get allSettingsReset => 'Alle Einstellungen und Daten wurden zurückgesetzt';

  @override
  String get decibelThresholdMaxNoise => 'Dezibel-Schwelle (max. Lärm)';

  @override
  String get highThresholdWarningText => 'Hoher Schwellenwert kann relevante Geräusche ignorieren.';

  @override
  String get decibelThresholdTooltip => 'Typisch ruhige Räume: 30–40 dB. Kalibrieren; nur erhöhen falls Brummen zählt.';

  @override
  String get sessionDuration => 'Sitzungsdauer';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Upgrade für ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Frei: bis $minutes Min';
  }

  @override
  String get durationLabel => 'Dauer';

  @override
  String get minutesShort => 'Min';

  @override
  String get noiseCalibration => 'Lärmkallibrierung';

  @override
  String get calibrateBaseline => 'Basis kalibrieren';

  @override
  String get unlockAdvancedCalibration => 'Erweiterte Kalibrierung freischalten';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get sessionHistory => 'Sitzungsverlauf';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get remindersCelebrations => 'Erinnerungen & Feiern';

  @override
  String get accessibility => 'Barrierefreiheit';

  @override
  String get accessibilityFeatures => 'Barrierefreiheitsfunktionen';

  @override
  String get appInformation => 'App-Information';

  @override
  String get version => 'Version';

  @override
  String get bundleId => 'Bundle-ID';

  @override
  String get environment => 'Umgebung';

  @override
  String get helpSupport => 'Hilfe & Support';

  @override
  String get faq => 'FAQ';

  @override
  String get support => 'Support';

  @override
  String get rateApp => 'Bewerten';

  @override
  String errorLoadingSettings(String error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String get exportNoData => 'Keine Daten zum Export';

  @override
  String chooseExportFormat(int sessions) {
    return 'Format für $sessions Sitzungen wählen:';
  }

  @override
  String get csvSpreadsheet => 'CSV Tabelle';

  @override
  String get rawDataForAnalysis => 'Rohdaten für Analyse';

  @override
  String get pdfReport => 'PDF Bericht';

  @override
  String get formattedReportWithCharts => 'Bericht mit Diagrammen';

  @override
  String generatingExport(String format) {
    return 'Erzeuge $format Export...';
  }

  @override
  String exportCompleted(String format) {
    return '$format Export fertig';
  }

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get frequentlyAskedQuestions => 'Häufige Fragen';

  @override
  String get faqHowWorksQ => 'Wie funktioniert Focus Field?';

  @override
  String get faqHowWorksA => 'Misst Umgebungsgeräusch – Zeit unter Schwelle bringt Punkte.';

  @override
  String get faqAudioRecordedQ => 'Wird Audio aufgenommen?';

  @override
  String get faqAudioRecordedA => 'Nein. Nur Dezibelwerte; kein Audio gespeichert.';

  @override
  String get faqAdjustSensitivityQ => 'Empfindlichkeit anpassen?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Einstellungen > Basis > Dezibel-Schwelle ($min–$max dB) und zuerst kalibrieren.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Premium-Funktionen?';

  @override
  String get faqPremiumFeaturesA => 'Verl. Sitzungen (bis 120m), Analytik, Export, Themes.';

  @override
  String get faqNotificationsQ => 'Benachrichtigungen?';

  @override
  String get faqNotificationsA => 'Intelligente Erinnerungen lernen Gewohnheiten und feiern Meilensteine.';

  @override
  String get close => 'Schließen';

  @override
  String get supportTitle => 'Support';

  @override
  String responseTimeLabel(String time) {
    return 'Reaktionszeit: $time';
  }

  @override
  String get docs => 'Doks';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get emailOpenDescription => 'Öffnet Mail-App mit Systeminfo vorausgefüllt';

  @override
  String get subject => 'Betreff';

  @override
  String get briefDescription => 'Kurze Beschreibung';

  @override
  String get description => 'Beschreibung';

  @override
  String get issueDescriptionHint => 'Details zum Problem...';

  @override
  String get openingEmail => 'E-Mail wird geöffnet...';

  @override
  String get openEmailApp => 'Mail-App öffnen';

  @override
  String get fillSubjectDescription => 'Betreff und Beschreibung ausfüllen';

  @override
  String get emailOpened => 'Mail-App geöffnet. Senden wenn bereit.';

  @override
  String get noEmailAppFound => 'Keine Mail-App gefunden. Kontakt:';

  @override
  String standardSubject(String subject) {
    return 'Betreff: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Problem: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'FAQ konnte nicht geöffnet werden: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Dokumentation Fehler: $error';
  }

  @override
  String get accessibilitySettings => 'Barrierefreiheits-Einstellungen';

  @override
  String get vibrationFeedback => 'Vibration';

  @override
  String get vibrateOnSessionEvents => 'Bei Ereignissen vibrieren';

  @override
  String get voiceAnnouncements => 'Sprachansagen';

  @override
  String get announceSessionProgress => 'Fortschritt ansagen';

  @override
  String get highContrastMode => 'Hoher Kontrast';

  @override
  String get improveVisualAccessibility => 'Visuelle Zugänglichkeit verbessern';

  @override
  String get largeText => 'Großer Text';

  @override
  String get increaseTextSize => 'Text vergrößern';

  @override
  String get save => 'Speichern';

  @override
  String get accessibilitySettingsSaved => 'Barrierefreiheits-Einstellungen gespeichert';

  @override
  String get noiseFloorCalibration => 'Grundrauschkalibrierung';

  @override
  String get measuringAmbientNoise => 'Umgebungsgeräusch messen (≈5s)...';

  @override
  String get couldNotReadMic => 'Mikrofon konnte nicht gelesen werden';

  @override
  String get calibrationFailed => 'Kalibrierung fehlgeschlagen';

  @override
  String get retry => 'Erneut';

  @override
  String previousThreshold(double value) {
    return 'Vorher: $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'Neuer Schwellenwert: $value dB';
  }

  @override
  String get noSignificantChange => 'Kein signifikanter Unterschied';

  @override
  String get highAmbientDetected => 'Hohe Umgebung erkannt';

  @override
  String get adjustAnytimeSettings => 'Jederzeit in Einstellungen anpassen';

  @override
  String get toggleThemeTooltip => 'Theme wechseln';

  @override
  String get audioChartRecovering => 'Audio-Chart erholt sich...';

  @override
  String themeChanged(String themeName) {
    return 'Theme: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Sitzung starten';

  @override
  String get stopSessionButton => 'Stopp';

  @override
  String get statusListening => 'Hört zu...';

  @override
  String get statusSuccess => 'Stille erreicht! +1 Punkt';

  @override
  String get statusFailure => 'Zu laut!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get upgradeRequired => 'Upgrade Required';

  @override
  String get exportCsvSpreadsheet => 'CSV Tabelle';

  @override
  String get exportPdfReport => 'PDF Bericht';

  @override
  String get formattedReportCharts => 'Bericht mit Diagrammen';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Theme';

  @override
  String get open => 'Öffnen';

  @override
  String get microphone => 'Mikrofon';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get format => 'Format';

  @override
  String get successRate => 'Erfolgsrate';

  @override
  String get avgSession => 'Ø Sitzung';

  @override
  String get consistency => 'Konsistenz';

  @override
  String get bestTime => 'Beste Zeit';

  @override
  String get weeklyTrends => 'Wöchentliche Trends';

  @override
  String get performanceMetrics => 'Leistungsmetriken';

  @override
  String get advancedAnalytics => 'Erweiterte Analytik';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get bucket1to2 => '1-2 Min';

  @override
  String get bucket3to5 => '3-5 Min';

  @override
  String get bucket6to10 => '6-10 Min';

  @override
  String get bucket11to20 => '11-20 Min';

  @override
  String get bucket21to30 => '21-30 Min';

  @override
  String get bucket30plus => '30+ Min';

  @override
  String get sessionHistoryTitle => 'Sitzungsverlauf';

  @override
  String get recentSessionHistory => 'Letzte Sitzungen';

  @override
  String get achievementFirstStepTitle => 'Erster Schritt';

  @override
  String get achievementFirstStepDesc => 'Erste Sitzung abgeschlossen';

  @override
  String get achievementOnFireTitle => 'In Serie';

  @override
  String get achievementOnFireDesc => '3-Tage Serie';

  @override
  String get achievementWeekWarriorTitle => 'Wochen-Kämpfer';

  @override
  String get achievementWeekWarriorDesc => '7-Tage Serie';

  @override
  String get achievementDecadeTitle => 'Dekade';

  @override
  String get achievementDecadeDesc => '10 Punkte Meilenstein';

  @override
  String get achievementHalfCenturyTitle => 'Halbes Jahrhundert';

  @override
  String get achievementHalfCenturyDesc => '50 Punkte Meilenstein';

  @override
  String get achievementLockedPrompt => 'Sitzungen abschließen zum Freischalten';

  @override
  String get ratingPromptTitle => 'Gefällt dir Focus Field?';

  @override
  String get ratingPromptBody => 'Eine kurze 5-Sterne-Bewertung hilft anderen, mehr Ruhe zu finden.';

  @override
  String get ratingPromptRateNow => 'Jetzt bewerten';

  @override
  String get ratingPromptLater => 'Später';

  @override
  String get ratingPromptNoThanks => 'Nein danke';

  @override
  String get ratingThankYou => 'Danke für deine Unterstützung!';

  @override
  String get notificationSettingsTitle => 'Benachrichtigungseinstellungen';

  @override
  String get notificationPermissionRequired => 'Berechtigung erforderlich';

  @override
  String get notificationPermissionRationale => 'Aktiviere Benachrichtigungen für sanfte Erinnerungen und Erfolge.';

  @override
  String get requesting => 'Anfrage...';

  @override
  String get enableNotificationsCta => 'Benachrichtigungen aktivieren';

  @override
  String get enableNotificationsTitle => 'Benachrichtigungen aktivieren';

  @override
  String get enableNotificationsSubtitle => 'Erlaube Focus Field Benachrichtigungen zu senden';

  @override
  String get dailyReminderTitle => 'Intelligente Tageserinnerung';

  @override
  String get dailyReminderSubtitle => 'Intelligent oder feste Zeit';

  @override
  String get dailyTimeLabel => 'Tägliche Zeit';

  @override
  String get dailyTimeHint => 'Feste Zeit wählen oder Muster automatisch lernen lassen.';

  @override
  String get useSmartCta => 'Smart nutzen';

  @override
  String get sessionCompletedTitle => 'Session abgeschlossen';

  @override
  String get sessionCompletedSubtitle => 'Abgeschlossene Sessions feiern';

  @override
  String get achievementUnlockedTitle => 'Erfolg freigeschaltet';

  @override
  String get achievementUnlockedSubtitle => 'Meilenstein-Benachrichtigungen';

  @override
  String get weeklySummaryTitle => 'Wöchentliche Zusammenfassung';

  @override
  String get weeklySummarySubtitle => 'Wöchentliche Einblicke (Wochentag & Zeit)';

  @override
  String get weeklyTimeLabel => 'Wöchentliche Zeit';

  @override
  String get notificationPreview => 'Vorschau';

  @override
  String get dailySilenceReminderTitle => 'Tägliche Stille-Erinnerung';

  @override
  String get weeklyProgressReportTitle => 'Wochenfortschritt 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Erfolg freigeschaltet! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session fertig! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session beendet';

  @override
  String get reminderStartJourney => '🧘‍♂️ Starte heute deine Stille-Reise – finde innere Ruhe.';

  @override
  String get reminderRestart => '🌱 Neustart? Jeder Moment ist ein neuer Anfang.';

  @override
  String get reminderDayTwo => '⭐ Tag 2 deiner Serie! Beständigkeit baut Gelassenheit.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak-Tage Serie! Du baust eine starke Gewohnheit auf.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Beeindruckende $streak-Tage Serie! Deine Hingabe inspiriert.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Unglaubliche $streak-Tage Serie! Du bist ein Stille-Meister!';
  }

  @override
  String get achievementFirstSession => '🎉 Erste Session geschafft! Willkommen auf deiner Reise.';

  @override
  String get achievementWeekStreak => '🌟 7-Tage Serie erreicht! Konsistenz ist deine Superkraft!';

  @override
  String get achievementMonthStreak => '🏆 30-Tage Serie freigeschaltet! Unaufhaltsam!';

  @override
  String get achievementPerfectSession => '✨ Perfekte stille Session! Keine Störung deiner Ruhe.';

  @override
  String get achievementLongSession => '⏰ Lange Session gemeistert! Dein Fokus wächst.';

  @override
  String get achievementGeneric => '🎊 Erfolg freigeschaltet! Weiter so!';

  @override
  String get weeklyProgressNone => '💭 Diese Woche war ruhig im Kalender – bereit für eine stille Session?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count Sessions diese Woche. Jede Praxis vertieft deine Ruhe.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count Sessions – du findest deinen Rhythmus.';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 Perfekte Woche mit $count Sessions! Großartige Beständigkeit.';
  }

  @override
  String get tipsHidden => 'Tipps ausgeblendet';

  @override
  String get tipsShown => 'Tipps angezeigt';

  @override
  String get showTips => 'Tipps anzeigen';

  @override
  String get hideTips => 'Tipps ausblenden';

  @override
  String get tip01 => 'Short sessions count—start with 2–3 minutes to build consistency.';

  @override
  String get tip02 => 'Use Smart Daily Reminders to nudge you at your best time.';

  @override
  String get tip03 => 'Recalibrate when your environment changes for better accuracy.';

  @override
  String get tip04 => 'Check Weekly Trends to spot your momentum over time.';

  @override
  String get tip05 => 'Streaks grow with daily wins—show up, even for one minute.';

  @override
  String get tip06 => 'High ambient noise? Raise threshold a bit to reduce false fails.';

  @override
  String get tip07 => 'Try different times of day to find your quiet sweet spot.';

  @override
  String get tip08 => 'Session complete notifications keep motivation high—enable them!';

  @override
  String get tip09 => 'Prefer hands‑off? Auto reminders can schedule themselves (Smart).';

  @override
  String get tip10 => 'Use shorter sessions on busy days to keep your streak alive.';

  @override
  String get tip11 => 'The progress ring is tappable—start or stop with a single tap.';

  @override
  String get tip12 => 'Export your data (Premium) to share progress or back it up.';

  @override
  String get tip13 => 'Average session length helps you choose the right duration.';

  @override
  String get tip14 => 'Consistency beats intensity—small daily practice compounds.';

  @override
  String get tip15 => 'Set a gentle goal: 5 quiet minutes is a great baseline.';

  @override
  String get tip16 => 'The noise chart helps you see spikes—aim for calmer periods.';

  @override
  String get tip17 => 'Upgrade session duration (Premium) for longer focus blocks.';

  @override
  String get tip18 => 'High threshold warning guards accuracy—avoid setting it too high.';

  @override
  String get tip19 => 'Weekdays vary—tune your weekly summary to your schedule.';

  @override
  String get tip20 => 'Accessibility options: high contrast, large text, and vibration.';

  @override
  String get tip21 => 'Ambient baseline matters—calibrate when moving to new spaces.';

  @override
  String get tip22 => 'Quiet wins add up—1 point per minute keeps it simple.';

  @override
  String get tip23 => 'Confetti celebrates progress—small celebrations reinforce habits.';

  @override
  String get tip24 => 'Try mornings if evenings are noisy—best time differs for everyone.';

  @override
  String get tip25 => 'Fine‑tune the decibel threshold for your room’s character.';

  @override
  String get tip26 => 'Use the moving average to smooth out noisy days.';

  @override
  String get tip27 => 'Let Weekly Insights remind you of your progress rhythm.';

  @override
  String get tip28 => 'Finish what you start—short sessions reduce friction to begin.';

  @override
  String get tip29 => 'Silence is a skill—practice makes patterns, patterns make progress.';

  @override
  String get tip30 => 'You’re one tap away—start a tiny session now.';

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
  String get tipInfoTooltip => 'Tipp anzeigen';
}
