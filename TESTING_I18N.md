# 🌍 Testing Localization - Quick Guide

## How to Test Different Languages

We've added a `--locale` parameter to the run scripts for easy i18n testing!

### iOS
```bash
./scripts/run/ios.sh --debug --locale es    # Spanish
./scripts/run/ios.sh --debug --locale de    # German
./scripts/run/ios.sh --debug --locale fr    # French
./scripts/run/ios.sh --debug --locale ja    # Japanese
./scripts/run/ios.sh --debug --locale pt    # Portuguese
./scripts/run/ios.sh --debug --locale pt_BR # Brazilian Portuguese
```

### Android
```bash
./scripts/run/android.sh --debug --locale es    # Spanish
./scripts/run/android.sh --debug --locale de    # German
./scripts/run/android.sh --debug --locale fr    # French
./scripts/run/android.sh --debug --locale ja    # Japanese
./scripts/run/android.sh --debug --locale pt    # Portuguese
./scripts/run/android.sh --debug --locale pt_BR # Brazilian Portuguese
```

## What's Been Localized

### ✅ READY TO TEST
1. **Permission Dialogs** (5 keys)
   - Microphone permission request
   - Settings dialog when permission denied
   - All button labels

2. **FAQ System** (45 keys)
   - 20 Q&A pairs
   - Search interface
   - Empty states

### ⏳ TRANSLATIONS READY (Code integration pending)
3. **Onboarding Flow** (64 keys)
   - All 6 onboarding screens
   - Navigation buttons
   - Feature descriptions

## Current Status

- **Languages**: 7 (EN, ES, DE, FR, JA, PT, PT_BR)
- **Total Keys**: 437 per language
- **Parity**: ✅ Perfect (all languages have same keys)
- **Translation Quality**: Machine translated (Google Translate)

## Quick Test Checklist

### Permission Dialogs
1. Delete app or revoke microphone permission
2. Launch app in target language
3. Check dialog title, message, and buttons

### FAQ System
1. Go to Settings > About > Help & Support
2. Tap "FAQs"
3. Verify title, search bar, and Q&A content
4. Test search functionality

### Onboarding (After code integration)
1. Delete app and reinstall OR Settings > Replay Onboarding
2. Go through all 6 screens
3. Verify all text and buttons

## Detailed Testing Guide

See `docs/development/i18n_testing_guide.md` for comprehensive testing instructions.

## Documentation

- **Session Log**: `docs/development/i18n_session_oct20_part2.md`
- **Testing Guide**: `docs/development/i18n_testing_guide.md`
- **Remaining Work**: `docs/development/i18n_remaining_work.md`
