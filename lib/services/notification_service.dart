import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_permissions.dart';
import 'package:focus_field/l10n/app_localizations.dart';

typedef NowProvider = DateTime Function();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _sessionTimesKey = 'session_times';
  static const String _lastReminderKey = 'last_reminder';

  // Flutter Local Notifications
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationPermissionHandler? _permissionHandler; // lazy

  // IDs
  static const int dailyReminderId = 1001;
  static const int weeklySummaryId = 1002;
  static const int ongoingSessionId = 2001;

  // Optional action handler for notification taps/actions
  Future<void> Function(String actionId, String? payload)? actionHandler;

  // Time provider (injectable for tests)
  NowProvider now = DateTime.now;

  // Settings
  bool enableNotifications = true;
  bool enableDailyReminders = false;
  bool enableSessionComplete = true;
  bool enableAchievementNotifications = true;
  bool enableWeeklyProgress = false;
  // User-selected scheduling overrides (nullable means use smart detection / defaults)
  int? dailyReminderHour; // 0-23
  int? dailyReminderMinute; // 0-59
  int weeklySummaryWeekday = DateTime.monday; // 1=Mon..7=Sun
  int weeklySummaryHour = 9;
  int weeklySummaryMinute = 0;

  // Permission status
  bool _hasNotificationPermission = false;
  bool _isInitialized = false;

  // Test hook for capturing scheduling without invoking platform plugin
  @visibleForTesting
  void Function({
    required int id,
    required DateTime scheduled,
    required DateTimeComponents? match,
  })?
  onZonedSchedule;

  List<DateTime> _sessionTimes = [];
  @visibleForTesting
  void setSessionTimes(List<DateTime> times) {
    _sessionTimes = List.from(times);
  }

  Future<void> initialize({NowProvider? nowProvider}) async {
    if (_isInitialized) return;
    if (nowProvider != null) now = nowProvider;

    final isTest = _isInTestEnvironment();
    if (!isTest) {
      await _initializeNotifications();
      _permissionHandler ??= NotificationPermissionHandler(
        _flutterLocalNotificationsPlugin,
      );
      await _permissionHandler!.initialize();
      _hasNotificationPermission = _permissionHandler!.hasPermission;
      // Initialize timezone database once
      try {
        tz.initializeTimeZones();
      } catch (_) {}
      if (tz.local.name == 'UTC') {
        // Attempt to set local location if possible
        try {
          tz.setLocalLocation(tz.getLocation(_platformTimeZoneName() ?? 'UTC'));
        } catch (_) {}
      }
    } else {
      if (!kReleaseMode) {
        debugPrint(
          '[NotificationService] Skipping notification plugin init in test environment',
        );
      }
      _hasNotificationPermission = false; // treat as no permission in tests
    }

    await _loadSessionTimes();
    _isInitialized = true;
  }

  Future<void> _initializeNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    if (!kReleaseMode) {
      debugPrint('Notification tapped: ${notificationResponse.payload}');
    }
    // Dispatch action callbacks for interactive notifications
    final actionId = notificationResponse.actionId;
    if (actionId != null && actionId.isNotEmpty) {
      final handler = actionHandler;
      if (handler != null) {
        handler(actionId, notificationResponse.payload);
      }
    }
  }

  void updateSettings({
    bool? notifications,
    bool? dailyReminders,
    bool? sessionComplete,
    bool? achievementNotifications,
    bool? weeklyProgress,
    int? dailyHour,
    int? dailyMinute,
    int? weeklyWeekday,
    int? weeklyHour,
    int? weeklyMinute,
  }) {
    if (notifications != null) enableNotifications = notifications;
    if (dailyReminders != null) enableDailyReminders = dailyReminders;
    if (sessionComplete != null) enableSessionComplete = sessionComplete;
    if (achievementNotifications != null) {
      enableAchievementNotifications = achievementNotifications;
    }
    if (weeklyProgress != null) enableWeeklyProgress = weeklyProgress;
    if (dailyHour != null) dailyReminderHour = dailyHour;
    if (dailyMinute != null) dailyReminderMinute = dailyMinute;
    if (weeklyWeekday != null) weeklySummaryWeekday = weeklyWeekday;
    if (weeklyHour != null) weeklySummaryHour = weeklyHour;
    if (weeklyMinute != null) weeklySummaryMinute = weeklyMinute;
  }

  // Record when user starts a session
  Future<void> recordSessionTime(DateTime sessionTime) async {
    _sessionTimes.add(sessionTime);

    // Keep only last 30 sessions for pattern analysis
    if (_sessionTimes.length > 30) {
      _sessionTimes = _sessionTimes.sublist(_sessionTimes.length - 30);
    }

    await _saveSessionTimes();
  }

  // Get the most common session time for reminders
  TimeOfDay? getOptimalReminderTime() {
    // If user picked an explicit time, honor it regardless of history
    if (dailyReminderHour != null && dailyReminderMinute != null) {
      return TimeOfDay(hour: dailyReminderHour!, minute: dailyReminderMinute!);
    }
    if (_sessionTimes.isEmpty) return null;

    // Group sessions by hour and find the most common
    final hourCounts = <int, int>{};

    for (final sessionTime in _sessionTimes) {
      final hour = sessionTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    if (hourCounts.isEmpty) return null;

    // Find the hour with most sessions
    final mostCommonHour =
        hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Calculate average minute for that hour
    final sessionsInHour =
        _sessionTimes.where((time) => time.hour == mostCommonHour).toList();

    final averageMinute =
        sessionsInHour.isEmpty
            ? 0
            : (sessionsInHour
                        .map((time) => time.minute)
                        .reduce((a, b) => a + b) /
                    sessionsInHour.length)
                .round();

    return TimeOfDay(hour: mostCommonHour, minute: averageMinute);
  }

  // Check if we should send a reminder today
  Future<bool> shouldSendDailyReminder() async {
    if (!enableNotifications || !enableDailyReminders) return false;
    if (_sessionTimes.isEmpty) return false; // need history

    final prefs = await SharedPreferences.getInstance();
    final lastReminderString = prefs.getString(_lastReminderKey);

    final todayNow = now();
    final today = DateTime(todayNow.year, todayNow.month, todayNow.day);

    if (lastReminderString != null) {
      final lastReminder = DateTime.parse(lastReminderString);
      final sameDay =
          lastReminder.year == today.year &&
          lastReminder.month == today.month &&
          lastReminder.day == today.day;
      if (sameDay) return false; // already sent today
    }

    final optimalTime = getOptimalReminderTime();
    if (optimalTime == null) return false;

    final optimalMinutes = optimalTime.hour * 60 + optimalTime.minute;
    final currentMinutes = todayNow.hour * 60 + todayNow.minute;
    return (currentMinutes - optimalMinutes).abs() <= 30;
  }

  // Mark that we sent a reminder today
  Future<void> markReminderSent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReminderKey, now().toIso8601String());
  }

  // Get reminder message based on user's pattern
  String getReminderMessage() {
    final optimalTime = getOptimalReminderTime();
    final sessionCount = _sessionTimes.length;

    if (optimalTime == null || sessionCount == 0) {
      return 'Time for your daily focus practice! 🎯';
    }

    final timeString =
        '${optimalTime.hour.toString().padLeft(2, '0')}:${optimalTime.minute.toString().padLeft(2, '0')}';

    if (sessionCount < 5) {
      return 'Building your focus habit! Ready for today\'s session? 🌱';
    } else if (sessionCount < 15) {
      return 'You usually practice around $timeString. Ready to continue your streak? ⭐';
    } else {
      return 'Your daily $timeString focus session awaits! You\'ve got this! 🏆';
    }
  }

  // Session completion messages
  String getCompletionMessage(bool success, int durationMinutes) {
    if (success) {
      if (durationMinutes >= 5) {
        return 'Excellent! $durationMinutes focus minutes earned! 🏆';
      } else {
        return 'Great job! $durationMinutes focus minutes in your session! ✨';
      }
    } else {
      return 'Session ended early—that\'s okay! Every attempt builds your focus habit. 💪';
    }
  }

  // Get streak information
  int getCurrentStreak() {
    if (_sessionTimes.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;

    // Check consecutive days backwards from today
    for (int i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final hasSessionOnDate = _sessionTimes.any((session) {
        final sessionDate = DateTime(session.year, session.month, session.day);
        return sessionDate.isAtSameMomentAs(checkDate);
      });

      if (hasSessionOnDate) {
        streak++;
      } else if (i > 0) {
        // If no session found and not today, break the streak
        break;
      }
    }

    return streak;
  }

  Future<void> _loadSessionTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString(_sessionTimesKey);

      if (sessionsJson != null) {
        final sessionsList = jsonDecode(sessionsJson) as List;
        _sessionTimes =
            sessionsList
                .map((timeString) => DateTime.parse(timeString as String))
                .toList();
      }
    } catch (e) {
      debugPrint('Error loading session times: $e');
      _sessionTimes = [];
    }
  }

  Future<void> _saveSessionTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = jsonEncode(
        _sessionTimes.map((time) => time.toIso8601String()).toList(),
      );
      await prefs.setString(_sessionTimesKey, sessionsJson);
    } catch (e) {
      debugPrint('Error saving session times: $e');
    }
  }

  // Permission handling
  Future<bool> requestNotificationPermission() async {
    _permissionHandler ??= NotificationPermissionHandler(
      _flutterLocalNotificationsPlugin,
    );
    final granted = await _permissionHandler!.request();
    _hasNotificationPermission = granted;
    return granted;
  }

  Future<void> refreshPermissionStatus() async {
    _permissionHandler ??= NotificationPermissionHandler(
      _flutterLocalNotificationsPlugin,
    );
    await _permissionHandler!.refreshStatus();
    _hasNotificationPermission = _permissionHandler!.hasPermission;
  }

  // Show actual notifications
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!enableNotifications || !_hasNotificationPermission) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'focus_field_general',
          'General Notifications',
          channelDescription: 'General notifications for Focus Field app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Convenience methods for different notification types
  Future<void> showDailyReminder(BuildContext context) async {
    final l = AppLocalizations.of(context);
    await showNotification(
      title: l?.dailySilenceReminderTitle ?? 'Daily Focus Reminder',
      body: getSmartReminderMessage(context),
      payload: 'daily_reminder',
    );
  }

  // Ongoing session notification APIs (Android primary; iOS shows a regular notification as fallback)
  Future<void> showOngoingSession({
    required String title,
    required String body,
    int progress = 0, // 0..100
  }) async {
    if (!enableNotifications || !_hasNotificationPermission) return;

    final android = AndroidNotificationDetails(
      'focus_field_session',
      'Session',
      channelDescription: 'Ongoing focus session',
      importance: Importance.low,
      priority: Priority.low,
      category: AndroidNotificationCategory.service,
      ongoing: true,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress.clamp(0, 100),
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction('STOP_SESSION', 'Stop', showsUserInterface: true),
      ],
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails(presentAlert: false, presentBadge: false, presentSound: false);
    final details = NotificationDetails(android: android, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
      ongoingSessionId,
      title,
      body,
      details,
      payload: 'ongoing_session',
    );
  }

  Future<void> updateOngoingSession({
    String? title,
    String? body,
    int? progress,
  }) async {
    if (!enableNotifications || !_hasNotificationPermission) return;
    final android = AndroidNotificationDetails(
      'focus_field_session',
      'Session',
      channelDescription: 'Ongoing focus session',
      importance: Importance.low,
      priority: Priority.low,
      category: AndroidNotificationCategory.service,
      ongoing: true,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: (progress ?? 0).clamp(0, 100),
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction('STOP_SESSION', 'Stop', showsUserInterface: true),
      ],
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails(presentAlert: false, presentBadge: false, presentSound: false);
    final details = NotificationDetails(android: android, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
      ongoingSessionId,
      title ?? 'Session in progress',
      body ?? 'Stay in the app to maintain Deep Focus',
      details,
      payload: 'ongoing_session',
    );
  }

  Future<void> cancelOngoingSession() async {
    await _flutterLocalNotificationsPlugin.cancel(ongoingSessionId);
  }

  Future<void> showSessionComplete(
    BuildContext context,
    bool success,
    int durationMinutes,
  ) async {
    if (!enableSessionComplete) return;
    final l = AppLocalizations.of(context);
    await showNotification(
      title:
          success
              ? (l?.sessionCompleteSuccessTitle ?? 'Session Complete! 🎉')
              : (l?.sessionCompleteEndedTitle ?? 'Session Ended'),
      body: getCompletionMessage(success, durationMinutes),
      payload: 'session_complete',
    );
  }

  Future<void> showAchievement(BuildContext context, String achievement) async {
    if (!enableAchievementNotifications) return;
    final l = AppLocalizations.of(context);
    await showNotification(
      title: l?.achievementUnlockedGenericTitle ?? 'Achievement Unlocked! 🏆',
      body: getAchievementMessage(context, achievement),
      payload: 'achievement:$achievement',
    );
  }

  Future<void> showWeeklyProgress(
    BuildContext context,
    int sessionsThisWeek,
    int averageScore,
  ) async {
    if (!enableWeeklyProgress) return;
    final l = AppLocalizations.of(context);
    await showNotification(
      title: l?.weeklyProgressReportTitle ?? 'Weekly Progress Report 📊',
      body: getWeeklyProgressMessage(context, sessionsThisWeek, averageScore),
      payload: 'weekly_progress',
    );
  }

  bool get hasNotificationPermission => _hasNotificationPermission;
  @visibleForTesting
  void setTestPlugin(dynamic plugin) {
    _flutterLocalNotificationsPlugin =
        plugin as FlutterLocalNotificationsPlugin;
  }

  @visibleForTesting
  void forcePermissionGranted() {
    _hasNotificationPermission = true;
  }

  // Scheduling helpers -------------------------------------------------------
  Future<void> scheduleDailyReminderNotification({
    BuildContext? context,
  }) async {
    if (!enableNotifications ||
        !enableDailyReminders ||
        !_hasNotificationPermission) {
      return;
    }
    final optimal = getOptimalReminderTime();
    if (optimal == null) return; // need history
    final nowDt = now();
    final scheduleTime = DateTime(
      nowDt.year,
      nowDt.month,
      nowDt.day,
      optimal.hour,
      optimal.minute,
    );
    final target =
        scheduleTime.isAfter(nowDt)
            ? scheduleTime
            : scheduleTime.add(const Duration(days: 1));
    if (_isInTestEnvironment()) {
      onZonedSchedule?.call(
        id: dailyReminderId,
        scheduled: target,
        match: DateTimeComponents.time,
      );
      return;
    }
    final tzTime = tz.TZDateTime.from(target, tz.local);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      dailyReminderId,
      context != null
          ? (AppLocalizations.of(context)?.dailySilenceReminderTitle ??
              'Daily Focus Reminder')
          : 'Daily Focus Reminder',
      getSmartReminderMessage(context),
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_field_general',
          'General Notifications',
          channelDescription: 'General notifications for Focus Field app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  Future<void> scheduleWeeklySummaryNotification({
    BuildContext? context,
    int weekday = DateTime.monday,
    int hour = 9,
    int minute = 0,
  }) async {
    if (!enableNotifications ||
        !enableWeeklyProgress ||
        !_hasNotificationPermission) {
      return;
    }
    // Allow stored overrides to supersede passed parameters
    final effectiveWeekday =
        weeklySummaryWeekday; // already stored default / user setting
    final effectiveHour = weeklySummaryHour;
    final effectiveMinute = weeklySummaryMinute;
    final nowDt = now();
    // Find next occurrence of given weekday
    int daysUntil = (effectiveWeekday - nowDt.weekday) % 7;
    var scheduled = DateTime(
      nowDt.year,
      nowDt.month,
      nowDt.day,
      effectiveHour,
      effectiveMinute,
    ).add(Duration(days: daysUntil));
    if (scheduled.isBefore(nowDt)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    if (_isInTestEnvironment()) {
      onZonedSchedule?.call(
        id: weeklySummaryId,
        scheduled: scheduled,
        match: DateTimeComponents.dayOfWeekAndTime,
      );
      return;
    }
    final tzTime = tz.TZDateTime.from(scheduled, tz.local);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      weeklySummaryId,
      context != null
          ? (AppLocalizations.of(context)?.weeklyProgressReportTitle ??
              'Weekly Progress Report 📊')
          : 'Weekly Progress Report 📊',
      getWeeklyProgressMessage(context, 0, 0),
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_field_general',
          'General Notifications',
          channelDescription: 'General notifications for Focus Field app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weekly_progress',
    );
  }

  Future<void> cancelScheduledNotifications() async {
    await _flutterLocalNotificationsPlugin.cancel(dailyReminderId);
    await _flutterLocalNotificationsPlugin.cancel(weeklySummaryId);
  }

  /// Triggered externally right before firing weekly summary to compute dynamic content.
  /// For now we expose a method to manually send an updated weekly summary using current data.
  Future<void> showDynamicWeeklySummary(BuildContext context) async {
    if (!enableNotifications ||
        !enableWeeklyProgress ||
        !_hasNotificationPermission) {
      return;
    }
    // Compute sessions in last 7 days
    final nowDt = now();
    final start = nowDt.subtract(const Duration(days: 6));
    final sessions =
        _sessionTimes
            .where(
              (t) =>
                  t.isAfter(DateTime(start.year, start.month, start.day)) &&
                  t.isBefore(nowDt.add(const Duration(days: 1))),
            )
            .toList();
    final sessionsThisWeek =
        sessions
            .map((e) => DateTime(e.year, e.month, e.day))
            .toSet()
            .length; // unique days
    // Simple average score placeholder: minutes per session * 1 (point per min). In absence of full scoring, approximate.
    // Average score placeholder removed to avoid misleading fixed 5 min assumption.
    const avg =
        0; // TODO: compute real average session duration once durations are tracked here.
    await showWeeklyProgress(context, sessionsThisWeek, avg);
  }

  // Enhanced reminder messages based on user engagement
  String getSmartReminderMessage(BuildContext? context) {
    final streak = getCurrentStreak();
    final sessionCount = _sessionTimes.length;
    final l = context != null ? AppLocalizations.of(context) : null;

    if (streak == 0 && sessionCount == 0) {
      return l?.reminderStartJourney ??
          '🎯 Start your focus journey today! Build your deep work habit.';
    }

    if (streak == 0 && sessionCount > 0) {
      return l?.reminderRestart ??
          '🌱 Ready to restart your focus practice? Every moment is a new beginning.';
    }

    if (streak == 1) {
      return l?.reminderDayTwo ??
          '⭐ Day 2 of your focus streak! Consistency builds concentration.';
    }

    if (streak < 7) {
      return l?.reminderStreakShort(streak) ??
          '🔥 $streak-day streak! You\'re building a powerful focus habit.';
    }

    if (streak < 30) {
      return l?.reminderStreakMedium(streak) ??
          '🏆 Amazing $streak-day streak! Your dedication is inspiring.';
    }

    return l?.reminderStreakLong(streak) ??
        '👑 Incredible $streak-day streak! You\'re a focus champion!';
  }

  // Achievement notification messages
  String getAchievementMessage(BuildContext? context, String achievement) {
    switch (achievement) {
      case 'first_session':
        return AppLocalizations.of(context!)?.achievementFirstSession ??
            '🎉 First session complete! Welcome to Focus Field!';
      case 'week_streak':
        return AppLocalizations.of(context!)?.achievementWeekStreak ??
            '🌟 7-day streak achieved! Consistency is your superpower!';
      case 'month_streak':
        return AppLocalizations.of(context!)?.achievementMonthStreak ??
            '🏆 30-day streak unlocked! You\'re unstoppable!';
      case 'perfect_session':
        return AppLocalizations.of(context!)?.achievementPerfectSession ??
            '✨ Perfect session! 100% calm environment maintained!';
      case 'long_session':
        return AppLocalizations.of(context!)?.achievementLongSession ??
            '⏰ Extended session master! Your focus grows stronger.';
      default:
        return AppLocalizations.of(context!)?.achievementGeneric ??
            '🎊 Achievement unlocked! Keep up the great work!';
    }
  }

  // Weekly progress summary
  String getWeeklyProgressMessage(
    BuildContext? context,
    int sessionsThisWeek,
    int averageScore,
  ) {
    if (sessionsThisWeek == 0) {
      return AppLocalizations.of(context!)?.weeklyProgressNone ??
          '💭 Start your weekly goal! Ready for a focused session?';
    }

    if (sessionsThisWeek < 3) {
      return AppLocalizations.of(
            context!,
          )?.weeklyProgressFew(sessionsThisWeek) ??
          '🌿 $sessionsThisWeek focus minutes this week! Every session counts.';
    }

    if (sessionsThisWeek < 7) {
      return AppLocalizations.of(
            context!,
          )?.weeklyProgressSome(sessionsThisWeek) ??
          '🌊 $sessionsThisWeek focus minutes earned! You\'re on track!';
    }

    return AppLocalizations.of(
          context!,
        )?.weeklyProgressPerfect(sessionsThisWeek) ??
        '🎯 $sessionsThisWeek focus minutes achieved! Perfect week!';
  }

  bool _isInTestEnvironment() {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  String? _platformTimeZoneName() {
    try {
      // Basic heuristic; could integrate native channel for accuracy
      return DateTime.now().timeZoneName;
    } catch (_) {
      return null;
    }
  }
}
