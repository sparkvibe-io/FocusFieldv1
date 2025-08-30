// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Préparation du moteur de focus…';

  @override
  String get paywallTitle => 'Entraînez une concentration plus profonde avec Premium';

  @override
  String get featureExtendSessions => 'Étendez les sessions de 5 min à 120 min';

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
  String get microphonePermissionMessage => 'Silence Score nécessite l\'accès au micro pour mesurer le bruit. Aucun audio stocké.';

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
  String get faqHowWorksQ => 'Comment fonctionne Silence Score ?';

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
}
