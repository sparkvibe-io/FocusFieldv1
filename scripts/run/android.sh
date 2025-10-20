#!/bin/bash
set -euo pipefail

# RevenueCat Android Testing Script with Platform-Specific API Keys
echo "🚀 Focus Field - RevenueCat Android Testing"
echo "============================================"

# Try to source .env if present (for REVENUECAT_API_KEY or ANDROID_REVENUECAT_API_KEY)
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env || true
fi

# Determine Android Public API Key
# Priority:
#   1) ANDROID_REVENUECAT_API_KEY env var (explicit)
#   2) REVENUECAT_API_KEY if it starts with goog_
#   3) fallback hardcoded placeholder (must be replaced by you)
ANDROID_API_KEY="${ANDROID_REVENUECAT_API_KEY:-}"
if [[ -z "${ANDROID_API_KEY}" && -n "${REVENUECAT_API_KEY:-}" && "${REVENUECAT_API_KEY}" == goog_* ]]; then
  ANDROID_API_KEY="${REVENUECAT_API_KEY}"
fi
ANDROID_API_KEY="${ANDROID_API_KEY:-goog_HNKHzGPIWgDdqihvtZrmgTdMSzf}"

# Optional: entitlement key override (defaults to 'Premium' in app constants)
DART_DEFINE_ENTITLEMENT_KEY=""
if [[ -n "${REVENUECAT_ENTITLEMENT_KEY:-}" ]]; then
  DART_DEFINE_ENTITLEMENT_KEY="--dart-define=REVENUECAT_ENTITLEMENT_KEY=${REVENUECAT_ENTITLEMENT_KEY}"
fi

RUN_MODE="--profile"  # default to profile for near-release perf
DEVICE_TARGET="android" # let Flutter pick the first Android device by default
# Default dev flag inferred from run mode (debug/profile -> true, release -> false)
IS_DEVELOPMENT=true

# Optional: production banner ad unit id for AdMob (overrides app constants)
DART_DEFINE_BANNER_UNIT=""
if [[ -n "${ANDROID_BANNER_AD_UNIT_ID:-}" ]]; then
  DART_DEFINE_BANNER_UNIT="--dart-define=ANDROID_BANNER_AD_UNIT_ID=${ANDROID_BANNER_AD_UNIT_ID}"
fi

# Extra optional feature flags passed as dart-defines
EXTRA_DART_DEFINES=""

# Args: --debug/--profile/--release, -d <device_id>, --prod (sets IS_DEVELOPMENT=false)
#       --missions (enables FEATURE_MISSIONS_UI)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug) RUN_MODE="--debug"; shift ;;
    --profile) RUN_MODE="--profile"; shift ;;
  --release) RUN_MODE="--release"; IS_DEVELOPMENT=false; shift ;;
    --prod) IS_DEVELOPMENT=false; shift ;;
    --missions) EXTRA_DART_DEFINES+=" --dart-define=FEATURE_MISSIONS_UI=true"; shift ;;
    -d) DEVICE_TARGET="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 2 ;;
  esac
done

echo "📱 Testing on Android device..."
echo "   Using Android API Key: ${ANDROID_API_KEY:0:20}..."
echo "   Run mode: ${RUN_MODE#--}"
echo "   Target: ${DEVICE_TARGET}"
echo "   IS_DEVELOPMENT: ${IS_DEVELOPMENT}"
if [[ -n "${ANDROID_BANNER_AD_UNIT_ID:-}" ]]; then
  echo "   ANDROID_BANNER_AD_UNIT_ID: ${ANDROID_BANNER_AD_UNIT_ID}"
fi

if [[ "${ANDROID_API_KEY}" == "goog_YOUR_ANDROID_PUBLIC_KEY_HERE" ]]; then
  echo "❌ Please set ANDROID_REVENUECAT_API_KEY or REVENUECAT_API_KEY (goog_...) in your environment or .env file"
  echo "   1. Go to RevenueCat Dashboard"
  echo "   2. Navigate to Project Settings > Apps"
  echo "   3. Find your Android app configuration"
  echo "   4. Copy the PUBLIC API key (starts with 'goog_')"
  exit 1
fi

echo ""
echo "🔄 Running Flutter app on Android..."
flutter run \
  ${RUN_MODE} \
  --no-devtools \
  --no-dds \
  --dart-define=IS_DEVELOPMENT=${IS_DEVELOPMENT} \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=REVENUECAT_API_KEY="${ANDROID_API_KEY}" \
  ${DART_DEFINE_BANNER_UNIT} \
  ${EXTRA_DART_DEFINES} \
  ${DART_DEFINE_ENTITLEMENT_KEY} \
  -d "${DEVICE_TARGET}"

echo ""
echo "✅ Testing complete!"
