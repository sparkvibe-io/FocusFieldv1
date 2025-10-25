# i18n Testing Guide

**Last Updated**: October 20, 2025
**Purpose**: Test localized strings across all 7 supported languages

---

## 🌍 Supported Languages

| Code | Language | Status |
|------|----------|--------|
| `en` | English | ✅ Reference language |
| `es` | Spanish (Español) | ✅ Machine translated |
| `de` | German (Deutsch) | ✅ Machine translated |
| `fr` | French (Français) | ✅ Machine translated |
| `ja` | Japanese (日本語) | ✅ Machine translated |
| `pt` | Portuguese (Português) | ✅ Machine translated |
| `pt_BR` | Brazilian Portuguese | ✅ Machine translated |

**Total Keys Per Language**: 437

---

## 🚀 Quick Start - Testing with Locale Parameter

### iOS Testing

```bash
# Test English (default)
./scripts/run/ios.sh --debug

# Test Spanish
./scripts/run/ios.sh --debug --locale es

# Test German
./scripts/run/ios.sh --debug --locale de

# Test French
./scripts/run/ios.sh --debug --locale fr

# Test Japanese
./scripts/run/ios.sh --debug --locale ja

# Test Portuguese
./scripts/run/ios.sh --debug --locale pt

# Test Brazilian Portuguese
./scripts/run/ios.sh --debug --locale pt_BR
```

### Android Testing

```bash
# Test English (default)
./scripts/run/android.sh --debug

# Test Spanish
./scripts/run/android.sh --debug --locale es

# Test German
./scripts/run/android.sh --debug --locale de

# Test French
./scripts/run/android.sh --debug --locale fr

# Test Japanese
./scripts/run/android.sh --debug --locale ja

# Test Portuguese
./scripts/run/android.sh --debug --locale pt

# Test Brazilian Portuguese
./scripts/run/android.sh --debug --locale pt_BR
```

---

## ✅ What to Test

### 1. Permission Dialogs (COMPLETE - Ready to Test)

**How to Trigger**:
- Launch app for the first time
- OR: Revoke microphone permission and restart app
- OR: From Settings > Advanced > Clear App Data (then restart)

**What to Check**:
- ✅ Dialog title displays in target language
- ✅ Dialog message text displays correctly
- ✅ "Later" button label is localized
- ✅ "Grant Permission" button label is localized
- ✅ Settings dialog title ("Settings Required") is localized
- ✅ Settings dialog message with platform-specific instructions is localized
- ✅ "OK" and "Open Settings" buttons are localized

**Example Expected Text (Spanish)**:
```
Title: "Permiso de Micrófono"
Message: "Focus Field mide los niveles de sonido ambiente..."
Buttons: "Más Tarde", "Otorgar Permiso"
```

---

### 2. FAQ System (COMPLETE - Ready to Test)

**How to Access**:
- Go to Settings (gear icon)
- Tap "About" section
- Tap "Help & Support"
- Tap "FAQs" button

**What to Check**:
- ✅ FAQ modal title ("Frequently Asked Questions") is localized
- ✅ Search hint text ("Search FAQs...") is localized
- ✅ All 20 Q&A pairs display in target language
- ✅ Search functionality works with localized text
- ✅ Results count message is localized
- ✅ Empty state messages ("No results found") are localized
- ✅ Emojis display correctly across all languages

**Example Expected Text (German)**:
```
Title: "Häufig gestellte Fragen"
Search: "FAQs durchsuchen..."
Q1: "Was ist Focus Field und wie hilft es mir, mich zu konzentrieren?"
```

---

### 3. Onboarding Flow (90% COMPLETE - Translations Ready, Code Integration Pending)

**How to Access**:
- Delete app and reinstall
- OR: Settings > Advanced > Replay Onboarding

**What to Check** (once code integration complete):
- ✅ All 6 onboarding screens
- ✅ Navigation buttons (Back, Skip, Next, Get Started)
- ✅ Welcome screen feature cards
- ✅ Environment selection options with dB labels
- ✅ Goal selection options with advice messages
- ✅ Activity selection with descriptions
- ✅ Permission/Privacy screen assurances
- ✅ Tips screen with 4 pro tips
- ✅ All emojis preserved across languages

**Expected Screens**:
1. Welcome & Features
2. Environment Selection
3. Daily Goal Setting
4. Activity Selection
5. Permission/Privacy
6. Quick Tips

---

## 🧪 Testing Checklist

### General Checks (All Languages)

- [ ] App title displays correctly
- [ ] Text doesn't overflow containers
- [ ] Line breaks appear natural
- [ ] Emojis render properly
- [ ] RTL languages (if added) display correctly
- [ ] Buttons are tappable (no overlapping text)
- [ ] All text is readable (good contrast)

### Language-Specific Checks

#### Spanish (es)
- [ ] Accents display: á, é, í, ó, ú, ñ
- [ ] Inverted punctuation: ¿, ¡
- [ ] Gender agreement correct

#### German (de)
- [ ] Umlauts display: ä, ö, ü, ß
- [ ] Compound words don't overflow
- [ ] Capitalized nouns correct

#### French (fr)
- [ ] Accents display: é, è, ê, ë, à, ù, ç
- [ ] Apostrophes correct: l', d', qu'
- [ ] Spacing before punctuation (« »)

#### Japanese (ja)
- [ ] Kanji, Hiragana, Katakana mix correctly
- [ ] Text wrapping works properly
- [ ] Font renders all characters
- [ ] No "tofu" (□) characters

#### Portuguese (pt / pt_BR)
- [ ] Accents display: ã, õ, á, é, í, ó, ú, â, ê, ô, ç
- [ ] Brazilian vs. European differences noted
- [ ] Natural phrasing

---

## 📊 Key Metrics to Verify

### Translation Coverage
```bash
# Check key parity across all languages
for lang in en es de fr ja pt pt_BR; do
  echo -n "$lang: "
  jq 'to_entries | map(select(.key | startswith("@") | not)) | length' \
    lib/l10n/app_$lang.arb
done
```

**Expected Output**: All files show `437` keys

### Localization Completeness
- FAQ System: 45/45 keys ✅
- Permission Dialogs: 5/5 keys ✅
- Onboarding: 64/64 keys ✅ (code integration pending)
- Core UI: 313/313 keys ✅
- **Total**: 427/427 keys with translations

---

## 🐛 Common Issues to Watch For

### Text Overflow
- **Symptom**: Text cut off or button labels truncated
- **Cause**: Translations longer than English
- **Fix**: Increase widget width or use responsive sizing

### Missing Translations
- **Symptom**: English text appears in non-English locale
- **Cause**: Missing key or hardcoded string
- **Fix**: Add key to all ARB files or update code to use AppLocalizations

### Encoding Issues
- **Symptom**: Garbled characters or boxes (□)
- **Cause**: Font doesn't support character set
- **Fix**: Ensure app uses Unicode-compatible fonts

### Emoji Issues
- **Symptom**: Emojis display as boxes or text
- **Cause**: Platform emoji support varies
- **Fix**: Test on real devices (emulators may differ)

---

## 🔧 Advanced Testing

### Change Device Language
Instead of using `--locale` parameter, you can test system integration:

**iOS**:
1. Settings > General > Language & Region
2. Add/Select target language
3. Restart app

**Android**:
1. Settings > System > Languages & input
2. Add/Select target language
3. Restart app

### Debug Locale Selection
Add debug output in `main.dart`:
```dart
debugPrint('🌍 App Locale: ${forcedLocale ?? "System Default"}');
```

### Verify ARB File Integrity
```bash
# Validate JSON structure
for file in lib/l10n/*.arb; do
  echo "Checking $file..."
  jq empty "$file" && echo "✅ Valid" || echo "❌ Invalid JSON"
done
```

---

## 📝 Reporting Issues

When reporting localization issues, include:

1. **Language Code**: Which locale (es, de, fr, etc.)
2. **Location**: Where in app (FAQ, permission dialog, onboarding, etc.)
3. **Issue Type**: Missing, incorrect, overflow, encoding, etc.
4. **Screenshot**: Visual evidence
5. **Expected vs. Actual**: What should appear vs. what appears
6. **Device Info**: iOS/Android version, device model

**Example Report**:
```
Language: Spanish (es)
Location: Permission Dialog
Issue: "Grant Permission" button text overflows
Expected: "Otorgar Permiso"
Actual: "Otorgar Per..." (truncated)
Device: iPhone 12, iOS 17.0
```

---

## 🎯 Testing Priorities

### High Priority (Test First)
1. ✅ Permission dialogs - First user interaction
2. ✅ FAQ system - User support/troubleshooting
3. ⏳ Onboarding - First-time user experience (pending code integration)

### Medium Priority
4. Settings UI strings
5. Error messages
6. Notification text

### Low Priority (Future)
7. Tooltips
8. Debug messages
9. Developer-facing text

---

## 📚 Resources

- **ARB Files**: `lib/l10n/app_*.arb`
- **Generated Classes**: `lib/l10n/app_localizations*.dart` (auto-generated)
- **Implementation**: `lib/main.dart` (locale override), `lib/screens/settings_sheet.dart` (FAQ)
- **Documentation**:
  - `docs/development/i18n_session_oct20_part2.md` - Session log
  - `docs/development/i18n_remaining_work.md` - Future work
  - `CLAUDE.md` - Project overview

---

## 🚦 Testing Status

| Feature | Translations | Code Integration | Testing |
|---------|--------------|------------------|---------|
| Permission Dialogs | ✅ Complete | ✅ Complete | ⏳ Pending |
| FAQ System | ✅ Complete | ✅ Complete | ⏳ Pending |
| Onboarding | ✅ Complete | ⏳ 10% remaining | ⏳ Blocked |
| Core UI | ✅ Complete | ✅ Complete | ✅ Verified |

**Next Steps**:
1. Complete onboarding code integration (64 string replacements)
2. Run `flutter gen-l10n`
3. Test all 3 features in all 7 languages
4. Fix any issues found
5. Update this doc with test results

---

**Happy Testing! 🌍🚀**
