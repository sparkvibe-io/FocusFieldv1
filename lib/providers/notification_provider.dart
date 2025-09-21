import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/services/notification_service.dart';
import 'package:focus_field/providers/silence_provider.dart';

// Notification service provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Individual notification setting providers
final enableNotificationsProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableNotifications'] as bool? ?? true,
    loading: () => true,
    error: (_, __) => true,
  );
});

final enableDailyRemindersProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableDailyReminders'] as bool? ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

final enableSessionCompleteProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableSessionComplete'] as bool? ?? true,
    loading: () => true,
    error: (_, __) => true,
  );
});

final enableAchievementNotificationsProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableAchievementNotifications'] as bool? ?? true,
    loading: () => true,
    error: (_, __) => true,
  );
});

final enableWeeklyProgressProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return settings.when(
    data: (data) => data['enableWeeklyProgress'] as bool? ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

// Combined notification settings provider
final notificationSettingsProvider = Provider<Map<String, bool>>((ref) {
  return {
    'enableNotifications': ref.watch(enableNotificationsProvider),
    'enableDailyReminders': ref.watch(enableDailyRemindersProvider),
    'enableSessionComplete': ref.watch(enableSessionCompleteProvider),
    'enableAchievementNotifications': ref.watch(
      enableAchievementNotificationsProvider,
    ),
    'enableWeeklyProgress': ref.watch(enableWeeklyProgressProvider),
  };
});
