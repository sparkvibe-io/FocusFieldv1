// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Focus Field';

  @override
  String get splashLoading => '集中エンジンを準備中…';

  @override
  String get paywallTitle => 'プレミアムでより深い集中を';

  @override
  String get featureExtendSessions => 'セッションを30分から120分へ拡張';

  @override
  String get featureHistory => '過去90日間の履歴にアクセス';

  @override
  String get featureMetrics => 'パフォーマンス指標とトレンドを解放';

  @override
  String get featureExport => 'セッションデータをエクスポート (CSV / PDF)';

  @override
  String get featureThemes => '全テーマパックを使用';

  @override
  String get featureThreshold => '環境ベースでしきい値を微調整';

  @override
  String get featureSupport => '迅速なサポートと先行アクセス';

  @override
  String get subscribeCta => '続行';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get privacyPolicy => 'プライバシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get manageSubscription => '管理';

  @override
  String get legalDisclaimer => '自動更新サブスクリプション。ストア設定でいつでも解約可能。';

  @override
  String minutesOfSilenceCongrats(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# 分の静けさを達成 ✨',
      one: '# 分の静けさを達成 ✨',
    );
    return '素晴らしい！$_temp0';
  }

  @override
  String get minutes => '分';

  @override
  String get minute => '分';

  @override
  String get exportCsv => 'CSVエクスポート';

  @override
  String get exportPdf => 'PDFエクスポート';

  @override
  String get settings => '設定';

  @override
  String get themes => 'テーマ';

  @override
  String get analytics => '分析';

  @override
  String get history => '履歴';

  @override
  String get startSession => '開始';

  @override
  String get stopSession => '停止';

  @override
  String get pauseSession => '一時停止';

  @override
  String get resumeSession => '再開';

  @override
  String get sessionSaved => 'セッションを保存しました';

  @override
  String get copied => 'コピー済み';

  @override
  String get errorGeneric => '問題が発生しました';

  @override
  String get permissionMicrophoneDenied => 'マイク権限が拒否されました';

  @override
  String get actionRetry => '再試行';

  @override
  String get listeningStatus => '計測中...';

  @override
  String get successPointMessage => '静けさ達成！+1 ポイント';

  @override
  String get tooNoisyMessage => '騒がしすぎます。再試行してください';

  @override
  String get totalPoints => '合計ポイント';

  @override
  String get currentStreak => '現在の連続';

  @override
  String get bestStreak => '最高連続';

  @override
  String get welcomeMessage => '開始を押して静けさの旅を始めましょう';

  @override
  String get resetAllData => 'すべてのデータをリセット';

  @override
  String get resetDataConfirmation => '進捗をすべてリセットしますか？';

  @override
  String get resetDataSuccess => 'データをリセットしました';

  @override
  String get decibelThresholdLabel => 'デシベルしきい値';

  @override
  String get decibelThresholdHint => '許容される最大ノイズレベル (dB) を設定';

  @override
  String get microphonePermissionTitle => 'マイク権限';

  @override
  String get microphonePermissionMessage => 'Focus Field は環境ノイズ測定のためマイクを使用します。音声は保存されません。';

  @override
  String get permissionDeniedMessage => '測定にはマイク権限が必要です。設定で有効にしてください。';

  @override
  String get noiseMeterError => 'マイクにアクセスできません';

  @override
  String get premiumFeaturesTitle => 'プレミアム機能';

  @override
  String get premiumDescription => '延長セッション・高度な分析・エクスポートを解放';

  @override
  String get premiumRequiredMessage => 'この機能はプレミアムが必要です';

  @override
  String get subscriptionSuccessMessage => '購読が完了しました';

  @override
  String get subscriptionErrorMessage => '購読を処理できませんでした';

  @override
  String get restoreSuccessMessage => '購入を復元しました';

  @override
  String get restoreErrorMessage => '購入が見つかりません';

  @override
  String get yearlyPlanTitle => '年額';

  @override
  String get monthlyPlanTitle => '月額';

  @override
  String savePercent(String percent) {
    return '$percent% お得';
  }

  @override
  String billedAnnually(String price) {
    return '年額 $price';
  }

  @override
  String billedMonthly(String price) {
    return '月額 $price';
  }

  @override
  String get mockSubscriptionsBanner => 'モック購読有効';

  @override
  String get splashTagline => '静けさを見つけよう';

  @override
  String get appIconSemantic => 'アプリアイコン';

  @override
  String get tabBasic => '基本';

  @override
  String get tabAdvanced => '詳細';

  @override
  String get tabAbout => '情報';

  @override
  String get resetAllSettings => '全設定をリセット';

  @override
  String get resetAllSettingsDescription => 'すべての設定とデータを初期化します (元に戻せません)';

  @override
  String get cancel => 'キャンセル';

  @override
  String get reset => 'リセット';

  @override
  String get allSettingsReset => '全設定とデータをリセットしました';

  @override
  String get decibelThresholdMaxNoise => 'デシベルしきい値 (最大騒音)';

  @override
  String get highThresholdWarningText => '高いしきい値は重要な音を無視する可能性があります';

  @override
  String get decibelThresholdTooltip => '静かな場所: 30–40 dB 校正後 通常ハムがノイズなら上げる';

  @override
  String get sessionDuration => 'セッション時間';

  @override
  String upgradeForMinutes(int minutes) {
    return '$minutes分にアップグレード';
  }

  @override
  String freeUpToMinutes(int minutes) {
    return '無料: 最大 $minutes 分';
  }

  @override
  String get durationLabel => '時間';

  @override
  String get minutesShort => '分';

  @override
  String get noiseCalibration => 'ノイズ較正';

  @override
  String get calibrateBaseline => 'ベース較正';

  @override
  String get unlockAdvancedCalibration => '高度な較正をアンロック';

  @override
  String get exportData => 'データ書き出し';

  @override
  String get sessionHistory => 'セッション履歴';

  @override
  String get notifications => '通知';

  @override
  String get remindersCelebrations => 'リマインダーと祝福';

  @override
  String get accessibility => 'アクセシビリティ';

  @override
  String get accessibilityFeatures => 'アクセシビリティ機能';

  @override
  String get appInformation => 'アプリ情報';

  @override
  String get version => 'バージョン';

  @override
  String get bundleId => 'バンドルID';

  @override
  String get environment => '環境';

  @override
  String get helpSupport => 'ヘルプとサポート';

  @override
  String get support => 'サポート';

  @override
  String get rateApp => '評価';

  @override
  String errorLoadingSettings(String error) {
    return '設定読み込みエラー: $error';
  }

  @override
  String get exportNoData => '書き出すデータがありません';

  @override
  String chooseExportFormat(int sessions) {
    return '$sessions件のセッション形式を選択:';
  }

  @override
  String get csvSpreadsheet => 'CSVスプレッドシート';

  @override
  String get rawDataForAnalysis => '分析用生データ';

  @override
  String get pdfReport => 'PDFレポート';

  @override
  String get formattedReportWithCharts => 'グラフ付き整形レポート';

  @override
  String generatingExport(String format) {
    return '$format 書き出し生成中...';
  }

  @override
  String exportCompleted(String format) {
    return '$format 書き出し完了';
  }

  @override
  String exportFailed(String error) {
    return '書き出し失敗: $error';
  }

  @override
  String get close => '閉じる';

  @override
  String get supportTitle => 'サポート';

  @override
  String responseTimeLabel(String time) {
    return '応答時間: $time';
  }

  @override
  String get docs => 'ドキュメント';

  @override
  String get contactSupport => 'サポートに連絡';

  @override
  String get emailOpenDescription => 'システム情報付きでメールアプリを開く';

  @override
  String get subject => '件名';

  @override
  String get briefDescription => '概要';

  @override
  String get description => '説明';

  @override
  String get issueDescriptionHint => '問題の詳細を入力...';

  @override
  String get openingEmail => 'メールを開いています...';

  @override
  String get openEmailApp => 'メールアプリを開く';

  @override
  String get fillSubjectDescription => '件名と説明を入力してください';

  @override
  String get emailOpened => 'メールアプリを開きました。準備ができたら送信';

  @override
  String get noEmailAppFound => 'メールアプリが見つかりません 連絡先:';

  @override
  String standardSubject(String subject) {
    return '件名: [STANDARD] $subject';
  }

  @override
  String issueLine(String issue) {
    return '問題: $issue';
  }

  @override
  String failedOpenFaq(String error) {
    return 'FAQ を開けません: $error';
  }

  @override
  String failedOpenDocs(String error) {
    return 'ドキュメントを開けません: $error';
  }

  @override
  String get accessibilitySettings => 'アクセシビリティ設定';

  @override
  String get vibrationFeedback => 'バイブレーション';

  @override
  String get vibrateOnSessionEvents => 'イベント時に振動';

  @override
  String get voiceAnnouncements => '音声案内';

  @override
  String get announceSessionProgress => '進行を案内';

  @override
  String get highContrastMode => 'ハイコントラスト';

  @override
  String get improveVisualAccessibility => '視認性向上';

  @override
  String get largeText => '大きな文字';

  @override
  String get increaseTextSize => '文字サイズ拡大';

  @override
  String get save => '保存';

  @override
  String get accessibilitySettingsSaved => 'アクセシビリティ設定を保存';

  @override
  String get noiseFloorCalibration => 'ノイズフロア較正';

  @override
  String get measuringAmbientNoise => '環境ノイズ測定中 (≈5秒)';

  @override
  String get couldNotReadMic => 'マイクを読み取れません';

  @override
  String get calibrationFailed => '較正失敗';

  @override
  String get retry => '再試行';

  @override
  String previousThreshold(double value) {
    return '以前: $value dB';
  }

  @override
  String newThreshold(double value) {
    return '新しいしきい値: $value dB';
  }

  @override
  String get noSignificantChange => '大きな変化なし';

  @override
  String get highAmbientDetected => '高い環境ノイズ検出';

  @override
  String get adjustAnytimeSettings => '設定でいつでも調整可能';

  @override
  String get toggleThemeTooltip => 'テーマ切替';

  @override
  String get audioChartRecovering => 'オーディオチャート回復中...';

  @override
  String themeChanged(String themeName) {
    return 'テーマ: $themeName';
  }

  @override
  String get privacyComingSoon => 'Privacy policy coming soon.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get startSessionButton => 'Start Session';

  @override
  String get stopSessionButton => 'Stop';

  @override
  String get statusListening => 'Listening...';

  @override
  String get statusSuccess => 'Silence achieved! +1 point';

  @override
  String get statusFailure => 'Too noisy! Try again';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get upgradeRequired => 'アップグレードが必要です';

  @override
  String get exportCsvSpreadsheet => 'CSV Spreadsheet';

  @override
  String get exportPdfReport => 'PDF Report';

  @override
  String get formattedReportCharts => 'Formatted report with charts';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get theme => 'Theme';

  @override
  String get open => 'Open';

  @override
  String get microphone => 'Microphone';

  @override
  String get premium => 'Premium';

  @override
  String get sessions => 'sessions';

  @override
  String get format => 'format';

  @override
  String get successRate => 'Success Rate';

  @override
  String get avgSession => 'Avg Session';

  @override
  String get consistency => 'Consistency';

  @override
  String get bestTime => 'Best Time';

  @override
  String get weeklyTrends => 'Weekly Trends';

  @override
  String get performanceMetrics => 'Performance Metrics';

  @override
  String get advancedAnalytics => 'Advanced Analytics';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String get bucket1to2 => '1-2分';

  @override
  String get bucket3to5 => '3-5分';

  @override
  String get bucket6to10 => '6-10分';

  @override
  String get bucket11to20 => '11-20分';

  @override
  String get bucket21to30 => '21-30分';

  @override
  String get bucket30plus => '30分以上';

  @override
  String get sessionHistoryTitle => 'Session History';

  @override
  String get recentSessionHistory => 'Recent Session History';

  @override
  String get achievementFirstStepTitle => 'First Step';

  @override
  String get achievementFirstStepDesc => 'Completed your first session';

  @override
  String get achievementOnFireTitle => 'On Fire';

  @override
  String get achievementOnFireDesc => '3-day streak achieved';

  @override
  String get achievementWeekWarriorTitle => 'Week Warrior';

  @override
  String get achievementWeekWarriorDesc => '7-day streak achieved';

  @override
  String get achievementDecadeTitle => 'Decade';

  @override
  String get achievementDecadeDesc => '10 points milestone';

  @override
  String get achievementHalfCenturyTitle => 'Half Century';

  @override
  String get achievementHalfCenturyDesc => '50 points milestone';

  @override
  String get achievementLockedPrompt => 'Complete sessions to unlock achievements';

  @override
  String get ratingPromptTitle => 'Focus Field を気に入っていますか?';

  @override
  String get ratingPromptBody => '5つ星の評価は他の人が静かな集中を見つける助けになります。';

  @override
  String get ratingPromptRateNow => '今すぐ評価';

  @override
  String get ratingPromptLater => '後で';

  @override
  String get ratingPromptNoThanks => '結構です';

  @override
  String get ratingThankYou => 'ご支援ありがとうございます！';

  @override
  String get notificationSettingsTitle => '通知設定';

  @override
  String get notificationPermissionRequired => '通知許可が必要です';

  @override
  String get notificationPermissionRationale => 'そっと促し達成を祝う通知を受け取るには有効にしてください。';

  @override
  String get requesting => 'リクエスト中...';

  @override
  String get enableNotificationsCta => '通知を有効にする';

  @override
  String get enableNotificationsTitle => '通知を有効にする';

  @override
  String get enableNotificationsSubtitle => 'Focus Field の通知を許可';

  @override
  String get dailyReminderTitle => 'スマートな毎日のリマインダー';

  @override
  String get dailyReminderSubtitle => 'スマートまたは固定時間';

  @override
  String get dailyTimeLabel => '毎日の時間';

  @override
  String get dailyTimeHint => '固定時間を選ぶかパターン学習に任せましょう。';

  @override
  String get useSmartCta => 'スマートを使う';

  @override
  String get sessionCompletedTitle => 'セッション完了';

  @override
  String get sessionCompletedSubtitle => '完了したセッションを祝う';

  @override
  String get achievementUnlockedTitle => '実績解除';

  @override
  String get achievementUnlockedSubtitle => '節目の通知';

  @override
  String get weeklySummaryTitle => '週間サマリー';

  @override
  String get weeklySummarySubtitle => '週ごとの洞察 (曜日と時間)';

  @override
  String get weeklyTimeLabel => '週間時間';

  @override
  String get notificationPreview => 'プレビュー';

  @override
  String get dailySilenceReminderTitle => '毎日の集中リマインダー';

  @override
  String get weeklyProgressReportTitle => '週間進捗レポート 📊';

  @override
  String get achievementUnlockedGenericTitle => '実績解除! 🏆';

  @override
  String get sessionCompleteSuccessTitle => 'セッション達成! 🎉';

  @override
  String get sessionCompleteEndedTitle => 'セッション終了';

  @override
  String get reminderStartJourney => '🎯 今日から集中力の旅を始めましょう！深い作業習慣を築きましょう。';

  @override
  String get reminderRestart => '🌱 再開しませんか？いつでも集中し直せます。';

  @override
  String get reminderDayTwo => '⭐ 集中連続2日目！継続は集中力を育てます。';

  @override
  String reminderStreakShort(int streak) {
    return '🔥 $streak日間の集中連続！強い習慣が育っています。';
  }

  @override
  String reminderStreakMedium(int streak) {
    return '🏆 $streak日連続すごい！あなたの集中は刺激的です。';
  }

  @override
  String reminderStreakLong(int streak) {
    return '👑 $streak日連続は驚異的！あなたは集中チャンピオンです！';
  }

  @override
  String get achievementFirstSession => '🎉 初回セッション完了！Focus Fieldへようこそ！';

  @override
  String get achievementWeekStreak => '🌟 7日連続達成！継続こそ力。';

  @override
  String get achievementMonthStreak => '🏆 30日連続！止まりません。';

  @override
  String get achievementPerfectSession => '✨ 完璧なセッション！100%穏やかな環境を維持しました！';

  @override
  String get achievementLongSession => '⏰ 長時間セッション達成。集中が深まっています。';

  @override
  String get achievementGeneric => '🎊 実績解除！その調子！';

  @override
  String get weeklyProgressNone => '💭 今週の目標を始めましょう！集中セッションの準備はいいですか？';

  @override
  String weeklyProgressFew(int count) {
    return '🌿 今週 $count 分の集中時間！すべてのセッションがカウントされます。';
  }

  @override
  String weeklyProgressSome(int count) {
    return '🌊 今週 $count 分の集中時間を獲得！リズムができています！';
  }

  @override
  String weeklyProgressPerfect(int count) {
    return '🎯 今週は $count セッションでパーフェクト！素晴らしい継続です。';
  }

  @override
  String get tipsHidden => 'ヒントを非表示にしました';

  @override
  String get tipsShown => 'ヒントを表示しました';

  @override
  String get showTips => 'ヒントを表示';

  @override
  String get hideTips => 'ヒントを非表示';

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
  String get tipInfoTooltip => 'ヒントを表示';

  @override
  String get questCapsuleTitle => 'アンビエントクエスト';

  @override
  String get questCapsuleLoading => '静かな時間を読み込み中…';

  @override
  String questCapsuleProgress(int progress, int goal, int streak) {
    return '静寂 $progress/$goal 分 • ストリーク $streak';
  }

  @override
  String get questFreezeButton => '凍結';

  @override
  String get questFrozenToday => '今日は凍結されました — 保護されています。';

  @override
  String get questGoButton => '移動';

  @override
  String calmPercent(int percent) {
    return '静寂 $percent%';
  }

  @override
  String get calmLabel => '静寂';

  @override
  String get day => '日';

  @override
  String get days => '日';

  @override
  String get freeze => '凍結';

  @override
  String adaptiveThresholdSuggestion(int threshold) {
    return '3勝！ $threshold dBを試す？';
  }

  @override
  String get adaptiveThresholdNotNow => '今はしない';

  @override
  String get adaptiveThresholdTryIt => '試す';

  @override
  String adaptiveThresholdConfirm(int threshold) {
    return 'しきい値を$threshold dBに設定';
  }

  @override
  String get edit => '編集';

  @override
  String get start => '開始';

  @override
  String get error => 'エラー';

  @override
  String errorWithMessage(String message) {
    return 'エラー：$message';
  }
}
