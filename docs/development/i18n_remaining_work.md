# Localization Remaining Work

**Last Updated**: October 20, 2025
**Status**: FAQ localization complete, ~71 hardcoded strings remain

---

## ✅ Completed (Oct 20, 2025)

### FAQ System Localization
- **Files**: All 7 ARB files (EN, ES, DE, FR, JA, PT, PT_BR)
- **Keys Added**: 45 FAQ keys per language (358 total keys per file)
  - `faqTitle`, `faqSearchHint`, `faqNoResults`, `faqNoResultsSubtitle`, `faqResultsCount`
  - `faqQ01` through `faqQ20` (20 questions)
  - `faqA01` through `faqA20` (20 answers)
- **Code Updated**: `lib/screens/settings_sheet.dart`
  - Replaced hardcoded FAQ list with `AppLocalizations` calls
  - Replaced hardcoded UI strings (title, search, empty states)
  - FAQ bottom sheet now fully localized

### Key Cleanup
- Removed 12 orphaned FAQ keys from non-English files:
  - `faq`, `frequentlyAskedQuestions`
  - `faqHowWorksQ`, `faqHowWorksA`
  - `faqAudioRecordedQ`, `faqAudioRecordedA`
  - `faqAdjustSensitivityQ`, `faqAdjustSensitivityA`
  - `faqPremiumFeaturesQ`, `faqPremiumFeaturesA`
  - `faqNotificationsQ`, `faqNotificationsA`

### Verification
- ✅ All 7 languages have 358 keys (perfect parity)
- ✅ `flutter gen-l10n` regenerated successfully
- ✅ `flutter analyze` shows no errors (23 pre-existing style lints)
- ✅ FAQ translations use machine translation quality (approved for MVP)

---

## 🔧 Remaining Work

### Hardcoded UI Strings (~71 strings across 15+ files)

**Not blocking launch** - all have English fallback text, non-critical UX impact.

#### Files with Hardcoded Strings:

1. **`lib/widgets/permission_dialogs.dart`** (~4 strings)
   - Microphone permission dialog text
   - Notification permission dialog text

2. **`lib/widgets/audio_safe_widget.dart`** (~4 strings)
   - Audio safety messages
   - Error states

3. **`lib/widgets/activity_edit_sheet.dart`** (~5 strings)
   - Activity editing UI labels
   - Form field hints

4. **`lib/screens/app_initializer.dart`** (~6 strings)
   - Loading messages
   - Initialization states

5. **`lib/widgets/adaptive_activity_rings_widget.dart`** (~8 strings)
   - Activity ring labels
   - Progress indicators

6. **`lib/widgets/advanced_analytics_widget.dart`** (~10 strings)
   - Analytics labels
   - Chart titles
   - Metric descriptions

7. **`lib/widgets/analytics_modal.dart`** (~6 strings)
   - Modal titles
   - Button labels

8. **`lib/screens/onboarding_screen.dart`** (~8 strings)
   - Onboarding flow text
   - Instructions

9. **`lib/widgets/share_preview_sheet.dart`** (~5 strings)
   - Share dialog text
   - Export options

10. **Other files** (~15 strings)
    - Various UI labels, tooltips, error messages

---

## 📋 Approach for Future Localization

### Step 1: Audit and Extract
For each file above:
1. Read the file and identify all hardcoded user-facing strings
2. Determine appropriate localization key names
3. Document strings by category (errors, labels, instructions, etc.)

### Step 2: Add to ARB Files
1. Add keys to `lib/l10n/app_en.arb` (English reference)
2. Use machine translation for other 6 languages:
   - Spanish (ES)
   - German (DE)
   - French (FR)
   - Japanese (JA)
   - Portuguese (PT)
   - Brazilian Portuguese (PT_BR)

### Step 3: Update Code
1. Replace hardcoded strings with `AppLocalizations.of(context)!.keyName`
2. Ensure `BuildContext` is available for widget/screen classes
3. For static/utility functions, pass `AppLocalizations` as parameter

### Step 4: Verify
1. Run `flutter gen-l10n` to regenerate localization classes
2. Run `./scripts/tools/check-localizations.sh` to verify key parity
3. Run `flutter analyze` to check for errors
4. Test in app with different language settings

---

## 🎯 Priority Guidelines

### High Priority (Consider Before Launch)
- Permission dialogs (user trust, clarity)
- Error messages (user troubleshooting)
- Onboarding flow (first user experience)

### Medium Priority (Post-Launch Polish)
- Analytics labels
- Advanced features UI
- Share/export dialogs

### Low Priority (Nice-to-Have)
- Tooltips
- Debug messages
- Developer-facing text

---

## 🔍 Finding Hardcoded Strings

### Manual Search Commands
```bash
# Find potential hardcoded strings in widgets
grep -r "Text(" lib/widgets/ | grep -v "AppLocalizations" | grep -v "//" | head -20

# Find hardcoded strings in screens
grep -r "Text(" lib/screens/ | grep -v "AppLocalizations" | grep -v "//" | head -20

# Find dialog/snackbar messages
grep -r "SnackBar\|showDialog" lib/ | grep -v "AppLocalizations"
```

### Automated Approach
Consider creating a script to:
1. Parse all `.dart` files
2. Extract `Text()`, `hintText:`, `labelText:` strings
3. Filter out those already using `AppLocalizations`
4. Generate a report of remaining hardcoded strings

---

## 📊 Current Localization Status

| Category | Status | Count |
|----------|--------|-------|
| FAQ System | ✅ Complete | 45 keys |
| Core UI Strings | ✅ Complete | 313 keys |
| Widget/Screen Strings | ⏳ Pending | ~71 strings |
| **Total Keys** | **358/language** | **7 languages** |

### Languages Supported
- 🇺🇸 English (EN) - Reference
- 🇪🇸 Spanish (ES) - Machine translated
- 🇩🇪 German (DE) - Machine translated
- 🇫🇷 French (FR) - Machine translated
- 🇯🇵 Japanese (JA) - Machine translated
- 🇵🇹 Portuguese (PT) - Machine translated
- 🇧🇷 Brazilian Portuguese (PT_BR) - Machine translated

---

## 📝 Notes

- **Machine Translation Quality**: Approved by user for MVP/launch
- **Native Speaker Review**: Consider post-launch for quality improvement
- **Key Parity**: All languages must maintain same key count
- **Metadata Keys**: Keys starting with `@` are metadata, not counted
- **Translation Tool**: Used Python scripts with JSON library for bulk operations
- **Git Workflow**: ARB files and generated `.dart` files should be committed together

---

## 🚀 When to Resume

This work can be picked up:
1. **Before final launch** - If polish pass needed
2. **Post-launch** - As part of UX refinement sprint
3. **User feedback** - If language quality issues reported
4. **Market expansion** - When targeting non-English markets heavily

The current state (358 localized keys, FAQ fully translated) is **sufficient for MVP launch** as confirmed in `CLAUDE.md`.
