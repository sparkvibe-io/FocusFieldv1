import 'package:flutter_test/flutter_test.dart';
import 'package:focus_field/models/user_preferences.dart';

void main() {
  group('Wake Lock User Preferences', () {
    test('keepScreenOn defaults to true', () {
      final prefs = UserPreferences.defaults();
      expect(prefs.keepScreenOn, true);
    });

    test('keepScreenOn can be disabled', () {
      final prefs = UserPreferences.defaults().copyWith(keepScreenOn: false);
      expect(prefs.keepScreenOn, false);
    });

    test('keepScreenOn serializes to JSON correctly', () {
      final prefs = UserPreferences.defaults();
      final json = prefs.toJson();
      expect(json['keepScreenOn'], true);
    });

    test('keepScreenOn deserializes from JSON correctly', () {
      final json = {
        'enabledProfiles': ['study', 'reading', 'meditation'],
        'globalDailyQuietGoalMinutes': 10,
        'lastDurationByProfile': <String, int>{},
        'keepScreenOn': false,
      };
      final prefs = UserPreferences.fromJson(json);
      expect(prefs.keepScreenOn, false);
    });

    test('keepScreenOn defaults to true when missing from JSON', () {
      final json = {
        'enabledProfiles': ['study', 'reading', 'meditation'],
        'globalDailyQuietGoalMinutes': 10,
        'lastDurationByProfile': <String, int>{},
      };
      final prefs = UserPreferences.fromJson(json);
      expect(prefs.keepScreenOn, true);
    });

    test('keepScreenOn persists through copyWith', () {
      final prefs1 = UserPreferences.defaults();
      final prefs2 = prefs1.copyWith(keepScreenOn: false);
      final prefs3 = prefs2.copyWith(globalDailyQuietGoalMinutes: 20);

      expect(prefs1.keepScreenOn, true);
      expect(prefs2.keepScreenOn, false);
      expect(prefs3.keepScreenOn, false);
    });
  });
}
