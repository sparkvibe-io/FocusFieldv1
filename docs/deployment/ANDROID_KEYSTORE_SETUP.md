# Android Release Keystore Setup Guide

## Overview

To publish an Android app to Google Play, you need a **release keystore** (also called a signing certificate). This is a cryptographic file that proves you are the legitimate publisher of your app.

**⚠️ CRITICAL:**
- **Never commit your keystore or passwords to Git**
- **Back up your keystore in a secure location** (password manager, encrypted drive)
- **If you lose your keystore, you cannot update your app** - you'd have to publish as a new app

---

## Step 1: Generate Your Keystore

### Option A: Using Command Line (Recommended)

Open Terminal and navigate to your project:

```bash
cd /Users/krishna/Development/FocusField/android
```

Run the keytool command (replace values in `[ ]` with your info):

```bash
keytool -genkey -v \
  -keystore focusfield-release.jks \
  -alias focusfield \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storetype JKS
```

**You'll be prompted for:**

1. **Keystore password:** Choose a strong password (at least 12 characters)
   - Example: `MySecurePassword123!`
   - **WRITE THIS DOWN** - you'll need it for every release

2. **Key password:** Can be same as keystore password (press Enter) or different
   - **WRITE THIS DOWN** too

3. **Your details:**
   ```
   What is your first and last name?
     [Your Name or Company Name, e.g., Krishna Smith]

   What is the name of your organizational unit?
     [Your team/department, e.g., Development or press Enter]

   What is the name of your organization?
     [Your company name, e.g., SparkVibe or press Enter]

   What is the name of your City or Locality?
     [Your city, e.g., San Francisco]

   What is the name of your State or Province?
     [Your state, e.g., California]

   What is the two-letter country code for this unit?
     [Your country code, e.g., US]
   ```

4. **Confirm:** Type `yes` when it shows your info

**Result:** A file `focusfield-release.jks` will be created in `/Users/krishna/Development/FocusField/android/`

### Option B: Using Android Studio

1. Open Android Studio
2. Go to **Build** → **Generate Signed Bundle / APK**
3. Select **Android App Bundle** or **APK**
4. Click **Create new...** under Key store path
5. Fill in the form:
   - **Key store path:** `/Users/krishna/Development/FocusField/android/focusfield-release.jks`
   - **Password:** Your strong password
   - **Alias:** `focusfield`
   - **Password:** Same or different from keystore password
   - **Validity:** 10000 days (27+ years)
   - **Certificate:** Fill in your name/org info
6. Click **OK** to create the keystore

---

## Step 2: Verify Keystore Was Created

```bash
ls -lh /Users/krishna/Development/FocusField/android/focusfield-release.jks
```

**Expected output:**
```
-rw-r--r--  1 krishna  staff   2.5K [date] focusfield-release.jks
```

**Verify keystore details:**
```bash
keytool -list -v -keystore android/focusfield-release.jks -alias focusfield
```

Enter your keystore password when prompted. You should see:
- Alias name: focusfield
- Creation date
- Entry type: PrivateKeyEntry
- Certificate fingerprints (SHA1, SHA256)

**Save the SHA-1 and SHA-256 fingerprints** - you'll need them for:
- Google Play Console (App Signing)
- Firebase (if using Firebase Auth)
- Google Sign-In configuration

---

## Step 3: Configure key.properties

You already have `android/key.properties`. Update it with your actual values:

```bash
cd /Users/krishna/Development/FocusField/android
nano key.properties
```

**Update to:**
```properties
storeFile=focusfield-release.jks
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyAlias=focusfield
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
```

**Replace:**
- `YOUR_ACTUAL_KEYSTORE_PASSWORD` with the password you set in Step 1
- `YOUR_ACTUAL_KEY_PASSWORD` with the key password (may be same as store password)

**Save and exit:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

---

## Step 4: Verify .gitignore

Make sure your keystore and passwords are NOT committed to Git:

```bash
cat /Users/krishna/Development/FocusField/.gitignore | grep -E "key.properties|\.jks|\.keystore"
```

**Should include:**
```
android/key.properties
*.jks
*.keystore
```

If missing, add them:

```bash
echo "android/key.properties" >> .gitignore
echo "*.jks" >> .gitignore
echo "*.keystore" >> .gitignore
```

---

## Step 5: Back Up Your Keystore (CRITICAL!)

**⚠️ DO THIS NOW - Don't skip this step!**

Your keystore is the ONLY way to publish updates to your app. If lost, you cannot update your app.

### Recommended Backup Locations (choose 2-3):

1. **Password Manager** (1Password, LastPass, Bitwarden)
   - Store the `.jks` file as a secure note attachment
   - Store passwords in same entry

2. **Encrypted Cloud Storage** (Google Drive, Dropbox)
   - Upload `focusfield-release.jks` to a secure folder
   - Don't store passwords in same location

3. **External Hard Drive**
   - Copy to USB drive or external HDD
   - Store in safe place (fireproof safe, safety deposit box)

4. **Google Play Console** (Automatic - Recommended)
   - When you first upload your app, Google can manage your signing key
   - This protects you if you lose your local keystore
   - See "Play App Signing" in Step 7 below

**Document these in your password manager:**
```
App: Focus Field Android Release
Keystore File: focusfield-release.jks
Keystore Password: [YOUR_PASSWORD]
Key Alias: focusfield
Key Password: [YOUR_PASSWORD]
SHA-1: [from keytool -list command]
SHA-256: [from keytool -list command]
Location: /Users/krishna/Development/FocusField/android/
Backup Locations: [list where you backed it up]
```

---

## Step 6: Build Release APK/AAB

Now you can build a signed release:

### Build APK (for direct distribution or testing):

```bash
cd /Users/krishna/Development/FocusField

flutter build apk --release \
  --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=IS_DEVELOPMENT=false
```

**Output location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

### Build AAB (for Play Store upload - RECOMMENDED):

```bash
flutter build appbundle --release \
  --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false \
  --dart-define=IS_DEVELOPMENT=false
```

**Output location:**
```
build/app/outputs/bundle/release/app-release.aab
```

---

## Step 7: Upload to Google Play Console

### First Time Upload (Initial Release)

1. **Go to:** [Google Play Console](https://play.google.com/console)
2. **Navigate to:** Your App → **Release** → **Production** (or Internal Testing first)
3. **Create new release**
4. **Upload:** `build/app/outputs/bundle/release/app-release.aab`

### Enable Play App Signing (HIGHLY RECOMMENDED)

When uploading your first release, Google will prompt you to enroll in **Play App Signing**.

**What this does:**
- Google stores your original signing key securely
- You upload with an "upload key" (can be reset if lost)
- Google re-signs with your original key before distribution
- **This protects you from losing access to your app**

**Choose:** "Let Google create and manage my app signing key" (recommended for new apps)

**OR** if you want to keep control: "Export and upload a key from a Java keystore"

### Get Your SHA Certificates for Google Play

Google Play Console needs your certificate fingerprints:

```bash
keytool -list -v \
  -keystore android/focusfield-release.jks \
  -alias focusfield
```

**Copy these values:**
- **SHA-1 certificate fingerprint**
- **SHA-256 certificate fingerprint**

**Paste them in:**
- Google Play Console → **Release** → **Setup** → **App Integrity** → **App signing**
- Firebase Console (if using Firebase)

---

## Step 8: Configure Android Studio (Optional)

If you want to build/debug releases from Android Studio:

### Add Build Configuration

1. **Open Android Studio**
2. **Open:** `/Users/krishna/Development/FocusField/android/` as a project
3. **Go to:** Run → Edit Configurations
4. **Click:** + → Flutter
5. **Configure:**
   - Name: `Release (Android)`
   - Dart entrypoint: `lib/main.dart`
   - Build flavor: (leave empty)
   - Additional run args:
     ```
     --release --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
     ```
6. **Click:** OK

### Run from Android Studio

- Select "Release (Android)" from dropdown
- Click Run button
- App will be built in release mode with correct signing

### View Build Output

- **Terminal tab** in Android Studio will show build logs
- **Build** → **Build Bundle(s) / APK(s)** → **Build APK** to generate APK manually

---

## Troubleshooting

### Error: "Keystore file not found"

**Fix:**
```bash
# Verify keystore exists
ls -lh /Users/krishna/Development/FocusField/android/focusfield-release.jks

# Verify key.properties path is correct
cat /Users/krishna/Development/FocusField/android/key.properties
```

The `storeFile` path in `key.properties` is relative to `android/` directory.

### Error: "Incorrect keystore password"

**Fix:** Update `storePassword` in `android/key.properties` with the correct password you used when creating the keystore.

### Error: "Alias not found"

**Fix:**
```bash
# List all aliases in keystore
keytool -list -keystore android/focusfield-release.jks

# Update keyAlias in key.properties to match
```

### Error: "Build variant not found"

**Fix:** Make sure you're running:
```bash
flutter build apk --release    # not --debug or --profile
```

### Want to create a new keystore?

**⚠️ WARNING:** If you already uploaded an app to Play Store with the old keystore, creating a new keystore means you CANNOT update that app. You'd have to publish as a completely new app (new package name).

**Only create a new keystore if:**
- This is your first time building for release
- You're testing and haven't uploaded to Play Store yet
- You're creating a completely different app

---

## Summary Checklist

- [ ] Created keystore with `keytool -genkey` or Android Studio
- [ ] Saved keystore to `android/focusfield-release.jks`
- [ ] Updated `android/key.properties` with correct credentials
- [ ] Verified `key.properties` and `*.jks` are in `.gitignore`
- [ ] Backed up keystore to 2-3 secure locations
- [ ] Documented keystore password in password manager
- [ ] Got SHA-1 and SHA-256 fingerprints with `keytool -list`
- [ ] Successfully built release APK with `flutter build apk --release`
- [ ] Successfully built release AAB with `flutter build appbundle --release`
- [ ] (Optional) Configured Android Studio build configuration

---

## Quick Reference Commands

```bash
# Generate keystore (one time only)
keytool -genkey -v -keystore android/focusfield-release.jks \
  -alias focusfield -keyalg RSA -keysize 2048 -validity 10000

# View keystore info
keytool -list -v -keystore android/focusfield-release.jks -alias focusfield

# Build release APK
flutter build apk --release \
  --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf

# Build release AAB (for Play Store)
flutter build appbundle --release \
  --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf

# Verify APK signature
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

---

## Next Steps

After creating your keystore:

1. **Build your first release:** See Step 6 above
2. **Upload to Internal Testing:** Test with real devices before production
3. **Configure RevenueCat:** See `docs/deployment/REVENUECAT_ANDROID_SETUP.md`
4. **Upload to Production:** When ready for public release

---

## Need Help?

- **Lost keystore password?** Check your password manager or backup documentation
- **Lost keystore file?** Check backup locations (cloud, external drive)
- **Need to reset?** If you enrolled in Play App Signing, contact Google Play support
- **Build errors?** Check `android/app/build.gradle` signing config (it's already set up correctly)
