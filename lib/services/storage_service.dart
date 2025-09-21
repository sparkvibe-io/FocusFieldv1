import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/models/silence_data.dart';

class StorageService {
  static const String _silenceDataKey = 'silence_data';
  static const String _decibelThresholdKey = 'decibel_threshold';
  static const String _sessionDurationKey = 'session_duration';
  static const String _sampleIntervalKey = 'sample_interval';
  static const String _pointsPerSuccessKey = 'points_per_success';
  static const String _firstLaunchKey = 'first_launch';
  static const String _appVersionKey = 'app_version';
  static const String _lastSessionDateKey = 'last_session_date';
  static const String _totalSessionsKey = 'total_sessions';
  static const String _averageScoreKey = 'average_score';
  // Notification settings keys
  static const String _enableNotificationsKey = 'enable_notifications';
  static const String _enableDailyRemindersKey = 'enable_daily_reminders';
  static const String _enableSessionCompleteKey = 'enable_session_complete';
  static const String _enableAchievementNotificationsKey =
      'enable_achievement_notifications';
  static const String _enableWeeklyProgressKey = 'enable_weekly_progress';
  // Notification scheduling keys
  static const String _dailyReminderHourKey = 'daily_reminder_hour';
  static const String _dailyReminderMinuteKey = 'daily_reminder_minute';
  static const String _weeklySummaryWeekdayKey =
      'weekly_summary_weekday'; // 1=Mon .. 7=Sun
  static const String _weeklySummaryHourKey = 'weekly_summary_hour';
  static const String _weeklySummaryMinuteKey = 'weekly_summary_minute';

  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Initialize app settings on first launch
  Future<void> initializeApp() async {
    await _init();

    final isFirstLaunch = _prefs!.getBool(_firstLaunchKey) ?? true;

    if (isFirstLaunch) {
      // Set default values on first launch
      await _prefs!.setDouble(
        _decibelThresholdKey,
        AppConstants.defaultDecibelThreshold,
      );
      await _prefs!.setInt(
        _sessionDurationKey,
        AppConstants.silenceDurationSeconds,
      );
      await _prefs!.setInt(_sampleIntervalKey, AppConstants.sampleIntervalMs);
      await _prefs!.setInt(_pointsPerSuccessKey, AppConstants.pointsPerSuccess);
      await _prefs!.setString(_appVersionKey, '1.0.0');
      await _prefs!.setInt(_totalSessionsKey, 0);
      await _prefs!.setDouble(_averageScoreKey, 0.0);

      // Initialize notification settings with defaults
      await _prefs!.setBool(_enableNotificationsKey, true);
      await _prefs!.setBool(_enableDailyRemindersKey, false);
      await _prefs!.setBool(_enableSessionCompleteKey, true);
      await _prefs!.setBool(_enableAchievementNotificationsKey, true);
      await _prefs!.setBool(_enableWeeklyProgressKey, false);

      await _prefs!.setBool(_firstLaunchKey, false);

      // Initialize empty silence data
      await saveSilenceData(const SilenceData());
    }
  }

  /// Get all settings at once for efficient loading
  Future<Map<String, dynamic>> loadAllSettings() async {
    await _init();
    return {
      'decibelThreshold':
          _prefs!.getDouble(_decibelThresholdKey) ??
          AppConstants.defaultDecibelThreshold,
      'sessionDuration':
          _prefs!.getInt(_sessionDurationKey) ??
          AppConstants.silenceDurationSeconds,
      'sampleInterval':
          _prefs!.getInt(_sampleIntervalKey) ?? AppConstants.sampleIntervalMs,
      'pointsPerSuccess':
          _prefs!.getInt(_pointsPerSuccessKey) ?? AppConstants.pointsPerSuccess,
      'totalSessions': _prefs!.getInt(_totalSessionsKey) ?? 0,
      'averageScore': _prefs!.getDouble(_averageScoreKey) ?? 0.0,
      'appVersion': _prefs!.getString(_appVersionKey) ?? '1.0.0',
      'isFirstLaunch': _prefs!.getBool(_firstLaunchKey) ?? true,
      // Notification settings (with defaults)
      'enableNotifications': _prefs!.getBool(_enableNotificationsKey) ?? true,
      'enableDailyReminders':
          _prefs!.getBool(_enableDailyRemindersKey) ?? false,
      'enableSessionComplete':
          _prefs!.getBool(_enableSessionCompleteKey) ?? true,
      'enableAchievementNotifications':
          _prefs!.getBool(_enableAchievementNotificationsKey) ?? true,
      'enableWeeklyProgress':
          _prefs!.getBool(_enableWeeklyProgressKey) ?? false,
      // Notification scheduling (nullable defaults)
      'dailyReminderHour': _prefs!.getInt(_dailyReminderHourKey),
      'dailyReminderMinute': _prefs!.getInt(_dailyReminderMinuteKey),
      'weeklySummaryWeekday':
          _prefs!.getInt(_weeklySummaryWeekdayKey) ?? DateTime.monday,
      'weeklySummaryHour': _prefs!.getInt(_weeklySummaryHourKey) ?? 9,
      'weeklySummaryMinute': _prefs!.getInt(_weeklySummaryMinuteKey) ?? 0,
    };
  }

  /// Save all settings at once
  Future<void> saveAllSettings(Map<String, dynamic> settings) async {
    await _init();
    for (final entry in settings.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value == null) continue; // skip null writes
      switch (key) {
        case 'decibelThreshold':
          await _prefs!.setDouble(_decibelThresholdKey, value as double);
          break;
        case 'sessionDuration':
          await _prefs!.setInt(_sessionDurationKey, value as int);
          break;
        case 'sampleInterval':
          await _prefs!.setInt(_sampleIntervalKey, value as int);
          break;
        case 'pointsPerSuccess':
          await _prefs!.setInt(_pointsPerSuccessKey, value as int);
          break;
        case 'totalSessions':
          await _prefs!.setInt(_totalSessionsKey, value as int);
          break;
        case 'averageScore':
          await _prefs!.setDouble(_averageScoreKey, value as double);
          break;
        case 'dailyReminderHour':
          await _prefs!.setInt(_dailyReminderHourKey, value as int);
          break;
        case 'dailyReminderMinute':
          await _prefs!.setInt(_dailyReminderMinuteKey, value as int);
          break;
        case 'weeklySummaryWeekday':
          await _prefs!.setInt(_weeklySummaryWeekdayKey, value as int);
          break;
        case 'weeklySummaryHour':
          await _prefs!.setInt(_weeklySummaryHourKey, value as int);
          break;
        case 'weeklySummaryMinute':
          await _prefs!.setInt(_weeklySummaryMinuteKey, value as int);
          break;
        case 'enableNotifications':
          await _prefs!.setBool(_enableNotificationsKey, value as bool);
          break;
        case 'enableDailyReminders':
          await _prefs!.setBool(_enableDailyRemindersKey, value as bool);
          break;
        case 'enableSessionComplete':
          await _prefs!.setBool(_enableSessionCompleteKey, value as bool);
          break;
        case 'enableAchievementNotifications':
          await _prefs!.setBool(
            _enableAchievementNotificationsKey,
            value as bool,
          );
          break;
        case 'enableWeeklyProgress':
          await _prefs!.setBool(_enableWeeklyProgressKey, value as bool);
          break;
        default:
          // Generic persistence for any new primitive key
          if (value is int) {
            await _prefs!.setInt(key, value);
          } else if (value is double) {
            await _prefs!.setDouble(key, value);
          } else if (value is bool) {
            await _prefs!.setBool(key, value);
          } else if (value is String) {
            await _prefs!.setString(key, value);
          }
      }
    }
  }

  /// Save silence data to local storage
  Future<void> saveSilenceData(SilenceData data) async {
    await _init();
    final jsonString = jsonEncode(data.toJson());
    await _prefs!.setString(_silenceDataKey, jsonString);
  }

  /// Load silence data from local storage
  Future<SilenceData> loadSilenceData() async {
    await _init();
    final jsonString = _prefs!.getString(_silenceDataKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return SilenceData.fromJson(json);
      } catch (e) {
        // If JSON is corrupted, return default data
        return const SilenceData();
      }
    }

    return const SilenceData();
  }

  /// Save decibel threshold setting
  Future<void> saveDecibelThreshold(double threshold) async {
    await _init();
    await _prefs!.setDouble(_decibelThresholdKey, threshold);
  }

  /// Load decibel threshold setting
  Future<double> loadDecibelThreshold() async {
    await _init();
    return _prefs!.getDouble(_decibelThresholdKey) ??
        AppConstants.defaultDecibelThreshold;
  }

  /// Save session duration setting
  Future<void> saveSessionDuration(int duration) async {
    await _init();
    await _prefs!.setInt(_sessionDurationKey, duration);
  }

  /// Load session duration setting
  Future<int> loadSessionDuration() async {
    await _init();
    return _prefs!.getInt(_sessionDurationKey) ??
        AppConstants.silenceDurationSeconds;
  }

  /// Save sample interval setting
  Future<void> saveSampleInterval(int interval) async {
    await _init();
    await _prefs!.setInt(_sampleIntervalKey, interval);
  }

  /// Load sample interval setting
  Future<int> loadSampleInterval() async {
    await _init();
    return _prefs!.getInt(_sampleIntervalKey) ?? AppConstants.sampleIntervalMs;
  }

  /// Save points per success setting
  Future<void> savePointsPerSuccess(int points) async {
    await _init();
    await _prefs!.setInt(_pointsPerSuccessKey, points);
  }

  /// Load points per success setting
  Future<int> loadPointsPerSuccess() async {
    await _init();
    return _prefs!.getInt(_pointsPerSuccessKey) ??
        AppConstants.pointsPerSuccess;
  }

  /// Check if this is the first app launch
  Future<bool> isFirstLaunch() async {
    await _init();
    return _prefs!.getBool(_firstLaunchKey) ?? true;
  }

  /// Get app version
  Future<String> getAppVersion() async {
    await _init();
    return _prefs!.getString(_appVersionKey) ?? '1.0.0';
  }

  /// Save app version
  Future<void> saveAppVersion(String version) async {
    await _init();
    await _prefs!.setString(_appVersionKey, version);
  }

  /// Get total sessions count
  Future<int> getTotalSessions() async {
    await _init();
    return _prefs!.getInt(_totalSessionsKey) ?? 0;
  }

  /// Increment total sessions count
  Future<void> incrementTotalSessions() async {
    await _init();
    final currentCount = await getTotalSessions();
    await _prefs!.setInt(_totalSessionsKey, currentCount + 1);
  }

  /// Get average score
  Future<double> getAverageScore() async {
    await _init();
    return _prefs!.getDouble(_averageScoreKey) ?? 0.0;
  }

  /// Update average score
  Future<void> updateAverageScore(double newScore) async {
    await _init();
    final totalSessions = await getTotalSessions();
    final currentAverage = await getAverageScore();

    // Calculate new average
    final newAverage =
        totalSessions > 0
            ? ((currentAverage * totalSessions) + newScore) /
                (totalSessions + 1)
            : newScore;

    await _prefs!.setDouble(_averageScoreKey, newAverage);
  }

  /// Save last session date
  Future<void> saveLastSessionDate(DateTime date) async {
    await _init();
    await _prefs!.setString(_lastSessionDateKey, date.toIso8601String());
  }

  /// Get last session date
  Future<DateTime?> getLastSessionDate() async {
    await _init();
    final dateString = _prefs!.getString(_lastSessionDateKey);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Reset all stored data
  Future<void> resetAllData() async {
    await _init();
    await _prefs!.clear();
    // Re-initialize after clearing
    await initializeApp();
  }

  /// Update streak based on current date
  Future<SilenceData> updateStreak(SilenceData currentData) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If no last play date, start streak at 1
    if (currentData.lastPlayDate == null) {
      return currentData.copyWith(currentStreak: 1, lastPlayDate: today);
    }

    final lastPlayDay = DateTime(
      currentData.lastPlayDate!.year,
      currentData.lastPlayDate!.month,
      currentData.lastPlayDate!.day,
    );

    // If played today, don't change streak
    if (today.isAtSameMomentAs(lastPlayDay)) {
      return currentData;
    }

    // If played yesterday, increment streak
    final yesterday = today.subtract(const Duration(days: 1));
    if (lastPlayDay.isAtSameMomentAs(yesterday)) {
      final newStreak = currentData.currentStreak + 1;
      final newBestStreak =
          newStreak > currentData.bestStreak
              ? newStreak
              : currentData.bestStreak;

      return currentData.copyWith(
        currentStreak: newStreak,
        bestStreak: newBestStreak,
        lastPlayDate: today,
      );
    }

    // If gap is more than 1 day, reset streak
    return currentData.copyWith(currentStreak: 1, lastPlayDate: today);
  }
}
