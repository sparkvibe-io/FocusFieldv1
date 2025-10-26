# Android Localization Setup Guide

## Overview
Configure Android project to support all 7 languages for Google Play submission.

## Current Status
- ✅ Flutter app supports: EN, ES, FR, DE, PT-BR, JA, ZH
- ❌ Android res/ has no language-specific folders
- **Result**: Can only submit English metadata to Google Play

## Required Changes

### Understanding Android Localization

**Flutter handles all app content** - no Android changes needed for app functionality!

However, for **Google Play Console store listings**, Android should declare supported locales.

### Step 1: Create locale-specific resource folders (OPTIONAL)

Android localization is **optional** because Flutter handles everything. But if you want to:
1. Localize app name on home screen
2. Declare official support in Google Play
3. Follow Android best practices

**Create these folders:**
```bash
cd android/app/src/main/res

# Create locale-specific values folders
mkdir -p values-es  # Spanish
mkdir -p values-fr  # French
mkdir -p values-de  # German
mkdir -p values-pt-rBR  # Portuguese (Brazil)
mkdir -p values-ja  # Japanese
mkdir -p values-zh  # Chinese (Simplified)
```

### Step 2: Create strings.xml in each folder

**Base: `values/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
</resources>
```

**Spanish: `values-es/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">Campo de Enfoque</string> -->
</resources>
```

**French: `values-fr/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">Champ de Concentration</string> -->
</resources>
```

**German: `values-de/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">Fokusfeld</string> -->
</resources>
```

**Portuguese (Brazil): `values-pt-rBR/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">Campo de Foco</string> -->
</resources>
```

**Japanese: `values-ja/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">フォーカスフィールド</string> -->
</resources>
```

**Chinese (Simplified): `values-zh/strings.xml`**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
    <!-- Or localize: <string name="app_name">专注场</string> -->
</resources>
```

### Step 3: Update AndroidManifest.xml (Already Correct)

Verify `android/app/src/main/AndroidManifest.xml` has:
```xml
<manifest>
    <application
        android:label="Focus Field"
        ...>
```

Or to use localized name from strings.xml:
```xml
<application
    android:label="@string/app_name"
    ...>
```

### Step 4: Declare Supported Locales (Optional)

Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        ...
        resConfigs "en", "es", "fr", "de", "pt-rBR", "ja", "zh"
    }
}
```

**Benefits:**
- Reduces APK size (strips unsupported language resources from dependencies)
- Explicitly declares supported languages
- Helps Google Play filter by region

### Step 5: Automated Setup Script

I can create a script to set up all folders and files automatically:

```bash
#!/bin/bash
# scripts/tools/setup-android-locales.sh

cd android/app/src/main/res

# Create locale folders
locales=("es" "fr" "de" "pt-rBR" "ja" "zh")

for locale in "${locales[@]}"; do
    mkdir -p "values-$locale"
    cat > "values-$locale/strings.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
</resources>
EOF
    echo "Created values-$locale/strings.xml"
done

# Create base strings.xml if missing
if [ ! -f "values/strings.xml" ]; then
    cat > "values/strings.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
</resources>
EOF
    echo "Created values/strings.xml"
fi

echo "✅ Android localization setup complete!"
```

### Step 6: Commit Changes

```bash
git add android/app/src/main/res/values*/strings.xml
git add android/app/build.gradle  # If modified
git commit -m "feat(android): Add localization support for 7 languages

- Created locale-specific values folders (es, fr, de, pt-rBR, ja, zh)
- Added strings.xml for app name in all languages
- Declared supported locales in build.gradle
- Enables Google Play submissions in all supported languages

Supported locales: EN, ES, FR, DE, PT-BR, JA, ZH
"
```

## Google Play Console Impact

**After adding localizations:**
- ✅ Can submit app listing in all 7 languages
- ✅ Users in those regions see localized app in store
- ✅ Automatic language detection works
- ✅ Better Play Store SEO and discoverability

**Metadata to translate for Google Play Console:**
- App name (optional - can keep "Focus Field")
- Short description (80 chars)
- Full description (4000 chars)
- Screenshots (can reuse, but consider localized UI)
- What's New (500 chars)

## Testing

Test language switching:

1. **Change device language**: Settings → System → Languages
2. **Force close and restart app**
3. **Verify**:
   - App UI shows correct language
   - App name on home screen (if localized)
   - All screens render correctly

**Test each language:**
- English (en)
- Spanish (es)
- French (fr)
- German (de)
- Portuguese - Brazil (pt-rBR)
- Japanese (ja)
- Chinese (zh)

## Important Notes

### Do You Need This?

**No, if:**
- Launching in English-speaking markets only initially
- Want to add languages incrementally post-launch
- Flutter app already works in all languages (it does!)

**Yes, if:**
- Want to submit store listings in multiple languages
- Targeting international markets from day 1
- Want app name localized on Android home screen
- Want to reduce APK size with `resConfigs`

### What This DOESN'T Affect

- ❌ App functionality (Flutter handles all UI text)
- ❌ User-facing strings (all in .arb files)
- ❌ In-app language switching (already works)
- ❌ Firebase, AdMob, RevenueCat (language-agnostic)

### What This DOES Affect

- ✅ Google Play store listing languages available
- ✅ App name on Android home screen (if localized)
- ✅ APK size (if using `resConfigs`)
- ✅ Regional discoverability in Play Store

## Alternative: No Android Configuration

**You can skip Android localization setup entirely!**

Your app works in all 7 languages without any Android changes. The only limitation:
- Google Play store listings can only be in English initially
- Can add other languages to Play Console later without app update

## Recommendation

**For MVP Launch:**
- Skip Android localization setup (not required)
- Submit English store listing only
- App works in all languages based on device settings
- Add localized store listings post-launch

**For Full International Launch:**
- Follow setup steps above
- Submit store listings in all 7 languages from day 1
- Maximum market reach and discoverability

## Summary

**Before**: English only in Google Play
**After**: 7 languages available for store listings

**Estimated Time**: 5-10 minutes (or use automated script)
**Build Impact**: None (only adds resource files)
**Required for Launch**: No (but recommended for international markets)
