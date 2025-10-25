import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';

import 'package:focus_field/providers/ambient_quest_provider.dart';
import 'package:focus_field/providers/silence_provider.dart';

void main() {
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
    SharedPreferences.setMockInitialValues({});
  });

  test('no suggestion within 24h cooldown after last suggestion', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final list = [
  sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.90),
  sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.92),
  sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.88),
    ];
    final container = makeContainer();
    final storage = await container.read(storageServiceProvider.future);
    await storage.setString('ambient_sessions_list', jsonEncode(list));
    await storage.saveAllSettings({'decibelThreshold': 40.0});
  // Set last suggestion to 1 hour ago
  final oneHourAgo = (DateTime.now().millisecondsSinceEpoch - 3600 * 1000).toString();
  await storage.setString('ambient_adaptive_last_suggest_ms', oneHourAgo);
  await storage.setString('ambient_adaptive_last_applied_ms', '');

    await container.read(appSettingsProvider.future);
    final suggestion = await container.read(adaptiveThresholdProvider.future);
    expect(suggestion, isNull);
  });

  test('suggestion allowed after 24h cooldown has elapsed', () async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final list = [
  sessionJson(id: 'a', endedAtMs: now, ambientScore: 0.30),
  sessionJson(id: 'b', endedAtMs: now - 60000, ambientScore: 0.40),
  sessionJson(id: 'c', endedAtMs: now - 120000, ambientScore: 0.45),
    ];
    final container = makeContainer();
    final storage = await container.read(storageServiceProvider.future);
    await storage.setString('ambient_sessions_list', jsonEncode(list));
    await storage.saveAllSettings({'decibelThreshold': 40.0});
  // Clear cooldown and set last event to 25 hours ago to ensure cooldown expired
  final twentyFiveHoursAgo = (DateTime.now().millisecondsSinceEpoch - 25 * 3600 * 1000).toString();
  await storage.setString('ambient_adaptive_last_suggest_ms', twentyFiveHoursAgo);
  await storage.setString('ambient_adaptive_last_applied_ms', '');

    await container.read(appSettingsProvider.future);
    final suggestion = await container.read(adaptiveThresholdProvider.future);
    expect(suggestion, 42); // 40 + 2
  });
}
