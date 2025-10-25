import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/services/tip_service.dart';

// Provider for checking if there are new tips
final hasNewTipsProvider = FutureProvider<bool>((ref) async {
  final tipService = ref.read(tipServiceProvider);
  return await tipService.hasNewTips();
});

// Provider for tip service enabled state
final tipServiceEnabledProvider = FutureProvider<bool>((ref) async {
  final tipService = ref.read(tipServiceProvider);
  return await tipService
      .getEnabled(); // Use async method that properly initializes
});

// Provider to watch tip service enabled state changes
final tipServiceEnabledNotifierProvider = Provider<ValueNotifier<bool>>((ref) {
  final tipService = ref.read(tipServiceProvider);
  return tipService.enabled;
});
