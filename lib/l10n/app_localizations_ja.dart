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
  String get microphonePermissionMessage => 'Focus Fieldは、静かな環境を維持するために周囲の音レベルを測定します。\n\nアプリは沈黙を検出するためにマイクアクセスを必要としますが、音声は録音しません。';

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
  String get notificationPreview => '通知プレビュー';

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
  String get tip01 => '小さく始めよう—2分でも集中習慣を築けます。';

  @override
  String get tip02 => 'ストリークには猶予があります—2日ルールで1回のミスでは切れません。';

  @override
  String get tip03 => '学習、読書、瞑想のアクティビティを試して、集中スタイルに合わせましょう。';

  @override
  String get tip04 => '12週間のヒートマップをチェックして、小さな勝利がどう積み重なるか見てみましょう。';

  @override
  String get tip05 => 'セッション中のリアルタイム静寂%を見る—高いスコアはより良い集中を意味します！';

  @override
  String get tip06 => '日々の目標（10〜60分）をリズムに合わせてカスタマイズしましょう。';

  @override
  String get tip07 => '月1回のフリーズトークンを使って、厳しい日のストリークを守りましょう。';

  @override
  String get tip08 => '3回勝利の後、より厳しいしきい値を提案します—レベルアップの準備はできていますか？';

  @override
  String get tip09 => '周囲の騒音が高い？しきい値を上げてゾーンに留まりましょう。';

  @override
  String get tip10 => 'スマート毎日リマインダーはあなたの最適な時間を学習します—ガイドさせましょう。';

  @override
  String get tip11 => '進捗リングはタップ可能—1タップで集中セッションを開始します。';

  @override
  String get tip12 => '環境が変わったら再調整して精度を上げましょう。';

  @override
  String get tip13 => 'セッション通知は勝利を祝います—モチベーションのために有効にしましょう！';

  @override
  String get tip14 => '一貫性は完璧さに勝ります—忙しい日でも現れましょう。';

  @override
  String get tip15 => '一日の異なる時間を試して、静かなスイートスポットを発見しましょう。';

  @override
  String get tip16 => '日々の進捗は常に表示されます—いつでもタップして開始できます。';

  @override
  String get tip17 => '各アクティビティは個別に目標に向かって追跡されます—バラエティが新鮮さを保ちます。';

  @override
  String get tip18 => 'データをエクスポート（プレミアム）して完全な集中の旅を見ましょう。';

  @override
  String get tip19 => '紙吹雪が全ての完了を祝います—小さな勝利は認識に値します！';

  @override
  String get tip20 => 'ベースラインが重要です—新しい空間に移動するときは調整しましょう。';

  @override
  String get tip21 => '7日間のトレンドがパターンを明らかにします—洞察のために毎週チェックしましょう。';

  @override
  String get tip22 => 'セッション時間をアップグレード（プレミアム）してより長い集中ブロックを。';

  @override
  String get tip23 => '集中は練習です—小さなセッションがあなたが望む習慣を築きます。';

  @override
  String get tip24 => '週次サマリーがリズムを示します—スケジュールに合わせて調整しましょう。';

  @override
  String get tip25 => '空間に合わせてしきい値を微調整—すべての部屋は異なります。';

  @override
  String get tip26 => 'アクセシビリティオプションは誰もが集中するのを助けます—高コントラスト、大きいテキスト、振動。';

  @override
  String get tip27 => '今日のタイムラインは集中した時間を表示—生産的な時間を見つけましょう。';

  @override
  String get tip28 => '始めたことを終わらせる—短いセッションはより多くの完了を意味します。';

  @override
  String get tip29 => '静かな分が目標に向かって積み上がります—完璧さより進歩を。';

  @override
  String get tip30 => '1タップの距離です—今すぐ小さなセッションを開始しましょう。';

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
  String get tipInstructionHeatmap => '概要タブ → 詳細を表示 → ヒートマップ';

  @override
  String get tipInstructionTodayTimeline => '概要タブ → 詳細を表示 → 今日のタイムライン';

  @override
  String get tipInstruction7DayTrends => '概要タブ → 詳細を表示 → 7日間のトレンド';

  @override
  String get tipInstructionEditActivities => 'アクティビティタブ → 編集をタップしてアクティビティを表示/非表示';

  @override
  String get tipInstructionQuestGo => 'アクティビティタブ → クエストカプセル → Goをタップ';

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

  @override
  String get faqTitle => 'よくある質問';

  @override
  String get faqSearchHint => '質問を検索...';

  @override
  String get faqNoResults => '結果が見つかりません';

  @override
  String get faqNoResultsSubtitle => '別の検索用語をお試しください';

  @override
  String faqResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の結果が見つかりました',
      one: '1件の結果が見つかりました',
    );
    return '$_temp0';
  }

  @override
  String get faqQ01 => 'Focus Fieldとは何ですか？集中力を高めるにはどう役立ちますか？';

  @override
  String get faqA01 => 'Focus Fieldは、環境内の周囲ノイズを監視することで、より良い集中習慣の構築を支援します。セッション（学習、読書、瞑想、その他）を開始すると、アプリは環境の静かさを測定します。静かに保つほど、より多くの「集中分」を獲得できます。これにより、深い作業のための気を散らさない空間を見つけ、維持することが促されます。';

  @override
  String get faqQ02 => 'Focus Fieldはどのように集中力を測定しますか？';

  @override
  String get faqA02 => 'Focus Fieldは、セッション中の環境内の周囲ノイズレベルを監視します。選択したノイズ閾値を下回る秒数を追跡することで「アンビエントスコア」を計算します。セッションに少なくとも70%の静かな時間がある場合（アンビエントスコア≥70%）、これらの静かな分に対して完全なクレジットを獲得します。';

  @override
  String get faqQ03 => 'Focus Fieldは音声や会話を録音しますか？';

  @override
  String get faqA03 => 'いいえ、絶対にしません。Focus Fieldはデシベルレベル（音量）のみを測定します - 音声を録音、保存、送信することは一切ありません。プライバシーは完全に保護されています。アプリは単に環境が選択した閾値を上回っているか下回っているかをチェックするだけです。';

  @override
  String get faqQ04 => 'Focus Fieldではどのような活動を追跡できますか？';

  @override
  String get faqA04 => 'Focus Fieldには4つの活動タイプがあります：学習📚（学習と研究用）、読書📖（集中した読書用）、瞑想🧘（マインドフルネス実践用）、その他⭐（集中を必要とする活動用）。すべての活動は、静かで集中した環境を維持するのに役立つ周囲ノイズ監視を使用します。';

  @override
  String get faqQ05 => 'すべての活動にFocus Fieldを使用すべきですか？';

  @override
  String get faqA05 => 'Focus Fieldは、周囲ノイズが集中レベルを示す活動に最適です。学習、読書、瞑想などの活動は、静かな環境から最も恩恵を受けます。「その他」の活動を追跡することもできますが、主にノイズに敏感な集中作業にFocus Fieldを使用することをお勧めします。';

  @override
  String get faqQ06 => '集中セッションを開始するには？';

  @override
  String get faqA06 => 'セッションタブに移動し、活動（学習、読書、瞑想、その他）を選択し、セッション期間（1、5、10、15、30分、またはプレミアムオプション）を選択し、進行リング上の開始ボタンをタップして、環境を静かに保ちます！';

  @override
  String get faqQ07 => '利用可能なセッション期間は？';

  @override
  String get faqA07 => '無料ユーザーは選択できます：1、5、10、15、または30分セッション。プレミアムユーザーは、より長い深い作業期間のための1時間、1.5時間、2時間の延長セッションも利用できます。';

  @override
  String get faqQ08 => 'セッションを一時停止または早期に停止できますか？';

  @override
  String get faqA08 => 'はい！セッション中、進行リングの上に一時停止と停止ボタンが表示されます。誤タップを防ぐため、これらのボタンを長押しする必要があります。早期に停止しても、蓄積した静かな分のポイントは獲得できます。';

  @override
  String get faqQ09 => 'Focus Fieldでポイントを獲得するには？';

  @override
  String get faqA09 => '静かな分ごとに1ポイントを獲得します。セッション中、Focus Fieldは環境がノイズ閾値を下回る秒数を追跡します。最後に、これらの静かな秒が分に変換されます。例えば、8分間の静かな時間で10分セッションを完了すると、8ポイントを獲得します。';

  @override
  String get faqQ10 => '70%閾値とは何ですか？なぜ重要ですか？';

  @override
  String get faqA10 => '70%閾値は、セッションが毎日の目標にカウントされるかどうかを決定します。アンビエントスコア（静かな時間÷合計時間）が少なくとも70%の場合、セッションはクエストクレジットの資格があります。70%未満でも、毎分の静かな時間のポイントは獲得できます！';

  @override
  String get faqQ11 => 'アンビエントスコアとポイントの違いは何ですか？';

  @override
  String get faqA11 => 'アンビエントスコアは、70%閾値に達したかどうかを決定するセッションの品質のパーセンテージ（静かな秒÷合計秒）です。ポイントは獲得した実際の静かな分です（1ポイント＝1分）。アンビエントスコア＝品質、ポイント＝達成。';

  @override
  String get faqQ12 => 'Focus Fieldのストリークはどのように機能しますか？';

  @override
  String get faqA12 => 'ストリークは、毎日の目標を達成した連続した日数を追跡します。Focus Fieldは思いやりのある2日間ルールを使用：2日間連続して逃した場合にのみストリークが壊れます。これは、1日逃しても、翌日に目標を完了すればストリークが続くことを意味します。';

  @override
  String get faqQ13 => 'フリーズトークンとは何ですか？どのように使用しますか？';

  @override
  String get faqA13 => 'フリーズトークンは、目標を完了できないときにストリークを保護します。毎月1つの無料フリーズトークンを受け取ります。使用すると、全体的な進行状況は100%（目標保護）を示し、ストリークは安全で、個々の活動追跡は通常通り続きます。忙しい日のために賢く使用してください！';

  @override
  String get faqQ14 => '毎日の集中目標をカスタマイズできますか？';

  @override
  String get faqA14 => 'はい！今日タブのセッションカードで編集をタップします。グローバル毎日目標を設定し（無料10-60分、プレミアム最大1080分）、個別ターゲットのためのアクティビティごとの目標を有効にし、特定のアクティビティを表示/非表示にできます。';

  @override
  String get faqQ15 => 'ノイズ閾値とは何ですか？どのように調整しますか？';

  @override
  String get faqA15 => '閾値は「静か」とカウントされる最大ノイズレベル（デシベル）です。デフォルトは40 dB（図書館の静けさ）です。セッションタブで調整できます：30 dB（非常に静か）、40 dB（図書館の静けさ - 推奨）、50 dB（適度なオフィス）、60-80 dB（より騒がしい環境）。';

  @override
  String get faqQ16 => '適応閾値とは何ですか？使用すべきですか？';

  @override
  String get faqA16 => '現在の閾値で3回連続成功したセッションの後、Focus Fieldは挑戦するために2 dB増加することを提案します。これにより、徐々に改善するのに役立ちます。提案を受け入れるか却下できます - 7日ごとに1回だけ表示されます。';

  @override
  String get faqQ17 => 'フォーカスモードとは何ですか？';

  @override
  String get faqA17 => 'フォーカスモードは、セッション中の気を散らさないフルスクリーンオーバーレイです。カウントダウンタイマー、ライブの静かなパーセンテージ、最小限のコントロール（長押しで一時停止/停止）を表示します。完全に集中できるように他のすべてのUI要素を削除します。設定>基本>フォーカスモードで有効にします。';

  @override
  String get faqQ18 => 'Focus Fieldがマイク許可を必要とするのはなぜですか？';

  @override
  String get faqA18 => 'Focus Fieldは、セッション中に周囲ノイズレベル（デシベル）を測定するためにデバイスのマイクを使用します。これはアンビエントスコアを計算するために不可欠です。覚えておいてください：音声は決して録音されません - ノイズレベルのみがリアルタイムで測定されます。';

  @override
  String get faqQ19 => '時間の経過とともに集中パターンを見ることができますか？';

  @override
  String get faqA19 => 'はい！今日タブには、毎日の進行状況、週次トレンド、12週間のアクティビティヒートマップ（GitHubコントリビューションのような）、セッションタイムラインが表示されます。プレミアムユーザーは、パフォーマンスメトリクス、移動平均、AI搭載のインサイトを備えた高度な分析を取得します。';

  @override
  String get faqQ20 => 'Focus Fieldで通知はどのように機能しますか？';

  @override
  String get faqA20 => 'Focus Fieldにはスマートリマインダーがあります：毎日のリマインダー（好みの集中時間を学習するか固定時間を使用）、結果付きのセッション完了通知、マイルストーンの達成通知、週次サマリー（プレミアム）。設定>詳細>通知で有効化/カスタマイズします。';

  @override
  String get microphoneSettingsTitle => '設定が必要です';

  @override
  String get microphoneSettingsMessage => '沈黙検出を有効にするには、マイクの許可を手動で付与してください:\n\n• iOS: 設定 > プライバシーとセキュリティ > マイク > Focus Field\n• Android: 設定 > アプリ > Focus Field > 権限 > マイク';

  @override
  String get buttonGrantPermission => '許可を与える';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonOpenSettings => '設定を開く';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingGetStarted => '始める';

  @override
  String get onboardingWelcomeSnackbar => 'ようこそ！最初のセッションを開始する準備はできていますか？ 🚀';

  @override
  String get onboardingWelcomeTitle => 'Focus Fieldへ\nようこそ！ 🎯';

  @override
  String get onboardingWelcomeSubtitle => 'より良い集中への旅がここから始まります！\n続く習慣を作りましょう 💪';

  @override
  String get onboardingFeatureTrackTitle => 'フォーカスを追跡';

  @override
  String get onboardingFeatureTrackDesc => '集中力スーパーパワーを構築しながら、リアルタイムで進捗を確認しましょう！ 📊';

  @override
  String get onboardingFeatureRewardsTitle => '報酬を獲得';

  @override
  String get onboardingFeatureRewardsDesc => '静かな分ごとにカウントされます！ポイントを集めて勝利を祝いましょう 🏆';

  @override
  String get onboardingFeatureStreaksTitle => 'ストリークを構築';

  @override
  String get onboardingFeatureStreaksDesc => '勢いを維持しましょう！私たちの思いやりのあるシステムがあなたをモチベートし続けます 🔥';

  @override
  String get onboardingEnvironmentTitle => 'あなたのフォーカスゾーンはどこ？ 🎯';

  @override
  String get onboardingEnvironmentSubtitle => 'あなたのスペースを最適化できるように、典型的な環境を選択してください！';

  @override
  String get onboardingEnvQuietHomeTitle => '静かな自宅';

  @override
  String get onboardingEnvQuietHomeDesc => '寝室、静かなホームオフィス';

  @override
  String get onboardingEnvQuietHomeDb => '30 dB - 非常に静か';

  @override
  String get onboardingEnvOfficeTitle => '典型的なオフィス';

  @override
  String get onboardingEnvOfficeDesc => '標準的なオフィス、図書館';

  @override
  String get onboardingEnvOfficeDb => '40 dB - 図書館の静けさ（推奨）';

  @override
  String get onboardingEnvBusyTitle => '忙しいスペース';

  @override
  String get onboardingEnvBusyDesc => 'カフェ、共有ワークスペース';

  @override
  String get onboardingEnvBusyDb => '50 dB - 中程度のノイズ';

  @override
  String get onboardingEnvNoisyTitle => '騒がしい環境';

  @override
  String get onboardingEnvNoisyDesc => 'オープンオフィス、公共スペース';

  @override
  String get onboardingEnvNoisyDb => '60 dB - より高いノイズ';

  @override
  String get onboardingEnvAdjustNote => '設定でいつでも調整できます';

  @override
  String get onboardingGoalTitle => '毎日の目標を設定しましょう！ 🎯';

  @override
  String get onboardingGoalSubtitle => 'どのくらいの集中時間があなたに適していますか？\n（いつでも調整できます！）';

  @override
  String get onboardingGoalStartingTitle => 'スタート';

  @override
  String get onboardingGoalStartingDuration => '10-15分';

  @override
  String get onboardingGoalHabitTitle => '習慣を作る';

  @override
  String get onboardingGoalHabitDuration => '20-30分';

  @override
  String get onboardingGoalPracticeTitle => '定期的な練習';

  @override
  String get onboardingGoalPracticeDuration => '40-60分';

  @override
  String get onboardingGoalDeepWorkTitle => '深い作業';

  @override
  String get onboardingGoalDeepWorkDuration => '60分以上';

  @override
  String get onboardingGoalAdvice1 => '完璧なスタート！ 🌟 小さな一歩が大きな勝利につながります。あなたならできます！';

  @override
  String get onboardingGoalAdvice2 => '素晴らしい選択！ 🎯 このスイートスポットが永続的な習慣を構築します！';

  @override
  String get onboardingGoalAdvice3 => '野心的！ 💪 集中力ゲームをレベルアップする準備ができています！';

  @override
  String get onboardingGoalAdvice4 => 'すごい！ 🏆 深い作業モード起動！休憩を忘れずに！';

  @override
  String get onboardingActivitiesTitle => 'アクティビティを選択しましょう！ ✨';

  @override
  String get onboardingActivitiesSubtitle => 'あなたに共鳴するものをすべて選んでください！\n（後でいつでも追加できます）';

  @override
  String get onboardingActivityStudyTitle => '学習';

  @override
  String get onboardingActivityStudyDesc => '学習、コースワーク、研究';

  @override
  String get onboardingActivityReadingTitle => '読書';

  @override
  String get onboardingActivityReadingDesc => '深い読書、記事、本';

  @override
  String get onboardingActivityMeditationTitle => '瞑想';

  @override
  String get onboardingActivityMeditationDesc => 'マインドフルネス、呼吸法';

  @override
  String get onboardingActivityOtherTitle => 'その他';

  @override
  String get onboardingActivityOtherDesc => '集中を必要とする活動';

  @override
  String get onboardingActivitiesTip => 'プロのヒント：Focus Fieldは静寂=集中のときに輝きます！ 🤫✨';

  @override
  String get onboardingPermissionTitle => 'あなたのプライバシーは重要です！ 🔒';

  @override
  String get onboardingPermissionSubtitle => '周囲のノイズを測定し、より良い集中を支援するためにマイクアクセスが必要です';

  @override
  String get onboardingPrivacyNoRecordingTitle => '録音なし';

  @override
  String get onboardingPrivacyNoRecordingDesc => 'ノイズレベルのみを測定し、音声を録音することはありません';

  @override
  String get onboardingPrivacyLocalTitle => 'ローカルのみ';

  @override
  String get onboardingPrivacyLocalDesc => 'すべてのデータはデバイスに保存されます';

  @override
  String get onboardingPrivacyFirstTitle => 'プライバシー第一';

  @override
  String get onboardingPrivacyFirstDesc => 'あなたの会話は完全にプライベートです';

  @override
  String get onboardingPermissionNote => '最初のセッションを開始するときに次の画面で許可を与えることができます';

  @override
  String get onboardingTipsTitle => '成功のためのプロのヒント！ 💡';

  @override
  String get onboardingTipsSubtitle => 'これらはFocus Fieldを最大限に活用するのに役立ちます！';

  @override
  String get onboardingTip1Title => '小さく始めて、大きく勝つ！ 🌱';

  @override
  String get onboardingTip1Desc => '5-10分のセッションから始めましょう。一貫性が完璧さに勝ります！';

  @override
  String get onboardingTip2Title => 'フォーカスモードを有効にする！ 🎯';

  @override
  String get onboardingTip2Desc => '没入型の気を散らさない体験のためにフォーカスモードをタップします。';

  @override
  String get onboardingTip3Title => 'フリーズトークン = セーフティネット！ ❄️';

  @override
  String get onboardingTip3Desc => '忙しい日に月1回のトークンを使用してストリークを保護します。';

  @override
  String get onboardingTip4Title => '70%ルールが素晴らしい！ 📈';

  @override
  String get onboardingTip4Desc => '70%の静かな時間を目指しましょう - 完璧な静寂は必要ありません！';

  @override
  String get onboardingReadyTitle => '準備完了！ 🚀';

  @override
  String get onboardingReadyDesc => '最初のセッションを開始して、素晴らしい習慣を作りましょう！';

  @override
  String get questMotivation1 => '成功は終わらず、失敗は決して最終的ではない';

  @override
  String get questMotivation2 => '完璧よりも進歩 - 毎分が大切です';

  @override
  String get questMotivation3 => '毎日の小さな一歩が大きな変化につながる';

  @override
  String get questMotivation4 => 'より良い習慣を築いています、一度に一つのセッション';

  @override
  String get questMotivation5 => '一貫性は強度に勝る';

  @override
  String get questMotivation6 => 'どんなに短くても、すべてのセッションは勝利です';

  @override
  String get questMotivation7 => '集中力は筋肉です - あなたは強くなっています';

  @override
  String get questMotivation8 => '千里の道も一歩から';

  @override
  String get questGo => '行く';

  @override
  String get todayDashboardTitle => 'あなたのフォーカスダッシュボード';

  @override
  String get todayFocusMinutes => '今日の集中分';

  @override
  String todayGoalCalm(int goalMinutes, int calmPercent) {
    return '目標: $goalMinutes分 • 静か ≥$calmPercent%';
  }

  @override
  String get todayPickMode => 'モードを選択';

  @override
  String get todayDefaultActivities => '学習 • 読書 • 瞑想';

  @override
  String get todayTooltipTips => 'ヒント';

  @override
  String get todayTooltipTheme => 'テーマ';

  @override
  String get todayTooltipSettings => '設定';

  @override
  String todayThemeChanged(String themeName) {
    return 'テーマを$themeNameに変更しました';
  }

  @override
  String get todayTabToday => '今日';

  @override
  String get todayTabSessions => 'セッション';

  @override
  String get todayHelperText => '期間を設定し、時間を追跡します。セッション履歴と分析は概要に表示されます。';

  @override
  String get statPoints => 'ポイント';

  @override
  String get statStreak => 'ストリーク';

  @override
  String get statSessions => 'セッション';

  @override
  String get ringProgressTitle => 'リングの進捗';

  @override
  String get ringOverall => '全体';

  @override
  String get ringOverallFrozen => '全体 ❄️';

  @override
  String get sessionCalm => '静か';

  @override
  String get sessionStart => '開始';

  @override
  String get sessionStop => '停止';

  @override
  String get buttonEdit => '編集';

  @override
  String get durationUpTo1Hour => '最大1時間のセッション';

  @override
  String get durationUpTo1_5Hours => '最大1.5時間のセッション';

  @override
  String get durationUpTo2Hours => '最大2時間のセッション';

  @override
  String get durationExtended => '延長セッション期間';

  @override
  String get durationExtendedAccess => '延長セッションへのアクセス';

  @override
  String get noiseRoomLoudness => '部屋の音量';

  @override
  String noiseThresholdLabel(int threshold) {
    return 'しきい値: ${threshold}dB';
  }

  @override
  String noiseThresholdSet(int db) {
    return 'しきい値を$db dBに設定しました';
  }

  @override
  String get noiseHighDetected => '高い騒音が検出されました。より良い集中のために静かな部屋に移動してください';

  @override
  String get noiseThresholdExceededHint => 'より静かな部屋を見つけるか、しきい値を上げる →';

  @override
  String noiseExceededIncreasePrompt(int db) {
    return 'より静かな部屋を探すか、${db}dBに上げますか？';
  }

  @override
  String noiseHighIncreasePrompt(int db) {
    return '高いノイズが検出されました。${db}dBに上げますか？';
  }

  @override
  String get noiseAtMaxThreshold => 'すでに最大しきい値です。より静かな部屋を見つけてください。';

  @override
  String get noiseThresholdYes => 'はい';

  @override
  String get noiseThresholdNo => 'いいえ';

  @override
  String get trendsInsights => '洞察';

  @override
  String get trendsLast7Days => '過去7日間';

  @override
  String get trendsShareWeeklySummary => '週間サマリーを共有';

  @override
  String get trendsLoading => '読み込み中...';

  @override
  String get trendsLoadingMetrics => 'メトリクスを読み込み中...';

  @override
  String get trendsNoData => 'データなし';

  @override
  String get trendsWeeklyTotal => '週間合計';

  @override
  String get trendsBestDay => '最良の日';

  @override
  String get trendsActivityHeatmap => 'アクティビティヒートマップ';

  @override
  String get trendsRecentActivity => '最近のアクティビティ';

  @override
  String get trendsHeatmapError => 'ヒートマップを読み込めません';

  @override
  String get dayMon => '月';

  @override
  String get dayTue => '火';

  @override
  String get dayWed => '水';

  @override
  String get dayThu => '木';

  @override
  String get dayFri => '金';

  @override
  String get daySat => '土';

  @override
  String get daySun => '日';

  @override
  String get focusModeComplete => 'セッション完了！';

  @override
  String get focusModeGreatSession => '素晴らしい集中セッション';

  @override
  String get focusModeResume => '再開';

  @override
  String get focusModePause => '一時停止';

  @override
  String get focusModeLongPressHint => '長押しして一時停止または停止';

  @override
  String get activityEditTitle => 'アクティビティを編集';

  @override
  String get activityRecommendation => '推奨: 一貫した習慣形成のために1つのアクティビティあたり10分以上';

  @override
  String get activityDailyGoals => '毎日の目標';

  @override
  String activityTotalHours(String hours) {
    return '合計: ${hours}h / 18h';
  }

  @override
  String get activityPerActivity => 'アクティビティごと';

  @override
  String get activityExceedsLimit => '合計が1日の18時間制限を超えています。目標を減らしてください。';

  @override
  String get activityGoalLabel => '目標';

  @override
  String get activityGoalDescription => '毎日の集中目標を設定（1分〜18時間）';

  @override
  String get shareYourProgress => '進捗を共有';

  @override
  String get shareTimeRange => '時間範囲';

  @override
  String get shareCardSize => 'カードサイズ';

  @override
  String get analyticsPerformanceMetrics => 'パフォーマンス指標';

  @override
  String get analyticsPreferredDuration => '優先期間';

  @override
  String get analyticsUnavailable => '分析は利用できません';

  @override
  String get analyticsRestoreAttempt => '次のアプリ起動時にこのセクションを復元しようとします。';

  @override
  String get audioUnavailable => 'オーディオは一時的に利用できません';

  @override
  String get audioRecovering => 'オーディオ処理で問題が発生しました。自動的に回復しています...';

  @override
  String get shareQuietMinutes => '静かな分';

  @override
  String get shareTopActivity => 'トップアクティビティ';

  @override
  String get appName => 'Focus Field';

  @override
  String get sharePreview => 'プレビュー';

  @override
  String get sharePinchToZoom => 'ピンチしてズーム';

  @override
  String get shareGenerating => '生成中...';

  @override
  String get shareButton => '共有';

  @override
  String get shareTodayLabel => '今日';

  @override
  String get shareWeeklyLabel => '週間';

  @override
  String get shareTodayTitle => '今日のフォーカス';

  @override
  String get shareWeeklyTitle => '今週のフォーカス';

  @override
  String get shareSubject => 'Focus Fieldの進捗';

  @override
  String get shareFormatSquare => '1:1比率 • 汎用互換性';

  @override
  String get shareFormatPost => '4:5比率 • Instagram/Twitter投稿';

  @override
  String get shareFormatStory => '9:16比率 • Instagramストーリー';

  @override
  String get recapWeeklyTitle => '週間まとめ';

  @override
  String get recapMinutes => '分';

  @override
  String recapStreak(int start, int end) {
    return '連続記録: $start → $end 日';
  }

  @override
  String get recapTopActivity => 'トップアクティビティ: ';

  @override
  String get practiceOverviewTitle => '練習の概要';

  @override
  String get practiceLast7Days => '過去7日間';

  @override
  String get audioMultipleErrors => '複数のオーディオエラーが検出されました。コンポーネントを復旧しています...';

  @override
  String activityCurrentGoal(String goal) {
    return '現在の目標: $goal';
  }

  @override
  String get activitySaveChanges => '変更を保存';

  @override
  String get insightsTitle => 'インサイト';

  @override
  String get insightsTooltip => '詳細なインサイトを表示';

  @override
  String get statDays => '日';

  @override
  String sessionsTotalToday(int done, int goal) {
    return '今日の合計 $done/$goal 分、任意のアクティビティを選択';
  }

  @override
  String get premiumFeature => 'プレミアム機能';

  @override
  String get premiumFeatureAccess => 'プレミアム機能アクセス';

  @override
  String get activityUnknown => '不明';

  @override
  String get insightsFirstSessionTitle => '最初のセッションを完了する';

  @override
  String get insightsFirstSessionSubtitle => '集中時間、セッションパターン、アンビエントスコアのトレンドを追跡し始めます';

  @override
  String sessionAmbientLabel(int percent) {
    return 'アンビエント：$percent%';
  }

  @override
  String get sessionSuccess => '成功';

  @override
  String get sessionFailed => '失敗';

  @override
  String get focusModeButton => 'フォーカスモード';

  @override
  String get settingsDailyGoalsTitle => '毎日の目標';

  @override
  String get settingsFocusModeDescription => 'セッション中に集中オーバーレイで気を散らすものを最小限に抑えます';

  @override
  String get settingsDeepFocusTitle => 'ディープフォーカス';

  @override
  String get settingsDeepFocusDescription => 'アプリが離れるとセッションを終了';

  @override
  String get deepFocusDialogTitle => 'ディープフォーカス';

  @override
  String get deepFocusEnableLabel => 'ディープフォーカスを有効にする';

  @override
  String get deepFocusGracePeriodLabel => '猶予期間（秒）';

  @override
  String get deepFocusExplanation => '有効にすると、アプリを離れると猶予期間後にセッションが終了します。';

  @override
  String get notificationPermissionTitle => '通知を有効にする';

  @override
  String get notificationPermissionExplanation => 'Focus Fieldは通知権限が必要です：';

  @override
  String get notificationBenefitReminders => '毎日の集中リマインダー';

  @override
  String get notificationBenefitCompletion => 'セッション完了アラート';

  @override
  String get notificationBenefitAchievements => '達成の祝福';

  @override
  String get notificationHowToEnableIos => 'iOSで有効にする方法：';

  @override
  String get notificationHowToEnableAndroid => 'Androidで有効にする方法：';

  @override
  String get notificationStepsIos => '1. 下の「設定を開く」をタップ\n2. 「通知」をタップ\n3. 「通知を許可」を有効にする';

  @override
  String get notificationStepsAndroid => '1. 下の「設定を開く」をタップ\n2. 「通知」をタップ\n3. 「すべてのFocus Field通知」を有効にする';

  @override
  String get aboutShowTips => 'ヒントを表示';

  @override
  String get aboutShowTipsDescription => 'アプリ起動時と電球アイコンから役立つヒントを表示します。ヒントは2〜3日ごとに表示されます。';

  @override
  String get aboutReplayOnboarding => 'オンボーディングを再生';

  @override
  String get aboutReplayOnboardingDescription => 'アプリツアーを確認し、設定を再度セットアップします';

  @override
  String get buttonFaq => 'よくある質問';

  @override
  String get onboardingWelcomeMessage => 'ようこそ！最初のセッションを始める準備はできましたか？ 🚀';

  @override
  String get onboardingFeatureEarnTitle => '報酬を獲得';

  @override
  String get onboardingFeatureEarnDesc => '静かな1分1分が大切！ポイントを集めて勝利を祝いましょう 🏆';

  @override
  String get onboardingFeatureBuildTitle => 'ストリークを構築';

  @override
  String get onboardingFeatureBuildDesc => '勢いを維持しましょう！思いやりのあるシステムがあなたをやる気にさせます 🔥';

  @override
  String get onboardingEnvironmentDescription => 'あなたの典型的な環境を選択して、スペースを最適化しましょう！';

  @override
  String get onboardingEnvQuietHome => '静かな家';

  @override
  String get onboardingEnvQuietHomeLevel => '30 dB - とても静か';

  @override
  String get onboardingEnvOffice => '典型的なオフィス';

  @override
  String get onboardingEnvOfficeLevel => '40 dB - 図書館の静けさ（推奨）';

  @override
  String get onboardingEnvBusy => '忙しいスペース';

  @override
  String get onboardingEnvBusyLevel => '50 dB - 中程度の騒音';

  @override
  String get onboardingEnvNoisy => '騒がしい環境';

  @override
  String get onboardingEnvNoisyLevel => '60 dB - より高い騒音';

  @override
  String get onboardingAdjustAnytime => 'これはいつでも設定で調整できます';

  @override
  String get buttonGetStarted => '始める';

  @override
  String get buttonNext => '次へ';

  @override
  String get errorActivityRequired => '⚠️ 少なくとも1つのアクティビティを有効にする必要があります';

  @override
  String get errorGoalExceeds => '合計目標が1日18時間の制限を超えています。目標を減らしてください。';

  @override
  String get messageSaved => '設定が保存されました';

  @override
  String get errorPermissionRequired => '権限が必要です';

  @override
  String get notificationEnableReason => 'リマインダーを受け取り、達成を祝うために通知を有効にしてください。';

  @override
  String get buttonEnableNotifications => '通知を有効にする';

  @override
  String get buttonRequesting => 'リクエスト中...';

  @override
  String get notificationDailyTime => '毎日の時間';

  @override
  String notificationDailyReminderSet(String time) {
    return '$timeに毎日のリマインダー';
  }

  @override
  String get notificationLearning => '学習中';

  @override
  String notificationSmart(String time) {
    return 'スマート（$time）';
  }

  @override
  String get buttonUseSmart => 'スマートを使用';

  @override
  String get notificationSmartExplanation => '固定時間を選択するか、Focus Fieldにパターンを学習させてください。';

  @override
  String get notificationSessionComplete => 'セッション完了';

  @override
  String get notificationSessionCompleteDesc => '完了したセッションを祝う';

  @override
  String get notificationAchievement => '達成アンロック';

  @override
  String get notificationAchievementDesc => 'マイルストーン通知';

  @override
  String get notificationWeekly => '週次進捗サマリー';

  @override
  String get notificationWeeklyDesc => '週次インサイト（曜日と時間）';

  @override
  String get notificationWeeklyTime => '週次時間';

  @override
  String get notificationMilestone => 'マイルストーン通知';

  @override
  String get notificationWeeklyInsights => '週次インサイト（曜日と時刻）';

  @override
  String get notificationDailyReminder => '毎日のリマインダー';

  @override
  String get notificationComplete => 'セッション完了';

  @override
  String get settingsSnackbar => 'デバイス設定で通知を有効にしてください';

  @override
  String get shareCardTitle => 'カードを共有';

  @override
  String get shareYourWeek => 'あなたの週を共有';

  @override
  String get shareStyleGradient => 'グラデーションスタイル';

  @override
  String get shareStyleGradientDesc => '大きな数字の大胆なグラデーション';

  @override
  String get shareWeeklySummary => '週次サマリー';

  @override
  String get shareStyleAchievement => '達成スタイル';

  @override
  String get shareStyleAchievementDesc => '合計静寂分数に焦点を当てる';

  @override
  String get shareQuietMinutesWeek => '今週の静寂分数';

  @override
  String get shareAchievementMessage => 'より深い集中を構築、\\n一度に一つのセッション';

  @override
  String get shareAchievementCard => '達成カード';

  @override
  String get shareTextOnly => 'テキストのみ';

  @override
  String get shareTextOnlyDesc => 'プレーンテキストとして共有（画像なし）';

  @override
  String get shareYourStreak => 'あなたのストリークを共有';

  @override
  String get shareAsCard => 'カードとして共有';

  @override
  String get shareAsCardDesc => '美しいビジュアルカード';

  @override
  String get shareStreakCard => 'ストリークカード';

  @override
  String get shareAsText => 'テキストとして共有';

  @override
  String get shareAsTextDesc => 'シンプルなテキストメッセージ';

  @override
  String get shareErrorFailed => '共有に失敗しました。もう一度お試しください。';

  @override
  String get buttonShare => '共有';

  @override
  String get initializingApp => 'アプリを初期化中...';

  @override
  String initializationFailed(String error) {
    return '初期化に失敗しました: $error';
  }

  @override
  String get loadingSettings => '設定を読み込み中...';

  @override
  String settingsLoadingFailed(String error) {
    return '設定の読み込みに失敗しました: $error';
  }

  @override
  String get loadingUserData => 'ユーザーデータを読み込み中...';

  @override
  String dataLoadingFailed(String error) {
    return 'データの読み込みに失敗しました: $error';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get taglineSilence => '🤫 沈黙の芸術をマスター';

  @override
  String get errorOops => 'おっと！問題が発生しました';

  @override
  String get buttonRetry => '再試行';

  @override
  String get resetAppData => 'アプリデータをリセット';

  @override
  String get resetAppDataMessage => 'これにより、すべてのアプリデータと設定がデフォルトにリセットされます。この操作は元に戻せません。\\n\\n続行しますか？';

  @override
  String get buttonReset => 'リセット';

  @override
  String get messageDataReset => 'アプリデータがリセットされました';

  @override
  String errorResetFailed(String error) {
    return 'データのリセットに失敗しました: $error';
  }

  @override
  String get analyticsTitle => '分析';

  @override
  String get analyticsOverview => '概要';

  @override
  String get analyticsPoints => 'ポイント';

  @override
  String get analyticsStreak => 'ストリーク';

  @override
  String get analyticsSessions => 'セッション';

  @override
  String get analyticsLast7Days => '過去7日間';

  @override
  String get analyticsPerformanceHighlights => 'パフォーマンスのハイライト';

  @override
  String get analyticsSuccessRate => '成功率';

  @override
  String get analyticsAvgSession => '平均セッション';

  @override
  String get analyticsBestStreak => '最高のストリーク';

  @override
  String get analyticsActivityProgress => 'アクティビティの進捗';

  @override
  String get analyticsComingSoon => '詳細なアクティビティトラッキングは近日公開予定です。';

  @override
  String get analyticsAdvancedMetrics => '高度な指標';

  @override
  String get analyticsPremiumContent => 'プレミアム高度分析コンテンツはこちら...';

  @override
  String get analytics30DayTrends => '30日間のトレンド';

  @override
  String get analyticsTrendsChart => 'プレミアムトレンドチャートはこちら...';

  @override
  String get analyticsAIInsights => 'AI インサイト';

  @override
  String get analyticsAIComingSoon => 'AI駆動のインサイトは近日公開予定...';

  @override
  String get analyticsUnlock => '高度な分析をロック解除';

  @override
  String get errorTitle => 'エラー';

  @override
  String get errorQuestUnavailable => 'クエスト状態が利用できません';

  @override
  String get buttonOK => 'OK';

  @override
  String get errorFreezeTokenFailed => '❌ フリーズトークンの使用に失敗しました';

  @override
  String get buttonUseFreeze => 'フリーズを使用';

  @override
  String get onboardingDailyGoalTitle => '毎日の目標を設定しよう！🎯';

  @override
  String get onboardingDailyGoalSubtitle => 'どれくらいの集中時間が適切ですか？\\n（いつでも調整できます！）';

  @override
  String get onboardingGoalGettingStarted => 'はじめに';

  @override
  String get onboardingGoalBuildingHabit => '習慣を作る';

  @override
  String get onboardingGoalRegularPractice => '定期的な練習';

  @override
  String get onboardingGoalDeepWork => 'ディープワーク';

  @override
  String get onboardingProTip => 'プロのヒント: 静寂 = 集中のとき、Focus Fieldは輝きます！🤫✨';

  @override
  String get onboardingPrivacyTitle => 'あなたのプライバシーは重要です！🔒';

  @override
  String get onboardingPrivacySubtitle => '周囲の騒音を測定し、より集中できるようにするためにマイクへのアクセスが必要です';

  @override
  String get onboardingPrivacyNoRecording => '録音なし';

  @override
  String get onboardingPrivacyLocalOnly => 'ローカルのみ';

  @override
  String get onboardingPrivacyLocalOnlyDesc => 'すべてのデータはデバイスに保存されます';

  @override
  String get onboardingPrivacyFirst => 'プライバシー第一';

  @override
  String get onboardingPrivacyNote => '最初のセッションを開始するときに次の画面で許可を付与できます';

  @override
  String get insightsFocusTime => '集中時間';

  @override
  String get insightsSessions => 'セッション';

  @override
  String get insightsAverage => '平均';

  @override
  String get insightsAmbientScore => 'アンビエントスコア';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeOceanBlue => 'オーシャンブルー';

  @override
  String get themeForestGreen => 'フォレストグリーン';

  @override
  String get themePurpleNight => 'パープルナイト';

  @override
  String get themeGoldLuxury => 'ゴールドラグジュアリー';

  @override
  String get themeSolarSunrise => 'ソーラーサンライズ';

  @override
  String get themeCyberNeon => 'サイバーネオン';

  @override
  String get themeMidnightTeal => 'ミッドナイトティール';

  @override
  String get settingsAppTheme => 'アプリテーマ';

  @override
  String get freezeTokenNoTokensTitle => 'フリーズトークンなし';

  @override
  String get freezeTokenNoTokensMessage => '利用可能なフリーズトークンがありません。週に1トークン獲得できます（最大4）。';

  @override
  String get freezeTokenGoalCompleteTitle => '目標はすでに達成されています';

  @override
  String get freezeTokenGoalCompleteMessage => '日次目標はすでに達成されています！フリーズトークンは目標をまだ達成していない場合にのみ使用できます。';

  @override
  String get freezeTokenUseTitle => 'フリーズトークンを使用';

  @override
  String get freezeTokenUseMessage => 'フリーズトークンは、1日逃した時にストリークを保護します。フリーズを使用すると、日次目標を達成したとカウントされます。';

  @override
  String freezeTokenUsePrompt(Object count) {
    return '$count個のトークンがあります。今すぐ1つ使用しますか？';
  }

  @override
  String get freezeTokenUsedSuccess => '✅ フリーズトークンを使用しました！目標は達成済みとマークされました。';

  @override
  String get trendsErrorLoading => 'データの読み込みエラー';

  @override
  String get trendsPoints => 'ポイント';

  @override
  String get trendsStreak => 'ストリーク';

  @override
  String get trendsSessions => 'セッション';

  @override
  String get trendsTopActivity => 'トップアクティビティ';

  @override
  String get sectionToday => '今日';

  @override
  String get sectionSessions => 'セッション';

  @override
  String get sectionInsights => 'インサイト';

  @override
  String get onboardingGoalAdviceGettingStarted => '完璧なスタート！🌟 小さな一歩が大きな勝利につながります。あなたならできる！';

  @override
  String get onboardingGoalAdviceBuildingHabit => '素晴らしい選択！🎯 このスイートスポットが持続的な習慣を作ります！';

  @override
  String get onboardingGoalAdviceRegularPractice => '野心的！💪 集中力を高める準備ができています！';

  @override
  String get onboardingGoalAdviceDeepWork => 'わお！🏆 ディープワークモード起動！休憩を忘れずに！';

  @override
  String get onboardingDuration10to15 => '10-15分';

  @override
  String get onboardingDuration20to30 => '20-30分';

  @override
  String get onboardingDuration40to60 => '40-60分';

  @override
  String get onboardingDuration60plus => '60分以上';

  @override
  String get activityStudy => '勉強';

  @override
  String get activityReading => '読書';

  @override
  String get activityMeditation => '瞑想';

  @override
  String get activityOther => 'その他';

  @override
  String get onboardingTip1Description => '5-10分のセッションから始めましょう。一貫性は完璧さに勝ります！';

  @override
  String get onboardingTip2Description => '没入型で気が散らない体験のためにフォーカスモードをタップしてください。';

  @override
  String get onboardingTip3Description => '忙しい日に月次トークンを使用してストリークを保護しましょう。';

  @override
  String get onboardingTip4Description => '70%の静かな時間を目指しましょう - 完璧な静寂は不要です！';

  @override
  String get onboardingLaunchTitle => '準備完了！🚀';

  @override
  String get onboardingLaunchDescription => '最初のセッションを始めて、素晴らしい習慣を作りましょう！';

  @override
  String get insightsBestTimeByActivity => 'アクティビティ別のベストタイム';

  @override
  String get insightHighSuccessRateTitle => '高い成功率';

  @override
  String get insightEnvironmentStabilityTitle => '環境の安定性';

  @override
  String get insightLowNoiseSuccessTitle => '低騒音化に成功';

  @override
  String get insightConsistentPracticeTitle => '一貫した実践';

  @override
  String get insightStreakProtectionTitle => 'ストリーク保護が利用可能';

  @override
  String get insightRoomTooNoisyTitle => '部屋がうるさすぎる';

  @override
  String get insightIrregularScheduleTitle => '不定期スケジュール';

  @override
  String get insightLowAmbientScoreTitle => '低い周囲スコア';

  @override
  String get insightNoRecentSessionsTitle => '最近のセッションはありません';

  @override
  String get insightHighSuccessRateDesc => '強力なサイレント セッションを維持しています。';

  @override
  String get insightEnvironmentStabilityDesc => '周囲の騒音は適度で管理可能な範囲内にあります。';

  @override
  String get insightLowNoiseSuccessDesc => 'セッション中の環境は非常に静かです。';

  @override
  String get insightConsistentPracticeDesc => '信頼できる毎日の練習習慣を構築しています。';

  @override
  String insightStreakProtectionDesc(Object count) {
    return 'ストリークを保護するためのフリーズ トークンが $count 個あります。';
  }

  @override
  String get insightRoomTooNoisyDesc => 'より静かな場所を見つけるか、敷居を調整してみてください。';

  @override
  String get insightIrregularScheduleDesc => 'セッション時間をより安定させると、連続記録が改善される可能性があります。';

  @override
  String get insightLowAmbientScoreDesc => '最近のセッションでは静かな時間が短くなりました。より静かな環境を試してください。';

  @override
  String get insightNoRecentSessionsDesc => '集中する習慣を身につけるために、今すぐセッションを始めてください。';

  @override
  String sessionCompleteSuccess(Object minutes) {
    return '素晴らしい仕事だ！ $minutes 分のセッションに集中してください。 ✨';
  }

  @override
  String sessionCompletePartial(Object minutes) {
    return '頑張れ！ $minutes 分完了しました。';
  }

  @override
  String get sessionCompleteFailed => 'セッションが終了しました。準備ができたらもう一度試してください。';

  @override
  String get notificationSessionStarted => 'セッションが始まりました - 集中してください!';

  @override
  String get notificationSessionPaused => 'セッションが一時停止されました';

  @override
  String get notificationSessionResumed => 'セッションが再開されました';
}
