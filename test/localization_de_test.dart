import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silence_score/l10n/app_localizations.dart';

void main() {
  testWidgets('German streak interpolation and weekly progress', (
    tester,
  ) async {
    late AppLocalizations loc;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
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

    final s = loc.reminderStreakShort(3);
    expect(s, contains('3'));
    expect(s.toLowerCase(), contains('serie'));

    final weekly = loc.weeklyProgressFew(2);
    expect(weekly, contains('2'));
  });
}
