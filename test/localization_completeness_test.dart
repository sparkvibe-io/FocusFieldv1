import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All locale ARB files contain every base (en) key', () async {
    final baseFile = File('lib/l10n/app_en.arb');
    final baseMap =
        json.decode(await baseFile.readAsString()) as Map<String, dynamic>;
    final baseKeys = baseMap.keys.where((k) => !k.startsWith('@')).toSet();

    final arbFiles = Directory('lib/l10n').listSync().whereType<File>().where(
      (f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'),
    );

    for (final file in arbFiles) {
      final map =
          json.decode(await file.readAsString()) as Map<String, dynamic>;
      final keys = map.keys.where((k) => !k.startsWith('@')).toSet();
      final missing = baseKeys.difference(keys);
      expect(
        missing,
        isEmpty,
        reason: 'Missing keys in ${file.path}: $missing',
      );
    }
  });
}
