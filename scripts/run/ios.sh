#!/bin/bash
set -euo pipefail

# RevenueCat iOS Testing Script with Platform-Specific API Keys
echo "🍎 Focus Field - RevenueCat iOS Testing"
echo "========================================"

# Try to source .env if present (for REVENUECAT_API_KEY)
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env || true
fi

# iOS Public API Key (get this from RevenueCat Dashboard > Project Settings > Apps > iOS App)
# Prefer env var REVENUECAT_API_KEY if provided; fallback to hardcoded default.
IOS_API_KEY="${REVENUECAT_API_KEY:-appl_qoFokYDCMBFZLyKXTulaPFkjdME}"

# Optional: comma-separated Apple product IDs for StoreKit diagnostics
# Example: export APPLE_PRODUCT_IDS="premium.tier.monthly,premium.tier.yearly"
DART_DEFINE_APPLE_PRODUCT_IDS=""
if [[ -n "${APPLE_PRODUCT_IDS:-}" ]]; then
  DART_DEFINE_APPLE_PRODUCT_IDS="--dart-define=APPLE_PRODUCT_IDS=${APPLE_PRODUCT_IDS}"
fi

# Optional: iOS Banner Ad Unit override for production testing
DART_DEFINE_IOS_BANNER_UNIT=""
if [[ -n "${IOS_BANNER_AD_UNIT_ID:-}" ]]; then
  DART_DEFINE_IOS_BANNER_UNIT="--dart-define=IOS_BANNER_AD_UNIT_ID=${IOS_BANNER_AD_UNIT_ID}"
fi

# Optional: enable one-time fallback to Google test unit when prod load fails
DART_DEFINE_ADS_FALLBACK=""
if [[ -n "${ADS_FALLBACK_TEST_ON_FAIL:-}" ]]; then
  DART_DEFINE_ADS_FALLBACK="--dart-define=ADS_FALLBACK_TEST_ON_FAIL=${ADS_FALLBACK_TEST_ON_FAIL}"
fi

# Optional: Entitlement key override (defaults to 'Premium' in app constants)
DART_DEFINE_ENTITLEMENT_KEY=""
if [[ -n "${REVENUECAT_ENTITLEMENT_KEY:-}" ]]; then
  DART_DEFINE_ENTITLEMENT_KEY="--dart-define=REVENUECAT_ENTITLEMENT_KEY=${REVENUECAT_ENTITLEMENT_KEY}"
fi

RUN_MODE="--profile"   # default to profile to avoid JIT/memory overhead on device
DEVICE_TARGET="ios"     # default to any connected iOS device/simulator
# Default dev flag inferred from run mode (debug/profile -> true, release -> false)
IS_DEVELOPMENT=true
TEST_LOCALE=""          # Optional locale for i18n testing (e.g., es, de, fr, ja, pt)

# Optional: Test locale for i18n verification
DART_DEFINE_LOCALE=""
if [[ -n "${TEST_LOCALE}" ]]; then
  DART_DEFINE_LOCALE="--dart-define=TEST_LOCALE=${TEST_LOCALE}"
fi

# Basic args:
#   --debug / --profile / --release to set run mode
#   -d <device_id> to target a specific device
#   --locale <code> to test specific language (en, es, de, fr, ja, pt, pt_BR)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      RUN_MODE="--debug"; shift ;;
    --profile)
      RUN_MODE="--profile"; shift ;;
    --release)
      RUN_MODE="--release"; IS_DEVELOPMENT=false; shift ;;
    -d)
      DEVICE_TARGET="$2"; shift 2 ;;
    --locale)
      TEST_LOCALE="$2"; shift 2 ;;
    *)
      echo "Unknown arg: $1"; exit 2 ;;
  esac
done

echo "📱 Testing on iOS device/simulator..."
echo "   Using iOS API Key: ${IOS_API_KEY:0:20}..."
echo "   Run mode: ${RUN_MODE#--}"
echo "   Target: ${DEVICE_TARGET}"
if [[ -n "${TEST_LOCALE}" ]]; then
  echo "   🌍 Testing Locale: ${TEST_LOCALE}"
fi
if [[ -n "${APPLE_PRODUCT_IDS:-}" ]]; then
  echo "   Apple Product IDs: ${APPLE_PRODUCT_IDS}"
fi

if [[ "$IOS_API_KEY" == "appl_YOUR_IOS_PUBLIC_KEY_HERE" ]]; then
  echo "❌ Please set REVENUECAT_API_KEY in your environment or .env file with your actual RevenueCat iOS public API key"
  echo "   1. Go to RevenueCat Dashboard"
  echo "   2. Navigate to Project Settings > Apps"
  echo "   3. Find your iOS app configuration"
  echo "   4. Copy the PUBLIC API key (starts with 'appl_')"
  exit 1
fi

echo ""
echo "🔄 Running Flutter app on iOS..."
# Pass the correct define expected by the app (REVENUECAT_API_KEY)
flutter run \
  ${RUN_MODE} \
  --no-devtools \
  --no-dds \
  --dart-define=IS_DEVELOPMENT=${IS_DEVELOPMENT} \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=REVENUECAT_API_KEY="$IOS_API_KEY" \
  ${DART_DEFINE_APPLE_PRODUCT_IDS} \
  ${DART_DEFINE_IOS_BANNER_UNIT} \
  ${DART_DEFINE_ADS_FALLBACK} \
  ${DART_DEFINE_ENTITLEMENT_KEY} \
  ${DART_DEFINE_LOCALE} \
  -d "${DEVICE_TARGET}"

echo ""
echo "✅ Testing complete!"
echo ""
echo "🔧 Troubleshooting Tips:"
echo "   1. Make sure your iOS device/simulator is connected"
echo "   2. Verify product IDs match your RevenueCat dashboard:"
echo "      - premium.tier.monthly"
echo "      - premium.tier.yearly"
echo "   3. Check entitlements in RevenueCat dashboard:"
echo "      - Premium (Identifier)"
echo "      - If you renamed it, export REVENUECAT_ENTITLEMENT_KEY=YourIdentifier"
echo "   4. Ensure you're using sandbox environment for testing"
echo "   5. For iOS testing, sign in with a sandbox test account on the device (Settings > App Store > Sandbox Account)"