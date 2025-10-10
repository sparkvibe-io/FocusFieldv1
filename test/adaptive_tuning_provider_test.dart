import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/providers/adaptive_tuning_provider.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Adaptive tuning loads defaults on first use', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // Ensure StorageService is initialized to avoid MissingPluginException in unit tests
    await container.read(storageServiceProvider.future);
    final tuning = container.read(adaptiveTuningProvider);
    expect(tuning.cooldownHours, AdaptiveTuning.defaults.cooldownHours);
    expect(tuning.baseStreak, AdaptiveTuning.defaults.baseStreak);
    expect(tuning.reverseBonus, AdaptiveTuning.defaults.reverseBonus);
  });

  test('Adaptive tuning persists and reloads across containers', () async {
    // First container: set values via controller
  final c1 = ProviderContainer();
    addTearDown(c1.dispose);
  await c1.read(storageServiceProvider.future);
    final ctrl = c1.read(adaptiveTuningProvider.notifier);
    await ctrl.setCooldownHours(12);
    await ctrl.setBaseStreak(4);
    await ctrl.setReverseBonus(2);

    // New container should pick up persisted values via StorageService
  final c2 = ProviderContainer();
    addTearDown(c2.dispose);
    // Ensure StorageService is initialized in this container too
    await c2.read(storageServiceProvider.future);
    // Wait for async load to propagate
    AdaptiveTuning t2 = c2.read(adaptiveTuningProvider);
    for (var i = 0; i < 10 && t2.cooldownHours != 12; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      t2 = c2.read(adaptiveTuningProvider);
    }
    expect(t2.cooldownHours, 12);
    expect(t2.baseStreak, 4);
    expect(t2.reverseBonus, 2);
  });
}
