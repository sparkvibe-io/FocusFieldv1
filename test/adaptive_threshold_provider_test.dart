import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';

import 'package:focus_field/providers/ambient_quest_provider.dart';
import 'package:focus_field/providers/silence_provider.dart';

void main() {
  group('adaptiveThresholdProvider', () {
    ProviderContainer makeContainer() => ProviderContainer();

  Map<String, dynamic> sessionJson({
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
      // ensure a clean prefs for every test
      SharedPreferences.setMockInitialValues({});
    });

    test('suggests -2 dB after 3 consecutive wins', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final list = [
  sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.90),
  sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
  sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
      ];
      final container = makeContainer();
      // Write test data via the app's storage service to avoid stale static prefs
      final storage = await container.read(storageServiceProvider.future);
      // Clear cooldown keys to avoid interference across tests
      await storage.setString('ambient_adaptive_last_suggest_ms', '');
      await storage.setString('ambient_adaptive_last_applied_ms', '');
      await storage.setString('ambient_sessions_list', jsonEncode(list));
      await storage.saveAllSettings({'decibelThreshold': 40.0});
      await container.read(appSettingsProvider.future);
      final suggestion = await container.read(adaptiveThresholdProvider.future);
      expect(suggestion, 38); // 40 - 2
    });

    test('suggests +2 dB after 3 consecutive losses', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final list = [
  sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.30),
  sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.40),
  sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.45),
      ];
      final container = makeContainer();
      final storage = await container.read(storageServiceProvider.future);
      // Clear cooldown keys to avoid interference across tests
      await storage.setString('ambient_adaptive_last_suggest_ms', '');
      await storage.setString('ambient_adaptive_last_applied_ms', '');
  await storage.setString('ambient_adaptive_last_dir', 'up'); // ensure not reversing so base streak applies
      await storage.setString('ambient_sessions_list', jsonEncode(list));
      await storage.saveAllSettings({'decibelThreshold': 40.0});
      await container.read(appSettingsProvider.future);
      final suggestion = await container.read(adaptiveThresholdProvider.future);
      expect(suggestion, 42); // 40 + 2
    });

    test('no suggestion when mixed/neutral', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final list = [
  sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.75), // neutral
  sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
  sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
      ];
      final container = makeContainer();
      final storage = await container.read(storageServiceProvider.future);
      // Clear cooldown keys to avoid interference across tests
      await storage.setString('ambient_adaptive_last_suggest_ms', '');
      await storage.setString('ambient_adaptive_last_applied_ms', '');
      await storage.setString('ambient_sessions_list', jsonEncode(list));
      await storage.saveAllSettings({'decibelThreshold': 40.0});
      await container.read(appSettingsProvider.future);
      final suggestion = await container.read(adaptiveThresholdProvider.future);
      expect(suggestion, isNull);
    });
  });
}
