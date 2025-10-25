#!/bin/bash

# Focus Field - Comprehensive Application Testing Script
# This script provides complete testing coverage for the entire Focus Field application

set -e

echo "🧪 Focus Field - Comprehensive Application Testing Suite"
echo "========================================================"

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
    echo -e "${YELLOW}[TEST]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Check if device is connected
check_device() {
    if ! flutter devices | grep -q "device"; then
        print_error "No Flutter device connected. Please connect a device or start an emulator."
        exit 1
    fi
    print_success "Device detected"
}

# Test runner function
run_test_scenario() {
    local test_name="$1"
    local description="$2"
    local command="$3"

    echo ""
    print_warning "TEST SCENARIO: $test_name"
    echo "Description: $description"
    echo "Command: $command"
    echo ""
    echo "Press Enter to run this test, or 'skip' to skip it:"
    read -r input

    if [ "$input" = "skip" ]; then
        print_warning "Skipped: $test_name"
        return
    fi

    print_status "Running: $test_name"
    if eval "$command"; then
        print_success "Completed: $test_name"
    else
        print_error "Failed: $test_name"
    fi

    echo "Press Enter to continue to next test..."
    read -r
}

# 1. AUTOMATED TESTS
echo -e "\n${BLUE}1. AUTOMATED TESTS${NC}"
echo "-------------------"

print_status "Running unit tests for tip service..."
if flutter test test/tip_service_test.dart; then
    print_success "All tip service unit tests passed"
else
    print_error "Some tip service tests failed"
fi

print_status "Running all automated tests..."
if flutter test; then
    print_success "All automated tests passed"
else
    print_error "Some automated tests failed"
fi

# 2. MANUAL TESTING SCENARIOS
echo -e "\n${BLUE}2. MANUAL TESTING SCENARIOS${NC}"
echo "-----------------------------"

# Check if device is connected
check_device

# Development Mode Tests
run_test_scenario \
    "Development Mode - Automatic Tip Display" \
    "Tips should appear automatically 2 seconds after app startup in dev mode" \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

run_test_scenario \
    "Development Mode - Frequent Tips" \
    "New tips should generate every 5 minutes in dev mode (wait 5+ minutes and check lightbulb)" \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# Production Mode Tests
run_test_scenario \
    "Production Mode - Respectful Frequency" \
    "Tips should appear max every 48 hours, with 4-second delay on startup" \
    "flutter run --dart-define=IS_DEVELOPMENT=false --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# Settings Integration Tests
run_test_scenario \
    "Settings Integration - Tip Toggle" \
    "Verify tip setting controls both manual and automatic tips. Check settings description." \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# Manual Tip Tests
run_test_scenario \
    "Manual Tip Access - Lightbulb Icon" \
    "Test clicking lightbulb icon shows tips regardless of automatic settings" \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# 3. EDGE CASE TESTING
echo -e "\n${BLUE}3. EDGE CASE TESTING${NC}"
echo "--------------------"

run_test_scenario \
    "Tips Disabled State" \
    "When tips are disabled in settings, no automatic tips should appear" \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

run_test_scenario \
    "Session Active Prevention" \
    "Tips should never appear during active silence sessions" \
    "flutter run --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

run_test_scenario \
    "App Restart Persistence" \
    "Tip preferences and frequency tracking should persist across app restarts" \
    "flutter run --dart-define=IS_DEVELOPMENT=false --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# 4. PERFORMANCE TESTING
echo -e "\n${BLUE}4. PERFORMANCE TESTING${NC}"
echo "-----------------------"

run_test_scenario \
    "Memory Leak Check" \
    "Monitor app for memory leaks with tip timers (use dev tools)" \
    "flutter run --profile --dart-define=IS_DEVELOPMENT=true --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET"

# 5. TESTING INSTRUCTIONS
echo -e "\n${BLUE}5. MANUAL TESTING CHECKLIST${NC}"
echo "-----------------------------"

echo "For each test scenario, verify the following:"
echo ""
echo "✅ Development Mode Tests:"
echo "   • Tip appears 2 seconds after app startup"
echo "   • Lightbulb shows amber glow when new tips available"
echo "   • New tips generate every 5 minutes"
echo "   • Tips never show during active sessions"
echo ""
echo "✅ Production Mode Tests:"
echo "   • Tip appears 4 seconds after app startup (first time)"
echo "   • No automatic tips within 48 hours of last tip"
echo "   • Settings description mentions '2-3 days' frequency"
echo "   • Manual lightbulb access always works"
echo ""
echo "✅ Settings Integration:"
echo "   • 'Show Tips' toggle controls automatic tips"
echo "   • Setting description is clear and accurate"
echo "   • Manual lightbulb respects the setting"
echo ""
echo "✅ Edge Cases:"
echo "   • No tips when setting is disabled"
echo "   • No automatic tips during silence sessions"
echo "   • Preferences persist across app restarts"
echo "   • No memory leaks or hanging timers"

# 6. COVERAGE REPORT
echo -e "\n${BLUE}6. TESTING COVERAGE REPORT${NC}"
echo "---------------------------"

print_status "Generating test coverage report..."
if flutter test --coverage; then
    print_success "Coverage report generated in coverage/lcov.info"

    # Try to generate HTML coverage report if lcov is available
    if command -v lcov >/dev/null 2>&1; then
        print_status "Generating HTML coverage report..."
        genhtml coverage/lcov.info -o coverage/html
        print_success "HTML coverage report generated in coverage/html/"
        echo "Open coverage/html/index.html in your browser to view detailed coverage"
    else
        print_warning "Install lcov to generate HTML coverage reports: brew install lcov"
    fi
else
    print_error "Coverage generation failed"
fi

# 7. SUMMARY
echo -e "\n${BLUE}7. TESTING SUMMARY${NC}"
echo "------------------"

echo "Current Test Structure:"
echo "• Total Test Files: 14"
echo "• Service Files: 19"
echo "• Service Test Files: 3 (tip_service, notification_service, rating_service)"
echo "• Tip Service Tests: 8 test cases"
echo ""
echo "Coverage Gaps:"
echo "• Missing service tests: 16 services need testing"
echo "• Integration tests: End-to-end tip flow testing"
echo "• Performance tests: Memory and timer management"
echo ""
echo "Recommendations:"
echo "• Add tests for StorageService, SubscriptionService, ExportService"
echo "• Create integration tests for tip display flow"
echo "• Add performance monitoring for tip timers"
echo "• Consider adding visual regression tests for tip UI"

echo -e "\n${GREEN}🎉 Comprehensive Application Testing Complete!${NC}"
echo "Review the manual testing checklist above and verify all scenarios work as expected."
echo ""
echo "For focused tip system testing only, run: ./scripts/testing/test-tip-system.sh"
