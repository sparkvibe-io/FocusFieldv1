import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'package:silence_score/constants/permission_constants.dart';

class PermissionDialogs {
  static Future<void> showMicrophoneRationale(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            title: const Text(PermissionConstants.microphoneDialogTitle),
            content: const Text(PermissionConstants.microphoneDialogBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Later'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final detector = ref.read(silenceDetectorProvider);
                  await detector.requestPermission();
                },
                child: const Text('Grant Permission'),
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
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => AlertDialog(
            title: const Text(
              PermissionConstants.microphoneSettingsDialogTitle,
            ),
            content: const Text(
              PermissionConstants.microphoneSettingsDialogBody,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final detector = ref.read(silenceDetectorProvider);
                  try {
                    await detector.openSettings();
                  } catch (_) {}
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }
}
