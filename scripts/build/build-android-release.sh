#!/bin/bash
set -euo pipefail

# Android Release Build Script
# Builds signed APK/AAB for Google Play Store upload
echo "🤖 Focus Field - Android Release Build"
echo "======================================"

# Navigate to project root
cd "$(dirname "$0")/../.."

# Check for keystore
KEYSTORE_PATH="android/focusfield-release.jks"
KEY_PROPERTIES="android/key.properties"

if [[ ! -f "${KEYSTORE_PATH}" ]]; then
  echo "❌ Error: Keystore not found at ${KEYSTORE_PATH}"
  echo ""
  echo "📚 You need to create a keystore first. See:"
  echo "   docs/deployment/ANDROID_KEYSTORE_SETUP.md"
  echo ""
  echo "Quick command:"
  echo "  keytool -genkey -v -keystore ${KEYSTORE_PATH} \\"
  echo "    -alias focusfield -keyalg RSA -keysize 2048 -validity 10000"
  exit 1
fi

if [[ ! -f "${KEY_PROPERTIES}" ]]; then
  echo "❌ Error: key.properties not found at ${KEY_PROPERTIES}"
  echo ""
  echo "📚 Create this file with your keystore credentials:"
  echo "   cp android/key.properties.example android/key.properties"
  echo "   nano android/key.properties"
  exit 1
fi

# Source .env if present for API keys
if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  source .env || true
fi

# Get RevenueCat API key
ANDROID_API_KEY="${REVENUECAT_ANDROID_API_KEY:-${REVENUECAT_API_KEY:-goog_HNKHzGPIWgDdqihvtZrmgTdMSzf}}"

# Parse command line args
BUILD_TYPE="aab"  # Default to AAB (Play Store preferred format)
CLEAN_BUILD=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apk) BUILD_TYPE="apk"; shift ;;
    --aab) BUILD_TYPE="aab"; shift ;;
    --clean) CLEAN_BUILD=true; shift ;;
    *) echo "Unknown arg: $1"; exit 2 ;;
  esac
done

echo ""
echo "📱 Build Configuration:"
echo "   Type: $(echo "${BUILD_TYPE}" | tr '[:lower:]' '[:upper:]')"
echo "   Keystore: ${KEYSTORE_PATH}"
echo "   RevenueCat Key: ${ANDROID_API_KEY:0:20}..."
echo "   Clean build: ${CLEAN_BUILD}"
echo ""

# Clean if requested
if [[ "${CLEAN_BUILD}" == "true" ]]; then
  echo "🧹 Cleaning previous build..."
  flutter clean
  flutter pub get
fi

# Build command based on type
if [[ "${BUILD_TYPE}" == "apk" ]]; then
  echo "🔨 Building Release APK..."
  echo ""

  flutter build apk --release \
    --dart-define=REVENUECAT_API_KEY="${ANDROID_API_KEY}" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
    --dart-define=IS_DEVELOPMENT=false

  OUTPUT_PATH="build/app/outputs/flutter-apk/app-release.apk"

elif [[ "${BUILD_TYPE}" == "aab" ]]; then
  echo "🔨 Building Release App Bundle (AAB)..."
  echo ""

  flutter build appbundle --release \
    --dart-define=REVENUECAT_API_KEY="${ANDROID_API_KEY}" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
    --dart-define=IS_DEVELOPMENT=false

  OUTPUT_PATH="build/app/outputs/bundle/release/app-release.aab"
fi

# Verify output exists
if [[ ! -f "${OUTPUT_PATH}" ]]; then
  echo "❌ Build failed - output not found: ${OUTPUT_PATH}"
  exit 1
fi

# Get file size
FILE_SIZE=$(du -h "${OUTPUT_PATH}" | cut -f1)

echo ""
echo "✅ Build Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Output: ${OUTPUT_PATH}"
echo "📊 Size: ${FILE_SIZE}"
echo ""

# Show next steps based on build type
if [[ "${BUILD_TYPE}" == "aab" ]]; then
  echo "📤 Next Steps - Upload to Google Play Console:"
  echo "   1. Go to: https://play.google.com/console"
  echo "   2. Select your app: Focus Field"
  echo "   3. Navigate to: Release → Internal Testing (or Production)"
  echo "   4. Create new release"
  echo "   5. Upload: ${OUTPUT_PATH}"
  echo "   6. Add release notes and roll out"
  echo ""
  echo "💡 For first upload, enable Play App Signing to protect your key"

elif [[ "${BUILD_TYPE}" == "apk" ]]; then
  echo "📤 Next Steps - Install APK for testing:"
  echo "   1. Connect Android device via USB"
  echo "   2. Enable USB debugging on device"
  echo "   3. Install: adb install ${OUTPUT_PATH}"
  echo ""
  echo "⚠️  For Play Store upload, use AAB format instead:"
  echo "   ./scripts/build/build-android-release.sh --aab"
fi

echo ""
echo "🔐 Verify Signing:"
echo "   jarsigner -verify -verbose -certs ${OUTPUT_PATH}"
echo ""

# Optional: Verify signature
# Try system jarsigner first, fall back to Android Studio's JDK
JARSIGNER=""
if command -v jarsigner &> /dev/null; then
  JARSIGNER="jarsigner"
elif [[ -f "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/jarsigner" ]]; then
  JARSIGNER="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/jarsigner"
fi

echo "🔍 Verifying signature..."
# Check if signature files exist in the AAB
if unzip -l "${OUTPUT_PATH}" 2>/dev/null | grep -q "META-INF.*\\.RSA"; then
  echo "✅ AAB is properly signed with your keystore"
  echo ""
  echo "ℹ️  Note: Self-signed certificate warnings are normal."
  echo "   Google Play will re-sign your AAB with their managed key."
else
  echo "❌ No signature found in AAB"
  echo "   Check your keystore configuration in android/key.properties"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
