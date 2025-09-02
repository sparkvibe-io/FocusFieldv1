#!/bin/bash

# SilenceScore Production Build Script
# Simple single-dev variant (Option 1):
#   Export REVENUECAT_API_KEY to the platform-specific key before running OR pass --rc-key=KEY.
#   For Android build:  export REVENUECAT_API_KEY="$REVENUECAT_ANDROID_API_KEY" ; bash scripts/build-prod.sh
#   For iOS build:      export REVENUECAT_API_KEY="$REVENUECAT_IOS_API_KEY" ; flutter build ipa ...
# This script now also:
#   - Auto-sources a project .env (if present) without overwriting an already exported REVENUECAT_API_KEY
#   - Accepts additional --dart-define=XYZ=val arguments that are appended to builds
#   - Accepts --rc-key=VALUE (or --revenuecat-key=VALUE) as a convenience

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR%/scripts}"

# Auto-source .env (if exists) to pick up keys (preserve pre-exported REVENUECAT_API_KEY)
if [ -f "$PROJECT_ROOT/.env" ]; then
    _PRESET_RC_KEY="${REVENUECAT_API_KEY:-}"
    # shellcheck disable=SC2046,SC1090
    set -a; . "$PROJECT_ROOT/.env"; set +a
    if [ -n "$_PRESET_RC_KEY" ]; then
        export REVENUECAT_API_KEY="$_PRESET_RC_KEY"
    fi
fi

# Parse arguments
EXTRA_DART_DEFINES=()
for arg in "$@"; do
    case "$arg" in
        --rc-key=*|--revenuecat-key=*)
            export REVENUECAT_API_KEY="${arg#*=}";
            shift ;;
        --dart-define=*)
            # Collect user-supplied dart-defines (will append later)
            EXTRA_DART_DEFINES+=("$arg")
            shift ;;
        -h|--help)
            cat <<'EOF'
Usage: bash scripts/build-prod.sh [--rc-key=REVENUeCAT_KEY] [--dart-define=FOO=bar]...

Environment (preferred for simplicity):
    export REVENUECAT_API_KEY=your_android_public_key
    bash scripts/build-prod.sh

To pass a key directly:
    bash scripts/build-prod.sh --rc-key=your_android_public_key

Any extra --dart-define= pairs are forwarded to both build commands.
EOF
            exit 0 ;;
        *) ;;
    esac
done

echo "🚀 Building SilenceScore for Production..."

# Validate required environment variables
if [ -z "${REVENUECAT_API_KEY:-}" ] || [ "$REVENUECAT_API_KEY" = "your_revenuecat_public_sdk_key" ]; then
    echo "❌ Error: REVENUECAT_API_KEY is required for production builds"
    echo "   Set the env var or pass --rc-key=KEY"
    echo "   Example: export REVENUECAT_API_KEY='pub_android_xxx' && bash scripts/build-prod.sh"
    echo "         or bash scripts/build-prod.sh --rc-key=pub_android_xxx"
    exit 1
fi

# Set production defaults
IS_DEVELOPMENT="false"
ENABLE_MOCK_SUBSCRIPTIONS="false"
FIREBASE_API_KEY=${FIREBASE_API_KEY:-FIREBASE_API_KEY_NOT_SET}
SENTRY_DSN=${SENTRY_DSN:-}

echo "🔧 Production Configuration:"
echo "   Environment: Production"
echo "   Mock Subscriptions: Disabled"
echo "   RevenueCat Key: ✓ Configured"

# Build release APK
echo "📦 Building release APK..."
flutter build apk --release \
    --dart-define=IS_DEVELOPMENT="$IS_DEVELOPMENT" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="$ENABLE_MOCK_SUBSCRIPTIONS" \
    --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
    --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
    --dart-define=SENTRY_DSN="$SENTRY_DSN" \
    ${EXTRA_DART_DEFINES[@]:+${EXTRA_DART_DEFINES[@]}}

# Build app bundle for Play Store
echo "📦 Building app bundle..."
flutter build appbundle --release \
    --dart-define=IS_DEVELOPMENT="$IS_DEVELOPMENT" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="$ENABLE_MOCK_SUBSCRIPTIONS" \
    --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
    --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
    --dart-define=SENTRY_DSN="$SENTRY_DSN" \
    ${EXTRA_DART_DEFINES[@]:+${EXTRA_DART_DEFINES[@]}}

echo "✅ Production build completed!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 AAB location: build/app/outputs/bundle/release/app-release.aab" 