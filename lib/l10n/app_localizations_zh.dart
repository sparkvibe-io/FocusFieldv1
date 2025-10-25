// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '聚焦领域';

  @override
  String get splashLoading => '正在准备焦点引擎...';

  @override
  String get paywallTitle => '通过 Premium 训练更深入的专注力';

  @override
  String get featureExtendSessions => '将专注练习从30分钟延长至120分钟';

  @override
  String get featureHistory => '访问过去90天的练习记录';

  @override
  String get featureMetrics => '解锁绩效指标和趋势图表';

  @override
  String get featureExport => '下载您的练习数据（CSV / PDF）';

  @override
  String get featureThemes => '使用完整的自定义主题包';

  @override
  String get featureThreshold => '根据环境基线微调阈值';

  @override
  String get featureSupport => '更快的帮助和早期的功能访问';

  @override
  String get subscribeCta => '继续';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get privacyPolicy => '隐私';

  @override
  String get termsOfService => '条款';

  @override
  String get manageSubscription => '管理';

  @override
  String get legalDisclaimer => '自动续订订阅。可以随时在商店设置中取消。';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '#分钟的和平沉默！ ✨',
      one: '#分钟的和平沉默！ ✨',
    );
    return '干得好！ $_temp0';
  }

  @override
  String get minutes => '分钟';

  @override
  String get minute => '分钟';

  @override
  String get exportCsv => '导出 CSV';

  @override
  String get exportPdf => '导出PDF';

  @override
  String get settings => '设置';

  @override
  String get themes => '主题';

  @override
  String get analytics => '分析';

  @override
  String get history => '历史';

  @override
  String get startSession => '开始练习';

  @override
  String get stopSession => '停止';

  @override
  String get pauseSession => '暂停';

  @override
  String get resumeSession => '恢复';

  @override
  String get sessionSaved => '练习已保存';

  @override
  String get copied => '已复制';

  @override
  String get errorGeneric => '出了点问题';

  @override
  String get permissionMicrophoneDenied => '麦克风权限被拒绝';

  @override
  String get actionRetry => '重试';

  @override
  String get listeningStatus => '听...';

  @override
  String get successPointMessage => '实现了沉默！ +1 点';

  @override
  String get tooNoisyMessage => '太吵了！再试一次';

  @override
  String get totalPoints => '总分';

  @override
  String get currentStreak => '当前连胜';

  @override
  String get bestStreak => '最佳连胜纪录';

  @override
  String get welcomeMessage => '按“开始”开始您的静音之旅！';

  @override
  String get resetAllData => '重置所有数据';

  @override
  String get resetDataConfirmation => '您确定要重置所有进度吗？';

  @override
  String get resetDataSuccess => '数据重置成功';

  @override
  String get decibelThresholdLabel => '分贝阈值';

  @override
  String get decibelThresholdHint => '设置最大允许噪音水平 (dB)';

  @override
  String get microphonePermissionTitle => '麦克风权限';

  @override
  String get microphonePermissionMessage => 'Focus Field 测量环境声级，帮助您保持安静的环境。\n\n该应用程序需要麦克风访问权限来检测静音，但不会录制任何音频。';

  @override
  String get permissionDeniedMessage => '测量静音需要麦克风许可。请在设置中启用它。';

  @override
  String get noiseMeterError => '无法访问麦克风';

  @override
  String get premiumFeaturesTitle => '高级功能';

  @override
  String get premiumDescription => '解锁扩展会话、高级分析和数据导出';

  @override
  String get premiumRequiredMessage => '此功能需要高级订阅';

  @override
  String get subscriptionSuccessMessage => '订阅成功！享受您的高级功能';

  @override
  String get subscriptionErrorMessage => '无法处理订阅。请重试';

  @override
  String get restoreSuccessMessage => '购买成功恢复';

  @override
  String get restoreErrorMessage => '未找到可恢复的购买';

  @override
  String get yearlyPlanTitle => '每年';

  @override
  String get monthlyPlanTitle => '每月';

  @override
  String savePercent(String percent) {
    return '节省 $percent%';
  }

  @override
  String billedAnnually(String price) {
    return '按每年 $price 计费。';
  }

  @override
  String billedMonthly(String price) {
    return '按每月 $price 计费。';
  }

  @override
  String get mockSubscriptionsBanner => '模拟订阅已启用';

  @override
  String get splashTagline => '寻找属于你的安静';

  @override
  String get appIconSemantic => '应用程序图标';

  @override
  String get tabBasic => '基本的';

  @override
  String get tabAdvanced => '先进的';

  @override
  String get tabAbout => '关于';

  @override
  String get resetAllSettings => '重置所有设置';

  @override
  String get resetAllSettingsDescription => '这将重置所有设置和数据。无法撤消。';

  @override
  String get cancel => '取消';

  @override
  String get reset => '重置';

  @override
  String get allSettingsReset => '所有设置和数据均已重置';

  @override
  String get decibelThresholdMaxNoise => '分贝阈值（最大噪音水平）';

  @override
  String get highThresholdWarningText => '高阈值可能会忽略有意义的噪声事件。';

  @override
  String get decibelThresholdTooltip => '典型的安静空间：30–40 dB。校准;仅当正常嗡嗡声算作噪音时才会升高。';

  @override
  String get sessionDuration => '练习时长';

  @override
  String upgradeForMinutes(int minutes) {
    return '升级 $minutes 分钟';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return '免费：最多$minutes分钟';
  }

  @override
  String get durationLabel => '期间';

  @override
  String get minutesShort => '分钟';

  @override
  String get noiseCalibration => '噪声校准';

  @override
  String get calibrateBaseline => '校准基线';

  @override
  String get unlockAdvancedCalibration => '解锁高级噪声校准';

  @override
  String get exportData => '导出数据';

  @override
  String get sessionHistory => '练习历史';

  @override
  String get notifications => '通知';

  @override
  String get remindersCelebrations => '提醒和庆祝活动';

  @override
  String get accessibility => '无障碍';

  @override
  String get accessibilityFeatures => '辅助功能';

  @override
  String get appInformation => '应用信息';

  @override
  String get version => '版本';

  @override
  String get bundleId => '捆绑包 ID';

  @override
  String get environment => '环境';

  @override
  String get helpSupport => '帮助与支持';

  @override
  String get support => '支持';

  @override
  String get rateApp => '评价应用程序';

  @override
  String errorLoadingSettings(String error) {
    return '加载设置时出错：$error';
  }

  @override
  String get exportNoData => '没有可导出的数据';

  @override
  String chooseExportFormat(int sessions) {
    return '为您的 $sessions 会话选择导出格式：';
  }

  @override
  String get csvSpreadsheet => 'CSV 电子表格';

  @override
  String get rawDataForAnalysis => '用于分析的原始数据';

  @override
  String get pdfReport => 'PDF报告';

  @override
  String get formattedReportWithCharts => '带图表的格式化报告';

  @override
  String generatingExport(String format) {
    return '正在生成 $format 导出...';
  }

  @override
  String exportCompleted(String format) {
    return '$format导出完成！';
  }

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String get close => '关闭';

  @override
  String get supportTitle => '支持';

  @override
  String responseTimeLabel(String time) {
    return '响应时间：$time';
  }

  @override
  String get docs => '文档';

  @override
  String get contactSupport => '联系支持人员';

  @override
  String get emailOpenDescription => '打开您的电子邮件应用程序并预​​先填写系统信息';

  @override
  String get subject => '主题';

  @override
  String get briefDescription => '简要说明';

  @override
  String get description => '描述';

  @override
  String get issueDescriptionHint => '提供有关您的问题的详细信息...';

  @override
  String get openingEmail => '打开电子邮件...';

  @override
  String get openEmailApp => '打开电子邮件应用程序';

  @override
  String get fillSubjectDescription => '请填写主题和描述';

  @override
  String get emailOpened => '电子邮件应用程序已打开。准备好后发送。';

  @override
  String get noEmailAppFound => '找不到电子邮件应用程序。接触：';

  @override
  String standardSubject(String subject) {
    return '主题：[标准] $subject';
  }

  @override
  String issueLine(String issue) {
    return '问题：$issue';
  }

  @override
  String failedOpenFaq(String error) {
    return '无法打开常见问题解答：$error';
  }

  @override
  String failedOpenDocs(String error) {
    return '无法打开文档：$error';
  }

  @override
  String get accessibilitySettings => '辅助功能设置';

  @override
  String get vibrationFeedback => '振动反馈';

  @override
  String get vibrateOnSessionEvents => '练习事件时振动';

  @override
  String get voiceAnnouncements => '语音通知';

  @override
  String get announceSessionProgress => '播报练习进度';

  @override
  String get highContrastMode => '高对比度模式';

  @override
  String get improveVisualAccessibility => '提高视觉可达性';

  @override
  String get largeText => '大文本';

  @override
  String get increaseTextSize => '增加文字大小';

  @override
  String get save => '节省';

  @override
  String get accessibilitySettingsSaved => '已保存辅助功能设置';

  @override
  String get noiseFloorCalibration => '本底噪声校准';

  @override
  String get measuringAmbientNoise => '测量环境噪声（约 5 秒）...';

  @override
  String get couldNotReadMic => '无法读取麦克风';

  @override
  String get calibrationFailed => '校准失败';

  @override
  String get retry => '重试';

  @override
  String previousThreshold(double value) {
    return '上一篇：$value dB';
  }

  @override
  String newThreshold(double value) {
    return '新阈值：$value dB';
  }

  @override
  String get noSignificantChange => '未检测到显着变化。';

  @override
  String get highAmbientDetected => '检测到周围环境较高。考虑一个更安静的空间以获得更高的灵敏度。';

  @override
  String get adjustAnytimeSettings => '您可以随时在“设置”中进行调整。';

  @override
  String get toggleThemeTooltip => '切换主题';

  @override
  String get audioChartRecovering => '音频图表正在恢复...';

  @override
  String themeChanged(String themeName) {
    return '主题：$themeName';
  }

  @override
  String get privacyComingSoon => '隐私政策即将推出。';

  @override
  String get ratingFeatureComingSoon => '评分功能即将推出！';

  @override
  String get startSessionButton => '开始练习';

  @override
  String get stopSessionButton => '停止';

  @override
  String get statusListening => '听...';

  @override
  String get statusSuccess => '实现了沉默！ +1 点';

  @override
  String get statusFailure => '太吵了！再试一次';

  @override
  String get upgrade => '升级';

  @override
  String get upgradeRequired => '需要升级';

  @override
  String get exportCsvSpreadsheet => 'CSV 电子表格';

  @override
  String get exportPdfReport => 'PDF报告';

  @override
  String get formattedReportCharts => '带图表的格式化报告';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => '主题';

  @override
  String get open => '打开';

  @override
  String get microphone => '麦克风';

  @override
  String get premium => '优质的';

  @override
  String get sessions => '会议';

  @override
  String get format => '格式';

  @override
  String get successRate => '成功率';

  @override
  String get avgSession => '平均会话数';

  @override
  String get consistency => '一致性';

  @override
  String get bestTime => '最佳时间';

  @override
  String get weeklyTrends => '每周趋势';

  @override
  String get performanceMetrics => '绩效指标';

  @override
  String get advancedAnalytics => '高级分析';

  @override
  String get premiumBadge => '优质的';

  @override
  String get bucket1to2 => '1-2分钟';

  @override
  String get bucket3to5 => '3-5分钟';

  @override
  String get bucket6to10 => '6-10分钟';

  @override
  String get bucket11to20 => '11-20分钟';

  @override
  String get bucket21to30 => '21-30分钟';

  @override
  String get bucket30plus => '30分钟以上';

  @override
  String get sessionHistoryTitle => '会话历史记录';

  @override
  String get recentSessionHistory => '最近的会话历史记录';

  @override
  String get achievementFirstStepTitle => '第一步';

  @override
  String get achievementFirstStepDesc => '完成你的第一节课';

  @override
  String get achievementOnFireTitle => '着火';

  @override
  String get achievementOnFireDesc => '连续3天实现';

  @override
  String get achievementWeekWarriorTitle => '周战士';

  @override
  String get achievementWeekWarriorDesc => '连续7天实现';

  @override
  String get achievementDecadeTitle => '十年';

  @override
  String get achievementDecadeDesc => '10分里程碑';

  @override
  String get achievementHalfCenturyTitle => '半个世纪';

  @override
  String get achievementHalfCenturyDesc => '50分里程碑';

  @override
  String get achievementLockedPrompt => '完成会话以解锁成就';

  @override
  String get ratingPromptTitle => '喜欢焦点领域吗？';

  @override
  String get ratingPromptBody => '快速的 5 星级评级可以帮助其他人找到更平静的专注时间。';

  @override
  String get ratingPromptRateNow => '立即评分';

  @override
  String get ratingPromptLater => '之后';

  @override
  String get ratingPromptNoThanks => '不，谢谢';

  @override
  String get ratingThankYou => '感谢您的支持！';

  @override
  String get notificationSettingsTitle => '通知设置';

  @override
  String get notificationPermissionRequired => '需要通知许可';

  @override
  String get notificationPermissionRationale => '启用通知以接收温和的提醒并庆祝成就。';

  @override
  String get requesting => '请求...';

  @override
  String get enableNotificationsCta => '启用通知';

  @override
  String get enableNotificationsTitle => '启用通知';

  @override
  String get enableNotificationsSubtitle => '允许 Focus Field 发送通知';

  @override
  String get dailyReminderTitle => '智能每日提醒';

  @override
  String get dailyReminderSubtitle => '聪明或选择的时间';

  @override
  String get dailyTimeLabel => '每日时间';

  @override
  String get dailyTimeHint => '选择固定时间或让 Focus Field 学习您的模式。';

  @override
  String get useSmartCta => '使用智能';

  @override
  String get sessionCompletedTitle => '会话已完成';

  @override
  String get sessionCompletedSubtitle => '庆祝已完成的课程';

  @override
  String get achievementUnlockedTitle => '解锁成就';

  @override
  String get achievementUnlockedSubtitle => '里程碑通知';

  @override
  String get weeklySummaryTitle => '每周进度总结';

  @override
  String get weeklySummarySubtitle => '每周见解（工作日和时间）';

  @override
  String get weeklyTimeLabel => '每周时间';

  @override
  String get notificationPreview => '通知预览';

  @override
  String get dailySilenceReminderTitle => '每日焦点提醒';

  @override
  String get weeklyProgressReportTitle => '每周进度报告📊';

  @override
  String get achievementUnlockedGenericTitle => '成就已解锁！ 🏆';

  @override
  String get sessionCompleteSuccessTitle => '会议结束！ 🎉';

  @override
  String get sessionCompleteEndedTitle => '会议结束';

  @override
  String get reminderStartJourney => '🎯 今天开始你的专注之旅！养成深入的工作习惯。';

  @override
  String get reminderRestart => '🌱 准备好重新开始你的专注练习了吗？每一刻都是一个新的开始。';

  @override
  String get reminderDayTwo => '⭐ 连续专注的第二天！一致性可以增强注意力。';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak天连续！您正在养成强大的专注习惯。';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 惊人的$streak天连续记录！你的奉献精神令人鼓舞。';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 令人难以置信的$streak天连续记录！你是焦点冠军！';
  }

  @override
  String get achievementFirstSession => '🎉 第一节结束！欢迎来到焦点领域！';

  @override
  String get achievementWeekStreak => '🌟 连续7天达成！一致性是你的超能力！';

  @override
  String get achievementMonthStreak => '🏆 30 天连续解锁！你势不可挡！';

  @override
  String get achievementPerfectSession => '✨ 完美的会议！保持100%平静的环境！';

  @override
  String get achievementLongSession => '⏰ 扩展会话大师！你的注意力会变得更强。';

  @override
  String get achievementGeneric => '🎊 成就已解锁！继续努力！';

  @override
  String get weeklyProgressNone => '💭 开始你的每周目标！准备好参加重点会议了吗？';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 本周有 $count 分钟专注时间！每次会议都很重要。';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 已获得 $count 分钟专注时间！你已经步入正轨了！';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 已达到 $count 分钟专注时间！完美的一周！';
  }

  @override
  String get tipsHidden => '隐藏提示';

  @override
  String get tipsShown => '显示提示';

  @override
  String get showTips => '显示提示';

  @override
  String get hideTips => '隐藏提示';

  @override
  String get tip01 => '从小事做起——即使是 2 分钟也能培养你的专注习惯。';

  @override
  String get tip02 => '你的连胜记录很优雅——根据 2 天规则，一次失误也不会打破它。';

  @override
  String get tip03 => '尝试学习、阅读或冥想活动来匹配您的专注方式。';

  @override
  String get tip04 => '检查您的 12 周热图，了解随着时间的推移，小小的胜利会带来怎样的复合效果。';

  @override
  String get tip05 => '观看训练期间的实时平静百分比 - 分数越高意味着注意力越集中！';

  @override
  String get tip06 => '自定义您的每日目标（10-60 分钟）以符合您的节奏。';

  @override
  String get tip07 => '使用每月的冻结代币来保护您在艰难日子里的连续记录。';

  @override
  String get tip08 => '赢得 3 场胜利后，Focus Field 提出了更严格的门槛——准备好升级了吗？';

  @override
  String get tip09 => '环境噪音大？提高你留在该区域的门槛。';

  @override
  String get tip10 => '智能每日提醒了解您的最佳时间 - 让它们指导您。';

  @override
  String get tip11 => '进度环是可点击的——点击一下即可启动您的专注会话。';

  @override
  String get tip12 => '当环境发生变化时重新校准以获得更高的准确性。';

  @override
  String get tip13 => '会议通知庆祝您的胜利——激发他们的动力！';

  @override
  String get tip14 => '一致性胜过完美——即使在忙碌的日子里也要出现。';

  @override
  String get tip15 => '尝试一天中的不同时间来发现您安静的最佳地点。';

  @override
  String get tip16 => '您每天的进度始终可见 - 点击“开始”即可随时开始。';

  @override
  String get tip17 => '每项活动都单独朝着您的目标前进——多样性让活动保持新鲜感。';

  @override
  String get tip18 => '导出您的数据（高级版）以查看您完整的专注旅程。';

  @override
  String get tip19 => '五彩纸屑庆祝每一次完成——小小的胜利值得认可！';

  @override
  String get tip20 => '您的基线很重要——在搬到新空间时进行校准。';

  @override
  String get tip21 => '您的 7 天趋势揭示了模式 - 每周检查一次以获取见解。';

  @override
  String get tip22 => '升级会话持续时间（高级）以获得更长的深度焦点块。';

  @override
  String get tip23 => '专注是一种练习——小规模的训练可以培养你想要的习惯。';

  @override
  String get tip24 => '每周摘要显示您的节奏 - 根据您的日程安排进行调整。';

  @override
  String get tip25 => '微调您的空间门槛——每个房间都是不同的。';

  @override
  String get tip26 => '辅助功能选项可帮助每个人集中注意力——高对比度、大文本、振动。';

  @override
  String get tip27 => '今天的时间轴显示您何时集中精力，找到您的高效工作时间。';

  @override
  String get tip28 => '完成你开始的事情——较短的疗程意味着更多的完成。';

  @override
  String get tip29 => '安静的几分钟加起来就能实现你的目标——进步而不是完美。';

  @override
  String get tip30 => '只需轻按一下即可开始一个小型会话。';

  @override
  String get tipInstructionNotifications => '设置 → 高级 → 通知来配置提醒和庆祝活动。';

  @override
  String get tipInstructionWeeklySummary => '设置 → 高级 → 通知 → 每周摘要以选择工作日和时间。';

  @override
  String get tipInstructionThreshold => '设置 → 基本 → 分贝阈值。先校准，再微调。';

  @override
  String get tipsTitle => '尖端';

  @override
  String get tipInstructionSetTime => '设置 → 基本 → 会话持续时间';

  @override
  String get tipInstructionDailyReminders => '设置→高级→通知→智能每日提醒。';

  @override
  String get tipInstructionCalibrate => '设置 → 高级 → 噪声校准。';

  @override
  String get tipInstructionOpenAnalytics => '打开 Analytics 查看趋势和平均值。';

  @override
  String get tipInstructionSessionComplete => '设置 → 高级 → 通知 → 会话完成。';

  @override
  String get tipInstructionTapRing => '在主页上，点击进度环即可开始/停止。';

  @override
  String get tipInstructionExport => '设置 → 高级 → 导出数据。';

  @override
  String get tipInstructionOpenNoiseChart => '启动会话以查看实时噪声图表。';

  @override
  String get tipInstructionUpgradeDuration => '设置 → 基本 → 会话持续时间。升级以获得更长的块。';

  @override
  String get tipInstructionAccessibility => '设置 → 高级 → 辅助功能。';

  @override
  String get tipInstructionStartNow => '点击主屏幕上的开始会话。';

  @override
  String get tipInstructionHeatmap => '摘要选项卡 → 显示更多 → 热图';

  @override
  String get tipInstructionTodayTimeline => '摘要选项卡 → 显示更多 → 今日时间线';

  @override
  String get tipInstruction7DayTrends => '摘要选项卡 → 显示更多 → 7 天趋势';

  @override
  String get tipInstructionEditActivities => '活动选项卡 → 点击编辑以显示/隐藏活动';

  @override
  String get tipInstructionQuestGo => '活动选项卡 → 任务胶囊 → 点击前往';

  @override
  String get tipInfoTooltip => '显示提示';

  @override
  String get questCapsuleTitle => '环境探索';

  @override
  String get questCapsuleLoading => '平静的分钟正在加载...';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return '平静 $progress/$goal 分钟 • 连续 $streak';
  }

  @override
  String get questFreezeButton => '冻结';

  @override
  String get questFrozenToday => '今天冰冻了——你被覆盖了。';

  @override
  String get questGoButton => '去';

  @override
  String calmPercent(int percent) {
    return '平静$percent%';
  }

  @override
  String get calmLabel => '冷静的';

  @override
  String get day => '天';

  @override
  String get days => '天';

  @override
  String get freeze => '冻结';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3胜！尝试$threshold dB？';
  }

  @override
  String get adaptiveThresholdNotNow => '现在不要';

  @override
  String get adaptiveThresholdTryIt => '尝试一下';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return '阈值设置为 $threshold dB';
  }

  @override
  String get edit => '编辑';

  @override
  String get start => '开始';

  @override
  String get error => '错误';

  @override
  String errorWithMessage(String message) {
    return '错误信息';
  }

  @override
  String get faqTitle => '常见问题解答';

  @override
  String get faqSearchHint => '搜索常见问题解答...';

  @override
  String get faqNoResults => '没有找到结果';

  @override
  String get faqNoResultsSubtitle => '尝试不同的搜索词';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到$count个结果',
      one: '找到1个结果',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => '什么是聚焦场？它如何帮助我集中注意力？';

  @override
  String get faqA01 => 'Focus Field 通过监控环境中的环境噪音来帮助您养成更好的专注习惯。当您开始课程（学习、阅读、冥想或其他）时，该应用程序会测量您的环境的安静程度。你越安静，你获得的“专注时间”就越多。这会鼓励您找到并保持无干扰的空间来进行深度工作。';

  @override
  String get faqQ02 => 'Focus Field 如何衡量我的注意力？';

  @override
  String get faqA02 => 'Focus Field 会在您的会议期间监控您环境中的环境噪音水平。它通过跟踪您的环境保持低于所选噪声阈值的秒数来计算“环境分数”。如果您的会话有至少 70% 的安静时间（环境得分 ≥70%），您将获得这些安静时间的满分。';

  @override
  String get faqQ03 => 'Focus Field 会录制我的音频或对话吗？';

  @override
  String get faqA03 => '不，绝对不。 Focus Field 仅测量分贝级别（响度） - 它从不记录、存储或传输任何音频。您的隐私受到完全保护。该应用程序只是检查您的环境是否高于或低于您选择的阈值。';

  @override
  String get faqQ04 => '我可以使用 Focus Field 跟踪哪些活动？';

  @override
  String get faqA04 => 'Focus Field 提供四种活动类型：学习 📚（用于学习和研究）、阅读 📖（用于专注阅读）、冥想 🧘（用于正念练习）和其他 ⭐（用于任何需要集中注意力的活动）。所有活动都使用环境噪音监测来帮助您保持安静、专注的环境。';

  @override
  String get faqQ05 => '我应该在所有活动中使用 Focus Field 吗？';

  @override
  String get faqA05 => 'Focus Field 最适合环境噪音表明您注意力集中程度的活动。学习、阅读和冥想等活动最受益于安静的环境。虽然您可以跟踪“其他”活动，但我们建议主要将 Focus Field 用于对噪声敏感的聚焦工作。';

  @override
  String get faqQ06 => '如何开始焦点会议？';

  @override
  String get faqA06 => '转到“课程”选项卡，选择您的活动（学习、阅读、冥想或其他），选择课程持续时间（1、5、10、15、30 分钟或高级选项），点击进度环上的“开始”按钮，并保持环境安静！';

  @override
  String get faqQ07 => '可用的会话持续时间是多少？';

  @override
  String get faqA07 => '免费用户可以选择：1、5、10、15 或 30 分钟的会话。高级用户还可以获得：1 小时、1.5 小时和 2 小时的延长会话，以实现更长的深度工作时间。';

  @override
  String get faqQ08 => '我可以提前暂停或停止会话吗？';

  @override
  String get faqA08 => '是的！在会话期间，您会在进度环上方看到“暂停”和“停止”按钮。为了防止意外点击，您需要长按这些按钮。如果您提早停车，您仍然可以通过积累的安静时间赚取积分。';

  @override
  String get faqQ09 => '如何在 Focus Field 中赚取积分？';

  @override
  String get faqA09 => '每安静一分钟即可赚取 1 分。在您的会话期间，Focus Field 会跟踪您的环境保持在噪声阈值以下的秒数。最后，那些安静的秒数被转换为分钟。例如，如果您完成 10 分钟的课程并有 8 分钟的安静时间，您将获得 8 分。';

  @override
  String get faqQ10 => '70% 的门槛是多少？为什么它很重要？';

  @override
  String get faqA10 => '70% 阈值决定您的训练次数是否计入您的每日目标。如果您的环境分数（安静时间 ÷ 总时间）至少为 70%，您的会话就有资格获得任务积分。即使您的分数低于 70%，您仍然可以通过安静的每一分钟赚取积分！';

  @override
  String get faqQ11 => '环境分数和分数有什么区别？';

  @override
  String get faqA11 => '环境分数是您的会话质量百分比（安静秒数 ÷ 总秒数），确定您是否达到 70% 的阈值。积分是实际获得的安静分钟数（1 分 = 1 分钟）。环境分数=质量，积分=成就。';

  @override
  String get faqQ12 => 'Focus Field 中的条纹如何发挥作用？';

  @override
  String get faqA12 => '连续记录跟踪实现每日目标的连续天数。 Focus Field 使用富有同情心的 2 天规则：只有连续两天缺席，您的连续记录才会中断。这意味着您可以错过某一天，但如果您第二天完成了目标，您的连续记录就会继续。';

  @override
  String get faqQ13 => '什么是冻结令牌以及如何使用它们？';

  @override
  String get faqA13 => '当您无法完成目标时，冻结代币可以保护您的连胜。您每月获得 1 个免费冻结代币。使用时，您的总体进度显示 100%（目标受保护），您的连续记录是安全的，并且个人活动跟踪正常继续。在忙碌的日子里明智地使用它！';

  @override
  String get faqQ14 => '我可以定制我的每日焦点目标吗？';

  @override
  String get faqA14 => '是的！点击“今日”选项卡中“会话”卡上的“编辑”。您可以设置全局每日目标（免费 10-60 分钟，付费最多 1080 分钟），为单独的目标启用每个活动目标，以及显示/隐藏特定活动。';

  @override
  String get faqQ15 => '噪声阈值是多少以及如何调整它？';

  @override
  String get faqA15 => '阈值是算作“安静”的最大噪声级别（以分贝为单位）。默认值为 40 dB（图书馆安静）。您可以在“会话”选项卡中对其进行调整：30 dB（非常安静）、40 dB（图书馆安静 - 推荐）、50 dB（中等办公室）、60-80 dB（大声环境）。';

  @override
  String get faqQ16 => '什么是自适应阈值？我应该使用它吗？';

  @override
  String get faqA16 => '在当前阈值连续成功进行 3 次训练后，Focus Field 建议将其增加 2 dB 以挑战自己。这可以帮助你逐渐提高。您可以接受或拒绝该建议 - 它每 7 天只出现一次。';

  @override
  String get faqQ17 => '什么是对焦模式？';

  @override
  String get faqA17 => '专注模式是在您的会话期间全屏无干扰的叠加。它显示您的倒计时器、实时平静百分比和最小控制（通过长按暂停/停止）。它删除了所有其他 UI 元素，因此您可以完全集中精力。在“设置”>“基本”>“对焦模式”中启用它。';

  @override
  String get faqQ18 => '为什么 Focus Field 需要麦克风权限？';

  @override
  String get faqA18 => 'Focus Field 使用设备的麦克风来测量会话期间的环境噪音水平（分贝）。这对于计算您的环境分数至关重要。请记住：不会记录任何音频 - 仅实时测量噪音水平。';

  @override
  String get faqQ19 => '我能看到一段时间内我的注意力模式吗？';

  @override
  String get faqA19 => '是的！ “今日”选项卡显示您的每日进度、每周趋势、12 周活动热图（如 GitHub 贡献）和会话时间线。高级用户可以获得包含性能指标、移动平均值和人工智能驱动的见解的高级分析。';

  @override
  String get faqQ20 => 'Focus Field 中的通知如何工作？';

  @override
  String get faqA20 => 'Focus Field 具有智能提醒功能：每日提醒（了解您首选的专注时间或使用固定时间）、包含结果的会话完成通知、里程碑的成就通知以及每周摘要（高级版）。在“设置”>“高级”>“通知”中启用/自定义。';

  @override
  String get microphoneSettingsTitle => '所需设置';

  @override
  String get microphoneSettingsMessage => '要启用静音检测，请手动授予麦克风权限：\n\n• iOS：设置 > 隐私和安全 > 麦克风 > 焦点区域\n• Android：设置 > 应用程序 > 焦点字段 > 权限 > 麦克风';

  @override
  String get buttonGrantPermission => '授予许可';

  @override
  String get buttonOk => '好的';

  @override
  String get buttonOpenSettings => '打开设置';

  @override
  String get onboardingBack => '后退';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一个';

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String get onboardingWelcomeSnackbar => '欢迎！准备好开始你的第一堂课了吗？ 🚀';

  @override
  String get onboardingWelcomeTitle => '欢迎来到\n聚焦领域！ 🎯';

  @override
  String get onboardingWelcomeSubtitle => '您的专注之旅从这里开始！\n让我们养成坚持的习惯吧💪';

  @override
  String get onboardingFeatureTrackTitle => '追踪你的注意力';

  @override
  String get onboardingFeatureTrackDesc => '当你建立你的专注超能力时，实时查看你的进步！ 📊';

  @override
  String get onboardingFeatureRewardsTitle => '赚取奖励';

  @override
  String get onboardingFeatureRewardsDesc => '每安静的一分钟都很重要！收集积分并庆祝您的胜利🏆';

  @override
  String get onboardingFeatureStreaksTitle => '建立连胜';

  @override
  String get onboardingFeatureStreaksDesc => '继续保持势头！我们的富有同情心的系统让您充满动力🔥';

  @override
  String get onboardingEnvironmentTitle => '你的焦点区域在哪里？ 🎯';

  @override
  String get onboardingEnvironmentSubtitle => '选择您的典型环境，以便我们优化您的空间！';

  @override
  String get onboardingEnvQuietHomeTitle => '安静的家';

  @override
  String get onboardingEnvQuietHomeDesc => '卧室、安静的家庭办公室';

  @override
  String get onboardingEnvQuietHomeDb => '30 分贝 - 非常安静';

  @override
  String get onboardingEnvOfficeTitle => '典型办公室';

  @override
  String get onboardingEnvOfficeDesc => '标准办公室、图书馆';

  @override
  String get onboardingEnvOfficeDb => '40 分贝 - 图书馆安静（推荐）';

  @override
  String get onboardingEnvBusyTitle => '繁忙空间';

  @override
  String get onboardingEnvBusyDesc => '咖啡厅、共享工作空间';

  @override
  String get onboardingEnvBusyDb => '50 分贝 - 中等噪音';

  @override
  String get onboardingEnvNoisyTitle => '嘈杂的环境';

  @override
  String get onboardingEnvNoisyDesc => '开放式办公室、公共空间';

  @override
  String get onboardingEnvNoisyDb => '60 dB - 更高噪音';

  @override
  String get onboardingEnvAdjustNote => '您可以随时在“设置”中进行调整';

  @override
  String get onboardingGoalTitle => '设定您的每日目标！ 🎯';

  @override
  String get onboardingGoalSubtitle => '您觉得多长时间的专注时间合适？\n（您可以随时调整！）';

  @override
  String get onboardingGoalStartingTitle => '入门';

  @override
  String get onboardingGoalStartingDuration => '10-15分钟';

  @override
  String get onboardingGoalHabitTitle => '养成习惯';

  @override
  String get onboardingGoalHabitDuration => '20-30分钟';

  @override
  String get onboardingGoalPracticeTitle => '定期练习';

  @override
  String get onboardingGoalPracticeDuration => '40-60分钟';

  @override
  String get onboardingGoalDeepWorkTitle => '深度工作';

  @override
  String get onboardingGoalDeepWorkDuration => '60+分钟';

  @override
  String get onboardingGoalAdvice1 => '完美的开始！ 🌟 小步骤带来大胜利。你已经得到了这个！';

  @override
  String get onboardingGoalAdvice2 => '绝佳的选择！ 🎯 这个甜蜜点可以培养持久的习惯！';

  @override
  String get onboardingGoalAdvice3 => '雄心勃勃！ 💪 您已准备好升级您的专注力游戏了！';

  @override
  String get onboardingGoalAdvice4 => '哇！ 🏆深度工作模式激活！记得注意休息！';

  @override
  String get onboardingActivitiesTitle => '选择您的活动！ ✨';

  @override
  String get onboardingActivitiesSubtitle => '选出所有能引起你共鸣的！\n（以后您可以随时添加更多内容）';

  @override
  String get onboardingActivityStudyTitle => '学习';

  @override
  String get onboardingActivityStudyDesc => '学习、课程作业、研究';

  @override
  String get onboardingActivityReadingTitle => '阅读';

  @override
  String get onboardingActivityReadingDesc => '深度阅读、文章、书籍';

  @override
  String get onboardingActivityMeditationTitle => '冥想';

  @override
  String get onboardingActivityMeditationDesc => '正念、呼吸练习';

  @override
  String get onboardingActivityOtherTitle => '其他';

  @override
  String get onboardingActivityOtherDesc => '任何需要集中注意力的活动';

  @override
  String get onboardingActivitiesTip => '专业提示：安静时焦点场会发光 = 专注！ 🤫✨';

  @override
  String get onboardingPermissionTitle => '您的隐私很重要！ 🔒';

  @override
  String get onboardingPermissionSubtitle => '我们需要使用麦克风来测量环境噪音并帮助您更好地集中注意力';

  @override
  String get onboardingPrivacyNoRecordingTitle => '无录音';

  @override
  String get onboardingPrivacyNoRecordingDesc => '我们只测量噪音水平，从不录制音频';

  @override
  String get onboardingPrivacyLocalTitle => '仅限本地';

  @override
  String get onboardingPrivacyLocalDesc => '所有数据都保留在您的设备上';

  @override
  String get onboardingPrivacyFirstTitle => '隐私第一';

  @override
  String get onboardingPrivacyFirstDesc => '您的谈话是完全私密的';

  @override
  String get onboardingPermissionNote => '您可以在开始第一个会话时在下一个屏幕上授予权限';

  @override
  String get onboardingTipsTitle => '成功的专业秘诀！ 💡';

  @override
  String get onboardingTipsSubtitle => '这些将帮助您充分利用 Focus Field！';

  @override
  String get onboardingTip1Title => '从小事做起，赢得大事！ 🌱';

  @override
  String get onboardingTip1Desc => '从 5-10 分钟的课程开始。一致性胜过完美！';

  @override
  String get onboardingTip2Title => '激活专注模式！ 🎯';

  @override
  String get onboardingTip2Desc => '点击专注模式即可获得身临其境、无干扰的体验。';

  @override
  String get onboardingTip3Title => '冻结代币=安全网！ ❄️';

  @override
  String get onboardingTip3Desc => '在繁忙的日子里使用您的每月代币来保护您的连续记录。';

  @override
  String get onboardingTip4Title => '70% 规则很有效！ 📈';

  @override
  String get onboardingTip4Desc => '目标是 70% 的安静时间 - 不需要完全安静！';

  @override
  String get onboardingReadyTitle => '您已准备好启动！ 🚀';

  @override
  String get onboardingReadyDesc => '让我们开始您的第一堂课并养成惊人的习惯！';

  @override
  String get questMotivation1 => '成功永远不会结束，失败也永远不会结束';

  @override
  String get questMotivation2 => '进步胜于完美——每一分钟都很重要';

  @override
  String get questMotivation3 => '每天的小步骤会带来大改变';

  @override
  String get questMotivation4 => '您正在养成更好的习惯，一次一个疗程';

  @override
  String get questMotivation5 => '一致性胜过强度';

  @override
  String get questMotivation6 => '每场比赛都是一场胜利，无论多短';

  @override
  String get questMotivation7 => '专注是肌肉——你会变得更强壮';

  @override
  String get questMotivation8 => '千里之行始于足下';

  @override
  String get questGo => '去';

  @override
  String get todayDashboardTitle => '您的焦点仪表板';

  @override
  String get todayFocusMinutes => '今日焦点会议纪要';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return '目标：$goalMinutes 分钟 • 平静 ≥$calmPercent%';
  }

  @override
  String get todayPickMode => '选择您的模式';

  @override
  String get todayDefaultActivities => '学习•阅读•冥想';

  @override
  String get todayTooltipTips => '尖端';

  @override
  String get todayTooltipTheme => '主题';

  @override
  String get todayTooltipSettings => '设置';

  @override
  String todayThemeChanged(String themeName) {
    return '主题更改为 $themeName';
  }

  @override
  String get todayTabToday => '今天';

  @override
  String get todayTabSessions => '会议';

  @override
  String get todayHelperText => '设置您的持续时间并跟踪您的时间。会话历史记录和分析将显示在摘要中。';

  @override
  String get statPoints => '积分';

  @override
  String get statStreak => '条纹';

  @override
  String get statSessions => '会议';

  @override
  String get ringProgressTitle => '戒指进度';

  @override
  String get ringOverall => '全面的';

  @override
  String get ringOverallFrozen => '总体❄️';

  @override
  String get sessionCalm => '冷静的';

  @override
  String get sessionStart => '开始';

  @override
  String get sessionStop => '停止';

  @override
  String get buttonEdit => '编辑';

  @override
  String get durationUpTo1Hour => '会议时间长达 1 小时';

  @override
  String get durationUpTo1_5Hours => '会话长达 1.5 小时';

  @override
  String get durationUpTo2Hours => '会议时间长达 2 小时';

  @override
  String get durationExtended => '延长会话持续时间';

  @override
  String get durationExtendedAccess => '扩展会话访问';

  @override
  String get noiseRoomLoudness => '房间响度';

  @override
  String noiseThresholdLabel(int threshold) {
    return '阈值：${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return '阈值设置为 $db dB';
  }

  @override
  String get noiseHighDetected => '检测到高噪音，请前往更安静的房间以便更好地集中注意力';

  @override
  String get noiseThresholdExceededHint => '找一个更安静的房间或提高门槛 →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return '寻找一个更安静的房间或提高到 ${db}dB？';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return '检测到高噪音。增加到${db}dB？';
  }

  @override
  String get noiseAtMaxThreshold => '已经达到最大阈值。请找一个更安静的房间。';

  @override
  String get noiseThresholdYes => '是的';

  @override
  String get noiseThresholdNo => '不';

  @override
  String get trendsInsights => '见解';

  @override
  String get trendsLast7Days => '过去 7 天';

  @override
  String get trendsShareWeeklySummary => '分享每周总结';

  @override
  String get trendsLoading => '加载中...';

  @override
  String get trendsLoadingMetrics => '正在加载指标...';

  @override
  String get trendsNoData => '无数据';

  @override
  String get trendsWeeklyTotal => '每周总计';

  @override
  String get trendsBestDay => '最好的一天';

  @override
  String get trendsActivityHeatmap => '活动热图';

  @override
  String get trendsRecentActivity => '最近的活动';

  @override
  String get trendsHeatmapError => '无法加载热图';

  @override
  String get dayMon => '周一';

  @override
  String get dayTue => '星期二';

  @override
  String get dayWed => '周三';

  @override
  String get dayThu => '星期四';

  @override
  String get dayFri => '周五';

  @override
  String get daySat => '星期六';

  @override
  String get daySun => '太阳';

  @override
  String get focusModeComplete => '会议结束！';

  @override
  String get focusModeGreatSession => '精彩的焦点会议';

  @override
  String get focusModeResume => '恢复';

  @override
  String get focusModePause => '暂停';

  @override
  String get focusModeLongPressHint => '长按暂停或停止';

  @override
  String get activityEditTitle => '编辑活动';

  @override
  String get activityRecommendation => '建议：每次活动 10 分钟以上，以养成一致的习惯';

  @override
  String get activityDailyGoals => '每日目标';

  @override
  String activityTotalHours(String hours) {
    return '总计：$hours小时/18 小时';
  }

  @override
  String get activityPerActivity => '每项活动';

  @override
  String get activityExceedsLimit => '总计超过每日 18 小时限制。请减少目标。';

  @override
  String get activityGoalLabel => '目标';

  @override
  String get activityGoalDescription => '设定每日焦点目标（1 分钟 - 18 小时）';

  @override
  String get shareYourProgress => '分享您的进步';

  @override
  String get shareTimeRange => '时间范围';

  @override
  String get shareCardSize => '卡片尺寸';

  @override
  String get analyticsPerformanceMetrics => '绩效指标';

  @override
  String get analyticsPreferredDuration => '首选持续时间';

  @override
  String get analyticsUnavailable => '分析不可用';

  @override
  String get analyticsRestoreAttempt => '我们将尝试在下次应用程序启动时恢复此部分。';

  @override
  String get audioUnavailable => '音频暂时无法使用';

  @override
  String get audioRecovering => '音频处理遇到问题。正在自动恢复...';

  @override
  String get shareQuietMinutes => '安静几分钟';

  @override
  String get shareTopActivity => '热门活动';

  @override
  String get appName => '聚焦领域';

  @override
  String get sharePreview => '预览';

  @override
  String get sharePinchToZoom => '捏合缩放';

  @override
  String get shareGenerating => '生成...';

  @override
  String get shareButton => '分享';

  @override
  String get shareTodayLabel => '今天';

  @override
  String get shareWeeklyLabel => '每周';

  @override
  String get shareTodayTitle => '今日焦点';

  @override
  String get shareWeeklyTitle => '您每周的焦点';

  @override
  String get shareSubject => '我的关注领域进展';

  @override
  String get shareFormatSquare => '1:1 比例 • 通用兼容性';

  @override
  String get shareFormatPost => '4:5 比例 • Instagram/Twitter 帖子';

  @override
  String get shareFormatStory => '9:16 比例 • Instagram 故事';

  @override
  String get recapWeeklyTitle => '每周回顾';

  @override
  String get recapMinutes => '分钟';

  @override
  String recapStreak(int start, int end) {
    return '连胜：$start → $end 天';
  }

  @override
  String get recapTopActivity => '热门活动：';

  @override
  String get practiceOverviewTitle => '实践概览';

  @override
  String get practiceLast7Days => '过去 7 天';

  @override
  String get audioMultipleErrors => '检测到多个音频错误。组件恢复中...';

  @override
  String activityCurrentGoal(String goal) {
    return '当前目标：$goal';
  }

  @override
  String get activitySaveChanges => '保存更改';

  @override
  String get insightsTitle => '见解';

  @override
  String get insightsTooltip => '查看详细见解';

  @override
  String get statDays => '天';

  @override
  String sessionsTotalToday(int done, int goal) {
    return '今天总计 $done/$goal 分钟，选择任意活动';
  }

  @override
  String get premiumFeature => '高级功能';

  @override
  String get premiumFeatureAccess => '高级功能访问';

  @override
  String get activityUnknown => '未知';

  @override
  String get insightsFirstSessionTitle => '完成你的第一节课';

  @override
  String get insightsFirstSessionSubtitle => '开始跟踪您的专注时间、会话模式和环境分数趋势';

  @override
  String sessionAmbientLabel(int percent) {
    return '环境：$percent%';
  }

  @override
  String get sessionSuccess => '成功';

  @override
  String get sessionFailed => '失败的';

  @override
  String get focusModeButton => '专注模式';

  @override
  String get settingsDailyGoalsTitle => '每日目标';

  @override
  String get settingsFocusModeDescription => '通过集中覆盖最大限度地减少会议期间的干扰';

  @override
  String get settingsDeepFocusTitle => '深度聚焦';

  @override
  String get settingsDeepFocusDescription => '如果应用程序离开则结束会话';

  @override
  String get deepFocusDialogTitle => '深度聚焦';

  @override
  String get deepFocusEnableLabel => '启用深度对焦';

  @override
  String get deepFocusGracePeriodLabel => '宽限期（秒）';

  @override
  String get deepFocusExplanation => '启用后，离开应用程序将在宽限期后结束会话。';

  @override
  String get notificationPermissionTitle => '启用通知';

  @override
  String get notificationPermissionExplanation => 'Focus Field 需要通知权限才能向您发送：';

  @override
  String get notificationBenefitReminders => '每日焦点提醒';

  @override
  String get notificationBenefitCompletion => '会话完成警报';

  @override
  String get notificationBenefitAchievements => '成就庆祝活动';

  @override
  String get notificationHowToEnableIos => '如何在 iOS 上启用：';

  @override
  String get notificationHowToEnableAndroid => '如何在 Android 上启用：';

  @override
  String get notificationStepsIos => '1. 点击下方的“打开设置”\n2. 点击“通知”\n3.启用“允许通知”';

  @override
  String get notificationStepsAndroid => '1. 点击下方的“打开设置”\n2. 点击“通知”\n3.启用“所有焦点字段通知”';

  @override
  String get aboutShowTips => '显示提示';

  @override
  String get aboutShowTipsDescription => '通过灯泡图标显示有关应用程序启动的有用提示。提示每 2-3 天出现一次。';

  @override
  String get aboutReplayOnboarding => '重播入职流程';

  @override
  String get aboutReplayOnboardingDescription => '查看应用程序导览并再次设置您的首选项';

  @override
  String get buttonFaq => '常问问题';

  @override
  String get onboardingWelcomeMessage => '欢迎！准备好开始你的第一堂课了吗？ 🚀';

  @override
  String get onboardingFeatureEarnTitle => '赚取奖励';

  @override
  String get onboardingFeatureEarnDesc => '每安静的一分钟都很重要！收集积分并庆祝您的胜利🏆';

  @override
  String get onboardingFeatureBuildTitle => '建立连胜';

  @override
  String get onboardingFeatureBuildDesc => '继续保持势头！我们的富有同情心的系统让您充满动力🔥';

  @override
  String get onboardingEnvironmentDescription => '选择您的典型环境，以便我们优化您的空间！';

  @override
  String get onboardingEnvQuietHome => '安静的家';

  @override
  String get onboardingEnvQuietHomeLevel => '30 分贝 - 非常安静';

  @override
  String get onboardingEnvOffice => '典型办公室';

  @override
  String get onboardingEnvOfficeLevel => '40 分贝 - 图书馆安静（推荐）';

  @override
  String get onboardingEnvBusy => '繁忙空间';

  @override
  String get onboardingEnvBusyLevel => '50 分贝 - 中等噪音';

  @override
  String get onboardingEnvNoisy => '嘈杂的环境';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - 更高噪音';

  @override
  String get onboardingAdjustAnytime => '您可以随时在“设置”中进行调整';

  @override
  String get buttonGetStarted => '开始使用';

  @override
  String get buttonNext => '下一个';

  @override
  String get errorActivityRequired => '⚠️ 必须至少启用一项活动';

  @override
  String get errorGoalExceeds => '总目标超过每日 18 小时限制。请减少目标。';

  @override
  String get messageSaved => '设置已保存';

  @override
  String get errorPermissionRequired => '需要许可';

  @override
  String get notificationEnableReason => '启用通知以接收提醒并庆祝成就。';

  @override
  String get buttonEnableNotifications => '启用通知';

  @override
  String get buttonRequesting => '请求...';

  @override
  String get notificationDailyTime => '每日时间';

  @override
  String notificationDailyReminderSet(String time) {
    return '每日$time提醒';
  }

  @override
  String get notificationLearning => '学习';

  @override
  String notificationSmart(String time) {
    return '智能（$time）';
  }

  @override
  String get buttonUseSmart => '使用智能';

  @override
  String get notificationSmartExplanation => '选择固定时间或让 Focus Field 学习您的模式。';

  @override
  String get notificationSessionComplete => '会话已完成';

  @override
  String get notificationSessionCompleteDesc => '庆祝已完成的课程';

  @override
  String get notificationAchievement => '解锁成就';

  @override
  String get notificationAchievementDesc => '里程碑通知';

  @override
  String get notificationWeekly => '每周进度总结';

  @override
  String get notificationWeeklyDesc => '每周见解（工作日和时间）';

  @override
  String get notificationWeeklyTime => '每周时间';

  @override
  String get notificationMilestone => '里程碑通知';

  @override
  String get notificationWeeklyInsights => '每周见解（工作日和时间）';

  @override
  String get notificationDailyReminder => '每日提醒';

  @override
  String get notificationComplete => '会话完成';

  @override
  String get settingsSnackbar => '请在设备设置中启用通知';

  @override
  String get shareCardTitle => '共享卡';

  @override
  String get shareYourWeek => '分享你的一周';

  @override
  String get shareStyleGradient => '渐变风格';

  @override
  String get shareStyleGradientDesc => '带有大量数字的粗体渐变';

  @override
  String get shareWeeklySummary => '每周总结';

  @override
  String get shareStyleAchievement => '成就风格';

  @override
  String get shareStyleAchievementDesc => '专注于安静的总分钟数';

  @override
  String get shareQuietMinutesWeek => '本周安静时刻';

  @override
  String get shareAchievementMessage => '建立更深入的焦点，\\一次无会话';

  @override
  String get shareAchievementCard => '成就卡';

  @override
  String get shareTextOnly => '仅文本';

  @override
  String get shareTextOnlyDesc => '以纯文本形式分享（无图像）';

  @override
  String get shareYourStreak => '分享你的连胜记录';

  @override
  String get shareAsCard => '分享为卡';

  @override
  String get shareAsCardDesc => '美丽的视觉卡';

  @override
  String get shareStreakCard => '连胜卡';

  @override
  String get shareAsText => '以文本形式分享';

  @override
  String get shareAsTextDesc => '简单的短信';

  @override
  String get shareErrorFailed => '分享失败。请再试一次。';

  @override
  String get buttonShare => '分享';

  @override
  String get initializingApp => '正在初始化应用程序...';

  @override
  String initializationFailed(String error) {
    return '初始化失败：$error';
  }

  @override
  String get loadingSettings => '正在加载设置...';

  @override
  String settingsLoadingFailed(String error) {
    return '设置加载失败：$error';
  }

  @override
  String get loadingUserData => '正在加载用户数据...';

  @override
  String dataLoadingFailed(String error) {
    return '数据加载失败：$error';
  }

  @override
  String get loading => '加载中...';

  @override
  String get taglineSilence => '🤫 掌握沉默的艺术';

  @override
  String get errorOops => '哎呀！出了点问题';

  @override
  String get buttonRetry => '重试';

  @override
  String get resetAppData => '重置应用程序数据';

  @override
  String get resetAppDataMessage => '这会将所有应用程序数据和设置重置为默认值。此操作无法撤消。\\n\\n您想继续吗？';

  @override
  String get buttonReset => '重置';

  @override
  String get messageDataReset => '应用程序数据已重置';

  @override
  String errorResetFailed(String error) {
    return '重置数据失败：$error';
  }

  @override
  String get analyticsTitle => '分析';

  @override
  String get analyticsOverview => '概述';

  @override
  String get analyticsPoints => '积分';

  @override
  String get analyticsStreak => '条纹';

  @override
  String get analyticsSessions => '会议';

  @override
  String get analyticsLast7Days => '过去 7 天';

  @override
  String get analyticsPerformanceHighlights => '性能亮点';

  @override
  String get analyticsSuccessRate => '成功率';

  @override
  String get analyticsAvgSession => '平均会话数';

  @override
  String get analyticsBestStreak => '最佳连胜纪录';

  @override
  String get analyticsActivityProgress => '活动进度';

  @override
  String get analyticsComingSoon => '详细的活动跟踪即将推出。';

  @override
  String get analyticsAdvancedMetrics => '高级指标';

  @override
  String get analyticsPremiumContent => '高级高级分析内容在这里...';

  @override
  String get analytics30DayTrends => '30 天趋势';

  @override
  String get analyticsTrendsChart => '优质趋势图表在这里...';

  @override
  String get analyticsAIInsights => '人工智能洞察';

  @override
  String get analyticsAIComingSoon => '人工智能驱动的见解即将推出...';

  @override
  String get analyticsUnlock => '解锁高级分析';

  @override
  String get errorTitle => '错误';

  @override
  String get errorQuestUnavailable => '任务状态不可用';

  @override
  String get buttonOK => '好的';

  @override
  String get errorFreezeTokenFailed => '❌ 使用冻结令牌失败';

  @override
  String get buttonUseFreeze => '使用冻结';

  @override
  String get onboardingDailyGoalTitle => '设定您的每日目标！ 🎯';

  @override
  String get onboardingDailyGoalSubtitle => '多长时间的专注时间适合您？\\n（您可以随时调整！）';

  @override
  String get onboardingGoalGettingStarted => '入门';

  @override
  String get onboardingGoalBuildingHabit => '养成习惯';

  @override
  String get onboardingGoalRegularPractice => '定期练习';

  @override
  String get onboardingGoalDeepWork => '深度工作';

  @override
  String get onboardingProTip => '专业提示：安静时焦点场会发光 = 专注！ 🤫✨';

  @override
  String get onboardingPrivacyTitle => '您的隐私很重要！ 🔒';

  @override
  String get onboardingPrivacySubtitle => '我们需要使用麦克风来测量环境噪音并帮助您更好地集中注意力';

  @override
  String get onboardingPrivacyNoRecording => '无录音';

  @override
  String get onboardingPrivacyLocalOnly => '仅限本地';

  @override
  String get onboardingPrivacyLocalOnlyDesc => '所有数据都保留在您的设备上';

  @override
  String get onboardingPrivacyFirst => '隐私第一';

  @override
  String get onboardingPrivacyNote => '您可以在开始第一个会话时在下一个屏幕上授予权限';

  @override
  String get insightsFocusTime => '专注时间';

  @override
  String get insightsSessions => '练习次数';

  @override
  String get insightsAverage => '平均的';

  @override
  String get insightsAmbientScore => '环境得分';

  @override
  String get themeSystem => '系统';

  @override
  String get themeLight => '光';

  @override
  String get themeDark => '黑暗的';

  @override
  String get themeOceanBlue => '海洋蓝';

  @override
  String get themeForestGreen => '森林绿';

  @override
  String get themePurpleNight => '紫夜';

  @override
  String get themeGoldLuxury => '黄金奢华';

  @override
  String get themeSolarSunrise => '太阳能日出';

  @override
  String get themeCyberNeon => '网络霓虹灯';

  @override
  String get themeMidnightTeal => '午夜青色';

  @override
  String get settingsAppTheme => '应用主题';

  @override
  String get freezeTokenNoTokensTitle => '无冻结代币';

  @override
  String get freezeTokenNoTokensMessage => '您没有任何可用的冻结令牌。您每周可获得 1 个冻结代币（最多 4 个）。';

  @override
  String get freezeTokenGoalCompleteTitle => '目标已经完成';

  @override
  String get freezeTokenGoalCompleteMessage => '您的每日目标已经完成！冻结代币只能在您尚未实现目标时使用。';

  @override
  String get freezeTokenUseTitle => '使用冻结令牌';

  @override
  String get freezeTokenUseMessage => '当您缺席某一天时，冻结代币可以保护您的连续记录。使用冻结将被视为完成您的每日目标。';

  @override
  String freezeTokenUsePrompt(Object count) {
    return '您有 $count 个令牌。现在用一个吗？';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ 冻结已使用的代币！目标标记为完成。';

  @override
  String get trendsErrorLoading => '加载数据时出错';

  @override
  String get trendsPoints => '积分';

  @override
  String get trendsStreak => '条纹';

  @override
  String get trendsSessions => '练习';

  @override
  String get trendsTopActivity => '热门活动';

  @override
  String get sectionToday => '今天';

  @override
  String get sectionSessions => '会议';

  @override
  String get sectionInsights => '见解';

  @override
  String get onboardingGoalAdviceGettingStarted => '完美的开始！ 🌟 小步骤带来大胜利。你已经得到了这个！';

  @override
  String get onboardingGoalAdviceBuildingHabit => '绝佳的选择！ 🎯 这个甜蜜点可以培养持久的习惯！';

  @override
  String get onboardingGoalAdviceRegularPractice => '雄心勃勃！ 💪 您已准备好升级您的专注力游戏了！';

  @override
  String get onboardingGoalAdviceDeepWork => '哇！ 🏆深度工作模式激活！记得注意休息！';

  @override
  String get onboardingDuration10to15 => '10-15分钟';

  @override
  String get onboardingDuration20to30 => '20-30分钟';

  @override
  String get onboardingDuration40to60 => '40-60分钟';

  @override
  String get onboardingDuration60plus => '60+分钟';

  @override
  String get activityStudy => '学习';

  @override
  String get activityReading => '阅读';

  @override
  String get activityMeditation => '冥想';

  @override
  String get activityOther => '其他';

  @override
  String get onboardingTip1Description => '从 5-10 分钟的课程开始。一致性胜过完美！';

  @override
  String get onboardingTip2Description => '点击专注模式即可获得身临其境、无干扰的体验。';

  @override
  String get onboardingTip3Description => '在繁忙的日子里使用您的每月代币来保护您的连续记录。';

  @override
  String get onboardingTip4Description => '目标是 70% 的安静时间 - 不需要完全安静！';

  @override
  String get onboardingLaunchTitle => '您已准备好启动！ 🚀';

  @override
  String get onboardingLaunchDescription => '让我们开始您的第一堂课并养成惊人的习惯！';

  @override
  String get insightsBestTimeByActivity => '最佳活动时间';

  @override
  String get insightHighSuccessRateTitle => '高成功率';

  @override
  String get insightEnvironmentStabilityTitle => '环境稳定性';

  @override
  String get insightLowNoiseSuccessTitle => '低噪音成功';

  @override
  String get insightConsistentPracticeTitle => '坚持练习';

  @override
  String get insightStreakProtectionTitle => '连胜保护可用';

  @override
  String get insightRoomTooNoisyTitle => '房间太吵';

  @override
  String get insightIrregularScheduleTitle => '时间不规律';

  @override
  String get insightLowAmbientScoreTitle => '环境得分低';

  @override
  String get insightNoRecentSessionsTitle => '最近无练习';

  @override
  String get insightHighSuccessRateDesc => '您正在保持强大的安静练习。';

  @override
  String get insightEnvironmentStabilityDesc => '环境噪音在适中、可控的范围内。';

  @override
  String get insightLowNoiseSuccessDesc => '您的环境在练习期间异常安静。';

  @override
  String get insightConsistentPracticeDesc => '您正在养成可靠的每日练习习惯。';

  @override
  String insightStreakProtectionDesc(Object count) {
    return '您有 $count 个冻结令牌来保护您的连胜。';
  }

  @override
  String get insightRoomTooNoisyDesc => '尝试找一个更安静的空间或调整您的阈值。';

  @override
  String get insightIrregularScheduleDesc => '更一致的练习时间可能会改善您的连胜。';

  @override
  String get insightLowAmbientScoreDesc => '最近的练习安静时间较短。尝试更安静的环境。';

  @override
  String get insightNoRecentSessionsDesc => '今天开始练习，养成专注习惯！';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return '干得好！您的练习中有 $minutes 分钟专注时间！ ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return '很好的努力！完成了 $minutes 分钟。';
  }

  @override
  String get sessionCompleteFailed => '练习结束。准备好后再试一次。';

  @override
  String get notificationSessionStarted => '练习开始 - 保持专注！';

  @override
  String get notificationSessionPaused => '练习已暂停';

  @override
  String get notificationSessionResumed => '练习已恢复';
}
