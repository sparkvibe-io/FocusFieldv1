import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/services/notification_service.dart';

void main() {
  group('NotificationService.shouldSendDailyReminder', () {
    late NotificationService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = NotificationService();
      await service.initialize(nowProvider: () => DateTime(2025, 8, 30, 10, 0));
      // Ensure settings state
      service.updateSettings(notifications: true, dailyReminders: true);
    });

    test('returns false when no sessions recorded', () async {
      service.setSessionTimes([]); // ensure empty
      final result = await service.shouldSendDailyReminder();
      expect(result, isFalse);
    });

    test('returns true when within 30 min window of optimal time', () async {
      // Simulate sessions around 9:00
      final base = DateTime(2025, 8, 28, 9, 0);
      for (int i = 0; i < 5; i++) {
        await service.recordSessionTime(base.add(Duration(days: i)));
      }
      // nowProvider set to 10:00 which is within 60 min; adjust to 9:15 to ensure window
      service.now = () => DateTime(2025, 8, 30, 9, 20);
      final result = await service.shouldSendDailyReminder();
      expect(result, isTrue);
    });

    test('returns false when outside 30 min window', () async {
      final base = DateTime(2025, 8, 28, 9, 0);
      for (int i = 0; i < 5; i++) {
        await service.recordSessionTime(base.add(Duration(days: i)));
      }
      service.now = () => DateTime(2025, 8, 30, 12, 0); // far from 9am
      final result = await service.shouldSendDailyReminder();
      expect(result, isFalse);
    });

    test('returns false if already sent today', () async {
      final base = DateTime(2025, 8, 28, 9, 0);
      for (int i = 0; i < 5; i++) {
        await service.recordSessionTime(base.add(Duration(days: i)));
      }
      service.now = () => DateTime(2025, 8, 30, 9, 10);
      expect(await service.shouldSendDailyReminder(), isTrue);
      await service.markReminderSent();
      // second check same day -> false
      expect(await service.shouldSendDailyReminder(), isFalse);
    });
  });
}
