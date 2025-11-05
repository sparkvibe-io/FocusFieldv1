# Android Studio Configuration for Focus Field

## Overview

This guide walks you through configuring Android Studio for developing and building Focus Field on Android.

---

## Step 1: Install Android Studio

1. **Download:** [Android Studio](https://developer.android.com/studio)
2. **Install** with default settings
3. **Open Android Studio**
4. **Install SDKs:**
   - Go to **Settings** (⌘,) → **Appearance & Behavior** → **System Settings** → **Android SDK**
   - Install:
     - Android SDK Platform 36 (required by app)
     - Android SDK Build-Tools 36.0.0
     - Android SDK Platform-Tools
     - Android SDK Command-line Tools

---

## Step 2: Install Flutter Plugin

1. **Open Android Studio**
2. **Go to:** Settings (⌘,) → **Plugins**
3. **Search:** "Flutter"
4. **Install** the Flutter plugin (will also install Dart plugin)
5. **Restart** Android Studio

---

## Step 3: Open Focus Field Project

1. **Open Android Studio**
2. **File** → **Open**
3. **Navigate to:** `/Users/krishna/Development/FocusField`
4. **Click:** Open

Android Studio will:
- Index the project (may take 1-2 minutes)
- Download dependencies
- Sync Gradle files

---

## Step 4: Configure Flutter SDK Path

1. **Go to:** Settings (⌘,) → **Languages & Frameworks** → **Flutter**
2. **Set Flutter SDK path:**
   - Usually: `/Users/krishna/flutter` or `/Users/krishna/Development/flutter`
   - Find it with: `which flutter` in Terminal (it will show something like `/usr/local/bin/flutter` → follow that to the SDK root)
3. **Click:** Apply

---

## Step 5: Configure Run Configurations

### Development Configuration (Debug Mode)

1. **Click:** Run → Edit Configurations
2. **Click:** + (Add New Configuration) → Flutter
3. **Configure:**
   - **Name:** `Debug (Android)`
   - **Dart entrypoint:** `lib/main.dart`
   - **Build flavor:** (leave empty)
   - **Additional run args:**
     ```
     --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
     ```
   - **VM options:** (leave empty)
   - **Store as project file:** ✓ (checked)
4. **Click:** OK

### Release Configuration (Release Mode)

1. **Click:** Run → Edit Configurations
2. **Click:** + (Add New Configuration) → Flutter
3. **Configure:**
   - **Name:** `Release (Android)`
   - **Dart entrypoint:** `lib/main.dart`
   - **Build flavor:** (leave empty)
   - **Additional run args:**
     ```
     --release --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false --dart-define=IS_DEVELOPMENT=false
     ```
   - **VM options:** (leave empty)
   - **Store as project file:** ✓ (checked)
4. **Click:** OK

### Demo Mode Configuration (for Screenshots)

1. **Click:** Run → Edit Configurations
2. **Click:** + (Add New Configuration) → Flutter
3. **Configure:**
   - **Name:** `Demo Mode (Android)`
   - **Dart entrypoint:** `lib/main.dart`
   - **Build flavor:** (leave empty)
   - **Additional run args:**
     ```
     --dart-define=REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false --dart-define=DEMO_MODE=true
     ```
   - **VM options:** (leave empty)
   - **Store as project file:** ✓ (checked)
4. **Click:** OK

---

## Step 6: Connect Android Device or Emulator

### Option A: Physical Device (Recommended for Testing)

1. **Enable Developer Options on your Android device:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → System → Developer Options
   - Enable "USB Debugging"

2. **Connect device via USB**

3. **Verify connection:**
   - In Android Studio, check the device dropdown (top toolbar)
   - Your device should appear in the list

4. **Run app:**
   - Select device from dropdown
   - Select "Debug (Android)" configuration
   - Click Run button (▶️) or press ⌃R

### Option B: Android Emulator

1. **Open AVD Manager:**
   - Click device dropdown → AVD Manager
   - Or: Tools → AVD Manager

2. **Create Virtual Device:**
   - Click **+ Create Virtual Device**
   - **Category:** Phone
   - **Device:** Pixel 6 (or any modern device)
   - Click **Next**

3. **Select System Image:**
   - **Release:** Android 15.0 (API 36) or Android 14.0 (API 34)
   - **ABI:** x86_64 (Intel Mac) or arm64-v8a (Apple Silicon Mac)
   - Click **Download** if not installed
   - Click **Next**

4. **Configure AVD:**
   - **AVD Name:** Pixel 6 API 36
   - **Startup orientation:** Portrait
   - **Enable Device Frame:** ✓
   - Click **Finish**

5. **Launch Emulator:**
   - Click ▶️ button next to your AVD
   - Wait for emulator to boot (~30 seconds)

6. **Run app:**
   - Select emulator from device dropdown
   - Select "Debug (Android)" configuration
   - Click Run button (▶️)

---

## Step 7: Configure Gradle Settings (Performance)

### Increase Gradle Memory (Recommended)

1. **Open:** `/Users/krishna/Development/FocusField/android/gradle.properties`
2. **Add/update these lines:**
   ```properties
   org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m -XX:+HeapDumpOnOutOfMemoryError
   org.gradle.parallel=true
   org.gradle.caching=true
   org.gradle.daemon=true
   ```
3. **Save file**

This improves build performance significantly.

### Enable R8 (Code Shrinking - Already Enabled)

Your `android/app/build.gradle` already has:
```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled false    // Set to true if you want code shrinking
        shrinkResources false  // Set to true if you want resource shrinking
    }
}
```

**Note:** Code shrinking is disabled to simplify debugging. Enable for production if you need smaller APK size.

---

## Step 8: Configure Android Studio Preferences

### Enable Auto-Import

1. **Settings** (⌘,) → **Editor** → **General** → **Auto Import**
2. **Dart:**
   - ✓ Show import suggestions for classes
   - ✓ Optimize imports on the fly
3. **Click:** Apply

### Configure Code Style

1. **Settings** (⌘,) → **Editor** → **Code Style** → **Dart**
2. **Scheme:** Project (should use project's `analysis_options.yaml`)
3. **Line length:** 80 (Flutter convention)
4. **Click:** Apply

### Configure Logcat Colors (Optional)

1. **Settings** (⌘,) → **Editor** → **Color Scheme** → **Android Logcat**
2. Customize colors for different log levels:
   - **Verbose:** Gray
   - **Debug:** Blue
   - **Info:** Green
   - **Warning:** Yellow
   - **Error:** Red
   - **Assert:** Magenta

---

## Step 9: Build APK/AAB from Android Studio

### Build Debug APK (Quick Testing)

1. **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
2. Wait for build to complete
3. Click **locate** in notification to find APK
4. Install via: `adb install app-debug.apk`

### Build Release APK (Signed)

**⚠️ Requires keystore setup first** (see `docs/deployment/ANDROID_KEYSTORE_SETUP.md`)

1. **Build** → **Generate Signed Bundle / APK**
2. **Select:** Android App Bundle or APK
3. **Click:** Next
4. **Key store path:** Browse to `android/focusfield-release.jks`
5. **Key store password:** Your keystore password
6. **Key alias:** focusfield
7. **Key password:** Your key password
8. **Click:** Next
9. **Destination folder:** `release/`
10. **Build Variants:** release
11. **Signature Versions:** ✓ V1, ✓ V2
12. **Click:** Finish

**Output:**
- APK: `release/app-release.apk`
- AAB: `release/app-release.aab`

---

## Step 10: Useful Android Studio Tools

### Logcat (View App Logs)

1. **View** → **Tool Windows** → **Logcat**
2. **Filter by:**
   - Package: `io.sparkvibe.focusfield`
   - Tag: `flutter`, `RevenueCat`, `Purchases`
   - Log level: Debug, Info, Warn, Error

**Useful filters:**
```
package:io.sparkvibe.focusfield level:debug
tag:Purchases|RevenueCat
message:premium|subscription|entitlement
```

### Flutter Inspector

1. **View** → **Tool Windows** → **Flutter Inspector**
2. **Features:**
   - Widget tree visualization
   - Layout debugging (enable "Show Guidelines")
   - Performance overlays
   - Debug paint (shows widget boundaries)

### Flutter Performance

1. **View** → **Tool Windows** → **Flutter Performance**
2. **Monitor:**
   - Frame rendering time
   - GPU/CPU usage
   - Memory allocation
   - Timeline events

### App Inspection (Android 11+)

1. **View** → **Tool Windows** → **App Inspection**
2. **Features:**
   - Database Inspector (view SharedPreferences)
   - Network Inspector
   - Background Task Inspector

---

## Troubleshooting

### "Gradle sync failed"

**Fix:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

Then in Android Studio: **File** → **Sync Project with Gradle Files**

### "Flutter SDK not found"

**Fix:**
1. Find Flutter SDK: `which flutter` → `/usr/local/bin/flutter`
2. Follow symlink: `ls -l /usr/local/bin/flutter`
3. SDK root is usually: `/Users/krishna/flutter` or `/Users/krishna/Development/flutter`
4. Set in: Settings → Languages & Frameworks → Flutter

### "Device not detected"

**Fix:**
- USB debugging enabled on device?
- USB cable supports data transfer (not charge-only)?
- Run: `adb devices` in Terminal
- If "unauthorized", check device for authorization prompt
- Try: `adb kill-server && adb start-server`

### "Build fails with keystore error"

**Fix:**
- Verify keystore exists: `ls -lh android/focusfield-release.jks`
- Check passwords in `android/key.properties`
- Ensure you're building release mode (not debug)

### "Out of memory error during build"

**Fix:**
- Increase Gradle memory (see Step 7 above)
- Close other apps to free RAM
- Restart Android Studio

---

## Keyboard Shortcuts (macOS)

### Running & Debugging
- **Run app:** ⌃R
- **Debug app:** ⌃D
- **Stop app:** ⌘F2
- **Hot reload:** ⌘\ (backslash)
- **Hot restart:** ⌘⇧\ (shift+backslash)

### Navigation
- **Open file:** ⌘⇧O
- **Search everywhere:** ⇧⇧ (double shift)
- **Find in files:** ⌘⇧F
- **Go to definition:** ⌘B
- **Go back:** ⌘[
- **Go forward:** ⌘]

### Editing
- **Format code:** ⌥⌘L
- **Optimize imports:** ⌃⌥O
- **Comment line:** ⌘/
- **Duplicate line:** ⌘D
- **Delete line:** ⌘⌫

### Refactoring
- **Rename:** ⇧F6
- **Extract method:** ⌥⌘M
- **Extract variable:** ⌥⌘V
- **Refactor this:** ⌃T

---

## Summary Checklist

- [ ] Android Studio installed with SDK 36
- [ ] Flutter plugin installed
- [ ] Flutter SDK path configured
- [ ] Project opened and indexed
- [ ] Run configurations created (Debug, Release, Demo)
- [ ] Device connected or emulator created
- [ ] Gradle settings optimized
- [ ] Keystore created (for release builds)
- [ ] Successfully ran app in debug mode
- [ ] Successfully built release APK/AAB

---

## Next Steps

1. **Test on physical device:** More accurate than emulator for performance testing
2. **Build release APK:** See `docs/deployment/ANDROID_KEYSTORE_SETUP.md`
3. **Upload to Play Console:** Internal Testing first, then Production
4. **Configure RevenueCat:** See `docs/deployment/REVENUECAT_ANDROID_SETUP.md`

---

## Additional Resources

- [Android Studio User Guide](https://developer.android.com/studio/intro)
- [Flutter Development in Android Studio](https://flutter.dev/docs/development/tools/android-studio)
- [Android Developer Documentation](https://developer.android.com/docs)
- [Gradle Build Configuration](https://developer.android.com/studio/build)
