// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Préparation du moteur de focus…';

  @override
  String get paywallTitle => 'Entraînez une concentration plus profonde avec Premium';

  @override
  String get featureExtendSessions => 'Étendez les sessions de 30 min à 120 min';

  @override
  String get featureHistory => 'Accédez à 90 jours d\'historique';

  @override
  String get featureMetrics => 'Débloquez métriques et graphiques de tendance';

  @override
  String get featureExport => 'Exportez vos données (CSV / PDF)';

  @override
  String get featureThemes => 'Utilisez tout le pack de thèmes';

  @override
  String get featureThreshold => 'Affinez le seuil avec la base ambiante';

  @override
  String get featureSupport => 'Support plus rapide et accès anticipé';

  @override
  String get subscribeCta => 'Continuer';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get privacyPolicy => 'Confidentialité';

  @override
  String get termsOfService => 'Conditions';

  @override
  String get manageSubscription => 'Gérer';

  @override
  String get legalDisclaimer => 'Abonnement à renouvellement automatique. Annulez à tout moment dans les réglages de la boutique.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutes de silence atteintes ✨',
      one: '# minute de silence atteinte ✨',
    );
    return 'Bravo ! $_temp0';
  }

  @override
  String get minutes => 'minutes';

  @override
  String get minute => 'minute';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get settings => 'Réglages';

  @override
  String get themes => 'Thèmes';

  @override
  String get analytics => 'Analytique';

  @override
  String get history => 'Historique';

  @override
  String get startSession => 'Démarrer';

  @override
  String get stopSession => 'Arrêter';

  @override
  String get pauseSession => 'Pause';

  @override
  String get resumeSession => 'Reprendre';

  @override
  String get sessionSaved => 'Session enregistrée';

  @override
  String get copied => 'Copié';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get permissionMicrophoneDenied => 'Permission micro refusée';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get listeningStatus => 'Écoute...';

  @override
  String get successPointMessage => 'Silence atteint ! +1 point';

  @override
  String get tooNoisyMessage => 'Trop de bruit ! Réessayez';

  @override
  String get totalPoints => 'Total de points';

  @override
  String get currentStreak => 'Série en cours';

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String get welcomeMessage => 'Appuyez sur Démarrer pour commencer';

  @override
  String get resetAllData => 'Réinitialiser toutes les données';

  @override
  String get resetDataConfirmation => 'Réinitialiser tout votre progrès ?';

  @override
  String get resetDataSuccess => 'Données réinitialisées';

  @override
  String get decibelThresholdLabel => 'Seuil de décibels';

  @override
  String get decibelThresholdHint => 'Définissez le niveau maximum de bruit (dB)';

  @override
  String get microphonePermissionTitle => 'Permission micro';

  @override
  String get microphonePermissionMessage => 'Focus Field nécessite l\'accès au micro pour mesurer le bruit. Aucun audio stocké.';

  @override
  String get permissionDeniedMessage => 'Le micro est requis. Activez‑le dans les réglages.';

  @override
  String get noiseMeterError => 'Accès micro impossible';

  @override
  String get premiumFeaturesTitle => 'Fonctionnalités Premium';

  @override
  String get premiumDescription => 'Débloquez sessions étendues, analytique et export';

  @override
  String get premiumRequiredMessage => 'Fonction réservée au Premium';

  @override
  String get subscriptionSuccessMessage => 'Abonnement réussi !';

  @override
  String get subscriptionErrorMessage => 'Échec de l\'abonnement';

  @override
  String get restoreSuccessMessage => 'Achats restaurés';

  @override
  String get restoreErrorMessage => 'Aucun achat trouvé';

  @override
  String get yearlyPlanTitle => 'Annuel';

  @override
  String get monthlyPlanTitle => 'Mensuel';

  @override
  String savePercent(String percent) {
    return 'ÉCONOMISEZ $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Facturé $price/an';
  }

  @override
  String billedMonthly(String price) {
    return 'Facturé $price/mois';
  }

  @override
  String get mockSubscriptionsBanner => 'Abonnements simulés';

  @override
  String get splashTagline => 'Trouvez votre calme';

  @override
  String get appIconSemantic => 'Icône de l\'app';

  @override
  String get tabBasic => 'Basique';

  @override
  String get tabAdvanced => 'Avancé';

  @override
  String get tabAbout => 'À propos';

  @override
  String get resetAllSettings => 'Réinitialiser tous les réglages';

  @override
  String get resetAllSettingsDescription => 'Cela réinitialisera tous les réglages et données. Irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get allSettingsReset => 'Tous les réglages et données ont été réinitialisés';

  @override
  String get decibelThresholdMaxNoise => 'Seuil décibels (bruit max)';

  @override
  String get highThresholdWarningText => 'Un seuil élevé peut ignorer des bruits pertinents.';

  @override
  String get decibelThresholdTooltip => 'Espaces calmes typiques : 30–40 dB. Calibrez; augmentez seulement si le bourdonnement compte comme bruit.';

  @override
  String get sessionDuration => 'Durée de session';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Passer pour ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Gratuit : jusqu\'à $minutes min';
  }

  @override
  String get durationLabel => 'Durée';

  @override
  String get minutesShort => 'min';

  @override
  String get noiseCalibration => 'Calibration du bruit';

  @override
  String get calibrateBaseline => 'Calibrer base';

  @override
  String get unlockAdvancedCalibration => 'Débloquez la calibration avancée';

  @override
  String get exportData => 'Exporter données';

  @override
  String get sessionHistory => 'Historique des sessions';

  @override
  String get notifications => 'Notifications';

  @override
  String get remindersCelebrations => 'Rappels & célébrations';

  @override
  String get accessibility => 'Accessibilité';

  @override
  String get accessibilityFeatures => 'Fonctions d\'accessibilité';

  @override
  String get appInformation => 'Infos application';

  @override
  String get version => 'Version';

  @override
  String get bundleId => 'Bundle ID';

  @override
  String get environment => 'Environnement';

  @override
  String get helpSupport => 'Aide & support';

  @override
  String get faq => 'FAQ';

  @override
  String get support => 'Support';

  @override
  String get rateApp => 'Noter';

  @override
  String errorLoadingSettings(String error) {
    return 'Erreur chargement réglages : $error';
  }

  @override
  String get exportNoData => 'Aucune donnée à exporter';

  @override
  String chooseExportFormat(int sessions) {
    return 'Choisissez le format pour vos $sessions sessions :';
  }

  @override
  String get csvSpreadsheet => 'Feuille CSV';

  @override
  String get rawDataForAnalysis => 'Données brutes pour analyse';

  @override
  String get pdfReport => 'Rapport PDF';

  @override
  String get formattedReportWithCharts => 'Rapport avec graphiques';

  @override
  String generatingExport(String format) {
    return 'Génération export $format...';
  }

  @override
  String exportCompleted(String format) {
    return 'Export $format terminé';
  }

  @override
  String exportFailed(String error) {
    return 'Échec export : $error';
  }

  @override
  String get frequentlyAskedQuestions => 'Questions fréquentes';

  @override
  String get faqHowWorksQ => 'Comment fonctionne Focus Field ?';

  @override
  String get faqHowWorksA => 'Mesure le bruit ambiant – le temps sous le seuil gagne des points.';

  @override
  String get faqAudioRecordedQ => 'L\'audio est-il enregistré ?';

  @override
  String get faqAudioRecordedA => 'Non. Seuls les niveaux de décibels sont échantillonnés; rien n\'est stocké.';

  @override
  String get faqAdjustSensitivityQ => 'Ajuster la sensibilité ?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Réglages > Basique > Seuil décibels ($min–$max dB) puis calibrez d\'abord.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Fonctionnalités Premium ?';

  @override
  String get faqPremiumFeaturesA => 'Sessions étendues (jusqu\'à 120m), analytique, export, thèmes.';

  @override
  String get faqNotificationsQ => 'Notifications ?';

  @override
  String get faqNotificationsA => 'Rappels intelligents apprennent vos habitudes et célèbrent les étapes.';

  @override
  String get close => 'Fermer';

  @override
  String get supportTitle => 'Support';

  @override
  String responseTimeLabel(String time) {
    return 'Délai de réponse : $time';
  }

  @override
  String get docs => 'Docs';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get emailOpenDescription => 'Ouvre votre mail avec infos système pré-remplies';

  @override
  String get subject => 'Sujet';

  @override
  String get briefDescription => 'Brève description';

  @override
  String get description => 'Description';

  @override
  String get issueDescriptionHint => 'Détaillez votre problème...';

  @override
  String get openingEmail => 'Ouverture du mail...';

  @override
  String get openEmailApp => 'Ouvrir l\'app mail';

  @override
  String get fillSubjectDescription => 'Renseignez sujet et description';

  @override
  String get emailOpened => 'Application mail ouverte. Envoyez quand prêt.';

  @override
  String get noEmailAppFound => 'Pas d\'app mail trouvée. Contact :';

  @override
  String standardSubject(String subject) {
    return 'Sujet: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Problème: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'Échec ouverture FAQ: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Échec ouverture docs: $error';
  }

  @override
  String get accessibilitySettings => 'Réglages d\'accessibilité';

  @override
  String get vibrationFeedback => 'Vibration';

  @override
  String get vibrateOnSessionEvents => 'Vibrer lors des événements';

  @override
  String get voiceAnnouncements => 'Annonces vocales';

  @override
  String get announceSessionProgress => 'Annoncer la progression';

  @override
  String get highContrastMode => 'Haut contraste';

  @override
  String get improveVisualAccessibility => 'Améliorer l\'accessibilité visuelle';

  @override
  String get largeText => 'Grand texte';

  @override
  String get increaseTextSize => 'Augmenter taille';

  @override
  String get save => 'Enregistrer';

  @override
  String get accessibilitySettingsSaved => 'Réglages d\'accessibilité enregistrés';

  @override
  String get noiseFloorCalibration => 'Calibration du bruit de base';

  @override
  String get measuringAmbientNoise => 'Mesure du bruit ambiant (≈5s)...';

  @override
  String get couldNotReadMic => 'Lecture micro impossible';

  @override
  String get calibrationFailed => 'Calibration échouée';

  @override
  String get retry => 'Réessayer';

  @override
  String previousThreshold(double value) {
    return 'Précédent : $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'Nouveau seuil : $value dB';
  }

  @override
  String get noSignificantChange => 'Pas de changement significatif';

  @override
  String get highAmbientDetected => 'Bruit ambiant élevé détecté';

  @override
  String get adjustAnytimeSettings => 'Ajustable dans Réglages';

  @override
  String get toggleThemeTooltip => 'Changer le thème';

  @override
  String get audioChartRecovering => 'Récupération du graphique audio...';

  @override
  String themeChanged(String themeName) {
    return 'Thème : $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Démarrer';

  @override
  String get stopSessionButton => 'Arrêter';

  @override
  String get statusListening => 'Écoute...';

  @override
  String get statusSuccess => 'Silence atteint ! +1 point';

  @override
  String get statusFailure => 'Trop de bruit !';

  @override
  String get upgrade => 'Améliorer';

  @override
  String get upgradeRequired => 'Mise à niveau requise';

  @override
  String get exportCsvSpreadsheet => 'Feuille CSV';

  @override
  String get exportPdfReport => 'Rapport PDF';

  @override
  String get formattedReportCharts => 'Rapport avec graphiques';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Thème';

  @override
  String get open => 'Ouvrir';

  @override
  String get microphone => 'Micro';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sessions';

  @override
  String get format => 'format';

  @override
  String get successRate => 'Taux de réussite';

  @override
  String get avgSession => 'Session moy.';

  @override
  String get consistency => 'Régularité';

  @override
  String get bestTime => 'Meilleur temps';

  @override
  String get weeklyTrends => 'Tendances hebdo';

  @override
  String get performanceMetrics => 'Métriques de performance';

  @override
  String get advancedAnalytics => 'Analytique avancée';

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
  String get sessionHistoryTitle => 'Historique de sessions';

  @override
  String get recentSessionHistory => 'Historique récent';

  @override
  String get achievementFirstStepTitle => 'Premier pas';

  @override
  String get achievementFirstStepDesc => 'Première session complétée';

  @override
  String get achievementOnFireTitle => 'En feu';

  @override
  String get achievementOnFireDesc => 'Série de 3 jours';

  @override
  String get achievementWeekWarriorTitle => 'Guerrier semaine';

  @override
  String get achievementWeekWarriorDesc => 'Série de 7 jours';

  @override
  String get achievementDecadeTitle => 'Décennie';

  @override
  String get achievementDecadeDesc => 'Étape 10 points';

  @override
  String get achievementHalfCenturyTitle => 'Demi-siècle';

  @override
  String get achievementHalfCenturyDesc => 'Étape 50 points';

  @override
  String get achievementLockedPrompt => 'Complétez des sessions pour débloquer les succès';

  @override
  String get ratingPromptTitle => 'Vous appréciez Focus Field ?';

  @override
  String get ratingPromptBody => 'Une note 5★ rapide aide d\'autres à trouver le calme.';

  @override
  String get ratingPromptRateNow => 'Noter maintenant';

  @override
  String get ratingPromptLater => 'Plus tard';

  @override
  String get ratingPromptNoThanks => 'Non merci';

  @override
  String get ratingThankYou => 'Merci pour votre soutien !';

  @override
  String get notificationSettingsTitle => 'Paramètres de notification';

  @override
  String get notificationPermissionRequired => 'Permission requise';

  @override
  String get notificationPermissionRationale => 'Activez les notifications pour des rappels doux et célébrer vos succès.';

  @override
  String get requesting => 'Demande...';

  @override
  String get enableNotificationsCta => 'Activer';

  @override
  String get enableNotificationsTitle => 'Activer les notifications';

  @override
  String get enableNotificationsSubtitle => 'Autoriser Focus Field à envoyer des notifications';

  @override
  String get dailyReminderTitle => 'Rappel quotidien intelligent';

  @override
  String get dailyReminderSubtitle => 'Intelligent ou heure fixe';

  @override
  String get dailyTimeLabel => 'Heure quotidienne';

  @override
  String get dailyTimeHint => 'Choisir une heure fixe ou laisser l\'appli apprendre votre rythme.';

  @override
  String get useSmartCta => 'Utiliser Smart';

  @override
  String get sessionCompletedTitle => 'Session terminée';

  @override
  String get sessionCompletedSubtitle => 'Célébrer les sessions terminées';

  @override
  String get achievementUnlockedTitle => 'Succès débloqué';

  @override
  String get achievementUnlockedSubtitle => 'Notifications de jalons';

  @override
  String get weeklySummaryTitle => 'Résumé hebdomadaire';

  @override
  String get weeklySummarySubtitle => 'Aperçu hebdo (jour & heure)';

  @override
  String get weeklyTimeLabel => 'Heure hebdo';

  @override
  String get notificationPreview => 'Aperçu';

  @override
  String get dailySilenceReminderTitle => 'Rappel quotidien de silence';

  @override
  String get weeklyProgressReportTitle => 'Progrès hebdomadaire 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Succès débloqué ! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session réussie ! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session terminée';

  @override
  String get reminderStartJourney => '🧘‍♂️ Commencez votre voyage silencieux aujourd\'hui et trouvez le calme.';

  @override
  String get reminderRestart => '🌱 Repartir ? Chaque instant est un nouveau départ.';

  @override
  String get reminderDayTwo => '⭐ Jour 2 de votre série ! La constance construit la sérénité.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Série de $streak jours ! Vous bâtissez une habitude solide.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Impressionnante série de $streak jours ! Votre engagement inspire.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Incroyable série de $streak jours ! Maîtrise du silence !';
  }

  @override
  String get achievementFirstSession => '🎉 Première session accomplie ! Bienvenue.';

  @override
  String get achievementWeekStreak => '🌟 Série de 7 jours ! La constance est votre super‑pouvoir.';

  @override
  String get achievementMonthStreak => '🏆 Série de 30 jours débloquée ! Inarrêtable.';

  @override
  String get achievementPerfectSession => '✨ Session de silence parfaite. Aucune perturbation.';

  @override
  String get achievementLongSession => '⏰ Longue session maîtrisée. Votre focus grandit.';

  @override
  String get achievementGeneric => '🎊 Succès débloqué ! Continuez !';

  @override
  String get weeklyProgressNone => '💭 Semaine légère en pratique. Prêt pour une session ?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count sessions cette semaine. Chaque pratique approfondit votre calme.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count sessions – vous trouvez votre rythme.';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 Semaine parfaite avec $count sessions. Super constance.';
  }

  @override
  String get tipsHidden => 'Astuces masquées';

  @override
  String get tipsShown => 'Astuces affichées';

  @override
  String get showTips => 'Afficher les astuces';

  @override
  String get hideTips => 'Masquer les astuces';

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
  String get tipInfoTooltip => 'Afficher l\'astuce';

  @override
  String get questCapsuleTitle => 'Quête Ambiante';

  @override
  String get questCapsuleLoading => 'Chargement des minutes calmes…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Calme $progress/$goal min • Série $streak';
  }

  @override
  String get questFreezeButton => 'Geler';

  @override
  String get questFrozenToday => 'Aujourd\'hui gelé — vous êtes protégé.';

  @override
  String get questGoButton => 'Aller';

  @override
  String calmPercent(int percent) {
    return 'Calme $percent%';
  }

  @override
  String get calmLabel => 'Calme';

  @override
  String get day => 'jour';

  @override
  String get days => 'jours';

  @override
  String get freeze => 'geler';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3 victoires ! Essayer $threshold dB ?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Pas maintenant';

  @override
  String get adaptiveThresholdTryIt => 'Essayer';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Seuil défini à $threshold dB';
  }
}
