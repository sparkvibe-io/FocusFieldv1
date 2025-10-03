import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/models/mission.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:focus_field/constants/app_constants.dart';

final missionProvider = Provider<Mission?>((ref) {
  if (!AppConstants.featureMissionsUi) return null;
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 30));
  return Mission(
    id: 'mission-${start.toIso8601String()}',
    startDate: start,
    endDate: end,
    goals: const [
      ActivityGoal(type: 'studying', dailyMinutes: 1),
      ActivityGoal(type: 'reading', dailyMinutes: 1),
    ],
  );
});

final missionProgressProvider = Provider<int>((ref) {
  // Count micro-sessions (<= 5 min) in recent history as progress units
  final data = ref.watch(silenceDataNotifierProvider);
  return data.when(
    data: (silence) {
      final micro = silence.recentSessions.where((s) => s.duration <= 5 * 60 && s.completed).length;
      return micro;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});
