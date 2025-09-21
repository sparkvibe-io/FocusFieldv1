// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Preparando motor de foco…';

  @override
  String get paywallTitle => 'Treine foco mais profundo com Premium';

  @override
  String get featureExtendSessions => 'Estenda sessões de 30 min para 120 min';

  @override
  String get featureHistory => 'Acesse 90 dias de histórico';

  @override
  String get featureMetrics => 'Desbloqueie métricas e gráficos de tendência';

  @override
  String get featureExport => 'Baixe seus dados (CSV / PDF)';

  @override
  String get featureThemes => 'Use todo o pacote de temas';

  @override
  String get featureThreshold => 'Ajuste fino do limite com base ambiente';

  @override
  String get featureSupport => 'Suporte mais rápido e acesso antecipado';

  @override
  String get subscribeCta => 'Continuar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get privacyPolicy => 'Privacidade';

  @override
  String get termsOfService => 'Termos';

  @override
  String get manageSubscription => 'Gerenciar';

  @override
  String get legalDisclaimer =>
      'Assinatura com renovação automática. Cancele a qualquer momento.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutos de silêncio ✨',
      one: '# minuto de silêncio ✨',
    );
    return 'Ótimo! $_temp0';
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
  String get settings => 'Configurações';

  @override
  String get themes => 'Temas';

  @override
  String get analytics => 'Análises';

  @override
  String get history => 'Histórico';

  @override
  String get startSession => 'Iniciar sessão';

  @override
  String get stopSession => 'Parar';

  @override
  String get pauseSession => 'Pausar';

  @override
  String get resumeSession => 'Retomar';

  @override
  String get sessionSaved => 'Sessão salva';

  @override
  String get copied => 'Copiado';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get permissionMicrophoneDenied => 'Permissão de microfone negada';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get listeningStatus => 'Ouvindo...';

  @override
  String get successPointMessage => 'Silêncio alcançado! +1 ponto';

  @override
  String get tooNoisyMessage => 'Muito barulho! Tente novamente';

  @override
  String get totalPoints => 'Pontos Totais';

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get bestStreak => 'Melhor Sequência';

  @override
  String get welcomeMessage => 'Pressione Iniciar para começar';

  @override
  String get resetAllData => 'Redefinir todos os dados';

  @override
  String get resetDataConfirmation =>
      'Tem certeza que deseja redefinir o progresso?';

  @override
  String get resetDataSuccess => 'Dados redefinidos';

  @override
  String get decibelThresholdLabel => 'Limite de decibéis';

  @override
  String get decibelThresholdHint => 'Defina o nível máximo de ruído (dB)';

  @override
  String get microphonePermissionTitle => 'Permissão de microfone';

  @override
  String get microphonePermissionMessage =>
      'Focus Field precisa acesso ao microfone para medir o ruído. Nenhum áudio é armazenado.';

  @override
  String get permissionDeniedMessage =>
      'Permissão de microfone necessária. Ative nas configurações.';

  @override
  String get noiseMeterError => 'Não foi possível acessar o microfone';

  @override
  String get premiumFeaturesTitle => 'Recursos Premium';

  @override
  String get premiumDescription =>
      'Desbloqueie sessões longas, análises e exportação';

  @override
  String get premiumRequiredMessage => 'Requer Premium';

  @override
  String get subscriptionSuccessMessage => 'Assinatura concluída!';

  @override
  String get subscriptionErrorMessage =>
      'Não foi possível processar a assinatura';

  @override
  String get restoreSuccessMessage => 'Compras restauradas';

  @override
  String get restoreErrorMessage => 'Nenhuma compra encontrada';

  @override
  String get yearlyPlanTitle => 'Anual';

  @override
  String get monthlyPlanTitle => 'Mensal';

  @override
  String savePercent(String percent) {
    return 'ECONOMIZE $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Cobrado $price/ano';
  }

  @override
  String billedMonthly(String price) {
    return 'Cobrado $price/mês';
  }

  @override
  String get mockSubscriptionsBanner => 'Assinaturas simuladas ativas';

  @override
  String get splashTagline => 'Encontre seu silêncio';

  @override
  String get appIconSemantic => 'Ícone do app';

  @override
  String get tabBasic => 'Básico';

  @override
  String get tabAdvanced => 'Avançado';

  @override
  String get tabAbout => 'Sobre';

  @override
  String get resetAllSettings => 'Redefinir todas as configurações';

  @override
  String get resetAllSettingsDescription =>
      'Isto redefinirá todas as configurações e dados. Irreversível.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Redefinir';

  @override
  String get allSettingsReset =>
      'Todas as configurações e dados foram redefinidos';

  @override
  String get decibelThresholdMaxNoise => 'Limite de decibéis (ruído máx)';

  @override
  String get highThresholdWarningText =>
      'Limite alto pode ignorar ruídos importantes.';

  @override
  String get decibelThresholdTooltip =>
      'Ambientes silenciosos: 30–40 dB. Calibre; aumente só se o zumbido contar.';

  @override
  String get sessionDuration => 'Duração da sessão';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Upgrade para ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Grátis: até $minutes min';
  }

  @override
  String get durationLabel => 'Duração';

  @override
  String get minutesShort => 'min';

  @override
  String get noiseCalibration => 'Calibração de ruído';

  @override
  String get calibrateBaseline => 'Calibrar base';

  @override
  String get unlockAdvancedCalibration => 'Desbloquear calibração avançada';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get sessionHistory => 'Histórico de sessões';

  @override
  String get notifications => 'Notificações';

  @override
  String get remindersCelebrations => 'Lembretes e celebrações';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get accessibilityFeatures => 'Recursos de acessibilidade';

  @override
  String get appInformation => 'Informações do app';

  @override
  String get version => 'Versão';

  @override
  String get bundleId => 'Bundle ID';

  @override
  String get environment => 'Ambiente';

  @override
  String get helpSupport => 'Ajuda e suporte';

  @override
  String get faq => 'FAQ';

  @override
  String get support => 'Suporte';

  @override
  String get rateApp => 'Avaliar';

  @override
  String errorLoadingSettings(String error) {
    return 'Erro ao carregar: $error';
  }

  @override
  String get exportNoData => 'Sem dados para exportar';

  @override
  String chooseExportFormat(int sessions) {
    return 'Escolha formato para $sessions sessões:';
  }

  @override
  String get csvSpreadsheet => 'Planilha CSV';

  @override
  String get rawDataForAnalysis => 'Dados brutos para análise';

  @override
  String get pdfReport => 'Relatório PDF';

  @override
  String get formattedReportWithCharts => 'Relatório com gráficos';

  @override
  String generatingExport(String format) {
    return 'Gerando exportação $format...';
  }

  @override
  String exportCompleted(String format) {
    return 'Exportação $format concluída';
  }

  @override
  String exportFailed(String error) {
    return 'Falha exportação: $error';
  }

  @override
  String get frequentlyAskedQuestions => 'Perguntas frequentes';

  @override
  String get faqHowWorksQ => 'Como o Focus Field funciona?';

  @override
  String get faqHowWorksA =>
      'Mede o ruído ambiente – tempo abaixo do limite gera pontos.';

  @override
  String get faqAudioRecordedQ => 'Áudio é gravado?';

  @override
  String get faqAudioRecordedA =>
      'Não. Apenas níveis de dB; áudio nunca é salvo.';

  @override
  String get faqAdjustSensitivityQ => 'Ajustar sensibilidade?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Configurações > Básico > Limite ($min–$max dB) e calibre primeiro.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Recursos Premium?';

  @override
  String get faqPremiumFeaturesA =>
      'Sessões estendidas (até 120m), análises, exportação, temas.';

  @override
  String get faqNotificationsQ => 'Notificações?';

  @override
  String get faqNotificationsA =>
      'Lembretes inteligentes aprendem hábitos e celebram marcos.';

  @override
  String get close => 'Fechar';

  @override
  String get supportTitle => 'Suporte';

  @override
  String responseTimeLabel(String time) {
    return 'Tempo de resposta: $time';
  }

  @override
  String get docs => 'Docs';

  @override
  String get contactSupport => 'Contatar suporte';

  @override
  String get emailOpenDescription =>
      'Abre seu e-mail com info do sistema pré-preenchida';

  @override
  String get subject => 'Assunto';

  @override
  String get briefDescription => 'Breve descrição';

  @override
  String get description => 'Descrição';

  @override
  String get issueDescriptionHint => 'Detalhe seu problema...';

  @override
  String get openingEmail => 'Abrindo e-mail...';

  @override
  String get openEmailApp => 'Abrir app de e-mail';

  @override
  String get fillSubjectDescription => 'Preencha assunto e descrição';

  @override
  String get emailOpened => 'App de e-mail aberta. Envie quando quiser.';

  @override
  String get noEmailAppFound => 'Nenhum app de e-mail encontrado. Contato:';

  @override
  String standardSubject(String subject) {
    return 'Assunto: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Problema: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'Falha ao abrir FAQ: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Falha docs: $error';
  }

  @override
  String get accessibilitySettings => 'Configurações de acessibilidade';

  @override
  String get vibrationFeedback => 'Vibração';

  @override
  String get vibrateOnSessionEvents => 'Vibrar em eventos da sessão';

  @override
  String get voiceAnnouncements => 'Anúncios de voz';

  @override
  String get announceSessionProgress => 'Anunciar progresso';

  @override
  String get highContrastMode => 'Alto contraste';

  @override
  String get improveVisualAccessibility => 'Melhorar acessibilidade visual';

  @override
  String get largeText => 'Texto grande';

  @override
  String get increaseTextSize => 'Aumentar tamanho';

  @override
  String get save => 'Salvar';

  @override
  String get accessibilitySettingsSaved =>
      'Configurações de acessibilidade salvas';

  @override
  String get noiseFloorCalibration => 'Calibração de ruído base';

  @override
  String get measuringAmbientNoise => 'Medindo ruído ambiente (≈5s)...';

  @override
  String get couldNotReadMic => 'Não foi possível ler o microfone';

  @override
  String get calibrationFailed => 'Falha na calibração';

  @override
  String get retry => 'Tentar novamente';

  @override
  String previousThreshold(double value) {
    return 'Anterior: $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'Novo limite: $value dB';
  }

  @override
  String get noSignificantChange => 'Sem mudança significativa';

  @override
  String get highAmbientDetected => 'Ambiente ruidoso detectado';

  @override
  String get adjustAnytimeSettings => 'Ajuste quando quiser em Configurações';

  @override
  String get toggleThemeTooltip => 'Trocar tema';

  @override
  String get audioChartRecovering => 'Recuperando gráfico de áudio...';

  @override
  String themeChanged(String themeName) {
    return 'Tema: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Iniciar sessão';

  @override
  String get stopSessionButton => 'Parar';

  @override
  String get statusListening => 'Ouvindo...';

  @override
  String get statusSuccess => 'Silêncio alcançado! +1 ponto';

  @override
  String get statusFailure => 'Muito barulho!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get exportCsvSpreadsheet => 'Planilha CSV';

  @override
  String get exportPdfReport => 'Relatório PDF';

  @override
  String get formattedReportCharts => 'Relatório com gráficos';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Tema';

  @override
  String get open => 'Abrir';

  @override
  String get microphone => 'Microfone';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sessões';

  @override
  String get format => 'formato';

  @override
  String get successRate => 'Taxa de sucesso';

  @override
  String get avgSession => 'Sessão méd.';

  @override
  String get consistency => 'Consistência';

  @override
  String get bestTime => 'Melhor tempo';

  @override
  String get weeklyTrends => 'Tendências semanais';

  @override
  String get performanceMetrics => 'Métricas de desempenho';

  @override
  String get advancedAnalytics => 'Análises avançadas';

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
  String get sessionHistoryTitle => 'Histórico de sessões';

  @override
  String get recentSessionHistory => 'Histórico recente';

  @override
  String get achievementFirstStepTitle => 'Primeiro passo';

  @override
  String get achievementFirstStepDesc => 'Primeira sessão concluída';

  @override
  String get achievementOnFireTitle => 'Em sequência';

  @override
  String get achievementOnFireDesc => 'Sequência de 3 dias';

  @override
  String get achievementWeekWarriorTitle => 'Guerreiro da semana';

  @override
  String get achievementWeekWarriorDesc => 'Sequência de 7 dias';

  @override
  String get achievementDecadeTitle => 'Década';

  @override
  String get achievementDecadeDesc => 'Marco de 10 pontos';

  @override
  String get achievementHalfCenturyTitle => 'Meio século';

  @override
  String get achievementHalfCenturyDesc => 'Marco de 50 pontos';

  @override
  String get achievementLockedPrompt =>
      'Complete sessões para desbloquear conquistas';

  @override
  String get ratingPromptTitle => 'Está gostando do Focus Field?';

  @override
  String get ratingPromptBody =>
      'Uma avaliação 5★ rápida ajuda outros a encontrar mais calma.';

  @override
  String get ratingPromptRateNow => 'Avaliar agora';

  @override
  String get ratingPromptLater => 'Depois';

  @override
  String get ratingPromptNoThanks => 'Não, obrigado';

  @override
  String get ratingThankYou => 'Obrigado pelo apoio!';

  @override
  String get notificationSettingsTitle => 'Configurações de notificação';

  @override
  String get notificationPermissionRequired => 'Permissão necessária';

  @override
  String get notificationPermissionRationale =>
      'Ative notificações para lembretes suaves e celebrar conquistas.';

  @override
  String get requesting => 'Solicitando...';

  @override
  String get enableNotificationsCta => 'Ativar notificações';

  @override
  String get enableNotificationsTitle => 'Ativar notificações';

  @override
  String get enableNotificationsSubtitle =>
      'Permitir que o Focus Field envie notificações';

  @override
  String get dailyReminderTitle => 'Lembrete diário inteligente';

  @override
  String get dailyReminderSubtitle => 'Inteligente ou horário fixo';

  @override
  String get dailyTimeLabel => 'Horário diário';

  @override
  String get dailyTimeHint =>
      'Escolha horário fixo ou deixe o app aprender seu padrão.';

  @override
  String get useSmartCta => 'Usar inteligente';

  @override
  String get sessionCompletedTitle => 'Sessão concluída';

  @override
  String get sessionCompletedSubtitle => 'Celebrar sessões concluídas';

  @override
  String get achievementUnlockedTitle => 'Conquista desbloqueada';

  @override
  String get achievementUnlockedSubtitle => 'Notificações de marcos';

  @override
  String get weeklySummaryTitle => 'Resumo semanal';

  @override
  String get weeklySummarySubtitle => 'Visão semanal (dia & hora)';

  @override
  String get weeklyTimeLabel => 'Horário semanal';

  @override
  String get notificationPreview => 'Prévia';

  @override
  String get dailySilenceReminderTitle => 'Lembrete diário de silêncio';

  @override
  String get weeklyProgressReportTitle => 'Progresso semanal 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Conquista desbloqueada! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Sessão finalizada! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Sessão encerrada';

  @override
  String get reminderStartJourney =>
      '🧘‍♂️ Comece hoje sua jornada de silêncio e encontre calma.';

  @override
  String get reminderRestart => '🌱 Recomeçar? Cada momento é um novo início.';

  @override
  String get reminderDayTwo =>
      '⭐ Dia 2 da sua sequência! Consistência gera tranquilidade.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Sequência de $streak dias! Construindo hábito forte.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Sequência incrível de $streak dias! Dedicação inspiradora.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Sequência incrível de $streak dias! Mestre do silêncio!';
  }

  @override
  String get achievementFirstSession =>
      '🎉 Primeira sessão concluída! Bem-vindo.';

  @override
  String get achievementWeekStreak =>
      '🌟 Sequência de 7 dias! Consistência é seu superpoder.';

  @override
  String get achievementMonthStreak =>
      '🏆 Sequência de 30 dias desbloqueada! Imparável.';

  @override
  String get achievementPerfectSession =>
      '✨ Sessão perfeita de silêncio. Nada interrompeu sua paz.';

  @override
  String get achievementLongSession =>
      '⏰ Sessão longa dominada. Foco crescendo.';

  @override
  String get achievementGeneric => '🎊 Conquista desbloqueada! Continue!';

  @override
  String get weeklyProgressNone =>
      '💭 Semana leve de prática. Pronto para uma sessão?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count sessões nesta semana. Cada prática aprofunda a calma.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count sessões nesta semana! Encontrando o ritmo.';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 Semana perfeita com $count sessões! Sua consistência brilha.';
  }

  @override
  String get tipsHidden => 'Dicas ocultas';

  @override
  String get tipsShown => 'Dicas mostradas';

  @override
  String get showTips => 'Mostrar dicas';

  @override
  String get hideTips => 'Ocultar dicas';

  @override
  String get tip01 =>
      'Short sessions count—start with 2–3 minutes to build consistency.';

  @override
  String get tip02 =>
      'Use Smart Daily Reminders to nudge you at your best time.';

  @override
  String get tip03 =>
      'Recalibrate when your environment changes for better accuracy.';

  @override
  String get tip04 => 'Check Weekly Trends to spot your momentum over time.';

  @override
  String get tip05 =>
      'Streaks grow with daily wins—show up, even for one minute.';

  @override
  String get tip06 =>
      'High ambient noise? Raise threshold a bit to reduce false fails.';

  @override
  String get tip07 =>
      'Try different times of day to find your quiet sweet spot.';

  @override
  String get tip08 =>
      'Session complete notifications keep motivation high—enable them!';

  @override
  String get tip09 =>
      'Prefer hands‑off? Auto reminders can schedule themselves (Smart).';

  @override
  String get tip10 =>
      'Use shorter sessions on busy days to keep your streak alive.';

  @override
  String get tip11 =>
      'The progress ring is tappable—start or stop with a single tap.';

  @override
  String get tip12 =>
      'Export your data (Premium) to share progress or back it up.';

  @override
  String get tip13 =>
      'Average session length helps you choose the right duration.';

  @override
  String get tip14 =>
      'Consistency beats intensity—small daily practice compounds.';

  @override
  String get tip15 => 'Set a gentle goal: 5 quiet minutes is a great baseline.';

  @override
  String get tip16 =>
      'The noise chart helps you see spikes—aim for calmer periods.';

  @override
  String get tip17 =>
      'Upgrade session duration (Premium) for longer focus blocks.';

  @override
  String get tip18 =>
      'High threshold warning guards accuracy—avoid setting it too high.';

  @override
  String get tip19 =>
      'Weekdays vary—tune your weekly summary to your schedule.';

  @override
  String get tip20 =>
      'Accessibility options: high contrast, large text, and vibration.';

  @override
  String get tip21 =>
      'Ambient baseline matters—calibrate when moving to new spaces.';

  @override
  String get tip22 => 'Quiet wins add up—1 point per minute keeps it simple.';

  @override
  String get tip23 =>
      'Confetti celebrates progress—small celebrations reinforce habits.';

  @override
  String get tip24 =>
      'Try mornings if evenings are noisy—best time differs for everyone.';

  @override
  String get tip25 =>
      'Fine‑tune the decibel threshold for your room’s character.';

  @override
  String get tip26 => 'Use the moving average to smooth out noisy days.';

  @override
  String get tip27 => 'Let Weekly Insights remind you of your progress rhythm.';

  @override
  String get tip28 =>
      'Finish what you start—short sessions reduce friction to begin.';

  @override
  String get tip29 =>
      'Silence is a skill—practice makes patterns, patterns make progress.';

  @override
  String get tip30 => 'You’re one tap away—start a tiny session now.';

  @override
  String get tipInstructionNotifications =>
      'Settings → Advanced → Notifications to configure reminders and celebrations.';

  @override
  String get tipInstructionWeeklySummary =>
      'Settings → Advanced → Notifications → Weekly Summary to pick weekday & time.';

  @override
  String get tipInstructionThreshold =>
      'Settings → Basic → Decibel Threshold. Calibrate first, then fine‑tune.';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get tipInstructionSetTime => 'Settings → Basic → Session duration';

  @override
  String get tipInstructionDailyReminders =>
      'Settings → Advanced → Notifications → Smart Daily Reminders.';

  @override
  String get tipInstructionCalibrate =>
      'Settings → Advanced → Noise Calibration.';

  @override
  String get tipInstructionOpenAnalytics =>
      'Open Analytics to view trends and averages.';

  @override
  String get tipInstructionSessionComplete =>
      'Settings → Advanced → Notifications → Session Completed.';

  @override
  String get tipInstructionTapRing =>
      'On Home, tap the progress ring to start/stop.';

  @override
  String get tipInstructionExport => 'Settings → Advanced → Export Data.';

  @override
  String get tipInstructionOpenNoiseChart =>
      'Start a session to see the real‑time noise chart.';

  @override
  String get tipInstructionUpgradeDuration =>
      'Settings → Basic → Session duration. Upgrade for longer blocks.';

  @override
  String get tipInstructionAccessibility =>
      'Settings → Advanced → Accessibility.';

  @override
  String get tipInstructionStartNow => 'Tap Start Session on the Home screen.';

  @override
  String get tipInfoTooltip => 'Mostrar dica';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => 'Preparando o motor de foco…';

  @override
  String get paywallTitle => 'Treine foco mais profundo com o Premium';

  @override
  String get featureExtendSessions => 'Estenda sessões de 30 min para 120 min';

  @override
  String get featureHistory => 'Acesse 90 dias de histórico';

  @override
  String get featureMetrics => 'Desbloqueie métricas e gráficos de tendência';

  @override
  String get featureExport => 'Baixe seus dados (CSV / PDF)';

  @override
  String get featureThemes => 'Use todo o pacote de temas';

  @override
  String get featureThreshold => 'Ajuste fino do limite com base ambiente';

  @override
  String get featureSupport => 'Suporte mais rápido e acesso antecipado';

  @override
  String get subscribeCta => 'Continuar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get privacyPolicy => 'Privacidade';

  @override
  String get termsOfService => 'Termos';

  @override
  String get manageSubscription => 'Gerenciar';

  @override
  String get legalDisclaimer =>
      'Assinatura com renovação automática. Cancele a qualquer momento nas configurações da loja.';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutos de silêncio alcançados ✨',
      one: '# minuto de silêncio alcançado ✨',
    );
    return 'Ótimo! $_temp0';
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
  String get settings => 'Configurações';

  @override
  String get themes => 'Temas';

  @override
  String get analytics => 'Análises';

  @override
  String get history => 'Histórico';

  @override
  String get startSession => 'Iniciar sessão';

  @override
  String get stopSession => 'Parar';

  @override
  String get pauseSession => 'Pausar';

  @override
  String get resumeSession => 'Retomar';

  @override
  String get sessionSaved => 'Sessão salva';

  @override
  String get copied => 'Copiado';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get permissionMicrophoneDenied => 'Permissão de microfone negada';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get listeningStatus => 'Ouvindo...';

  @override
  String get successPointMessage => 'Silêncio alcançado! +1 ponto';

  @override
  String get tooNoisyMessage => 'Muito barulho! Tente novamente';

  @override
  String get totalPoints => 'Pontos Totais';

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get bestStreak => 'Melhor Sequência';

  @override
  String get welcomeMessage => 'Pressione Iniciar para começar sua jornada';

  @override
  String get resetAllData => 'Redefinir todos os dados';

  @override
  String get resetDataConfirmation =>
      'Tem certeza que deseja redefinir seu progresso?';

  @override
  String get resetDataSuccess => 'Dados redefinidos';

  @override
  String get decibelThresholdLabel => 'Limite de decibéis';

  @override
  String get decibelThresholdHint => 'Defina o nível máximo de ruído (dB)';

  @override
  String get microphonePermissionTitle => 'Permissão de microfone';

  @override
  String get microphonePermissionMessage =>
      'Focus Field precisa de acesso ao microfone para medir o ruído. Nenhum áudio é armazenado.';

  @override
  String get permissionDeniedMessage =>
      'Permissão de microfone necessária. Ative nas configurações.';

  @override
  String get noiseMeterError => 'Não foi possível acessar o microfone';

  @override
  String get premiumFeaturesTitle => 'Recursos Premium';

  @override
  String get premiumDescription =>
      'Desbloqueie sessões longas, análises e exportação';

  @override
  String get premiumRequiredMessage => 'Requer assinatura Premium';

  @override
  String get subscriptionSuccessMessage => 'Assinatura concluída!';

  @override
  String get subscriptionErrorMessage =>
      'Não foi possível concluir a assinatura';

  @override
  String get restoreSuccessMessage => 'Compras restauradas';

  @override
  String get restoreErrorMessage => 'Nenhuma compra encontrada';

  @override
  String get yearlyPlanTitle => 'Anual';

  @override
  String get monthlyPlanTitle => 'Mensal';

  @override
  String savePercent(String percent) {
    return 'ECONOMIZE $percent%';
  }

  @override
  String billedAnnually(String price) {
    return 'Cobrado $price/ano';
  }

  @override
  String billedMonthly(String price) {
    return 'Cobrado $price/mês';
  }

  @override
  String get mockSubscriptionsBanner => 'Assinaturas simuladas ativas';

  @override
  String get splashTagline => 'Encontre seu silêncio';

  @override
  String get appIconSemantic => 'Ícone do app';

  @override
  String get tabBasic => 'Básico';

  @override
  String get tabAdvanced => 'Avançado';

  @override
  String get tabAbout => 'Sobre';

  @override
  String get resetAllSettings => 'Redefinir todas as configurações';

  @override
  String get resetAllSettingsDescription =>
      'Isto redefinirá todas as configurações e dados. Irreversível.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Redefinir';

  @override
  String get allSettingsReset =>
      'Todas as configurações e dados foram redefinidos';

  @override
  String get decibelThresholdMaxNoise => 'Limite de decibéis (ruído máx)';

  @override
  String get highThresholdWarningText =>
      'Limite alto pode ignorar ruídos importantes.';

  @override
  String get decibelThresholdTooltip =>
      'Ambientes silenciosos: 30–40 dB. Calibre; aumente só se o zumbido contar.';

  @override
  String get sessionDuration => 'Duração da sessão';

  @override
  String upgradeForMinutes(int minutes) {
    return 'Upgrade para ${minutes}m';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return 'Grátis: até $minutes min';
  }

  @override
  String get durationLabel => 'Duração';

  @override
  String get minutesShort => 'min';

  @override
  String get noiseCalibration => 'Calibração de ruído';

  @override
  String get calibrateBaseline => 'Calibrar base';

  @override
  String get unlockAdvancedCalibration => 'Desbloquear calibração avançada';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get sessionHistory => 'Histórico de sessões';

  @override
  String get notifications => 'Notificações';

  @override
  String get remindersCelebrations => 'Lembretes e celebrações';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get accessibilityFeatures => 'Recursos de acessibilidade';

  @override
  String get appInformation => 'Informações do app';

  @override
  String get version => 'Versão';

  @override
  String get bundleId => 'Bundle ID';

  @override
  String get environment => 'Ambiente';

  @override
  String get helpSupport => 'Ajuda e suporte';

  @override
  String get faq => 'FAQ';

  @override
  String get support => 'Suporte';

  @override
  String get rateApp => 'Avaliar';

  @override
  String errorLoadingSettings(String error) {
    return 'Erro ao carregar: $error';
  }

  @override
  String get exportNoData => 'Sem dados para exportar';

  @override
  String chooseExportFormat(int sessions) {
    return 'Escolha formato para $sessions sessões:';
  }

  @override
  String get csvSpreadsheet => 'Planilha CSV';

  @override
  String get rawDataForAnalysis => 'Dados brutos para análise';

  @override
  String get pdfReport => 'Relatório PDF';

  @override
  String get formattedReportWithCharts => 'Relatório com gráficos';

  @override
  String generatingExport(String format) {
    return 'Gerando exportação $format...';
  }

  @override
  String exportCompleted(String format) {
    return 'Exportação $format concluída';
  }

  @override
  String exportFailed(String error) {
    return 'Falha exportação: $error';
  }

  @override
  String get frequentlyAskedQuestions => 'Perguntas frequentes';

  @override
  String get faqHowWorksQ => 'Como o Focus Field funciona?';

  @override
  String get faqHowWorksA =>
      'Mede o ruído ambiente – tempo abaixo do limite gera pontos.';

  @override
  String get faqAudioRecordedQ => 'Áudio é gravado?';

  @override
  String get faqAudioRecordedA =>
      'Não. Apenas níveis de dB; áudio nunca é salvo.';

  @override
  String get faqAdjustSensitivityQ => 'Ajustar sensibilidade?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Configurações > Básico > Limite ($min–$max dB) e calibre primeiro.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Recursos Premium?';

  @override
  String get faqPremiumFeaturesA =>
      'Sessões estendidas (até 120m), análises, exportação, temas.';

  @override
  String get faqNotificationsQ => 'Notificações?';

  @override
  String get faqNotificationsA =>
      'Lembretes inteligentes aprendem hábitos e celebram marcos.';

  @override
  String get close => 'Fechar';

  @override
  String get supportTitle => 'Suporte';

  @override
  String responseTimeLabel(String time) {
    return 'Tempo de resposta: $time';
  }

  @override
  String get docs => 'Docs';

  @override
  String get contactSupport => 'Contatar suporte';

  @override
  String get emailOpenDescription =>
      'Abre seu e-mail com info do sistema pré-preenchida';

  @override
  String get subject => 'Assunto';

  @override
  String get briefDescription => 'Breve descrição';

  @override
  String get description => 'Descrição';

  @override
  String get issueDescriptionHint => 'Detalhe seu problema...';

  @override
  String get openingEmail => 'Abrindo e-mail...';

  @override
  String get openEmailApp => 'Abrir app de e-mail';

  @override
  String get fillSubjectDescription => 'Preencha assunto e descrição';

  @override
  String get emailOpened => 'App de e-mail aberta. Envie quando quiser.';

  @override
  String get noEmailAppFound => 'Nenhum app de e-mail encontrado. Contato:';

  @override
  String standardSubject(String subject) {
    return 'Assunto: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return 'Problema: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'Falha ao abrir FAQ: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'Falha docs: $error';
  }

  @override
  String get accessibilitySettings => 'Configurações de acessibilidade';

  @override
  String get vibrationFeedback => 'Vibração';

  @override
  String get vibrateOnSessionEvents => 'Vibrar em eventos da sessão';

  @override
  String get voiceAnnouncements => 'Anúncios de voz';

  @override
  String get announceSessionProgress => 'Anunciar progresso';

  @override
  String get highContrastMode => 'Alto contraste';

  @override
  String get improveVisualAccessibility => 'Melhorar acessibilidade visual';

  @override
  String get largeText => 'Texto grande';

  @override
  String get increaseTextSize => 'Aumentar tamanho';

  @override
  String get save => 'Salvar';

  @override
  String get accessibilitySettingsSaved =>
      'Configurações de acessibilidade salvas';

  @override
  String get noiseFloorCalibration => 'Calibração de ruído base';

  @override
  String get measuringAmbientNoise => 'Medindo ruído ambiente (≈5s)...';

  @override
  String get couldNotReadMic => 'Não foi possível ler o microfone';

  @override
  String get calibrationFailed => 'Falha na calibração';

  @override
  String get retry => 'Tentar novamente';

  @override
  String previousThreshold(double value) {
    return 'Anterior: $value dB';
  }

  @override
  String newThreshold(double value) {
    return 'Novo limite: $value dB';
  }

  @override
  String get noSignificantChange => 'Sem mudança significativa';

  @override
  String get highAmbientDetected => 'Ambiente ruidoso detectado';

  @override
  String get adjustAnytimeSettings => 'Ajuste quando quiser em Configurações';

  @override
  String get toggleThemeTooltip => 'Trocar tema';

  @override
  String get audioChartRecovering => 'Recuperando gráfico de áudio...';

  @override
  String themeChanged(String themeName) {
    return 'Tema: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Iniciar sessão';

  @override
  String get stopSessionButton => 'Parar';

  @override
  String get statusListening => 'Ouvindo...';

  @override
  String get statusSuccess => 'Silêncio alcançado! +1 ponto';

  @override
  String get statusFailure => 'Muito barulho!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get exportCsvSpreadsheet => 'Planilha CSV';

  @override
  String get exportPdfReport => 'Relatório PDF';

  @override
  String get formattedReportCharts => 'Relatório com gráficos';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Tema';

  @override
  String get open => 'Abrir';

  @override
  String get microphone => 'Microfone';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sessões';

  @override
  String get format => 'formato';

  @override
  String get successRate => 'Taxa de sucesso';

  @override
  String get avgSession => 'Sessão méd.';

  @override
  String get consistency => 'Consistência';

  @override
  String get bestTime => 'Melhor tempo';

  @override
  String get weeklyTrends => 'Tendências semanais';

  @override
  String get performanceMetrics => 'Métricas de desempenho';

  @override
  String get advancedAnalytics => 'Análises avançadas';

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
  String get sessionHistoryTitle => 'Histórico de sessões';

  @override
  String get recentSessionHistory => 'Histórico recente';

  @override
  String get achievementFirstStepTitle => 'Primeiro passo';

  @override
  String get achievementFirstStepDesc => 'Primeira sessão concluída';

  @override
  String get achievementOnFireTitle => 'Em sequência';

  @override
  String get achievementOnFireDesc => 'Sequência de 3 dias';

  @override
  String get achievementWeekWarriorTitle => 'Guerreiro da semana';

  @override
  String get achievementWeekWarriorDesc => 'Sequência de 7 dias';

  @override
  String get achievementDecadeTitle => 'Década';

  @override
  String get achievementDecadeDesc => 'Marco de 10 pontos';

  @override
  String get achievementHalfCenturyTitle => 'Meio século';

  @override
  String get achievementHalfCenturyDesc => 'Marco de 50 pontos';

  @override
  String get achievementLockedPrompt =>
      'Complete sessões para desbloquear conquistas';

  @override
  String get ratingPromptTitle => 'Está gostando do Focus Field?';

  @override
  String get ratingPromptBody =>
      'Uma avaliação 5★ rápida ajuda outros a encontrar foco calmo.';

  @override
  String get ratingPromptRateNow => 'Avaliar agora';

  @override
  String get ratingPromptLater => 'Depois';

  @override
  String get ratingPromptNoThanks => 'Não, obrigado';

  @override
  String get ratingThankYou => 'Obrigado pelo apoio!';

  @override
  String get notificationSettingsTitle => 'Configurações de notificação';

  @override
  String get notificationPermissionRequired => 'Permissão necessária';

  @override
  String get notificationPermissionRationale =>
      'Ative notificações para receber lembretes e celebrar conquistas.';

  @override
  String get requesting => 'Solicitando...';

  @override
  String get enableNotificationsCta => 'Ativar notificações';

  @override
  String get enableNotificationsTitle => 'Ativar notificações';

  @override
  String get enableNotificationsSubtitle =>
      'Permitir que o Focus Field envie notificações';

  @override
  String get dailyReminderTitle => 'Lembrete diário inteligente';

  @override
  String get dailyReminderSubtitle => 'Inteligente ou horário escolhido';

  @override
  String get dailyTimeLabel => 'Horário diário';

  @override
  String get dailyTimeHint =>
      'Escolha um horário fixo ou deixe o app aprender seu padrão.';

  @override
  String get useSmartCta => 'Usar inteligente';

  @override
  String get sessionCompletedTitle => 'Sessão concluída';

  @override
  String get sessionCompletedSubtitle => 'Celebrar sessões finalizadas';

  @override
  String get achievementUnlockedTitle => 'Conquista desbloqueada';

  @override
  String get achievementUnlockedSubtitle => 'Notificações de marcos';

  @override
  String get weeklySummaryTitle => 'Resumo semanal';

  @override
  String get weeklySummarySubtitle => 'Visão semanal (dia e hora)';

  @override
  String get weeklyTimeLabel => 'Horário semanal';

  @override
  String get notificationPreview => 'Prévia';

  @override
  String get dailySilenceReminderTitle => 'Lembrete diário de silêncio';

  @override
  String get weeklyProgressReportTitle => 'Relatório semanal 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Conquista desbloqueada! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Sessão concluída! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Sessão finalizada';

  @override
  String get reminderStartJourney =>
      '🧘‍♂️ Comece hoje sua jornada de silêncio e encontre sua paz.';

  @override
  String get reminderRestart =>
      '🌱 Recomeçar a prática? Cada momento é um novo começo.';

  @override
  String get reminderDayTwo =>
      '⭐ Dia 2 da sua sequência! Consistência gera tranquilidade.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Sequência de $streak dias! Você está criando um hábito forte.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Incrível sequência de $streak dias! Sua dedicação inspira.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Sequência impressionante de $streak dias! Mestre do silêncio!';
  }

  @override
  String get achievementFirstSession =>
      '🎉 Primeira sessão concluída! Bem-vindo(a).';

  @override
  String get achievementWeekStreak =>
      '🌟 Sequência de 7 dias! Consistência é seu superpoder.';

  @override
  String get achievementMonthStreak =>
      '🏆 Sequência de 30 dias desbloqueada! Imparável.';

  @override
  String get achievementPerfectSession =>
      '✨ Sessão perfeita. Nada perturbou sua paz.';

  @override
  String get achievementLongSession =>
      '⏰ Sessão longa dominada. Foco crescente.';

  @override
  String get achievementGeneric => '🎊 Conquista desbloqueada! Continue assim!';

  @override
  String get weeklyProgressNone =>
      '💭 Semana tranquila de prática. Pronto(a) para uma sessão?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count sessões esta semana. Cada prática aprofunda a calma.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count sessões nesta semana! Encontrando o ritmo.';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 Semana perfeita com $count sessões! Sua consistência brilha.';
  }

  @override
  String get tipsHidden => 'Dicas ocultas';

  @override
  String get tipsShown => 'Dicas mostradas';

  @override
  String get showTips => 'Mostrar dicas';

  @override
  String get hideTips => 'Ocultar dicas';

  @override
  String get tip01 =>
      'Short sessions count—start with 2–3 minutes to build consistency.';

  @override
  String get tip02 =>
      'Use Smart Daily Reminders to nudge you at your best time.';

  @override
  String get tip03 =>
      'Recalibrate when your environment changes for better accuracy.';

  @override
  String get tip04 => 'Check Weekly Trends to spot your momentum over time.';

  @override
  String get tip05 =>
      'Streaks grow with daily wins—show up, even for one minute.';

  @override
  String get tip06 =>
      'High ambient noise? Raise threshold a bit to reduce false fails.';

  @override
  String get tip07 =>
      'Try different times of day to find your quiet sweet spot.';

  @override
  String get tip08 =>
      'Session complete notifications keep motivation high—enable them!';

  @override
  String get tip09 =>
      'Prefer hands‑off? Auto reminders can schedule themselves (Smart).';

  @override
  String get tip10 =>
      'Use shorter sessions on busy days to keep your streak alive.';

  @override
  String get tip11 =>
      'The progress ring is tappable—start or stop with a single tap.';

  @override
  String get tip12 =>
      'Export your data (Premium) to share progress or back it up.';

  @override
  String get tip13 =>
      'Average session length helps you choose the right duration.';

  @override
  String get tip14 =>
      'Consistency beats intensity—small daily practice compounds.';

  @override
  String get tip15 => 'Set a gentle goal: 5 quiet minutes is a great baseline.';

  @override
  String get tip16 =>
      'The noise chart helps you see spikes—aim for calmer periods.';

  @override
  String get tip17 =>
      'Upgrade session duration (Premium) for longer focus blocks.';

  @override
  String get tip18 =>
      'High threshold warning guards accuracy—avoid setting it too high.';

  @override
  String get tip19 =>
      'Weekdays vary—tune your weekly summary to your schedule.';

  @override
  String get tip20 =>
      'Accessibility options: high contrast, large text, and vibration.';

  @override
  String get tip21 =>
      'Ambient baseline matters—calibrate when moving to new spaces.';

  @override
  String get tip22 => 'Quiet wins add up—1 point per minute keeps it simple.';

  @override
  String get tip23 =>
      'Confetti celebrates progress—small celebrations reinforce habits.';

  @override
  String get tip24 =>
      'Try mornings if evenings are noisy—best time differs for everyone.';

  @override
  String get tip25 =>
      'Fine‑tune the decibel threshold for your room’s character.';

  @override
  String get tip26 => 'Use the moving average to smooth out noisy days.';

  @override
  String get tip27 => 'Let Weekly Insights remind you of your progress rhythm.';

  @override
  String get tip28 =>
      'Finish what you start—short sessions reduce friction to begin.';

  @override
  String get tip29 =>
      'Silence is a skill—practice makes patterns, patterns make progress.';

  @override
  String get tip30 => 'You’re one tap away—start a tiny session now.';

  @override
  String get tipInstructionNotifications =>
      'Settings → Advanced → Notifications to configure reminders and celebrations.';

  @override
  String get tipInstructionWeeklySummary =>
      'Settings → Advanced → Notifications → Weekly Summary to pick weekday & time.';

  @override
  String get tipInstructionThreshold =>
      'Settings → Basic → Decibel Threshold. Calibrate first, then fine‑tune.';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get tipInstructionSetTime => 'Settings → Basic → Session duration';

  @override
  String get tipInstructionDailyReminders =>
      'Settings → Advanced → Notifications → Smart Daily Reminders.';

  @override
  String get tipInstructionCalibrate =>
      'Settings → Advanced → Noise Calibration.';

  @override
  String get tipInstructionOpenAnalytics =>
      'Open Analytics to view trends and averages.';

  @override
  String get tipInstructionSessionComplete =>
      'Settings → Advanced → Notifications → Session Completed.';

  @override
  String get tipInstructionTapRing =>
      'On Home, tap the progress ring to start/stop.';

  @override
  String get tipInstructionExport => 'Settings → Advanced → Export Data.';

  @override
  String get tipInstructionOpenNoiseChart =>
      'Start a session to see the real‑time noise chart.';

  @override
  String get tipInstructionUpgradeDuration =>
      'Settings → Basic → Session duration. Upgrade for longer blocks.';

  @override
  String get tipInstructionAccessibility =>
      'Settings → Advanced → Accessibility.';

  @override
  String get tipInstructionStartNow => 'Tap Start Session on the Home screen.';

  @override
  String get tipInfoTooltip => 'Mostrar dica';
}
