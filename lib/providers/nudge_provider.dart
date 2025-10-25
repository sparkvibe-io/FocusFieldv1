import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/nudge_service.dart';
import '../providers/silence_provider.dart';

/// Provider for the NudgeService
final nudgeServiceProvider = Provider<NudgeService>((ref) {
  final storage = ref.watch(storageServiceProvider).requireValue;
  return NudgeService(storage);
});

/// Provider to check if a celebration is due based on current streak
final celebrationMessageProvider = FutureProvider.autoDispose<String?>((ref) async {
  final nudgeService = ref.watch(nudgeServiceProvider);
  final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

  final silenceData = silenceDataAsync.valueOrNull;
  if (silenceData == null) return null;

  return await nudgeService.getCelebrationMessage(silenceData.currentStreak);
});

/// Provider to get encouragement messages
final encouragementMessageProvider = FutureProvider.autoDispose<String?>((ref) async {
  final nudgeService = ref.watch(nudgeServiceProvider);
  final silenceDataAsync = ref.watch(silenceDataNotifierProvider);

  final silenceData = silenceDataAsync.valueOrNull;
  if (silenceData == null) return null;

  // Count today's sessions
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final sessionsToday = silenceData.recentSessions
      .where((s) =>
          DateTime(s.date.year, s.date.month, s.date.day) == today)
      .length;

  return await nudgeService.getEncouragementMessage(
    sessionsToday: sessionsToday,
    totalSessions: silenceData.totalSessions,
    currentStreak: silenceData.currentStreak,
  );
});

/// Provider to get remaining nudge count for today
final remainingNudgesProvider = FutureProvider.autoDispose<int>((ref) async {
  final nudgeService = ref.watch(nudgeServiceProvider);
  return await nudgeService.getRemainingNudges();
});
