#!/bin/bash

# RevenueCat Comprehensive Testing Script
echo "🔍 Focus Field - RevenueCat Comprehensive Testing"
echo "=================================================="

# Android Public API Key
ANDROID_API_KEY="goog_OQmcHbcdgUgLCplNGOzHRVwfqVU"

echo "📱 Running comprehensive RevenueCat test..."
echo "   Using Android API Key: ${ANDROID_API_KEY:0:20}..."

# Kill any existing Flutter processes first
echo "🔄 Stopping any existing Flutter sessions..."
pkill -f "flutter run" || true

echo ""
echo "🚀 Starting Flutter app with detailed logging..."
flutter run \
  --dart-define=REVENUECAT_ANDROID_API_KEY=$ANDROID_API_KEY \
  -d ZL8322BT88 \
  --verbose &

FLUTTER_PID=$!
echo "Flutter PID: $FLUTTER_PID"

echo ""
echo "⏳ Waiting for app initialization (30 seconds)..."
sleep 30

echo ""
echo "📊 Test Instructions:"
echo "1. ✅ Check if app launches without crashes"
echo "2. ✅ Check debug logs for RevenueCat initialization"  
echo "3. 🔍 Navigate to subscription/paywall screen in the app"
echo "4. 🔍 Try to trigger a purchase flow"
echo "5. 🔍 Check for product availability errors"
echo ""
echo "🔧 Look for these log messages:"
echo "   - 'SubscriptionService: ✅ Initialized successfully'"
echo "   - 'Customer info received'"
echo "   - Any product/offering errors"
echo ""
echo "💡 To stop testing: Press Ctrl+C or 'q' in the Flutter console"

# Keep the script running until user terminates
wait $FLUTTER_PID
