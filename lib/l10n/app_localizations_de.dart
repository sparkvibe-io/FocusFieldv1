// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Fokus-Engine wird vorbereitet…';

  @override
  String get paywallTitle => 'Trainiere tiefere Fokussierung mit Premium';

  @override
  String get featureExtendSessions => 'Verlängere Sitzungen von 5 auf 120 Minuten';

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
  String get microphonePermissionMessage => 'Silence Score benötigt Mikrofonzugriff zur Messung. Kein Audio wird gespeichert.';

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
  String get faqHowWorksQ => 'Wie funktioniert Silence Score?';

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
}
