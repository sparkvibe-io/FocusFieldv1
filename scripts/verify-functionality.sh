#!/bin/bash

# Focus Field - Comprehensive Functionality Verification Script
# This script verifies all core functionality works as intended

set -e

echo "🔍 Focus Field - Comprehensive Functionality Verification"
echo "========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_name="$1"
    local test_command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    print_status "Running: $test_name"

    if eval "$test_command" > /dev/null 2>&1; then
        print_success "$test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        print_error "$test_name"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# 1. ENVIRONMENT VERIFICATION
echo -e "\n${BLUE}1. ENVIRONMENT VERIFICATION${NC}"
echo "-----------------------------"

run_test "Flutter installation" "flutter --version"
run_test "Flutter dependencies" "flutter pub get"
run_test "Code analysis" "flutter analyze --no-fatal-infos"

# 2. AUTOMATED TEST SUITE
echo -e "\n${BLUE}2. AUTOMATED TEST SUITE${NC}"
echo "------------------------"

run_test "Unit tests" "flutter test"
run_test "Widget tests" "flutter test test/widget_test.dart"
run_test "Silence detector tests" "flutter test test/silence_detector_test.dart"
run_test "Notification service tests" "flutter test test/notification_service_test.dart"
run_test "Localization tests" "flutter test test/localization_completeness_test.dart"

# 3. BUILD VERIFICATION
echo -e "\n${BLUE}3. BUILD VERIFICATION${NC}"
echo "---------------------"

run_test "Development APK build" "./scripts/build-dev.sh"
run_test "Debug APK exists" "test -f build/app/outputs/flutter-apk/app-debug.apk"

# 4. CORE FUNCTIONALITY GAPS IDENTIFIED
echo -e "\n${BLUE}4. IDENTIFIED FUNCTIONALITY GAPS${NC}"
echo "----------------------------------"

print_error "CRITICAL BUG: Notification settings persistence"
echo "   → Notification settings (enableNotifications, enableDailyReminders, etc.) are NOT persisted"
echo "   → Missing from StorageService.loadAllSettings() and saveAllSettings()"
echo "   → Settings reset after app restart"

print_warning "Test coverage gaps (19 services, only 3 service tests):"
echo "   → Missing: StorageService tests"
echo "   → Missing: SubscriptionService tests"
echo "   → Missing: ExportService tests"
echo "   → Missing: AnalyticsService tests"
echo "   → Missing: SupportService tests"
echo "   → Missing: ThemeProvider tests"
echo "   → Missing: SubscriptionProvider tests"

print_warning "Integration test coverage:"
echo "   → No end-to-end session flow tests"
echo "   → No subscription purchase flow tests"
echo "   → No data export functionality tests"
echo "   → No permission handling tests"

# 5. MISSING FUNCTIONALITY TESTS
echo -e "\n${BLUE}5. CORE FEATURES NEEDING MANUAL VERIFICATION${NC}"
echo "---------------------------------------------"

echo "❓ Settings Persistence:"
echo "   • Decibel threshold changes"
echo "   • Session duration changes"
echo "   • Theme selection"
echo "   • ⚠️  Notification preferences (BROKEN)"

echo "❓ Session Management:"
echo "   • Start/stop sessions"
echo "   • Progress tracking"
echo "   • Achievement notifications"
echo "   • Session history recording"

echo "❓ Subscription System:"
echo "   • Mock subscription flow"
echo "   • Premium feature gating"
echo "   • Paywall display"
echo "   • Feature unlock verification"

echo "❓ Data Export (Premium):"
echo "   • CSV export functionality"
echo "   • PDF report generation"
echo "   • Share functionality"

echo "❓ Real-time Features:"
echo "   • Noise detection accuracy"
echo "   • Live chart updates"
echo "   • Audio permission handling"
echo "   • Background ambient monitoring"

echo "❓ UI/UX Features:"
echo "   • Multi-language support"
echo "   • Theme switching"
echo "   • Accessibility features"
echo "   • Tip system"

# 6. RECOMMENDATIONS
echo -e "\n${BLUE}6. IMMEDIATE FIXES NEEDED${NC}"
echo "-----------------------------"

print_error "HIGH PRIORITY:"
echo "   1. Fix notification settings persistence"
echo "      → Add constants to StorageService for notification settings"
echo "      → Include in loadAllSettings() and saveAllSettings()"
echo "      → Add default values to initializeApp()"

print_warning "MEDIUM PRIORITY:"
echo "   2. Add missing service tests"
echo "   3. Create integration test suite"
echo "   4. Add settings persistence tests"

print_warning "LOW PRIORITY:"
echo "   5. Add end-to-end automation tests"
echo "   6. Performance testing"
echo "   7. Accessibility testing"

# 7. SUMMARY
echo -e "\n${BLUE}7. VERIFICATION SUMMARY${NC}"
echo "------------------------"

echo "Total tests run: $TOTAL_TESTS"
print_success "Passed: $PASSED_TESTS"
print_error "Failed: $FAILED_TESTS"

if [ $FAILED_TESTS -eq 0 ]; then
    print_success "All automated tests passed! ✅"
    echo "Manual verification still needed for core functionality."
else
    print_error "Some tests failed. Review issues above."
fi

echo -e "\n${YELLOW}⚠️  CRITICAL ISSUE IDENTIFIED:${NC}"
echo "Notification settings do NOT persist after app restart."
echo "This affects user experience and should be fixed immediately."

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Fix notification settings persistence bug"
echo "2. Test core functionality manually on device"
echo "3. Verify subscription system works correctly"
echo "4. Test data export features"

exit $FAILED_TESTS