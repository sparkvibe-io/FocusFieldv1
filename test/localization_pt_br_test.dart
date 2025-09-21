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

  test('Portuguese (pt_BR) streak & weekly progress interpolation', () async {
    final l10n = await _load(const Locale('pt', 'BR'));
    expect(l10n.reminderStreakShort(4), contains('4'));
    expect(l10n.weeklyProgressFew(3), contains('3'));
  });
}
