import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_field/l10n/app_localizations.dart';

Future<AppLocalizations> _load(Locale locale) async {
  const delegate = AppLocalizations.delegate;
  assert(delegate.isSupported(locale));
  return delegate.load(locale);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Portuguese (pt) streak & weekly progress interpolation', () async {
    final l10n = await _load(const Locale('pt'));
    expect(l10n.reminderStreakShort(6), contains('6'));
    expect(l10n.weeklyProgressFew(2), contains('2'));
  });
}
