# Adding a New Language to Focus Field

This guide explains how to add support for a new language (e.g., Chinese, Korean, Italian, etc.) to the Focus Field app.

## Overview

Focus Field currently supports 7 languages:
- English (EN)
- Spanish (ES)
- German (DE)
- French (FR)
- Japanese (JA)
- Portuguese (PT)
- Brazilian Portuguese (PT_BR)

Each language file contains **740 localization keys** covering all user-facing strings in the app.

---

## Step-by-Step Process

### 1. Create the ARB File

**File Naming Convention:**
- Simplified Chinese: `lib/l10n/app_zh.arb` or `lib/l10n/app_zh_CN.arb`
- Traditional Chinese: `lib/l10n/app_zh_TW.arb`
- Korean: `lib/l10n/app_ko.arb`
- Italian: `lib/l10n/app_it.arb`

**Action:**
```bash
# Copy English file as template
cp lib/l10n/app_en.arb lib/l10n/app_zh.arb
```

### 2. Translate All Keys

You now have a file with 740 English strings. You need to translate each value to Chinese.

**Example Entries:**

```json
{
  "appTitle": "Focus Field",
  "@appTitle": {
    "description": "The name of the application"
  },
  "sessionStart": "开始",
  "@sessionStart": {
    "description": "Button label to start a session"
  },
  "sessionStop": "停止",
  "@sessionStop": {
    "description": "Button label to stop a session"
  },
  "focusModeButton": "专注模式",
  "@focusModeButton": {
    "description": "Button to enter focus mode"
  },
  "onboardingWelcomeTitle": "欢迎来到 Focus Field",
  "@onboardingWelcomeTitle": {
    "description": "Welcome screen title"
  }
}
```

**Important:**
- Only translate the **values**, not the keys
- Keep `@keyName` metadata entries unchanged
- Preserve all placeholders like `{value}`, `{min}`, `{max}`
- Maintain the exact same key count (740 keys)

**Example with Placeholder:**
```json
{
  "sessionDuration": "持续时间: {minutes} 分钟",
  "@sessionDuration": {
    "description": "Shows session duration",
    "placeholders": {
      "minutes": {
        "type": "int"
      }
    }
  }
}
```

### 3. Translation Options

**Option A: Professional Translation Service**
- **Pros**: High quality, culturally appropriate
- **Cons**: Expensive ($0.08-0.15 per word ≈ $500-1000 for 740 strings)
- **Services**: Gengo, Lokalise, Phrase

**Option B: Machine Translation + Manual Review**
- **Pros**: Fast, cheap
- **Cons**: May have errors, unnatural phrasing
- **Tools**: Google Translate API, DeepL API
- **Recommended**: Use Python script (see below)

**Option C: Community Translation**
- **Pros**: Free, native speakers
- **Cons**: Slow, inconsistent quality
- **Platforms**: Crowdin, Transifex

### 4. Python Script for Batch Translation

Create `/tmp/translate_to_chinese.py`:

```python
#!/usr/bin/env python3
import json
from googletrans import Translator

translator = Translator()

# Load English file
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

zh_data = {}

for key, value in en_data.items():
    if key.startswith('@'):
        # Keep metadata unchanged
        zh_data[key] = value
    else:
        # Translate the value
        try:
            translated = translator.translate(value, src='en', dest='zh-cn')
            zh_data[key] = translated.text
            print(f"Translated: {key} = {translated.text}")
        except Exception as e:
            print(f"Error translating {key}: {e}")
            zh_data[key] = value  # Fallback to English

# Save Chinese file
with open('lib/l10n/app_zh.arb', 'w', encoding='utf-8') as f:
    json.dump(zh_data, f, ensure_ascii=False, indent=2)

print(f"\n✅ Created app_zh.arb with {len([k for k in zh_data.keys() if not k.startswith('@')])} translated keys")
```

**Usage:**
```bash
# Install dependency
pip3 install googletrans==4.0.0-rc1

# Run translation
python3 /tmp/translate_to_chinese.py
```

**⚠️ Important:** Machine translations MUST be reviewed by a native speaker before release!

### 5. Update Flutter Configuration

**Check `l10n.yaml` (if exists):**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

No changes needed - Flutter automatically detects new ARB files.

**Update `lib/main.dart` (if needed):**

Most implementations auto-detect locales, but verify:

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,  // Should auto-include Chinese
  // ...
)
```

If Chinese doesn't appear, manually add:

```dart
supportedLocales: const [
  Locale('en'),
  Locale('es'),
  Locale('de'),
  Locale('fr'),
  Locale('ja'),
  Locale('pt'),
  Locale('pt', 'BR'),
  Locale('zh'),      // Add Simplified Chinese
  Locale('zh', 'TW'), // Add Traditional Chinese (if needed)
],
```

### 6. Generate Localization Code

Run Flutter's code generator:

```bash
flutter gen-l10n
```

This creates:
- `lib/l10n/app_localizations_zh.dart` - Generated Chinese localization class
- Updates `lib/l10n/app_localizations.dart` with Chinese support

**Expected Output:**
```
Generating localizations...
  app_en.arb (en)
  app_es.arb (es)
  app_de.arb (de)
  app_fr.arb (fr)
  app_ja.arb (ja)
  app_pt.arb (pt)
  app_pt_BR.arb (pt_BR)
  app_zh.arb (zh)      ← New!
Generating files...
  lib/l10n/app_localizations.dart
  lib/l10n/app_localizations_en.dart
  ...
  lib/l10n/app_localizations_zh.dart  ← New!
```

### 7. Verify Key Parity

All language files must have **identical key counts**. Run this check:

```bash
for lang in en es de fr ja pt pt_BR zh; do
  echo -n "app_$lang.arb: "
  jq 'to_entries | map(select(.key | startswith("@") | not)) | length' lib/l10n/app_$lang.arb
done
```

**Expected Output:**
```
app_en.arb: 740
app_es.arb: 740
app_de.arb: 740
app_fr.arb: 740
app_ja.arb: 740
app_pt.arb: 740
app_pt_BR.arb: 740
app_zh.arb: 740  ← All must match!
```

If counts differ, find missing keys:

```bash
# Find keys in English but not in Chinese
comm -23 <(jq -r 'keys[]' lib/l10n/app_en.arb | grep -v '^@' | sort) \
         <(jq -r 'keys[]' lib/l10n/app_zh.arb | grep -v '^@' | sort)
```

### 8. Testing Checklist

**A. Layout Testing**

Chinese characters have different widths than English. Test for overflow:

1. **Button Overflow** (lesson learned from Japanese):
   ```dart
   // Verify all buttons use Flexible widgets
   Flexible(
     child: Text(
       l10n.focusModeButton,
       overflow: TextOverflow.ellipsis,
       maxLines: 1,
     ),
   )
   ```

2. **Test on Small Screens**: Run on smallest supported device (iPhone SE, small Android)

3. **Test Long Strings**: Some Chinese translations may be longer than English

**B. Functional Testing**

```bash
# Set device to Chinese locale
# iOS: Settings > General > Language & Region > Add Chinese
# Android: Settings > System > Languages > Add Chinese

# Run app
./scripts/run/ios.sh --debug
# or
./scripts/run/android.sh --debug
```

**Test these screens:**
- ✅ Onboarding flow (all 6 screens)
- ✅ Home page (Today/Sessions tabs)
- ✅ Settings sheet
- ✅ Trends sheet
- ✅ Focus Mode overlay
- ✅ Paywall dialogs
- ✅ Error messages
- ✅ Freeze token dialogs
- ✅ FAQ section

**C. Screenshot Testing**

Capture screenshots in Chinese for:
- App Store / Google Play listing
- Documentation
- Bug reports

**D. Edge Cases**

Test these scenarios:
1. **Empty States**: "No sessions yet" messages
2. **Placeholders**: Session duration, points, streaks with Chinese numerals
3. **Date Formatting**: Ensure Chinese date formats work (2025年10月25日)
4. **Pluralization**: Check if Chinese requires special plural rules
5. **RTL Issues**: Chinese is LTR but verify no layout bugs

### 9. Common Issues & Solutions

**Issue 1: Layout Overflow**

```
A RenderFlex overflowed by X pixels on the right.
```

**Solution:** Wrap text in `Flexible` widgets:

```dart
// Before (breaks with long Chinese text)
Row(
  children: [
    Text(l10n.someLabel),
    Text(l10n.anotherLabel),
  ],
)

// After (responsive)
Row(
  children: [
    Flexible(child: Text(l10n.someLabel, overflow: TextOverflow.ellipsis)),
    Flexible(child: Text(l10n.anotherLabel, overflow: TextOverflow.ellipsis)),
  ],
)
```

**Issue 2: Missing Translations**

```
Error: No translation found for key 'xyz'
```

**Solution:** Find the missing key:

```bash
# Check if key exists in English
jq '.xyz' lib/l10n/app_en.arb

# Add to Chinese file
jq '.xyz = "翻译文本"' lib/l10n/app_zh.arb > tmp.arb && mv tmp.arb lib/l10n/app_zh.arb
```

**Issue 3: Placeholder Formatting**

```dart
// English: "Session: {minutes} minutes"
// Chinese: "会话: {minutes} 分钟"
```

**Solution:** Keep placeholders unchanged, only translate surrounding text.

**Issue 4: Font Issues**

Some Chinese characters may not render correctly.

**Solution:** Update `pubspec.yaml` to include Chinese font:

```yaml
flutter:
  fonts:
    - family: NotoSansSC
      fonts:
        - asset: fonts/NotoSansSC-Regular.ttf
        - asset: fonts/NotoSansSC-Bold.ttf
          weight: 700
```

Then apply globally:

```dart
ThemeData(
  fontFamily: 'NotoSansSC',
  // ...
)
```

### 10. Maintenance Workflow

When adding new features with new strings:

1. **Add to English first**: Update `app_en.arb` with new keys
2. **Run translation script**: Re-translate all languages
3. **Verify key parity**: Ensure all files have same key count
4. **Manual review**: Native speakers check new translations
5. **Regenerate**: Run `flutter gen-l10n`
6. **Test**: Verify new strings appear correctly in all languages

**Python Script for Adding Single Key to All Languages:**

```python
#!/usr/bin/env python3
import json
from googletrans import Translator

translator = Translator()

new_key = "newFeatureLabel"
english_value = "New Feature"

languages = {
    'es': 'app_es.arb',
    'de': 'app_de.arb',
    'fr': 'app_fr.arb',
    'ja': 'app_ja.arb',
    'pt': 'app_pt.arb',
    'pt_BR': 'app_pt_BR.arb',
    'zh': 'app_zh.arb',
}

lang_codes = {
    'es': 'es', 'de': 'de', 'fr': 'fr',
    'ja': 'ja', 'pt': 'pt', 'pt_BR': 'pt',
    'zh': 'zh-cn',
}

for lang, filename in languages.items():
    filepath = f'lib/l10n/{filename}'
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Translate
    target_lang = lang_codes[lang]
    translated = translator.translate(english_value, src='en', dest=target_lang)

    # Add key
    data[new_key] = translated.text

    # Save
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Added to {lang}: {new_key} = {translated.text}")
```

---

## Summary Checklist

When adding Chinese (or any new language):

- [ ] Create `lib/l10n/app_zh.arb` with all 740 keys
- [ ] Translate all values (machine translate + manual review)
- [ ] Verify key parity (all files have 740 keys)
- [ ] Run `flutter gen-l10n`
- [ ] Update `supportedLocales` in main.dart (if needed)
- [ ] Test on device with Chinese locale
- [ ] Check for layout overflow issues
- [ ] Verify all placeholders work correctly
- [ ] Test all screens and dialogs
- [ ] Capture screenshots for app store
- [ ] Document any Chinese-specific issues
- [ ] Add Chinese to `scripts/tools/check-localizations.sh`

---

## Tools & Resources

**Translation Tools:**
- Google Translate API: https://cloud.google.com/translate
- DeepL API: https://www.deepl.com/pro-api
- Azure Translator: https://azure.microsoft.com/en-us/services/cognitive-services/translator/

**Quality Assurance:**
- Lokalise: https://lokalise.com/
- Crowdin: https://crowdin.com/
- Phrase: https://phrase.com/

**Chinese Fonts:**
- Noto Sans SC (Simplified): https://fonts.google.com/noto/specimen/Noto+Sans+SC
- Noto Sans TC (Traditional): https://fonts.google.com/noto/specimen/Noto+Sans+TC

**Testing:**
- BrowserStack: Test on real Chinese devices
- Firebase Test Lab: Automated testing with Chinese locale

---

## Example: Complete Chinese Translation Workflow

```bash
# 1. Create Chinese ARB file
cp lib/l10n/app_en.arb lib/l10n/app_zh.arb

# 2. Run translation script
python3 /tmp/translate_to_chinese.py

# 3. Verify key count
jq 'to_entries | map(select(.key | startswith("@") | not)) | length' lib/l10n/app_zh.arb
# Output: 740

# 4. Generate localization code
flutter gen-l10n

# 5. Format code
dart format lib/l10n/app_localizations_zh.dart

# 6. Run app with Chinese locale
./scripts/run/ios.sh --debug

# 7. Switch device to Chinese
# iOS: Settings > General > Language & Region > Add Chinese > Set as Primary

# 8. Test all screens
# - Onboarding ✅
# - Home page ✅
# - Settings ✅
# - Focus Mode ✅
# - Paywall ✅

# 9. Fix any overflow issues
# (Add Flexible widgets as needed)

# 10. Commit changes
git add lib/l10n/app_zh.arb lib/l10n/app_localizations_zh.dart
git commit -m "feat: Add Simplified Chinese (zh) language support

- Added app_zh.arb with 740 translated keys
- Generated app_localizations_zh.dart
- Tested on iOS/Android with Chinese locale
- Verified all screens render correctly"
```

---

**Questions?** See `docs/development/i18n_comprehensive_audit.md` for detailed internationalization architecture.
