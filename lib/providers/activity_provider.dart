import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/providers/silence_provider.dart';

/// Maximum free activities allowed (free tier limit)
const int maxFreeActivities = 5;

/// Activity types for Phase 1
enum ActivityType {
  work('work', '💼', true),
  studying('studying', '🎓', true),
  reading('reading', '📖', true),
  meditation('meditation', '🧘', true),
  family('family', '👨‍👩‍👧', false),
  fitness('fitness', '💪', false),
  noise('noise', '🔇', true),
  custom('custom', '✨', false); // Custom activity type

  final String key;
  final String icon;
  final bool requiresSilence;

  const ActivityType(this.key, this.icon, this.requiresSilence);

  static ActivityType fromKey(String key) {
    return ActivityType.values.firstWhere(
      (type) => type.key == key,
      orElse: () => ActivityType.work,
    );
  }
}

/// Custom activity model
class CustomActivity {
  final String id; // Unique identifier
  final String title;
  final int iconCodePoint; // Material icon code point
  final bool requiresSilence;
  final int defaultGoalMinutes;
  final Color color;

  const CustomActivity({
    required this.id,
    required this.title,
    required this.iconCodePoint,
    required this.requiresSilence,
    this.defaultGoalMinutes = 1,
    required this.color,
  });

  // Get IconData from code point
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'iconCodePoint': iconCodePoint,
    'requiresSilence': requiresSilence,
    'defaultGoalMinutes': defaultGoalMinutes,
    'color': color.value,
  };

  factory CustomActivity.fromJson(Map<String, dynamic> json) {
    return CustomActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      iconCodePoint: json['iconCodePoint'] as int? ?? Icons.star.codePoint,
      requiresSilence: json['requiresSilence'] as bool? ?? false,
      defaultGoalMinutes: json['defaultGoalMinutes'] as int? ?? 1,
      color: Color(json['color'] as int? ?? Colors.blue.value),
    );
  }

  CustomActivity copyWith({
    String? id,
    String? title,
    int? iconCodePoint,
    bool? requiresSilence,
    int? defaultGoalMinutes,
    Color? color,
  }) {
    return CustomActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      requiresSilence: requiresSilence ?? this.requiresSilence,
      defaultGoalMinutes: defaultGoalMinutes ?? this.defaultGoalMinutes,
      color: color ?? this.color,
    );
  }
}

/// Legacy activity types list for backward compatibility
const activityTypes = <String>[
  'studying',
  'reading',
  'work',
  'meditation',
  'family',
  'fitness',
  'noise',
];

/// Activity progress tracking model
class ActivityProgress {
  final ActivityType type;
  final CustomActivity? customActivity; // For custom activities
  final int goalMinutes;
  final int completedMinutes;
  final DateTime lastUpdated;

  const ActivityProgress({
    required this.type,
    this.customActivity,
    this.goalMinutes = 1,
    this.completedMinutes = 0,
    required this.lastUpdated,
  });

  bool get isCustom => type == ActivityType.custom && customActivity != null;
  String get displayTitle => isCustom ? customActivity!.title : type.key;
  String get displayIcon => isCustom ? '' : type.icon; // Emoji for built-in types
  IconData? get displayIconData => isCustom ? customActivity!.icon : null; // Icon for custom types
  bool get requiresSilence => isCustom ? customActivity!.requiresSilence : type.requiresSilence;
  String get activityId => isCustom ? 'custom_${customActivity!.id}' : type.key;

  double get progress => goalMinutes == 0 ? 0.0 : (completedMinutes / goalMinutes).clamp(0.0, 1.0);
  bool get isCompleted => completedMinutes >= goalMinutes;
  String get goalIndicator => '$completedMinutes/$goalMinutes';

  ActivityProgress copyWith({
    ActivityType? type,
    CustomActivity? customActivity,
    int? goalMinutes,
    int? completedMinutes,
    DateTime? lastUpdated,
  }) {
    return ActivityProgress(
      type: type ?? this.type,
      customActivity: customActivity ?? this.customActivity,
      goalMinutes: goalMinutes ?? this.goalMinutes,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.key,
    if (customActivity != null) 'customActivity': customActivity!.toJson(),
    'goalMinutes': goalMinutes,
    'completedMinutes': completedMinutes,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory ActivityProgress.fromJson(Map<String, dynamic> json) {
    return ActivityProgress(
      type: ActivityType.fromKey(json['type'] as String),
      customActivity: json['customActivity'] != null
          ? CustomActivity.fromJson(json['customActivity'] as Map<String, dynamic>)
          : null,
      goalMinutes: json['goalMinutes'] as int? ?? 1,
      completedMinutes: json['completedMinutes'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Activity tracking state
class ActivityTrackingState {
  final String selectedActivity;
  final List<ActivityProgress> trackedActivities;
  final bool isLoading;

  const ActivityTrackingState({
    this.selectedActivity = 'studying',
    this.trackedActivities = const [],
    this.isLoading = false,
  });

  ActivityTrackingState copyWith({
    String? selectedActivity,
    List<ActivityProgress>? trackedActivities,
    bool? isLoading,
  }) {
    return ActivityTrackingState(
      selectedActivity: selectedActivity ?? this.selectedActivity,
      trackedActivities: trackedActivities ?? this.trackedActivities,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  ActivityProgress? getProgress(String activityKey) {
    try {
      return trackedActivities.firstWhere(
        (a) => a.type.key == activityKey || a.activityId == activityKey,
      );
    } catch (_) {
      return null;
    }
  }

  bool isTracked(String activityKey) {
    return trackedActivities.any((a) => a.type.key == activityKey);
  }
}

/// Activity tracking provider (enhanced with progress)
final activityTrackingProvider = StateNotifierProvider<ActivityTrackingController, ActivityTrackingState>((ref) {
  return ActivityTrackingController(ref);
});

class ActivityTrackingController extends StateNotifier<ActivityTrackingState> {
  final Ref _ref;

  ActivityTrackingController(this._ref) : super(const ActivityTrackingState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final storage = await _ref.read(storageServiceProvider.future);

      // Load selected activity
      final selected = await storage.getString(AppConstants.selectedActivityKey) ?? 'studying';

      // Load tracked activities with progress
      final trackedJson = await storage.getString('tracked_activities_progress');
      List<ActivityProgress> tracked = [];

      if (trackedJson != null) {
        try {
          final List<dynamic> list = jsonDecode(trackedJson) as List;
          tracked = list.map((json) => ActivityProgress.fromJson(json as Map<String, dynamic>)).toList();
        } catch (_) {
          tracked = _getDefaultActivities();
        }
      } else {
        tracked = _getDefaultActivities();
      }

      state = ActivityTrackingState(
        selectedActivity: selected,
        trackedActivities: tracked,
        isLoading: false,
      );
    } catch (_) {
      state = ActivityTrackingState(
        selectedActivity: 'studying',
        trackedActivities: _getDefaultActivities(),
        isLoading: false,
      );
    }
  }

  List<ActivityProgress> _getDefaultActivities() {
    final now = DateTime.now();
    return [
      ActivityProgress(type: ActivityType.work, lastUpdated: now),
      ActivityProgress(type: ActivityType.studying, lastUpdated: now),
      ActivityProgress(type: ActivityType.reading, lastUpdated: now),
    ];
  }

  Future<void> selectActivity(String activityKey) async {
    state = state.copyWith(selectedActivity: activityKey);
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      await storage.setString(AppConstants.selectedActivityKey, activityKey);
    } catch (_) {}

    // Add to tracked if not already
    if (!state.isTracked(activityKey)) {
      await addActivity(activityKey);
    }
  }

  Future<bool> addActivity(String activityKey, {bool isPremium = false}) async {
    if (state.isTracked(activityKey)) return true;

    // Check free tier limit
    if (!isPremium && state.trackedActivities.length >= maxFreeActivities) {
      return false;
    }

    final type = ActivityType.fromKey(activityKey);
    final newActivity = ActivityProgress(type: type, lastUpdated: DateTime.now());

    state = state.copyWith(trackedActivities: [...state.trackedActivities, newActivity]);
    await _save();
    return true;
  }

  Future<bool> addCustomActivity(CustomActivity customActivity, {bool isPremium = false}) async {
    // Check if a custom activity with the same ID already exists
    final exists = state.trackedActivities.any(
      (a) => a.isCustom && a.customActivity!.id == customActivity.id,
    );
    if (exists) return true;

    // Check free tier limit
    if (!isPremium && state.trackedActivities.length >= maxFreeActivities) {
      return false;
    }

    final newActivity = ActivityProgress(
      type: ActivityType.custom,
      customActivity: customActivity,
      goalMinutes: customActivity.defaultGoalMinutes,
      lastUpdated: DateTime.now(),
    );

    state = state.copyWith(trackedActivities: [...state.trackedActivities, newActivity]);
    await _save();
    return true;
  }

  Future<void> removeActivity(String activityKey) async {
    final updated = state.trackedActivities.where((a) => a.type.key != activityKey).toList();
    state = state.copyWith(trackedActivities: updated);

    if (state.selectedActivity == activityKey && updated.isNotEmpty) {
      await selectActivity(updated.first.type.key);
    }
    await _save();
  }

  Future<void> updateProgress(String activityKey, int minutesToAdd) async {
    final activity = state.getProgress(activityKey);
    if (activity == null) return;

    final now = DateTime.now();
    final shouldReset = !_isSameDay(activity.lastUpdated, now);

    final updated = activity.copyWith(
      completedMinutes: shouldReset ? minutesToAdd : activity.completedMinutes + minutesToAdd,
      lastUpdated: now,
    );

  final updatedList = state.trackedActivities
    .map((a) => (a.type.key == activityKey || a.activityId == activityKey) ? updated : a)
    .toList();

    state = state.copyWith(trackedActivities: updatedList);
    await _save();
  }

  Future<void> _save() async {
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      final jsonList = state.trackedActivities.map((a) => a.toJson()).toList();
      await storage.setString('tracked_activities_progress', jsonEncode(jsonList));
    } catch (_) {}
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Legacy provider for backward compatibility
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
