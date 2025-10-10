import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/constants/ambient_flags.dart';
import 'silence_provider.dart';

class AdaptiveTuning {
  final int cooldownHours;
  final int baseStreak;
  final int reverseBonus;

  const AdaptiveTuning({
    required this.cooldownHours,
    required this.baseStreak,
    required this.reverseBonus,
  });

  AdaptiveTuning copyWith({int? cooldownHours, int? baseStreak, int? reverseBonus}) =>
      AdaptiveTuning(
        cooldownHours: cooldownHours ?? this.cooldownHours,
        baseStreak: baseStreak ?? this.baseStreak,
        reverseBonus: reverseBonus ?? this.reverseBonus,
      );

  static const defaults = AdaptiveTuning(
    cooldownHours: AmbientFlags.defaultAdaptiveCooldownHours,
    baseStreak: AmbientFlags.adaptiveBaseStreak,
    reverseBonus: AmbientFlags.adaptiveReverseBonus,
  );
}

class AdaptiveTuningController extends StateNotifier<AdaptiveTuning> {
  final Ref _ref;
  static const _kCooldown = 'adaptive_cooldown_hours';
  static const _kBaseStreak = 'adaptive_base_streak';
  static const _kReverseBonus = 'adaptive_reverse_bonus';

  AdaptiveTuningController(this._ref) : super(AdaptiveTuning.defaults) {
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final storage = await _ref.read(storageServiceProvider.future);
      int? ch;
      int? bs;
      int? rb;
      try {
        final chStr = await storage.getString(_kCooldown);
        if (chStr != null && chStr.isNotEmpty) ch = int.tryParse(chStr);
      } catch (_) {}
      try {
        final bsStr = await storage.getString(_kBaseStreak);
        if (bsStr != null && bsStr.isNotEmpty) bs = int.tryParse(bsStr);
      } catch (_) {}
      try {
        final rbStr = await storage.getString(_kReverseBonus);
        if (rbStr != null && rbStr.isNotEmpty) rb = int.tryParse(rbStr);
      } catch (_) {}
      if (!mounted) return;
      state = AdaptiveTuning(
        cooldownHours: ch ?? AdaptiveTuning.defaults.cooldownHours,
        baseStreak: bs ?? AdaptiveTuning.defaults.baseStreak,
        reverseBonus: rb ?? AdaptiveTuning.defaults.reverseBonus,
      );
    } catch (_) {
      if (!mounted) return;
      state = AdaptiveTuning.defaults;
    }
  }

  Future<void> setCooldownHours(int hours) async {
    state = state.copyWith(cooldownHours: hours);
    final storage = await _ref.read(storageServiceProvider.future);
    await storage.setString(_kCooldown, hours.toString());
  }

  Future<void> setBaseStreak(int streak) async {
    state = state.copyWith(baseStreak: streak);
    final storage = await _ref.read(storageServiceProvider.future);
    await storage.setString(_kBaseStreak, streak.toString());
  }

  Future<void> setReverseBonus(int bonus) async {
    state = state.copyWith(reverseBonus: bonus);
    final storage = await _ref.read(storageServiceProvider.future);
    await storage.setString(_kReverseBonus, bonus.toString());
  }

  Future<void> restoreDefaults() async {
    state = AdaptiveTuning.defaults;
    final storage = await _ref.read(storageServiceProvider.future);
    await storage.setString(_kCooldown, state.cooldownHours.toString());
    await storage.setString(_kBaseStreak, state.baseStreak.toString());
    await storage.setString(_kReverseBonus, state.reverseBonus.toString());
  }
}

final adaptiveTuningProvider =
    StateNotifierProvider<AdaptiveTuningController, AdaptiveTuning>((ref) {
  return AdaptiveTuningController(ref);
});
