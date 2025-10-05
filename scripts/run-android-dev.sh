#!/usr/bin/env bash
set -euo pipefail

# Quick runner for Android in development with mock subscriptions
# Usage:
#   ./scripts/run-android-dev.sh           # auto-pick a device (if only one)
#   ./scripts/run-android-dev.sh <deviceId> # specify a device id from `flutter devices`

DEVICE_ID="${1:-}"

CMD=(
  flutter run
  --profile
  --dart-define=IS_DEVELOPMENT=true
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true
  --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
)

if [[ -n "${DEVICE_ID}" ]]; then
  CMD+=(-d "${DEVICE_ID}")
fi

exec "${CMD[@]}"
