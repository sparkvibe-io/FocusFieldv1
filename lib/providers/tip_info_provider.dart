import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/services/tip_service.dart';

// Provider for checking if there are new tips
final hasNewTipsProvider = FutureProvider<bool>((ref) async {
  final tipService = ref.read(tipServiceProvider);
  return await tipService.hasNewTips();
});

// Provider for tip service enabled state
final tipServiceEnabledProvider = Provider<bool>((ref) {
  final tipService = ref.read(tipServiceProvider);
  return tipService.enabled.value;
});

// Provider to watch tip service enabled state changes
final tipServiceEnabledNotifierProvider = Provider<ValueNotifier<bool>>((ref) {
  final tipService = ref.read(tipServiceProvider);
  return tipService.enabled;
});
