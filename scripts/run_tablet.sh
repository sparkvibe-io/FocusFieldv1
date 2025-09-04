#!/usr/bin/env bash
set -euo pipefail

# Helper script to run SilenceScore on a tablet AVD.
# Creates / launches an Android tablet emulator if needed, then runs flutter with desired defines.
# Usage: ./scripts/run_tablet.sh [--prod]
#   --prod : uses real RevenueCat key from environment (REVENUECAT_API_KEY) and disables mocks
# Otherwise : uses mock subscriptions for safe local testing.

AVD_NAME=${AVD_NAME:-pixel_tablet_api34}
SYSTEM_IMAGE="system-images;android-34;google_apis;arm64-v8a"

MODE="dev"
if [[ ${1:-} == "--prod" ]]; then MODE="prod"; fi

need_create=false
if ! avdmanager list avd | grep -q "Name: ${AVD_NAME}"; then
  echo "[tablet] AVD ${AVD_NAME} not found, creating..."
  yes | sdkmanager --install "${SYSTEM_IMAGE}" >/dev/null 2>&1 || true
  avdmanager create avd -n "${AVD_NAME}" -k "${SYSTEM_IMAGE}" -d pixel_tablet || need_create=true
fi

# Launch emulator if not running
if ! adb devices | grep -q "emulator-"; then
  echo "[tablet] Launching emulator ${AVD_NAME}..."
  ( emulator -avd "${AVD_NAME}" -netfast -gpu host -no-snapshot -camera-back none -camera-front none >/dev/null 2>&1 & )
  echo "[tablet] Waiting for device boot..."
  adb wait-for-device
  # Wait for sys.boot_completed
  for i in {1..60}; do
    if adb shell getprop sys.boot_completed 2>/dev/null | grep -q 1; then
      echo "[tablet] Boot complete."; break; fi
    sleep 2
  done
fi

device_id=$(flutter devices | awk '/emulator/ {print $1; exit}')
if [[ -z ${device_id} ]]; then
  echo "::error::No emulator device detected after launch" >&2
  exit 1
fi

DART_DEFINES=(--dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true)
if [[ $MODE == prod ]]; then
  if [[ -z ${REVENUECAT_API_KEY:-} ]]; then
    echo "::error::REVENUECAT_API_KEY must be set for --prod mode" >&2
    exit 1
  fi
  DART_DEFINES=(--dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false --dart-define=REVENUECAT_API_KEY=${REVENUECAT_API_KEY})
fi

echo "[tablet] Running app on ${device_id} (mode=$MODE)";
set -x
flutter run -d "${device_id}" "${DART_DEFINES[@]}"
