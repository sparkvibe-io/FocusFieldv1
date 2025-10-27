import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/ambient_models.dart';
import '../providers/silence_provider.dart';
import '../utils/debug_log.dart';
import 'package:focus_field/constants/ambient_flags.dart';
import 'adaptive_tuning_provider.dart';
import 'user_preferences_provider.dart';
import 'package:focus_field/l10n/app_localizations.dart';

const _uuid = Uuid();

// Helper function to get localized activity name
String getLocalizedActivityName(BuildContext context, String activityId) {
  final l10n = AppLocalizations.of(context)!;
  switch (activityId) {
    case 'study':
      return l10n.activityStudy;
    case 'reading':
      return l10n.activityReading;
    case 'meditation':
      return l10n.activityMeditation;
    case 'other':
      return l10n.activityOther;
    default:
      return activityId; // Fallback to ID if unknown
  }
}

// Default quiet-first profiles (now includes "other" for 4 activities)
// NOTE: The 'name' field contains the English fallback. Use getLocalizedActivityName()
// in UI code to display the localized name.
final defaultProfilesProvider = Provider<List<ActivityProfile>>((ref) {
  return const [
    ActivityProfile(
      id: 'study',
      name: 'Study',
      icon: '🎓',
      usesNoise: true,
      thresholdDb: 38,
    ),
    ActivityProfile(
      id: 'reading',
      name: 'Reading',
      icon: '📖',
      usesNoise: true,
      thresholdDb: 38,
    ),
    ActivityProfile(
      id: 'meditation',
      name: 'Meditation',
      icon: '🧘',
      usesNoise: true,
      thresholdDb: 38,
    ),
    ActivityProfile(
      id: 'other',
      name: 'Other',
      icon: '⭐',
      usesNoise: true,
      thresholdDb: 38,
    ),
  ];
});

// Selected profile ID with persistence
final selectedProfileIdProvider =
    StateNotifierProvider<SelectedProfileNotifier, String>((ref) {
      return SelectedProfileNotifier(ref);
    });

class SelectedProfileNotifier extends StateNotifier<String> {
  final Ref _ref;

  SelectedProfileNotifier(this._ref) : super('study') {
    _load();
  }

  Future<void> _load() async {
    final storage = await _ref.read(storageServiceProvider.future);
    final savedId = await storage.getString('selected_activity_profile');
    if (savedId != null && savedId.isNotEmpty) {
      state = savedId;
    }
  }

  Future<void> setProfile(String profileId) async {
    state = profileId;
    final storage = await _ref.read(storageServiceProvider.future);
    await storage.setString('selected_activity_profile', profileId);
  }
}

// Active profile object
final activeProfileProvider = Provider<ActivityProfile>((ref) {
  final id = ref.watch(selectedProfileIdProvider);
  final list = ref.watch(defaultProfilesProvider);
  return list.firstWhere((p) => p.id == id, orElse: () => list.first);
});

class AmbientSessionState {
  final String? sessionId;
  final int elapsedSeconds;
  final int quietSeconds;
  final int violations;
  final double ambientScore;
  final bool running;
  final bool sessionUsesNoise;

  const AmbientSessionState({
    this.sessionId,
    this.elapsedSeconds = 0,
    this.quietSeconds = 0,
    this.violations = 0,
    this.ambientScore = 0.0,
    this.running = false,
    this.sessionUsesNoise = true,
  });

  AmbientSessionState copyWith({
    String? sessionId,
    int? elapsedSeconds,
    int? quietSeconds,
    int? violations,
    double? ambientScore,
    bool? running,
    bool? sessionUsesNoise,
  }) => AmbientSessionState(
    sessionId: sessionId ?? this.sessionId,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    quietSeconds: quietSeconds ?? this.quietSeconds,
    violations: violations ?? this.violations,
    ambientScore: ambientScore ?? this.ambientScore,
    running: running ?? this.running,
    sessionUsesNoise: sessionUsesNoise ?? this.sessionUsesNoise,
  );
}

final ambientSessionEngineProvider =
    StateNotifierProvider<AmbientSessionEngine, AmbientSessionState>((ref) {
      return AmbientSessionEngine(ref);
    });

class AmbientSessionEngine extends StateNotifier<AmbientSessionState> {
  final Ref _ref;
  DateTime? _start;
  AmbientSessionEngine(this._ref) : super(const AmbientSessionState());

  Future<String> start({
    required int plannedSeconds,
    required bool usesNoise,
  }) async {
    final id = _uuid.v4();
    _start = DateTime.now();
    state = state.copyWith(
      sessionId: id,
      running: true,
      elapsedSeconds: 0,
      quietSeconds: 0,
      violations: 0,
      ambientScore: 0.0,
      sessionUsesNoise: usesNoise,
    );
    return id;
  }

  // Minimal tick; UI should call at 1s cadence (reuse RealTimeNoiseController externally)
  void tick({
    required bool usesNoise,
    required double currentDb,
    required int thresholdDb,
    int deltaSeconds = 1,
    int spikeGraceMs = 3000,
  }) {
    if (!state.running) return;
    final elapsed = state.elapsedSeconds + deltaSeconds;
    bool isQuietNow = true;
    if (usesNoise) {
      isQuietNow = currentDb <= thresholdDb;
    }
    final quiet = state.quietSeconds + (isQuietNow ? deltaSeconds : 0);
    final violations = state.violations + (isQuietNow ? 0 : 1);
    final score = elapsed > 0 ? quiet / max(1, elapsed) : 0.0;
    state = state.copyWith(
      elapsedSeconds: elapsed,
      quietSeconds: quiet,
      violations: violations,
      ambientScore: score,
    );
  }

  Future<AmbientSession?> end({
    String reason = 'completed',
    int plannedSeconds = 0,
  }) async {
    if (!state.running || _start == null || state.sessionId == null) {
      return null;
    }
    final ended = DateTime.now();
    final profile = _ref.read(activeProfileProvider);
    final session = AmbientSession(
      id: state.sessionId!,
      profileId: profile.id,
      plannedSeconds: plannedSeconds,
      actualSeconds: state.elapsedSeconds,
      startedAt: _start!,
      endedAt: ended,
      quietSeconds: state.quietSeconds,
      violations: state.violations,
      ambientScore: state.sessionUsesNoise ? state.ambientScore : null,
    );

    // Persist minimal history
    final storage = await _ref.read(storageServiceProvider.future);
    final jsonString = await storage.getString('ambient_sessions_list');
    List<dynamic> raw = [];
    if (jsonString != null) {
      try {
        raw = List<dynamic>.from(jsonDecode(jsonString) as List<dynamic>);
      } catch (_) {
        raw = [];
      }
    }
    final items = [...raw, session.toJson()].take(30).toList();
    await storage.setString('ambient_sessions_list', jsonEncode(items));

    // Apply session effects to Quest state centrally (moved from UI)
    try {
      await _ref.read(questStateProvider.notifier).applySession(session);
    } catch (_) {
      // Swallow to avoid breaking end flow; UI remains responsive even if quest update fails
    }

    state = const AmbientSessionState();
    _start = null;
    return session;
  }
}

/// Live calm-percent (0-100) during an active session, computed from the
/// 1Hz RealTimeNoiseController stream and current threshold. Null when idle.
class LiveCalmPercentNotifier extends StateNotifier<double?> {
  final Ref _ref;
  StreamSubscription<double>? _sub;
  int _calmSeconds = 0;
  int _elapsedSeconds = 0;

  LiveCalmPercentNotifier(this._ref) : super(null) {
    // Subscribe to aggregated 1Hz noise stream
    final controller = _ref.read(realTimeNoiseControllerProvider);
    _sub = controller.stream.listen((d) {
      if (d.isNaN || d.isInfinite) return;
      final listening = _ref.read(silenceStateProvider).isListening;
      if (!listening) return;
      _elapsedSeconds += 1;
      final threshold = _ref.read(decibelThresholdProvider);
      if (d.clamp(0.0, 120.0) <= threshold) {
        _calmSeconds += 1;
      }
      if (_elapsedSeconds > 0) {
        state = ((_calmSeconds / _elapsedSeconds) * 100.0).clamp(0, 100);
      }
    });

    // Reset counters when a session starts
    _ref.listen(silenceStateProvider, (prev, next) {
      if (next.isListening && (prev?.isListening != true)) {
        _calmSeconds = 0;
        _elapsedSeconds = 0;
        state = null;
      }
    });

    _ref.onDispose(() {
      _sub?.cancel();
    });
  }
}

final liveCalmPercentProvider =
    StateNotifierProvider<LiveCalmPercentNotifier, double?>((ref) {
      return LiveCalmPercentNotifier(ref);
    });

class QuestStateController extends StateNotifier<QuestState?> {
  final Ref _ref;
  QuestStateController(this._ref) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final storage = await _ref.read(storageServiceProvider.future);
    final jsonString = await storage.getString('ambient_quest_state');
    if (jsonString != null) {
      try {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        state = QuestState.fromJson(map);
        await _rolloverIfNeeded();
        return;
      } catch (_) {}
    }
    {
      final now = DateTime.now();
      final prefs = _ref.read(userPreferencesProvider);
      state = QuestState(
        cycleId: '${now.year}-${now.month.toString().padLeft(2, '0')}',
        dayIndex: now.day,
        goalQuietMinutes: prefs.globalDailyQuietGoalMinutes,
        requiredScore: 0.7,  // 70% quiet time required
        progressQuietMinutes: 0,
        streakCount: 0,
        freezeTokens: 1,
        lastUpdatedAt: now,
        lastFreezeReplenishment: now,
      );
      await save();
    }
  }

  Future<void> save() async {
    final storage = await _ref.read(storageServiceProvider.future);
    if (state != null) {
      await storage.setString(
        'ambient_quest_state',
        jsonEncode(state!.toJson()),
      );
    }
  }

  // Handles day/month rollover, resets daily progress and replenishes weekly freeze tokens (1 per week, max 4)
  // Implements permissive 2-Day Rule: only reset streak if two consecutive days are missed
  Future<void> _rolloverIfNeeded() async {
    final qs = state;
    if (qs == null) return;
    final now = DateTime.now();
    final currentCycleId =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    var updated = qs;

    // Check if a week has passed since last freeze replenishment (rolling 7-day window)
    final daysSinceLastReplenishment =
        now.difference(qs.lastFreezeReplenishment).inDays;
    if (daysSinceLastReplenishment >= 7) {
      // Add 1 token per week, capped at 4 max
      final newTokens = (qs.freezeTokens + 1).clamp(0, 4);
      updated = updated.copyWith(
        freezeTokens: newTokens,
        lastFreezeReplenishment: now,
      );
    }

    // Month change -> reset cycle, keep streak and freeze tokens
    if (qs.cycleId != currentCycleId) {
      updated = updated.copyWith(
        cycleId: currentCycleId,
        dayIndex: now.day,
        progressQuietMinutes: 0,
        studyMinutes: 0,
        readingMinutes: 0,
        meditationMinutes: 0,
        missedYesterday: false, // fresh month
        freezeTokenUsedToday: false, // Reset freeze token lock for new month
        lastUpdatedAt: now,
      );
    }
    // Day change within same month
    final last = DateTime(
      qs.lastUpdatedAt.year,
      qs.lastUpdatedAt.month,
      qs.lastUpdatedAt.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    if (today.isAfter(last)) {
      // Permissive 2-Day Rule: only reset streak if BOTH yesterday AND the day before were missed
      final yesterdayMissed = qs.progressQuietMinutes < qs.goalQuietMinutes;
      final resetStreak =
          yesterdayMissed && qs.missedYesterday; // two days in a row

      updated = updated.copyWith(
        dayIndex: now.day,
        progressQuietMinutes: 0,
        studyMinutes: 0,
        readingMinutes: 0,
        meditationMinutes: 0,
        streakCount: resetStreak ? 0 : qs.streakCount,
        missedYesterday: yesterdayMissed, // track for next rollover
        freezeTokenUsedToday: false, // Reset freeze token lock for new day
        lastUpdatedAt: now,
      );
    }
    if (updated != qs) {
      state = updated;
      await save();
    }
  }

  Future<void> applySession(AmbientSession session) async {
    if (!kReleaseMode) {
      DebugLog.d('🎯 [QuestState] applySession START: ${session.profileId}, quietSeconds=${session.quietSeconds}, score=${session.ambientScore}');
    }

    await _rolloverIfNeeded();
    final qs = state;
    if (qs == null) {
      if (!kReleaseMode) {
        DebugLog.d('❌ [QuestState] applySession ABORT: state is null');
      }
      return;
    }
    final now = DateTime.now();

    // Calculate credited minutes if ambient score qualifies
    // Use ceiling (round up) for compassionate credit: 48 seconds = 1 minute
    int credited = 0;
    bool qualifies = false;
    if (session.ambientScore != null) {
      qualifies = session.ambientScore! >= qs.requiredScore;
      credited = qualifies ? (session.quietSeconds / 60).ceil() : 0;
    }

    if (!kReleaseMode) {
      DebugLog.d('🎯 [QuestState] Credited minutes: $credited (qualifies: $qualifies)');
    }

    // Track per-activity minutes based on profileId
    int newStudyMinutes = qs.studyMinutes;
    int newReadingMinutes = qs.readingMinutes;
    int newMeditationMinutes = qs.meditationMinutes;

    switch (session.profileId) {
      case 'study':
        newStudyMinutes = qs.studyMinutes + credited;
        break;
      case 'reading':
        newReadingMinutes = qs.readingMinutes + credited;
        break;
      case 'meditation':
        newMeditationMinutes = qs.meditationMinutes + credited;
        break;
    }

    // Calculate total progress as sum of all activities (capped at goal)
    // IMPORTANT: If freeze token was used today, keep progress locked at goal value
    final totalMinutes =
        newStudyMinutes + newReadingMinutes + newMeditationMinutes;
    final newProgress =
        qs.freezeTokenUsedToday
            ? qs
                .progressQuietMinutes // Keep locked at 100% when freeze token used
            : min(qs.goalQuietMinutes, totalMinutes);

    int newStreak = qs.streakCount;
    bool clearMissed = false;

    // If goal is met, increment streak and clear missedYesterday flag
    if (newProgress >= qs.goalQuietMinutes) {
      newStreak = qs.streakCount + 1;
      clearMissed = true; // goal met, streak is safe
    }

    state = qs.copyWith(
      progressQuietMinutes: newProgress,
      studyMinutes: newStudyMinutes,
      readingMinutes: newReadingMinutes,
      meditationMinutes: newMeditationMinutes,
      streakCount: newStreak,
      dayIndex: now.day,
      missedYesterday: clearMissed ? false : qs.missedYesterday,
      lastUpdatedAt: now,
    );
    await save();

    if (!kReleaseMode) {
      DebugLog.d('✅ [QuestState] applySession COMPLETE: progress=$newProgress/${ qs.goalQuietMinutes}, streak=$newStreak, study=$newStudyMinutes, reading=$newReadingMinutes, meditation=$newMeditationMinutes');
    }
  }

  /// Update the goal when user preferences change
  Future<void> updateGoal(int newGoalMinutes) async {
    final qs = state;
    if (qs == null) return;
    state = qs.copyWith(goalQuietMinutes: newGoalMinutes);
    await save();
  }

  Future<bool> freezeToday() async {
    await _rolloverIfNeeded();
    final qs = state;
    if (qs == null) return false;
    if (qs.freezeTokens <= 0) return false;
    // Freeze counts as goal completion: clear missedYesterday flag and set freezeTokenUsedToday
    state = qs.copyWith(
      progressQuietMinutes: qs.goalQuietMinutes,
      freezeTokens: qs.freezeTokens - 1,
      missedYesterday: false, // freeze protects streak
      freezeTokenUsedToday: true, // Lock day at 100% completion
      lastUpdatedAt: DateTime.now(),
    );
    await save();
    return true;
  }
}

final questStateProvider =
    StateNotifierProvider<QuestStateController, QuestState?>((ref) {
      return QuestStateController(ref);
    });

/// Debug-only: force an adaptive threshold suggestion value (null = off)
final debugAdaptiveOverrideProvider = StateProvider<int?>((ref) => null);

/// Tracks the last applied adaptive threshold value to show a brief confirmation hint
final lastAdaptiveAppliedProvider = StateProvider<int?>((ref) => null);

// Adaptive threshold suggestion based on recent session outcomes.
// Returns an int dB suggestion or null if no suggestion.
final adaptiveThresholdProvider = FutureProvider<int?>((ref) async {
  // Honor debug override first if provided
  final forced = ref.watch(debugAdaptiveOverrideProvider);
  if (forced != null) return forced;
  try {
    final storage = await ref.watch(storageServiceProvider.future);
    // Cooldown: suggest at most once per 24 hours. Consider last suggested or last applied time.
    DateTime? parseMs(String? v) {
      if (v == null || v.isEmpty) return null;
      final ms = int.tryParse(v);
      if (ms == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }

    final now = DateTime.now();
    final lastSuggested = parseMs(
      await storage.getString('ambient_adaptive_last_suggest_ms'),
    );
    final lastApplied = parseMs(
      await storage.getString('ambient_adaptive_last_applied_ms'),
    );
    final lastEvent = [
      lastSuggested,
      lastApplied,
    ].whereType<DateTime>().fold<DateTime?>(
      null,
      (prev, e) => prev == null ? e : (e.isAfter(prev) ? e : prev),
    );
    // Read tuning values; fall back to flags if provider not ready
    int cooldownHours = AmbientFlags.defaultAdaptiveCooldownHours;
    int baseStreak = AmbientFlags.adaptiveBaseStreak;
    int reverseBonus = AmbientFlags.adaptiveReverseBonus;
    try {
      final tuning = ref.read(adaptiveTuningProvider);
      cooldownHours = tuning.cooldownHours;
      baseStreak = tuning.baseStreak;
      reverseBonus = tuning.reverseBonus;
    } catch (_) {}
    if (lastEvent != null &&
        now.difference(lastEvent) < Duration(hours: cooldownHours)) {
      return null;
    }
    final jsonString = await storage.getString('ambient_sessions_list');
    if (jsonString == null || jsonString.isEmpty) return null;

    final raw = jsonDecode(jsonString);
    if (raw is! List) return null;
    final sessions =
        raw
            .map((e) => AmbientSession.fromJson(e as Map<String, dynamic>))
            .where((s) => s.ambientScore != null)
            .toList();
    if (sessions.isEmpty) return null;

    // Newest first
    sessions.sort((a, b) => b.endedAt.compareTo(a.endedAt));
    final recent = sessions.take(5).toList();

    // Determine consecutive wins/losses in most recent order
    int consecWins = 0;
    int consecLosses = 0;
    for (final s in recent) {
      final score = s.ambientScore ?? 0.0;
      // Define a "win" as a strong calm session
      if (score >= 0.85) {
        if (consecLosses > 0) break; // mixed results, stop early
        consecWins++;
      } else if (score <= 0.5) {
        if (consecWins > 0) break;
        consecLosses++;
      } else {
        break; // neutral result breaks the streak
      }
    }

    // Prefer persisted settings to avoid dependency on provider timing in async contexts
    int currentThreshold = ref.watch(decibelThresholdProvider).round();
    try {
      final settings = await storage.loadAllSettings();
      final persisted = settings['decibelThreshold'] as double?;
      if (persisted != null) currentThreshold = persisted.round();
    } catch (_) {
      // ignore and use provider value
    }

    // Hysteresis: require an extra streak if reversing from last suggestion direction
    int requiredWins = baseStreak;
    int requiredLosses = baseStreak;
    final lastDir = await storage.getString(
      'ambient_adaptive_last_dir',
    ); // 'up' or 'down'
    if (lastDir == 'up') {
      // Last we suggested increasing threshold; to reverse, require a bit more proof to go down
      requiredWins += reverseBonus;
    } else if (lastDir == 'down') {
      requiredLosses += reverseBonus;
    }

    // If enough consecutive wins, user may tolerate stricter environment -> suggest -2 dB
    if (consecWins >= requiredWins) {
      final suggested = (currentThreshold - 2).clamp(28, 60);
      if (suggested != currentThreshold) {
        await storage.setString(
          'ambient_adaptive_last_suggest_ms',
          now.millisecondsSinceEpoch.toString(),
        );
        await storage.setString('ambient_adaptive_last_dir', 'down');
        return suggested;
      }
    }

    // If enough consecutive losses, environment too strict -> suggest +2 dB
    if (consecLosses >= requiredLosses) {
      final suggested = (currentThreshold + 2).clamp(28, 60);
      if (suggested != currentThreshold) {
        await storage.setString(
          'ambient_adaptive_last_suggest_ms',
          now.millisecondsSinceEpoch.toString(),
        );
        await storage.setString('ambient_adaptive_last_dir', 'up');
        return suggested;
      }
    }

    return null;
  } catch (_) {
    return null;
  }
});
