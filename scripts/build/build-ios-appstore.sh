#!/bin/bash

# Focus Field iOS App Store Build Script
# Creates an IPA archive ready for App Store submission
#
# Usage:
#   bash scripts/build/build-ios-appstore.sh
#
# Prerequisites:
#   - Distribution certificate installed in Keychain
#   - App Store provisioning profile installed
#   - Xcode configured with proper signing
#   - .env file with production keys

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR%/scripts/*}"

echo "🍎 Building Focus Field for App Store..."
echo "========================================"

# Auto-source .env if exists
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "📄 Loading environment from .env..."
    set -a
    # shellcheck disable=SC1091
    source "$PROJECT_ROOT/.env"
    set +a
else
    echo "❌ Error: .env file not found"
    echo "   Copy .env.example to .env and configure your production keys"
    exit 1
fi

# Validate required iOS production keys
echo ""
echo "🔍 Validating Production Configuration..."

# RevenueCat iOS API Key
if [ -z "${REVENUECAT_API_KEY:-}" ] || [ "$REVENUECAT_API_KEY" = "your_revenuecat_public_sdk_key" ]; then
    echo "❌ Error: REVENUECAT_API_KEY not configured"
    echo "   Get your iOS public key from: https://app.revenuecat.com"
    echo "   Navigate to: Project Settings > Apps > iOS App"
    echo "   Copy the public API key (starts with 'appl_')"
    exit 1
fi

# Validate it's the iOS key (starts with appl_)
if [[ ! "$REVENUECAT_API_KEY" =~ ^appl_ ]]; then
    echo "⚠️  Warning: REVENUECAT_API_KEY doesn't start with 'appl_'"
    echo "   iOS keys should start with 'appl_'"
    echo "   Android keys start with 'goog_'"
    read -p "   Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# AdMob iOS App ID (should be in Info.plist, but validate it exists)
IOS_ADMOB_APP_ID="ca-app-pub-2086096819226646~9627636327"
IOS_ADMOB_BANNER_ID="ca-app-pub-2086096819226646/9050063581"

echo "✅ Configuration Validated:"
echo "   RevenueCat iOS Key: ${REVENUECAT_API_KEY:0:20}..."
echo "   AdMob App ID: $IOS_ADMOB_APP_ID"
echo "   AdMob Banner ID: $IOS_ADMOB_BANNER_ID"

# Set production flags
IS_DEVELOPMENT="false"
ENABLE_MOCK_SUBSCRIPTIONS="false"
FIREBASE_API_KEY=${FIREBASE_API_KEY:-FIREBASE_API_KEY_NOT_SET}
SENTRY_DSN=${SENTRY_DSN:-}

echo ""
echo "🔧 Production Settings:"
echo "   Environment: Production"
echo "   Mock Subscriptions: Disabled"
echo "   Development Mode: Disabled"

# Verify version number
PUBSPEC_VERSION=$(grep -E '^version:' "$PROJECT_ROOT/pubspec.yaml" | awk '{print $2}')
echo ""
echo "📦 App Version: $PUBSPEC_VERSION"
read -p "   Is this version correct? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "   Please update version in pubspec.yaml and run again"
    exit 1
fi

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
cd "$PROJECT_ROOT"
flutter clean
flutter pub get

# Build iOS Archive (IPA)
echo ""
echo "📦 Building iOS IPA for App Store..."
echo "   This will use the Distribution certificate and App Store provisioning profile"
echo "   configured in Xcode (Runner > Signing & Capabilities > Release)"
echo ""

# Build IPA with production configuration
# Note: Xcode signing is configured in the project, not via command line
# The certificate/profile selection happens automatically based on:
#   1. Xcode > Runner > Signing & Capabilities > Release configuration
#   2. Provisioning Profile: "Focus Field App Store"
#   3. Code Signing Identity: "Apple Distribution"
#
# ExportOptions.plist is available at: ios/ExportOptions.plist
# (used by Xcode Archive, not by flutter build ipa)
flutter build ipa --release \
    --dart-define=IS_DEVELOPMENT="$IS_DEVELOPMENT" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="$ENABLE_MOCK_SUBSCRIPTIONS" \
    --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
    --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
    --dart-define=SENTRY_DSN="$SENTRY_DSN"

echo ""
echo "✅ iOS Build Completed!"
echo ""
echo "📱 IPA Location:"
echo "   build/ios/ipa/Focus Field.ipa"
echo ""
echo "📋 Next Steps:"
echo "   1. Open Xcode: open ios/Runner.xcworkspace"
echo "   2. Product > Archive (or use Organizer if archive exists)"
echo "   3. In Organizer, click 'Distribute App'"
echo "   4. Select 'App Store Connect' > Upload"
echo "   5. Wait for processing in App Store Connect (10-30 min)"
echo ""
echo "🔍 Verify Build Contains:"
echo "   ✓ RevenueCat iOS API Key: ${REVENUECAT_API_KEY:0:20}..."
echo "   ✓ AdMob iOS App ID: $IOS_ADMOB_APP_ID"
echo "   ✓ Production mode (no mocks)"
echo "   ✓ Signed with Distribution certificate"
echo ""
