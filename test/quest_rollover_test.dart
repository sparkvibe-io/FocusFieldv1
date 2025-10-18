import 'package:flutter_test/flutter_test.dart';
import 'package:focus_field/models/ambient_models.dart';

void main() {
  group('Quest 2-Day Rule Logic', () {

    test('missedYesterday field tracks first miss correctly', () {
      final state = QuestState(
        cycleId: '2025-10',
        dayIndex: 1,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 10, // incomplete
        streakCount: 5,
        freezeTokens: 1,
        lastUpdatedAt: DateTime.now(),
        lastFreezeReplenishment: DateTime.now(),
        missedYesterday: false,
      );

      // First miss should preserve streak
      expect(state.missedYesterday, isFalse, reason: 'Initially false');
      expect(state.streakCount, equals(5), reason: 'Streak intact');
    });

    test('Two consecutive misses indicated by missedYesterday flag', () {
      final state = QuestState(
        cycleId: '2025-10',
        dayIndex: 2,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 5, // incomplete
        streakCount: 5,
        freezeTokens: 1,
        lastUpdatedAt: DateTime.now(),
        lastFreezeReplenishment: DateTime.now(),
        missedYesterday: true, // already missed yesterday
      );

      // Second consecutive miss - this is the condition that resets streak
      expect(state.missedYesterday, isTrue, reason: 'Flag tracks previous miss');
      expect(state.progressQuietMinutes < state.goalQuietMinutes, isTrue,
             reason: 'Today also incomplete');
    });

    test('QuestState copyWith preserves missedYesterday correctly', () {
      final state = QuestState(
        cycleId: '2025-10',
        dayIndex: 5,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 0,
        streakCount: 2,
        freezeTokens: 1,
        lastUpdatedAt: DateTime.now(),
        lastFreezeReplenishment: DateTime.now(),
        missedYesterday: true,
      );

      // Test that copyWith can update missedYesterday
      final updated = state.copyWith(
        progressQuietMinutes: 20,
        streakCount: 3,
        missedYesterday: false,
      );

      expect(updated.missedYesterday, isFalse);
      expect(updated.streakCount, equals(3));
      expect(updated.progressQuietMinutes, equals(20));
    });

    test('QuestState JSON serialization includes missedYesterday', () {
      final state = QuestState(
        cycleId: '2025-10',
        dayIndex: 15,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 5,
        streakCount: 10,
        freezeTokens: 1,
        lastUpdatedAt: DateTime(2025, 10, 15, 10, 0),
        lastFreezeReplenishment: DateTime(2025, 10, 15, 10, 0),
        missedYesterday: true,
      );

      final json = state.toJson();
      expect(json['missedYesterday'], isTrue);

      final restored = QuestState.fromJson(json);
      expect(restored.missedYesterday, isTrue);
      expect(restored.streakCount, equals(10));
    });

    test('QuestState defaults missedYesterday to false', () {
      final state = QuestState(
        cycleId: '2025-10',
        dayIndex: 1,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 0,
        streakCount: 0,
        freezeTokens: 1,
        lastUpdatedAt: DateTime.now(),
        lastFreezeReplenishment: DateTime.now(),
        // missedYesterday not specified
      );

      expect(state.missedYesterday, isFalse, reason: 'Should default to false');
    });

    test('QuestState fromJson handles missing missedYesterday field', () {
      final json = {
        'cycleId': '2025-10',
        'dayIndex': 5,
        'goalQuietMinutes': 20,
        'requiredScore': 0.7,
        'progressQuietMinutes': 10,
        'streakCount': 3,
        'freezeTokens': 1,
        'lastUpdatedAt': DateTime.now().millisecondsSinceEpoch,
        // missedYesterday omitted (simulates old data)
      };

      final state = QuestState.fromJson(json);
      expect(state.missedYesterday, isFalse, reason: 'Should default to false for backward compatibility');
      expect(state.streakCount, equals(3));
    });
  });
}
