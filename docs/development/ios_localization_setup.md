# iOS Localization Setup Guide

## Overview
Configure Xcode project to support all 7 languages for App Store submission.

## Current Status
- ✅ Flutter app supports: EN, ES, FR, DE, PT-BR, JA, ZH
- ❌ Xcode project only declares: EN, Base
- **Result**: Can only submit English metadata to App Store

## Required Changes

### Step 1: Add Localizations in Xcode

1. **Open project in Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Runner project** in Project Navigator (left sidebar)

3. **Click on "Runner" under PROJECT** (not TARGETS)

4. **Go to "Info" tab**

5. **Under "Localizations" section**, click the **"+"** button

6. **Add each language**:
   - Spanish (es)
   - French (fr)
   - German (de)
   - Portuguese (Brazil) (pt-BR)
   - Japanese (ja)
   - Chinese, Simplified (zh-Hans) *or* Chinese (zh)

7. **For each language added**, in the dialog:
   - ✅ Check "LaunchScreen.storyboard"
   - ✅ Check "Main.storyboard"
   - ✅ Check "InfoPlist.strings" (creates if needed)
   - Click "Finish"

### Step 2: Verify project.pbxproj Updated

After adding languages, check `ios/Runner.xcodeproj/project.pbxproj`:

```bash
grep -A 10 "knownRegions" ios/Runner.xcodeproj/project.pbxproj
```

**Should show:**
```
knownRegions = (
    en,
    Base,
    es,
    fr,
    de,
    "pt-BR",
    ja,
    zh,
);
```

### Step 3: Localize InfoPlist.strings (Optional)

If you want app name to change based on language:

1. In Xcode, **File → New → File**
2. Select **"Strings File"**
3. Name it **"InfoPlist.strings"**
4. Save in **ios/Runner/**
5. Select the file, click **"Localize..."** in File Inspector
6. Add all languages

**In each InfoPlist.strings file**, add:
```
"CFBundleDisplayName" = "Focus Field";
"CFBundleName" = "Focus Field";
```

**Or localize the app name**:
- `InfoPlist.strings (Spanish)`: `"CFBundleDisplayName" = "Campo de Enfoque";`
- `InfoPlist.strings (French)`: `"CFBundleDisplayName" = "Champ de Concentration";`
- etc.

### Step 4: Update Info.plist (Already Correct)

Verify `ios/Runner/Info.plist` has:
```xml
<key>CFBundleDevelopmentRegion</key>
<string>$(DEVELOPMENT_LANGUAGE)</string>
```

This is already set correctly in your project.

### Step 5: Commit Changes

```bash
git add ios/Runner.xcodeproj/project.pbxproj
git add ios/Runner/*.lproj  # If created
git commit -m "feat(ios): Add localization support for 7 languages

- Added Spanish, French, German, Portuguese (BR), Japanese, Chinese
- Localized LaunchScreen and Main storyboards
- Updated knownRegions in Xcode project
- Enables App Store submissions in all supported languages

Supported locales: EN, ES, FR, DE, PT-BR, JA, ZH
"
```

## App Store Connect Impact

**After adding localizations:**
- ✅ Can submit app with metadata in all 7 languages
- ✅ Users in those regions see localized app in store
- ✅ Automatic language detection works
- ✅ Better App Store SEO and discoverability

**Metadata to translate for App Store Connect:**
- App name (optional - can keep "Focus Field")
- Subtitle (30 chars)
- Description (4000 chars)
- Keywords (100 chars)
- Promotional text (170 chars)
- What's New (4000 chars)
- Screenshots (can reuse, but consider localized UI)

## Testing

Test language switching:

1. **Change device language**: Settings → General → Language & Region
2. **Force restart app**
3. **Verify**:
   - App UI shows correct language
   - Launch screen displays (no crashes)
   - All screens render correctly

**Test each language:**
- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Portuguese - Brazil (pt-BR)
- Japanese (ja)
- Chinese (zh)

## Troubleshooting

### Issue: "Base.lproj not found"
**Solution**: In Xcode, select storyboard files → File Inspector → check "Use Base Internationalization"

### Issue: App crashes on launch after adding languages
**Solution**:
1. Clean build: `flutter clean`
2. Reinstall pods: `cd ios && pod install && cd ..`
3. Rebuild: `flutter build ios --debug`

### Issue: Language not appearing in App Store Connect
**Solution**:
1. Verify language in `knownRegions` in project.pbxproj
2. Ensure at least one .lproj folder exists for that language
3. Wait 24 hours for App Store Connect to sync

## Summary

**Before**: English only in App Store
**After**: 7 languages available for store listings

**Estimated Time**: 10-15 minutes
**Build Impact**: None (only adds metadata files)
**Required for Launch**: No (but highly recommended)
