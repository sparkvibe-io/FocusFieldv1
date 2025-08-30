// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Silence Score';

  @override
  String get splashLoading => '集中エンジンを準備中…';

  @override
  String get paywallTitle => 'プレミアムでより深い集中を';

  @override
  String get featureExtendSessions => 'セッションを5分から120分へ拡張';

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
  String get microphonePermissionMessage => 'Silence Score は環境ノイズ測定のためマイクを使用します。音声は保存されません。';

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
  String get faq => 'FAQ';

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
  String get frequentlyAskedQuestions => 'よくある質問';

  @override
  String get faqHowWorksQ => '仕組みは?';

  @override
  String get faqHowWorksA => '環境ノイズを測定し しきい値未満の時間でポイント獲得';

  @override
  String get faqAudioRecordedQ => '音声は記録されますか?';

  @override
  String get faqAudioRecordedA => 'いいえ。デシベル値のみ計測し保存しません';

  @override
  String get faqAdjustSensitivityQ => '感度調整?';

  @override
  String faqAdjustSensitivityA(int min, int max) {
    return '設定 > 基本 > しきい値 ($min–$max dB) で較正後に調整';
  }

  @override
  String get faqPremiumFeaturesQ => 'プレミアム機能?';

  @override
  String get faqPremiumFeaturesA => '延長セッション・高度分析・エクスポート・テーマ';

  @override
  String get faqNotificationsQ => '通知?';

  @override
  String get faqNotificationsA => 'スマートリマインダーが習慣を学びマイルストーンを祝福';

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
}
