// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Preparando motor de enfoque…';

  @override
  String get paywallTitle => 'Entrena un enfoque más profundo con Premium';

  @override
  String get featureExtendSessions => 'Amplía sesiones de enfoque de 30 min a 120 min';

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
  String get microphonePermissionMessage => 'Focus Field mide los niveles de sonido ambiente para ayudarte a mantener entornos silenciosos.\n\nLa aplicación necesita acceso al micrófono para detectar el silencio, pero no graba ningún audio.';

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
  String get upgradeRequired => 'Se requiere actualización';

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

  @override
  String get ratingPromptTitle => '¿Disfrutas Focus Field?';

  @override
  String get ratingPromptBody => 'Una valoración 5★ rápida ayuda a otros a descubrir calma.';

  @override
  String get ratingPromptRateNow => 'Calificar ahora';

  @override
  String get ratingPromptLater => 'Más tarde';

  @override
  String get ratingPromptNoThanks => 'No, gracias';

  @override
  String get ratingThankYou => '¡Gracias por tu apoyo!';

  @override
  String get notificationSettingsTitle => 'Ajustes de notificaciones';

  @override
  String get notificationPermissionRequired => 'Permiso requerido';

  @override
  String get notificationPermissionRationale => 'Activa notificaciones para recordatorios suaves y celebrar logros.';

  @override
  String get requesting => 'Solicitando...';

  @override
  String get enableNotificationsCta => 'Activar notificaciones';

  @override
  String get enableNotificationsTitle => 'Activar notificaciones';

  @override
  String get enableNotificationsSubtitle => 'Permite a Focus Field enviar notificaciones';

  @override
  String get dailyReminderTitle => 'Recordatorio diario inteligente';

  @override
  String get dailyReminderSubtitle => 'Inteligente o hora fija';

  @override
  String get dailyTimeLabel => 'Hora diaria';

  @override
  String get dailyTimeHint => 'Elige hora fija o deja que la app aprenda tu patrón.';

  @override
  String get useSmartCta => 'Usar inteligente';

  @override
  String get sessionCompletedTitle => 'Sesión completada';

  @override
  String get sessionCompletedSubtitle => 'Celebrar sesiones completadas';

  @override
  String get achievementUnlockedTitle => 'Logro desbloqueado';

  @override
  String get achievementUnlockedSubtitle => 'Notificaciones de hitos';

  @override
  String get weeklySummaryTitle => 'Resumen semanal';

  @override
  String get weeklySummarySubtitle => 'Resumen semanal (día & hora)';

  @override
  String get weeklyTimeLabel => 'Hora semanal';

  @override
  String get notificationPreview => 'Vista Previa de Notificación';

  @override
  String get dailySilenceReminderTitle => 'Recordatorio diario de enfoque';

  @override
  String get weeklyProgressReportTitle => 'Progreso semanal 📊';

  @override
  String get achievementUnlockedGenericTitle => '¡Logro desbloqueado! 🏆';

  @override
  String get sessionCompleteSuccessTitle => '¡Sesión lista! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Sesión finalizada';

  @override
  String get reminderStartJourney => '🎯 ¡Comienza hoy tu viaje de enfoque! Construye tu hábito de trabajo profundo.';

  @override
  String get reminderRestart => '🌱 ¿Listo para reiniciar tu práctica de enfoque? Cada momento es un nuevo comienzo.';

  @override
  String get reminderDayTwo => '⭐ ¡Día 2 de tu racha de enfoque! La constancia crea concentración.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 ¡Racha de $streak días! Construyes un hábito de enfoque poderoso.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Impresionante racha de $streak días. ¡Inspiras dedicación!';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Increíble racha de $streak días. ¡Eres un campeón de enfoque!';
  }

  @override
  String get achievementFirstSession => '🎉 ¡Primera sesión lograda! ¡Bienvenido a Focus Field!';

  @override
  String get achievementWeekStreak => '🌟 ¡Racha de 7 días! La constancia es tu superpoder.';

  @override
  String get achievementMonthStreak => '🏆 ¡Racha de 30 días desbloqueada! Imparable.';

  @override
  String get achievementPerfectSession => '✨ ¡Sesión perfecta! ¡Ambiente tranquilo al 100%!';

  @override
  String get achievementLongSession => '⏰ Sesión larga dominada. Tu enfoque crece.';

  @override
  String get achievementGeneric => '🎊 Logro desbloqueado. ¡Sigue así!';

  @override
  String get weeklyProgressNone => '💭 ¡Comienza tu meta semanal! ¿Listo para una sesión enfocada?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 ¡$count minutos de enfoque esta semana! Cada sesión cuenta.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 ¡$count minutos de enfoque ganados! ¡Vas por buen camino!';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 ¡$count minutos de enfoque logrados! ¡Semana perfecta!';
  }

  @override
  String get tipsHidden => 'Consejos ocultos';

  @override
  String get tipsShown => 'Consejos mostrados';

  @override
  String get showTips => 'Mostrar consejos';

  @override
  String get hideTips => 'Ocultar consejos';

  @override
  String get tip01 => 'Comienza pequeño—incluso 2 minutos construyen tu hábito de concentración.';

  @override
  String get tip02 => 'Tu racha tiene gracia—una falta no la romperá con la Regla de 2 Días.';

  @override
  String get tip03 => 'Prueba actividades de Estudio, Lectura o Meditación para que coincidan con tu estilo de concentración.';

  @override
  String get tip04 => 'Revisa tu Mapa de Calor de 12 semanas para ver cómo se acumulan las pequeñas victorias con el tiempo.';

  @override
  String get tip05 => 'Observa tu % de Calma en vivo durante las sesiones—¡puntuaciones más altas significan mejor concentración!';

  @override
  String get tip06 => 'Personaliza tu objetivo diario (10-60 min) para que coincida con tu ritmo.';

  @override
  String get tip07 => 'Usa tu Token de Congelación mensual para proteger tu racha en días difíciles.';

  @override
  String get tip08 => 'Después de 3 victorias, Focus Field sugiere un umbral más estricto—¿listo para subir de nivel?';

  @override
  String get tip09 => '¿Ruido ambiente alto? Aumenta tu umbral para mantenerte en la zona.';

  @override
  String get tip10 => 'Los Recordatorios Diarios Inteligentes aprenden tu mejor momento—déjalos guiarte.';

  @override
  String get tip11 => 'El anillo de progreso es tocable—un toque inicia tu sesión de concentración.';

  @override
  String get tip12 => 'Recalibra cuando tu entorno cambie para mejor precisión.';

  @override
  String get tip13 => '¡Las notificaciones de sesión celebran tus victorias—actívalas para motivación!';

  @override
  String get tip14 => 'La consistencia vence a la perfección—aparece, incluso en días ocupados.';

  @override
  String get tip15 => 'Prueba diferentes momentos del día para descubrir tu punto dulce tranquilo.';

  @override
  String get tip16 => 'Tu progreso diario siempre está visible—toca Ir para comenzar en cualquier momento.';

  @override
  String get tip17 => 'Cada actividad rastrea por separado hacia tu objetivo—la variedad lo mantiene fresco.';

  @override
  String get tip18 => 'Exporta tus datos (Premium) para ver tu viaje completo de concentración.';

  @override
  String get tip19 => '¡El confeti celebra cada finalización—las pequeñas victorias merecen reconocimiento!';

  @override
  String get tip20 => 'Tu línea base importa—calibra al mudarte a nuevos espacios.';

  @override
  String get tip21 => 'Tus Tendencias de 7 Días revelan patrones—revísalas semanalmente para obtener información.';

  @override
  String get tip22 => 'Actualiza la duración de la sesión (Premium) para bloques de concentración profunda más largos.';

  @override
  String get tip23 => 'El enfoque es una práctica—las sesiones pequeñas construyen el hábito que deseas.';

  @override
  String get tip24 => 'El Resumen Semanal muestra tu ritmo—ajústalo a tu horario.';

  @override
  String get tip25 => 'Ajusta tu umbral para tu espacio—cada habitación es diferente.';

  @override
  String get tip26 => 'Las opciones de accesibilidad ayudan a todos a concentrarse—alto contraste, texto grande, vibración.';

  @override
  String get tip27 => 'La Línea de Tiempo de Hoy muestra cuándo te concentraste—encuentra tus horas productivas.';

  @override
  String get tip28 => 'Termina lo que comienzas—sesiones más cortas significan más finalizaciones.';

  @override
  String get tip29 => 'Los Minutos Silenciosos se suman hacia tu objetivo—progreso sobre perfección.';

  @override
  String get tip30 => 'Estás a un toque de distancia—comienza una sesión pequeña ahora mismo.';

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
  String get tipInstructionHeatmap => 'Pestaña Resumen → Mostrar Más → Mapa de Calor';

  @override
  String get tipInstructionTodayTimeline => 'Pestaña Resumen → Mostrar Más → Línea de Tiempo de Hoy';

  @override
  String get tipInstruction7DayTrends => 'Pestaña Resumen → Mostrar Más → Tendencias de 7 Días';

  @override
  String get tipInstructionEditActivities => 'Pestaña Actividad → toca Editar para mostrar/ocultar actividades';

  @override
  String get tipInstructionQuestGo => 'Pestaña Actividad → Cápsula de Misión → toca Ir';

  @override
  String get tipInfoTooltip => 'Mostrar consejo';

  @override
  String get questCapsuleTitle => 'Misión Ambiental';

  @override
  String get questCapsuleLoading => 'Cargando minutos de calma…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Calma $progress/$goal min • Racha $streak';
  }

  @override
  String get questFreezeButton => 'Congelar';

  @override
  String get questFrozenToday => 'Hoy congelado — estás cubierto.';

  @override
  String get questGoButton => 'Ir';

  @override
  String calmPercent(int percent) {
    return 'Calma $percent%';
  }

  @override
  String get calmLabel => 'Calma';

  @override
  String get day => 'día';

  @override
  String get days => 'días';

  @override
  String get freeze => 'congelar';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '¡3 victorias! ¿Probar $threshold dB?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Ahora no';

  @override
  String get adaptiveThresholdTryIt => 'Probarlo';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Umbral establecido en $threshold dB';
  }

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get error => 'Error';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get faqTitle => 'Preguntas Frecuentes';

  @override
  String get faqSearchHint => 'Buscar preguntas...';

  @override
  String get faqNoResults => 'No se encontraron resultados';

  @override
  String get faqNoResultsSubtitle => 'Intenta con un término diferente';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados encontrados',
      one: '1 resultado encontrado',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => '¿Qué es Focus Field y cómo me ayuda a concentrarme?';

  @override
  String get faqA01 => 'Focus Field te ayuda a desarrollar mejores hábitos de concentración monitoreando el ruido ambiental en tu entorno. Cuando inicias una sesión (Estudio, Lectura, Meditación u Otro), la app mide qué tan silencioso está tu ambiente. Cuanto más silencio mantengas, más \"minutos de concentración\" ganas. Esto te anima a encontrar y mantener espacios libres de distracciones para trabajo profundo.';

  @override
  String get faqQ02 => '¿Cómo mide Focus Field mi concentración?';

  @override
  String get faqA02 => 'Focus Field monitorea el nivel de ruido ambiental en tu entorno durante tu sesión. Calcula un \"Puntaje Ambiental\" rastreando cuántos segundos tu ambiente permanece por debajo de tu umbral de ruido elegido. Si tu sesión tiene al menos 70% de tiempo silencioso (Puntaje Ambiental ≥70%), obtienes crédito completo por esos minutos silenciosos.';

  @override
  String get faqQ03 => '¿Focus Field graba mi audio o conversaciones?';

  @override
  String get faqA03 => 'No, absolutamente no. Focus Field solo mide niveles de decibelios (volumen) - nunca graba, almacena ni transmite audio. Tu privacidad está completamente protegida. La app simplemente verifica si tu ambiente está por encima o por debajo de tu umbral elegido.';

  @override
  String get faqQ04 => '¿Qué actividades puedo rastrear con Focus Field?';

  @override
  String get faqA04 => 'Focus Field viene con cuatro tipos de actividad: Estudio 📚 (para aprendizaje e investigación), Lectura 📖 (para lectura concentrada), Meditación 🧘 (para práctica de atención plena) y Otro ⭐ (para cualquier actividad que requiera concentración). Todas las actividades usan monitoreo de ruido ambiental para ayudarte a mantener un ambiente silencioso y concentrado.';

  @override
  String get faqQ05 => '¿Debería usar Focus Field para todas mis actividades?';

  @override
  String get faqA05 => 'Focus Field funciona mejor para actividades donde el ruido ambiental indica tu nivel de concentración. Actividades como Estudio, Lectura y Meditación se benefician más de ambientes silenciosos. Aunque puedes rastrear actividades \"Otro\", recomendamos usar Focus Field principalmente para trabajo de concentración sensible al ruido.';

  @override
  String get faqQ06 => '¿Cómo inicio una sesión de concentración?';

  @override
  String get faqA06 => 'Ve a la pestaña Sesiones, selecciona tu actividad (Estudio, Lectura, Meditación u Otro), elige la duración de tu sesión (1, 5, 10, 15, 30 minutos u opciones premium), toca el botón Iniciar en el anillo de progreso y ¡mantén tu ambiente silencioso!';

  @override
  String get faqQ07 => '¿Qué duraciones de sesión están disponibles?';

  @override
  String get faqA07 => 'Los usuarios gratuitos pueden elegir: sesiones de 1, 5, 10, 15 o 30 minutos. Los usuarios Premium también obtienen: sesiones extendidas de 1 hora, 1.5 horas y 2 horas para períodos más largos de trabajo profundo.';

  @override
  String get faqQ08 => '¿Puedo pausar o detener una sesión antes de tiempo?';

  @override
  String get faqA08 => '¡Sí! Durante una sesión, verás botones de Pausa y Detener sobre el anillo de progreso. Para evitar toques accidentales, necesitas mantener presionados estos botones. Si detienes antes, aún ganarás puntos por los minutos silenciosos que acumulaste.';

  @override
  String get faqQ09 => '¿Cómo gano puntos en Focus Field?';

  @override
  String get faqA09 => 'Ganas 1 punto por minuto silencioso. Durante tu sesión, Focus Field rastrea cuántos segundos tu ambiente permanece por debajo del umbral de ruido. Al final, esos segundos silenciosos se convierten en minutos. Por ejemplo, si completas una sesión de 10 minutos con 8 minutos de silencio, ganas 8 puntos.';

  @override
  String get faqQ10 => '¿Qué es el umbral del 70% y por qué importa?';

  @override
  String get faqA10 => 'El umbral del 70% determina si tu sesión cuenta para tu meta diaria. Si tu Puntaje Ambiental (tiempo silencioso ÷ tiempo total) es al menos 70%, tu sesión califica para crédito de misión. ¡Incluso si estás por debajo del 70%, aún ganas puntos por cada minuto silencioso!';

  @override
  String get faqQ11 => '¿Cuál es la diferencia entre Puntaje Ambiental y puntos?';

  @override
  String get faqA11 => 'El Puntaje Ambiental es la calidad de tu sesión como porcentaje (segundos silenciosos ÷ segundos totales), determinando si alcanzas el umbral del 70%. Los puntos son los minutos silenciosos reales ganados (1 punto = 1 minuto). Puntaje Ambiental = calidad, Puntos = logro.';

  @override
  String get faqQ12 => '¿Cómo funcionan las rachas en Focus Field?';

  @override
  String get faqA12 => 'Las rachas rastrean días consecutivos cumpliendo tu meta diaria. Focus Field usa una Regla Compasiva de 2 Días: Tu racha solo se rompe si pierdes dos días consecutivos. Esto significa que puedes perder un día y tu racha continúa si completas tu meta al día siguiente.';

  @override
  String get faqQ13 => '¿Qué son las fichas de congelación y cómo las uso?';

  @override
  String get faqA13 => 'Las fichas de congelación protegen tu racha cuando no puedes completar tu meta. Obtienes 1 ficha de congelación gratis por mes. Cuando se usa, tu progreso general muestra 100% (meta protegida), tu racha está segura y el seguimiento de actividad individual continúa normalmente. ¡Úsala sabiamente para días ocupados!';

  @override
  String get faqQ14 => '¿Puedo personalizar mi meta diaria de concentración?';

  @override
  String get faqA14 => '¡Sí! Toca Editar en la tarjeta Sesiones en la pestaña Hoy. Puedes establecer tu meta diaria global (10-60 minutos gratis, hasta 1080 minutos premium), habilitar metas por actividad para objetivos separados y mostrar/ocultar actividades específicas.';

  @override
  String get faqQ15 => '¿Qué es el umbral de ruido y cómo lo ajusto?';

  @override
  String get faqA15 => 'El umbral es el nivel máximo de ruido (en decibelios) que cuenta como \"silencioso\". El predeterminado es 40 dB (biblioteca silenciosa). Puedes ajustarlo en la pestaña Sesiones: 30 dB (muy silencioso), 40 dB (biblioteca silenciosa - recomendado), 50 dB (oficina moderada), 60-80 dB (ambientes más ruidosos).';

  @override
  String get faqQ16 => '¿Qué es el Umbral Adaptativo y debería usarlo?';

  @override
  String get faqA16 => 'Después de 3 sesiones exitosas consecutivas en tu umbral actual, Focus Field sugiere aumentarlo en 2 dB para desafiarte. Esto te ayuda a mejorar gradualmente. Puedes aceptar o rechazar la sugerencia; solo aparece una vez cada 7 días.';

  @override
  String get faqQ17 => '¿Qué es el Modo de Concentración?';

  @override
  String get faqA17 => 'El Modo de Concentración es una superposición de pantalla completa libre de distracciones durante tu sesión. Muestra tu temporizador de cuenta regresiva, porcentaje de calma en vivo y controles mínimos (Pausa/Detener mediante mantener presionado). Elimina todos los demás elementos de UI para que puedas concentrarte completamente. Habilítalo en Configuración > Básico > Modo de Concentración.';

  @override
  String get faqQ18 => '¿Por qué Focus Field necesita permiso de micrófono?';

  @override
  String get faqA18 => 'Focus Field usa el micrófono de tu dispositivo para medir niveles de ruido ambiental (decibelios) durante las sesiones. Esto es esencial para calcular tu Puntaje Ambiental. Recuerda: nunca se graba audio, solo se miden los niveles de ruido en tiempo real.';

  @override
  String get faqQ19 => '¿Puedo ver mis patrones de concentración a lo largo del tiempo?';

  @override
  String get faqA19 => '¡Sí! La pestaña Hoy muestra tu progreso diario, tendencias semanales, mapa de calor de actividad de 12 semanas (como contribuciones de GitHub) y línea de tiempo de sesiones. Los usuarios Premium obtienen análisis avanzados con métricas de rendimiento, promedios móviles e información impulsada por IA.';

  @override
  String get faqQ20 => '¿Cómo funcionan las notificaciones en Focus Field?';

  @override
  String get faqA20 => 'Focus Field tiene recordatorios inteligentes: Recordatorios Diarios (aprende tu hora de concentración preferida o usa una hora fija), notificaciones de Sesión Completada con resultados, notificaciones de Logros para hitos y Resumen Semanal (Premium). Habilita/personaliza en Configuración > Avanzado > Notificaciones.';

  @override
  String get microphoneSettingsTitle => 'Configuración Requerida';

  @override
  String get microphoneSettingsMessage => 'Para habilitar la detección de silencio, otorga manualmente el permiso del micrófono:\n\n• iOS: Ajustes > Privacidad y Seguridad > Micrófono > Focus Field\n• Android: Ajustes > Aplicaciones > Focus Field > Permisos > Micrófono';

  @override
  String get buttonGrantPermission => 'Otorgar Permiso';

  @override
  String get buttonOk => 'Aceptar';

  @override
  String get buttonOpenSettings => 'Abrir Ajustes';

  @override
  String get onboardingBack => 'Atrás';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingGetStarted => 'Comenzar';

  @override
  String get onboardingWelcomeSnackbar => '¡Bienvenido! ¿Listo para comenzar tu primera sesión? 🚀';

  @override
  String get onboardingWelcomeTitle => '¡Bienvenido a\nFocus Field! 🎯';

  @override
  String get onboardingWelcomeSubtitle => '¡Tu viaje hacia un mejor enfoque comienza aquí!\nConstruyamos hábitos que perduren 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Rastrea Tu Enfoque';

  @override
  String get onboardingFeatureTrackDesc => '¡Ve tu progreso en tiempo real mientras construyes tu superpoder de enfoque! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Gana Recompensas';

  @override
  String get onboardingFeatureRewardsDesc => '¡Cada minuto silencioso cuenta! Colecciona puntos y celebra tus logros 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Construye Rachas';

  @override
  String get onboardingFeatureStreaksDesc => '¡Mantén el impulso! Nuestro sistema compasivo te mantiene motivado 🔥';

  @override
  String get onboardingEnvironmentTitle => '¿Dónde está tu Zona de Enfoque? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => '¡Elige tu entorno típico para que optimicemos tu espacio!';

  @override
  String get onboardingEnvQuietHomeTitle => 'Hogar Silencioso';

  @override
  String get onboardingEnvQuietHomeDesc => 'Dormitorio, oficina en casa tranquila';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Muy silencioso';

  @override
  String get onboardingEnvOfficeTitle => 'Oficina Típica';

  @override
  String get onboardingEnvOfficeDesc => 'Oficina estándar, biblioteca';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Silencio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusyTitle => 'Espacio Ocupado';

  @override
  String get onboardingEnvBusyDesc => 'Cafetería, espacio de trabajo compartido';

  @override
  String get onboardingEnvBusyDb => '50 dB - Ruido moderado';

  @override
  String get onboardingEnvNoisyTitle => 'Entorno Ruidoso';

  @override
  String get onboardingEnvNoisyDesc => 'Oficina abierta, espacio público';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Ruido más alto';

  @override
  String get onboardingEnvAdjustNote => 'Puedes ajustar esto en cualquier momento en Configuración';

  @override
  String get onboardingGoalTitle => '¡Establece tu Meta Diaria! 🎯';

  @override
  String get onboardingGoalSubtitle => '¿Cuánto tiempo de concentración te parece adecuado?\n(¡Puedes ajustar esto en cualquier momento!)';

  @override
  String get onboardingGoalStartingTitle => 'Comenzando';

  @override
  String get onboardingGoalStartingDuration => '10-15 minutos';

  @override
  String get onboardingGoalHabitTitle => 'Construyendo Hábito';

  @override
  String get onboardingGoalHabitDuration => '20-30 minutos';

  @override
  String get onboardingGoalPracticeTitle => 'Práctica Regular';

  @override
  String get onboardingGoalPracticeDuration => '40-60 minutos';

  @override
  String get onboardingGoalDeepWorkTitle => 'Trabajo Profundo';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ minutos';

  @override
  String get onboardingGoalAdvice1 => '¡Comienzo perfecto! 🌟 Los pequeños pasos llevan a grandes victorias. ¡Tú puedes!';

  @override
  String get onboardingGoalAdvice2 => '¡Excelente elección! 🎯 ¡Este punto ideal construye hábitos duraderos!';

  @override
  String get onboardingGoalAdvice3 => '¡Ambicioso! 💪 ¡Estás listo para subir de nivel tu juego de concentración!';

  @override
  String get onboardingGoalAdvice4 => '¡Guau! 🏆 ¡Modo de trabajo profundo activado! ¡Recuerda tomar descansos!';

  @override
  String get onboardingActivitiesTitle => '¡Elige Tus Actividades! ✨';

  @override
  String get onboardingActivitiesSubtitle => '¡Elige todas las que resuenen contigo!\n(Siempre puedes agregar más después)';

  @override
  String get onboardingActivityStudyTitle => 'Estudio';

  @override
  String get onboardingActivityStudyDesc => 'Aprendizaje, tareas, investigación';

  @override
  String get onboardingActivityReadingTitle => 'Lectura';

  @override
  String get onboardingActivityReadingDesc => 'Lectura profunda, artículos, libros';

  @override
  String get onboardingActivityMeditationTitle => 'Meditación';

  @override
  String get onboardingActivityMeditationDesc => 'Atención plena, ejercicios de respiración';

  @override
  String get onboardingActivityOtherTitle => 'Otro';

  @override
  String get onboardingActivityOtherDesc => 'Cualquier actividad que requiera concentración';

  @override
  String get onboardingActivitiesTip => 'Consejo profesional: ¡Focus Field brilla cuando silencio = concentración! 🤫✨';

  @override
  String get onboardingPermissionTitle => '¡Tu Privacidad Importa! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'Necesitamos acceso al micrófono para medir el ruido ambiente y ayudarte a concentrarte mejor';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'Sin Grabación';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'Solo medimos niveles de ruido, nunca grabamos audio';

  @override
  String get onboardingPrivacyLocalTitle => 'Solo Local';

  @override
  String get onboardingPrivacyLocalDesc => 'Todos los datos permanecen en tu dispositivo';

  @override
  String get onboardingPrivacyFirstTitle => 'Privacidad Primero';

  @override
  String get onboardingPrivacyFirstDesc => 'Tus conversaciones son completamente privadas';

  @override
  String get onboardingPermissionNote => 'Puedes otorgar permiso en la siguiente pantalla al iniciar tu primera sesión';

  @override
  String get onboardingTipsTitle => '¡Consejos Profesionales para el Éxito! 💡';

  @override
  String get onboardingTipsSubtitle => '¡Estos te ayudarán a aprovechar al máximo Focus Field!';

  @override
  String get onboardingTip1Title => '¡Comienza Pequeño, Gana Grande! 🌱';

  @override
  String get onboardingTip1Desc => 'Comienza con sesiones de 5-10 minutos. ¡La consistencia supera la perfección!';

  @override
  String get onboardingTip2Title => '¡Activa el Modo de Concentración! 🎯';

  @override
  String get onboardingTip2Desc => 'Toca Modo de Concentración para una experiencia inmersiva sin distracciones.';

  @override
  String get onboardingTip3Title => '¡Token de Congelación = Red de Seguridad! ❄️';

  @override
  String get onboardingTip3Desc => 'Usa tu token mensual en días ocupados para proteger tu racha.';

  @override
  String get onboardingTip4Title => '¡La Regla del 70% Funciona! 📈';

  @override
  String get onboardingTip4Desc => 'Apunta al 70% de tiempo silencioso - ¡no se requiere silencio perfecto!';

  @override
  String get onboardingReadyTitle => '¡Estás Listo para Despegar! 🚀';

  @override
  String get onboardingReadyDesc => '¡Comencemos tu primera sesión y construyamos hábitos increíbles!';

  @override
  String get questMotivation1 => 'El éxito nunca termina y el fracaso nunca es final';

  @override
  String get questMotivation2 => 'Progreso sobre perfección - cada minuto cuenta';

  @override
  String get questMotivation3 => 'Pequeños pasos diarios conducen a grandes cambios';

  @override
  String get questMotivation4 => 'Estás construyendo mejores hábitos, una sesión a la vez';

  @override
  String get questMotivation5 => 'La consistencia supera la intensidad';

  @override
  String get questMotivation6 => 'Cada sesión es una victoria, sin importar cuán corta';

  @override
  String get questMotivation7 => 'El enfoque es un músculo - te estás volviendo más fuerte';

  @override
  String get questMotivation8 => 'El viaje de mil millas comienza con un solo paso';

  @override
  String get questGo => 'Ir';

  @override
  String get questTapStart => 'Toca Inicio →';

  @override
  String get todayDashboardTitle => 'Tu Panel de Enfoque';

  @override
  String get todayFocusMinutes => 'Minutos de enfoque hoy';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Objetivo: $goalMinutes min • Calma ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Elige tu modo';

  @override
  String get todayDefaultActivities => 'Estudio • Lectura • Meditación';

  @override
  String get todayTooltipTips => 'Consejos';

  @override
  String get todayTooltipTheme => 'Tema';

  @override
  String get todayTooltipSettings => 'Configuración';

  @override
  String todayThemeChanged(String themeName) {
    return 'Tema cambiado a $themeName';
  }

  @override
  String get todayTabToday => 'Hoy';

  @override
  String get todayTabSessions => 'Sesiones';

  @override
  String get todayHelperText => 'Establece tu duración y rastrea tu tiempo. El historial de sesiones y análisis aparecerán en Resumen.';

  @override
  String get statPoints => 'Puntos';

  @override
  String get statStreak => 'Racha';

  @override
  String get statSessions => 'Sesiones';

  @override
  String get ringProgressTitle => 'Progreso del Anillo';

  @override
  String get ringOverall => 'General';

  @override
  String get ringOverallFrozen => 'General ❄️';

  @override
  String get sessionCalm => 'Calma';

  @override
  String get sessionStart => 'Iniciar';

  @override
  String get sessionStop => 'Detener';

  @override
  String get buttonEdit => 'Editar';

  @override
  String get durationUpTo1Hour => 'Sesiones de hasta 1 hora';

  @override
  String get durationUpTo1_5Hours => 'Sesiones de hasta 1.5 horas';

  @override
  String get durationUpTo2Hours => 'Sesiones de hasta 2 horas';

  @override
  String get durationExtended => 'Duraciones de sesión extendidas';

  @override
  String get durationExtendedAccess => 'Acceso a sesiones extendidas';

  @override
  String get noiseRoomLoudness => 'Volumen de la Habitación';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Umbral: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Umbral establecido en $db dB';
  }

  @override
  String get noiseHighDetected => 'Ruido alto detectado, por favor vaya a una habitación más silenciosa para un mejor enfoque';

  @override
  String get noiseThresholdExceededHint => 'Busque un lugar más silencioso o aumente el umbral →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return '¿Buscar un lugar más silencioso o aumentar a ${db}dB?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'Alto ruido detectado. ¿Aumentar a ${db}dB?';
  }

  @override
  String get noiseAtMaxThreshold => 'Ya está en el umbral máximo. Por favor, busque un lugar más silencioso.';

  @override
  String get noiseThresholdYes => 'Sí';

  @override
  String get noiseThresholdNo => 'No';

  @override
  String get trendsInsights => 'Perspectivas';

  @override
  String get trendsLast7Days => 'Últimos 7 Días';

  @override
  String get trendsShareWeeklySummary => 'Compartir resumen semanal';

  @override
  String get trendsLoading => 'Cargando...';

  @override
  String get trendsLoadingMetrics => 'Cargando métricas...';

  @override
  String get trendsNoData => 'Sin datos';

  @override
  String get trendsWeeklyTotal => 'Total Semanal';

  @override
  String get trendsBestDay => 'Mejor Día';

  @override
  String get trendsActivityHeatmap => 'Mapa de Calor de Actividad';

  @override
  String get trendsRecentActivity => 'Actividad reciente';

  @override
  String get trendsHeatmapError => 'No se puede cargar el mapa de calor';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mié';

  @override
  String get dayThu => 'Jue';

  @override
  String get dayFri => 'Vie';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get focusModeComplete => '¡Sesión Completa!';

  @override
  String get focusModeGreatSession => 'Gran sesión de enfoque';

  @override
  String get focusModeResume => 'Reanudar';

  @override
  String get focusModePause => 'Pausar';

  @override
  String get focusModeLongPressHint => 'Mantén presionado para pausar o detener';

  @override
  String get activityEditTitle => 'Editar Actividades';

  @override
  String get activityRecommendation => 'Recomendado: 10+ min por actividad para la construcción constante de hábitos';

  @override
  String get activityDailyGoals => 'Objetivos Diarios';

  @override
  String activityTotalHours(String hours) {
    return 'Total: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Por Actividad';

  @override
  String get activityExceedsLimit => 'El total excede el límite diario de 18 horas. Por favor reduce los objetivos.';

  @override
  String get activityGoalLabel => 'Objetivo';

  @override
  String get activityGoalDescription => 'Establece tu objetivo de enfoque diario (1 min - 18h)';

  @override
  String get shareYourProgress => 'Comparte Tu Progreso';

  @override
  String get shareTimeRange => 'Rango de Tiempo';

  @override
  String get shareCardSize => 'Tamaño de Tarjeta';

  @override
  String get analyticsPerformanceMetrics => 'Métricas de Rendimiento';

  @override
  String get analyticsPreferredDuration => 'Duración Preferida';

  @override
  String get analyticsUnavailable => 'Análisis no disponible';

  @override
  String get analyticsRestoreAttempt => 'Intentaremos restaurar esta sección en el próximo inicio de la aplicación.';

  @override
  String get audioUnavailable => 'Audio temporalmente no disponible';

  @override
  String get audioRecovering => 'El procesamiento de audio encontró un problema. Recuperando automáticamente...';

  @override
  String get shareQuietMinutes => 'MINUTOS TRANQUILOS';

  @override
  String get shareTopActivity => 'Actividad Principal';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Vista Previa';

  @override
  String get sharePinchToZoom => 'Pellizca para ampliar';

  @override
  String get shareGenerating => 'Generando...';

  @override
  String get shareButton => 'Compartir';

  @override
  String get shareTodayLabel => 'Hoy';

  @override
  String get shareWeeklyLabel => 'Semanal';

  @override
  String get shareTodayTitle => 'Tu Enfoque de Hoy';

  @override
  String get shareWeeklyTitle => 'Tu Enfoque Semanal';

  @override
  String get shareSubject => 'Mi Progreso en Focus Field';

  @override
  String get shareFormatSquare => 'Relación 1:1 • Compatibilidad universal';

  @override
  String get shareFormatPost => 'Relación 4:5 • Publicaciones de Instagram/Twitter';

  @override
  String get shareFormatStory => 'Relación 9:16 • Historias de Instagram';

  @override
  String get recapWeeklyTitle => 'Resumen Semanal';

  @override
  String get recapMinutes => 'Minutos';

  @override
  String recapStreak(int start, int end) {
    return 'Racha: $start → $end días';
  }

  @override
  String get recapTopActivity => 'Actividad Principal: ';

  @override
  String get practiceOverviewTitle => 'Resumen de Práctica';

  @override
  String get practiceLast7Days => 'Últimos 7 Días';

  @override
  String get audioMultipleErrors => 'Se detectaron múltiples errores de audio. Componente recuperándose...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Meta actual: $goal';
  }

  @override
  String get activitySaveChanges => 'Guardar Cambios';

  @override
  String get insightsTitle => 'Perspectivas';

  @override
  String get insightsTooltip => 'Ver perspectivas detalladas';

  @override
  String get statDays => 'DÍAS';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Total Hoy $done/$goal min, elige cualquier actividad';
  }

  @override
  String get premiumFeature => 'Función Premium';

  @override
  String get premiumFeatureAccess => 'Acceso a función premium';

  @override
  String get activityUnknown => 'Desconocido';

  @override
  String get insightsFirstSessionTitle => 'Completa tu primera sesión';

  @override
  String get insightsFirstSessionSubtitle => 'Comienza a rastrear tu tiempo de concentración, patrones de sesión y tendencias de puntuación ambiental';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Ambiente: $percent%';
  }

  @override
  String get sessionSuccess => 'Éxito';

  @override
  String get sessionFailed => 'Fallido';

  @override
  String get focusModeButton => 'Modo de enfoque';

  @override
  String get settingsDailyGoalsTitle => 'Objetivos Diarios';

  @override
  String get settingsFocusModeDescription => 'Minimiza las distracciones durante las sesiones con una superposición enfocada';

  @override
  String get settingsDeepFocusTitle => 'Enfoque Profundo';

  @override
  String get settingsDeepFocusDescription => 'Finalizar sesión si se abandona la aplicación';

  @override
  String get deepFocusDialogTitle => 'Enfoque Profundo';

  @override
  String get deepFocusEnableLabel => 'Habilitar Enfoque Profundo';

  @override
  String get deepFocusGracePeriodLabel => 'Período de gracia (segundos)';

  @override
  String get deepFocusExplanation => 'Cuando está habilitado, salir de la aplicación finalizará la sesión después del período de gracia.';

  @override
  String get notificationPermissionTitle => 'Habilitar Notificaciones';

  @override
  String get notificationPermissionExplanation => 'Focus Field necesita permiso de notificaciones para enviarte:';

  @override
  String get notificationBenefitReminders => 'Recordatorios diarios de enfoque';

  @override
  String get notificationBenefitCompletion => 'Alertas de sesión completada';

  @override
  String get notificationBenefitAchievements => 'Celebraciones de logros';

  @override
  String get notificationHowToEnableIos => 'Cómo habilitar en iOS:';

  @override
  String get notificationHowToEnableAndroid => 'Cómo habilitar en Android:';

  @override
  String get notificationStepsIos => '1. Toca \"Abrir Configuración\" abajo\n2. Toca \"Notificaciones\"\n3. Habilita \"Permitir Notificaciones\"';

  @override
  String get notificationStepsAndroid => '1. Toca \"Abrir Configuración\" abajo\n2. Toca \"Notificaciones\"\n3. Habilita \"Todas las notificaciones de Focus Field\"';

  @override
  String get aboutShowTips => 'Mostrar Consejos';

  @override
  String get aboutShowTipsDescription => 'Muestra consejos útiles al iniciar la aplicación y mediante el icono de bombilla. Los consejos aparecen cada 2-3 días.';

  @override
  String get aboutReplayOnboarding => 'Repetir Introducción';

  @override
  String get aboutReplayOnboardingDescription => 'Revisa el recorrido de la aplicación y configura tus preferencias nuevamente';

  @override
  String get buttonFaq => 'Preguntas Frecuentes';

  @override
  String get onboardingWelcomeMessage => '¡Bienvenido! ¿Listo para comenzar tu primera sesión? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Gana Recompensas';

  @override
  String get onboardingFeatureEarnDesc => '¡Cada minuto tranquilo cuenta! Colecciona puntos y celebra tus victorias 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Construye Rachas';

  @override
  String get onboardingFeatureBuildDesc => '¡Mantén el impulso! Nuestro sistema compasivo te mantiene motivado 🔥';

  @override
  String get onboardingEnvironmentDescription => '¡Elige tu entorno típico para que podamos optimizar tu espacio!';

  @override
  String get onboardingEnvQuietHome => 'Casa Tranquila';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Muy tranquilo';

  @override
  String get onboardingEnvOffice => 'Oficina Típica';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Silencio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusy => 'Espacio Concurrido';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Ruido moderado';

  @override
  String get onboardingEnvNoisy => 'Entorno Ruidoso';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Ruido alto';

  @override
  String get onboardingAdjustAnytime => 'Puedes ajustar esto en cualquier momento en Configuración';

  @override
  String get buttonGetStarted => 'Comenzar';

  @override
  String get buttonNext => 'Siguiente';

  @override
  String get errorActivityRequired => '⚠️ Debe habilitarse al menos una actividad';

  @override
  String get errorGoalExceeds => 'Los objetivos totales exceden el límite diario de 18 horas. Por favor, reduce los objetivos.';

  @override
  String get messageSaved => 'Configuración guardada';

  @override
  String get errorPermissionRequired => 'Se requiere permiso';

  @override
  String get notificationEnableReason => 'Habilita las notificaciones para recibir recordatorios y celebrar logros.';

  @override
  String get buttonEnableNotifications => 'Habilitar Notificaciones';

  @override
  String get buttonRequesting => 'Solicitando...';

  @override
  String get notificationDailyTime => 'Hora Diaria';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Recordatorio diario a las $time';
  }

  @override
  String get notificationLearning => 'aprendiendo';

  @override
  String notificationSmart(String time) {
    return 'Inteligente ($time)';
  }

  @override
  String get buttonUseSmart => 'Usar Inteligente';

  @override
  String get notificationSmartExplanation => 'Elige una hora fija o deja que Focus Field aprenda tu patrón.';

  @override
  String get notificationSessionComplete => 'Sesión Completada';

  @override
  String get notificationSessionCompleteDesc => 'Celebra sesiones completadas';

  @override
  String get notificationAchievement => 'Logro Desbloqueado';

  @override
  String get notificationAchievementDesc => 'Notificaciones de hitos';

  @override
  String get notificationWeekly => 'Resumen Semanal de Progreso';

  @override
  String get notificationWeeklyDesc => 'Información semanal (día y hora)';

  @override
  String get notificationWeeklyTime => 'Hora Semanal';

  @override
  String get notificationMilestone => 'Notificaciones de hitos';

  @override
  String get notificationWeeklyInsights => 'Informes semanales (día y hora)';

  @override
  String get notificationDailyReminder => 'Recordatorio diario';

  @override
  String get notificationComplete => 'Sesión completada';

  @override
  String get settingsSnackbar => 'Por favor, habilita las notificaciones en la configuración del dispositivo';

  @override
  String get shareCardTitle => 'Compartir tarjeta';

  @override
  String get shareYourWeek => 'Comparte tu semana';

  @override
  String get shareStyleGradient => 'Estilo degradado';

  @override
  String get shareStyleGradientDesc => 'Degradado audaz con números grandes';

  @override
  String get shareWeeklySummary => 'Resumen semanal';

  @override
  String get shareStyleAchievement => 'Estilo de logro';

  @override
  String get shareStyleAchievementDesc => 'Enfócate en los minutos totales de silencio';

  @override
  String get shareQuietMinutesWeek => 'Minutos de silencio esta semana';

  @override
  String get shareAchievementMessage => 'Construyendo un enfoque más profundo,\\nuna sesión a la vez';

  @override
  String get shareAchievementCard => 'Tarjeta de logro';

  @override
  String get shareTextOnly => 'Solo texto';

  @override
  String get shareTextOnlyDesc => 'Compartir como texto plano (sin imagen)';

  @override
  String get shareYourStreak => 'Comparte tu racha';

  @override
  String get shareAsCard => 'Compartir como tarjeta';

  @override
  String get shareAsCardDesc => 'Tarjeta visual hermosa';

  @override
  String get shareStreakCard => 'Tarjeta de racha';

  @override
  String get shareAsText => 'Compartir como texto';

  @override
  String get shareAsTextDesc => 'Mensaje de texto simple';

  @override
  String get shareErrorFailed => 'Error al compartir. Por favor, inténtalo de nuevo.';

  @override
  String get buttonShare => 'Compartir';

  @override
  String get initializingApp => 'Inicializando aplicación...';

  @override
  String initializationFailed(String error) {
    return 'Error de inicialización: $error';
  }

  @override
  String get loadingSettings => 'Cargando configuración...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Error al cargar configuración: $error';
  }

  @override
  String get loadingUserData => 'Cargando datos de usuario...';

  @override
  String dataLoadingFailed(String error) {
    return 'Error al cargar datos: $error';
  }

  @override
  String get loading => 'Cargando...';

  @override
  String get taglineSilence => '🤫 Domina el arte del silencio';

  @override
  String get errorOops => '¡Ups! Algo salió mal';

  @override
  String get buttonRetry => 'Reintentar';

  @override
  String get resetAppData => 'Restablecer datos de la aplicación';

  @override
  String get resetAppDataMessage => 'Esto restablecerá todos los datos y configuraciones de la aplicación a sus valores predeterminados. Esta acción no se puede deshacer.\\n\\n¿Deseas continuar?';

  @override
  String get buttonReset => 'Restablecer';

  @override
  String get messageDataReset => 'Los datos de la aplicación se han restablecido';

  @override
  String errorResetFailed(String error) {
    return 'Error al restablecer datos: $error';
  }

  @override
  String get analyticsTitle => 'Analítica';

  @override
  String get analyticsOverview => 'Resumen';

  @override
  String get analyticsPoints => 'Puntos';

  @override
  String get analyticsStreak => 'Racha';

  @override
  String get analyticsSessions => 'Sesiones';

  @override
  String get analyticsLast7Days => 'Últimos 7 días';

  @override
  String get analyticsPerformanceHighlights => 'Aspectos destacados del rendimiento';

  @override
  String get analyticsSuccessRate => 'Tasa de éxito';

  @override
  String get analyticsAvgSession => 'Sesión promedio';

  @override
  String get analyticsBestStreak => 'Mejor racha';

  @override
  String get analyticsActivityProgress => 'Progreso de actividad';

  @override
  String get analyticsComingSoon => 'El seguimiento detallado de actividades estará disponible próximamente.';

  @override
  String get analyticsAdvancedMetrics => 'Métricas avanzadas';

  @override
  String get analyticsPremiumContent => 'Contenido de análisis avanzado premium aquí...';

  @override
  String get analytics30DayTrends => 'Tendencias de 30 días';

  @override
  String get analyticsTrendsChart => 'Gráfico de tendencias premium aquí...';

  @override
  String get analyticsAIInsights => 'Información de IA';

  @override
  String get analyticsAIComingSoon => 'Información impulsada por IA próximamente...';

  @override
  String get analyticsUnlock => 'Desbloquear análisis avanzados';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorQuestUnavailable => 'Estado de misión no disponible';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Error al usar el token de congelación';

  @override
  String get buttonUseFreeze => 'Usar congelación';

  @override
  String get onboardingDailyGoalTitle => '¡Establece tu meta diaria! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => '¿Cuánto tiempo de concentración te parece adecuado?\\n(¡Puedes ajustarlo en cualquier momento!)';

  @override
  String get onboardingGoalGettingStarted => 'Comenzando';

  @override
  String get onboardingGoalBuildingHabit => 'Construyendo hábito';

  @override
  String get onboardingGoalRegularPractice => 'Práctica regular';

  @override
  String get onboardingGoalDeepWork => 'Trabajo profundo';

  @override
  String get onboardingProTip => 'Consejo profesional: ¡Focus Field brilla cuando silencio = concentración! 🤫✨';

  @override
  String get onboardingPrivacyTitle => '¡Tu privacidad importa! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'Necesitamos acceso al micrófono para medir el ruido ambiental y ayudarte a concentrarte mejor';

  @override
  String get onboardingPrivacyNoRecording => 'Sin grabación';

  @override
  String get onboardingPrivacyLocalOnly => 'Solo local';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'Todos los datos permanecen en tu dispositivo';

  @override
  String get onboardingPrivacyFirst => 'Privacidad primero';

  @override
  String get onboardingPrivacyNote => 'Puedes otorgar permiso en la siguiente pantalla al iniciar tu primera sesión';

  @override
  String get insightsFocusTime => 'Tiempo de concentración';

  @override
  String get insightsSessions => 'Sesiones';

  @override
  String get insightsAverage => 'Promedio';

  @override
  String get insightsAmbientScore => 'Puntuación ambiental';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeOceanBlue => 'Azul océano';

  @override
  String get themeForestGreen => 'Verde bosque';

  @override
  String get themePurpleNight => 'Noche púrpura';

  @override
  String get themeGoldLuxury => 'Lujo dorado';

  @override
  String get themeSolarSunrise => 'Amanecer solar';

  @override
  String get themeCyberNeon => 'Neón cibernético';

  @override
  String get themeMidnightTeal => 'Verde azulado medianoche';

  @override
  String get settingsAppTheme => 'Tema de la aplicación';

  @override
  String get freezeTokenNoTokensTitle => 'Sin Tokens de Congelación';

  @override
  String get freezeTokenNoTokensMessage => 'No tienes tokens de congelación disponibles. Ganas 1 token por semana (máximo 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Meta Ya Completada';

  @override
  String get freezeTokenGoalCompleteMessage => '¡Tu meta diaria ya está completa! Los tokens de congelación solo se pueden usar cuando aún no has alcanzado tu meta.';

  @override
  String get freezeTokenUseTitle => 'Usar Token de Congelación';

  @override
  String get freezeTokenUseMessage => 'Los tokens de congelación protegen tu racha cuando pierdes un día. Usar un token contará como completar tu meta diaria.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'Tienes $count token(s). ¿Usar uno ahora?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ ¡Token de congelación usado! Meta marcada como completa.';

  @override
  String get trendsErrorLoading => 'Error al cargar datos';

  @override
  String get trendsPoints => 'Puntos';

  @override
  String get trendsStreak => 'Racha';

  @override
  String get trendsSessions => 'Sesiones';

  @override
  String get trendsTopActivity => 'Actividad Principal';

  @override
  String get sectionToday => 'Hoy';

  @override
  String get sectionSessions => 'Sesiones';

  @override
  String get sectionInsights => 'Perspectivas';

  @override
  String get onboardingGoalAdviceGettingStarted => '¡Excelente comienzo! 🌟 Los pequeños pasos conducen a grandes victorias. ¡Tú puedes!';

  @override
  String get onboardingGoalAdviceBuildingHabit => '¡Excelente elección! 🎯 ¡Este punto ideal construye hábitos duraderos!';

  @override
  String get onboardingGoalAdviceRegularPractice => '¡Ambicioso! 💪 ¡Estás listo para mejorar tu enfoque!';

  @override
  String get onboardingGoalAdviceDeepWork => '¡Guau! 🏆 ¡Modo de trabajo profundo activado! ¡Recuerda tomar descansos!';

  @override
  String get onboardingDuration10to15 => '10-15 minutos';

  @override
  String get onboardingDuration20to30 => '20-30 minutos';

  @override
  String get onboardingDuration40to60 => '40-60 minutos';

  @override
  String get onboardingDuration60plus => '60+ minutos';

  @override
  String get activityStudy => 'Estudio';

  @override
  String get activityReading => 'Lectura';

  @override
  String get activityMeditation => 'Meditación';

  @override
  String get activityOther => 'Otro';

  @override
  String get onboardingTip1Description => 'Comienza con sesiones de 5-10 minutos. ¡La consistencia supera la perfección!';

  @override
  String get onboardingTip2Description => 'Toca Modo Enfoque para una experiencia inmersiva sin distracciones.';

  @override
  String get onboardingTip3Description => 'Usa tu token mensual en días ocupados para proteger tu racha.';

  @override
  String get onboardingTip4Description => 'Apunta al 70% de tiempo tranquilo - ¡no se requiere silencio perfecto!';

  @override
  String get onboardingLaunchTitle => '¡Estás Listo para Comenzar! 🚀';

  @override
  String get onboardingLaunchDescription => '¡Comencemos tu primera sesión y construyamos hábitos increíbles!';

  @override
  String get insightsBestTimeByActivity => 'Mejor tiempo por actividad';

  @override
  String get insightHighSuccessRateTitle => 'Alta tasa de éxito';

  @override
  String get insightEnvironmentStabilityTitle => 'Estabilidad ambiental';

  @override
  String get insightLowNoiseSuccessTitle => 'Éxito con poco ruido';

  @override
  String get insightConsistentPracticeTitle => 'Práctica consistente';

  @override
  String get insightStreakProtectionTitle => 'Protección contra rayas disponible';

  @override
  String get insightRoomTooNoisyTitle => 'Habitación demasiado ruidosa';

  @override
  String get insightIrregularScheduleTitle => 'Horario irregular';

  @override
  String get insightLowAmbientScoreTitle => 'Puntuación ambiental baja';

  @override
  String get insightNoRecentSessionsTitle => 'No hay sesiones recientes';

  @override
  String get insightHighSuccessRateDesc => 'Estás manteniendo fuertes sesiones de silencio.';

  @override
  String get insightEnvironmentStabilityDesc => 'El ruido ambiental está dentro de un rango moderado y manejable.';

  @override
  String get insightLowNoiseSuccessDesc => 'Su entorno es excepcionalmente silencioso durante las sesiones.';

  @override
  String get insightConsistentPracticeDesc => 'Estás construyendo un hábito de práctica diaria confiable.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'Tienes $count token(s) de congelación para proteger tu racha.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Intente buscar un espacio más tranquilo o ajustar su umbral.';

  @override
  String get insightIrregularScheduleDesc => 'Tiempos de sesión más consistentes pueden mejorar tu racha.';

  @override
  String get insightLowAmbientScoreDesc => 'Las sesiones recientes tuvieron menos tiempo de silencio. Pruebe un ambiente más tranquilo.';

  @override
  String get insightNoRecentSessionsDesc => '¡Comience una sesión hoy para desarrollar su hábito de concentración!';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return '¡Buen trabajo! $minutes minutos de concentración en tu sesión! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return '¡Buen esfuerzo! $minutes minutos completados.';
  }

  @override
  String get sessionCompleteFailed => 'Sesión finalizada. Inténtalo de nuevo cuando estés listo.';

  @override
  String get notificationSessionStarted => 'Sesión iniciada: ¡manténgase concentrado!';

  @override
  String get notificationSessionPaused => 'Sesión pausada';

  @override
  String get notificationSessionResumed => 'Sesión reanudada';
}
