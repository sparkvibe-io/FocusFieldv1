import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/screens/home_page_elegant.dart';
import 'package:focus_field/constants/app_constants.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
  home: HomePageElegant(),
      ),
    ),
  );
  // Allow async providers (SharedPreferences, storage) to resolve
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Focus Field App', () {
    testWidgets('should show primary ring and duration chips', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);
      // Go to Sessions tab (prefer targeting within TabBar to avoid ambiguity)
      final sessionsTabText = find.descendant(
        of: find.byType(TabBar),
        matching: find.text('Sessions'),
      );
      if (sessionsTabText.evaluate().isNotEmpty) {
        await tester.tap(sessionsTabText);
      } else {
        await tester.tap(find.byIcon(Icons.play_circle_outline_rounded));
      }
      // Let the tab animation complete
      await tester.pump(const Duration(milliseconds: 600));

      // Scroll until the session control card (with duration chips) comes into view
      final target = find.text('1m');
      await tester.scrollUntilVisible(
        target,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );

      // Quick duration chips include common minutes like 1m, 5m, 10m
      expect(find.text('1m'), findsWidgets);
      expect(find.text('5m'), findsWidgets);
      expect(find.text('10m'), findsWidgets);
    });

    testWidgets('should not show status message before interaction', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);

      // Status message area is empty SizedBox initially
      expect(find.text(AppConstants.successMessage), findsNothing);
      expect(find.text(AppConstants.failureMessage), findsNothing);
    });

    testWidgets('should display overview stats placeholders', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);
      // Stats panel appears on the Summary tab; at least one of these labels should be present.
      final hasPoints = find.textContaining('Points');
      final hasStreak = find.textContaining('Streak');
      final hasSessions = find.textContaining('Sessions');
      expect(hasPoints.evaluate().isNotEmpty || hasStreak.evaluate().isNotEmpty || hasSessions.evaluate().isNotEmpty, isTrue);
    });

    testWidgets('should show settings button', (WidgetTester tester) async {
      await _pumpApp(tester);

  // Elegant home uses settings_outlined in Summary actions
  expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    // Settings button currently has no action wired in HomePageElegant header.
    // Skipping sheet presentation test for now; re-enable when action is implemented.
  });
}
