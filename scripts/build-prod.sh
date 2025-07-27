#!/bin/bash

# SilenceScore Production Build Script
# This script builds the app for production with proper security validation

set -e

echo "🚀 Building SilenceScore for Production..."

# Validate required environment variables
if [ -z "$REVENUECAT_API_KEY" ] || [ "$REVENUECAT_API_KEY" = "your_revenuecat_api_key_here" ]; then
    echo "❌ Error: REVENUECAT_API_KEY is required for production builds"
    echo "   Set the environment variable or use --dart-define flag"
    echo "   Example: export REVENUECAT_API_KEY='your_actual_key'"
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
    --dart-define=SENTRY_DSN="$SENTRY_DSN"

# Build app bundle for Play Store
echo "📦 Building app bundle..."
flutter build appbundle --release \
    --dart-define=IS_DEVELOPMENT="$IS_DEVELOPMENT" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="$ENABLE_MOCK_SUBSCRIPTIONS" \
    --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
    --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
    --dart-define=SENTRY_DSN="$SENTRY_DSN"

echo "✅ Production build completed!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 AAB location: build/app/outputs/bundle/release/app-release.aab" 