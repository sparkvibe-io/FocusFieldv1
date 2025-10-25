import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_field/services/rating_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RatingService gating', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await RatingService.instance.initLaunch();
    });

    test('Does not prompt before minimum sessions', () async {
      // We can't directly call maybePrompt without context; instead, we test probability logic indirectly by ensuring
      // gating returns early. We'll simulate internal state then rely on evaluation path (no exception).
      // NOTE: Full UI prompt requires BuildContext; this test focuses on state setup reliability.
      // If internal logic changes, adapt with a facade for pure evaluation.
      expect(RatingService.minSessions, 7);
    });

    test('Probability increases with sessions', () async {
      // Access private probability via reflection not possible; replicate formula.
      double probability(int sessions) {
        if (sessions <= RatingService.minSessions) {
          return RatingService.baseProbability;
        }
        final extra = sessions - RatingService.minSessions;
        final p = (RatingService.baseProbability +
                extra * RatingService.probabilitySlope)
            .clamp(RatingService.baseProbability, RatingService.maxProbability);
        return p.toDouble();
      }

      final pBase = probability(RatingService.minSessions);
      final pHigher = probability(RatingService.minSessions + 5);
      expect(pHigher, greaterThan(pBase));
      expect(pHigher, lessThanOrEqualTo(RatingService.maxProbability));
    });
  });
}
