import 'package:flutter/material.dart';
import '../models/weekly_recap.dart';
import '../models/silence_data.dart';
import '../services/storage_service.dart';
import 'dart:convert';

/// Service for generating and storing weekly recaps
class WeeklyRecapService {
  final StorageService _storage;
  static const String _lastRecapDateKey = 'last_recap_date';
  static const String _recapHistoryKey = 'recap_history';

  WeeklyRecapService(this._storage);

  /// Generate a weekly recap for the most recent week
  Future<WeeklyRecap> generateWeeklyRecap({
    required SilenceData silenceData,
  }) async {
    final now = DateTime.now();
    final weekStart = _getWeekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Get sessions from the past week
    final weekSessions = silenceData.sessions.where((s) =>
        s.timestamp.isAfter(weekStart) && s.timestamp.isBefore(weekEnd)).toList();

    // Calculate streak at start and end of week
    final streakAtEnd = silenceData.currentStreak;
    final streakAtStart = _calculateStreakAtDate(silenceData, weekStart);

    final recap = WeeklyRecap.fromSessions(
      sessions: weekSessions,
      weekStart: weekStart,
      initialStreak: streakAtStart,
      finalStreak: streakAtEnd,
    );

    // Save the recap
    await _saveRecap(recap);
    await _storage.setString(_lastRecapDateKey, now.toIso8601String());

    return recap;
  }

  /// Check if a recap is due (weekly on chosen day)
  Future<bool> isRecapDue() async {
    final lastRecapStr = await _storage.getString(_lastRecapDateKey);
    if (lastRecapStr == null) return true;

    final lastRecap = DateTime.parse(lastRecapStr);
    final now = DateTime.now();
    final daysSinceLastRecap = now.difference(lastRecap).inDays;

    return daysSinceLastRecap >= 7;
  }

  /// Get the most recent recap
  Future<WeeklyRecap?> getLatestRecap() async {
    final historyJson = await _storage.getString(_recapHistoryKey);
    if (historyJson == null) return null;

    final List<dynamic> history = json.decode(historyJson);
    if (history.isEmpty) return null;

    return WeeklyRecap.fromJson(history.last);
  }

  /// Get all recap history
  Future<List<WeeklyRecap>> getRecapHistory() async {
    final historyJson = await _storage.getString(_recapHistoryKey);
    if (historyJson == null) return [];

    final List<dynamic> history = json.decode(historyJson);
    return history.map((json) => WeeklyRecap.fromJson(json)).toList();
  }

  /// Save a recap to history
  Future<void> _saveRecap(WeeklyRecap recap) async {
    final history = await getRecapHistory();
    history.add(recap);

    // Keep only last 12 weeks
    if (history.length > 12) {
      history.removeRange(0, history.length - 12);
    }

    final historyJson = json.encode(history.map((r) => r.toJson()).toList());
    await _storage.setString(_recapHistoryKey, historyJson);
  }

  /// Calculate what the streak was at a specific date
  int _calculateStreakAtDate(SilenceData data, DateTime targetDate) {
    // This is an approximation - we count back from current streak
    // A more accurate implementation would track daily completion history
    final daysSince = DateTime.now().difference(targetDate).inDays;
    return (data.currentStreak - daysSince).clamp(0, data.currentStreak);
  }

  /// Get the start of the current week (Monday)
  DateTime _getWeekStart(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Format recap as a notification message
  String formatNotificationMessage(WeeklyRecap recap) {
    if (recap.totalSessions == 0) {
      return 'Weekly Recap: Start your focus journey this week!';
    }

    final parts = <String>[];
    parts.add('${recap.totalSessions} sessions');
    parts.add('${recap.totalPoints} points');

    if (recap.achievements.isNotEmpty) {
      parts.add('${recap.achievements.length} achievements');
    }

    return 'Weekly Recap: ${parts.join(' • ')}. ${recap.personalizedMessage}';
  }
}
