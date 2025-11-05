# ExportOptions.plist - Configuration Guide

## What Is This File?

`ExportOptions.plist` configures how Xcode exports your iOS app for distribution. It's used when:
- Creating an Archive in Xcode (Product > Archive)
- Exporting IPA from Xcode Organizer
- Using `xcodebuild` directly for automation

**Note**: `flutter build ipa` doesn't require this file—it's configured for Xcode Archive workflows.

---

## Current Configuration

Your file is pre-configured with:

```xml
<key>method</key>
<string>app-store</string>  <!-- Distribution method -->

<key>teamID</key>
<string>2R2QXHHW39</string>  <!-- Your Apple Developer Team ID -->

<key>provisioningProfiles</key>
<dict>
    <key>io.sparkvibe.focusfield</key>
    <string>Focus Field App Store</string>  <!-- Your provisioning profile name -->
</dict>

<key>signingCertificate</key>
<string>Apple Distribution</string>  <!-- Certificate type -->
```

---

## When This File Is Used

### ✅ Used By:
- **Xcode Organizer** when distributing archived IPA
- **xcodebuild** automation scripts
- **fastlane** (if you add it later)

### ❌ NOT Used By:
- `flutter build ipa` (uses Xcode project settings instead)
- Debug builds
- Development builds

---

## Configuration Fields Explained

| Field | Value | Purpose |
|-------|-------|---------|
| `method` | `app-store` | Distribution type (app-store, ad-hoc, enterprise, development) |
| `teamID` | `2R2QXHHW39` | Your Apple Developer Team ID |
| `provisioningProfiles` | Bundle ID → Profile Name mapping | Which profile to use for your app |
| `signingCertificate` | `Apple Distribution` | Certificate type (Apple Distribution, iPhone Distribution) |
| `uploadSymbols` | `true` | Upload crash symbols to App Store Connect |
| `uploadBitcode` | `false` | Upload bitcode (Apple is phasing this out) |
| `compileBitcode` | `false` | Recompile bitcode during export |
| `manageAppVersionAndBuildNumber` | `true` | Auto-increment version if needed |
| `destination` | `upload` | Where to send the IPA (upload, export) |

---

## How To Use (Xcode Archive Method)

### Step 1: Create Archive
```bash
open ios/Runner.xcworkspace
```
1. Select **Any iOS Device (arm64)**
2. Product → Archive
3. Wait for archive to complete

### Step 2: Export from Organizer
1. Organizer window opens (or Window → Organizer)
2. Select your archive
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Choose **Upload**

### Step 3: Export Options
When Xcode asks for export options:
- Option 1: **Use this file**: Click "Choose Info.plist File" → Select `ios/ExportOptions.plist`
- Option 2: **Let Xcode generate**: Select options in wizard (Xcode creates temporary plist)

---

## Distribution Methods

Change `<key>method</key>` value for different distributions:

| Method | Use Case | Certificate | Profile |
|--------|----------|-------------|---------|
| `app-store` | **App Store submission** (your current setup) | Apple Distribution | App Store Profile |
| `ad-hoc` | Beta testing (not TestFlight) | Apple Distribution | Ad Hoc Profile |
| `development` | Internal testing | Apple Development | Development Profile |
| `enterprise` | Enterprise distribution (requires enterprise account) | Apple Enterprise | Enterprise Profile |

---

## When To Update This File

### Update Team ID if:
- You switch Apple Developer accounts
- You transfer the app to another team

### Update Provisioning Profile if:
- You rename the provisioning profile
- You create a new profile

### Update Bundle ID mapping if:
- You change the app's bundle identifier
- You add app extensions (widgets, notifications, etc.)

---

## Multiple Bundle IDs (Future)

If you add extensions (e.g., widget, notification extension), update the `provisioningProfiles` dict:

```xml
<key>provisioningProfiles</key>
<dict>
    <!-- Main app -->
    <key>io.sparkvibe.focusfield</key>
    <string>Focus Field App Store</string>

    <!-- Widget extension (example) -->
    <key>io.sparkvibe.focusfield.widget</key>
    <string>Focus Field Widget App Store</string>
</dict>
```

---

## Troubleshooting

### Error: "No matching provisioning profile found"

**Fix**:
1. Verify profile name matches exactly: `Focus Field App Store`
2. Check profile is installed: `~/Library/MobileDevice/Provisioning Profiles/`
3. Re-download from developer portal if needed

### Error: "Team ID mismatch"

**Fix**:
1. Check your Team ID: Xcode → Runner → Signing & Capabilities → Team
2. Update `teamID` in this file to match

### Error: "Code signing identity not found"

**Fix**:
1. Verify certificate in Keychain: Keychain Access → My Certificates
2. Should see: "Apple Distribution: [Your Name]"
3. Update `signingCertificate` if using different cert type

---

## Alternative: Automatic Export Options

You can let Xcode generate export options automatically:

### In Xcode Organizer:
1. Select archive
2. Distribute App → App Store Connect → Upload
3. Choose: **Automatically manage signing**
4. Xcode generates temporary ExportOptions.plist

This works fine! This file is just for:
- Consistency across builds
- Automation scripts
- Team documentation

---

## Git Management

This file **should be committed** to git because:
- ✅ Contains no secrets (Team ID is public in your app)
- ✅ Documents your export configuration
- ✅ Ensures consistency across team members
- ✅ Required for CI/CD automation

---

## Related Files

| File | Purpose | Location |
|------|---------|----------|
| `ExportOptions.plist` | Export configuration | `ios/ExportOptions.plist` |
| Provisioning Profile | App signing profile | `~/Library/MobileDevice/Provisioning Profiles/` |
| Distribution Certificate | Code signing cert | Keychain Access → My Certificates |
| `Info.plist` | App metadata | `ios/Runner/Info.plist` |
| Xcode Project | Build settings | `ios/Runner.xcodeproj/project.pbxproj` |

---

## Quick Reference

**Your Current Setup:**
- Team ID: `2R2QXHHW39`
- Bundle ID: `io.sparkvibe.focusfield`
- Profile: `Focus Field App Store`
- Method: `app-store` (App Store Connect submission)
- Certificate: `Apple Distribution`

**No changes needed unless you:**
- Switch teams
- Rename provisioning profile
- Change distribution method
