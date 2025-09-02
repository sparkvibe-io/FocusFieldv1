import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:silence_score/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Weekly scheduling', () {
    late NotificationService service;
    late List<Map<String, dynamic>> captured;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = NotificationService();
      captured = [];
      service.onZonedSchedule = ({
        required int id,
        required DateTime scheduled,
        required DateTimeComponents? match,
      }) {
        captured.add({'id': id, 'scheduled': scheduled, 'match': match});
      };
      await service.initialize(nowProvider: () => DateTime(2025, 8, 30, 10));
      service.forcePermissionGranted();
      service.updateSettings(
        notifications: true,
        weeklyProgress: true,
        weeklyWeekday: DateTime.friday,
        weeklyHour: 12,
        weeklyMinute: 0,
      );
    });

    test('schedules weekly summary on chosen weekday/time', () async {
      await service.scheduleWeeklySummaryNotification();
      expect(captured.length, 1);
      final call = captured.first;
      expect(call['id'], NotificationService.weeklySummaryId);
      expect((call['scheduled'] as DateTime).hour, 12);
      expect(call['match'], DateTimeComponents.dayOfWeekAndTime);
    });
  });
}
