import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_field/l10n/app_localizations.dart';

void main() {
  testWidgets('English reminderStreakShort interpolation works', (
    tester,
  ) async {
    // Build a minimal app with localization delegates.
    late AppLocalizations loc;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            loc = AppLocalizations.of(context)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pump();

    final result = loc.reminderStreakShort(5);
    expect(result, contains('5')); // basic interpolation present
    expect(result.toLowerCase(), contains('streak'));
  });
}
