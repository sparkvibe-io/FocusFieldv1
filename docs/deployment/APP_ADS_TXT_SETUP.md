# App-ads.txt Setup Guide for Focus Field

**Date**: November 5, 2025
**Status**: Required for AdMob Ad Serving
**Priority**: HIGH - Blocking ads from displaying

---

## 🚨 Problem

AdMob requires an `app-ads.txt` file to verify publisher authorization and prevent ad fraud. Without this file:
- Ads will NOT display in your app
- You'll see warnings in AdMob dashboard
- Revenue is blocked until resolved

---

## 📋 What is app-ads.txt?

App-ads.txt is an IAB Tech Lab standard that:
- Declares authorized digital sellers for your app's ad inventory
- Prevents unauthorized ad selling and domain spoofing
- Must be hosted on your developer website's root domain

**Official Spec**: https://iabtechlab.com/app-ads-txt/

---

## ✅ Solution Overview

1. Create `app-ads.txt` file with your AdMob publisher ID
2. Upload it to your website root: `https://sparkvibe.io/app-ads.txt`
3. Update App Store and Google Play with your developer website URL
4. Wait for AdMob to crawl and verify (usually 24-48 hours)

---

## 📝 Step 1: Create app-ads.txt File

The file has been created at: `docs/deployment/app-ads.txt`

**Content**:
```
google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0
```

**Format Explanation**:
- `google.com` - Ad network domain (Google AdMob)
- `pub-2086096819226646` - Your AdMob publisher ID
- `DIRECT` - Direct relationship with Google
- `f08c47fec0942fa0` - Google's TAG Certified Against Fraud identifier

---

## 🌐 Step 2: Deploy to Website Root

The file **MUST** be accessible at:
```
https://sparkvibe.io/app-ads.txt
```

### Option A: Static Website Hosting (Recommended)

If using **Netlify, Vercel, GitHub Pages, or similar**:

1. Copy the file to your website's root directory:
   ```bash
   cp docs/deployment/app-ads.txt /path/to/website/root/app-ads.txt
   ```

2. Deploy your website:
   ```bash
   # Example for Netlify
   netlify deploy --prod

   # Example for Vercel
   vercel --prod

   # Example for GitHub Pages
   git add app-ads.txt
   git commit -m "Add app-ads.txt for AdMob verification"
   git push origin main
   ```

3. Verify it's accessible:
   ```bash
   curl https://sparkvibe.io/app-ads.txt
   ```

### Option B: Web Server (Apache/Nginx)

**Apache** (.htaccess):
```apache
# Place app-ads.txt in your public_html or www folder
# No special configuration needed - serve as plain text
<Files "app-ads.txt">
    ForceType text/plain
    Header set Content-Type "text/plain; charset=utf-8"
</Files>
```

**Nginx** (nginx.conf):
```nginx
location = /app-ads.txt {
    alias /var/www/sparkvibe.io/app-ads.txt;
    default_type text/plain;
    add_header Content-Type "text/plain; charset=utf-8";
}
```

### Option C: Content Management System (WordPress, etc.)

1. Use an FTP client to upload `app-ads.txt` to the root directory
2. Or use a plugin like "Insert Headers and Footers" to serve the file
3. Verify the URL is accessible

---

## 📱 Step 3: Update Store Listings with Developer Website

### iOS - App Store Connect

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Go to **My Apps** → Select **Focus Field**
3. Click **App Information** (left sidebar)
4. Scroll down to **Developer Website**
5. Enter: `https://sparkvibe.io`
6. Click **Save**

**Note**: This is also where Privacy Policy and Terms are linked (you've already done this).

### Android - Google Play Console

1. Log in to [Google Play Console](https://play.google.com/console)
2. Select **Focus Field** app
3. Go to **Store Presence** → **Store Settings** (left sidebar)
4. Scroll down to **Contact details**
5. Enter:
   - **Website**: `https://sparkvibe.io`
   - **Email**: `support@sparkvibe.io`
6. Click **Save**

---

## 🔍 Step 4: Verify app-ads.txt File

### Manual Verification

1. Open browser and navigate to: `https://sparkvibe.io/app-ads.txt`
2. Verify you see:
   ```
   google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0
   ```
3. Check that:
   - ✅ File returns HTTP 200 status
   - ✅ Content-Type is `text/plain`
   - ✅ No redirects to www subdomain (use canonical domain)
   - ✅ No HTML wrapper or formatting
   - ✅ Publisher ID matches your AdMob account

### Command Line Verification

```bash
# Check file accessibility
curl -I https://sparkvibe.io/app-ads.txt

# Expected output:
# HTTP/2 200
# content-type: text/plain

# Check file content
curl https://sparkvibe.io/app-ads.txt

# Expected output:
# google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0
```

### AdMob Crawler Tool

1. Log in to [AdMob](https://apps.admob.com)
2. Navigate to **Settings** → **Account Information**
3. Look for **App-ads.txt** section
4. Click **Check app-ads.txt for updates**
5. AdMob will crawl your file and show verification status

---

## ⏱️ Step 5: Wait for AdMob Verification

**Timeline**:
- Initial crawl: Usually within 24 hours
- Full verification: Up to 48-72 hours
- Status updates appear in AdMob dashboard

**During this period**:
- Ads may still not display (this is normal)
- Check AdMob dashboard for crawl status
- Monitor AdMob for any error messages

---

## 🔧 Troubleshooting

### Issue 1: "app-ads.txt file not found"

**Symptoms**: AdMob shows "File not found" error

**Fixes**:
1. Verify file is at exact root: `https://sparkvibe.io/app-ads.txt`
2. Check for case sensitivity (must be lowercase)
3. Ensure no `.txt.txt` double extension
4. Check web server configuration allows plain text files

### Issue 2: "Wrong Content-Type"

**Symptoms**: File loads but AdMob says format is invalid

**Fixes**:
1. Ensure Content-Type is `text/plain` (not `text/html`)
2. Remove any HTML wrappers or headers
3. Save file with UTF-8 encoding, no BOM
4. Check web server MIME type configuration

### Issue 3: "Publisher ID mismatch"

**Symptoms**: File verified but ads still don't show

**Fixes**:
1. Verify publisher ID in app-ads.txt matches AdMob account:
   - Go to AdMob → Settings → Account Information
   - Compare "Publisher ID" (pub-XXXXXXXXXXXXXX)
2. If mismatch, update app-ads.txt with correct ID
3. Trigger re-crawl in AdMob dashboard

### Issue 4: "www subdomain redirect"

**Symptoms**: `https://sparkvibe.io/app-ads.txt` redirects to `https://www.sparkvibe.io/app-ads.txt`

**Fixes**:
1. Use the canonical domain listed in App Store/Play Store
2. Place app-ads.txt on **both** domains (if using www)
3. Or configure server to serve same file on both
4. Update store listings to use consistent domain

### Issue 5: "File accessible but ads still not showing"

**Symptoms**: Everything looks correct but ads don't display

**Checklist**:
- ✅ Wait 48-72 hours for full propagation
- ✅ Check AdMob dashboard for account status
- ✅ Verify ad unit IDs match in code vs AdMob console
- ✅ Test in production build (not debug/dev mode)
- ✅ Ensure app is using correct AdMob App ID in AndroidManifest.xml/Info.plist
- ✅ Check for policy violations in AdMob account

---

## 📱 Platform-Specific Notes

### iOS Considerations

**App Store Connect Requirements**:
- Developer website URL must be entered in App Information
- Website must match the domain in app-ads.txt
- Apple's App Review will verify the website is accessible

**Info.plist Configuration** (already done):
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-2086096819226646~9627636327</string>
```

### Android Considerations

**Google Play Console Requirements**:
- Developer website must be entered in Store Settings → Contact Details
- Website must match the domain in app-ads.txt
- Google Play may take 24 hours to verify domain ownership

**AndroidManifest.xml Configuration** (already done):
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-2086096819226646~6517708516"/>
```

---

## 📊 AdMob Dashboard Verification

After deployment, check your AdMob account:

1. **Settings** → **Account Information**:
   - Publisher ID: `pub-2086096819226646`
   - App-ads.txt status: Should show "✅ Verified"

2. **Apps** → **Focus Field** (iOS & Android):
   - Developer website: `https://sparkvibe.io`
   - App-ads.txt: Should show "Found and verified"

3. **Ad Units**:
   - iOS Banner: `ca-app-pub-2086096819226646/9050063581`
   - Android Banner: `ca-app-pub-2086096819226646/3553182566`
   - Status: Should show "Ready to serve ads"

---

## ✅ Final Verification Checklist

Before considering this complete:

### Website:
- [ ] `https://sparkvibe.io/app-ads.txt` returns HTTP 200
- [ ] File contains: `google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0`
- [ ] Content-Type is `text/plain`
- [ ] No redirects or HTML wrappers
- [ ] File is UTF-8 encoded

### App Store Connect (iOS):
- [ ] Developer Website set to: `https://sparkvibe.io`
- [ ] Privacy Policy URL: `https://sparkvibe.io/privacy`
- [ ] Terms URL added to app description
- [ ] AdMob App ID in Info.plist: `ca-app-pub-2086096819226646~9627636327`
- [ ] Banner Ad Unit ID in code: `ca-app-pub-2086096819226646/9050063581`

### Google Play Console (Android):
- [ ] Website in Contact Details: `https://sparkvibe.io`
- [ ] Email: `support@sparkvibe.io`
- [ ] Privacy Policy URL: `https://sparkvibe.io/privacy`
- [ ] AdMob App ID in AndroidManifest.xml: `ca-app-pub-2086096819226646~6517708516`
- [ ] Banner Ad Unit ID in code: `ca-app-pub-2086096819226646/3553182566`

### AdMob Dashboard:
- [ ] Publisher ID matches: `pub-2086096819226646`
- [ ] App-ads.txt status: "Verified"
- [ ] iOS app status: "Serving ads"
- [ ] Android app status: "Serving ads"
- [ ] No policy violations or warnings

### Code Verification:
- [ ] `lib/constants/app_constants.dart` has correct ad unit IDs (lines 113-119)
- [ ] iOS Info.plist has correct AdMob App ID
- [ ] Android AndroidManifest.xml has correct AdMob App ID
- [ ] Production builds use production ad unit IDs (not test IDs)

---

## 🔄 Re-crawl Request

If you update app-ads.txt:

1. Go to AdMob → Settings → Account Information
2. Find **App-ads.txt** section
3. Click **Check app-ads.txt for updates**
4. Wait 10-15 minutes for re-crawl
5. Refresh page to see updated status

---

## 📚 Related Documentation

- **AdMob Setup**: `docs/MONETIZATION_SETUP.md`
- **Store Submission**: `docs/deployment/APP_STORE_SUBMISSION_CHECKLIST.md`
- **Privacy & Terms**: `docs/deployment/APP_STORE_PRIVACY_TERMS_SETUP.md`
- **Android Release**: `docs/deployment/ANDROID_RELEASE_QUICKSTART.md`
- **Legal Documents**: `docs/legal/`

---

## 🆘 Support Resources

### Official Documentation:
- **IAB App-ads.txt Spec**: https://iabtechlab.com/app-ads-txt/
- **Google AdMob App-ads.txt**: https://support.google.com/admob/answer/9363762
- **AdMob Policy Center**: https://support.google.com/admob/answer/6128543

### Troubleshooting:
- **AdMob Help**: https://support.google.com/admob
- **Community Forum**: https://groups.google.com/g/google-admob-ads-sdk

### Internal:
- **Email**: support@sparkvibe.io
- **Developer**: Krishna (Focus Field team)

---

## 🎯 Summary

**Quick Action Items**:

1. ✅ Copy `docs/deployment/app-ads.txt` to your website root
2. 🌐 Deploy to `https://sparkvibe.io/app-ads.txt`
3. 📱 Update iOS/Android store listings with website URL
4. 🔍 Verify file is accessible via browser
5. ⏱️ Wait 24-48 hours for AdMob verification
6. ✅ Check AdMob dashboard for "Verified" status

**Expected Timeline**:
- File deployment: 5-10 minutes
- Store listing updates: 5 minutes
- AdMob crawl: 24-48 hours
- Ads start serving: 48-72 hours total

---

**Last Updated**: November 5, 2025
**Status**: Ready to deploy
**Next Step**: Upload app-ads.txt to sparkvibe.io root directory
