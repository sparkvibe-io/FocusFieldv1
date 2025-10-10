import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';

import 'package:focus_field/providers/ambient_quest_provider.dart';
import 'package:focus_field/providers/silence_provider.dart';

void main() {
  group('adaptiveThresholdProvider hysteresis', () {
    ProviderContainer makeContainer() => ProviderContainer();

    Map<String, dynamic> _sessionJson({
      required String id,
      required int endedAtMs,
      required double ambientScore,
    }) {
      final startedAtMs = endedAtMs - 60 * 1000;
      return {
        'id': id,
        'profileId': 'study',
        'plannedSeconds': 60,
        'actualSeconds': 60,
        'startedAt': startedAtMs,
        'endedAt': endedAtMs,
        'quietSeconds': (ambientScore * 60).round(),
        'violations': 0,
        'ambientScore': ambientScore,
        'motionSamples': null,
        'notes': null,
        'exportedToCalendar': false,
        'syncedToHealth': false,
      };
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('requires extra proof when reversing suggestion direction', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final container = makeContainer();
      final storage = await container.read(storageServiceProvider.future);
      // Last suggestion was upward (environment too strict)
      await storage.setString('ambient_adaptive_last_dir', 'up');
      // Clear cooldown
      await storage.setString('ambient_adaptive_last_suggest_ms', '');
      await storage.setString('ambient_adaptive_last_applied_ms', '');
      await storage.saveAllSettings({'decibelThreshold': 40.0});

      // Only 3 wins should NOT be enough now due to reverse bonus; use wins only
      final list3Wins = [
        _sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.90),
        _sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
        _sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
      ];
      await storage.setString('ambient_sessions_list', jsonEncode(list3Wins));
      await container.read(appSettingsProvider.future);
      final suggestion3 = await container.read(adaptiveThresholdProvider.future);
      expect(suggestion3, isNull, reason: '3 wins should be insufficient when reversing direction');

      // With 4 wins (base 3 + reverse bonus 1), suggestion should occur
      final list4Wins = [
        _sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.90),
        _sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
        _sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
        _sessionJson(id: 'd', endedAtMs: now - 180000, ambientScore: 0.91),
      ];
      await storage.setString('ambient_sessions_list', jsonEncode(list4Wins));
  final container2 = ProviderContainer();
  final storage2 = await container2.read(storageServiceProvider.future);
  await storage2.setString('ambient_adaptive_last_suggest_ms', '');
  final suggestion4 = await container2.read(adaptiveThresholdProvider.future);
      expect(suggestion4, 38); // 40 - 2
    });

    test('no extra proof required when not reversing direction', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final container = makeContainer();
      final storage = await container.read(storageServiceProvider.future);
      // No previous direction recorded
      await storage.setString('ambient_adaptive_last_dir', '');
      await storage.setString('ambient_adaptive_last_suggest_ms', '');
      await storage.setString('ambient_adaptive_last_applied_ms', '');
      await storage.saveAllSettings({'decibelThreshold': 40.0});

      final list3Wins = [
        _sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.90),
        _sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
        _sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
      ];
      await storage.setString('ambient_sessions_list', jsonEncode(list3Wins));
      await container.read(appSettingsProvider.future);
      final suggestion = await container.read(adaptiveThresholdProvider.future);
      expect(suggestion, 38);
    });
  });
}
