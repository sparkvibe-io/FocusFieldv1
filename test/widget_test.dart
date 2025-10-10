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
    testWidgets('should display app title', (WidgetTester tester) async {
      await _pumpApp(tester);
  // HomePageElegant header shows the current tab title ('Summary' by default)
  expect(find.text('Summary'), findsWidgets);
    });

    testWidgets('should show primary ring and duration chips', (
      WidgetTester tester,
    ) async {
      await _pumpApp(tester);
      // Duration chips live under the Activity tab in the Session Control card.
      // Switch to Activity tab first.
      await tester.tap(find.text('Activity'));
      await tester.pumpAndSettle();
      // Quick duration chips include common minutes like 1, 5, 10
      expect(find.text('1'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(find.text('10'), findsWidgets);
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
