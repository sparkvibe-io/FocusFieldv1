#!/bin/bash

# RevenueCat Android Testing Script with Platform-Specific API Keys
echo "🚀 Focus Field - RevenueCat Android Testing"
echo "============================================"

# Android Public API Key (get this from RevenueCat Dashboard > Project Settings > Apps > Android App)
# This should start with 'goog_' for Google Play Store
ANDROID_API_KEY="goog_OQmcHbcdgUgLCplNGOzHRVwfqVU"

echo "📱 Testing on Android device..."
echo "   Using Android API Key: ${ANDROID_API_KEY:0:20}..."

if [[ "$ANDROID_API_KEY" == "goog_YOUR_ANDROID_PUBLIC_KEY_HERE" ]]; then
    echo "❌ Please update ANDROID_API_KEY in this script with your actual RevenueCat Android public API key"
    echo "   1. Go to RevenueCat Dashboard"
    echo "   2. Navigate to Project Settings > Apps"
    echo "   3. Find your Android app configuration"
    echo "   4. Copy the PUBLIC API key (starts with 'goog_')"
    exit 1
fi

echo ""
echo "🔄 Running Flutter app on Android..."
# Pass the correct define expected by the app (REVENUECAT_API_KEY)
flutter run \
  --dart-define=REVENUECAT_API_KEY=$ANDROID_API_KEY \
  -d ZL8322BT88

echo ""
echo "✅ Testing complete!"
