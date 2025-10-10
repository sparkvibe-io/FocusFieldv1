import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/ambient_models.dart';
import '../providers/silence_provider.dart';
import 'package:focus_field/constants/ambient_flags.dart';
import 'adaptive_tuning_provider.dart';

const _uuid = Uuid();

// Default quiet-first profiles
final defaultProfilesProvider = Provider<List<ActivityProfile>>((ref) {
  return const [
    ActivityProfile(id: 'study', name: 'Study', icon: '🎓', usesNoise: true, thresholdDb: 38),
    ActivityProfile(id: 'reading', name: 'Reading', icon: '📖', usesNoise: true, thresholdDb: 38),
    ActivityProfile(id: 'meditation', name: 'Meditation', icon: '🧘', usesNoise: true, thresholdDb: 38),
  ];
});

// Selected profile ID
final selectedProfileIdProvider = StateProvider<String>((ref) => 'study');

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

  const AmbientSessionState({
    this.sessionId,
    this.elapsedSeconds = 0,
    this.quietSeconds = 0,
    this.violations = 0,
    this.ambientScore = 0.0,
    this.running = false,
  });

  AmbientSessionState copyWith({
    String? sessionId,
    int? elapsedSeconds,
    int? quietSeconds,
    int? violations,
    double? ambientScore,
    bool? running,
  }) => AmbientSessionState(
        sessionId: sessionId ?? this.sessionId,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        quietSeconds: quietSeconds ?? this.quietSeconds,
        violations: violations ?? this.violations,
        ambientScore: ambientScore ?? this.ambientScore,
        running: running ?? this.running,
      );
}

final ambientSessionEngineProvider = StateNotifierProvider<AmbientSessionEngine, AmbientSessionState>((ref) {
  return AmbientSessionEngine(ref);
});

class AmbientSessionEngine extends StateNotifier<AmbientSessionState> {
  final Ref _ref;
  DateTime? _start;
  AmbientSessionEngine(this._ref) : super(const AmbientSessionState());

  Future<String> start({required int plannedSeconds}) async {
    final id = _uuid.v4();
    _start = DateTime.now();
    state = state.copyWith(sessionId: id, running: true, elapsedSeconds: 0, quietSeconds: 0, violations: 0, ambientScore: 0.0);
    return id;
  }

  // Minimal tick; UI should call at 1s cadence (reuse RealTimeNoiseController externally)
  void tick({required bool usesNoise, required double currentDb, required int thresholdDb, int deltaSeconds = 1, int spikeGraceMs = 3000}) {
    if (!state.running) return;
    final elapsed = state.elapsedSeconds + deltaSeconds;
    bool isQuietNow = true;
    if (usesNoise) {
      isQuietNow = currentDb <= thresholdDb;
    }
    final quiet = state.quietSeconds + (isQuietNow ? deltaSeconds : 0);
    final violations = state.violations + (isQuietNow ? 0 : 1);
    final score = elapsed > 0 ? quiet / max(1, elapsed) : 0.0;
    state = state.copyWith(elapsedSeconds: elapsed, quietSeconds: quiet, violations: violations, ambientScore: score);
  }

  Future<AmbientSession?> end({String reason = 'completed', int plannedSeconds = 0}) async {
    if (!state.running || _start == null || state.sessionId == null) return null;
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
      ambientScore: profile.usesNoise ? state.ambientScore : null,
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
        return;
      } catch (_) {}
    }
    {
      final now = DateTime.now();
      state = QuestState(
        cycleId: '${now.year}-${now.month.toString().padLeft(2, '0')}',
        dayIndex: now.day,
        goalQuietMinutes: 20,
        requiredScore: 0.7,
        progressQuietMinutes: 0,
        streakCount: 0,
        freezeTokens: 1,
        lastUpdatedAt: now,
      );
    }
  }

  Future<void> save() async {
    final storage = await _ref.read(storageServiceProvider.future);
    if (state != null) {
      await storage.setString('ambient_quest_state', jsonEncode(state!.toJson()));
    }
  }

  Future<void> applySession(AmbientSession session) async {
    final qs = state;
    if (qs == null) return;
    final now = DateTime.now();
    int credited = 0;
    bool qualifies = false;
    if (session.ambientScore != null) {
      qualifies = session.ambientScore! >= qs.requiredScore;
      credited = qualifies ? (session.quietSeconds ~/ 60) : 0;
    }
    final newProgress = min(qs.goalQuietMinutes, qs.progressQuietMinutes + credited);
    int newStreak = qs.streakCount;
    if (newProgress >= qs.goalQuietMinutes) newStreak = qs.streakCount + 1;

    state = qs.copyWith(
      progressQuietMinutes: newProgress,
      streakCount: newStreak,
      dayIndex: now.day,
      lastUpdatedAt: now,
    );
    await save();
  }

  Future<bool> freezeToday() async {
    final qs = state;
    if (qs == null) return false;
    if (qs.freezeTokens <= 0) return false;
    state = qs.copyWith(
      progressQuietMinutes: qs.goalQuietMinutes,
      freezeTokens: qs.freezeTokens - 1,
      lastUpdatedAt: DateTime.now(),
    );
    await save();
    return true;
  }
}

final questStateProvider = StateNotifierProvider<QuestStateController, QuestState?>((ref) {
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
    DateTime? _parseMs(String? v) {
      if (v == null || v.isEmpty) return null;
      final ms = int.tryParse(v);
      if (ms == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }
    final now = DateTime.now();
    final lastSuggested = _parseMs(await storage.getString('ambient_adaptive_last_suggest_ms'));
    final lastApplied = _parseMs(await storage.getString('ambient_adaptive_last_applied_ms'));
    final lastEvent = [lastSuggested, lastApplied]
        .whereType<DateTime>()
        .fold<DateTime?>(null, (prev, e) => prev == null ? e : (e.isAfter(prev) ? e : prev));
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
    if (lastEvent != null && now.difference(lastEvent) < Duration(hours: cooldownHours)) {
      return null;
    }
    final jsonString = await storage.getString('ambient_sessions_list');
    if (jsonString == null || jsonString.isEmpty) return null;

    final raw = jsonDecode(jsonString);
    if (raw is! List) return null;
    final sessions = raw
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
    final lastDir = await storage.getString('ambient_adaptive_last_dir'); // 'up' or 'down'
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
        await storage.setString('ambient_adaptive_last_suggest_ms', now.millisecondsSinceEpoch.toString());
        await storage.setString('ambient_adaptive_last_dir', 'down');
        return suggested;
      }
    }

    // If enough consecutive losses, environment too strict -> suggest +2 dB
    if (consecLosses >= requiredLosses) {
      final suggested = (currentThreshold + 2).clamp(28, 60);
      if (suggested != currentThreshold) {
        await storage.setString('ambient_adaptive_last_suggest_ms', now.millisecondsSinceEpoch.toString());
        await storage.setString('ambient_adaptive_last_dir', 'up');
        return suggested;
      }
    }

    return null;
  } catch (_) {
    return null;
  }
});
