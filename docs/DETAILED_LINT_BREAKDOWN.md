# Detailed Lint Issues Breakdown

**Generated:** September 21, 2025  
**Total Issues:** 130

## 🚨 **Critical Compilation Errors (77 issues)**

### `lib/services/silence_detector.dart` - Import Issues
**Root Cause:** Package name change from `silence_score` to `focus_field` not reflected in imports

**Import Errors (3):**
- Line 6: `package:silence_score/constants/app_constants.dart` → should be `package:focus_field/constants/app_constants.dart`
- Line 7: `package:silence_score/services/audio_circuit_breaker.dart` → should be `package:focus_field/services/audio_circuit_breaker.dart`  
- Line 8: `package:silence_score/utils/debug_log.dart` → should be `package:focus_field/utils/debug_log.dart`

**Undefined Identifier Errors (72):**
- `SafeAudioExecutor` class (lines 35, 35)
- `AppConstants` identifier (lines 44, 45)
- `DebugLog` identifier (68 occurrences throughout file)

**Quick Fix Command:**
```bash
# Update imports in silence_detector.dart
sed -i '' 's/package:silence_score\//package:focus_field\//g' lib/services/silence_detector.dart
```

## ⚠️ **BuildContext Async Issues (11 issues)**

### Files with async context usage needing manual review:

**`lib/screens/app_initializer.dart`**
- Line 54:23 - `use_build_context_synchronously`

**`lib/screens/home_page.dart`**
- Line 626:15 - `use_build_context_synchronously`

**`lib/services/rating_service.dart`**
- Line 276:25 - `use_build_context_synchronously`

**`lib/services/tip_service.dart`** (7 instances)
- Line 112:24 - `use_build_context_synchronously`
- Line 118:35 - `use_build_context_synchronously`
- Line 156:31 - `use_build_context_synchronously`
- Line 163:16 - `use_build_context_synchronously`
- Line 450:28 - `use_build_context_synchronously`
- Line 455:28 - `use_build_context_synchronously`
- Line 596:28 - `use_build_context_synchronously`

**`lib/widgets/notification_settings_widget.dart`** (4 instances)
- Line 252:53 - `use_build_context_synchronously`
- Line 256:51 - `use_build_context_synchronously` (guarded by unrelated mounted check)
- Line 260:90 - `use_build_context_synchronously` (guarded by unrelated mounted check)
- Line 462:53 - `use_build_context_synchronously`

## 🐛 **Production Print Statements (26 issues)**

### `lib/services/audio_circuit_breaker.dart` (24 instances)
**Lines with print statements:** 64, 81, 96, 110, 125, 138, 146, 157, 165, 171, 182, 194, 198, 212, 227, 233, 247, 256, 336, 345, 355, 361, 396, 414

### `lib/services/silence_detector.dart` (2 instances)
**Lines with print statements:** 536, 543

**Quick Fix Commands:**
```bash
# Comment out print statements in audio_circuit_breaker.dart
sed -i '' 's/print(/\/\/ print(/g' lib/services/audio_circuit_breaker.dart

# Comment out print statements in silence_detector.dart  
sed -i '' 's/print(/\/\/ print(/g' lib/services/silence_detector.dart
```

## 🔧 **Style Issues (16 issues)**

### Missing Curly Braces in Flow Control
**`lib/services/audio_circuit_breaker.dart`** (8 instances)
- Lines: 81, 96, 110, 125, 138, 146, 165, 171, 194, 198, 227, 233

**`lib/services/silence_detector.dart`** (1 instance)
- Line: 536

**Auto-fix available:** `dart fix --apply` should handle these

## 📋 **Immediate Action Items**

### **Step 1: Fix Critical Import Errors**
```bash
cd /Users/krishna/Development/FocusField
# Update package imports
find lib/ -name "*.dart" -exec sed -i '' 's/package:silence_score\//package:focus_field\//g' {} \;
# Clean and rebuild
flutter clean
flutter pub get
```

### **Step 2: Remove Print Statements**
```bash
# Comment out all print statements
find lib/ -name "*.dart" -exec sed -i '' 's/print(/\/\/ print(/g' {} \;
```

### **Step 3: Apply Automatic Fixes**
```bash
dart fix --apply
```

### **Step 4: Manual BuildContext Fixes**
Review each file and add proper async context handling:
```dart
// Before async operations, store context or check mounted
if (!mounted) return;
final context = this.context; // Store before async
// ... async operation
if (!mounted) return; // Check again before using context
```

## 🎯 **Expected Results After Quick Fixes**

- **Import fixes:** Should eliminate ~77 compilation errors
- **Print statement removal:** Should eliminate ~26 production warnings  
- **Auto-fixes:** Should eliminate ~16 style issues
- **Remaining:** ~11 BuildContext issues requiring manual review

**Target:** Reduce from 130 to approximately 11 issues with automated fixes.

---

*Run `flutter analyze --no-preamble` after each step to verify progress.*