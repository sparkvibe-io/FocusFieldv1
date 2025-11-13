# app-ads.txt Quick Reference for Focus Field

**TL;DR**: Copy `docs/deployment/app-ads.txt` to `https://sparkvibe.io/app-ads.txt`

---

## 🚀 Quick Deploy

```bash
# 1. Copy the file to your website root
cp docs/deployment/app-ads.txt /path/to/website/root/

# 2. Verify it's accessible
curl https://sparkvibe.io/app-ads.txt

# Expected output:
# google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0

# 3. Update store listings with website URL: https://sparkvibe.io
# 4. Wait 24-48 hours for AdMob to verify
```

---

## 📱 Platform Differences

### iOS
- **Website field**: App Store Connect → App Information → Developer Website
- **AdMob App ID**: `ca-app-pub-2086096819226646~9627636327`
- **Banner Unit ID**: `ca-app-pub-2086096819226646/9050063581`
- **Config file**: `ios/Runner/Info.plist`

### Android
- **Website field**: Google Play Console → Store Settings → Contact Details → Website
- **AdMob App ID**: `ca-app-pub-2086096819226646~6517708516`
- **Banner Unit ID**: `ca-app-pub-2086096819226646/3553182566`
- **Config file**: `android/app/src/main/AndroidManifest.xml`

---

## ✅ Verification Checklist

- [ ] File deployed to: `https://sparkvibe.io/app-ads.txt`
- [ ] Returns HTTP 200 status
- [ ] Content-Type is `text/plain`
- [ ] Contains: `google.com, pub-2086096819226646, DIRECT, f08c47fec0942fa0`
- [ ] iOS store listing has website URL
- [ ] Android store listing has website URL
- [ ] AdMob dashboard shows "Verified" status

---

## 🔗 Resources

- **Full Guide**: `docs/deployment/APP_ADS_TXT_SETUP.md`
- **IAB Spec**: https://iabtechlab.com/app-ads-txt/
- **Google Support**: https://support.google.com/admob/answer/9363762

---

**Last Updated**: November 5, 2025
