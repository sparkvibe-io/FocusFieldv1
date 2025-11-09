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
  String get legalDisclaimer => 'Assinatura com renovação automática. Cancele a qualquer momento.';

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
  String get resetDataConfirmation => 'Tem certeza que deseja redefinir o progresso?';

  @override
  String get resetDataSuccess => 'Dados redefinidos';

  @override
  String get decibelThresholdLabel => 'Limite de decibéis';

  @override
  String get decibelThresholdHint => 'Defina o nível máximo de ruído (dB)';

  @override
  String get microphonePermissionTitle => 'Permissão de microfone';

  @override
  String get microphonePermissionMessage => 'Focus Field mede os níveis de som ambiente para ajudá-lo a manter ambientes silenciosos.\n\nO aplicativo precisa de acesso ao microfone para detectar o silêncio, mas não grava nenhum áudio.';

  @override
  String get permissionDeniedMessage => 'Permissão de microfone necessária. Ative nas configurações.';

  @override
  String get noiseMeterError => 'Não foi possível acessar o microfone';

  @override
  String get premiumFeaturesTitle => 'Recursos Premium';

  @override
  String get premiumDescription => 'Desbloqueie sessões longas, análises e exportação';

  @override
  String get premiumRequiredMessage => 'Requer Premium';

  @override
  String get subscriptionSuccessMessage => 'Assinatura concluída!';

  @override
  String get subscriptionErrorMessage => 'Não foi possível processar a assinatura';

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
  String get splashTagline => 'Meça o Silêncio, Construa Foco';

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
  String get resetAllSettingsDescription => 'Isto redefinirá todas as configurações e dados. Irreversível.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Redefinir';

  @override
  String get allSettingsReset => 'Todas as configurações e dados foram redefinidos';

  @override
  String get decibelThresholdMaxNoise => 'Limite de decibéis (ruído máx)';

  @override
  String get highThresholdWarningText => 'Limite alto pode ignorar ruídos importantes.';

  @override
  String get decibelThresholdTooltip => 'Ambientes silenciosos: 30–40 dB. Calibre; aumente só se o zumbido contar.';

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
  String get emailOpenDescription => 'Abre seu e-mail com info do sistema pré-preenchida';

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
  String get accessibilitySettingsSaved => 'Configurações de acessibilidade salvas';

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
  String get upgradeRequired => 'Atualização Necessária';

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
  String get achievementLockedPrompt => 'Complete sessões para desbloquear conquistas';

  @override
  String get ratingPromptTitle => 'Está gostando do Silence Score?';

  @override
  String get ratingPromptBody => 'Uma avaliação 5★ rápida ajuda outros a encontrar mais calma.';

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
  String get notificationPermissionRationale => 'Ative notificações para lembretes suaves e celebrar conquistas.';

  @override
  String get requesting => 'Solicitando...';

  @override
  String get enableNotificationsCta => 'Ativar notificações';

  @override
  String get enableNotificationsTitle => 'Ativar notificações';

  @override
  String get enableNotificationsSubtitle => 'Permitir que o SilenceScore envie notificações';

  @override
  String get dailyReminderTitle => 'Lembrete diário inteligente';

  @override
  String get dailyReminderSubtitle => 'Inteligente ou horário fixo';

  @override
  String get dailyTimeLabel => 'Horário diário';

  @override
  String get dailyTimeHint => 'Escolha horário fixo ou deixe o app aprender seu padrão.';

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
  String get notificationPreview => 'Pré-visualização de Notificação';

  @override
  String get dailySilenceReminderTitle => 'Lembrete diário de foco';

  @override
  String get weeklyProgressReportTitle => 'Progresso semanal 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Conquista desbloqueada! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Sessão finalizada! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Sessão encerrada';

  @override
  String get reminderStartJourney => '🎯 Comece hoje sua jornada de foco! Construa seu hábito de trabalho profundo.';

  @override
  String get reminderRestart => '🌱 Recomeçar? Cada momento é uma nova oportunidade de foco.';

  @override
  String get reminderDayTwo => '⭐ Dia 2 da sua sequência de foco! Consistência constrói concentração.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Sequência de $streak dias de foco! Construindo hábito forte.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Sequência incrível de $streak dias! Dedicação inspiradora.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Sequência incrível de $streak dias! Você é um campeão de foco!';
  }

  @override
  String get achievementFirstSession => '🎉 Primeira sessão concluída! Bem-vindo ao Focus Field!';

  @override
  String get achievementWeekStreak => '🌟 Sequência de 7 dias! Consistência é seu superpoder.';

  @override
  String get achievementMonthStreak => '🏆 Sequência de 30 dias desbloqueada! Imparável.';

  @override
  String get achievementPerfectSession => '✨ Sessão perfeita! 100% de ambiente calmo mantido!';

  @override
  String get achievementLongSession => '⏰ Sessão longa dominada. Foco crescendo.';

  @override
  String get achievementGeneric => '🎊 Conquista desbloqueada! Continue!';

  @override
  String get weeklyProgressNone => '💭 Comece seu objetivo semanal! Pronto para uma sessão focada?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count minutos de foco esta semana! Cada sessão conta.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count minutos de foco conquistados! Encontrando o ritmo.';
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
  String get tip01 => 'Comece pequeno—até 2 minutos constroem seu hábito de foco.';

  @override
  String get tip02 => 'Sua sequência tem graça—uma falta não a quebrará com a Regra de 2 Dias.';

  @override
  String get tip03 => 'Experimente atividades de Estudo, Leitura ou Meditação para combinar com seu estilo de foco.';

  @override
  String get tip04 => 'Confira seu Mapa de Calor de 12 semanas para ver como pequenas vitórias se acumulam ao longo do tempo.';

  @override
  String get tip05 => 'Observe sua % de Calma ao vivo durante as sessões—pontuações mais altas significam melhor foco!';

  @override
  String get tip06 => 'Personalize sua meta diária (10-60 min) para combinar com seu ritmo.';

  @override
  String get tip07 => 'Use seu Token de Congelamento mensal para proteger sua sequência em dias difíceis.';

  @override
  String get tip08 => 'Após 3 vitórias, o Focus Field sugere um limiar mais rigoroso—pronto para subir de nível?';

  @override
  String get tip09 => 'Ruído ambiente alto? Aumente seu limiar para permanecer na zona.';

  @override
  String get tip10 => 'Lembretes Diários Inteligentes aprendem seu melhor momento—deixe-os guiá-lo.';

  @override
  String get tip11 => 'O anel de progresso é tocável—um toque inicia sua sessão de foco.';

  @override
  String get tip12 => 'Recalibre quando seu ambiente mudar para melhor precisão.';

  @override
  String get tip13 => 'Notificações de sessão celebram suas vitórias—ative-as para motivação!';

  @override
  String get tip14 => 'Consistência vence perfeição—apareça, mesmo em dias ocupados.';

  @override
  String get tip15 => 'Experimente diferentes momentos do dia para descobrir seu ponto doce tranquilo.';

  @override
  String get tip16 => 'Seu progresso diário está sempre visível—toque em Ir para começar a qualquer momento.';

  @override
  String get tip17 => 'Cada atividade rastreia separadamente em direção à sua meta—variedade mantém as coisas frescas.';

  @override
  String get tip18 => 'Exporte seus dados (Premium) para ver sua jornada de foco completa.';

  @override
  String get tip19 => 'Confete celebra cada conclusão—pequenas vitórias merecem reconhecimento!';

  @override
  String get tip20 => 'Sua linha de base importa—calibre ao mudar para novos espaços.';

  @override
  String get tip21 => 'Suas Tendências de 7 Dias revelam padrões—confira-as semanalmente para insights.';

  @override
  String get tip22 => 'Atualize a duração da sessão (Premium) para blocos de foco profundo mais longos.';

  @override
  String get tip23 => 'Foco é uma prática—pequenas sessões constroem o hábito que você deseja.';

  @override
  String get tip24 => 'O Resumo Semanal mostra seu ritmo—ajuste-o ao seu cronograma.';

  @override
  String get tip25 => 'Ajuste seu limiar para seu espaço—cada sala é diferente.';

  @override
  String get tip26 => 'Opções de acessibilidade ajudam todos a focar—alto contraste, texto grande, vibração.';

  @override
  String get tip27 => 'Linha do Tempo de Hoje mostra quando você focou—encontre suas horas produtivas.';

  @override
  String get tip28 => 'Termine o que você começa—sessões mais curtas significam mais conclusões.';

  @override
  String get tip29 => 'Minutos Silenciosos somam em direção à sua meta—progresso sobre perfeição.';

  @override
  String get tip30 => 'Você está a um toque de distância—comece uma pequena sessão agora.';

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
  String get tipInstructionHeatmap => 'Aba Resumo → Mostrar Mais → Mapa de Calor';

  @override
  String get tipInstructionTodayTimeline => 'Aba Resumo → Mostrar Mais → Linha do Tempo de Hoje';

  @override
  String get tipInstruction7DayTrends => 'Aba Resumo → Mostrar Mais → Tendências de 7 Dias';

  @override
  String get tipInstructionEditActivities => 'Aba Atividade → toque em Editar para mostrar/ocultar atividades';

  @override
  String get tipInstructionQuestGo => 'Aba Atividade → Cápsula de Missão → toque em Ir';

  @override
  String get tipInfoTooltip => 'Mostrar dica';

  @override
  String get questCapsuleTitle => 'Missão Ambiental';

  @override
  String get questCapsuleLoading => 'Carregando minutos calmos…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Calma $progress/$goal min • Sequência $streak';
  }

  @override
  String get questFreezeButton => 'Congelar';

  @override
  String get questFrozenToday => 'Hoje congelado — você está protegido.';

  @override
  String get questGoButton => 'Ir';

  @override
  String calmPercent(int percent) {
    return 'Calma $percent%';
  }

  @override
  String get calmLabel => 'Calma';

  @override
  String get day => 'dia';

  @override
  String get days => 'dias';

  @override
  String get freeze => 'congelar';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3 vitórias! Tentar $threshold dB?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Agora não';

  @override
  String get adaptiveThresholdTryIt => 'Tentar';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Limiar definido para $threshold dB';
  }

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get error => 'Erro';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get faqTitle => 'Perguntas Frequentes';

  @override
  String get faqSearchHint => 'Pesquisar perguntas...';

  @override
  String get faqNoResults => 'Nenhum resultado encontrado';

  @override
  String get faqNoResultsSubtitle => 'Tente um termo de pesquisa diferente';

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
  String get faqQ01 => 'O que é Focus Field e como me ajuda a concentrar?';

  @override
  String get faqA01 => 'Focus Field ajuda você a desenvolver melhores hábitos de concentração monitorando o ruído ambiente em seu ambiente. Quando você inicia uma sessão (Estudo, Leitura, Meditação ou Outro), o aplicativo mede o quão silencioso está seu ambiente. Quanto mais silencioso você mantiver, mais \"minutos de concentração\" você ganha. Isso o incentiva a encontrar e manter espaços livres de distrações para trabalho profundo.';

  @override
  String get faqQ02 => 'Como o Focus Field mede minha concentração?';

  @override
  String get faqA02 => 'Focus Field monitorao nível de ruído ambiente em seu ambiente durante sua sessão. Ele calcula uma \"Pontuação Ambiente\" rastreando quantos segundos seu ambiente permanece abaixo do seu limiar de ruído escolhido. Se sua sessão tiver pelo menos 70% de tempo silencioso (Pontuação Ambiente ≥70%), você ganha crédito total por esses minutos silenciosos.';

  @override
  String get faqQ03 => 'O Focus Field grava meu áudio ou conversas?';

  @override
  String get faqA03 => 'Não, absolutamente não. Focus Field apenas mede níveis de decibéis (volume) - nunca grava, armazena ou transmite áudio. Sua privacidade está completamente protegida. O aplicativo simplesmente verifica se seu ambiente está acima ou abaixo do seu limiar escolhido.';

  @override
  String get faqQ04 => 'Quais atividades posso rastrear com Focus Field?';

  @override
  String get faqA04 => 'Focus Field vem com quatro tipos de atividade: Estudo 📚 (para aprendizado e pesquisa), Leitura 📖 (para leitura focada), Meditação 🧘 (para prática de atenção plena) e Outro ⭐ (para qualquer atividade que requer concentração). Todas as atividades usam monitoramento de ruído ambiente para ajudá-lo a manter um ambiente silencioso e focado.';

  @override
  String get faqQ05 => 'Devo usar o Focus Field para todas as minhas atividades?';

  @override
  String get faqA05 => 'Focus Field funciona melhor para atividades onde o ruído ambiente indica seu nível de concentração. Atividades como Estudo, Leitura e Meditação se beneficiam mais de ambientes silenciosos. Embora você possa rastrear atividades \"Outro\", recomendamos usar Focus Field principalmente para trabalho de concentração sensível ao ruído.';

  @override
  String get faqQ06 => 'Como iniciar uma sessão de concentração?';

  @override
  String get faqA06 => 'Vá para a aba Sessões, selecione sua atividade (Estudo, Leitura, Meditação ou Outro), escolha a duração da sua sessão (1, 5, 10, 15, 30 minutos ou opções premium), toque no botão Iniciar no anel de progresso e mantenha seu ambiente silencioso!';

  @override
  String get faqQ07 => 'Quais durações de sessão estão disponíveis?';

  @override
  String get faqA07 => 'Usuários gratuitos podem escolher: sessões de 1, 5, 10, 15 ou 30 minutos. Usuários Premium também obtêm: sessões estendidas de 1 hora, 1,5 hora e 2 horas para períodos mais longos de trabalho profundo.';

  @override
  String get faqQ08 => 'Posso pausar ou parar uma sessão mais cedo?';

  @override
  String get faqA08 => 'Sim! Durante uma sessão, você verá botões de Pausar e Parar acima do anel de progresso. Para evitar toques acidentais, você precisa pressionar longamente esses botões. Se você parar mais cedo, ainda ganhará pontos pelos minutos silenciosos que acumulou.';

  @override
  String get faqQ09 => 'Como ganho pontos no Focus Field?';

  @override
  String get faqA09 => 'Você ganha 1 ponto por minuto silencioso. Durante sua sessão, Focus Field rastreia quantos segundos seu ambiente permanece abaixo do limiar de ruído. No final, esses segundos silenciosos são convertidos em minutos. Por exemplo, se você completar uma sessão de 10 minutos com 8 minutos de tempo silencioso, ganha 8 pontos.';

  @override
  String get faqQ10 => 'O que é o limiar de 70% e por que importa?';

  @override
  String get faqA10 => 'O limiar de 70% determina se sua sessão conta para seu objetivo diário. Se sua Pontuação Ambiente (tempo silencioso ÷ tempo total) for pelo menos 70%, sua sessão qualifica para crédito de missão. Mesmo se estiver abaixo de 70%, você ainda ganha pontos por cada minuto silencioso!';

  @override
  String get faqQ11 => 'Qual é a diferença entre Pontuação Ambiente e pontos?';

  @override
  String get faqA11 => 'Pontuação Ambiente é a qualidade da sua sessão como porcentagem (segundos silenciosos ÷ segundos totais), determinando se você atinge o limiar de 70%. Pontos são os minutos silenciosos reais ganhos (1 ponto = 1 minuto). Pontuação Ambiente = qualidade, Pontos = conquista.';

  @override
  String get faqQ12 => 'Como funcionam as sequências no Focus Field?';

  @override
  String get faqA12 => 'Sequências rastreiam dias consecutivos de atingir seu objetivo diário. Focus Field usa uma Regra Compassiva de 2 Dias: Sua sequência só quebra se você perder dois dias consecutivos. Isso significa que você pode perder um dia e sua sequência continua se você completar seu objetivo no dia seguinte.';

  @override
  String get faqQ13 => 'O que são tokens de congelamento e como usá-los?';

  @override
  String get faqA13 => 'Tokens de congelamento protegem sua sequência quando você não pode completar seu objetivo. Você recebe 1 token de congelamento grátis por mês. Quando usado, seu progresso geral mostra 100% (objetivo protegido), sua sequência está segura e o rastreamento de atividades individuais continua normalmente. Use sabiamente para dias ocupados!';

  @override
  String get faqQ14 => 'Posso personalizar meu objetivo diário de concentração?';

  @override
  String get faqA14 => 'Sim! Toque em Editar no cartão de Sessões na aba Hoje. Você pode definir seu objetivo diário global (10-60 minutos gratuito, até 1080 minutos premium), ativar objetivos por atividade para alvos separados e mostrar/ocultar atividades específicas.';

  @override
  String get faqQ15 => 'O que é o limiar de ruído e como ajustá-lo?';

  @override
  String get faqA15 => 'O limiar é o nível máximo de ruído (em decibéis) que conta como \"silencioso\". O padrão é 40 dB (silêncio de biblioteca). Você pode ajustá-lo na aba Sessões: 30 dB (muito silencioso), 40 dB (silêncio de biblioteca - recomendado), 50 dB (escritório moderado), 60-80 dB (ambientes mais barulhentos).';

  @override
  String get faqQ16 => 'O que é Limiar Adaptativo e devo usá-lo?';

  @override
  String get faqA16 => 'Após 3 sessões bem-sucedidas consecutivas no seu limiar atual, Focus Field sugere aumentá-lo em 2 dB para desafiá-lo. Isso ajuda você a melhorar gradualmente. Você pode aceitar ou recusar a sugestão - ela só aparece uma vez a cada 7 dias.';

  @override
  String get faqQ17 => 'O que é o Modo de Concentração?';

  @override
  String get faqA17 => 'Modo de Concentração é uma sobreposição de tela cheia sem distrações durante sua sessão. Mostra seu cronômetro de contagem regressiva, porcentagem de calma ao vivo e controles mínimos (Pausar/Parar via pressão longa). Remove todos os outros elementos de interface para que você possa se concentrar completamente. Ative em Configurações > Básico > Modo de Concentração.';

  @override
  String get faqQ18 => 'Por que o Focus Field precisa de permissão de microfone?';

  @override
  String get faqA18 => 'Focus Field usa o microfone do seu dispositivo para medir níveis de ruído ambiente (decibéis) durante as sessões. Isso é essencial para calcular sua Pontuação Ambiente. Lembre-se: nenhum áudio é gravado - apenas níveis de ruído são medidos em tempo real.';

  @override
  String get faqQ19 => 'Posso ver meus padrões de concentração ao longo do tempo?';

  @override
  String get faqA19 => 'Sim! A aba Hoje mostra seu progresso diário, tendências semanais, mapa de calor de atividade de 12 semanas (como contribuições do GitHub) e linha do tempo de sessões. Usuários Premium obtêm análises avançadas com métricas de desempenho, médias móveis e insights impulsionados por IA.';

  @override
  String get faqQ20 => 'Como funcionam as notificações no Focus Field?';

  @override
  String get faqA20 => 'Focus Field tem lembretes inteligentes: Lembretes Diários (aprende sua hora de concentração preferida ou usa uma hora fixa), notificações de Sessão Concluída com resultados, notificações de Conquista para marcos e Resumo Semanal (Premium). Ative/personalize em Configurações > Avançado > Notificações.';

  @override
  String get microphoneSettingsTitle => 'Configurações Necessárias';

  @override
  String get microphoneSettingsMessage => 'Para ativar a detecção de silêncio, conceda manualmente a permissão do microfone:\n\n• iOS: Ajustes > Privacidade e Segurança > Microfone > Focus Field\n• Android: Configurações > Aplicativos > Focus Field > Permissões > Microfone';

  @override
  String get buttonGrantPermission => 'Conceder Permissão';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => 'Abrir Configurações';

  @override
  String get onboardingBack => 'Voltar';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get onboardingWelcomeSnackbar => 'Bem-vindo! Pronto para iniciar sua primeira sessão? 🚀';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao\nFocus Field! 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'A sua jornada para um melhor foco começa aqui!\nVamos construir hábitos que permanecem 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Acompanhe o Seu Foco';

  @override
  String get onboardingFeatureTrackDesc => 'Veja o seu progresso em tempo real enquanto constrói o seu superpoder de foco! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Ganhe Recompensas';

  @override
  String get onboardingFeatureRewardsDesc => 'Cada minuto silencioso conta! Colete pontos e celebre suas vitórias 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Construa Sequências';

  @override
  String get onboardingFeatureStreaksDesc => 'Mantenha o impulso! Nosso sistema compassivo mantém você motivado 🔥';

  @override
  String get onboardingEnvironmentTitle => 'Onde está a sua Zona de Foco? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'Escolha seu ambiente típico para que possamos otimizar seu espaço!';

  @override
  String get onboardingEnvQuietHomeTitle => 'Casa Silenciosa';

  @override
  String get onboardingEnvQuietHomeDesc => 'Quarto, escritório em casa silencioso';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Muito silencioso';

  @override
  String get onboardingEnvOfficeTitle => 'Escritório Típico';

  @override
  String get onboardingEnvOfficeDesc => 'Escritório padrão, biblioteca';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Silêncio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusyTitle => 'Espaço Ocupado';

  @override
  String get onboardingEnvBusyDesc => 'Café, espaço de trabalho partilhado';

  @override
  String get onboardingEnvBusyDb => '50 dB - Ruído moderado';

  @override
  String get onboardingEnvNoisyTitle => 'Ambiente Barulhento';

  @override
  String get onboardingEnvNoisyDesc => 'Escritório aberto, espaço público';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Ruído mais alto';

  @override
  String get onboardingEnvAdjustNote => 'Você pode ajustar isso a qualquer momento nas Configurações';

  @override
  String get onboardingGoalTitle => 'Defina Sua Meta Diária! 🎯';

  @override
  String get onboardingGoalSubtitle => 'Quanto tempo de concentração parece certo para você?\n(Você pode ajustar isso a qualquer momento!)';

  @override
  String get onboardingGoalStartingTitle => 'Começando';

  @override
  String get onboardingGoalStartingDuration => '10-15 minutos';

  @override
  String get onboardingGoalHabitTitle => 'Construindo Hábito';

  @override
  String get onboardingGoalHabitDuration => '20-30 minutos';

  @override
  String get onboardingGoalPracticeTitle => 'Prática Regular';

  @override
  String get onboardingGoalPracticeDuration => '40-60 minutos';

  @override
  String get onboardingGoalDeepWorkTitle => 'Trabalho Profundo';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ minutos';

  @override
  String get onboardingGoalAdvice1 => 'Começo perfeito! 🌟 Pequenos passos levam a grandes vitórias. Você consegue!';

  @override
  String get onboardingGoalAdvice2 => 'Excelente escolha! 🎯 Este ponto ideal constrói hábitos duradouros!';

  @override
  String get onboardingGoalAdvice3 => 'Ambicioso! 💪 Você está pronto para subir de nível seu jogo de concentração!';

  @override
  String get onboardingGoalAdvice4 => 'Uau! 🏆 Modo de trabalho profundo ativado! Lembre-se de fazer pausas!';

  @override
  String get onboardingActivitiesTitle => 'Escolha Suas Atividades! ✨';

  @override
  String get onboardingActivitiesSubtitle => 'Escolha todas que ressoam com você!\n(Você sempre pode adicionar mais depois)';

  @override
  String get onboardingActivityStudyTitle => 'Estudo';

  @override
  String get onboardingActivityStudyDesc => 'Aprendizado, trabalhos de curso, pesquisa';

  @override
  String get onboardingActivityReadingTitle => 'Leitura';

  @override
  String get onboardingActivityReadingDesc => 'Leitura profunda, artigos, livros';

  @override
  String get onboardingActivityMeditationTitle => 'Meditação';

  @override
  String get onboardingActivityMeditationDesc => 'Atenção plena, exercícios de respiração';

  @override
  String get onboardingActivityOtherTitle => 'Outro';

  @override
  String get onboardingActivityOtherDesc => 'Qualquer atividade que exija concentração';

  @override
  String get onboardingActivitiesTip => 'Dica profissional: Focus Field brilha quando silêncio = concentração! 🤫✨';

  @override
  String get onboardingPermissionTitle => 'Sua Privacidade Importa! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'Precisamos de acesso ao microfone para medir o ruído ambiente e ajudá-lo a se concentrar melhor';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'Sem Gravação';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'Medimos apenas níveis de ruído, nunca gravamos áudio';

  @override
  String get onboardingPrivacyLocalTitle => 'Apenas Local';

  @override
  String get onboardingPrivacyLocalDesc => 'Todos os dados permanecem no seu dispositivo';

  @override
  String get onboardingPrivacyFirstTitle => 'Privacidade Primeiro';

  @override
  String get onboardingPrivacyFirstDesc => 'Suas conversas são completamente privadas';

  @override
  String get onboardingPermissionNote => 'Você pode conceder permissão na próxima tela ao iniciar sua primeira sessão';

  @override
  String get onboardingTipsTitle => 'Dicas Profissionais para o Sucesso! 💡';

  @override
  String get onboardingTipsSubtitle => 'Estas ajudarão você a aproveitar ao máximo o Focus Field!';

  @override
  String get onboardingTip1Title => 'Comece Pequeno, Ganhe Grande! 🌱';

  @override
  String get onboardingTip1Desc => 'Comece com sessões de 5-10 minutos. Consistência supera perfeição!';

  @override
  String get onboardingTip2Title => 'Ative o Modo de Concentração! 🎯';

  @override
  String get onboardingTip2Desc => 'Toque no Modo de Concentração para uma experiência imersiva sem distrações.';

  @override
  String get onboardingTip3Title => 'Token de Congelamento = Rede de Segurança! ❄️';

  @override
  String get onboardingTip3Desc => 'Use seu token mensal em dias ocupados para proteger sua sequência.';

  @override
  String get onboardingTip4Title => 'A Regra dos 70% é Ótima! 📈';

  @override
  String get onboardingTip4Desc => 'Mire em 70% de tempo silencioso - silêncio perfeito não é necessário!';

  @override
  String get onboardingReadyTitle => 'Você Está Pronto para Decolar! 🚀';

  @override
  String get onboardingReadyDesc => 'Vamos começar sua primeira sessão e construir hábitos incríveis!';

  @override
  String get questMotivation1 => 'O sucesso nunca termina e o fracasso nunca é final';

  @override
  String get questMotivation2 => 'Progresso sobre perfeição - cada minuto conta';

  @override
  String get questMotivation3 => 'Pequenos passos diários levam a grandes mudanças';

  @override
  String get questMotivation4 => 'Você está construindo melhores hábitos, uma sessão de cada vez';

  @override
  String get questMotivation5 => 'Consistência supera intensidade';

  @override
  String get questMotivation6 => 'Cada sessão é uma vitória, não importa quão curta';

  @override
  String get questMotivation7 => 'Foco é um músculo - você está ficando mais forte';

  @override
  String get questMotivation8 => 'A jornada de mil milhas começa com um único passo';

  @override
  String get questGo => 'Ir';

  @override
  String get questTapStart => 'Toque em Iniciar →';

  @override
  String get todayDashboardTitle => 'Seu Painel de Foco';

  @override
  String get todayFocusMinutes => 'Minutos de foco hoje';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Meta: $goalMinutes min • Calma ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Escolha seu modo';

  @override
  String get todayDefaultActivities => 'Estudo • Leitura • Meditação';

  @override
  String get todayTooltipTips => 'Dicas';

  @override
  String get todayTooltipTheme => 'Tema';

  @override
  String get todayTooltipSettings => 'Configurações';

  @override
  String todayThemeChanged(String themeName) {
    return 'Tema alterado para $themeName';
  }

  @override
  String get todayTabToday => 'Hoje';

  @override
  String get todayTabSessions => 'Sessões';

  @override
  String get todayHelperText => 'Defina sua duração e acompanhe seu tempo. O histórico de sessões e análises aparecerão no Resumo.';

  @override
  String get statPoints => 'Pontos';

  @override
  String get statStreak => 'Sequência';

  @override
  String get statSessions => 'Sessões';

  @override
  String get ringProgressTitle => 'Progresso do Anel';

  @override
  String get ringOverall => 'Geral';

  @override
  String get ringOverallFrozen => 'Geral ❄️';

  @override
  String get sessionCalm => 'Calma';

  @override
  String get sessionStart => 'Iniciar';

  @override
  String get sessionStop => 'Parar';

  @override
  String get buttonEdit => 'Editar';

  @override
  String get durationUpTo1Hour => 'Sessões de até 1 hora';

  @override
  String get durationUpTo1_5Hours => 'Sessões de até 1,5 horas';

  @override
  String get durationUpTo2Hours => 'Sessões de até 2 horas';

  @override
  String get durationExtended => 'Durações de sessão estendidas';

  @override
  String get durationExtendedAccess => 'Acesso a sessões estendidas';

  @override
  String get noiseRoomLoudness => 'Volume da Sala';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Limiar: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Limiar definido para $db dB';
  }

  @override
  String get noiseHighDetected => 'Ruído alto detectado, por favor vá para uma sala mais silenciosa para melhor foco';

  @override
  String get noiseThresholdExceededHint => 'Encontre um local mais silencioso ou aumente o limite →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'Encontrar local mais silencioso ou aumentar para ${db}dB?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'Alto ruído detectado. Aumentar para ${db}dB?';
  }

  @override
  String get noiseAtMaxThreshold => 'Já está no limite máximo. Por favor, encontre um local mais silencioso.';

  @override
  String get noiseThresholdYes => 'Sim';

  @override
  String get noiseThresholdNo => 'Não';

  @override
  String get trendsInsights => 'Insights';

  @override
  String get trendsLast7Days => 'Últimos 7 Dias';

  @override
  String get trendsShareWeeklySummary => 'Compartilhar resumo semanal';

  @override
  String get trendsLoading => 'Carregando...';

  @override
  String get trendsLoadingMetrics => 'Carregando métricas...';

  @override
  String get trendsNoData => 'Sem dados';

  @override
  String get trendsWeeklyTotal => 'Total Semanal';

  @override
  String get trendsBestDay => 'Melhor Dia';

  @override
  String get trendsActivityHeatmap => 'Mapa de Calor de Atividade';

  @override
  String get trendsRecentActivity => 'Atividade recente';

  @override
  String get trendsHeatmapError => 'Não foi possível carregar o mapa de calor';

  @override
  String get dayMon => 'Seg';

  @override
  String get dayTue => 'Ter';

  @override
  String get dayWed => 'Qua';

  @override
  String get dayThu => 'Qui';

  @override
  String get dayFri => 'Sex';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get focusModeComplete => 'Sessão Completa!';

  @override
  String get focusModeGreatSession => 'Ótima sessão de foco';

  @override
  String get focusModeResume => 'Retomar';

  @override
  String get focusModePause => 'Pausar';

  @override
  String get focusModeLongPressHint => 'Pressione longamente para pausar ou parar';

  @override
  String get activityEditTitle => 'Editar Atividades';

  @override
  String get activityRecommendation => 'Recomendado: 10+ min por atividade para construção consistente de hábitos';

  @override
  String get activityDailyGoals => 'Metas Diárias';

  @override
  String activityTotalHours(String hours) {
    return 'Total: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Por Atividade';

  @override
  String get activityExceedsLimit => 'O total excede o limite diário de 18 horas. Por favor, reduza as metas.';

  @override
  String get activityGoalLabel => 'Meta';

  @override
  String get activityGoalDescription => 'Defina sua meta de foco diária (1 min - 18h)';

  @override
  String get shareYourProgress => 'Compartilhe Seu Progresso';

  @override
  String get shareTimeRange => 'Intervalo de Tempo';

  @override
  String get shareCardSize => 'Tamanho do Cartão';

  @override
  String get analyticsPerformanceMetrics => 'Métricas de Desempenho';

  @override
  String get analyticsPreferredDuration => 'Duração Preferida';

  @override
  String get analyticsUnavailable => 'Análise indisponível';

  @override
  String get analyticsRestoreAttempt => 'Tentaremos restaurar esta seção na próxima inicialização do aplicativo.';

  @override
  String get audioUnavailable => 'Áudio temporariamente indisponível';

  @override
  String get audioRecovering => 'O processamento de áudio encontrou um problema. Recuperando automaticamente...';

  @override
  String get shareQuietMinutes => 'MINUTOS TRANQUILOS';

  @override
  String get shareTopActivity => 'Atividade Principal';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Visualizar';

  @override
  String get sharePinchToZoom => 'Apertar para ampliar';

  @override
  String get shareGenerating => 'Gerando...';

  @override
  String get shareButton => 'Compartilhar';

  @override
  String get shareTodayLabel => 'Hoje';

  @override
  String get shareWeeklyLabel => 'Semanal';

  @override
  String get shareTodayTitle => 'Seu Foco de Hoje';

  @override
  String get shareWeeklyTitle => 'Seu Foco Semanal';

  @override
  String get shareSubject => 'Meu Progresso no Focus Field';

  @override
  String get shareFormatSquare => 'Proporção 1:1 • Compatibilidade universal';

  @override
  String get shareFormatPost => 'Proporção 4:5 • Posts Instagram/Twitter';

  @override
  String get shareFormatStory => 'Proporção 9:16 • Stories do Instagram';

  @override
  String get recapWeeklyTitle => 'Resumo Semanal';

  @override
  String get recapMinutes => 'Minutos';

  @override
  String recapStreak(int start, int end) {
    return 'Sequência: $start → $end dias';
  }

  @override
  String get recapTopActivity => 'Atividade Principal: ';

  @override
  String get practiceOverviewTitle => 'Visão Geral da Prática';

  @override
  String get practiceLast7Days => 'Últimos 7 Dias';

  @override
  String get audioMultipleErrors => 'Múltiplos erros de áudio detectados. Componente recuperando...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Meta atual: $goal';
  }

  @override
  String get activitySaveChanges => 'Salvar Alterações';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsTooltip => 'Ver insights detalhados';

  @override
  String get statDays => 'DIAS';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Total Hoje $done/$goal min, escolha qualquer atividade';
  }

  @override
  String get premiumFeature => 'Recurso Premium';

  @override
  String get premiumFeatureAccess => 'Acesso a recurso premium';

  @override
  String get activityUnknown => 'Desconhecido';

  @override
  String get insightsFirstSessionTitle => 'Complete sua primeira sessão';

  @override
  String get insightsFirstSessionSubtitle => 'Comece a rastrear seu tempo de foco, padrões de sessão e tendências de pontuação ambiente';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Ambiente: $percent%';
  }

  @override
  String get sessionSuccess => 'Sucesso';

  @override
  String get sessionFailed => 'Falhou';

  @override
  String get focusModeButton => 'Modo de Foco';

  @override
  String get settingsDailyGoalsTitle => 'Objetivos Diários';

  @override
  String get settingsFocusModeDescription => 'Minimize as distrações durante as sessões com uma sobreposição focada';

  @override
  String get settingsDeepFocusTitle => 'Foco Profundo';

  @override
  String get settingsDeepFocusDescription => 'Terminar sessão se a aplicação for deixada';

  @override
  String get deepFocusDialogTitle => 'Foco Profundo';

  @override
  String get deepFocusEnableLabel => 'Ativar Foco Profundo';

  @override
  String get deepFocusGracePeriodLabel => 'Período de graça (segundos)';

  @override
  String get deepFocusExplanation => 'Quando ativado, sair da aplicação terminará a sessão após o período de graça.';

  @override
  String get notificationPermissionTitle => 'Ativar Notificações';

  @override
  String get notificationPermissionExplanation => 'Focus Field precisa de permissão de notificação para lhe enviar:';

  @override
  String get notificationBenefitReminders => 'Lembretes diários de foco';

  @override
  String get notificationBenefitCompletion => 'Alertas de sessão concluída';

  @override
  String get notificationBenefitAchievements => 'Celebrações de conquistas';

  @override
  String get notificationHowToEnableIos => 'Como ativar no iOS:';

  @override
  String get notificationHowToEnableAndroid => 'Como ativar no Android:';

  @override
  String get notificationStepsIos => '1. Toque em \"Abrir Definições\" abaixo\n2. Toque em \"Notificações\"\n3. Ative \"Permitir Notificações\"';

  @override
  String get notificationStepsAndroid => '1. Toque em \"Abrir Definições\" abaixo\n2. Toque em \"Notificações\"\n3. Ative \"Todas as notificações do Focus Field\"';

  @override
  String get aboutShowTips => 'Mostrar Dicas';

  @override
  String get aboutShowTipsDescription => 'Mostra dicas úteis no arranque da aplicação e através do ícone de lâmpada. As dicas aparecem a cada 2-3 dias.';

  @override
  String get aboutReplayOnboarding => 'Repetir Introdução';

  @override
  String get aboutReplayOnboardingDescription => 'Reveja o tour da aplicação e configure as suas preferências novamente';

  @override
  String get buttonFaq => 'FAQ';

  @override
  String get onboardingWelcomeMessage => 'Bem-vindo! Pronto para começar a sua primeira sessão? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Ganhar Recompensas';

  @override
  String get onboardingFeatureEarnDesc => 'Cada minuto silencioso conta! Colete pontos e celebre as suas vitórias 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Construir Sequências';

  @override
  String get onboardingFeatureBuildDesc => 'Mantenha o impulso! O nosso sistema compassivo mantém-no motivado 🔥';

  @override
  String get onboardingEnvironmentDescription => 'Escolha o seu ambiente típico para que possamos otimizar o seu espaço!';

  @override
  String get onboardingEnvQuietHome => 'Casa Silenciosa';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Muito silencioso';

  @override
  String get onboardingEnvOffice => 'Escritório Típico';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Silêncio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusy => 'Espaço Movimentado';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Ruído moderado';

  @override
  String get onboardingEnvNoisy => 'Ambiente Ruidoso';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Ruído mais alto';

  @override
  String get onboardingAdjustAnytime => 'Pode ajustar isto a qualquer momento nas Definições';

  @override
  String starterSessionTip(int starterMinutes, int goalMinutes) {
    return '👋 Começando com uma sessão de $starterMinutes minutos para ajudá-lo a se adaptar. Sua meta completa de $goalMinutes minutos está pronta quando você estiver!';
  }

  @override
  String get buttonGotIt => 'Entendi';

  @override
  String get buttonGetStarted => 'Começar';

  @override
  String get buttonNext => 'Seguinte';

  @override
  String get errorActivityRequired => '⚠️ Pelo menos uma atividade deve estar ativada';

  @override
  String get errorGoalExceeds => 'Os objetivos totais excedem o limite diário de 18 horas. Por favor, reduza os objetivos.';

  @override
  String get messageSaved => 'Definições guardadas';

  @override
  String get errorPermissionRequired => 'Permissão necessária';

  @override
  String get notificationEnableReason => 'Ative as notificações para receber lembretes e celebrar conquistas.';

  @override
  String get buttonEnableNotifications => 'Ativar Notificações';

  @override
  String get buttonRequesting => 'A solicitar...';

  @override
  String get notificationDailyTime => 'Hora Diária';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Lembrete diário às $time';
  }

  @override
  String get notificationLearning => 'a aprender';

  @override
  String notificationSmart(String time) {
    return 'Inteligente ($time)';
  }

  @override
  String get buttonUseSmart => 'Usar Inteligente';

  @override
  String get notificationSmartExplanation => 'Escolha uma hora fixa ou deixe o Focus Field aprender o seu padrão.';

  @override
  String get notificationSessionComplete => 'Sessão Concluída';

  @override
  String get notificationSessionCompleteDesc => 'Celebrar sessões concluídas';

  @override
  String get notificationAchievement => 'Conquista Desbloqueada';

  @override
  String get notificationAchievementDesc => 'Notificações de marcos';

  @override
  String get notificationWeekly => 'Resumo Semanal de Progresso';

  @override
  String get notificationWeeklyDesc => 'Insights semanais (dia da semana e hora)';

  @override
  String get notificationWeeklyTime => 'Hora Semanal';

  @override
  String get notificationMilestone => 'Notificações de marcos';

  @override
  String get notificationWeeklyInsights => 'Insights semanais (dia da semana e hora)';

  @override
  String get notificationDailyReminder => 'Lembrete diário';

  @override
  String get notificationComplete => 'Sessão concluída';

  @override
  String get settingsSnackbar => 'Por favor, ative as notificações nas configurações do dispositivo';

  @override
  String get shareCardTitle => 'Compartilhar cartão';

  @override
  String get shareYourWeek => 'Compartilhe sua semana';

  @override
  String get shareStyleGradient => 'Estilo gradiente';

  @override
  String get shareStyleGradientDesc => 'Gradiente ousado com números grandes';

  @override
  String get shareWeeklySummary => 'Resumo semanal';

  @override
  String get shareStyleAchievement => 'Estilo de conquista';

  @override
  String get shareStyleAchievementDesc => 'Foco no total de minutos silenciosos';

  @override
  String get shareQuietMinutesWeek => 'Minutos silenciosos esta semana';

  @override
  String get shareAchievementMessage => 'Construindo foco mais profundo,\\numa sessão de cada vez';

  @override
  String get shareAchievementCard => 'Cartão de conquista';

  @override
  String get shareTextOnly => 'Apenas texto';

  @override
  String get shareTextOnlyDesc => 'Compartilhar como texto simples (sem imagem)';

  @override
  String get shareYourStreak => 'Compartilhe sua sequência';

  @override
  String get shareAsCard => 'Compartilhar como cartão';

  @override
  String get shareAsCardDesc => 'Cartão visual bonito';

  @override
  String get shareStreakCard => 'Cartão de sequência';

  @override
  String get shareAsText => 'Compartilhar como texto';

  @override
  String get shareAsTextDesc => 'Mensagem de texto simples';

  @override
  String get shareErrorFailed => 'Falha ao compartilhar. Por favor, tente novamente.';

  @override
  String get buttonShare => 'Compartilhar';

  @override
  String get initializingApp => 'Inicializando aplicativo...';

  @override
  String initializationFailed(String error) {
    return 'Falha na inicialização: $error';
  }

  @override
  String get loadingSettings => 'Carregando configurações...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Falha ao carregar configurações: $error';
  }

  @override
  String get loadingUserData => 'Carregando dados do usuário...';

  @override
  String dataLoadingFailed(String error) {
    return 'Falha ao carregar dados: $error';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get taglineSilence => '🤫 Domine a arte do silêncio';

  @override
  String get errorOops => 'Ops! Algo deu errado';

  @override
  String get buttonRetry => 'Tentar novamente';

  @override
  String get resetAppData => 'Redefinir dados do aplicativo';

  @override
  String get resetAppDataMessage => 'Isso redefinirá todos os dados e configurações do aplicativo para seus padrões. Esta ação não pode ser desfeita.\\n\\nDeseja continuar?';

  @override
  String get buttonReset => 'Redefinir';

  @override
  String get messageDataReset => 'Os dados do aplicativo foram redefinidos';

  @override
  String errorResetFailed(String error) {
    return 'Falha ao redefinir dados: $error';
  }

  @override
  String get analyticsTitle => 'Análise';

  @override
  String get analyticsOverview => 'Visão geral';

  @override
  String get analyticsPoints => 'Pontos';

  @override
  String get analyticsStreak => 'Sequência';

  @override
  String get analyticsSessions => 'Sessões';

  @override
  String get analyticsLast7Days => 'Últimos 7 dias';

  @override
  String get analyticsPerformanceHighlights => 'Destaques de desempenho';

  @override
  String get analyticsSuccessRate => 'Taxa de sucesso';

  @override
  String get analyticsAvgSession => 'Sessão média';

  @override
  String get analyticsBestStreak => 'Melhor sequência';

  @override
  String get analyticsActivityProgress => 'Progresso da atividade';

  @override
  String get analyticsComingSoon => 'Rastreamento detalhado de atividades em breve.';

  @override
  String get analyticsAdvancedMetrics => 'Métricas avançadas';

  @override
  String get analyticsPremiumContent => 'Conteúdo de análise avançada premium aqui...';

  @override
  String get analytics30DayTrends => 'Tendências de 30 dias';

  @override
  String get analyticsTrendsChart => 'Gráfico de tendências premium aqui...';

  @override
  String get analyticsAIInsights => 'Insights de IA';

  @override
  String get analyticsAIComingSoon => 'Insights alimentados por IA em breve...';

  @override
  String get analyticsUnlock => 'Desbloquear análise avançada';

  @override
  String get errorTitle => 'Erro';

  @override
  String get errorQuestUnavailable => 'Estado da missão não disponível';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Falha ao usar o token de congelamento';

  @override
  String get buttonUseFreeze => 'Usar congelamento';

  @override
  String get onboardingDailyGoalTitle => 'Defina sua meta diária! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'Quanto tempo de foco parece certo para você?\\n(Você pode ajustar a qualquer momento!)';

  @override
  String get onboardingGoalGettingStarted => 'Começando';

  @override
  String get onboardingGoalBuildingHabit => 'Construindo hábito';

  @override
  String get onboardingGoalRegularPractice => 'Prática regular';

  @override
  String get onboardingGoalDeepWork => 'Trabalho profundo';

  @override
  String get onboardingProTip => 'Dica profissional: Focus Field brilha quando silêncio = foco! 🤫✨';

  @override
  String get onboardingPrivacyTitle => 'Sua privacidade importa! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'Precisamos de acesso ao microfone para medir o ruído ambiente e ajudá-lo a se concentrar melhor';

  @override
  String get onboardingPrivacyNoRecording => 'Sem gravação';

  @override
  String get onboardingPrivacyLocalOnly => 'Apenas local';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'Todos os dados permanecem no seu dispositivo';

  @override
  String get onboardingPrivacyFirst => 'Privacidade em primeiro lugar';

  @override
  String get onboardingPrivacyNote => 'Você pode conceder permissão na próxima tela ao iniciar sua primeira sessão';

  @override
  String get insightsFocusTime => 'Tempo de foco';

  @override
  String get insightsSessions => 'Sessões';

  @override
  String get insightsAverage => 'Média';

  @override
  String get insightsAmbientScore => 'Pontuação ambiente';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeOceanBlue => 'Azul oceano';

  @override
  String get themeForestGreen => 'Verde floresta';

  @override
  String get themePurpleNight => 'Noite roxa';

  @override
  String get themeGold => 'Gold';

  @override
  String get themeSolarSunrise => 'Nascer do sol solar';

  @override
  String get themeCyberNeon => 'Neon cibernético';

  @override
  String get themeLuxury => 'Luxury';

  @override
  String get settingsAppTheme => 'Tema do aplicativo';

  @override
  String get freezeTokenNoTokensTitle => 'Sem Tokens de Congelamento';

  @override
  String get freezeTokenNoTokensMessage => 'Você não tem tokens de congelamento disponíveis. Você ganha 1 token por semana (máximo 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Meta Já Concluída';

  @override
  String get freezeTokenGoalCompleteMessage => 'Sua meta diária já está completa! Tokens de congelamento só podem ser usados quando você ainda não atingiu sua meta.';

  @override
  String get freezeTokenUseTitle => 'Usar Token de Congelamento';

  @override
  String get freezeTokenUseMessage => 'Tokens de congelamento protegem sua sequência quando você perde um dia. Usar um congelamento contará como completar sua meta diária.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'Você tem $count token(s). Usar um agora?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ Token de congelamento usado! Meta marcada como concluída.';

  @override
  String get trendsErrorLoading => 'Erro ao carregar dados';

  @override
  String get trendsPoints => 'Pontos';

  @override
  String get trendsStreak => 'Sequência';

  @override
  String get trendsSessions => 'Sessões';

  @override
  String get trendsTopActivity => 'Atividade Principal';

  @override
  String get sectionToday => 'Hoje';

  @override
  String get sectionSessions => 'Sessões';

  @override
  String get sectionInsights => 'Insights';

  @override
  String get onboardingGoalAdviceGettingStarted => 'Começo perfeito! 🌟 Pequenos passos levam a grandes vitórias. Você consegue!';

  @override
  String get onboardingGoalAdviceBuildingHabit => 'Excelente escolha! 🎯 Este ponto ideal constrói hábitos duradouros!';

  @override
  String get onboardingGoalAdviceRegularPractice => 'Ambicioso! 💪 Você está pronto para melhorar seu foco!';

  @override
  String get onboardingGoalAdviceDeepWork => 'Uau! 🏆 Modo de trabalho profundo ativado! Lembre-se de fazer pausas!';

  @override
  String get onboardingDuration10to15 => '10-15 minutos';

  @override
  String get onboardingDuration20to30 => '20-30 minutos';

  @override
  String get onboardingDuration40to60 => '40-60 minutos';

  @override
  String get onboardingDuration60plus => '60+ minutos';

  @override
  String get activityStudy => 'Estudo';

  @override
  String get activityReading => 'Leitura';

  @override
  String get activityMeditation => 'Meditação';

  @override
  String get activityOther => 'Outro';

  @override
  String get onboardingTip1Description => 'Comece com sessões de 5-10 minutos. Consistência supera perfeição!';

  @override
  String get onboardingTip2Description => 'Toque no Modo Foco para uma experiência imersiva sem distrações.';

  @override
  String get onboardingTip3Description => 'Use seu token mensal em dias ocupados para proteger sua sequência.';

  @override
  String get onboardingTip4Description => 'Aponte para 70% de tempo silencioso - silêncio perfeito não é necessário!';

  @override
  String get onboardingLaunchTitle => 'Você Está Pronto para Começar! 🚀';

  @override
  String get onboardingLaunchDescription => 'Vamos começar sua primeira sessão e construir hábitos incríveis!';

  @override
  String get insightsBestTimeByActivity => 'Melhor horário por atividade';

  @override
  String get insightHighSuccessRateTitle => 'Alta taxa de sucesso';

  @override
  String get insightEnvironmentStabilityTitle => 'Estabilidade Ambiental';

  @override
  String get insightLowNoiseSuccessTitle => 'Sucesso de baixo ruído';

  @override
  String get insightConsistentPracticeTitle => 'Prática Consistente';

  @override
  String get insightStreakProtectionTitle => 'Proteção contra riscos disponível';

  @override
  String get insightRoomTooNoisyTitle => 'Quarto muito barulhento';

  @override
  String get insightIrregularScheduleTitle => 'Horário Irregular';

  @override
  String get insightLowAmbientScoreTitle => 'Pontuação ambiental baixa';

  @override
  String get insightNoRecentSessionsTitle => 'Nenhuma sessão recente';

  @override
  String get insightHighSuccessRateDesc => 'Você está mantendo fortes sessões silenciosas.';

  @override
  String get insightEnvironmentStabilityDesc => 'O ruído ambiente está dentro de uma faixa moderada e gerenciável.';

  @override
  String get insightLowNoiseSuccessDesc => 'Seu ambiente é excepcionalmente silencioso durante as sessões.';

  @override
  String get insightConsistentPracticeDesc => 'Você está construindo um hábito de prática diária confiável.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'Você tem $count token(s) de congelamento para proteger sua sequência.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Tente encontrar um espaço mais silencioso ou ajustar seu limite.';

  @override
  String get insightIrregularScheduleDesc => 'Tempos de sessão mais consistentes podem melhorar sua sequência.';

  @override
  String get insightLowAmbientScoreDesc => 'As sessões recentes tiveram menor tempo de silêncio. Experimente um ambiente mais silencioso.';

  @override
  String get insightNoRecentSessionsDesc => 'Comece uma sessão hoje para construir seu hábito de foco!';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return 'Ótimo trabalho! $minutes minutos de foco na sua sessão! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return 'Bom esforço! $minutes minutos concluídos.';
  }

  @override
  String get sessionCompleteFailed => 'A sessão terminou. Tente novamente quando estiver pronto.';

  @override
  String get notificationSessionStarted => 'Sessão iniciada - mantenha o foco!';

  @override
  String get notificationSessionPaused => 'Sessão pausada';

  @override
  String get notificationSessionResumed => 'Sessão retomada';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

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
  String get legalDisclaimer => 'Assinatura com renovação automática. Cancele a qualquer momento nas configurações da loja.';

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
  String get resetDataConfirmation => 'Tem certeza que deseja redefinir seu progresso?';

  @override
  String get resetDataSuccess => 'Dados redefinidos';

  @override
  String get decibelThresholdLabel => 'Limite de decibéis';

  @override
  String get decibelThresholdHint => 'Defina o nível máximo de ruído (dB)';

  @override
  String get microphonePermissionTitle => 'Permissão de microfone';

  @override
  String get microphonePermissionMessage => 'Focus Field mede os níveis de som ambiente para ajudá-lo a manter ambientes silenciosos.\n\nO aplicativo precisa de acesso ao microfone para detectar o silêncio, mas não grava nenhum áudio.';

  @override
  String get permissionDeniedMessage => 'Permissão de microfone necessária. Ative nas configurações.';

  @override
  String get noiseMeterError => 'Não foi possível acessar o microfone';

  @override
  String get premiumFeaturesTitle => 'Recursos Premium';

  @override
  String get premiumDescription => 'Desbloqueie sessões longas, análises e exportação';

  @override
  String get premiumRequiredMessage => 'Requer assinatura Premium';

  @override
  String get subscriptionSuccessMessage => 'Assinatura concluída!';

  @override
  String get subscriptionErrorMessage => 'Não foi possível concluir a assinatura';

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
  String get splashTagline => 'Meça o Silêncio, Construa Foco';

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
  String get resetAllSettingsDescription => 'Isto redefinirá todas as configurações e dados. Irreversível.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Redefinir';

  @override
  String get allSettingsReset => 'Todas as configurações e dados foram redefinidos';

  @override
  String get decibelThresholdMaxNoise => 'Limite de decibéis (ruído máx)';

  @override
  String get highThresholdWarningText => 'Limite alto pode ignorar ruídos importantes.';

  @override
  String get decibelThresholdTooltip => 'Ambientes silenciosos: 30–40 dB. Calibre; aumente só se o zumbido contar.';

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
  String get emailOpenDescription => 'Abre seu e-mail com info do sistema pré-preenchida';

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
  String get accessibilitySettingsSaved => 'Configurações de acessibilidade salvas';

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
  String get upgradeRequired => 'Atualização Necessária';

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
  String get achievementLockedPrompt => 'Complete sessões para desbloquear conquistas';

  @override
  String get ratingPromptTitle => 'Está gostando do Focus Field?';

  @override
  String get ratingPromptBody => 'Uma avaliação 5★ rápida ajuda outros a encontrar foco calmo.';

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
  String get notificationPermissionRationale => 'Ative notificações para receber lembretes e celebrar conquistas.';

  @override
  String get requesting => 'Solicitando...';

  @override
  String get enableNotificationsCta => 'Ativar notificações';

  @override
  String get enableNotificationsTitle => 'Ativar notificações';

  @override
  String get enableNotificationsSubtitle => 'Permitir que o Focus Field envie notificações';

  @override
  String get dailyReminderTitle => 'Lembrete diário inteligente';

  @override
  String get dailyReminderSubtitle => 'Inteligente ou horário escolhido';

  @override
  String get dailyTimeLabel => 'Horário diário';

  @override
  String get dailyTimeHint => 'Escolha um horário fixo ou deixe o app aprender seu padrão.';

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
  String get notificationPreview => 'Pré-visualização de Notificação';

  @override
  String get dailySilenceReminderTitle => 'Lembrete diário de foco';

  @override
  String get weeklyProgressReportTitle => 'Relatório semanal 📊';

  @override
  String get achievementUnlockedGenericTitle => 'Conquista desbloqueada! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'Sessão concluída! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'Sessão finalizada';

  @override
  String get reminderStartJourney => '🎯 Comece hoje sua jornada de foco! Construa seu hábito de trabalho profundo.';

  @override
  String get reminderRestart => '🌱 Recomeçar a prática? Cada momento é uma nova oportunidade de foco.';

  @override
  String get reminderDayTwo => '⭐ Dia 2 da sua sequência de foco! Consistência constrói concentração.';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 Sequência de $streak dias de foco! Você está criando um hábito forte.';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 Incrível sequência de $streak dias! Sua dedicação inspira.';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 Sequência impressionante de $streak dias! Você é um campeão de foco!';
  }

  @override
  String get achievementFirstSession => '🎉 Primeira sessão concluída! Bem-vindo(a) ao Focus Field!';

  @override
  String get achievementWeekStreak => '🌟 Sequência de 7 dias! Consistência é seu superpoder.';

  @override
  String get achievementMonthStreak => '🏆 Sequência de 30 dias desbloqueada! Imparável.';

  @override
  String get achievementPerfectSession => '✨ Sessão perfeita! 100% de ambiente calmo mantido!';

  @override
  String get achievementLongSession => '⏰ Sessão longa dominada. Foco crescente.';

  @override
  String get achievementGeneric => '🎊 Conquista desbloqueada! Continue assim!';

  @override
  String get weeklyProgressNone => '💭 Comece seu objetivo semanal! Pronto(a) para uma sessão focada?';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 $count minutos de foco esta semana! Cada sessão conta.';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 $count minutos de foco conquistados! Encontrando o ritmo.';
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
  String get tip01 => 'Comece pequeno—até 2 minutos constroem seu hábito de foco.';

  @override
  String get tip02 => 'Sua sequência tem graça—uma falta não a quebrará com a Regra de 2 Dias.';

  @override
  String get tip03 => 'Experimente atividades de Estudo, Leitura ou Meditação para combinar com seu estilo de foco.';

  @override
  String get tip04 => 'Confira seu Mapa de Calor de 12 semanas para ver como pequenas vitórias se acumulam ao longo do tempo.';

  @override
  String get tip05 => 'Observe sua % de Calma ao vivo durante as sessões—pontuações mais altas significam melhor foco!';

  @override
  String get tip06 => 'Personalize sua meta diária (10-60 min) para combinar com seu ritmo.';

  @override
  String get tip07 => 'Use seu Token de Congelamento mensal para proteger sua sequência em dias difíceis.';

  @override
  String get tip08 => 'Após 3 vitórias, o Focus Field sugere um limiar mais rigoroso—pronto para subir de nível?';

  @override
  String get tip09 => 'Ruído ambiente alto? Aumente seu limiar para permanecer na zona.';

  @override
  String get tip10 => 'Lembretes Diários Inteligentes aprendem seu melhor momento—deixe-os guiá-lo.';

  @override
  String get tip11 => 'O anel de progresso é tocável—um toque inicia sua sessão de foco.';

  @override
  String get tip12 => 'Recalibre quando seu ambiente mudar para melhor precisão.';

  @override
  String get tip13 => 'Notificações de sessão celebram suas vitórias—ative-as para motivação!';

  @override
  String get tip14 => 'Consistência vence perfeição—apareça, mesmo em dias ocupados.';

  @override
  String get tip15 => 'Experimente diferentes momentos do dia para descobrir seu ponto doce tranquilo.';

  @override
  String get tip16 => 'Seu progresso diário está sempre visível—toque em Ir para começar a qualquer momento.';

  @override
  String get tip17 => 'Cada atividade rastreia separadamente em direção à sua meta—variedade mantém as coisas frescas.';

  @override
  String get tip18 => 'Exporte seus dados (Premium) para ver sua jornada de foco completa.';

  @override
  String get tip19 => 'Confete celebra cada conclusão—pequenas vitórias merecem reconhecimento!';

  @override
  String get tip20 => 'Sua linha de base importa—calibre ao mudar para novos espaços.';

  @override
  String get tip21 => 'Suas Tendências de 7 Dias revelam padrões—confira-as semanalmente para insights.';

  @override
  String get tip22 => 'Atualize a duração da sessão (Premium) para blocos de foco profundo mais longos.';

  @override
  String get tip23 => 'Foco é uma prática—pequenas sessões constroem o hábito que você deseja.';

  @override
  String get tip24 => 'O Resumo Semanal mostra seu ritmo—ajuste-o ao seu cronograma.';

  @override
  String get tip25 => 'Ajuste seu limiar para seu espaço—cada sala é diferente.';

  @override
  String get tip26 => 'Opções de acessibilidade ajudam todos a focar—alto contraste, texto grande, vibração.';

  @override
  String get tip27 => 'Linha do Tempo de Hoje mostra quando você focou—encontre suas horas produtivas.';

  @override
  String get tip28 => 'Termine o que você começa—sessões mais curtas significam mais conclusões.';

  @override
  String get tip29 => 'Minutos Silenciosos somam em direção à sua meta—progresso sobre perfeição.';

  @override
  String get tip30 => 'Você está a um toque de distância—comece uma pequena sessão agora.';

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
  String get tipInstructionHeatmap => 'Aba Resumo → Mostrar Mais → Mapa de Calor';

  @override
  String get tipInstructionTodayTimeline => 'Aba Resumo → Mostrar Mais → Linha do Tempo de Hoje';

  @override
  String get tipInstruction7DayTrends => 'Aba Resumo → Mostrar Mais → Tendências de 7 Dias';

  @override
  String get tipInstructionEditActivities => 'Aba Atividade → toque em Editar para mostrar/ocultar atividades';

  @override
  String get tipInstructionQuestGo => 'Aba Atividade → Cápsula de Missão → toque em Ir';

  @override
  String get tipInfoTooltip => 'Mostrar dica';

  @override
  String get questCapsuleTitle => 'Missão Ambiental';

  @override
  String get questCapsuleLoading => 'Carregando minutos calmos…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return 'Calma $progress/$goal min • Sequência $streak';
  }

  @override
  String get questFreezeButton => 'Congelar';

  @override
  String get questFrozenToday => 'Hoje congelado — você está protegido.';

  @override
  String get questGoButton => 'Ir';

  @override
  String calmPercent(int percent) {
    return 'Calma $percent%';
  }

  @override
  String get calmLabel => 'Calma';

  @override
  String get day => 'dia';

  @override
  String get days => 'dias';

  @override
  String get freeze => 'congelar';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3 vitórias! Tentar $threshold dB?';
  }

  @override
  String get adaptiveThresholdNotNow => 'Agora não';

  @override
  String get adaptiveThresholdTryIt => 'Tentar';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'Limiar definido para $threshold dB';
  }

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get error => 'Erro';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get faqTitle => 'Perguntas Frequentes';

  @override
  String get faqSearchHint => 'Pesquisar perguntas...';

  @override
  String get faqNoResults => 'Nenhum resultado encontrado';

  @override
  String get faqNoResultsSubtitle => 'Tente um termo de pesquisa diferente';

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
  String get faqQ01 => 'O que é Focus Field e como me ajuda a concentrar?';

  @override
  String get faqA01 => 'Focus Field ajuda você a desenvolver melhores hábitos de concentração monitorando o ruído ambiente em seu ambiente. Quando você inicia uma sessão (Estudo, Leitura, Meditação ou Outro), o aplicativo mede o quão silencioso está seu ambiente. Quanto mais silencioso você mantiver, mais \"minutos de concentração\" você ganha. Isso o incentiva a encontrar e manter espaços livres de distrações para trabalho profundo.';

  @override
  String get faqQ02 => 'Como o Focus Field mede minha concentração?';

  @override
  String get faqA02 => 'Focus Field monitorao nível de ruído ambiente em seu ambiente durante sua sessão. Ele calcula uma \"Pontuação Ambiente\" rastreando quantos segundos seu ambiente permanece abaixo do seu limiar de ruído escolhido. Se sua sessão tiver pelo menos 70% de tempo silencioso (Pontuação Ambiente ≥70%), você ganha crédito total por esses minutos silenciosos.';

  @override
  String get faqQ03 => 'O Focus Field grava meu áudio ou conversas?';

  @override
  String get faqA03 => 'Não, absolutamente não. Focus Field apenas mede níveis de decibéis (volume) - nunca grava, armazena ou transmite áudio. Sua privacidade está completamente protegida. O aplicativo simplesmente verifica se seu ambiente está acima ou abaixo do seu limiar escolhido.';

  @override
  String get faqQ04 => 'Quais atividades posso rastrear com Focus Field?';

  @override
  String get faqA04 => 'Focus Field vem com quatro tipos de atividade: Estudo 📚 (para aprendizado e pesquisa), Leitura 📖 (para leitura focada), Meditação 🧘 (para prática de atenção plena) e Outro ⭐ (para qualquer atividade que requer concentração). Todas as atividades usam monitoramento de ruído ambiente para ajudá-lo a manter um ambiente silencioso e focado.';

  @override
  String get faqQ05 => 'Devo usar o Focus Field para todas as minhas atividades?';

  @override
  String get faqA05 => 'Focus Field funciona melhor para atividades onde o ruído ambiente indica seu nível de concentração. Atividades como Estudo, Leitura e Meditação se beneficiam mais de ambientes silenciosos. Embora você possa rastrear atividades \"Outro\", recomendamos usar Focus Field principalmente para trabalho de concentração sensível ao ruído.';

  @override
  String get faqQ06 => 'Como iniciar uma sessão de concentração?';

  @override
  String get faqA06 => 'Vá para a aba Sessões, selecione sua atividade (Estudo, Leitura, Meditação ou Outro), escolha a duração da sua sessão (1, 5, 10, 15, 30 minutos ou opções premium), toque no botão Iniciar no anel de progresso e mantenha seu ambiente silencioso!';

  @override
  String get faqQ07 => 'Quais durações de sessão estão disponíveis?';

  @override
  String get faqA07 => 'Usuários gratuitos podem escolher: sessões de 1, 5, 10, 15 ou 30 minutos. Usuários Premium também obtêm: sessões estendidas de 1 hora, 1,5 hora e 2 horas para períodos mais longos de trabalho profundo.';

  @override
  String get faqQ08 => 'Posso pausar ou parar uma sessão mais cedo?';

  @override
  String get faqA08 => 'Sim! Durante uma sessão, você verá botões de Pausar e Parar acima do anel de progresso. Para evitar toques acidentais, você precisa pressionar longamente esses botões. Se você parar mais cedo, ainda ganhará pontos pelos minutos silenciosos que acumulou.';

  @override
  String get faqQ09 => 'Como ganho pontos no Focus Field?';

  @override
  String get faqA09 => 'Você ganha 1 ponto por minuto silencioso. Durante sua sessão, Focus Field rastreia quantos segundos seu ambiente permanece abaixo do limiar de ruído. No final, esses segundos silenciosos são convertidos em minutos. Por exemplo, se você completar uma sessão de 10 minutos com 8 minutos de tempo silencioso, ganha 8 pontos.';

  @override
  String get faqQ10 => 'O que é o limiar de 70% e por que importa?';

  @override
  String get faqA10 => 'O limiar de 70% determina se sua sessão conta para seu objetivo diário. Se sua Pontuação Ambiente (tempo silencioso ÷ tempo total) for pelo menos 70%, sua sessão qualifica para crédito de missão. Mesmo se estiver abaixo de 70%, você ainda ganha pontos por cada minuto silencioso!';

  @override
  String get faqQ11 => 'Qual é a diferença entre Pontuação Ambiente e pontos?';

  @override
  String get faqA11 => 'Pontuação Ambiente é a qualidade da sua sessão como porcentagem (segundos silenciosos ÷ segundos totais), determinando se você atinge o limiar de 70%. Pontos são os minutos silenciosos reais ganhos (1 ponto = 1 minuto). Pontuação Ambiente = qualidade, Pontos = conquista.';

  @override
  String get faqQ12 => 'Como funcionam as sequências no Focus Field?';

  @override
  String get faqA12 => 'Sequências rastreiam dias consecutivos de atingir seu objetivo diário. Focus Field usa uma Regra Compassiva de 2 Dias: Sua sequência só quebra se você perder dois dias consecutivos. Isso significa que você pode perder um dia e sua sequência continua se você completar seu objetivo no dia seguinte.';

  @override
  String get faqQ13 => 'O que são tokens de congelamento e como usá-los?';

  @override
  String get faqA13 => 'Tokens de congelamento protegem sua sequência quando você não pode completar seu objetivo. Você recebe 1 token de congelamento grátis por mês. Quando usado, seu progresso geral mostra 100% (objetivo protegido), sua sequência está segura e o rastreamento de atividades individuais continua normalmente. Use sabiamente para dias ocupados!';

  @override
  String get faqQ14 => 'Posso personalizar meu objetivo diário de concentração?';

  @override
  String get faqA14 => 'Sim! Toque em Editar no cartão de Sessões na aba Hoje. Você pode definir seu objetivo diário global (10-60 minutos gratuito, até 1080 minutos premium), ativar objetivos por atividade para alvos separados e mostrar/ocultar atividades específicas.';

  @override
  String get faqQ15 => 'O que é o limiar de ruído e como ajustá-lo?';

  @override
  String get faqA15 => 'O limiar é o nível máximo de ruído (em decibéis) que conta como \"silencioso\". O padrão é 40 dB (silêncio de biblioteca). Você pode ajustá-lo na aba Sessões: 30 dB (muito silencioso), 40 dB (silêncio de biblioteca - recomendado), 50 dB (escritório moderado), 60-80 dB (ambientes mais barulhentos).';

  @override
  String get faqQ16 => 'O que é Limiar Adaptativo e devo usá-lo?';

  @override
  String get faqA16 => 'Após 3 sessões bem-sucedidas consecutivas no seu limiar atual, Focus Field sugere aumentá-lo em 2 dB para desafiá-lo. Isso ajuda você a melhorar gradualmente. Você pode aceitar ou recusar a sugestão - ela só aparece uma vez a cada 7 dias.';

  @override
  String get faqQ17 => 'O que é o Modo de Concentração?';

  @override
  String get faqA17 => 'Modo de Concentração é uma sobreposição de tela cheia sem distrações durante sua sessão. Mostra seu cronômetro de contagem regressiva, porcentagem de calma ao vivo e controles mínimos (Pausar/Parar via pressão longa). Remove todos os outros elementos de interface para que você possa se concentrar completamente. Ative em Configurações > Básico > Modo de Concentração.';

  @override
  String get faqQ18 => 'Por que o Focus Field precisa de permissão de microfone?';

  @override
  String get faqA18 => 'Focus Field usa o microfone do seu dispositivo para medir níveis de ruído ambiente (decibéis) durante as sessões. Isso é essencial para calcular sua Pontuação Ambiente. Lembre-se: nenhum áudio é gravado - apenas níveis de ruído são medidos em tempo real.';

  @override
  String get faqQ19 => 'Posso ver meus padrões de concentração ao longo do tempo?';

  @override
  String get faqA19 => 'Sim! A aba Hoje mostra seu progresso diário, tendências semanais, mapa de calor de atividade de 12 semanas (como contribuições do GitHub) e linha do tempo de sessões. Usuários Premium obtêm análises avançadas com métricas de desempenho, médias móveis e insights impulsionados por IA.';

  @override
  String get faqQ20 => 'Como funcionam as notificações no Focus Field?';

  @override
  String get faqA20 => 'Focus Field tem lembretes inteligentes: Lembretes Diários (aprende sua hora de concentração preferida ou usa uma hora fixa), notificações de Sessão Concluída com resultados, notificações de Conquista para marcos e Resumo Semanal (Premium). Ative/personalize em Configurações > Avançado > Notificações.';

  @override
  String get microphoneSettingsTitle => 'Configurações Necessárias';

  @override
  String get microphoneSettingsMessage => 'Para ativar a detecção de silêncio, conceda manualmente a permissão do microfone:\n\n• iOS: Ajustes > Privacidade e Segurança > Microfone > Focus Field\n• Android: Configurações > Aplicativos > Focus Field > Permissões > Microfone';

  @override
  String get buttonGrantPermission => 'Conceder Permissão';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => 'Abrir Configurações';

  @override
  String get onboardingBack => 'Voltar';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get onboardingWelcomeSnackbar => 'Bem-vindo! Pronto para iniciar sua primeira sessão? 🚀';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao\nFocus Field! 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'A sua jornada para um melhor foco começa aqui!\nVamos construir hábitos que permanecem 💪';

  @override
  String get onboardingFeatureTrackTitle => 'Acompanhe o Seu Foco';

  @override
  String get onboardingFeatureTrackDesc => 'Veja o seu progresso em tempo real enquanto constrói o seu superpoder de foco! 📊';

  @override
  String get onboardingFeatureRewardsTitle => 'Ganhe Recompensas';

  @override
  String get onboardingFeatureRewardsDesc => 'Cada minuto silencioso conta! Colete pontos e celebre suas vitórias 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'Construa Sequências';

  @override
  String get onboardingFeatureStreaksDesc => 'Mantenha o impulso! Nosso sistema compassivo mantém você motivado 🔥';

  @override
  String get onboardingEnvironmentTitle => 'Onde está a sua Zona de Foco? 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'Escolha seu ambiente típico para que possamos otimizar seu espaço!';

  @override
  String get onboardingEnvQuietHomeTitle => 'Casa Silenciosa';

  @override
  String get onboardingEnvQuietHomeDesc => 'Quarto, escritório em casa silencioso';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - Muito silencioso';

  @override
  String get onboardingEnvOfficeTitle => 'Escritório Típico';

  @override
  String get onboardingEnvOfficeDesc => 'Escritório padrão, biblioteca';

  @override
  String get onboardingEnvOfficeDb => '40 dB - Silêncio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusyTitle => 'Espaço Ocupado';

  @override
  String get onboardingEnvBusyDesc => 'Café, espaço de trabalho partilhado';

  @override
  String get onboardingEnvBusyDb => '50 dB - Ruído moderado';

  @override
  String get onboardingEnvNoisyTitle => 'Ambiente Barulhento';

  @override
  String get onboardingEnvNoisyDesc => 'Escritório aberto, espaço público';

  @override
  String get onboardingEnvNoisyDb => '60 dB - Ruído mais alto';

  @override
  String get onboardingEnvAdjustNote => 'Você pode ajustar isso a qualquer momento nas Configurações';

  @override
  String get onboardingGoalTitle => 'Defina Sua Meta Diária! 🎯';

  @override
  String get onboardingGoalSubtitle => 'Quanto tempo de concentração parece certo para você?\n(Você pode ajustar isso a qualquer momento!)';

  @override
  String get onboardingGoalStartingTitle => 'Começando';

  @override
  String get onboardingGoalStartingDuration => '10-15 minutos';

  @override
  String get onboardingGoalHabitTitle => 'Construindo Hábito';

  @override
  String get onboardingGoalHabitDuration => '20-30 minutos';

  @override
  String get onboardingGoalPracticeTitle => 'Prática Regular';

  @override
  String get onboardingGoalPracticeDuration => '40-60 minutos';

  @override
  String get onboardingGoalDeepWorkTitle => 'Trabalho Profundo';

  @override
  String get onboardingGoalDeepWorkDuration => '60+ minutos';

  @override
  String get onboardingGoalAdvice1 => 'Começo perfeito! 🌟 Pequenos passos levam a grandes vitórias. Você consegue!';

  @override
  String get onboardingGoalAdvice2 => 'Excelente escolha! 🎯 Este ponto ideal constrói hábitos duradouros!';

  @override
  String get onboardingGoalAdvice3 => 'Ambicioso! 💪 Você está pronto para subir de nível seu jogo de concentração!';

  @override
  String get onboardingGoalAdvice4 => 'Uau! 🏆 Modo de trabalho profundo ativado! Lembre-se de fazer pausas!';

  @override
  String get onboardingActivitiesTitle => 'Escolha Suas Atividades! ✨';

  @override
  String get onboardingActivitiesSubtitle => 'Escolha todas que ressoam com você!\n(Você sempre pode adicionar mais depois)';

  @override
  String get onboardingActivityStudyTitle => 'Estudo';

  @override
  String get onboardingActivityStudyDesc => 'Aprendizado, trabalhos de curso, pesquisa';

  @override
  String get onboardingActivityReadingTitle => 'Leitura';

  @override
  String get onboardingActivityReadingDesc => 'Leitura profunda, artigos, livros';

  @override
  String get onboardingActivityMeditationTitle => 'Meditação';

  @override
  String get onboardingActivityMeditationDesc => 'Atenção plena, exercícios de respiração';

  @override
  String get onboardingActivityOtherTitle => 'Outro';

  @override
  String get onboardingActivityOtherDesc => 'Qualquer atividade que exija concentração';

  @override
  String get onboardingActivitiesTip => 'Dica profissional: Focus Field brilha quando silêncio = concentração! 🤫✨';

  @override
  String get onboardingPermissionTitle => 'Sua Privacidade Importa! 🔒';

  @override
  String get onboardingPermissionSubtitle => 'Precisamos de acesso ao microfone para medir o ruído ambiente e ajudá-lo a se concentrar melhor';

  @override
  String get onboardingPrivacyNoRecordingTitle => 'Sem Gravação';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'Medimos apenas níveis de ruído, nunca gravamos áudio';

  @override
  String get onboardingPrivacyLocalTitle => 'Apenas Local';

  @override
  String get onboardingPrivacyLocalDesc => 'Todos os dados permanecem no seu dispositivo';

  @override
  String get onboardingPrivacyFirstTitle => 'Privacidade Primeiro';

  @override
  String get onboardingPrivacyFirstDesc => 'Suas conversas são completamente privadas';

  @override
  String get onboardingPermissionNote => 'Você pode conceder permissão na próxima tela ao iniciar sua primeira sessão';

  @override
  String get onboardingTipsTitle => 'Dicas Profissionais para o Sucesso! 💡';

  @override
  String get onboardingTipsSubtitle => 'Estas ajudarão você a aproveitar ao máximo o Focus Field!';

  @override
  String get onboardingTip1Title => 'Comece Pequeno, Ganhe Grande! 🌱';

  @override
  String get onboardingTip1Desc => 'Comece com sessões de 5-10 minutos. Consistência supera perfeição!';

  @override
  String get onboardingTip2Title => 'Ative o Modo de Concentração! 🎯';

  @override
  String get onboardingTip2Desc => 'Toque no Modo de Concentração para uma experiência imersiva sem distrações.';

  @override
  String get onboardingTip3Title => 'Token de Congelamento = Rede de Segurança! ❄️';

  @override
  String get onboardingTip3Desc => 'Use seu token mensal em dias ocupados para proteger sua sequência.';

  @override
  String get onboardingTip4Title => 'A Regra dos 70% é Ótima! 📈';

  @override
  String get onboardingTip4Desc => 'Mire em 70% de tempo silencioso - silêncio perfeito não é necessário!';

  @override
  String get onboardingReadyTitle => 'Você Está Pronto para Decolar! 🚀';

  @override
  String get onboardingReadyDesc => 'Vamos começar sua primeira sessão e construir hábitos incríveis!';

  @override
  String get questMotivation1 => 'O sucesso nunca termina e o fracasso nunca é final';

  @override
  String get questMotivation2 => 'Progresso sobre perfeição - cada minuto conta';

  @override
  String get questMotivation3 => 'Pequenos passos diários levam a grandes mudanças';

  @override
  String get questMotivation4 => 'Você está construindo melhores hábitos, uma sessão de cada vez';

  @override
  String get questMotivation5 => 'Consistência supera intensidade';

  @override
  String get questMotivation6 => 'Cada sessão é uma vitória, não importa quão curta';

  @override
  String get questMotivation7 => 'Foco é um músculo - você está ficando mais forte';

  @override
  String get questMotivation8 => 'A jornada de mil milhas começa com um único passo';

  @override
  String get questGo => 'Ir';

  @override
  String get questTapStart => 'Toque em Iniciar →';

  @override
  String get todayDashboardTitle => 'Seu Painel de Foco';

  @override
  String get todayFocusMinutes => 'Minutos de foco hoje';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return 'Meta: $goalMinutes min • Calma ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'Escolha seu modo';

  @override
  String get todayDefaultActivities => 'Estudo • Leitura • Meditação';

  @override
  String get todayTooltipTips => 'Dicas';

  @override
  String get todayTooltipTheme => 'Tema';

  @override
  String get todayTooltipSettings => 'Configurações';

  @override
  String todayThemeChanged(String themeName) {
    return 'Tema alterado para $themeName';
  }

  @override
  String get todayTabToday => 'Hoje';

  @override
  String get todayTabSessions => 'Sessões';

  @override
  String get todayHelperText => 'Defina sua duração e acompanhe seu tempo. O histórico de sessões e análises aparecerão no Resumo.';

  @override
  String get statPoints => 'Pontos';

  @override
  String get statStreak => 'Sequência';

  @override
  String get statSessions => 'Sessões';

  @override
  String get ringProgressTitle => 'Progresso do Anel';

  @override
  String get ringOverall => 'Geral';

  @override
  String get ringOverallFrozen => 'Geral ❄️';

  @override
  String get sessionCalm => 'Calma';

  @override
  String get sessionStart => 'Iniciar';

  @override
  String get sessionStop => 'Parar';

  @override
  String get buttonEdit => 'Editar';

  @override
  String get durationUpTo1Hour => 'Sessões de até 1 hora';

  @override
  String get durationUpTo1_5Hours => 'Sessões de até 1,5 horas';

  @override
  String get durationUpTo2Hours => 'Sessões de até 2 horas';

  @override
  String get durationExtended => 'Durações de sessão estendidas';

  @override
  String get durationExtendedAccess => 'Acesso a sessões estendidas';

  @override
  String get noiseRoomLoudness => 'Volume da Sala';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'Limiar: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'Limiar definido para $db dB';
  }

  @override
  String get noiseHighDetected => 'Ruído alto detectado, por favor vá para uma sala mais silenciosa para melhor foco';

  @override
  String get noiseThresholdExceededHint => 'Encontre um local mais silencioso ou aumente o limite →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'Encontrar local mais silencioso ou aumentar para ${db}dB?';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return 'Alto ruído detectado. Aumentar para ${db}dB?';
  }

  @override
  String get noiseAtMaxThreshold => 'Já está no limite máximo. Por favor, encontre um local mais silencioso.';

  @override
  String get noiseThresholdYes => 'Sim';

  @override
  String get noiseThresholdNo => 'Não';

  @override
  String get trendsInsights => 'Insights';

  @override
  String get trendsLast7Days => 'Últimos 7 Dias';

  @override
  String get trendsShareWeeklySummary => 'Compartilhar resumo semanal';

  @override
  String get trendsLoading => 'Carregando...';

  @override
  String get trendsLoadingMetrics => 'Carregando métricas...';

  @override
  String get trendsNoData => 'Sem dados';

  @override
  String get trendsWeeklyTotal => 'Total Semanal';

  @override
  String get trendsBestDay => 'Melhor Dia';

  @override
  String get trendsActivityHeatmap => 'Mapa de Calor de Atividade';

  @override
  String get trendsRecentActivity => 'Atividade recente';

  @override
  String get trendsHeatmapError => 'Não foi possível carregar o mapa de calor';

  @override
  String get dayMon => 'Seg';

  @override
  String get dayTue => 'Ter';

  @override
  String get dayWed => 'Qua';

  @override
  String get dayThu => 'Qui';

  @override
  String get dayFri => 'Sex';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get focusModeComplete => 'Sessão Completa!';

  @override
  String get focusModeGreatSession => 'Ótima sessão de foco';

  @override
  String get focusModeResume => 'Retomar';

  @override
  String get focusModePause => 'Pausar';

  @override
  String get focusModeLongPressHint => 'Pressione longamente para pausar ou parar';

  @override
  String get activityEditTitle => 'Editar Atividades';

  @override
  String get activityRecommendation => 'Recomendado: 10+ min por atividade para construção consistente de hábitos';

  @override
  String get activityDailyGoals => 'Metas Diárias';

  @override
  String activityTotalHours(String hours) {
    return 'Total: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'Por Atividade';

  @override
  String get activityExceedsLimit => 'O total excede o limite diário de 18 horas. Por favor, reduza as metas.';

  @override
  String get activityGoalLabel => 'Meta';

  @override
  String get activityGoalDescription => 'Defina sua meta de foco diária (1 min - 18h)';

  @override
  String get shareYourProgress => 'Compartilhe Seu Progresso';

  @override
  String get shareTimeRange => 'Intervalo de Tempo';

  @override
  String get shareCardSize => 'Tamanho do Cartão';

  @override
  String get analyticsPerformanceMetrics => 'Métricas de Desempenho';

  @override
  String get analyticsPreferredDuration => 'Duração Preferida';

  @override
  String get analyticsUnavailable => 'Análise indisponível';

  @override
  String get analyticsRestoreAttempt => 'Tentaremos restaurar esta seção na próxima inicialização do aplicativo.';

  @override
  String get audioUnavailable => 'Áudio temporariamente indisponível';

  @override
  String get audioRecovering => 'O processamento de áudio encontrou um problema. Recuperando automaticamente...';

  @override
  String get shareQuietMinutes => 'MINUTOS TRANQUILOS';

  @override
  String get shareTopActivity => 'Atividade Principal';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'Visualizar';

  @override
  String get sharePinchToZoom => 'Belisque para ampliar';

  @override
  String get shareGenerating => 'Gerando...';

  @override
  String get shareButton => 'Compartilhar';

  @override
  String get shareTodayLabel => 'Hoje';

  @override
  String get shareWeeklyLabel => 'Semanal';

  @override
  String get shareTodayTitle => 'Seu Foco de Hoje';

  @override
  String get shareWeeklyTitle => 'Seu Foco Semanal';

  @override
  String get shareSubject => 'Meu Progresso no Focus Field';

  @override
  String get shareFormatSquare => 'Proporção 1:1 • Compatibilidade universal';

  @override
  String get shareFormatPost => 'Proporção 4:5 • Posts Instagram/Twitter';

  @override
  String get shareFormatStory => 'Proporção 9:16 • Stories do Instagram';

  @override
  String get recapWeeklyTitle => 'Resumo Semanal';

  @override
  String get recapMinutes => 'Minutos';

  @override
  String recapStreak(int start, int end) {
    return 'Sequência: $start → $end dias';
  }

  @override
  String get recapTopActivity => 'Atividade Principal: ';

  @override
  String get practiceOverviewTitle => 'Visão Geral da Prática';

  @override
  String get practiceLast7Days => 'Últimos 7 Dias';

  @override
  String get audioMultipleErrors => 'Múltiplos erros de áudio detectados. Componente recuperando...';

  @override
  String activityCurrentGoal(String goal) {
    return 'Meta atual: $goal';
  }

  @override
  String get activitySaveChanges => 'Salvar Alterações';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsTooltip => 'Ver insights detalhados';

  @override
  String get statDays => 'DIAS';

  @override
  String sessionsTotalToday(int done, int goal) {
    return 'Total Hoje $done/$goal min, escolha qualquer atividade';
  }

  @override
  String get premiumFeature => 'Recurso Premium';

  @override
  String get premiumFeatureAccess => 'Acesso a recurso premium';

  @override
  String get activityUnknown => 'Desconhecido';

  @override
  String get insightsFirstSessionTitle => 'Complete sua primeira sessão';

  @override
  String get insightsFirstSessionSubtitle => 'Comece a rastrear seu tempo de foco, padrões de sessão e tendências de pontuação ambiente';

  @override
  String sessionAmbientLabel(int percent) {
    return 'Ambiente: $percent%';
  }

  @override
  String get sessionSuccess => 'Sucesso';

  @override
  String get sessionFailed => 'Falhou';

  @override
  String get focusModeButton => 'Modo de Foco';

  @override
  String get settingsDailyGoalsTitle => 'Objetivos Diários';

  @override
  String get settingsFocusModeDescription => 'Minimize as distrações durante as sessões com uma sobreposição focada';

  @override
  String get settingsDeepFocusTitle => 'Foco Profundo';

  @override
  String get settingsDeepFocusDescription => 'Terminar sessão se a aplicação for deixada';

  @override
  String get deepFocusDialogTitle => 'Foco Profundo';

  @override
  String get deepFocusEnableLabel => 'Ativar Foco Profundo';

  @override
  String get deepFocusGracePeriodLabel => 'Período de graça (segundos)';

  @override
  String get deepFocusExplanation => 'Quando ativado, sair da aplicação terminará a sessão após o período de graça.';

  @override
  String get notificationPermissionTitle => 'Ativar Notificações';

  @override
  String get notificationPermissionExplanation => 'Focus Field precisa de permissão de notificação para lhe enviar:';

  @override
  String get notificationBenefitReminders => 'Lembretes diários de foco';

  @override
  String get notificationBenefitCompletion => 'Alertas de sessão concluída';

  @override
  String get notificationBenefitAchievements => 'Celebrações de conquistas';

  @override
  String get notificationHowToEnableIos => 'Como ativar no iOS:';

  @override
  String get notificationHowToEnableAndroid => 'Como ativar no Android:';

  @override
  String get notificationStepsIos => '1. Toque em \"Abrir Definições\" abaixo\n2. Toque em \"Notificações\"\n3. Ative \"Permitir Notificações\"';

  @override
  String get notificationStepsAndroid => '1. Toque em \"Abrir Definições\" abaixo\n2. Toque em \"Notificações\"\n3. Ative \"Todas as notificações do Focus Field\"';

  @override
  String get aboutShowTips => 'Mostrar Dicas';

  @override
  String get aboutShowTipsDescription => 'Mostra dicas úteis no arranque da aplicação e através do ícone de lâmpada. As dicas aparecem a cada 2-3 dias.';

  @override
  String get aboutReplayOnboarding => 'Repetir Introdução';

  @override
  String get aboutReplayOnboardingDescription => 'Reveja o tour da aplicação e configure as suas preferências novamente';

  @override
  String get buttonFaq => 'FAQ';

  @override
  String get onboardingWelcomeMessage => 'Bem-vindo! Pronto para começar a sua primeira sessão? 🚀';

  @override
  String get onboardingFeatureEarnTitle => 'Ganhar Recompensas';

  @override
  String get onboardingFeatureEarnDesc => 'Cada minuto silencioso conta! Colete pontos e celebre as suas vitórias 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'Construir Sequências';

  @override
  String get onboardingFeatureBuildDesc => 'Mantenha o impulso! O nosso sistema compassivo mantém-no motivado 🔥';

  @override
  String get onboardingEnvironmentDescription => 'Escolha o seu ambiente típico para que possamos otimizar o seu espaço!';

  @override
  String get onboardingEnvQuietHome => 'Casa Silenciosa';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - Muito silencioso';

  @override
  String get onboardingEnvOffice => 'Escritório Típico';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - Silêncio de biblioteca (Recomendado)';

  @override
  String get onboardingEnvBusy => 'Espaço Movimentado';

  @override
  String get onboardingEnvBusyLevel => '50 dB - Ruído moderado';

  @override
  String get onboardingEnvNoisy => 'Ambiente Ruidoso';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - Ruído mais alto';

  @override
  String get onboardingAdjustAnytime => 'Pode ajustar isto a qualquer momento nas Definições';

  @override
  String starterSessionTip(int starterMinutes, int goalMinutes) {
    return '👋 Começando com uma sessão de $starterMinutes minutos para ajudá-lo a se adaptar. Sua meta completa de $goalMinutes minutos está pronta quando você estiver!';
  }

  @override
  String get buttonGotIt => 'Entendi';

  @override
  String get buttonGetStarted => 'Começar';

  @override
  String get buttonNext => 'Seguinte';

  @override
  String get errorActivityRequired => '⚠️ Pelo menos uma atividade deve estar ativada';

  @override
  String get errorGoalExceeds => 'Os objetivos totais excedem o limite diário de 18 horas. Por favor, reduza os objetivos.';

  @override
  String get messageSaved => 'Definições guardadas';

  @override
  String get errorPermissionRequired => 'Permissão necessária';

  @override
  String get notificationEnableReason => 'Ative as notificações para receber lembretes e celebrar conquistas.';

  @override
  String get buttonEnableNotifications => 'Ativar Notificações';

  @override
  String get buttonRequesting => 'A solicitar...';

  @override
  String get notificationDailyTime => 'Hora Diária';

  @override
  String notificationDailyReminderSet(String time) {
    return 'Lembrete diário às $time';
  }

  @override
  String get notificationLearning => 'a aprender';

  @override
  String notificationSmart(String time) {
    return 'Inteligente ($time)';
  }

  @override
  String get buttonUseSmart => 'Usar Inteligente';

  @override
  String get notificationSmartExplanation => 'Escolha uma hora fixa ou deixe o Focus Field aprender o seu padrão.';

  @override
  String get notificationSessionComplete => 'Sessão Concluída';

  @override
  String get notificationSessionCompleteDesc => 'Celebrar sessões concluídas';

  @override
  String get notificationAchievement => 'Conquista Desbloqueada';

  @override
  String get notificationAchievementDesc => 'Notificações de marcos';

  @override
  String get notificationWeekly => 'Resumo Semanal de Progresso';

  @override
  String get notificationWeeklyDesc => 'Insights semanais (dia da semana e hora)';

  @override
  String get notificationWeeklyTime => 'Hora Semanal';

  @override
  String get notificationMilestone => 'Notificações de marcos';

  @override
  String get notificationWeeklyInsights => 'Insights semanais (dia da semana e horário)';

  @override
  String get notificationDailyReminder => 'Lembrete diário';

  @override
  String get notificationComplete => 'Sessão concluída';

  @override
  String get settingsSnackbar => 'Por favor, ative as notificações nas configurações do dispositivo';

  @override
  String get shareCardTitle => 'Compartilhar cartão';

  @override
  String get shareYourWeek => 'Compartilhe sua semana';

  @override
  String get shareStyleGradient => 'Estilo gradiente';

  @override
  String get shareStyleGradientDesc => 'Gradiente ousado com números grandes';

  @override
  String get shareWeeklySummary => 'Resumo semanal';

  @override
  String get shareStyleAchievement => 'Estilo de conquista';

  @override
  String get shareStyleAchievementDesc => 'Foco no total de minutos silenciosos';

  @override
  String get shareQuietMinutesWeek => 'Minutos silenciosos esta semana';

  @override
  String get shareAchievementMessage => 'Construindo foco mais profundo,\\numa sessão de cada vez';

  @override
  String get shareAchievementCard => 'Cartão de conquista';

  @override
  String get shareTextOnly => 'Apenas texto';

  @override
  String get shareTextOnlyDesc => 'Compartilhar como texto simples (sem imagem)';

  @override
  String get shareYourStreak => 'Compartilhe sua sequência';

  @override
  String get shareAsCard => 'Compartilhar como cartão';

  @override
  String get shareAsCardDesc => 'Cartão visual bonito';

  @override
  String get shareStreakCard => 'Cartão de sequência';

  @override
  String get shareAsText => 'Compartilhar como texto';

  @override
  String get shareAsTextDesc => 'Mensagem de texto simples';

  @override
  String get shareErrorFailed => 'Falha ao compartilhar. Por favor, tente novamente.';

  @override
  String get buttonShare => 'Compartilhar';

  @override
  String get initializingApp => 'Inicializando aplicativo...';

  @override
  String initializationFailed(String error) {
    return 'Falha na inicialização: $error';
  }

  @override
  String get loadingSettings => 'Carregando configurações...';

  @override
  String settingsLoadingFailed(String error) {
    return 'Falha ao carregar configurações: $error';
  }

  @override
  String get loadingUserData => 'Carregando dados do usuário...';

  @override
  String dataLoadingFailed(String error) {
    return 'Falha ao carregar dados: $error';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get taglineSilence => '🤫 Domine a arte do silêncio';

  @override
  String get errorOops => 'Ops! Algo deu errado';

  @override
  String get buttonRetry => 'Tentar novamente';

  @override
  String get resetAppData => 'Redefinir dados do aplicativo';

  @override
  String get resetAppDataMessage => 'Isso redefinirá todos os dados e configurações do aplicativo para seus padrões. Esta ação não pode ser desfeita.\\n\\nDeseja continuar?';

  @override
  String get buttonReset => 'Redefinir';

  @override
  String get messageDataReset => 'Os dados do aplicativo foram redefinidos';

  @override
  String errorResetFailed(String error) {
    return 'Falha ao redefinir dados: $error';
  }

  @override
  String get analyticsTitle => 'Análise';

  @override
  String get analyticsOverview => 'Visão geral';

  @override
  String get analyticsPoints => 'Pontos';

  @override
  String get analyticsStreak => 'Sequência';

  @override
  String get analyticsSessions => 'Sessões';

  @override
  String get analyticsLast7Days => 'Últimos 7 dias';

  @override
  String get analyticsPerformanceHighlights => 'Destaques de desempenho';

  @override
  String get analyticsSuccessRate => 'Taxa de sucesso';

  @override
  String get analyticsAvgSession => 'Sessão média';

  @override
  String get analyticsBestStreak => 'Melhor sequência';

  @override
  String get analyticsActivityProgress => 'Progresso da atividade';

  @override
  String get analyticsComingSoon => 'Rastreamento detalhado de atividades em breve.';

  @override
  String get analyticsAdvancedMetrics => 'Métricas avançadas';

  @override
  String get analyticsPremiumContent => 'Conteúdo de análise avançada premium aqui...';

  @override
  String get analytics30DayTrends => 'Tendências de 30 dias';

  @override
  String get analyticsTrendsChart => 'Gráfico de tendências premium aqui...';

  @override
  String get analyticsAIInsights => 'Insights de IA';

  @override
  String get analyticsAIComingSoon => 'Insights alimentados por IA em breve...';

  @override
  String get analyticsUnlock => 'Desbloquear análise avançada';

  @override
  String get errorTitle => 'Erro';

  @override
  String get errorQuestUnavailable => 'Estado da missão não disponível';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ Falha ao usar o token de congelamento';

  @override
  String get buttonUseFreeze => 'Usar congelamento';

  @override
  String get onboardingDailyGoalTitle => 'Defina sua meta diária! 🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'Quanto tempo de foco parece certo para você?\\n(Você pode ajustar a qualquer momento!)';

  @override
  String get onboardingGoalGettingStarted => 'Começando';

  @override
  String get onboardingGoalBuildingHabit => 'Construindo hábito';

  @override
  String get onboardingGoalRegularPractice => 'Prática regular';

  @override
  String get onboardingGoalDeepWork => 'Trabalho profundo';

  @override
  String get onboardingProTip => 'Dica profissional: Focus Field brilha quando silêncio = foco! 🤫✨';

  @override
  String get onboardingPrivacyTitle => 'Sua privacidade importa! 🔒';

  @override
  String get onboardingPrivacySubtitle => 'Precisamos de acesso ao microfone para medir o ruído ambiente e ajudá-lo a se concentrar melhor';

  @override
  String get onboardingPrivacyNoRecording => 'Sem gravação';

  @override
  String get onboardingPrivacyLocalOnly => 'Apenas local';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'Todos os dados permanecem no seu dispositivo';

  @override
  String get onboardingPrivacyFirst => 'Privacidade em primeiro lugar';

  @override
  String get onboardingPrivacyNote => 'Você pode conceder permissão na próxima tela ao iniciar sua primeira sessão';

  @override
  String get insightsFocusTime => 'Tempo de foco';

  @override
  String get insightsSessions => 'Sessões';

  @override
  String get insightsAverage => 'Média';

  @override
  String get insightsAmbientScore => 'Pontuação ambiente';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeOceanBlue => 'Azul oceano';

  @override
  String get themeForestGreen => 'Verde floresta';

  @override
  String get themePurpleNight => 'Noite roxa';

  @override
  String get themeSolarSunrise => 'Nascer do sol solar';

  @override
  String get themeCyberNeon => 'Neon cibernético';

  @override
  String get settingsAppTheme => 'Tema do aplicativo';

  @override
  String get freezeTokenNoTokensTitle => 'Sem Tokens de Congelamento';

  @override
  String get freezeTokenNoTokensMessage => 'Você não tem tokens de congelamento disponíveis. Você ganha 1 token por semana (máximo 4).';

  @override
  String get freezeTokenGoalCompleteTitle => 'Meta Já Concluída';

  @override
  String get freezeTokenGoalCompleteMessage => 'Sua meta diária já está completa! Tokens de congelamento só podem ser usados quando você ainda não atingiu sua meta.';

  @override
  String get freezeTokenUseTitle => 'Usar Token de Congelamento';

  @override
  String get freezeTokenUseMessage => 'Tokens de congelamento protegem sua sequência quando você perde um dia. Usar um congelamento contará como completar sua meta diária.';

  @override
  String freezeTokenUsePrompt(Object count) {
    return 'Você tem $count token(s). Usar um agora?';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ Token de congelamento usado! Meta marcada como concluída.';

  @override
  String get trendsErrorLoading => 'Erro ao carregar dados';

  @override
  String get trendsPoints => 'Pontos';

  @override
  String get trendsStreak => 'Sequência';

  @override
  String get trendsSessions => 'Sessões';

  @override
  String get trendsTopActivity => 'Atividade Principal';

  @override
  String get sectionToday => 'Hoje';

  @override
  String get sectionSessions => 'Sessões';

  @override
  String get sectionInsights => 'Insights';

  @override
  String get onboardingGoalAdviceGettingStarted => 'Começo perfeito! 🌟 Pequenos passos levam a grandes vitórias. Você consegue!';

  @override
  String get onboardingGoalAdviceBuildingHabit => 'Excelente escolha! 🎯 Este ponto ideal constrói hábitos duradouros!';

  @override
  String get onboardingGoalAdviceRegularPractice => 'Ambicioso! 💪 Você está pronto para melhorar seu foco!';

  @override
  String get onboardingGoalAdviceDeepWork => 'Uau! 🏆 Modo de trabalho profundo ativado! Lembre-se de fazer pausas!';

  @override
  String get onboardingDuration10to15 => '10-15 minutos';

  @override
  String get onboardingDuration20to30 => '20-30 minutos';

  @override
  String get onboardingDuration40to60 => '40-60 minutos';

  @override
  String get onboardingDuration60plus => '60+ minutos';

  @override
  String get activityStudy => 'Estudo';

  @override
  String get activityReading => 'Leitura';

  @override
  String get activityMeditation => 'Meditação';

  @override
  String get activityOther => 'Outro';

  @override
  String get onboardingTip1Description => 'Comece com sessões de 5-10 minutos. Consistência supera perfeição!';

  @override
  String get onboardingTip2Description => 'Toque no Modo Foco para uma experiência imersiva sem distrações.';

  @override
  String get onboardingTip3Description => 'Use seu token mensal em dias ocupados para proteger sua sequência.';

  @override
  String get onboardingTip4Description => 'Aponte para 70% de tempo silencioso - silêncio perfeito não é necessário!';

  @override
  String get onboardingLaunchTitle => 'Você Está Pronto para Começar! 🚀';

  @override
  String get onboardingLaunchDescription => 'Vamos começar sua primeira sessão e construir hábitos incríveis!';

  @override
  String get insightsBestTimeByActivity => 'Melhor horário por atividade';

  @override
  String get insightHighSuccessRateTitle => 'Alta taxa de sucesso';

  @override
  String get insightEnvironmentStabilityTitle => 'Estabilidade Ambiental';

  @override
  String get insightLowNoiseSuccessTitle => 'Sucesso de baixo ruído';

  @override
  String get insightConsistentPracticeTitle => 'Prática Consistente';

  @override
  String get insightStreakProtectionTitle => 'Proteção contra riscos disponível';

  @override
  String get insightRoomTooNoisyTitle => 'Quarto muito barulhento';

  @override
  String get insightIrregularScheduleTitle => 'Horário Irregular';

  @override
  String get insightLowAmbientScoreTitle => 'Pontuação ambiental baixa';

  @override
  String get insightNoRecentSessionsTitle => 'Nenhuma sessão recente';

  @override
  String get insightHighSuccessRateDesc => 'Você está mantendo fortes sessões silenciosas.';

  @override
  String get insightEnvironmentStabilityDesc => 'O ruído ambiente está dentro de uma faixa moderada e gerenciável.';

  @override
  String get insightLowNoiseSuccessDesc => 'Seu ambiente é excepcionalmente silencioso durante as sessões.';

  @override
  String get insightConsistentPracticeDesc => 'Você está construindo um hábito de prática diária confiável.';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'Você tem $count token(s) de congelamento para proteger sua sequência.';
  }

  @override
  String get insightRoomTooNoisyDesc => 'Tente encontrar um espaço mais silencioso ou ajustar seu limite.';

  @override
  String get insightIrregularScheduleDesc => 'Tempos de sessão mais consistentes podem melhorar sua sequência.';

  @override
  String get insightLowAmbientScoreDesc => 'As sessões recentes tiveram menor tempo de silêncio. Experimente um ambiente mais silencioso.';

  @override
  String get insightNoRecentSessionsDesc => 'Comece uma sessão hoje para construir seu hábito de foco!';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return 'Ótimo trabalho! $minutes minutos de foco na sua sessão! ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return 'Bom esforço! $minutes minutos concluídos.';
  }

  @override
  String get sessionCompleteFailed => 'A sessão terminou. Tente novamente quando estiver pronto.';

  @override
  String get notificationSessionStarted => 'Sessão iniciada - mantenha o foco!';

  @override
  String get notificationSessionPaused => 'Sessão pausada';

  @override
  String get notificationSessionResumed => 'Sessão retomada';
}
