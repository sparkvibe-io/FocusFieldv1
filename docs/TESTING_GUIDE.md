# Focus Field - Comprehensive Testing Guide

## Overview

Focus Field has a robust testing infrastructure with automated unit tests, integration tests, and manual testing procedures. This guide covers all testing aspects with special focus on the tip system functionality.

## 📊 Current Test Coverage

### Test Statistics
- **Total Test Files**: 14
- **Service Files**: 19
- **Service Test Coverage**: 3/19 (16%)
- **Total Test Cases**: 32 (all passing)
- **UI Test Coverage**: Widget tests for core functionality

### Test File Structure
```
test/
├── localization_*_test.dart        # Internationalization tests (7 files)
├── notification_service_test.dart  # Notification system tests
├── notification_scheduling_test.dart # Notification timing tests
├── rating_service_test.dart        # App rating prompt tests
├── silence_detector_test.dart      # Core noise detection tests
├── tip_service_test.dart          # Tip system tests (enhanced)
├── weekly_schedule_test.dart       # Weekly notification tests
└── widget_test.dart               # UI integration tests
```

## 🧪 Test Categories

### 1. Automated Unit Tests

**Command**: `flutter test`

**Coverage**:
- ✅ Tip service (8 test cases)
- ✅ Notification service (4 test cases)
- ✅ Rating service (2 test cases)
- ✅ Silence detector (core functionality)
- ✅ Localization (7 languages)
- ✅ Widget integration (6 test cases)

**Missing Coverage**:
- ❌ StorageService (critical for data persistence)
- ❌ SubscriptionService (monetization features)
- ❌ ExportService (premium data export)
- ❌ AnalyticsService (user behavior tracking)
- ❌ 13 other services

### 2. Tip System Tests (Enhanced)

**File**: `test/tip_service_test.dart`

**Test Cases**:
1. **Toggle persistence** - Settings survive app restarts
2. **Manual tip display** - Lightbulb icon functionality
3. **Unlimited viewing** - No restrictions on manual access
4. **Production tip controls** - Frequency limit settings
5. **Frequency tracking** - 48-hour production limits
6. **hasNewTips logic** - Provider state management
7. **Disabled state handling** - Respects user preferences
8. **Environment detection** - Test vs dev vs production

### 3. Manual Testing Scripts

**Comprehensive Testing**: `scripts/test-comprehensive.sh`
```bash
./scripts/test-comprehensive.sh
```
*Complete application testing including tip system, notifications, core functionality*

**Tip System Specific**: `scripts/test-tip-system.sh`
```bash
./scripts/test-tip-system.sh
```
*Focused testing of tip system functionality only*

**Test Scenarios**:
- Development mode automatic tips
- Production mode frequency limits
- Settings integration
- Edge case handling
- Performance monitoring

## 🎯 Tip System Testing Guide

### Development Mode Testing

**Expected Behavior**:
- Tips appear 2 seconds after app startup
- New tips generate every 5 minutes
- Lightbulb shows amber glow for new tips
- Never shows during active sessions

**Test Command**:
```bash
flutter run --dart-define=IS_DEVELOPMENT=true \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true \
  --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
```

**Manual Verification**:
1. Launch app and wait 2 seconds
2. Verify tip appears automatically
3. Click lightbulb icon multiple times
4. Wait 5+ minutes and check for new tips
5. Start a session and verify no automatic tips

### Production Mode Testing

**Expected Behavior**:
- Tips appear 4 seconds after app startup (first time)
- Maximum frequency: every 48 hours
- Settings show "2-3 days" frequency
- Manual lightbulb always works

**Test Command**:
```bash
flutter run --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true \
  --dart-define=REVENUECAT_API_KEY=REVENUECAT_API_KEY_NOT_SET
```

**Manual Verification**:
1. Fresh install - verify first tip appears after 4 seconds
2. Force-close and restart - verify no immediate tip
3. Check settings description mentions frequency
4. Test lightbulb manual access

### Settings Integration Testing

**Test Areas**:
- "Show Tips" toggle controls automatic tips
- Setting description accuracy
- Preference persistence across restarts
- Manual access respect for settings

**Verification Steps**:
1. Go to Settings → Show Tips
2. Toggle OFF and restart app
3. Verify no automatic tips appear
4. Test lightbulb still works (if enabled in code)
5. Toggle ON and verify tips resume

## 🔧 Running Tests

### Quick Test Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/tip_service_test.dart

# Run tip system test script
./scripts/test-tip-system.sh

# Run verification script
./scripts/verify-functionality.sh
```

### Coverage Analysis

```bash
# Generate coverage
flutter test --coverage

# View coverage (if lcov installed)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📋 Manual Testing Checklist

### Core Functionality
- [ ] App launches without errors
- [ ] Session start/stop works correctly
- [ ] Noise detection accuracy
- [ ] Settings persistence
- [ ] Theme switching

### Tip System Specific
- [ ] Development mode automatic tips (2s delay)
- [ ] Production mode frequency limits (48h)
- [ ] Manual lightbulb access works
- [ ] Settings toggle controls behavior
- [ ] No tips during active sessions
- [ ] Tip content displays correctly
- [ ] Close button works
- [ ] Auto-dismiss after 10 seconds

### Edge Cases
- [ ] App restart maintains settings
- [ ] Disabled tips stay disabled
- [ ] Session interruption handling
- [ ] Memory management (no leaks)
- [ ] Timer cleanup in tests

## 🐛 Known Testing Gaps

### High Priority
1. **StorageService Tests** - Critical for data persistence
2. **SubscriptionService Tests** - Required for monetization
3. **Integration Tests** - End-to-end user flows

### Medium Priority
1. **ExportService Tests** - Premium feature validation
2. **AnalyticsService Tests** - User behavior tracking
3. **Performance Tests** - Memory and timing validation

### Low Priority
1. **Visual Regression Tests** - UI consistency
2. **Accessibility Tests** - Screen reader support
3. **Localization Tests** - Additional language coverage

## 🚀 Test Automation

### Continuous Integration
The existing test suite runs in CI/CD with:
- All 32 unit tests
- Widget integration tests
- Localization completeness tests
- Code analysis and formatting

### Test Categories by Priority

**P0 (Critical)**:
- Tip service functionality
- Core silence detection
- Basic UI functionality

**P1 (High)**:
- Settings persistence
- Notification scheduling
- User preferences

**P2 (Medium)**:
- Localization accuracy
- Performance metrics
- Error handling

## 📝 Adding New Tests

### For New Features
1. Create test file in `test/` directory
2. Follow existing naming convention
3. Include setup/teardown for SharedPreferences
4. Add both unit and integration tests
5. Update this documentation

### For Tip System Features
1. Add tests to `test/tip_service_test.dart`
2. Include both automated and manual test scenarios
3. Update `scripts/test-tip-system.sh` if needed
4. Verify production and development mode behavior

## 🎯 Testing Best Practices

### Automated Tests
- Use `SharedPreferences.setMockInitialValues({})` in setUp
- Properly dispose of ProviderContainers
- Wait for timers with appropriate delays
- Test both positive and negative cases

### Manual Tests
- Test on real devices when possible
- Verify both development and production modes
- Check settings persistence across app restarts
- Monitor for memory leaks and performance issues

### Documentation
- Keep test documentation updated
- Document manual test procedures
- Include expected vs actual behavior
- Note any known limitations or workarounds

---

**Last Updated**: September 2024
**Test Coverage**: 32 automated tests passing
**Manual Test Scripts**: Available in `scripts/` directory