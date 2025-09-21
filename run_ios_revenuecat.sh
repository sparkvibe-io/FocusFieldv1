#!/bin/bash

# RevenueCat iOS Testing Script with Platform-Specific API Keys
echo "🍎 Focus Field - RevenueCat iOS Testing"
echo "========================================"

# iOS Public API Key (get this from RevenueCat Dashboard > Project Settings > Apps > iOS App)
# This should start with 'appl_' for Apple App Store
IOS_API_KEY="appl_YOUR_IOS_PUBLIC_KEY_HERE"

echo "📱 Testing on iOS device/simulator..."
echo "   Using iOS API Key: ${IOS_API_KEY:0:20}..."

if [[ "$IOS_API_KEY" == "appl_YOUR_IOS_PUBLIC_KEY_HERE" ]]; then
    echo "❌ Please update IOS_API_KEY in this script with your actual RevenueCat iOS public API key"
    echo "   1. Go to RevenueCat Dashboard"
    echo "   2. Navigate to Project Settings > Apps"
    echo "   3. Find your iOS app configuration"
    echo "   4. Copy the PUBLIC API key (starts with 'appl_')"
    exit 1
fi

echo ""
echo "🔄 Running Flutter app on iOS..."
flutter run \
  --dart-define=REVENUECAT_IOS_API_KEY=$IOS_API_KEY \
  -d ios

echo ""
echo "✅ Testing complete!"
echo ""
echo "🔧 Troubleshooting Tips:"
echo "   1. Make sure your iOS device/simulator is connected"
echo "   2. Verify product IDs match your RevenueCat dashboard:"
echo "      - premium_monthly_199"
echo "      - premium_yearly_999" 
echo "      - premium_plus_monthly_399"
echo "      - premium_plus_yearly_2499"
echo "   3. Check entitlements in RevenueCat dashboard:"
echo "      - premium"
echo "      - premium_plus"
echo "   4. Ensure you're using sandbox environment for testing"
echo "   5. For iOS testing, make sure you're signed in with a sandbox test account"