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
  String get microphonePermissionMessage => 'Focus Field mesure les niveaux de bruit ambiant pour vous aider à maintenir des environnements calmes.\n\nL\'application a besoin d\'accéder au microphone pour détecter le silence, mais n\'enregistre aucun audio.';

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
  String get notificationPreview => 'Aperçu des notifications';

  @override
  String get dailySilenceReminderTitle => 'Rappel quotidien de focus';

  @override
  String get weeklyProgressReportTitle => 'Progrès hebdomadaire 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Succès débloqué ! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Session réussie ! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Session terminée';

  @override
  String get reminderStartJourney => '🎯 Commencez votre voyage de focus aujourd\'hui ! Construisez votre habitude de travail profond.';

  @override
  String get reminderRestart => '🌱 Repartir ? Chaque instant est une nouvelle occasion pour se concentrer.';

  @override
  String get reminderDayTwo => '⭐ Jour 2 de votre série de focus ! La constance construit la concentration.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Série de $streak jours de focus ! Vous bâtissez une habitude solide.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Impressionnante série de $streak jours ! Votre engagement inspire.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Incroyable série de $streak jours ! Vous êtes un champion de focus !';
  }

  @override
  String get achievementFirstSession => '🎉 Première session accomplie ! Bienvenue dans Focus Field !';

  @override
  String get achievementWeekStreak => '🌟 Série de 7 jours ! La constance est votre super‑pouvoir.';

  @override
  String get achievementMonthStreak => '🏆 Série de 30 jours débloquée ! Inarrêtable.';

  @override
  String get achievementPerfectSession => '✨ Session parfaite ! 100 % d\'environnement calme maintenu !';

  @override
  String get achievementLongSession => '⏰ Longue session maîtrisée. Votre focus grandit.';

  @override
  String get achievementGeneric => '🎊 Succès débloqué ! Continuez !';

  @override
  String get weeklyProgressNone => '💭 Commencez votre objectif hebdomadaire ! Prêt pour une session concentrée ?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count minutes de focus cette semaine ! Chaque session compte.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count minutes de focus gagnées – vous trouvez votre rythme !';
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
  String get tip01 => 'Commencez petit—même 2 minutes construisent votre habitude de concentration.';

  @override
  String get tip02 => 'Votre série a de la grâce—un oubli ne la cassera pas avec la Règle des 2 Jours.';

  @override
  String get tip03 => 'Essayez les activités Étude, Lecture ou Méditation pour correspondre à votre style de concentration.';

  @override
  String get tip04 => 'Consultez votre Carte de Chaleur sur 12 semaines pour voir comment les petites victoires s\'accumulent au fil du temps.';

  @override
  String get tip05 => 'Regardez votre % de Calme en direct pendant les sessions—des scores plus élevés signifient une meilleure concentration!';

  @override
  String get tip06 => 'Personnalisez votre objectif quotidien (10-60 min) pour correspondre à votre rythme.';

  @override
  String get tip07 => 'Utilisez votre Jeton de Gel mensuel pour protéger votre série les jours difficiles.';

  @override
  String get tip08 => 'Après 3 victoires, Focus Field suggère un seuil plus strict—prêt à passer au niveau supérieur?';

  @override
  String get tip09 => 'Bruit ambiant élevé? Augmentez votre seuil pour rester dans la zone.';

  @override
  String get tip10 => 'Les Rappels Quotidiens Intelligents apprennent votre meilleur moment—laissez-les vous guider.';

  @override
  String get tip11 => 'L\'anneau de progression est cliquable—un clic démarre votre session de concentration.';

  @override
  String get tip12 => 'Recalibrez lorsque votre environnement change pour une meilleure précision.';

  @override
  String get tip13 => 'Les notifications de session célèbrent vos victoires—activez-les pour la motivation!';

  @override
  String get tip14 => 'La cohérence bat la perfection—présentez-vous, même les jours chargés.';

  @override
  String get tip15 => 'Essayez différents moments de la journée pour découvrir votre point idéal tranquille.';

  @override
  String get tip16 => 'Votre progression quotidienne est toujours visible—appuyez sur Aller pour commencer à tout moment.';

  @override
  String get tip17 => 'Chaque activité suit séparément vers votre objectif—la variété garde les choses fraîches.';

  @override
  String get tip18 => 'Exportez vos données (Premium) pour voir votre parcours de concentration complet.';

  @override
  String get tip19 => 'Les confettis célèbrent chaque achèvement—les petites victoires méritent d\'être reconnues!';

  @override
  String get tip20 => 'Votre ligne de base compte—calibrez lors du déplacement vers de nouveaux espaces.';

  @override
  String get tip21 => 'Vos Tendances sur 7 Jours révèlent des modèles—consultez-les chaque semaine pour des insights.';

  @override
  String get tip22 => 'Améliorez la durée de session (Premium) pour des blocs de concentration profonde plus longs.';

  @override
  String get tip23 => 'La concentration est une pratique—les petites sessions construisent l\'habitude que vous voulez.';

  @override
  String get tip24 => 'Le Résumé Hebdomadaire montre votre rythme—adaptez-le à votre emploi du temps.';

  @override
  String get tip25 => 'Ajustez votre seuil pour votre espace—chaque pièce est différente.';

  @override
  String get tip26 => 'Les options d\'accessibilité aident tout le monde à se concentrer—contraste élevé, grand texte, vibration.';

  @override
  String get tip27 => 'La Chronologie d\'Aujourd\'hui montre quand vous étiez concentré—trouvez vos heures productives.';

  @override
  String get tip28 => 'Terminez ce que vous commencez—des sessions plus courtes signifient plus d\'achèvements.';

  @override
  String get tip29 => 'Les Minutes Silencieuses s\'ajoutent vers votre objectif—progression plutôt que perfection.';

  @override
  String get tip30 => 'Vous êtes à un clic—commencez une petite session maintenant.';

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
  String get tipInstructionHeatmap => 'Onglet Résumé → Afficher Plus → Carte de Chaleur';

  @override
  String get tipInstructionTodayTimeline => 'Onglet Résumé → Afficher Plus → Chronologie d\'Aujourd\'hui';

  @override
  String get tipInstruction7DayTrends => 'Onglet Résumé → Afficher Plus → Tendances sur 7 Jours';

  @override
  String get tipInstructionEditActivities => 'Onglet Activité → appuyez sur Modifier pour afficher/masquer les activités';

  @override
  String get tipInstructionQuestGo => 'Onglet Activité → Capsule de Quête → appuyez sur Aller';

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

  @override
  String get edit => 'Modifier';

  @override
  String get start => 'Démarrer';

  @override
  String get error => 'Erreur';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get faqTitle => 'Questions Fréquemment Posées';

  @override
  String get faqSearchHint => 'Rechercher des questions...';

  @override
  String get faqNoResults => 'Aucun résultat trouvé';

  @override
  String get faqNoResultsSubtitle => 'Essayez un autre terme de recherche';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats trouvés',
      one: '1 résultat trouvé',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => 'Qu\'est-ce que Focus Field et comment m\'aide-t-il à me concentrer ?';

  @override
  String get faqA01 => 'Focus Field vous aide à développer de meilleures habitudes de concentration en surveillant le bruit ambiant dans votre environnement. Lorsque vous démarrez une session (Étude, Lecture, Méditation ou Autre), l\'application mesure le calme de votre environnement. Plus vous le maintenez silencieux, plus vous gagnez de « minutes de concentration ». Cela vous encourage à trouver et à maintenir des espaces sans distraction pour un travail profond.';

  @override
  String get faqQ02 => 'Comment Focus Field mesure-t-il ma concentration ?';

  @override
  String get faqA02 => 'Focus Field surveille le niveau de bruit ambiant dans votre environnement pendant votre session. Il calcule un « Score Ambiant » en suivant combien de secondes votre environnement reste en dessous de votre seuil de bruit choisi. Si votre session a au moins 70% de temps calme (Score Ambiant ≥70%), vous obtenez un crédit complet pour ces minutes calmes.';

  @override
  String get faqQ03 => 'Focus Field enregistre-t-il mon audio ou mes conversations ?';

  @override
  String get faqA03 => 'Non, absolument pas. Focus Field mesure uniquement les niveaux de décibels (volume) - il n\'enregistre, ne stocke ni ne transmet jamais d\'audio. Votre vie privée est complètement protégée. L\'application vérifie simplement si votre environnement est au-dessus ou en dessous de votre seuil choisi.';

  @override
  String get faqQ04 => 'Quelles activités puis-je suivre avec Focus Field ?';

  @override
  String get faqA04 => 'Focus Field propose quatre types d\'activité : Étude 📚 (pour l\'apprentissage et la recherche), Lecture 📖 (pour la lecture concentrée), Méditation 🧘 (pour la pratique de pleine conscience) et Autre ⭐ (pour toute activité nécessitant de la concentration). Toutes les activités utilisent la surveillance du bruit ambiant pour vous aider à maintenir un environnement calme et concentré.';

  @override
  String get faqQ05 => 'Dois-je utiliser Focus Field pour toutes mes activités ?';

  @override
  String get faqA05 => 'Focus Field fonctionne mieux pour les activités où le bruit ambiant indique votre niveau de concentration. Les activités comme l\'Étude, la Lecture et la Méditation bénéficient le plus d\'environnements calmes. Bien que vous puissiez suivre d\'« Autres » activités, nous recommandons d\'utiliser Focus Field principalement pour un travail de concentration sensible au bruit.';

  @override
  String get faqQ06 => 'Comment démarrer une session de concentration ?';

  @override
  String get faqA06 => 'Allez dans l\'onglet Sessions, sélectionnez votre activité (Étude, Lecture, Méditation ou Autre), choisissez la durée de votre session (1, 5, 10, 15, 30 minutes ou options premium), appuyez sur le bouton Démarrer sur l\'anneau de progression et gardez votre environnement calme !';

  @override
  String get faqQ07 => 'Quelles durées de session sont disponibles ?';

  @override
  String get faqA07 => 'Les utilisateurs gratuits peuvent choisir : sessions de 1, 5, 10, 15 ou 30 minutes. Les utilisateurs Premium obtiennent également : sessions prolongées de 1 heure, 1,5 heure et 2 heures pour des périodes de travail profond plus longues.';

  @override
  String get faqQ08 => 'Puis-je mettre en pause ou arrêter une session plus tôt ?';

  @override
  String get faqA08 => 'Oui ! Pendant une session, vous verrez des boutons Pause et Arrêter au-dessus de l\'anneau de progression. Pour éviter les appuis accidentels, vous devez maintenir ces boutons appuyés. Si vous arrêtez plus tôt, vous gagnerez toujours des points pour les minutes calmes que vous avez accumulées.';

  @override
  String get faqQ09 => 'Comment gagner des points dans Focus Field ?';

  @override
  String get faqA09 => 'Vous gagnez 1 point par minute calme. Pendant votre session, Focus Field suit combien de secondes votre environnement reste en dessous du seuil de bruit. À la fin, ces secondes calmes sont converties en minutes. Par exemple, si vous terminez une session de 10 minutes avec 8 minutes de calme, vous gagnez 8 points.';

  @override
  String get faqQ10 => 'Qu\'est-ce que le seuil de 70% et pourquoi est-il important ?';

  @override
  String get faqA10 => 'Le seuil de 70% détermine si votre session compte pour votre objectif quotidien. Si votre Score Ambiant (temps calme ÷ temps total) est d\'au moins 70%, votre session est qualifiée pour le crédit de quête. Même si vous êtes en dessous de 70%, vous gagnez toujours des points pour chaque minute calme !';

  @override
  String get faqQ11 => 'Quelle est la différence entre Score Ambiant et points ?';

  @override
  String get faqA11 => 'Le Score Ambiant est la qualité de votre session en pourcentage (secondes calmes ÷ secondes totales), déterminant si vous atteignez le seuil de 70%. Les points sont les minutes calmes réellement gagnées (1 point = 1 minute). Score Ambiant = qualité, Points = réalisation.';

  @override
  String get faqQ12 => 'Comment fonctionnent les séries dans Focus Field ?';

  @override
  String get faqA12 => 'Les séries suivent les jours consécutifs où vous atteignez votre objectif quotidien. Focus Field utilise une Règle Compassionnelle de 2 Jours : Votre série ne se brise que si vous manquez deux jours consécutifs. Cela signifie que vous pouvez manquer un jour et votre série continue si vous atteignez votre objectif le lendemain.';

  @override
  String get faqQ13 => 'Que sont les jetons de gel et comment les utiliser ?';

  @override
  String get faqA13 => 'Les jetons de gel protègent votre série lorsque vous ne pouvez pas atteindre votre objectif. Vous recevez 1 jeton de gel gratuit par mois. Lorsqu\'il est utilisé, votre progression globale affiche 100% (objectif protégé), votre série est sûre et le suivi des activités individuelles se poursuit normalement. Utilisez-le judicieusement pour les jours chargés !';

  @override
  String get faqQ14 => 'Puis-je personnaliser mon objectif de concentration quotidien ?';

  @override
  String get faqA14 => 'Oui ! Appuyez sur Modifier sur la carte Sessions dans l\'onglet Aujourd\'hui. Vous pouvez définir votre objectif quotidien global (10-60 minutes gratuit, jusqu\'à 1080 minutes premium), activer les objectifs par activité pour des cibles séparées et afficher/masquer des activités spécifiques.';

  @override
  String get faqQ15 => 'Qu\'est-ce que le seuil de bruit et comment l\'ajuster ?';

  @override
  String get faqA15 => 'Le seuil est le niveau de bruit maximum (en décibels) qui compte comme « calme ». Par défaut, c\'est 40 dB (calme de bibliothèque). Vous pouvez l\'ajuster dans l\'onglet Sessions : 30 dB (très calme), 40 dB (calme de bibliothèque - recommandé), 50 dB (bureau modéré), 60-80 dB (environnements plus bruyants).';

  @override
  String get faqQ16 => 'Qu\'est-ce que le Seuil Adaptatif et dois-je l\'utiliser ?';

  @override
  String get faqA16 => 'Après 3 sessions réussies consécutives à votre seuil actuel, Focus Field suggère de l\'augmenter de 2 dB pour vous défier. Cela vous aide à vous améliorer progressivement. Vous pouvez accepter ou rejeter la suggestion - elle n\'apparaît qu\'une fois tous les 7 jours.';

  @override
  String get faqQ17 => 'Qu\'est-ce que le Mode Focus ?';

  @override
  String get faqA17 => 'Le Mode Focus est une superposition plein écran sans distraction pendant votre session. Il affiche votre minuteur de compte à rebours, le pourcentage de calme en direct et des contrôles minimaux (Pause/Arrêter via un appui long). Il supprime tous les autres éléments d\'interface pour que vous puissiez vous concentrer pleinement. Activez-le dans Paramètres > Basique > Mode Focus.';

  @override
  String get faqQ18 => 'Pourquoi Focus Field a-t-il besoin de l\'autorisation du microphone ?';

  @override
  String get faqA18 => 'Focus Field utilise le microphone de votre appareil pour mesurer les niveaux de bruit ambiant (décibels) pendant les sessions. C\'est essentiel pour calculer votre Score Ambiant. Rappelez-vous : aucun audio n\'est jamais enregistré - seuls les niveaux de bruit sont mesurés en temps réel.';

  @override
  String get faqQ19 => 'Puis-je voir mes schémas de concentration au fil du temps ?';

  @override
  String get faqA19 => 'Oui ! L\'onglet Aujourd\'hui affiche votre progression quotidienne, les tendances hebdomadaires, la carte thermique d\'activité de 12 semaines (comme les contributions GitHub) et la chronologie des sessions. Les utilisateurs Premium obtiennent des analyses avancées avec des métriques de performance, des moyennes mobiles et des informations alimentées par l\'IA.';

  @override
  String get faqQ20 => 'Comment fonctionnent les notifications dans Focus Field ?';

  @override
  String get faqA20 => 'Focus Field a des rappels intelligents : Rappels Quotidiens (apprend votre heure de concentration préférée ou utilise une heure fixe), notifications de Session Terminée avec résultats, notifications de Réalisation pour les jalons et Résumé Hebdomadaire (Premium). Activez/personnalisez dans Paramètres > Avancé > Notifications.';

  @override
  String get microphoneSettingsTitle => 'Paramètres Requis';

  @override
  String get microphoneSettingsMessage => 'Pour activer la détection du silence, accordez manuellement l\'autorisation du microphone:\n\n• iOS: Réglages > Confidentialité et Sécurité > Microphone > Focus Field\n• Android: Paramètres > Applications > Focus Field > Autorisations > Microphone';

  @override
  String get buttonGrantPermission => 'Accorder l\'Autorisation';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => 'Ouvrir les Paramètres';

  @override
  String get onboardingBack => 'Retour';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingWelcomeSnackbar => 'Bienvenue ! Prêt à commencer votre première session ? 🚀';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur\nFocus Field ! 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'Votre voyage vers un meilleur focus commence ici !\nConstruisons des habitudes qui durent 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Suivez votre focus';

  @override
  String get onboardingFeatureTrackDesc => 'Voyez votre progression en temps réel pendant que vous construisez votre super-pouvoir de focus ! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Gagnez des Récompenses';

  @override
  String get onboardingFeatureRewardsDesc => 'Chaque minute silencieuse compte ! Collectez des points et célébrez vos victoires 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Construisez des Séries';

  @override
  String get onboardingFeatureStreaksDesc => 'Maintenez l\'élan ! Notre système compatissant vous garde motivé 🔥';

  @override
  String get onboardingEnvironmentTitle => 'Où est votre zone de focus ? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'Choisissez votre environnement typique pour que nous optimisions votre espace !';

  @override
  String get onboardingEnvQuietHomeTitle => 'Maison Silencieuse';

  @override
  String get onboardingEnvQuietHomeDesc => 'Chambre, bureau à domicile calme';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Très silencieux';

  @override
  String get onboardingEnvOfficeTitle => 'Bureau Typique';

  @override
  String get onboardingEnvOfficeDesc => 'Bureau standard, bibliothèque';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Silence de bibliothèque (Recommandé)';

  @override
  String get onboardingEnvBusyTitle => 'Espace Animé';

  @override
  String get onboardingEnvBusyDesc => 'Café, espace de travail partagé';

  @override
  String get onboardingEnvBusyDb => '50 dB - Bruit modéré';

  @override
  String get onboardingEnvNoisyTitle => 'Environnement Bruyant';

  @override
  String get onboardingEnvNoisyDesc => 'Bureau ouvert, espace public';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Bruit plus élevé';

  @override
  String get onboardingEnvAdjustNote => 'Vous pouvez ajuster cela à tout moment dans les Paramètres';

  @override
  String get onboardingGoalTitle => 'Définissez Votre Objectif Quotidien ! 🎯';

  @override
  String get onboardingGoalSubtitle => 'Combien de temps de concentration vous convient ?\n(Vous pouvez ajuster cela à tout moment !)';

  @override
  String get onboardingGoalStartingTitle => 'Démarrage';

  @override
  String get onboardingGoalStartingDuration => '10-15 minutes';

  @override
  String get onboardingGoalHabitTitle => 'Construction d\'Habitude';

  @override
  String get onboardingGoalHabitDuration => '20-30 minutes';

  @override
  String get onboardingGoalPracticeTitle => 'Pratique Régulière';

  @override
  String get onboardingGoalPracticeDuration => '40-60 minutes';

  @override
  String get onboardingGoalDeepWorkTitle => 'Travail Profond';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ minutes';

  @override
  String get onboardingGoalAdvice1 => 'Début parfait ! 🌟 Les petits pas mènent à de grandes victoires. Vous pouvez le faire !';

  @override
  String get onboardingGoalAdvice2 => 'Excellent choix ! 🎯 Ce sweet spot construit des habitudes durables !';

  @override
  String get onboardingGoalAdvice3 => 'Ambitieux ! 💪 Vous êtes prêt à monter de niveau votre jeu de concentration !';

  @override
  String get onboardingGoalAdvice4 => 'Wow ! 🏆 Mode travail profond activé ! N\'oubliez pas les pauses !';

  @override
  String get onboardingActivitiesTitle => 'Choisissez Vos Activités ! ✨';

  @override
  String get onboardingActivitiesSubtitle => 'Choisissez toutes celles qui vous parlent !\n(Vous pouvez toujours en ajouter plus tard)';

  @override
  String get onboardingActivityStudyTitle => 'Étude';

  @override
  String get onboardingActivityStudyDesc => 'Apprentissage, cours, recherche';

  @override
  String get onboardingActivityReadingTitle => 'Lecture';

  @override
  String get onboardingActivityReadingDesc => 'Lecture approfondie, articles, livres';

  @override
  String get onboardingActivityMeditationTitle => 'Méditation';

  @override
  String get onboardingActivityMeditationDesc => 'Pleine conscience, exercices de respiration';

  @override
  String get onboardingActivityOtherTitle => 'Autre';

  @override
  String get onboardingActivityOtherDesc => 'Toute activité nécessitant de la concentration';

  @override
  String get onboardingActivitiesTip => 'Conseil pro : Focus Field brille quand silence = concentration ! 🤫✨';

  @override
  String get onboardingPermissionTitle => 'Votre Vie Privée Compte ! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'Nous avons besoin de l\'accès au microphone pour mesurer le bruit ambiant et vous aider à mieux vous concentrer';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'Pas d\'Enregistrement';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'Nous mesurons uniquement les niveaux de bruit, ne jamais enregistrer l\'audio';

  @override
  String get onboardingPrivacyLocalTitle => 'Local Seulement';

  @override
  String get onboardingPrivacyLocalDesc => 'Toutes les données restent sur votre appareil';

  @override
  String get onboardingPrivacyFirstTitle => 'Confidentialité D\'abord';

  @override
  String get onboardingPrivacyFirstDesc => 'Vos conversations sont complètement privées';

  @override
  String get onboardingPermissionNote => 'Vous pouvez accorder la permission sur l\'écran suivant lors du démarrage de votre première session';

  @override
  String get onboardingTipsTitle => 'Conseils Pro pour Réussir ! 💡';

  @override
  String get onboardingTipsSubtitle => 'Ceux-ci vous aideront à tirer le meilleur parti de Focus Field !';

  @override
  String get onboardingTip1Title => 'Commencez Petit, Gagnez Gros ! 🌱';

  @override
  String get onboardingTip1Desc => 'Commencez par des sessions de 5-10 minutes. La constance bat la perfection !';

  @override
  String get onboardingTip2Title => 'Activez le Mode Focus ! 🎯';

  @override
  String get onboardingTip2Desc => 'Appuyez sur Mode Focus pour une expérience immersive sans distraction.';

  @override
  String get onboardingTip3Title => 'Jeton de Gel = Filet de Sécurité ! ❄️';

  @override
  String get onboardingTip3Desc => 'Utilisez votre jeton mensuel les jours chargés pour protéger votre série.';

  @override
  String get onboardingTip4Title => 'La Règle des 70% Déchire ! 📈';

  @override
  String get onboardingTip4Desc => 'Visez 70% de temps calme - pas besoin de silence parfait !';

  @override
  String get onboardingReadyTitle => 'Vous Êtes Prêt à Décoller ! 🚀';

  @override
  String get onboardingReadyDesc => 'Commençons votre première session et construisons des habitudes incroyables !';

  @override
  String get questMotivation1 => 'Le succès ne finit jamais et l\'échec n\'est jamais final';

  @override
  String get questMotivation2 => 'Progrès plutôt que perfection - chaque minute compte';

  @override
  String get questMotivation3 => 'De petits pas quotidiens mènent à de grands changements';

  @override
  String get questMotivation4 => 'Vous construisez de meilleures habitudes, une session à la fois';

  @override
  String get questMotivation5 => 'La cohérence bat l\'intensité';

  @override
  String get questMotivation6 => 'Chaque session est une victoire, peu importe sa durée';

  @override
  String get questMotivation7 => 'La concentration est un muscle - vous devenez plus fort';

  @override
  String get questMotivation8 => 'Le voyage de mille lieues commence par un seul pas';

  @override
  String get questGo => 'Aller';

  @override
  String get questTapStart => 'Tap Start →';

  @override
  String get todayDashboardTitle => 'Votre tableau de bord de concentration';

  @override
  String get todayFocusMinutes => 'Minutes de concentration aujourd\'hui';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Objectif: $goalMinutes min • Calme ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Choisissez votre mode';

  @override
  String get todayDefaultActivities => 'Étude • Lecture • Méditation';

  @override
  String get todayTooltipTips => 'Conseils';

  @override
  String get todayTooltipTheme => 'Thème';

  @override
  String get todayTooltipSettings => 'Paramètres';

  @override
  String todayThemeChanged(String themeName) {
    return 'Thème changé en $themeName';
  }

  @override
  String get todayTabToday => 'Aujourd\'hui';

  @override
  String get todayTabSessions => 'Sessions';

  @override
  String get todayHelperText => 'Définissez votre durée et suivez votre temps. L\'historique des sessions et les analyses apparaîtront dans le résumé.';

  @override
  String get statPoints => 'Points';

  @override
  String get statStreak => 'Série';

  @override
  String get statSessions => 'Sessions';

  @override
  String get ringProgressTitle => 'Progrès de l\'anneau';

  @override
  String get ringOverall => 'Global';

  @override
  String get ringOverallFrozen => 'Global ❄️';

  @override
  String get sessionCalm => 'Calme';

  @override
  String get sessionStart => 'Démarrer';

  @override
  String get sessionStop => 'Arrêter';

  @override
  String get buttonEdit => 'Modifier';

  @override
  String get durationUpTo1Hour => 'Sessions jusqu\'à 1 heure';

  @override
  String get durationUpTo1_5Hours => 'Sessions jusqu\'à 1,5 heures';

  @override
  String get durationUpTo2Hours => 'Sessions jusqu\'à 2 heures';

  @override
  String get durationExtended => 'Durées de session étendues';

  @override
  String get durationExtendedAccess => 'Accès aux sessions étendues';

  @override
  String get noiseRoomLoudness => 'Volume de la pièce';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Seuil: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Seuil défini sur $db dB';
  }

  @override
  String get noiseHighDetected => 'Bruit élevé détecté, veuillez vous rendre dans une pièce plus calme pour une meilleure concentration';

  @override
  String get noiseThresholdExceededHint => 'Trouvez un endroit plus calme ou augmentez le seuil →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'Trouver un endroit plus calme ou augmenter à ${db}dB?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'Bruit élevé détecté. Augmenter à ${db}dB?';
  }

  @override
  String get noiseAtMaxThreshold => 'Déjà au seuil maximum. Veuillez trouver un endroit plus calme.';

  @override
  String get noiseThresholdYes => 'Oui';

  @override
  String get noiseThresholdNo => 'Non';

  @override
  String get trendsInsights => 'Aperçus';

  @override
  String get trendsLast7Days => '7 derniers jours';

  @override
  String get trendsShareWeeklySummary => 'Partager le résumé hebdomadaire';

  @override
  String get trendsLoading => 'Chargement...';

  @override
  String get trendsLoadingMetrics => 'Chargement des métriques...';

  @override
  String get trendsNoData => 'Aucune donnée';

  @override
  String get trendsWeeklyTotal => 'Total hebdomadaire';

  @override
  String get trendsBestDay => 'Meilleur jour';

  @override
  String get trendsActivityHeatmap => 'Carte thermique d\'activité';

  @override
  String get trendsRecentActivity => 'Activité récente';

  @override
  String get trendsHeatmapError => 'Impossible de charger la carte thermique';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mer';

  @override
  String get dayThu => 'Jeu';

  @override
  String get dayFri => 'Ven';

  @override
  String get daySat => 'Sam';

  @override
  String get daySun => 'Dim';

  @override
  String get focusModeComplete => 'Session terminée!';

  @override
  String get focusModeGreatSession => 'Excellente session de concentration';

  @override
  String get focusModeResume => 'Reprendre';

  @override
  String get focusModePause => 'Pause';

  @override
  String get focusModeLongPressHint => 'Appuyez longuement pour mettre en pause ou arrêter';

  @override
  String get activityEditTitle => 'Modifier les activités';

  @override
  String get activityRecommendation => 'Recommandé: 10+ min par activité pour une formation d\'habitudes cohérente';

  @override
  String get activityDailyGoals => 'Objectifs quotidiens';

  @override
  String activityTotalHours(String hours) {
    return 'Total: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Par activité';

  @override
  String get activityExceedsLimit => 'Le total dépasse la limite quotidienne de 18 heures. Veuillez réduire les objectifs.';

  @override
  String get activityGoalLabel => 'Objectif';

  @override
  String get activityGoalDescription => 'Définissez votre objectif de concentration quotidien (1 min - 18h)';

  @override
  String get shareYourProgress => 'Partagez vos progrès';

  @override
  String get shareTimeRange => 'Plage de temps';

  @override
  String get shareCardSize => 'Taille de carte';

  @override
  String get analyticsPerformanceMetrics => 'Métriques de performance';

  @override
  String get analyticsPreferredDuration => 'Durée préférée';

  @override
  String get analyticsUnavailable => 'Analyses non disponibles';

  @override
  String get analyticsRestoreAttempt => 'Nous tenterons de restaurer cette section au prochain lancement de l\'application.';

  @override
  String get audioUnavailable => 'Audio temporairement indisponible';

  @override
  String get audioRecovering => 'Le traitement audio a rencontré un problème. Récupération automatique...';

  @override
  String get shareQuietMinutes => 'MINUTES CALMES';

  @override
  String get shareTopActivity => 'Activité Principale';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Aperçu';

  @override
  String get sharePinchToZoom => 'Pincez pour zoomer';

  @override
  String get shareGenerating => 'Génération...';

  @override
  String get shareButton => 'Partager';

  @override
  String get shareTodayLabel => 'Aujourd\'hui';

  @override
  String get shareWeeklyLabel => 'Hebdomadaire';

  @override
  String get shareTodayTitle => 'Votre Focus du Jour';

  @override
  String get shareWeeklyTitle => 'Votre Focus Hebdomadaire';

  @override
  String get shareSubject => 'Ma Progression Focus Field';

  @override
  String get shareFormatSquare => 'Ratio 1:1 • Compatibilité universelle';

  @override
  String get shareFormatPost => 'Ratio 4:5 • Publications Instagram/Twitter';

  @override
  String get shareFormatStory => 'Ratio 9:16 • Stories Instagram';

  @override
  String get recapWeeklyTitle => 'Récapitulatif Hebdomadaire';

  @override
  String get recapMinutes => 'Minutes';

  @override
  String recapStreak(int start, int end) {
    return 'Série: $start → $end jours';
  }

  @override
  String get recapTopActivity => 'Activité Principale: ';

  @override
  String get practiceOverviewTitle => 'Aperçu de la Pratique';

  @override
  String get practiceLast7Days => '7 Derniers Jours';

  @override
  String get audioMultipleErrors => 'Plusieurs erreurs audio détectées. Composant en récupération...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Objectif actuel: $goal';
  }

  @override
  String get activitySaveChanges => 'Enregistrer les Modifications';

  @override
  String get insightsTitle => 'Aperçus';

  @override
  String get insightsTooltip => 'Voir les aperçus détaillés';

  @override
  String get statDays => 'JOURS';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Total Aujourd\'hui $done/$goal min, choisissez n\'importe quelle activité';
  }

  @override
  String get premiumFeature => 'Fonctionnalité Premium';

  @override
  String get premiumFeatureAccess => 'Accès aux fonctionnalités premium';

  @override
  String get activityUnknown => 'Inconnu';

  @override
  String get insightsFirstSessionTitle => 'Complétez votre première session';

  @override
  String get insightsFirstSessionSubtitle => 'Commencez à suivre votre temps de concentration, vos modèles de session et vos tendances de score ambiant';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Ambiance : $percent %';
  }

  @override
  String get sessionSuccess => 'Succès';

  @override
  String get sessionFailed => 'Échoué';

  @override
  String get focusModeButton => 'Mode Focus';

  @override
  String get settingsDailyGoalsTitle => 'Objectifs quotidiens';

  @override
  String get settingsFocusModeDescription => 'Minimisez les distractions pendant les sessions avec une superposition focalisée';

  @override
  String get settingsDeepFocusTitle => 'Focus profond';

  @override
  String get settingsDeepFocusDescription => 'Terminer la session si l\'application est quittée';

  @override
  String get deepFocusDialogTitle => 'Focus profond';

  @override
  String get deepFocusEnableLabel => 'Activer le Focus profond';

  @override
  String get deepFocusGracePeriodLabel => 'Période de grâce (secondes)';

  @override
  String get deepFocusExplanation => 'Lorsqu\'il est activé, quitter l\'application terminera la session après la période de grâce.';

  @override
  String get notificationPermissionTitle => 'Activer les notifications';

  @override
  String get notificationPermissionExplanation => 'Focus Field a besoin de l\'autorisation de notification pour vous envoyer :';

  @override
  String get notificationBenefitReminders => 'Rappels de focus quotidiens';

  @override
  String get notificationBenefitCompletion => 'Alertes de session terminée';

  @override
  String get notificationBenefitAchievements => 'Célébrations de réussite';

  @override
  String get notificationHowToEnableIos => 'Comment activer sur iOS :';

  @override
  String get notificationHowToEnableAndroid => 'Comment activer sur Android :';

  @override
  String get notificationStepsIos => '1. Appuyez sur \"Ouvrir les paramètres\" ci-dessous\n2. Appuyez sur \"Notifications\"\n3. Activez \"Autoriser les notifications\"';

  @override
  String get notificationStepsAndroid => '1. Appuyez sur \"Ouvrir les paramètres\" ci-dessous\n2. Appuyez sur \"Notifications\"\n3. Activez \"Toutes les notifications Focus Field\"';

  @override
  String get aboutShowTips => 'Afficher les conseils';

  @override
  String get aboutShowTipsDescription => 'Affichez des conseils utiles au démarrage de l\'application et via l\'icône d\'ampoule. Les conseils apparaissent tous les 2-3 jours.';

  @override
  String get aboutReplayOnboarding => 'Rejouer l\'intégration';

  @override
  String get aboutReplayOnboardingDescription => 'Consultez à nouveau la visite de l\'application et configurez vos préférences';

  @override
  String get buttonFaq => 'FAQ';

  @override
  String get onboardingWelcomeMessage => 'Bienvenue ! Prêt à commencer votre première session ? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Gagner des récompenses';

  @override
  String get onboardingFeatureEarnDesc => 'Chaque minute calme compte ! Collectez des points et célébrez vos victoires 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Construire des séries';

  @override
  String get onboardingFeatureBuildDesc => 'Gardez l\'élan ! Notre système compatissant vous garde motivé 🔥';

  @override
  String get onboardingEnvironmentDescription => 'Choisissez votre environnement typique pour que nous puissions optimiser votre espace !';

  @override
  String get onboardingEnvQuietHome => 'Maison calme';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Très calme';

  @override
  String get onboardingEnvOffice => 'Bureau typique';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Calme de bibliothèque (Recommandé)';

  @override
  String get onboardingEnvBusy => 'Espace occupé';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Bruit modéré';

  @override
  String get onboardingEnvNoisy => 'Environnement bruyant';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Bruit plus élevé';

  @override
  String get onboardingAdjustAnytime => 'Vous pouvez ajuster cela à tout moment dans les paramètres';

  @override
  String get buttonGetStarted => 'Commencer';

  @override
  String get buttonNext => 'Suivant';

  @override
  String get errorActivityRequired => '⚠️ Au moins une activité doit être activée';

  @override
  String get errorGoalExceeds => 'Les objectifs totaux dépassent la limite quotidienne de 18 heures. Veuillez réduire les objectifs.';

  @override
  String get messageSaved => 'Paramètres enregistrés';

  @override
  String get errorPermissionRequired => 'Autorisation requise';

  @override
  String get notificationEnableReason => 'Activez les notifications pour recevoir des rappels et célébrer les réalisations.';

  @override
  String get buttonEnableNotifications => 'Activer les notifications';

  @override
  String get buttonRequesting => 'Demande en cours...';

  @override
  String get notificationDailyTime => 'Heure quotidienne';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Rappel quotidien à $time';
  }

  @override
  String get notificationLearning => 'apprentissage';

  @override
  String notificationSmart(String time) {
    return 'Intelligent ($time)';
  }

  @override
  String get buttonUseSmart => 'Utiliser Intelligent';

  @override
  String get notificationSmartExplanation => 'Choisissez une heure fixe ou laissez Focus Field apprendre votre modèle.';

  @override
  String get notificationSessionComplete => 'Session terminée';

  @override
  String get notificationSessionCompleteDesc => 'Célébrer les sessions terminées';

  @override
  String get notificationAchievement => 'Réussite débloquée';

  @override
  String get notificationAchievementDesc => 'Notifications de jalons';

  @override
  String get notificationWeekly => 'Résumé hebdomadaire des progrès';

  @override
  String get notificationWeeklyDesc => 'Aperçus hebdomadaires (jour de la semaine et heure)';

  @override
  String get notificationWeeklyTime => 'Heure hebdomadaire';

  @override
  String get notificationMilestone => 'Notifications de jalons';

  @override
  String get notificationWeeklyInsights => 'Informations hebdomadaires (jour et heure)';

  @override
  String get notificationDailyReminder => 'Rappel quotidien';

  @override
  String get notificationComplete => 'Session terminée';

  @override
  String get settingsSnackbar => 'Veuillez activer les notifications dans les paramètres de l\'appareil';

  @override
  String get shareCardTitle => 'Partager la carte';

  @override
  String get shareYourWeek => 'Partagez votre semaine';

  @override
  String get shareStyleGradient => 'Style dégradé';

  @override
  String get shareStyleGradientDesc => 'Dégradé audacieux avec grands chiffres';

  @override
  String get shareWeeklySummary => 'Résumé hebdomadaire';

  @override
  String get shareStyleAchievement => 'Style de réalisation';

  @override
  String get shareStyleAchievementDesc => 'Concentrez-vous sur le total de minutes calmes';

  @override
  String get shareQuietMinutesWeek => 'Minutes calmes cette semaine';

  @override
  String get shareAchievementMessage => 'Construire une concentration plus profonde,\\nune session à la fois';

  @override
  String get shareAchievementCard => 'Carte de réalisation';

  @override
  String get shareTextOnly => 'Texte uniquement';

  @override
  String get shareTextOnlyDesc => 'Partager en texte brut (pas d\'image)';

  @override
  String get shareYourStreak => 'Partagez votre série';

  @override
  String get shareAsCard => 'Partager en tant que carte';

  @override
  String get shareAsCardDesc => 'Belle carte visuelle';

  @override
  String get shareStreakCard => 'Carte de série';

  @override
  String get shareAsText => 'Partager en tant que texte';

  @override
  String get shareAsTextDesc => 'Message texte simple';

  @override
  String get shareErrorFailed => 'Échec du partage. Veuillez réessayer.';

  @override
  String get buttonShare => 'Partager';

  @override
  String get initializingApp => 'Initialisation de l\'application...';

  @override
  String initializationFailed(String error) {
    return 'Échec de l\'initialisation: $error';
  }

  @override
  String get loadingSettings => 'Chargement des paramètres...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Échec du chargement des paramètres: $error';
  }

  @override
  String get loadingUserData => 'Chargement des données utilisateur...';

  @override
  String dataLoadingFailed(String error) {
    return 'Échec du chargement des données: $error';
  }

  @override
  String get loading => 'Chargement...';

  @override
  String get taglineSilence => '🤫 Maîtrisez l\'art du silence';

  @override
  String get errorOops => 'Oups ! Quelque chose s\'est mal passé';

  @override
  String get buttonRetry => 'Réessayer';

  @override
  String get resetAppData => 'Réinitialiser les données de l\'application';

  @override
  String get resetAppDataMessage => 'Cela réinitialisera toutes les données et paramètres de l\'application à leurs valeurs par défaut. Cette action ne peut pas être annulée.\\n\\nVoulez-vous continuer?';

  @override
  String get buttonReset => 'Réinitialiser';

  @override
  String get messageDataReset => 'Les données de l\'application ont été réinitialisées';

  @override
  String errorResetFailed(String error) {
    return 'Échec de la réinitialisation des données: $error';
  }

  @override
  String get analyticsTitle => 'Analyses';

  @override
  String get analyticsOverview => 'Aperçu';

  @override
  String get analyticsPoints => 'Points';

  @override
  String get analyticsStreak => 'Série';

  @override
  String get analyticsSessions => 'Sessions';

  @override
  String get analyticsLast7Days => '7 derniers jours';

  @override
  String get analyticsPerformanceHighlights => 'Points forts des performances';

  @override
  String get analyticsSuccessRate => 'Taux de réussite';

  @override
  String get analyticsAvgSession => 'Session moy.';

  @override
  String get analyticsBestStreak => 'Meilleure série';

  @override
  String get analyticsActivityProgress => 'Progression des activités';

  @override
  String get analyticsComingSoon => 'Suivi détaillé des activités à venir.';

  @override
  String get analyticsAdvancedMetrics => 'Métriques avancées';

  @override
  String get analyticsPremiumContent => 'Contenu analytique avancé premium ici...';

  @override
  String get analytics30DayTrends => 'Tendances sur 30 jours';

  @override
  String get analyticsTrendsChart => 'Graphique de tendances premium ici...';

  @override
  String get analyticsAIInsights => 'Aperçus IA';

  @override
  String get analyticsAIComingSoon => 'Aperçus alimentés par l\'IA à venir...';

  @override
  String get analyticsUnlock => 'Débloquer les analyses avancées';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get errorQuestUnavailable => 'État de quête non disponible';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Échec de l\'utilisation du jeton de gel';

  @override
  String get buttonUseFreeze => 'Utiliser le gel';

  @override
  String get onboardingDailyGoalTitle => 'Définissez votre objectif quotidien! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'Combien de temps de concentration vous convient?\\n(Vous pouvez l\'ajuster à tout moment!)';

  @override
  String get onboardingGoalGettingStarted => 'Premiers pas';

  @override
  String get onboardingGoalBuildingHabit => 'Créer une habitude';

  @override
  String get onboardingGoalRegularPractice => 'Pratique régulière';

  @override
  String get onboardingGoalDeepWork => 'Travail en profondeur';

  @override
  String get onboardingProTip => 'Astuce pro: Focus Field brille quand silence = concentration! 🤫✨';

  @override
  String get onboardingPrivacyTitle => 'Votre vie privée compte! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'Nous avons besoin d\'accéder au microphone pour mesurer le bruit ambiant et vous aider à mieux vous concentrer';

  @override
  String get onboardingPrivacyNoRecording => 'Pas d\'enregistrement';

  @override
  String get onboardingPrivacyLocalOnly => 'Local uniquement';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'Toutes les données restent sur votre appareil';

  @override
  String get onboardingPrivacyFirst => 'Confidentialité d\'abord';

  @override
  String get onboardingPrivacyNote => 'Vous pouvez accorder l\'autorisation sur l\'écran suivant lors du démarrage de votre première session';

  @override
  String get insightsFocusTime => 'Temps de concentration';

  @override
  String get insightsSessions => 'Sessions';

  @override
  String get insightsAverage => 'Moyenne';

  @override
  String get insightsAmbientScore => 'Score ambiant';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeOceanBlue => 'Bleu océan';

  @override
  String get themeForestGreen => 'Vert forêt';

  @override
  String get themePurpleNight => 'Nuit violette';

  @override
  String get themeGoldLuxury => 'Luxe doré';

  @override
  String get themeSolarSunrise => 'Lever de soleil solaire';

  @override
  String get themeCyberNeon => 'Néon cybernétique';

  @override
  String get themeMidnightTeal => 'Sarcelle de minuit';

  @override
  String get settingsAppTheme => 'Thème de l\'application';

  @override
  String get freezeTokenNoTokensTitle => 'Pas de Jetons de Gel';

  @override
  String get freezeTokenNoTokensMessage => 'Vous n\'avez aucun jeton de gel disponible. Vous gagnez 1 jeton par semaine (max 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Objectif Déjà Atteint';

  @override
  String get freezeTokenGoalCompleteMessage => 'Votre objectif quotidien est déjà atteint! Les jetons de gel ne peuvent être utilisés que lorsque vous n\'avez pas encore atteint votre objectif.';

  @override
  String get freezeTokenUseTitle => 'Utiliser un Jeton de Gel';

  @override
  String get freezeTokenUseMessage => 'Les jetons de gel protègent votre série lorsque vous manquez un jour. L\'utilisation d\'un gel comptera comme la réalisation de votre objectif quotidien.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'Vous avez $count jeton(s). En utiliser un maintenant?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ Jeton de gel utilisé! Objectif marqué comme atteint.';

  @override
  String get trendsErrorLoading => 'Erreur de chargement des données';

  @override
  String get trendsPoints => 'Points';

  @override
  String get trendsStreak => 'Série';

  @override
  String get trendsSessions => 'Sessions';

  @override
  String get trendsTopActivity => 'Activité Principale';

  @override
  String get sectionToday => 'Aujourd\'hui';

  @override
  String get sectionSessions => 'Sessions';

  @override
  String get sectionInsights => 'Aperçus';

  @override
  String get onboardingGoalAdviceGettingStarted => 'Excellent départ! 🌟 Les petits pas mènent à de grandes victoires. Vous pouvez le faire!';

  @override
  String get onboardingGoalAdviceBuildingHabit => 'Excellent choix! 🎯 Ce point optimal construit des habitudes durables!';

  @override
  String get onboardingGoalAdviceRegularPractice => 'Ambitieux! 💪 Vous êtes prêt à améliorer votre concentration!';

  @override
  String get onboardingGoalAdviceDeepWork => 'Wow! 🏆 Mode travail profond activé! N\'oubliez pas de faire des pauses!';

  @override
  String get onboardingDuration10to15 => '10-15 minutes';

  @override
  String get onboardingDuration20to30 => '20-30 minutes';

  @override
  String get onboardingDuration40to60 => '40-60 minutes';

  @override
  String get onboardingDuration60plus => '60+ minutes';

  @override
  String get activityStudy => 'Étude';

  @override
  String get activityReading => 'Lecture';

  @override
  String get activityMeditation => 'Méditation';

  @override
  String get activityOther => 'Autre';

  @override
  String get onboardingTip1Description => 'Commencez par des sessions de 5-10 minutes. La constance bat la perfection!';

  @override
  String get onboardingTip2Description => 'Appuyez sur Mode Focus pour une expérience immersive sans distraction.';

  @override
  String get onboardingTip3Description => 'Utilisez votre jeton mensuel les jours chargés pour protéger votre série.';

  @override
  String get onboardingTip4Description => 'Visez 70% de temps calme - le silence parfait n\'est pas requis!';

  @override
  String get onboardingLaunchTitle => 'Vous Êtes Prêt à Commencer! 🚀';

  @override
  String get onboardingLaunchDescription => 'Commençons votre première session et créons des habitudes incroyables!';

  @override
  String get insightsBestTimeByActivity => 'Meilleur moment par activité';

  @override
  String get insightHighSuccessRateTitle => 'Taux de réussite élevé';

  @override
  String get insightEnvironmentStabilityTitle => 'Stabilité de l\'environnement';

  @override
  String get insightLowNoiseSuccessTitle => 'Succès à faible bruit';

  @override
  String get insightConsistentPracticeTitle => 'Pratique cohérente';

  @override
  String get insightStreakProtectionTitle => 'Protection contre les traces disponible';

  @override
  String get insightRoomTooNoisyTitle => 'Chambre trop bruyante';

  @override
  String get insightIrregularScheduleTitle => 'Horaire irrégulier';

  @override
  String get insightLowAmbientScoreTitle => 'Faible score ambiant';

  @override
  String get insightNoRecentSessionsTitle => 'Aucune session récente';

  @override
  String get insightHighSuccessRateDesc => 'Vous maintenez de fortes sessions silencieuses.';

  @override
  String get insightEnvironmentStabilityDesc => 'Le bruit ambiant se situe dans une plage modérée et gérable.';

  @override
  String get insightLowNoiseSuccessDesc => 'Votre environnement est exceptionnellement calme pendant les séances.';

  @override
  String get insightConsistentPracticeDesc => 'Vous développez une habitude de pratique quotidienne fiable.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'Vous disposez de $count jeton(s) de gel pour protéger votre séquence.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Essayez de trouver un espace plus calme ou d\'ajuster votre seuil.';

  @override
  String get insightIrregularScheduleDesc => 'Des durées de séance plus cohérentes peuvent améliorer votre séquence.';

  @override
  String get insightLowAmbientScoreDesc => 'Les sessions récentes ont eu un temps de silence inférieur. Essayez un environnement plus calme.';

  @override
  String get insightNoRecentSessionsDesc => 'Commencez une séance aujourd’hui pour développer votre habitude de concentration !';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return 'Super travail ! $minutes minutes de concentration dans votre session ! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return 'Bon effort ! $minutes minutes terminées.';
  }

  @override
  String get sessionCompleteFailed => 'Séance terminée. Réessayez lorsque vous êtes prêt.';

  @override
  String get notificationSessionStarted => 'Session commencée – restez concentré !';

  @override
  String get notificationSessionPaused => 'Séance interrompue';

  @override
  String get notificationSessionResumed => 'Reprise de la séance';
}
