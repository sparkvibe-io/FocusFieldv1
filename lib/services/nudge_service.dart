import '../services/storage_service.dart';
import 'dart:math' as math;

/// NudgeService provides gentle encouragement and celebration messages
/// Limited to max 3 nudges per day to avoid overwhelming users
class NudgeService {
  final StorageService _storage;
  static const int maxNudgesPerDay = 3;
  static const String _nudgeCountKey = 'nudge_count';
  static const String _nudgeDateKey = 'nudge_date';

  NudgeService(this._storage);

  /// Check if we can send a nudge today
  Future<bool> canSendNudge() async {
    final today = _getToday();
    final lastDate = await _storage.getString(_nudgeDateKey);
    final count = await _storage.getInt(_nudgeCountKey) ?? 0;

    // Reset count if it's a new day
    if (lastDate != today) {
      await _storage.setInt(_nudgeCountKey, 0);
      await _storage.setString(_nudgeDateKey, today);
      return true;
    }

    return count < maxNudgesPerDay;
  }

  /// Record that a nudge was sent
  Future<void> recordNudge() async {
    final today = _getToday();
    final lastDate = await _storage.getString(_nudgeDateKey);
    final count = await _storage.getInt(_nudgeCountKey) ?? 0;

    if (lastDate != today) {
      await _storage.setInt(_nudgeCountKey, 1);
      await _storage.setString(_nudgeDateKey, today);
    } else {
      await _storage.setInt(_nudgeCountKey, count + 1);
    }
  }

  /// Get a celebration message for streak milestones
  Future<String?> getCelebrationMessage(int currentStreak) async {
    if (!await canSendNudge()) return null;

    // Celebrate specific milestones
    if (currentStreak == 3) {
      await recordNudge();
      return '🎉 3-day streak! You\'re building momentum.';
    } else if (currentStreak == 7) {
      await recordNudge();
      return '⭐ One week strong! Your focus is impressive.';
    } else if (currentStreak == 14) {
      await recordNudge();
      return '🔥 Two weeks! You\'re on fire!';
    } else if (currentStreak == 30) {
      await recordNudge();
      return '🏆 30 days! This is a true habit now.';
    } else if (currentStreak % 50 == 0 && currentStreak > 0) {
      await recordNudge();
      return '💎 ${currentStreak} days! Legendary commitment.';
    }

    return null;
  }

  /// Get an encouragement message for daily practice
  Future<String?> getEncouragementMessage({
    required int sessionsToday,
    required int totalSessions,
    required int currentStreak,
  }) async {
    if (!await canSendNudge()) return null;

    final messages = <String>[];

    // First session encouragement
    if (sessionsToday == 0 && totalSessions > 5) {
      messages.add('Ready for today\'s focus session?');
      messages.add('A few quiet minutes can make all the difference.');
      messages.add('Your focused moments await.');
    }

    // Progress encouragement
    if (sessionsToday == 1 && currentStreak >= 3) {
      messages.add('Great start! One more session to keep the momentum.');
      messages.add('You\'re in the zone today!');
    }

    // Streak protection
    if (currentStreak >= 5 && sessionsToday == 0) {
      messages.add('Protect your ${currentStreak}-day streak with a quick session.');
    }

    if (messages.isEmpty) return null;

    await recordNudge();
    return messages[math.Random().nextInt(messages.length)];
  }

  /// Get a gentle reminder for users who haven't practiced recently
  Future<String?> getGentleReminder({
    required int daysSinceLastSession,
    required int previousStreak,
  }) async {
    if (!await canSendNudge()) return null;
    if (daysSinceLastSession < 2) return null; // Only after 2+ days away

    final messages = <String>[];

    if (previousStreak > 0) {
      messages.add('Your ${previousStreak}-day streak is waiting for you.');
      messages.add('Ready to rebuild your practice?');
    } else {
      messages.add('A moment of quiet can reset your day.');
      messages.add('Your focus field is always here when you need it.');
    }

    await recordNudge();
    return messages[math.Random().nextInt(messages.length)];
  }

  /// Get today's date as a string (YYYY-MM-DD)
  String _getToday() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Get remaining nudges for today
  Future<int> getRemainingNudges() async {
    final today = _getToday();
    final lastDate = await _storage.getString(_nudgeDateKey);
    final count = await _storage.getInt(_nudgeCountKey) ?? 0;

    if (lastDate != today) {
      return maxNudgesPerDay;
    }

    return math.max(0, maxNudgesPerDay - count);
  }

  /// Reset nudge count (for testing or admin purposes)
  Future<void> resetNudgeCount() async {
    await _storage.setInt(_nudgeCountKey, 0);
    await _storage.setString(_nudgeDateKey, _getToday());
  }
}
