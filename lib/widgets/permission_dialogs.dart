import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import 'package:focus_field/providers/silence_provider.dart';

class PermissionDialogs {
  static Future<void> showMicrophoneRationale(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.microphonePermissionTitle),
            content: Text(l10n.microphonePermissionMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.ratingPromptLater),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final detector = ref.read(silenceDetectorProvider);
                  await detector.requestPermission();
                },
                child: Text(l10n.buttonGrantPermission),
              ),
            ],
          ),
    );
  }

  static Future<void> showMicrophoneSettings(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.microphoneSettingsTitle),
            content: Text(l10n.microphoneSettingsMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.buttonOk),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final detector = ref.read(silenceDetectorProvider);
                  try {
                    await detector.openSettings();
                  } catch (_) {}
                },
                child: Text(l10n.buttonOpenSettings),
              ),
            ],
          ),
    );
  }
}
