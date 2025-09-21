class PermissionConstants {
  static const initialPermissionDelayMs = 1000;
  static const dialogPostRequestDelayMs = 500;
  static const permissionCheckTimeoutSec = 5;
  static const permissionRequestTimeoutSec = 10;

  static const microphoneDialogTitle = 'Microphone Permission';
  static const microphoneDialogBody =
    'Focus Field measures ambient sound levels to help you maintain quiet environments.\n\nThe app needs microphone access to detect silence, but does not record any audio.';
  static const microphoneSettingsDialogTitle = 'Settings Required';
  static const microphoneSettingsDialogBody =
    'To enable silence detection, manually grant microphone permission:\n\n• iOS: Settings > Privacy & Security > Microphone > Focus Field\n• Android: Settings > Apps > Focus Field > Permissions > Microphone';
}
