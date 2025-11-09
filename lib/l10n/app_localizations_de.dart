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
  String get microphonePermissionMessage => 'Focus Field misst Umgebungsgeräuschpegel, um Ihnen zu helfen, ruhige Umgebungen aufrechtzuerhalten.\n\nDie App benötigt Mikrofonzugriff zur Stillerkennung, nimmt jedoch kein Audio auf.';

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
  String get splashTagline => 'Stille messen, Fokus aufbauen';

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
  String get upgradeRequired => 'Upgrade erforderlich';

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
  String get notificationPreview => 'Benachrichtigungsvorschau';

  @override
  String get dailySilenceReminderTitle => 'Tägliche Fokus-Erinnerung';

  @override
  String get weeklyProgressReportTitle => 'Wochenfortschritt 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Erfolg freigeschaltet! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session fertig! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session beendet';

  @override
  String get reminderStartJourney => '🎯 Starte heute deine Fokus-Reise! Baue deine Gewohnheit für tiefe Arbeit auf.';

  @override
  String get reminderRestart => '🌱 Bereit, deine Fokus-Praxis neu zu starten? Jeder Moment ist ein neuer Anfang.';

  @override
  String get reminderDayTwo => '⭐ Tag 2 deiner Fokus-Serie! Beständigkeit baut Konzentration.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak-Tage Serie! Du baust eine starke Fokus-Gewohnheit auf.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Beeindruckende $streak-Tage Serie! Deine Hingabe inspiriert.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Unglaubliche $streak-Tage Serie! Du bist ein Fokus-Champion!';
  }

  @override
  String get achievementFirstSession => '🎉 Erste Session geschafft! Willkommen bei Focus Field!';

  @override
  String get achievementWeekStreak => '🌟 7-Tage Serie erreicht! Konsistenz ist deine Superkraft!';

  @override
  String get achievementMonthStreak => '🏆 30-Tage Serie freigeschaltet! Unaufhaltsam!';

  @override
  String get achievementPerfectSession => '✨ Perfekte Session! 100% ruhige Umgebung gehalten!';

  @override
  String get achievementLongSession => '⏰ Lange Session gemeistert! Dein Fokus wächst.';

  @override
  String get achievementGeneric => '🎊 Erfolg freigeschaltet! Weiter so!';

  @override
  String get weeklyProgressNone => '💭 Starte dein Wochenziel! Bereit für eine fokussierte Session?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count Fokus-Minuten diese Woche! Jede Session zählt.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count Fokus-Minuten erreicht! Du bist auf Kurs!';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 $count Fokus-Minuten geschafft! Perfekte Woche!';
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
  String get tip01 => 'Klein anfangen—schon 2 Minuten bauen Ihre Fokusgewohnheit auf.';

  @override
  String get tip02 => 'Ihre Serie hat Gnade—ein Fehler bricht sie nicht mit der 2-Tage-Regel.';

  @override
  String get tip03 => 'Probieren Sie Lern-, Lese- oder Meditationsaktivitäten aus, um Ihrem Fokusstil zu entsprechen.';

  @override
  String get tip04 => 'Überprüfen Sie Ihre 12-Wochen-Heatmap, um zu sehen, wie sich kleine Erfolge im Laufe der Zeit summieren.';

  @override
  String get tip05 => 'Beobachten Sie Ihren Live-Ruhe-%-Wert während der Sitzungen—höhere Werte bedeuten besseren Fokus!';

  @override
  String get tip06 => 'Passen Sie Ihr Tagesziel (10-60 Min.) an Ihren Rhythmus an.';

  @override
  String get tip07 => 'Nutzen Sie Ihren monatlichen Freeze-Token, um Ihre Serie an schwierigen Tagen zu schützen.';

  @override
  String get tip08 => 'Nach 3 Siegen schlägt Focus Field einen strengeren Schwellenwert vor—bereit für das nächste Level?';

  @override
  String get tip09 => 'Hoher Umgebungslärm? Erhöhen Sie Ihren Schwellenwert, um in der Zone zu bleiben.';

  @override
  String get tip10 => 'Intelligente tägliche Erinnerungen lernen Ihre beste Zeit—lassen Sie sich führen.';

  @override
  String get tip11 => 'Der Fortschrittsring ist berührbar—ein Tippen startet Ihre Fokussitzung.';

  @override
  String get tip12 => 'Rekalibrieren Sie, wenn sich Ihre Umgebung ändert, für bessere Genauigkeit.';

  @override
  String get tip13 => 'Sitzungsbenachrichtigungen feiern Ihre Erfolge—aktivieren Sie sie für Motivation!';

  @override
  String get tip14 => 'Beständigkeit schlägt Perfektion—erscheinen Sie, auch an geschäftigen Tagen.';

  @override
  String get tip15 => 'Probieren Sie verschiedene Tageszeiten aus, um Ihren ruhigen Sweet Spot zu entdecken.';

  @override
  String get tip16 => 'Ihr täglicher Fortschritt ist immer sichtbar—tippen Sie auf Los, um jederzeit zu starten.';

  @override
  String get tip17 => 'Jede Aktivität zählt separat zu Ihrem Ziel—Vielfalt hält es frisch.';

  @override
  String get tip18 => 'Exportieren Sie Ihre Daten (Premium), um Ihre vollständige Fokusreise zu sehen.';

  @override
  String get tip19 => 'Konfetti feiert jeden Abschluss—kleine Erfolge verdienen Anerkennung!';

  @override
  String get tip20 => 'Ihre Baseline ist wichtig—kalibrieren Sie beim Umzug in neue Räume.';

  @override
  String get tip21 => 'Ihre 7-Tage-Trends zeigen Muster—überprüfen Sie sie wöchentlich für Einblicke.';

  @override
  String get tip22 => 'Verlängern Sie die Sitzungsdauer (Premium) für längere Tiefenfokusblöcke.';

  @override
  String get tip23 => 'Fokus ist eine Übung—kleine Sitzungen bauen die gewünschte Gewohnheit auf.';

  @override
  String get tip24 => 'Die Wöchentliche Zusammenfassung zeigt Ihren Rhythmus—stimmen Sie sie auf Ihren Zeitplan ab.';

  @override
  String get tip25 => 'Feinabstimmung Ihres Schwellenwerts für Ihren Raum—jeder Raum ist anders.';

  @override
  String get tip26 => 'Barrierefreiheitsoptionen helfen allen beim Fokussieren—hoher Kontrast, großer Text, Vibration.';

  @override
  String get tip27 => 'Die Heute-Zeitleiste zeigt, wann Sie fokussiert waren—finden Sie Ihre produktiven Stunden.';

  @override
  String get tip28 => 'Beenden Sie, was Sie begonnen haben—kürzere Sitzungen bedeuten mehr Abschlüsse.';

  @override
  String get tip29 => 'Ruhige Minuten summieren sich zu Ihrem Ziel—Fortschritt über Perfektion.';

  @override
  String get tip30 => 'Sie sind nur einen Tipp entfernt—starten Sie jetzt eine kleine Sitzung.';

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
  String get tipInstructionHeatmap => 'Zusammenfassung-Tab → Mehr anzeigen → Heatmap';

  @override
  String get tipInstructionTodayTimeline => 'Zusammenfassung-Tab → Mehr anzeigen → Heute-Zeitleiste';

  @override
  String get tipInstruction7DayTrends => 'Zusammenfassung-Tab → Mehr anzeigen → 7-Tage-Trends';

  @override
  String get tipInstructionEditActivities => 'Aktivität-Tab → Bearbeiten antippen, um Aktivitäten anzuzeigen/zu verbergen';

  @override
  String get tipInstructionQuestGo => 'Aktivität-Tab → Quest-Kapsel → Los antippen';

  @override
  String get tipInfoTooltip => 'Tipp anzeigen';

  @override
  String get questCapsuleTitle => 'Ambient Quest';

  @override
  String get questCapsuleLoading => 'Ruhige Minuten werden geladen…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Ruhe $progress/$goal Min • Serie $streak';
  }

  @override
  String get questFreezeButton => 'Einfrieren';

  @override
  String get questFrozenToday => 'Heute eingefroren — du bist geschützt.';

  @override
  String get questGoButton => 'Los';

  @override
  String calmPercent(int percent) {
    return 'Ruhe $percent%';
  }

  @override
  String get calmLabel => 'Ruhe';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String get freeze => 'einfrieren';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3 Siege! $threshold dB versuchen?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Nicht jetzt';

  @override
  String get adaptiveThresholdTryIt => 'Probieren';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Schwellenwert auf $threshold dB gesetzt';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get start => 'Start';

  @override
  String get error => 'Fehler';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get faqTitle => 'Häufig gestellte Fragen';

  @override
  String get faqSearchHint => 'FAQs durchsuchen...';

  @override
  String get faqNoResults => 'Keine Ergebnisse gefunden';

  @override
  String get faqNoResultsSubtitle => 'Versuchen Sie einen anderen Suchbegriff';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ergebnisse gefunden',
      one: '1 Ergebnis gefunden',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => 'Was ist Focus Field und wie hilft es mir beim Fokussieren?';

  @override
  String get faqA01 => 'Focus Field hilft Ihnen, bessere Fokusgewohnheiten zu entwickeln, indem es Umgebungsgeräusche in Ihrer Umgebung überwacht. Wenn Sie eine Sitzung starten (Lernen, Lesen, Meditation oder Sonstiges), misst die App, wie ruhig Ihre Umgebung ist. Je ruhiger Sie es halten, desto mehr \"Fokusminuten\" verdienen Sie. Dies ermutigt Sie, ablenkungsfreie Räume für tiefe Arbeit zu finden und aufrechtzuerhalten.';

  @override
  String get faqQ02 => 'Wie misst Focus Field meinen Fokus?';

  @override
  String get faqA02 => 'Focus Field überwacht den Umgebungsgeräuschpegel in Ihrer Umgebung während Ihrer Sitzung. Es berechnet einen \"Umgebungswert\", indem es verfolgt, wie viele Sekunden Ihre Umgebung unter Ihrem gewählten Geräuschschwellenwert bleibt. Wenn Ihre Sitzung mindestens 70% Ruhezeit hat (Umgebungswert ≥70%), erhalten Sie vollen Kredit für diese ruhigen Minuten.';

  @override
  String get faqQ03 => 'Zeichnet Focus Field mein Audio oder Gespräche auf?';

  @override
  String get faqA03 => 'Nein, absolut nicht. Focus Field misst nur Dezibel (Lautstärke) - es zeichnet, speichert oder überträgt niemals Audio. Ihre Privatsphäre ist vollständig geschützt. Die App überprüft einfach, ob Ihre Umgebung über oder unter Ihrem gewählten Schwellenwert liegt.';

  @override
  String get faqQ04 => 'Welche Aktivitäten kann ich mit Focus Field verfolgen?';

  @override
  String get faqA04 => 'Focus Field kommt mit vier Aktivitätstypen: Lernen 📚 (für Lernen und Forschung), Lesen 📖 (für fokussiertes Lesen), Meditation 🧘 (für Achtsamkeitspraxis) und Sonstiges ⭐ (für jede Aktivität, die Fokus erfordert). Alle Aktivitäten verwenden Umgebungsgeräuschüberwachung, um Ihnen zu helfen, eine ruhige, fokussierte Umgebung aufrechtzuerhalten.';

  @override
  String get faqQ05 => 'Sollte ich Focus Field für alle meine Aktivitäten verwenden?';

  @override
  String get faqA05 => 'Focus Field funktioniert am besten für Aktivitäten, bei denen Umgebungsgeräusche Ihren Fokusgrad anzeigen. Aktivitäten wie Lernen, Lesen und Meditation profitieren am meisten von ruhigen Umgebungen. Obwohl Sie \"Sonstige\" Aktivitäten verfolgen können, empfehlen wir, Focus Field hauptsächlich für geräuschempfindliche Fokusarbeit zu verwenden.';

  @override
  String get faqQ06 => 'Wie starte ich eine Fokussitzung?';

  @override
  String get faqA06 => 'Gehen Sie zur Registerkarte Sitzungen, wählen Sie Ihre Aktivität (Lernen, Lesen, Meditation oder Sonstiges), wählen Sie Ihre Sitzungsdauer (1, 5, 10, 15, 30 Minuten oder Premium-Optionen), tippen Sie auf die Schaltfläche Start am Fortschrittsring und halten Sie Ihre Umgebung ruhig!';

  @override
  String get faqQ07 => 'Welche Sitzungsdauern sind verfügbar?';

  @override
  String get faqA07 => 'Kostenlose Benutzer können wählen: 1, 5, 10, 15 oder 30-Minuten-Sitzungen. Premium-Benutzer erhalten auch: 1 Stunde, 1,5 Stunden und 2-Stunden-Sitzungen für längere Tiefarbeitsphasen.';

  @override
  String get faqQ08 => 'Kann ich eine Sitzung pausieren oder vorzeitig beenden?';

  @override
  String get faqA08 => 'Ja! Während einer Sitzung sehen Sie Pause- und Stopp-Schaltflächen über dem Fortschrittsring. Um versehentliche Berührungen zu vermeiden, müssen Sie diese Schaltflächen lange drücken. Wenn Sie vorzeitig stoppen, verdienen Sie immer noch Punkte für die ruhigen Minuten, die Sie gesammelt haben.';

  @override
  String get faqQ09 => 'Wie verdiene ich Punkte in Focus Field?';

  @override
  String get faqA09 => 'Sie verdienen 1 Punkt pro ruhige Minute. Während Ihrer Sitzung verfolgt Focus Field, wie viele Sekunden Ihre Umgebung unter dem Geräuschschwellenwert bleibt. Am Ende werden diese ruhigen Sekunden in Minuten umgewandelt. Wenn Sie beispielsweise eine 10-Minuten-Sitzung mit 8 Minuten Ruhezeit abschließen, verdienen Sie 8 Punkte.';

  @override
  String get faqQ10 => 'Was ist der 70%-Schwellenwert und warum ist er wichtig?';

  @override
  String get faqA10 => 'Der 70%-Schwellenwert bestimmt, ob Ihre Sitzung zu Ihrem täglichen Ziel zählt. Wenn Ihr Umgebungswert (Ruhezeit ÷ Gesamtzeit) mindestens 70% beträgt, qualifiziert sich Ihre Sitzung für Quest-Kredit. Selbst wenn Sie unter 70% liegen, verdienen Sie immer noch Punkte für jede ruhige Minute!';

  @override
  String get faqQ11 => 'Was ist der Unterschied zwischen Umgebungswert und Punkten?';

  @override
  String get faqA11 => 'Der Umgebungswert ist Ihre Sitzungsqualität als Prozentsatz (ruhige Sekunden ÷ Gesamtsekunden), die bestimmt, ob Sie den 70%-Schwellenwert erreichen. Punkte sind die tatsächlich verdienten ruhigen Minuten (1 Punkt = 1 Minute). Umgebungswert = Qualität, Punkte = Leistung.';

  @override
  String get faqQ12 => 'Wie funktionieren Serien in Focus Field?';

  @override
  String get faqA12 => 'Serien verfolgen aufeinanderfolgende Tage, an denen Sie Ihr tägliches Ziel erreichen. Focus Field verwendet eine mitfühlende 2-Tage-Regel: Ihre Serie bricht nur, wenn Sie zwei aufeinanderfolgende Tage verpassen. Das bedeutet, dass Sie einen Tag verpassen können und Ihre Serie weitergeht, wenn Sie Ihr Ziel am nächsten Tag erreichen.';

  @override
  String get faqQ13 => 'Was sind Freeze-Token und wie verwende ich sie?';

  @override
  String get faqA13 => 'Freeze-Token schützen Ihre Serie, wenn Sie Ihr Ziel nicht erreichen können. Sie erhalten 1 kostenloses Freeze-Token pro Monat. Bei Verwendung zeigt Ihr Gesamtfortschritt 100% (Ziel geschützt), Ihre Serie ist sicher und die individuelle Aktivitätsverfolgung wird normal fortgesetzt. Verwenden Sie es weise für arbeitsreiche Tage!';

  @override
  String get faqQ14 => 'Kann ich mein tägliches Fokusziel anpassen?';

  @override
  String get faqA14 => 'Ja! Tippen Sie auf Bearbeiten auf der Sitzungskarte in der Registerkarte Heute. Sie können Ihr globales tägliches Ziel festlegen (10-60 Minuten kostenlos, bis zu 1080 Minuten Premium), Ziele pro Aktivität für separate Ziele aktivieren und bestimmte Aktivitäten anzeigen/ausblenden.';

  @override
  String get faqQ15 => 'Was ist der Geräuschschwellenwert und wie passe ich ihn an?';

  @override
  String get faqA15 => 'Der Schwellenwert ist der maximale Geräuschpegel (in Dezibel), der als \"ruhig\" zählt. Standard ist 40 dB (Bibliotheksruhe). Sie können ihn in der Registerkarte Sitzungen anpassen: 30 dB (sehr ruhig), 40 dB (Bibliotheksruhe - empfohlen), 50 dB (mäßiges Büro), 60-80 dB (lautere Umgebungen).';

  @override
  String get faqQ16 => 'Was ist der Adaptive Schwellenwert und sollte ich ihn verwenden?';

  @override
  String get faqA16 => 'Nach 3 aufeinanderfolgenden erfolgreichen Sitzungen bei Ihrem aktuellen Schwellenwert schlägt Focus Field vor, ihn um 2 dB zu erhöhen, um Sie herauszufordern. Dies hilft Ihnen, sich schrittweise zu verbessern. Sie können den Vorschlag annehmen oder ablehnen - er erscheint nur einmal alle 7 Tage.';

  @override
  String get faqQ17 => 'Was ist der Fokusmodus?';

  @override
  String get faqA17 => 'Der Fokusmodus ist eine ablenkungsfreie Vollbildüberlagerung während Ihrer Sitzung. Er zeigt Ihren Countdown-Timer, Live-Ruheprozentsatz und minimale Steuerelemente (Pause/Stopp über langes Drücken). Er entfernt alle anderen UI-Elemente, damit Sie sich vollständig konzentrieren können. Aktivieren Sie ihn in Einstellungen > Basis > Fokusmodus.';

  @override
  String get faqQ18 => 'Warum benötigt Focus Field Mikrofon-Berechtigung?';

  @override
  String get faqA18 => 'Focus Field verwendet das Mikrofon Ihres Geräts, um Umgebungsgeräuschpegel (Dezibel) während der Sitzungen zu messen. Dies ist wichtig, um Ihren Umgebungswert zu berechnen. Denken Sie daran: Es wird niemals Audio aufgezeichnet - nur Geräuschpegel werden in Echtzeit gemessen.';

  @override
  String get faqQ19 => 'Kann ich meine Fokusmuster im Laufe der Zeit sehen?';

  @override
  String get faqA19 => 'Ja! Die Registerkarte Heute zeigt Ihren täglichen Fortschritt, wöchentliche Trends, 12-Wochen-Aktivitätsheatmap (wie GitHub-Beiträge) und Sitzungszeitlinie. Premium-Benutzer erhalten erweiterte Analysen mit Leistungsmetriken, gleitenden Durchschnitten und KI-gestützten Erkenntnissen.';

  @override
  String get faqQ20 => 'Wie funktionieren Benachrichtigungen in Focus Field?';

  @override
  String get faqA20 => 'Focus Field hat intelligente Erinnerungen: Tägliche Erinnerungen (lernt Ihre bevorzugte Fokuszeit oder verwendet eine feste Zeit), Benachrichtigungen über abgeschlossene Sitzungen mit Ergebnissen, Leistungsbenachrichtigungen für Meilensteine und wöchentliche Zusammenfassung (Premium). Aktivieren/Anpassen in Einstellungen > Erweitert > Benachrichtigungen.';

  @override
  String get microphoneSettingsTitle => 'Einstellungen Erforderlich';

  @override
  String get microphoneSettingsMessage => 'Um die Stillerkennung zu aktivieren, erteilen Sie manuell die Mikrofonberechtigung:\n\n• iOS: Einstellungen > Datenschutz & Sicherheit > Mikrofon > Focus Field\n• Android: Einstellungen > Apps > Focus Field > Berechtigungen > Mikrofon';

  @override
  String get buttonGrantPermission => 'Berechtigung Erteilen';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => 'Einstellungen Öffnen';

  @override
  String get onboardingBack => 'Zurück';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingGetStarted => 'Loslegen';

  @override
  String get onboardingWelcomeSnackbar => 'Willkommen! Bereit für deine erste Sitzung? 🚀';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei\nFocus Field! 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'Ihre Reise zu besserem Fokus beginnt hier!\nLassen Sie uns Gewohnheiten aufbauen, die bleiben 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Verfolgen Sie Ihren Fokus';

  @override
  String get onboardingFeatureTrackDesc => 'Sehen Sie Ihren Fortschritt in Echtzeit, während Sie Ihre Fokus-Superkraft aufbauen! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Verdiene Belohnungen';

  @override
  String get onboardingFeatureRewardsDesc => 'Jede ruhige Minute zählt! Sammle Punkte und feiere deine Erfolge 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Baue Streaks Auf';

  @override
  String get onboardingFeatureStreaksDesc => 'Halte den Schwung aufrecht! Unser mitfühlendes System hält dich motiviert 🔥';

  @override
  String get onboardingEnvironmentTitle => 'Wo ist Ihre Fokuszone? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'Wähle deine typische Umgebung, damit wir deinen Raum optimieren können!';

  @override
  String get onboardingEnvQuietHomeTitle => 'Ruhiges Zuhause';

  @override
  String get onboardingEnvQuietHomeDesc => 'Schlafzimmer, ruhiges Heimbüro';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Sehr ruhig';

  @override
  String get onboardingEnvOfficeTitle => 'Typisches Büro';

  @override
  String get onboardingEnvOfficeDesc => 'Standardbüro, Bibliothek';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Bibliotheksruhe (Empfohlen)';

  @override
  String get onboardingEnvBusyTitle => 'Belebter Raum';

  @override
  String get onboardingEnvBusyDesc => 'Café, gemeinsamer Arbeitsbereich';

  @override
  String get onboardingEnvBusyDb => '50 dB - Moderater Lärm';

  @override
  String get onboardingEnvNoisyTitle => 'Laute Umgebung';

  @override
  String get onboardingEnvNoisyDesc => 'Großraumbüro, öffentlicher Raum';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Höherer Lärm';

  @override
  String get onboardingEnvAdjustNote => 'Du kannst dies jederzeit in den Einstellungen anpassen';

  @override
  String get onboardingGoalTitle => 'Setze Dein Tagesziel! 🎯';

  @override
  String get onboardingGoalSubtitle => 'Wie viel Fokuszeit fühlt sich richtig für dich an?\n(Du kannst dies jederzeit anpassen!)';

  @override
  String get onboardingGoalStartingTitle => 'Erste Schritte';

  @override
  String get onboardingGoalStartingDuration => '10-15 Minuten';

  @override
  String get onboardingGoalHabitTitle => 'Gewohnheit Aufbauen';

  @override
  String get onboardingGoalHabitDuration => '20-30 Minuten';

  @override
  String get onboardingGoalPracticeTitle => 'Regelmäßige Praxis';

  @override
  String get onboardingGoalPracticeDuration => '40-60 Minuten';

  @override
  String get onboardingGoalDeepWorkTitle => 'Tiefes Arbeiten';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ Minuten';

  @override
  String get onboardingGoalAdvice1 => 'Perfekter Start! 🌟 Kleine Schritte führen zu großen Erfolgen. Du schaffst das!';

  @override
  String get onboardingGoalAdvice2 => 'Exzellente Wahl! 🎯 Dieser Sweet Spot baut dauerhafte Gewohnheiten auf!';

  @override
  String get onboardingGoalAdvice3 => 'Ehrgeizig! 💪 Du bist bereit, dein Fokusspiel auf die nächste Stufe zu heben!';

  @override
  String get onboardingGoalAdvice4 => 'Wow! 🏆 Tiefarbeitsmodus aktiviert! Denk an Pausen!';

  @override
  String get onboardingActivitiesTitle => 'Wähle Deine Aktivitäten! ✨';

  @override
  String get onboardingActivitiesSubtitle => 'Wähle alle, die zu dir passen!\n(Du kannst später immer mehr hinzufügen)';

  @override
  String get onboardingActivityStudyTitle => 'Studium';

  @override
  String get onboardingActivityStudyDesc => 'Lernen, Kursarbeit, Forschung';

  @override
  String get onboardingActivityReadingTitle => 'Lesen';

  @override
  String get onboardingActivityReadingDesc => 'Tiefes Lesen, Artikel, Bücher';

  @override
  String get onboardingActivityMeditationTitle => 'Meditation';

  @override
  String get onboardingActivityMeditationDesc => 'Achtsamkeit, Atemübungen';

  @override
  String get onboardingActivityOtherTitle => 'Andere';

  @override
  String get onboardingActivityOtherDesc => 'Jede fokusfordernde Aktivität';

  @override
  String get onboardingActivitiesTip => 'Profi-Tipp: Focus Field glänzt, wenn Stille = Fokus! 🤫✨';

  @override
  String get onboardingPermissionTitle => 'Deine Privatsphäre Zählt! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'Wir benötigen Mikrofonzugriff, um Umgebungslärm zu messen und dir beim Fokussieren zu helfen';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'Keine Aufnahme';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'Wir messen nur Lärmpegel, nehmen niemals Audio auf';

  @override
  String get onboardingPrivacyLocalTitle => 'Nur Lokal';

  @override
  String get onboardingPrivacyLocalDesc => 'Alle Daten bleiben auf deinem Gerät';

  @override
  String get onboardingPrivacyFirstTitle => 'Privatsphäre Zuerst';

  @override
  String get onboardingPrivacyFirstDesc => 'Deine Gespräche sind völlig privat';

  @override
  String get onboardingPermissionNote => 'Du kannst die Berechtigung beim Start deiner ersten Sitzung auf dem nächsten Bildschirm erteilen';

  @override
  String get onboardingTipsTitle => 'Profi-Tipps für Erfolg! 💡';

  @override
  String get onboardingTipsSubtitle => 'Diese helfen dir, das Beste aus Focus Field herauszuholen!';

  @override
  String get onboardingTip1Title => 'Klein Anfangen, Groß Gewinnen! 🌱';

  @override
  String get onboardingTip1Desc => 'Beginne mit 5-10-Minuten-Sitzungen. Konstanz schlägt Perfektion!';

  @override
  String get onboardingTip2Title => 'Aktiviere Fokusmodus! 🎯';

  @override
  String get onboardingTip2Desc => 'Tippe auf Fokusmodus für immersives, ablenkungsfreies Erlebnis.';

  @override
  String get onboardingTip3Title => 'Freeze-Token = Sicherheitsnetz! ❄️';

  @override
  String get onboardingTip3Desc => 'Nutze dein monatliches Token an geschäftigen Tagen, um deinen Streak zu schützen.';

  @override
  String get onboardingTip4Title => 'Die 70%-Regel Rockt! 📈';

  @override
  String get onboardingTip4Desc => 'Ziele auf 70% ruhige Zeit - perfekte Stille nicht erforderlich!';

  @override
  String get onboardingReadyTitle => 'Du Bist Startbereit! 🚀';

  @override
  String get onboardingReadyDesc => 'Lass uns deine erste Sitzung starten und großartige Gewohnheiten aufbauen!';

  @override
  String get questMotivation1 => 'Erfolg endet nie und Misserfolg ist nie endgültig';

  @override
  String get questMotivation2 => 'Fortschritt über Perfektion - jede Minute zählt';

  @override
  String get questMotivation3 => 'Kleine tägliche Schritte führen zu großen Veränderungen';

  @override
  String get questMotivation4 => 'Du baust bessere Gewohnheiten auf, eine Sitzung nach der anderen';

  @override
  String get questMotivation5 => 'Beständigkeit schlägt Intensität';

  @override
  String get questMotivation6 => 'Jede Sitzung ist ein Gewinn, egal wie kurz';

  @override
  String get questMotivation7 => 'Fokus ist ein Muskel - du wirst stärker';

  @override
  String get questMotivation8 => 'Die Reise von tausend Meilen beginnt mit einem einzigen Schritt';

  @override
  String get questGo => 'Los';

  @override
  String get questTapStart => 'Tippe auf Start →';

  @override
  String get todayDashboardTitle => 'Dein Fokus-Dashboard';

  @override
  String get todayFocusMinutes => 'Fokusminuten heute';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Ziel: $goalMinutes Min • Ruhe ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Wähle deinen Modus';

  @override
  String get todayDefaultActivities => 'Studium • Lesen • Meditation';

  @override
  String get todayTooltipTips => 'Tipps';

  @override
  String get todayTooltipTheme => 'Thema';

  @override
  String get todayTooltipSettings => 'Einstellungen';

  @override
  String todayThemeChanged(String themeName) {
    return 'Thema geändert zu $themeName';
  }

  @override
  String get todayTabToday => 'Heute';

  @override
  String get todayTabSessions => 'Sitzungen';

  @override
  String get todayHelperText => 'Stelle deine Dauer ein und verfolge deine Zeit. Sitzungsverlauf und Analysen erscheinen in der Zusammenfassung.';

  @override
  String get statPoints => 'Punkte';

  @override
  String get statStreak => 'Serie';

  @override
  String get statSessions => 'Sitzungen';

  @override
  String get ringProgressTitle => 'Ring-Fortschritt';

  @override
  String get ringOverall => 'Gesamt';

  @override
  String get ringOverallFrozen => 'Gesamt ❄️';

  @override
  String get sessionCalm => 'Ruhe';

  @override
  String get sessionStart => 'Start';

  @override
  String get sessionStop => 'Stopp';

  @override
  String get buttonEdit => 'Bearbeiten';

  @override
  String get durationUpTo1Hour => 'Sitzungen bis zu 1 Stunde';

  @override
  String get durationUpTo1_5Hours => 'Sitzungen bis zu 1,5 Stunden';

  @override
  String get durationUpTo2Hours => 'Sitzungen bis zu 2 Stunden';

  @override
  String get durationExtended => 'Erweiterte Sitzungsdauern';

  @override
  String get durationExtendedAccess => 'Zugang zu erweiterten Sitzungen';

  @override
  String get noiseRoomLoudness => 'Raumlautstärke';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Schwelle: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Schwelle auf $db dB gesetzt';
  }

  @override
  String get noiseHighDetected => 'Hoher Lärmpegel erkannt, bitte gehen Sie in einen ruhigeren Raum für bessere Konzentration';

  @override
  String get noiseThresholdExceededHint => 'Finden Sie einen ruhigeren Raum oder erhöhen Sie den Schwellenwert →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'Ruhigeren Raum finden oder auf ${db}dB erhöhen?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'Hohe Lautstärke erkannt. Auf ${db}dB erhöhen?';
  }

  @override
  String get noiseAtMaxThreshold => 'Bereits am maximalen Schwellenwert. Bitte finden Sie einen ruhigeren Raum.';

  @override
  String get noiseThresholdYes => 'Ja';

  @override
  String get noiseThresholdNo => 'Nein';

  @override
  String get trendsInsights => 'Einblicke';

  @override
  String get trendsLast7Days => 'Letzte 7 Tage';

  @override
  String get trendsShareWeeklySummary => 'Wochenzusammenfassung teilen';

  @override
  String get trendsLoading => 'Laden...';

  @override
  String get trendsLoadingMetrics => 'Metriken laden...';

  @override
  String get trendsNoData => 'Keine Daten';

  @override
  String get trendsWeeklyTotal => 'Wöchentliche Summe';

  @override
  String get trendsBestDay => 'Bester Tag';

  @override
  String get trendsActivityHeatmap => 'Aktivitäts-Heatmap';

  @override
  String get trendsRecentActivity => 'Letzte Aktivität';

  @override
  String get trendsHeatmapError => 'Heatmap kann nicht geladen werden';

  @override
  String get dayMon => 'Mo';

  @override
  String get dayTue => 'Di';

  @override
  String get dayWed => 'Mi';

  @override
  String get dayThu => 'Do';

  @override
  String get dayFri => 'Fr';

  @override
  String get daySat => 'Sa';

  @override
  String get daySun => 'So';

  @override
  String get focusModeComplete => 'Sitzung Abgeschlossen!';

  @override
  String get focusModeGreatSession => 'Großartige Fokussitzung';

  @override
  String get focusModeResume => 'Fortsetzen';

  @override
  String get focusModePause => 'Pause';

  @override
  String get focusModeLongPressHint => 'Lange drücken zum Pausieren oder Stoppen';

  @override
  String get activityEditTitle => 'Aktivitäten bearbeiten';

  @override
  String get activityRecommendation => 'Empfohlen: 10+ Min. pro Aktivität für konsistenten Gewohnheitsaufbau';

  @override
  String get activityDailyGoals => 'Tägliche Ziele';

  @override
  String activityTotalHours(String hours) {
    return 'Gesamt: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Pro Aktivität';

  @override
  String get activityExceedsLimit => 'Gesamt überschreitet das 18-Stunden-Tageslimit. Bitte Ziele reduzieren.';

  @override
  String get activityGoalLabel => 'Ziel';

  @override
  String get activityGoalDescription => 'Setze dein tägliches Fokusziel (1 Min - 18h)';

  @override
  String get shareYourProgress => 'Teile deinen Fortschritt';

  @override
  String get shareTimeRange => 'Zeitbereich';

  @override
  String get shareCardSize => 'Kartengröße';

  @override
  String get analyticsPerformanceMetrics => 'Leistungsmetriken';

  @override
  String get analyticsPreferredDuration => 'Bevorzugte Dauer';

  @override
  String get analyticsUnavailable => 'Analyse nicht verfügbar';

  @override
  String get analyticsRestoreAttempt => 'Wir werden versuchen, diesen Abschnitt beim nächsten App-Start wiederherzustellen.';

  @override
  String get audioUnavailable => 'Audio vorübergehend nicht verfügbar';

  @override
  String get audioRecovering => 'Audioverarbeitung hat ein Problem festgestellt. Automatische Wiederherstellung...';

  @override
  String get shareQuietMinutes => 'RUHIGE MINUTEN';

  @override
  String get shareTopActivity => 'Top-Aktivität';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Vorschau';

  @override
  String get sharePinchToZoom => 'Zum Zoomen kneifen';

  @override
  String get shareGenerating => 'Wird generiert...';

  @override
  String get shareButton => 'Teilen';

  @override
  String get shareTodayLabel => 'Heute';

  @override
  String get shareWeeklyLabel => 'Wöchentlich';

  @override
  String get shareTodayTitle => 'Dein heutiger Fokus';

  @override
  String get shareWeeklyTitle => 'Dein wöchentlicher Fokus';

  @override
  String get shareSubject => 'Mein Focus Field Fortschritt';

  @override
  String get shareFormatSquare => '1:1 Verhältnis • Universelle Kompatibilität';

  @override
  String get shareFormatPost => '4:5 Verhältnis • Instagram/Twitter-Beiträge';

  @override
  String get shareFormatStory => '9:16 Verhältnis • Instagram Stories';

  @override
  String get recapWeeklyTitle => 'Wöchentliche Zusammenfassung';

  @override
  String get recapMinutes => 'Minuten';

  @override
  String recapStreak(int start, int end) {
    return 'Serie: $start → $end Tage';
  }

  @override
  String get recapTopActivity => 'Top-Aktivität: ';

  @override
  String get practiceOverviewTitle => 'Praxis-Übersicht';

  @override
  String get practiceLast7Days => 'Letzte 7 Tage';

  @override
  String get audioMultipleErrors => 'Mehrere Audiofehler erkannt. Komponente wird wiederhergestellt...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Aktuelles Ziel: $goal';
  }

  @override
  String get activitySaveChanges => 'Änderungen Speichern';

  @override
  String get insightsTitle => 'Einblicke';

  @override
  String get insightsTooltip => 'Detaillierte Einblicke anzeigen';

  @override
  String get statDays => 'TAGE';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Gesamt Heute $done/$goal min, wähle eine beliebige Aktivität';
  }

  @override
  String get premiumFeature => 'Premium-Funktion';

  @override
  String get premiumFeatureAccess => 'Premium-Funktionszugriff';

  @override
  String get activityUnknown => 'Unbekannt';

  @override
  String get insightsFirstSessionTitle => 'Vervollständige deine erste Sitzung';

  @override
  String get insightsFirstSessionSubtitle => 'Beginne, deine Fokuszeit, Sitzungsmuster und Umgebungsgeräusch-Trends zu verfolgen';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Umgebung: $percent%';
  }

  @override
  String get sessionSuccess => 'Erfolg';

  @override
  String get sessionFailed => 'Fehlgeschlagen';

  @override
  String get focusModeButton => 'Fokusmodus';

  @override
  String get settingsDailyGoalsTitle => 'Tagesziele';

  @override
  String get settingsFocusModeDescription => 'Minimieren Sie Ablenkungen während Sitzungen mit einer fokussierten Überlagerung';

  @override
  String get settingsDeepFocusTitle => 'Tiefer Fokus';

  @override
  String get settingsDeepFocusDescription => 'Sitzung beenden, wenn die App verlassen wird';

  @override
  String get deepFocusDialogTitle => 'Tiefer Fokus';

  @override
  String get deepFocusEnableLabel => 'Tiefen Fokus aktivieren';

  @override
  String get deepFocusGracePeriodLabel => 'Schonfrist (Sekunden)';

  @override
  String get deepFocusExplanation => 'Wenn aktiviert, wird das Verlassen der App die Sitzung nach der Schonfrist beenden.';

  @override
  String get notificationPermissionTitle => 'Benachrichtigungen aktivieren';

  @override
  String get notificationPermissionExplanation => 'Focus Field benötigt Benachrichtigungsberechtigung, um Ihnen zu senden:';

  @override
  String get notificationBenefitReminders => 'Tägliche Fokus-Erinnerungen';

  @override
  String get notificationBenefitCompletion => 'Benachrichtigungen über abgeschlossene Sitzungen';

  @override
  String get notificationBenefitAchievements => 'Erfolgsfeiern';

  @override
  String get notificationHowToEnableIos => 'So aktivieren Sie auf iOS:';

  @override
  String get notificationHowToEnableAndroid => 'So aktivieren Sie auf Android:';

  @override
  String get notificationStepsIos => '1. Tippen Sie unten auf \"Einstellungen öffnen\"\n2. Tippen Sie auf \"Mitteilungen\"\n3. Aktivieren Sie \"Mitteilungen erlauben\"';

  @override
  String get notificationStepsAndroid => '1. Tippen Sie unten auf \"Einstellungen öffnen\"\n2. Tippen Sie auf \"Benachrichtigungen\"\n3. Aktivieren Sie \"Alle Focus Field-Benachrichtigungen\"';

  @override
  String get aboutShowTips => 'Tipps anzeigen';

  @override
  String get aboutShowTipsDescription => 'Zeigt hilfreiche Tipps beim App-Start und über das Glühbirnensymbol. Tipps erscheinen alle 2-3 Tage.';

  @override
  String get aboutReplayOnboarding => 'Einführung wiederholen';

  @override
  String get aboutReplayOnboardingDescription => 'Überprüfen Sie die App-Tour und richten Sie Ihre Einstellungen erneut ein';

  @override
  String get buttonFaq => 'FAQ';

  @override
  String get onboardingWelcomeMessage => 'Willkommen! Bereit für Ihre erste Sitzung? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Belohnungen verdienen';

  @override
  String get onboardingFeatureEarnDesc => 'Jede ruhige Minute zählt! Sammeln Sie Punkte und feiern Sie Ihre Erfolge 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Serien aufbauen';

  @override
  String get onboardingFeatureBuildDesc => 'Halten Sie die Dynamik aufrecht! Unser mitfühlendes System hält Sie motiviert 🔥';

  @override
  String get onboardingEnvironmentDescription => 'Wählen Sie Ihre typische Umgebung, damit wir sie für Ihren Raum optimieren können!';

  @override
  String get onboardingEnvQuietHome => 'Ruhiges Zuhause';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Sehr ruhig';

  @override
  String get onboardingEnvOffice => 'Typisches Büro';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Bibliotheksruhe (Empfohlen)';

  @override
  String get onboardingEnvBusy => 'Belebter Raum';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Mäßiger Lärm';

  @override
  String get onboardingEnvNoisy => 'Laute Umgebung';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Höherer Lärm';

  @override
  String get onboardingAdjustAnytime => 'Sie können dies jederzeit in den Einstellungen anpassen';

  @override
  String starterSessionTip(int starterMinutes, int goalMinutes) {
    return '👋 Beginne mit einer $starterMinutes-minütigen Sitzung, um dir den Einstieg zu erleichtern. Dein vollständiges $goalMinutes-Minuten-Ziel ist bereit, wenn du es bist!';
  }

  @override
  String get buttonGotIt => 'Verstanden';

  @override
  String get buttonGetStarted => 'Loslegen';

  @override
  String get buttonNext => 'Weiter';

  @override
  String get errorActivityRequired => '⚠️ Mindestens eine Aktivität muss aktiviert sein';

  @override
  String get errorGoalExceeds => 'Gesamtziele überschreiten das tägliche 18-Stunden-Limit. Bitte reduzieren Sie die Ziele.';

  @override
  String get messageSaved => 'Einstellungen gespeichert';

  @override
  String get errorPermissionRequired => 'Berechtigung erforderlich';

  @override
  String get notificationEnableReason => 'Aktivieren Sie Benachrichtigungen, um Erinnerungen zu erhalten und Erfolge zu feiern.';

  @override
  String get buttonEnableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get buttonRequesting => 'Wird angefordert...';

  @override
  String get notificationDailyTime => 'Tägliche Zeit';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Tägliche Erinnerung um $time';
  }

  @override
  String get notificationLearning => 'lernen';

  @override
  String notificationSmart(String time) {
    return 'Intelligent ($time)';
  }

  @override
  String get buttonUseSmart => 'Intelligent verwenden';

  @override
  String get notificationSmartExplanation => 'Wählen Sie eine feste Zeit oder lassen Sie Focus Field Ihr Muster lernen.';

  @override
  String get notificationSessionComplete => 'Sitzung abgeschlossen';

  @override
  String get notificationSessionCompleteDesc => 'Abgeschlossene Sitzungen feiern';

  @override
  String get notificationAchievement => 'Erfolg freigeschaltet';

  @override
  String get notificationAchievementDesc => 'Meilenstein-Benachrichtigungen';

  @override
  String get notificationWeekly => 'Wöchentliche Fortschrittszusammenfassung';

  @override
  String get notificationWeeklyDesc => 'Wöchentliche Einblicke (Wochentag und Uhrzeit)';

  @override
  String get notificationWeeklyTime => 'Wöchentliche Zeit';

  @override
  String get notificationMilestone => 'Meilenstein-Benachrichtigungen';

  @override
  String get notificationWeeklyInsights => 'Wöchentliche Einblicke (Wochentag & Uhrzeit)';

  @override
  String get notificationDailyReminder => 'Tägliche Erinnerung';

  @override
  String get notificationComplete => 'Sitzung abgeschlossen';

  @override
  String get settingsSnackbar => 'Bitte aktivieren Sie Benachrichtigungen in den Geräteeinstellungen';

  @override
  String get shareCardTitle => 'Karte teilen';

  @override
  String get shareYourWeek => 'Teile deine Woche';

  @override
  String get shareStyleGradient => 'Farbverlauf-Stil';

  @override
  String get shareStyleGradientDesc => 'Mutiger Farbverlauf mit großen Zahlen';

  @override
  String get shareWeeklySummary => 'Wochenzusammenfassung';

  @override
  String get shareStyleAchievement => 'Erfolgs-Stil';

  @override
  String get shareStyleAchievementDesc => 'Fokus auf Gesamtzahl der ruhigen Minuten';

  @override
  String get shareQuietMinutesWeek => 'Ruhige Minuten diese Woche';

  @override
  String get shareAchievementMessage => 'Tieferen Fokus aufbauen,\\neine Sitzung nach der anderen';

  @override
  String get shareAchievementCard => 'Erfolgs-Karte';

  @override
  String get shareTextOnly => 'Nur Text';

  @override
  String get shareTextOnlyDesc => 'Als reiner Text teilen (kein Bild)';

  @override
  String get shareYourStreak => 'Teile deine Serie';

  @override
  String get shareAsCard => 'Als Karte teilen';

  @override
  String get shareAsCardDesc => 'Schöne visuelle Karte';

  @override
  String get shareStreakCard => 'Serien-Karte';

  @override
  String get shareAsText => 'Als Text teilen';

  @override
  String get shareAsTextDesc => 'Einfache Textnachricht';

  @override
  String get shareErrorFailed => 'Freigabe fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get buttonShare => 'Teilen';

  @override
  String get initializingApp => 'App wird initialisiert...';

  @override
  String initializationFailed(String error) {
    return 'Initialisierung fehlgeschlagen: $error';
  }

  @override
  String get loadingSettings => 'Einstellungen werden geladen...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Laden der Einstellungen fehlgeschlagen: $error';
  }

  @override
  String get loadingUserData => 'Benutzerdaten werden geladen...';

  @override
  String dataLoadingFailed(String error) {
    return 'Laden der Daten fehlgeschlagen: $error';
  }

  @override
  String get loading => 'Laden...';

  @override
  String get taglineSilence => '🤫 Meistere die Kunst der Stille';

  @override
  String get errorOops => 'Hoppla! Etwas ist schief gelaufen';

  @override
  String get buttonRetry => 'Erneut versuchen';

  @override
  String get resetAppData => 'App-Daten zurücksetzen';

  @override
  String get resetAppDataMessage => 'Dies setzt alle App-Daten und Einstellungen auf ihre Standardwerte zurück. Diese Aktion kann nicht rückgängig gemacht werden.\\n\\nMöchten Sie fortfahren?';

  @override
  String get buttonReset => 'Zurücksetzen';

  @override
  String get messageDataReset => 'App-Daten wurden zurückgesetzt';

  @override
  String errorResetFailed(String error) {
    return 'Fehler beim Zurücksetzen der Daten: $error';
  }

  @override
  String get analyticsTitle => 'Analytik';

  @override
  String get analyticsOverview => 'Übersicht';

  @override
  String get analyticsPoints => 'Punkte';

  @override
  String get analyticsStreak => 'Serie';

  @override
  String get analyticsSessions => 'Sitzungen';

  @override
  String get analyticsLast7Days => 'Letzte 7 Tage';

  @override
  String get analyticsPerformanceHighlights => 'Leistungs-Highlights';

  @override
  String get analyticsSuccessRate => 'Erfolgsquote';

  @override
  String get analyticsAvgSession => 'Durchschn. Sitzung';

  @override
  String get analyticsBestStreak => 'Beste Serie';

  @override
  String get analyticsActivityProgress => 'Aktivitätsfortschritt';

  @override
  String get analyticsComingSoon => 'Detaillierte Aktivitätsverfolgung kommt bald.';

  @override
  String get analyticsAdvancedMetrics => 'Erweiterte Metriken';

  @override
  String get analyticsPremiumContent => 'Premium erweiterte Analytik-Inhalte hier...';

  @override
  String get analytics30DayTrends => '30-Tage-Trends';

  @override
  String get analyticsTrendsChart => 'Premium-Trenddiagramm hier...';

  @override
  String get analyticsAIInsights => 'KI-Einblicke';

  @override
  String get analyticsAIComingSoon => 'KI-gestützte Einblicke kommen bald...';

  @override
  String get analyticsUnlock => 'Erweiterte Analytik freischalten';

  @override
  String get errorTitle => 'Fehler';

  @override
  String get errorQuestUnavailable => 'Quest-Status nicht verfügbar';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Freeze-Token konnte nicht verwendet werden';

  @override
  String get buttonUseFreeze => 'Freeze verwenden';

  @override
  String get onboardingDailyGoalTitle => 'Setze dein Tagesziel! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'Wie viel Fokuszeit fühlt sich für dich richtig an?\\n(Du kannst dies jederzeit anpassen!)';

  @override
  String get onboardingGoalGettingStarted => 'Erste Schritte';

  @override
  String get onboardingGoalBuildingHabit => 'Gewohnheit aufbauen';

  @override
  String get onboardingGoalRegularPractice => 'Regelmäßige Praxis';

  @override
  String get onboardingGoalDeepWork => 'Tiefenarbeit';

  @override
  String get onboardingProTip => 'Profi-Tipp: Focus Field glänzt, wenn Ruhe = Fokus! 🤫✨';

  @override
  String get onboardingPrivacyTitle => 'Deine Privatsphäre zählt! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'Wir benötigen Mikrofon-Zugriff, um Umgebungsgeräusche zu messen und dir zu helfen, dich besser zu konzentrieren';

  @override
  String get onboardingPrivacyNoRecording => 'Keine Aufnahme';

  @override
  String get onboardingPrivacyLocalOnly => 'Nur lokal';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'Alle Daten bleiben auf deinem Gerät';

  @override
  String get onboardingPrivacyFirst => 'Datenschutz zuerst';

  @override
  String get onboardingPrivacyNote => 'Du kannst die Berechtigung auf dem nächsten Bildschirm erteilen, wenn du deine erste Sitzung startest';

  @override
  String get insightsFocusTime => 'Fokuszeit';

  @override
  String get insightsSessions => 'Sitzungen';

  @override
  String get insightsAverage => 'Durchschnitt';

  @override
  String get insightsAmbientScore => 'Ambient-Score';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeOceanBlue => 'Ozeanblau';

  @override
  String get themeForestGreen => 'Waldgrün';

  @override
  String get themePurpleNight => 'Lila Nacht';

  @override
  String get themeGold => 'Gold';

  @override
  String get themeSolarSunrise => 'Solar-Sonnenaufgang';

  @override
  String get themeCyberNeon => 'Cyber-Neon';

  @override
  String get themeLuxury => 'Luxury';

  @override
  String get settingsAppTheme => 'App-Theme';

  @override
  String get freezeTokenNoTokensTitle => 'Keine Einfriertoken';

  @override
  String get freezeTokenNoTokensMessage => 'Sie haben keine Einfriertoken verfügbar. Sie verdienen 1 Token pro Woche (max. 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Ziel Bereits Erreicht';

  @override
  String get freezeTokenGoalCompleteMessage => 'Ihr Tagesziel ist bereits erreicht! Einfriertoken können nur verwendet werden, wenn Sie Ihr Ziel noch nicht erreicht haben.';

  @override
  String get freezeTokenUseTitle => 'Einfriertoken Verwenden';

  @override
  String get freezeTokenUseMessage => 'Einfriertoken schützen Ihre Serie, wenn Sie einen Tag verpassen. Die Verwendung eines Tokens zählt als Erfüllung Ihres Tagesziels.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'Sie haben $count Token. Jetzt einen verwenden?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ Einfriertoken verwendet! Ziel als erreicht markiert.';

  @override
  String get trendsErrorLoading => 'Fehler beim Laden der Daten';

  @override
  String get trendsPoints => 'Punkte';

  @override
  String get trendsStreak => 'Serie';

  @override
  String get trendsSessions => 'Sitzungen';

  @override
  String get trendsTopActivity => 'Top-Aktivität';

  @override
  String get sectionToday => 'Heute';

  @override
  String get sectionSessions => 'Sitzungen';

  @override
  String get sectionInsights => 'Einblicke';

  @override
  String get onboardingGoalAdviceGettingStarted => 'Perfekter Start! 🌟 Kleine Schritte führen zu großen Erfolgen. Du schaffst das!';

  @override
  String get onboardingGoalAdviceBuildingHabit => 'Ausgezeichnete Wahl! 🎯 Dieser Sweet Spot baut dauerhafte Gewohnheiten auf!';

  @override
  String get onboardingGoalAdviceRegularPractice => 'Ehrgeizig! 💪 Du bist bereit, dein Fokus-Spiel zu verbessern!';

  @override
  String get onboardingGoalAdviceDeepWork => 'Wow! 🏆 Deep-Work-Modus aktiviert! Denk an Pausen!';

  @override
  String get onboardingDuration10to15 => '10-15 Minuten';

  @override
  String get onboardingDuration20to30 => '20-30 Minuten';

  @override
  String get onboardingDuration40to60 => '40-60 Minuten';

  @override
  String get onboardingDuration60plus => '60+ Minuten';

  @override
  String get activityStudy => 'Studium';

  @override
  String get activityReading => 'Lesen';

  @override
  String get activityMeditation => 'Meditation';

  @override
  String get activityOther => 'Andere';

  @override
  String get onboardingTip1Description => 'Beginnen Sie mit 5-10 Minuten Sitzungen. Beständigkeit schlägt Perfektion!';

  @override
  String get onboardingTip2Description => 'Tippen Sie auf Fokus-Modus für ein immersives, ablenkungsfreies Erlebnis.';

  @override
  String get onboardingTip3Description => 'Verwenden Sie Ihren monatlichen Token an geschäftigen Tagen, um Ihre Serie zu schützen.';

  @override
  String get onboardingTip4Description => 'Streben Sie 70% ruhige Zeit an - perfekte Stille nicht erforderlich!';

  @override
  String get onboardingLaunchTitle => 'Sie Sind Bereit zu Starten! 🚀';

  @override
  String get onboardingLaunchDescription => 'Lassen Sie uns Ihre erste Sitzung beginnen und großartige Gewohnheiten aufbauen!';

  @override
  String get insightsBestTimeByActivity => 'Beste Zeit nach Aktivität';

  @override
  String get insightHighSuccessRateTitle => 'Hohe Erfolgsquote';

  @override
  String get insightEnvironmentStabilityTitle => 'Umweltstabilität';

  @override
  String get insightLowNoiseSuccessTitle => 'Lärmarmer Erfolg';

  @override
  String get insightConsistentPracticeTitle => 'Konsequente Praxis';

  @override
  String get insightStreakProtectionTitle => 'Streifenschutz verfügbar';

  @override
  String get insightRoomTooNoisyTitle => 'Zimmer zu laut';

  @override
  String get insightIrregularScheduleTitle => 'Unregelmäßiger Zeitplan';

  @override
  String get insightLowAmbientScoreTitle => 'Niedriger Umgebungswert';

  @override
  String get insightNoRecentSessionsTitle => 'Keine letzten Sitzungen';

  @override
  String get insightHighSuccessRateDesc => 'Sie halten starke Schweigesitzungen aufrecht.';

  @override
  String get insightEnvironmentStabilityDesc => 'Die Umgebungsgeräusche liegen in einem moderaten, überschaubaren Bereich.';

  @override
  String get insightLowNoiseSuccessDesc => 'Während der Sitzungen ist Ihre Umgebung außergewöhnlich ruhig.';

  @override
  String get insightConsistentPracticeDesc => 'Sie entwickeln eine zuverlässige tägliche Übungsgewohnheit.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'Sie haben $count Freeze-Token, um Ihren Streak zu schützen.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Versuchen Sie, einen ruhigeren Ort zu finden oder Ihre Schwelle anzupassen.';

  @override
  String get insightIrregularScheduleDesc => 'Konsistentere Sitzungszeiten können Ihren Streak verbessern.';

  @override
  String get insightLowAmbientScoreDesc => 'In den letzten Sitzungen war die Ruhezeit geringer. Versuchen Sie es mit einer ruhigeren Umgebung.';

  @override
  String get insightNoRecentSessionsDesc => 'Starten Sie noch heute eine Sitzung, um Ihre Konzentrationsgewohnheit zu entwickeln!';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return 'Tolle Arbeit! $minutes Fokusminuten in Ihrer Sitzung! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return 'Guter Einsatz! $minutes Minuten abgeschlossen.';
  }

  @override
  String get sessionCompleteFailed => 'Sitzung beendet. Versuchen Sie es erneut, wenn Sie bereit sind.';

  @override
  String get notificationSessionStarted => 'Die Sitzung hat begonnen – bleiben Sie konzentriert!';

  @override
  String get notificationSessionPaused => 'Sitzung pausiert';

  @override
  String get notificationSessionResumed => 'Die Sitzung wurde fortgesetzt';
}
