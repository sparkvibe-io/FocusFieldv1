// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Preparando motor de enfoque…';

  @override
  String get paywallTitle => 'Entrena un enfoque más profundo con Premium';

  @override
  String get featureExtendSessions => 'Amplía sesiones de enfoque de 5 min a 120 min';

  @override
  String get featureHistory => 'Accede a 90 días de sesiones pasadas';

  @override
  String get featureMetrics => 'Desbloquea métricas de rendimiento y gráficos de tendencias';

  @override
  String get featureExport => 'Descarga tus datos de sesión (CSV / PDF)';

  @override
  String get featureThemes => 'Usa todo el paquete de temas';

  @override
  String get featureThreshold => 'Ajusta el umbral con la base ambiental';

  @override
  String get featureSupport => 'Ayuda más rápida y acceso anticipado';

  @override
  String get subscribeCta => 'Continuar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get privacyPolicy => 'Privacidad';

  @override
  String get termsOfService => 'Términos';

  @override
  String get manageSubscription => 'Gestionar';

  @override
  String get legalDisclaimer => 'Suscripción auto‑renovable. Cancela en cualquier momento en los ajustes de la tienda.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutos de silencio logrados ✨',
      one: '# minuto de silencio logrado ✨',
    );
    return '¡Gran trabajo! $_temp0';
  }

  @override
  String get minutes => 'minutos';

  @override
  String get minute => 'minuto';

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get settings => 'Ajustes';

  @override
  String get themes => 'Temas';

  @override
  String get analytics => 'Analítica';

  @override
  String get history => 'Historial';

  @override
  String get startSession => 'Iniciar sesión';

  @override
  String get stopSession => 'Detener';

  @override
  String get pauseSession => 'Pausar';

  @override
  String get resumeSession => 'Reanudar';

  @override
  String get sessionSaved => 'Sesión guardada';

  @override
  String get copied => 'Copiado';

  @override
  String get errorGeneric => 'Algo salió mal';

  @override
  String get permissionMicrophoneDenied => 'Permiso de micrófono denegado';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get listeningStatus => 'Escuchando...';

  @override
  String get successPointMessage => '¡Silencio logrado! +1 punto';

  @override
  String get tooNoisyMessage => '¡Demasiado ruido! Intenta de nuevo';

  @override
  String get totalPoints => 'Puntos Totales';

  @override
  String get currentStreak => 'Racha Actual';

  @override
  String get bestStreak => 'Mejor Racha';

  @override
  String get welcomeMessage => 'Pulsa Iniciar para comenzar tu viaje de silencio';

  @override
  String get resetAllData => 'Restablecer todos los datos';

  @override
  String get resetDataConfirmation => '¿Seguro que deseas restablecer todo tu progreso?';

  @override
  String get resetDataSuccess => 'Datos restablecidos';

  @override
  String get decibelThresholdLabel => 'Umbral de decibelios';

  @override
  String get decibelThresholdHint => 'Establece el nivel máximo de ruido (dB)';

  @override
  String get microphonePermissionTitle => 'Permiso de micrófono';

  @override
  String get microphonePermissionMessage => 'Silence Score necesita acceso al micrófono para medir el ruido. No se almacena audio.';

  @override
  String get permissionDeniedMessage => 'Se requiere permiso de micrófono. Actívalo en ajustes.';

  @override
  String get noiseMeterError => 'No se puede acceder al micrófono';

  @override
  String get premiumFeaturesTitle => 'Funciones Premium';

  @override
  String get premiumDescription => 'Desbloquea sesiones extendidas, analítica avanzada y exportación';

  @override
  String get premiumRequiredMessage => 'Esta función requiere Premium';

  @override
  String get subscriptionSuccessMessage => '¡Suscripción exitosa!';

  @override
  String get subscriptionErrorMessage => 'No se pudo procesar la suscripción';

  @override
  String get restoreSuccessMessage => 'Compras restauradas';

  @override
  String get restoreErrorMessage => 'No se encontraron compras';

  @override
  String get yearlyPlanTitle => 'Anual';

  @override
  String get monthlyPlanTitle => 'Mensual';

  @override
  String savePercent(String percent) {
    return 'AHORRA $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Facturado a $price/año';
  }

  @override
  String billedMonthly(String price) {
    return 'Facturado a $price/mes';
  }

  @override
  String get mockSubscriptionsBanner => 'Suscripciones simuladas activas';

  @override
  String get splashTagline => 'Encuentra tu quietud';

  @override
  String get appIconSemantic => 'Icono de la app';

  @override
  String get tabBasic => 'Básico';

  @override
  String get tabAdvanced => 'Avanzado';

  @override
  String get tabAbout => 'Acerca de';

  @override
  String get resetAllSettings => 'Restablecer todos los ajustes';

  @override
  String get resetAllSettingsDescription => 'Esto restablecerá todos los ajustes y datos. No se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Restablecer';

  @override
  String get allSettingsReset => 'Todos los ajustes y datos fueron restablecidos';

  @override
  String get decibelThresholdMaxNoise => 'Umbral de decibelios (ruido máx)';

  @override
  String get highThresholdWarningText => 'Un umbral alto puede ignorar ruidos importantes.';

  @override
  String get decibelThresholdTooltip => 'Espacios silenciosos típicos: 30–40 dB. Calibra; sube solo si el zumbido cuenta como ruido.';

  @override
  String get sessionDuration => 'Duración de la sesión';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Mejora para ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Gratis: hasta $minutes min';
  }

  @override
  String get durationLabel => 'Duración';

  @override
  String get minutesShort => 'min';

  @override
  String get noiseCalibration => 'Calibración de ruido';

  @override
  String get calibrateBaseline => 'Calibrar base';

  @override
  String get unlockAdvancedCalibration => 'Desbloquea calibración avanzada de ruido';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get sessionHistory => 'Historial de sesiones';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get remindersCelebrations => 'Recordatorios y celebraciones';

  @override
  String get accessibility => 'Accesibilidad';

  @override
  String get accessibilityFeatures => 'Funciones de accesibilidad';

  @override
  String get appInformation => 'Información de la app';

  @override
  String get version => 'Versión';

  @override
  String get bundleId => 'ID de paquete';

  @override
  String get environment => 'Entorno';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get faq => 'FAQ';

  @override
  String get support => 'Soporte';

  @override
  String get rateApp => 'Calificar';

  @override
  String errorLoadingSettings(String error) {
    return 'Error cargando ajustes: $error';
  }

  @override
  String get exportNoData => 'No hay datos para exportar';

  @override
  String chooseExportFormat(int sessions) {
    return 'Elige formato para tus $sessions sesiones:';
  }

  @override
  String get csvSpreadsheet => 'Hoja de cálculo CSV';

  @override
  String get rawDataForAnalysis => 'Datos crudos para análisis';

  @override
  String get pdfReport => 'Informe PDF';

  @override
  String get formattedReportWithCharts => 'Informe formateado con gráficos';

  @override
  String generatingExport(String format) {
    return 'Generando exportación $format...';
  }

  @override
  String exportCompleted(String format) {
    return 'Exportación $format completada';
  }

  @override
  String exportFailed(String error) {
    return 'Fallo en exportación: $error';
  }

  @override
  String get frequentlyAskedQuestions => 'Preguntas frecuentes';

  @override
  String get faqHowWorksQ => '¿Cómo funciona Silence Score?';

  @override
  String get faqHowWorksA => 'Mide el ruido ambiente: el tiempo por debajo del umbral gana puntos.';

  @override
  String get faqAudioRecordedQ => '¿Se graba audio?';

  @override
  String get faqAudioRecordedA => 'No. Solo se toman niveles de decibelios; nunca se guarda audio.';

  @override
  String get faqAdjustSensitivityQ => '¿Ajustar sensibilidad?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Usa Ajustes > Básico > Umbral de decibelios ($min–$max dB) y calibra primero.';
  }

  @override
  String get faqPremiumFeaturesQ => '¿Funciones Premium?';

  @override
  String get faqPremiumFeaturesA => 'Sesiones extendidas (hasta 120m), analítica avanzada, exportación, temas.';

  @override
  String get faqNotificationsQ => '¿Notificaciones?';

  @override
  String get faqNotificationsA => 'Recordatorios inteligentes aprenden hábitos y celebran hitos.';

  @override
  String get close => 'Cerrar';

  @override
  String get supportTitle => 'Soporte';

  @override
  String responseTimeLabel(String time) {
    return 'Tiempo de respuesta: $time';
  }

  @override
  String get docs => 'Docs';

  @override
  String get contactSupport => 'Contactar soporte';

  @override
  String get emailOpenDescription => 'Abre tu correo con información del sistema pre‑rellenada';

  @override
  String get subject => 'Asunto';

  @override
  String get briefDescription => 'Descripción breve';

  @override
  String get description => 'Descripción';

  @override
  String get issueDescriptionHint => 'Describe tu problema...';

  @override
  String get openingEmail => 'Abriendo correo...';

  @override
  String get openEmailApp => 'Abrir app de correo';

  @override
  String get fillSubjectDescription => 'Rellena asunto y descripción';

  @override
  String get emailOpened => 'App de correo abierta. Envía cuando quieras.';

  @override
  String get noEmailAppFound => 'No se encontró app de correo. Contacto:';

  @override
  String standardSubject(String subject) {
    return 'Asunto: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Incidencia: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'Error al abrir FAQ: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Error al abrir documentación: $error';
  }

  @override
  String get accessibilitySettings => 'Ajustes de accesibilidad';

  @override
  String get vibrationFeedback => 'Vibración';

  @override
  String get vibrateOnSessionEvents => 'Vibrar en eventos';

  @override
  String get voiceAnnouncements => 'Anuncios de voz';

  @override
  String get announceSessionProgress => 'Anunciar progreso';

  @override
  String get highContrastMode => 'Alto contraste';

  @override
  String get improveVisualAccessibility => 'Mejora visual';

  @override
  String get largeText => 'Texto grande';

  @override
  String get increaseTextSize => 'Aumentar tamaño';

  @override
  String get save => 'Guardar';

  @override
  String get accessibilitySettingsSaved => 'Ajustes de accesibilidad guardados';

  @override
  String get noiseFloorCalibration => 'Calibración de ruido base';

  @override
  String get measuringAmbientNoise => 'Midiendo ruido ambiente (≈5s)...';

  @override
  String get couldNotReadMic => 'No se pudo leer el micrófono';

  @override
  String get calibrationFailed => 'Fallo de calibración';

  @override
  String get retry => 'Reintentar';

  @override
  String previousThreshold(double value) {
    return 'Anterior: $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'Nuevo umbral: $value dB';
  }

  @override
  String get noSignificantChange => 'Sin cambio significativo';

  @override
  String get highAmbientDetected => 'Alto ruido ambiente detectado';

  @override
  String get adjustAnytimeSettings => 'Puedes ajustarlo en Ajustes';

  @override
  String get toggleThemeTooltip => 'Cambiar tema';

  @override
  String get audioChartRecovering => 'Recuperando gráfico de audio...';

  @override
  String themeChanged(String themeName) {
    return 'Tema: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Iniciar sesión';

  @override
  String get stopSessionButton => 'Detener';

  @override
  String get statusListening => 'Escuchando...';

  @override
  String get statusSuccess => '¡Silencio logrado! +1 punto';

  @override
  String get statusFailure => '¡Demasiado ruido!';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get exportCsvSpreadsheet => 'Hoja CSV';

  @override
  String get exportPdfReport => 'Informe PDF';

  @override
  String get formattedReportCharts => 'Informe con gráficos';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Tema';

  @override
  String get open => 'Abrir';

  @override
  String get microphone => 'Micrófono';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sesiones';

  @override
  String get format => 'formato';

  @override
  String get successRate => 'Tasa de éxito';

  @override
  String get avgSession => 'Sesión prom.';

  @override
  String get consistency => 'Consistencia';

  @override
  String get bestTime => 'Mejor tiempo';

  @override
  String get weeklyTrends => 'Tendencias semanales';

  @override
  String get performanceMetrics => 'Métricas de rendimiento';

  @override
  String get advancedAnalytics => 'Analítica avanzada';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get sessionHistoryTitle => 'Historial de sesiones';

  @override
  String get recentSessionHistory => 'Historial reciente';

  @override
  String get achievementFirstStepTitle => 'Primer paso';

  @override
  String get achievementFirstStepDesc => 'Completaste tu primera sesión';

  @override
  String get achievementOnFireTitle => 'En racha';

  @override
  String get achievementOnFireDesc => 'Racha de 3 días';

  @override
  String get achievementWeekWarriorTitle => 'Guerrero semanal';

  @override
  String get achievementWeekWarriorDesc => 'Racha de 7 días';

  @override
  String get achievementDecadeTitle => 'Década';

  @override
  String get achievementDecadeDesc => 'Hito de 10 puntos';

  @override
  String get achievementHalfCenturyTitle => 'Media centena';

  @override
  String get achievementHalfCenturyDesc => 'Hito de 50 puntos';

  @override
  String get achievementLockedPrompt => 'Completa sesiones para desbloquear logros';
}
