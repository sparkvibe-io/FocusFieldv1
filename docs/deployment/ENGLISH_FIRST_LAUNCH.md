# English-First Launch Checklist - Focus Field

**Target Launch Date**: Week of October 28, 2025
**Strategy**: English-only launch → Add languages next week
**Focus**: Speed to market, validate core value proposition

---

## 🎯 Why English-First?

✅ **Faster to market** - No screenshot localization needed this week
✅ **Validate product-market fit** - English markets are largest (US, UK, Canada, Australia)
✅ **Simpler QA** - Test one language thoroughly before expanding
✅ **Learn fast** - Gather feedback, iterate, then localize

**Next week**: Add Spanish, Chinese, Portuguese, Japanese, German, French

---

## ✅ Pre-Launch Checklist (English Only)

### 1. Technical Readiness
- [x] App code complete (MVP done!)
- [x] 51/52 tests passing
- [x] Flutter analyzer clean
- [x] No print statements
- [x] Debug logging properly gated
- [ ] **Version bumped to 1.0.0+1**
- [ ] **Production API keys configured**
- [ ] **Mock subscriptions disabled**

### 2. Build Preparation
- [ ] **iOS**: Xcode archive created with production provisioning profile
- [ ] **Android**: Signed App Bundle (.aab) generated with upload keystore
- [ ] Test on physical devices (iPhone + Android)
- [ ] Production RevenueCat keys working
- [ ] AdMob ads loading correctly

### 3. Visual Assets (English Only)
- [ ] **App Icon** (iOS: 1024x1024, Android: 512x512)
- [ ] **8 Screenshots** (iPhone 6.7" + 5.5")
  1. Home / Session Start
  2. Active Session (showing Calm%)
  3. Today Tab (activity rings)
  4. Quest Progress (streak display)
  5. Focus Mode (full-screen)
  6. Analytics (12-week heatmap)
  7. Settings (themes, activities)
  8. Premium / Paywall
- [ ] **Feature Graphic** (Android: 1024x500)
- [ ] App Preview Video (optional - can add later)

### 4. Store Listings - Use [`store_listing_en_NO_EMOJI.md`](store_listing_en_NO_EMOJI.md) ⚠️
- [ ] **IMPORTANT**: Use the NO_EMOJI version to avoid "invalid characters" errors
- [ ] Copy app name, subtitle, description
- [ ] Copy short description (Android)
- [ ] Copy keywords
- [ ] Copy promotional text (iOS)
- [ ] Copy release notes
- [ ] Copy subscription descriptions
- [ ] Add screenshot captions (optional but recommended)

**Note**: App stores reject emoji characters (🎯, ✨, etc.) in description fields. Always use the NO_EMOJI version!

### 5. Subscriptions (RevenueCat + Stores)
- [ ] **App Store Connect**:
  - [ ] Create subscription group: "Focus Field Premium"
  - [ ] Add product: `premium.tier.monthly` ($1.99/mo)
  - [ ] Add product: `premium.tier.yearly` ($19.99/yr)
  - [ ] Link to RevenueCat offering: "current"
- [ ] **Google Play Console**:
  - [ ] Create subscription: `premium.tier.monthly` ($1.99/mo)
  - [ ] Create subscription: `premium.tier.yearly` ($19.99/yr)
  - [ ] Link to RevenueCat offering: "current"
- [ ] Test purchase flow in sandbox/internal testing

### 6. Legal (Minimum Viable)
- [ ] **Privacy Policy** at https://focusfield.io/privacy
  - Required: What data we collect (decibels only)
  - Required: No audio recording statement
  - Required: Third-party services (RevenueCat, AdMob)
- [ ] **Support Email**: support@focusfield.io
- [ ] **Website Landing Page**: https://focusfield.io (simple one-pager OK)

### 7. App Store Connect (iOS)
- [ ] Bundle ID: `io.sparkvibe.focusfield`
- [ ] App name: "Focus Field"
- [ ] Subtitle: "Deep Work. Measured Silence."
- [ ] Primary category: Productivity
- [ ] Secondary category: Health & Fitness
- [ ] Age rating: 4+ (no restricted content)
- [ ] Privacy nutrition labels configured
- [ ] Upload build 1.0.0(1)
- [ ] Submit for review

### 8. Google Play Console (Android)
- [ ] Package name: `io.sparkvibe.focusfield`
- [ ] App name: "Focus Field"
- [ ] Short description (from store_listing_en.md)
- [ ] Full description (from store_listing_en.md)
- [ ] Content rating (IARC questionnaire)
- [ ] Data safety form completed
- [ ] Upload App Bundle (.aab)
- [ ] Submit for review

---

## 📅 Timeline (English-Only Launch)

### Day 1-2: Visual Assets (This Week)
- [ ] Design app icon
- [ ] Capture 8 screenshots on iPhone 6.7" device
- [ ] Capture 8 screenshots on iPhone 5.5" device (or resize)
- [ ] Create Android feature graphic (1024x500)
- [ ] Optional: Record app preview video

**Time estimate**: 4-6 hours

### Day 3: Store Configuration (This Week)
- [ ] Configure App Store Connect (metadata, subscriptions)
- [ ] Configure Google Play Console (metadata, subscriptions)
- [ ] Test subscriptions in sandbox/internal testing
- [ ] Verify all fields filled correctly

**Time estimate**: 3-4 hours

### Day 4: Legal & Web (This Week)
- [ ] Write privacy policy (template available online)
- [ ] Create simple landing page (single HTML page OK)
- [ ] Set up support@ email forwarding
- [ ] Host privacy policy at /privacy

**Time estimate**: 2-3 hours

### Day 5: Build & Submit (This Week)
- [ ] Bump version to 1.0.0+1
- [ ] Generate production builds (iOS + Android)
- [ ] Final testing on physical devices
- [ ] Upload to App Store Connect
- [ ] Upload to Google Play Console
- [ ] Submit both for review

**Time estimate**: 2-3 hours

### Day 6-10: Review Period
- [ ] Monitor App Store Connect for status updates
- [ ] Monitor Google Play Console for status updates
- [ ] Respond to any reviewer questions within 24h
- [ ] Prepare launch announcement (social media, email)

**Expected review time**:
- iOS: 24-48 hours
- Android: 1-3 days (first submission may be longer)

### Day 11+: Next Week - Add Languages
- [ ] Capture localized screenshots (7 languages)
- [ ] Add store listings from language-specific .md files
- [ ] Update app with localized screenshot captions
- [ ] Resubmit updates

---

## 🎨 Visual Assets - Quick Spec

### App Icon Design Guidelines
- **Concept**: Focus + Silence + Ambient
- **Style**: Simple, modern, recognizable at small sizes
- **Colors**: Teal (#009688), Cyan (#00BCD4) - brand colors
- **Elements**: Consider circular progress ring, sound wave, or minimalist "F"
- **No text** in icon (except stylized "F" if using)

### Screenshot Capture Settings
**Device**: iPhone 15 Pro Max (6.7" display) or Simulator
- **Resolution**: 1290 x 2796 pixels
- **Format**: PNG
- **Orientation**: Portrait
- **Status bar**: Clean (full signal, WiFi, battery)
- **Time**: 9:41 AM (Apple's default)

**Content to capture**:
1. **Home** - 30 min duration selected, "Start" ready, 0:00 countdown
2. **Active** - 10:00 remaining, 85% Calm, progress ring at ~67%
3. **Today** - Study 8/20 min, Reading 5/20 min, Meditation 0/20 min
4. **Quest** - 5-day streak, 18/20 points, freeze token available
5. **Focus Mode** - Full-screen, 15:30 remaining, 92% Calm
6. **Analytics** - 12-week heatmap with good activity, trend charts
7. **Settings** - Theme selector showing Ocean Blue selected
8. **Premium** - Paywall with all 7 features listed

**Pro tip**: Use good demo data. Show realistic progress (not perfect, not empty).

---

## 💎 Premium Features (UPDATED - Correct Version)

Use this list in all store descriptions and subscription text:

```
✨ Remove all ads for distraction-free focus
⏱️ 4-hour deep work sessions (vs 30 min free)
🎯 Reach your 18-hour daily goals faster
📊 Advanced analytics & performance trends
📅 90-day history (vs 7 days free)
💾 Export session data as CSV/PDF
🎨 7 exclusive premium themes
```

**Key correction**: Premium sessions are **4 hours (240 minutes)**, not 120 minutes!

---

## 🚀 Build Commands

### iOS Production Build
```bash
# Set production environment
export REVENUECAT_API_KEY="appl_qoFokYDCMBFZLyKXTulaPFkjdME"
export IOS_BANNER_AD_UNIT_ID="ca-app-pub-2086096819226646/9050063581"
export IS_DEVELOPMENT=false
export ENABLE_MOCK_SUBSCRIPTIONS=false

# Build in Xcode
# Product > Archive > Validate App > Distribute App
```

### Android Production Build
```bash
# Set production environment
export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
export ANDROID_BANNER_AD_UNIT_ID="ca-app-pub-2086096819226646/3553182566"
export IS_DEVELOPMENT=false
export ENABLE_MOCK_SUBSCRIPTIONS=false

# Build App Bundle
./scripts/build/build-prod.sh
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 📋 Submission Review Notes

### For iOS App Review
```
Focus Field measures ambient noise levels (decibels only) to help users
build focus habits. No audio is recorded or transmitted.

To test:
1. Grant microphone permission when prompted
2. Select a duration (1, 5, 10, 30 min for free)
3. Tap "Start" on the progress ring
4. App monitors ambient noise and tracks "Calm%" in real-time
5. Session completes when timer reaches zero
6. Daily goals and streaks update automatically

Premium features:
- Access via in-app purchase ($1.99/mo or $19.99/yr)
- Unlocks 4-hour sessions, advanced analytics, data export
- Test with sandbox account if needed

Privacy:
- Only decibel levels measured (no audio recording)
- Data stored locally on device
- Microphone permission required for core functionality
```

### For Android Review
```
Focus Field measures ambient noise (decibels only) for focus tracking.
No audio recording or transmission.

Test Instructions:
1. Allow microphone permission
2. Start 1, 5, 10, or 30 min session (free tier)
3. App tracks ambient noise and calculates Calm%
4. Complete session to see quest/streak updates

Premium: $1.99/mo unlocks 4-hour sessions, analytics, export, themes.

Privacy: Decibel measurement only, local storage, no cloud sync (free tier).
```

---

## ✅ Final Pre-Submit Checklist

Before hitting "Submit for Review":

### Technical
- [ ] Version number is 1.0.0+1
- [ ] Production API keys configured (not test keys!)
- [ ] Mock subscriptions DISABLED
- [ ] Tested on 2+ physical devices
- [ ] No crashes in last 24 hours of testing
- [ ] Subscriptions work in sandbox (iOS) or internal test (Android)

### Content
- [ ] All metadata from store_listing_en.md copied correctly
- [ ] No typos in app name, subtitle, description
- [ ] Keywords optimized for ASO
- [ ] Screenshots show real app functionality (not placeholders)
- [ ] Subscription descriptions accurate ($1.99/mo, $19.99/yr)
- [ ] Premium features list is UPDATED (4 hours, not 120 minutes)

### Legal
- [ ] Privacy policy live and accessible
- [ ] Support email working
- [ ] Terms of service (optional but recommended)
- [ ] Copyright notice: © 2025 SparkVibe IO

### Store-Specific
**iOS**:
- [ ] Age rating 4+ selected
- [ ] Privacy nutrition labels configured (microphone + usage data)
- [ ] Export compliance answered (NO if not using encryption beyond standard HTTPS)
- [ ] App Review Information filled out

**Android**:
- [ ] Content rating completed (IARC)
- [ ] Data safety form filled out (microphone permission explained)
- [ ] Target audience: Everyone
- [ ] Pricing: Free with in-app purchases

---

## 🎉 Post-Approval Actions

When both apps are approved:

### Immediate (Day 1)
- [ ] Test download from App Store
- [ ] Test download from Google Play
- [ ] Verify subscriptions work in production
- [ ] Test restore purchases
- [ ] Monitor crash reports (should be zero!)

### Week 1
- [ ] Monitor user reviews daily
- [ ] Respond to questions/feedback within 24h
- [ ] Track download numbers
- [ ] Monitor conversion rate (free → premium)
- [ ] Gather feedback for improvements

### Week 2+
- [ ] Add remaining 6 languages (Spanish, Chinese, Portuguese, Japanese, German, French)
- [ ] Create localized screenshots
- [ ] Update store listings with all languages
- [ ] Submit updates to both stores

---

## 📞 Quick Reference

**App Information**:
- App Name: Focus Field
- Bundle ID: io.sparkvibe.focusfield
- Version: 1.0.0 (Build 1)
- Copyright: © 2025 SparkVibe IO

**Pricing**:
- Free tier: 30 min sessions, 7 days history, ads
- Premium Monthly: $1.99/month
- Premium Yearly: $19.99/year (16% savings)

**Support**:
- Email: support@focusfield.io
- Website: https://focusfield.io
- Privacy: https://focusfield.io/privacy

**RevenueCat**:
- iOS API Key: appl_qoFokYDCMBFZLyKXTulaPFkjdME
- Android API Key: goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
- Entitlement: Premium
- Offering: current

**AdMob**:
- iOS Banner: ca-app-pub-2086096819226646/9050063581
- Android Banner: ca-app-pub-2086096819226646/3553182566

---

## 🚨 Common Rejection Reasons (Avoid These!)

### iOS
1. **Metadata Rejected**: Description mentions "Android" or "Google Play" → Use platform-neutral language
2. **Privacy Policy Missing**: Must be accessible before download → Host at focusfield.io/privacy
3. **Subscription Not Clear**: Users must understand what they're buying → Clear pricing + feature list
4. **Microphone Justification**: Must explain why mic is needed → "Measures ambient noise (decibels only)"
5. **Crash on Launch**: Always test on physical device before submitting

### Android
1. **Data Safety Incomplete**: Must declare microphone usage → "Measures decibel levels, no audio recording"
2. **Content Rating Wrong**: Must complete IARC questionnaire → Select "Everyone", no mature content
3. **Screenshots Don't Match**: Ensure screenshots show actual app → Use real builds, not mockups
4. **Target API Too Low**: Must target API 34 (Android 14) → Already set correctly in build.gradle
5. **Privacy Policy Missing**: Same as iOS → Host before submission

---

**You're ready to launch!** 🎉

Focus on speed this week. English-only, get approved, then iterate. You'll add languages next week after validating the core product.

Good luck! 🚀
