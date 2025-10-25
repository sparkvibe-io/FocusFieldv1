# Scripts Directory

Organized shell scripts for Focus Field development, testing, and deployment.

---

## 📁 Directory Structure

```
scripts/
├── build/          # Build scripts for development and production
├── run/            # Platform-specific run scripts
├── testing/        # Test automation scripts
├── tools/          # Development utilities
└── archive/        # Legacy/deprecated scripts (preserved for reference)
```

---

## 🏗️ Build Scripts (`build/`)

### `build-dev.sh`
Development build with mock subscriptions enabled.

```bash
./scripts/build/build-dev.sh
```

**Features:**
- Loads `.env` file for API keys
- Enables mock subscriptions by default
- Sets `IS_DEVELOPMENT=true`
- Builds debug APK

**Output:** `build/app/outputs/flutter-apk/app-debug.apk`

---

### `build-prod.sh`
Production build with actual RevenueCat integration.

```bash
export REVENUECAT_API_KEY="your_actual_key"
./scripts/build/build-prod.sh
```

**Features:**
- Requires actual RevenueCat API key
- Disables mock subscriptions
- Sets `IS_DEVELOPMENT=false`
- Validates environment variables
- Builds release APK/App Bundle

**Output:**
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

---

### `generate-keystore.sh`
Generate Android keystore for app signing.

```bash
./scripts/build/generate-keystore.sh
```

**Output:** `android/app/focus-field-key.jks`

---

## 🚀 Run Scripts (`run/`)

### `ios.sh`
Run app on iOS device/simulator with RevenueCat integration.

```bash
# Debug mode (default)
./scripts/run/ios.sh --debug

# Profile mode (near-release performance)
./scripts/run/ios.sh --profile

# Release mode
./scripts/run/ios.sh --release

# Target specific device
./scripts/run/ios.sh --debug -d <device_id>
```

**Environment Variables:**
- `REVENUECAT_API_KEY` - iOS API key (appl_...)
- `APPLE_PRODUCT_IDS` - Optional product IDs for diagnostics
- `IOS_BANNER_AD_UNIT_ID` - Optional AdMob banner override
- `ADS_FALLBACK_TEST_ON_FAIL` - Enable test ad fallback
- `REVENUECAT_ENTITLEMENT_KEY` - Optional entitlement override

---

### `android.sh`
Run app on Android device with RevenueCat integration.

```bash
# Debug mode
./scripts/run/android.sh --debug

# Profile mode (default)
./scripts/run/android.sh --profile

# Release mode
./scripts/run/android.sh --release

# Target specific device
./scripts/run/android.sh --debug -d <device_id>

# Enable missions UI (feature flag)
./scripts/run/android.sh --debug --missions
```

**Environment Variables:**
- `REVENUECAT_API_KEY` - Android API key (goog_...)
- `ANDROID_REVENUECAT_API_KEY` - Explicit Android key (takes priority)
- `ANDROID_BANNER_AD_UNIT_ID` - Optional AdMob banner override
- `REVENUECAT_ENTITLEMENT_KEY` - Optional entitlement override

---

### `tablet.sh`
Run app optimized for tablet device.

```bash
./scripts/run/tablet.sh
```

**Features:**
- Targets tablet-specific breakpoints
- Tests responsive design (≥840dp)
- Verifies landscape split-screen layout

---

### `android-dev.sh`
Quick Android development runner.

```bash
./scripts/run/android-dev.sh
```

**Features:**
- Fast iteration development
- Debug mode by default
- No additional configuration needed

---

## 🧪 Testing Scripts (`testing/`)

### `test.sh`
Basic test runner with optional coverage.

```bash
# Run all tests
./scripts/testing/test.sh

# Run with coverage
./scripts/testing/test.sh --coverage

# Run specific tests
./scripts/testing/test.sh --filter "silence_detector"
```

**Output:**
- Test results to console
- Coverage report (if `--coverage` flag used)

---

### `test-comprehensive.sh`
Full test suite with linting and formatting checks.

```bash
./scripts/testing/test-comprehensive.sh
```

**Includes:**
- Flutter analyzer
- Code formatting validation
- All unit tests
- Widget tests
- Integration tests

---

### `test-tip-system.sh`
Focused tests for tip/notification system.

```bash
./scripts/testing/test-tip-system.sh
```

**Tests:**
- Tip display logic
- Notification scheduling
- Localization coverage

---

### `verify-functionality.sh`
End-to-end functionality verification.

```bash
./scripts/testing/verify-functionality.sh
```

**Verifies:**
- Core app functionality
- Critical user flows
- Integration points

---

## 🛠️ Tools (`tools/`)

### `check-localizations.sh`
Validate localization files for completeness.

```bash
./scripts/tools/check-localizations.sh
```

**Checks:**
- All 7 languages have matching keys
- No missing translations
- Placeholder consistency
- ARB file syntax

**Supported Languages:** EN, ES, DE, FR, JA, PT, PT_BR

---

### `coverage-summary.sh`
Generate and display test coverage summary.

```bash
./scripts/tools/coverage-summary.sh
```

**Output:**
- Line coverage percentage
- File-by-file breakdown
- Uncovered lines report

---

### `fix-lint.sh`
Automated linter issue resolution.

```bash
./scripts/tools/fix-lint.sh
```

**Features:**
- Auto-formats code
- Fixes common lint warnings
- Reports unfixable issues

---

## 📦 Archive (`archive/`)

Legacy scripts from initial RevenueCat setup phase. Preserved for reference only.

- `revenuecat-success-summary.sh` - Setup success documentation
- `revenuecat-dashboard-setup.sh` - Dashboard configuration guide
- `test-revenuecat-sandbox.sh` - Early sandbox testing guide
- `test-revenuecat-comprehensive.sh` - Legacy comprehensive test

**Note:** These scripts are not maintained and may be outdated. Use modern equivalents in `run/` and `testing/` directories.

---

## 🔧 Common Workflows

### Initial Setup
```bash
# 1. Copy environment template
cp .env.example .env

# 2. Edit with your API keys
vim .env

# 3. Build development version
./scripts/build/build-dev.sh

# 4. Run on device
./scripts/run/ios.sh --debug
# or
./scripts/run/android.sh --debug
```

### Testing Before Commit
```bash
# 1. Check localizations
./scripts/tools/check-localizations.sh

# 2. Run comprehensive tests
./scripts/testing/test-comprehensive.sh

# 3. Verify coverage
./scripts/testing/test.sh --coverage
./scripts/tools/coverage-summary.sh
```

### Production Release
```bash
# 1. Set production API key
export REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"  # iOS
# or
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"  # Android

# 2. Run comprehensive tests
./scripts/testing/test-comprehensive.sh

# 3. Build production version
./scripts/build/build-prod.sh

# 4. Test on device
./scripts/run/ios.sh --release
# or
./scripts/run/android.sh --release
```

---

## 📝 Notes

- All scripts use `set -euo pipefail` for robust error handling
- Scripts automatically detect and load `.env` file when present
- Run scripts accept `--debug`, `--profile`, or `--release` flags
- Platform-specific API keys are required for production builds
- Test scripts support `--coverage` and `--filter` options

---

**Last Updated:** October 19, 2025 - Script consolidation and organization complete
