#!/bin/bash

# SilenceScore Development Build Script
# This script loads environment variables and builds the app with proper configuration

set -e

echo "🚀 Building SilenceScore for Development..."

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo "📄 Loading environment from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  No .env file found. Using default development settings."
    echo "   Copy .env.example to .env and configure your API keys."
fi

# Validate required environment variables
if [ -z "$REVENUECAT_API_KEY" ] || [ "$REVENUECAT_API_KEY" = "your_revenuecat_api_key_here" ]; then
    echo "⚠️  REVENUECAT_API_KEY not set. Mock subscriptions will be used."
    REVENUECAT_API_KEY="REVENUECAT_API_KEY_NOT_SET"
    ENABLE_MOCK_SUBSCRIPTIONS="true"
fi

# Set development defaults
IS_DEVELOPMENT=${IS_DEVELOPMENT:-true}
ENABLE_MOCK_SUBSCRIPTIONS=${ENABLE_MOCK_SUBSCRIPTIONS:-true}
FIREBASE_API_KEY=${FIREBASE_API_KEY:-FIREBASE_API_KEY_NOT_SET}
SENTRY_DSN=${SENTRY_DSN:-}

echo "🔧 Configuration:"
echo "   Environment: Development"
echo "   Mock Subscriptions: $ENABLE_MOCK_SUBSCRIPTIONS"
echo "   RevenueCat Key: ${REVENUECAT_API_KEY:0:10}..."

# Build command with dart-define flags
flutter build apk --debug \
    --dart-define=IS_DEVELOPMENT="$IS_DEVELOPMENT" \
    --dart-define=ENABLE_MOCK_SUBSCRIPTIONS="$ENABLE_MOCK_SUBSCRIPTIONS" \
    --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
    --dart-define=FIREBASE_API_KEY="$FIREBASE_API_KEY" \
    --dart-define=SENTRY_DSN="$SENTRY_DSN"

echo "✅ Development build completed!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-debug.apk" 