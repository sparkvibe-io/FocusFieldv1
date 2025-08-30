import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:silence_score/l10n/app_localizations.dart';

Future<AppLocalizations> _load(Locale locale) async {
  final delegate = AppLocalizations.delegate;
  final isSupported = delegate.isSupported(locale);
  assert(isSupported, 'Locale not supported in test');
  final localization = await delegate.load(locale);
  return localization;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Japanese streak & weekly progress interpolation', () async {
    final l10n = await _load(const Locale('ja'));
    expect(l10n.reminderStreakShort(3), contains('3'));
    expect(l10n.weeklyProgressFew(4), contains('4'));
  });
}
