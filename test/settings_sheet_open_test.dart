import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/screens/home_page_elegant.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpOnce(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePageElegant(),
        ),
      ),
    );
    // Let initial async work settle a bit
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('tapping settings icon opens Settings sheet', (tester) async {
  await pumpOnce(tester);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    // Let the bottom sheet animate in
    await tester.pump(const Duration(milliseconds: 200));
    // Expect the Settings header text
    expect(find.text('Settings'), findsWidgets);
  });
}
