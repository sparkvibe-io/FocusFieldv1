// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Preparando motor de foco…';

  @override
  String get paywallTitle => 'Treine foco mais profundo com Premium';

  @override
  String get featureExtendSessions => 'Estenda sessões de 5 min para 120 min';

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
  String get microphonePermissionMessage => 'Silence Score precisa acesso ao microfone para medir o ruído. Nenhum áudio é armazenado.';

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
  String get faqHowWorksQ => 'Como o Silence Score funciona?';

  @override
  String get faqHowWorksA => 'Mede o ruído ambiente – tempo abaixo do limite gera pontos.';

  @override
  String get faqAudioRecordedQ => 'Áudio é gravado?';

  @override
  String get faqAudioRecordedA => 'Não. Apenas níveis de dB; áudio nunca é salvo.';

  @override
  String get faqAdjustSensitivityQ => 'Ajustar sensibilidade?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Configurações > Básico > Limite ($min–$max dB) e calibre primeiro.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Recursos Premium?';

  @override
  String get faqPremiumFeaturesA => 'Sessões estendidas (até 120m), análises, exportação, temas.';

  @override
  String get faqNotificationsQ => 'Notificações?';

  @override
  String get faqNotificationsA => 'Lembretes inteligentes aprendem hábitos e celebram marcos.';

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => 'Preparando o motor de foco…';

  @override
  String get paywallTitle => 'Treine foco mais profundo com o Premium';

  @override
  String get featureExtendSessions => 'Estenda sessões de 5 min para 120 min';

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
  String get microphonePermissionMessage => 'Silence Score precisa de acesso ao microfone para medir o ruído. Nenhum áudio é armazenado.';

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
  String get faqHowWorksQ => 'Como o Silence Score funciona?';

  @override
  String get faqHowWorksA => 'Mede o ruído ambiente – tempo abaixo do limite gera pontos.';

  @override
  String get faqAudioRecordedQ => 'Áudio é gravado?';

  @override
  String get faqAudioRecordedA => 'Não. Apenas níveis de dB; áudio nunca é salvo.';

  @override
  String get faqAdjustSensitivityQ => 'Ajustar sensibilidade?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return 'Configurações > Básico > Limite ($min–$max dB) e calibre primeiro.';
  }

  @override
  String get faqPremiumFeaturesQ => 'Recursos Premium?';

  @override
  String get faqPremiumFeaturesA => 'Sessões estendidas (até 120m), análises, exportação, temas.';

  @override
  String get faqNotificationsQ => 'Notificações?';

  @override
  String get faqNotificationsA => 'Lembretes inteligentes aprendem hábitos e celebram marcos.';

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
}
