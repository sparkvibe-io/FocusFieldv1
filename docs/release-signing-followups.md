# Release Signing Follow-ups (post-rebrand)

Short notes to prep signed store builds after moving identifiers to `io.sparkvibe.focusfield`.

## Android

- key.properties: Do NOT commit secrets. Locally, create `android/key.properties` with:
  - storeFile=<path to your .jks>
  - storePassword=<env or local secret>
  - keyAlias=<alias>
  - keyPassword=<env or local secret>
- In CI: provide these via encrypted secrets and Gradle env mapping.
- Play Console: Update package name refs to io.sparkvibe.focusfield. Create app if new.

## iOS

- Xcode project now uses bundle id `io.sparkvibe.focusfield`.
- In Apple Developer, create matching App ID and provisioning profiles.
- In CI: use App Store Connect API key or manual upload via Xcode Organizer.

## RevenueCat keys

- Do not hardcode. Pass via `--dart-define` or env (see scripts). Use platform-specific public keys.

## Quick local checks

- `flutter pub get && flutter analyze && flutter test`
- Android release: `./scripts/build/build-prod.sh` (ensure env secrets are set)
- iOS archive: Open `ios/Runner.xcworkspace` and Archive with correct team & profiles.
