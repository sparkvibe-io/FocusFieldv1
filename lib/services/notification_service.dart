import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _sessionTimesKey = 'session_times';
  static const String _lastReminderKey = 'last_reminder';
  
  // Flutter Local Notifications
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  // Settings
  bool enableNotifications = true;
  bool enableDailyReminders = false;
  bool enableSessionComplete = true;
  bool enableAchievementNotifications = true;
  bool enableWeeklyProgress = false;
  
  // Permission status
  bool _hasNotificationPermission = false;
  bool _isInitialized = false;
  
  List<DateTime> _sessionTimes = [];

  Future<void> initialize() async {
    if (_isInitialized) return;

    final isTest = _isInTestEnvironment();
    if (!isTest) {
      await _initializeNotifications();
      await _checkNotificationPermission();
    } else {
      if (!kReleaseMode) debugPrint('[NotificationService] Skipping notification plugin init in test environment');
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
  }

  void updateSettings({
    bool? notifications,
    bool? dailyReminders,
    bool? sessionComplete,
    bool? achievementNotifications,
    bool? weeklyProgress,
  }) {
    if (notifications != null) enableNotifications = notifications;
    if (dailyReminders != null) enableDailyReminders = dailyReminders;
    if (sessionComplete != null) enableSessionComplete = sessionComplete;
    if (achievementNotifications != null) enableAchievementNotifications = achievementNotifications;
    if (weeklyProgress != null) enableWeeklyProgress = weeklyProgress;
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
    if (_sessionTimes.isEmpty) return null;
    
    // Group sessions by hour and find the most common
    final hourCounts = <int, int>{};
    
    for (final sessionTime in _sessionTimes) {
      final hour = sessionTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    
    if (hourCounts.isEmpty) return null;
    
    // Find the hour with most sessions
    final mostCommonHour = hourCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    // Calculate average minute for that hour
    final sessionsInHour = _sessionTimes
        .where((time) => time.hour == mostCommonHour)
        .toList();
    
    final averageMinute = sessionsInHour.isEmpty 
        ? 0 
        : (sessionsInHour.map((time) => time.minute).reduce((a, b) => a + b) / sessionsInHour.length).round();
    
    return TimeOfDay(hour: mostCommonHour, minute: averageMinute);
  }

  // Check if we should send a reminder today
  Future<bool> shouldSendDailyReminder() async {
    if (!enableNotifications || !enableDailyReminders) return false;
    
    final prefs = await SharedPreferences.getInstance();
    final lastReminderString = prefs.getString(_lastReminderKey);
    
    if (lastReminderString == null) return true;
    
    final lastReminder = DateTime.parse(lastReminderString);
    final today = DateTime.now();
    
    // Send reminder if it's a new day and past the optimal reminder time
    final isNewDay = lastReminder.day != today.day || 
                     lastReminder.month != today.month || 
                     lastReminder.year != today.year;
    
    if (!isNewDay) return false;
    
    final optimalTime = getOptimalReminderTime();
    if (optimalTime == null) return false;
    
    final now = TimeOfDay.now();
    final optimalMinutes = optimalTime.hour * 60 + optimalTime.minute;
    final currentMinutes = now.hour * 60 + now.minute;
    
    // Send reminder if current time is within 30 minutes of optimal time
    return (currentMinutes - optimalMinutes).abs() <= 30;
  }

  // Mark that we sent a reminder today
  Future<void> markReminderSent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReminderKey, DateTime.now().toIso8601String());
  }

  // Get reminder message based on user's pattern
  String getReminderMessage() {
    final optimalTime = getOptimalReminderTime();
    final sessionCount = _sessionTimes.length;
    
    if (optimalTime == null || sessionCount == 0) {
      return 'Time for your daily silence practice! 🧘‍♂️';
    }
    
    final timeString = '${optimalTime.hour.toString().padLeft(2, '0')}:${optimalTime.minute.toString().padLeft(2, '0')}';
    
    if (sessionCount < 5) {
      return 'Building your silence habit! Ready for today\'s session? 🌱';
    } else if (sessionCount < 15) {
      return 'You usually practice around $timeString. Ready to continue your streak? ⭐';
    } else {
      return 'Your daily $timeString silence session awaits! You\'ve got this! 🏆';
    }
  }

  // Session completion messages
  String getCompletionMessage(bool success, int durationMinutes) {
    if (success) {
      if (durationMinutes >= 5) {
        return 'Excellent! You completed a $durationMinutes-minute silence session! 🏆';
      } else {
        return 'Great job! $durationMinutes minutes of peaceful silence achieved! ✨';
      }
    } else {
      return 'Session incomplete, but every attempt makes you stronger! Try again when ready. 💪';
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
        _sessionTimes = sessionsList
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
    try {
      // For Android 13+ (API 33+), we need to request POST_NOTIFICATIONS permission
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        _hasNotificationPermission = status.isGranted;
        
        // Also request from flutter_local_notifications for iOS-style permissions
        if (status.isGranted) {
          final granted = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
          _hasNotificationPermission = granted ?? false;
        }
      } else {
        // For iOS, use flutter_local_notifications
        final granted = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        _hasNotificationPermission = granted ?? false;
      }
      
      return _hasNotificationPermission;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  Future<void> _checkNotificationPermission() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        _hasNotificationPermission = status.isGranted;
      } else {
        // For iOS, check through flutter_local_notifications
        final granted = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.checkPermissions();
        _hasNotificationPermission = granted?.isEnabled ?? false;
      }
    } catch (e) {
      debugPrint('Error checking notification permission: $e');
      _hasNotificationPermission = false;
    }
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
      'silence_score_general',
      'General Notifications',
      channelDescription: 'General notifications for SilenceScore app',
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
  Future<void> showDailyReminder() async {
    await showNotification(
      title: 'Daily Silence Reminder',
      body: getSmartReminderMessage(),
      payload: 'daily_reminder',
    );
  }

  Future<void> showSessionComplete(bool success, int durationMinutes) async {
    if (!enableSessionComplete) return;
    
    await showNotification(
      title: success ? 'Session Complete! 🎉' : 'Session Ended',
      body: getCompletionMessage(success, durationMinutes),
      payload: 'session_complete',
    );
  }

  Future<void> showAchievement(String achievement) async {
    if (!enableAchievementNotifications) return;
    
    await showNotification(
      title: 'Achievement Unlocked! 🏆',
      body: getAchievementMessage(achievement),
      payload: 'achievement:$achievement',
    );
  }

  Future<void> showWeeklyProgress(int sessionsThisWeek, int averageScore) async {
    if (!enableWeeklyProgress) return;
    
    await showNotification(
      title: 'Weekly Progress Report 📊',
      body: getWeeklyProgressMessage(sessionsThisWeek, averageScore),
      payload: 'weekly_progress',
    );
  }

  bool get hasNotificationPermission => _hasNotificationPermission;

  // Enhanced reminder messages based on user engagement
  String getSmartReminderMessage() {
    final streak = getCurrentStreak();
    final sessionCount = _sessionTimes.length;
    
    if (streak == 0 && sessionCount == 0) {
      return '🧘‍♂️ Start your silence journey today! Find your inner peace.';
    }
    
    if (streak == 0 && sessionCount > 0) {
      return '🌱 Ready to restart your silence practice? Every moment is a new beginning.';
    }
    
    if (streak == 1) {
      return '⭐ Day 2 of your silence streak! Consistency builds tranquility.';
    }
    
    if (streak < 7) {
      return '🔥 $streak-day streak! You\'re building a powerful habit.';
    }
    
    if (streak < 30) {
      return '🏆 Amazing $streak-day streak! Your dedication is inspiring.';
    }
    
    return '👑 Incredible $streak-day streak! You\'re a silence master!';
  }

  // Achievement notification messages
  String getAchievementMessage(String achievement) {
    switch (achievement) {
      case 'first_session':
        return '🎉 First session completed! Welcome to your silence journey!';
      case 'week_streak':
        return '🌟 7-day streak achieved! Consistency is your superpower!';
      case 'month_streak':
        return '🏆 30-day streak unlocked! You\'re unstoppable!';
      case 'perfect_session':
        return '✨ Perfect silence session! Not a sound disturbed your peace.';
      case 'long_session':
        return '⏰ Extended session master! Your focus grows stronger.';
      default:
        return '🎊 Achievement unlocked! Keep up the great work!';
    }
  }

  // Weekly progress summary
  String getWeeklyProgressMessage(int sessionsThisWeek, int averageScore) {
    if (sessionsThisWeek == 0) {
      return '💭 This week could use some silence. Ready for a peaceful session?';
    }
    
    if (sessionsThisWeek < 3) {
      return '🌿 $sessionsThisWeek sessions this week. Every practice deepens your calm.';
    }
    
    if (sessionsThisWeek < 7) {
      return '🌊 $sessionsThisWeek sessions this week! You\'re finding your rhythm.';
    }
    
    return '🎯 Perfect week with $sessionsThisWeek sessions! Your dedication shines.';
  }
  bool _isInTestEnvironment() {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }
}