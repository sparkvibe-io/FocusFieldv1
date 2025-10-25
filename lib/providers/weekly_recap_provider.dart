import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/weekly_recap_service.dart';
import '../models/weekly_recap.dart';
import '../providers/silence_provider.dart';

/// Provider for the WeeklyRecapService
final weeklyRecapServiceProvider = Provider<WeeklyRecapService>((ref) {
  final storage = ref.watch(storageServiceProvider).requireValue;
  return WeeklyRecapService(storage);
});

/// Provider to check if weekly recap is due
final isWeeklyRecapDueProvider = FutureProvider.autoDispose<bool>((ref) async {
  final recapService = ref.watch(weeklyRecapServiceProvider);
  return await recapService.isRecapDue();
});

/// Provider to get the latest weekly recap
final latestWeeklyRecapProvider = FutureProvider.autoDispose<WeeklyRecap?>((ref) async {
  final recapService = ref.watch(weeklyRecapServiceProvider);
  return await recapService.getLatestRecap();
});

/// Provider to generate a new weekly recap
final generateWeeklyRecapProvider = FutureProvider.family.autoDispose<WeeklyRecap, void>(
  (ref, _) async {
    final recapService = ref.watch(weeklyRecapServiceProvider);
    final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

    final silenceData = silenceDataAsync.valueOrNull;
    if (silenceData == null) {
      throw Exception('Silence data not available');
    }

    return await recapService.generateWeeklyRecap(silenceData: silenceData);
  },
);

/// Provider to get recap history
final weeklyRecapHistoryProvider = FutureProvider.autoDispose<List<WeeklyRecap>>((ref) async {
  final recapService = ref.watch(weeklyRecapServiceProvider);
  return await recapService.getRecapHistory();
});

/// Helper to trigger weekly recap notification
Future<void> triggerWeeklyRecapNotification(WidgetRef ref) async {
  final recapService = ref.read(weeklyRecapServiceProvider);
  final silenceDataAsync = ref.read(silenceDataNotifierProvider);

  final silenceData = silenceDataAsync.valueOrNull;
  if (silenceData == null) {
    return; // Cannot generate recap without data
  }

  // Generate the recap
  await recapService.generateWeeklyRecap(silenceData: silenceData);

  // Format as notification message (for future notification integration)
  // This function is currently experimental and not actively used
  // The NotificationService.showWeeklyProgress already handles this,
  // but we could extend it to use our new recap data in the future

  return;
}
