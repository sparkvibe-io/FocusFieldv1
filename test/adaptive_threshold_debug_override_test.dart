import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'package:focus_field/providers/ambient_quest_provider.dart';

void main() {
  test('debug override takes precedence over computed suggestion', () async {
    final container = ProviderContainer();

    // Force an override, provider should return it immediately even with no data
    container.read(debugAdaptiveOverrideProvider.notifier).state = 47;

    final suggestion = await container.read(adaptiveThresholdProvider.future);
    expect(suggestion, 47);

    // Remove override; suggestion should revert to null in absence of history
    container.read(debugAdaptiveOverrideProvider.notifier).state = null;
    final suggestion2 = await container.read(adaptiveThresholdProvider.future);
    expect(suggestion2, isNull);
  });
}
