import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/providers/silence_provider.dart';

/// Activity types for Phase 1
const activityTypes = <String>[
  'studying',
  'reading',
  'work',
  'meditation',
  'family',
  'fitness',
  'noise',
];

final selectedActivityProvider = StateNotifierProvider<SelectedActivityController, String>((ref) {
  return SelectedActivityController(ref);
});

class SelectedActivityController extends StateNotifier<String> {
  final Ref _ref;
  SelectedActivityController(this._ref) : super('studying') {
    _load();
  }

  Future<void> _load() async {
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      final v = await storage.getString(AppConstants.selectedActivityKey);
      if (v != null && v.isNotEmpty) state = v;
    } catch (_) {}
  }

  Future<void> set(String activity) async {
    state = activity;
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      await storage.setString(AppConstants.selectedActivityKey, activity);
    } catch (_) {}
  }
}

/// Tracks if the first 1-minute micro-goal has been celebrated for a given mission-day.
final firstMicroCelebratedProvider = FutureProvider.family<bool, String>((ref, missionDayKey) async {
  final storage = await ref.read(storageServiceProvider.future);
  final key = AppConstants.firstMicroCelebratedPrefix + missionDayKey;
  final val = await storage.getBool(key);
  return val ?? false;
});

final firstMicroCelebratedControllerProvider = Provider<FirstMicroCelebratedController>((ref) {
  return FirstMicroCelebratedController(ref);
});

class FirstMicroCelebratedController {
  final Ref _ref;
  FirstMicroCelebratedController(this._ref);

  Future<void> markCelebrated(String missionDayKey) async {
    final storage = await _ref.read(storageServiceProvider.future);
    final key = AppConstants.firstMicroCelebratedPrefix + missionDayKey;
    await storage.setBool(key, true);
  }
}
