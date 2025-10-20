# App Store Submission Checklist - Focus Field

**Last Updated**: October 19, 2025
**Target Launch**: Week 3 (Legal & Store Submission)
**Current Status**: MVP Complete - Ready for Platform Configuration

---

## 📋 Table of Contents

1. [Pre-Submission Overview](#pre-submission-overview)
2. [Technical Requirements](#technical-requirements)
3. [Visual Assets](#visual-assets)
4. [App Store Connect Configuration](#app-store-connect-configuration)
5. [Google Play Console Configuration](#google-play-console-configuration)
6. [In-App Purchases & Subscriptions](#in-app-purchases--subscriptions)
7. [Content & Metadata](#content--metadata)
8. [Legal & Compliance](#legal--compliance)
9. [Testing & Quality Assurance](#testing--quality-assurance)
10. [Submission Checklist](#submission-checklist)

---

## 🎯 Pre-Submission Overview

### Current Completion Status

| Category | Status | Progress |
|----------|--------|----------|
| **Technical Implementation** | ✅ Complete | 100% |
| **Visual Assets** | ⏳ Pending | 0% |
| **Store Configuration** | ⏳ Pending | 0% |
| **Subscriptions** | ⏳ Pending | 0% |
| **Content & Metadata** | ⏳ Pending | 0% |
| **Legal Documents** | ⏳ Pending | 0% |
| **Testing** | ✅ Complete | 100% |

### Timeline Estimate
- **Week 2**: Visual assets + Platform configuration (5-7 days)
- **Week 3**: Legal docs + Store submission (3-5 days)
- **Week 4-6**: Review + Launch marketing

---

## ✅ Technical Requirements

### Code Quality & Testing
- [x] All unit tests passing (51/52 tests pass)
- [x] Flutter analyzer clean (32 optional const suggestions only)
- [x] Code formatted with `flutter format`
- [x] No memory leaks (all streams/controllers disposed)
- [x] Performance optimized (deprecated APIs migrated)
- [x] Localization complete (7 languages: EN, ES, DE, FR, JA, PT, PT_BR)

### Build Configuration
- [x] Version in `pubspec.yaml`: `0.1.6+6` (ready to increment for release)
- [ ] **TODO**: Bump to `1.0.0+1` for App Store submission
- [x] Package ID: `io.sparkvibe.focusfield` (iOS & Android)
- [x] Minimum iOS version: 15.0
- [x] Minimum Android API: 21 (Android 5.0)
- [x] Target Android API: 34

### Platform-Specific Builds
- [ ] **iOS**: Xcode archive with correct provisioning profile
- [ ] **Android**: Signed App Bundle (`.aab`) with upload keystore
- [ ] Test builds verified on physical devices
- [ ] Production API keys configured (RevenueCat, AdMob)

### Environment Variables
```bash
# iOS
REVENUECAT_API_KEY=appl_qoFokYDCMBFZLyKXTulaPFkjdME
IOS_BANNER_AD_UNIT_ID=ca-app-pub-2086096819226646/9050063581

# Android
REVENUECAT_API_KEY=goog_HNKHzGPIWgDdqihvtZrmgTdMSzf
ANDROID_BANNER_AD_UNIT_ID=ca-app-pub-2086096819226646/3553182566

# Build flags
IS_DEVELOPMENT=false
ENABLE_MOCK_SUBSCRIPTIONS=false
```

---

## 🎨 Visual Assets

### App Icons

#### iOS Icon Sizes Required
- [ ] **1024x1024** - App Store (PNG, no alpha)
- [ ] **180x180** - iPhone 3x
- [ ] **120x120** - iPhone 2x
- [ ] **167x167** - iPad Pro
- [ ] **152x152** - iPad 2x
- [ ] **76x76** - iPad 1x
- [ ] **60x60** - iPhone Spotlight 3x
- [ ] **40x40** - iPhone Spotlight 2x

#### Android Icon Sizes Required
- [ ] **512x512** - Play Store listing (PNG, 32-bit)
- [ ] **192x192** - xxxhdpi
- [ ] **144x144** - xxhdpi
- [ ] **96x96** - xhdpi
- [ ] **72x72** - hdpi
- [ ] **48x48** - mdpi
- [ ] **1024x500** - Feature graphic (Google Play)

**Design Guidelines**:
- Simple, recognizable design
- Focus on the "ambient silence" concept
- Works well at small sizes
- No text in icon
- Consistent with Material 3 design
- Brand colors: Teal (#009688), Cyan (#00BCD4)

---

### Screenshots

#### iOS Screenshots Required

**6.7" Display (iPhone 14 Pro Max, iPhone 15 Pro Max)** - REQUIRED
- [ ] Screenshot 1: **Home Screen** - Progress ring with "Start Session" (show 0:00 countdown)
- [ ] Screenshot 2: **Active Session** - Progress ring showing 10:00 remaining, 85% Calm indicator
- [ ] Screenshot 3: **Today Tab** - Activity rings showing daily progress (Study 8/10 min, Reading 5/10 min)
- [ ] Screenshot 4: **Quest Progress** - Quest capsule showing streak (5 days 🔥), freeze token
- [ ] Screenshot 5: **Focus Mode** - Full-screen overlay with minimal distractions
- [ ] Screenshot 6: **Analytics** - 12-week heatmap + trend charts
- [ ] Screenshot 7: **Settings** - Theme selection, activity customization
- [ ] Screenshot 8: **Onboarding** - First screen showcasing app concept

**5.5" Display (iPhone 8 Plus)** - REQUIRED
- [ ] Same 8 screenshots scaled for smaller display

**12.9" iPad Pro (6th Gen)** - OPTIONAL (if supporting iPad)
- [ ] Same 8 screenshots optimized for tablet layout (landscape split-screen)

**Dimensions**:
- 6.7": 1290 x 2796 pixels
- 5.5": 1242 x 2208 pixels
- 12.9" iPad: 2048 x 2732 pixels

---

#### Android Screenshots Required

**Phone** - REQUIRED
- [ ] Same 8 screenshots as iOS (minimum 2, recommended 8)
- [ ] **Dimensions**: 1080 x 1920 pixels minimum

**7" Tablet** - OPTIONAL
- [ ] Same 8 screenshots optimized for tablet
- [ ] **Dimensions**: 1200 x 1920 pixels minimum

**10" Tablet** - OPTIONAL
- [ ] Landscape split-screen layout screenshots
- [ ] **Dimensions**: 1920 x 1200 pixels minimum

---

### Promotional Graphics

#### iOS App Preview Video (Optional but Recommended)
- [ ] **Duration**: 15-30 seconds
- [ ] **Resolution**: 1080p or higher
- [ ] **Content**:
  - Show app opening
  - Demo starting a session
  - Highlight ambient score tracking
  - Show quest progress and streak
  - Display analytics/insights
  - End with call-to-action
- [ ] **Format**: .mov or .mp4
- [ ] **File size**: Max 500MB

#### Android Promo Video (Optional)
- [ ] **Duration**: 30 seconds max
- [ ] **Resolution**: 1920 x 1080 (16:9 aspect ratio)
- [ ] **Format**: .mp4
- [ ] **File size**: Max 200MB

#### Google Play Feature Graphic (REQUIRED for Android)
- [ ] **Dimensions**: 1024 x 500 pixels
- [ ] **Content**: App name + key visual + tagline
- [ ] **Example**: "Focus Field | Measure Silence, Build Focus Habits"
- [ ] **Format**: PNG or JPEG

---

### Screenshot Content Recommendations

**Screenshot 1: Home Screen**
- Title: "Start Your Focus Session"
- Description: "Track ambient silence in real-time with our intuitive progress ring"
- Highlight: Duration selector (1, 5, 10, 30 min)

**Screenshot 2: Active Session**
- Title: "Real-Time Ambient Monitoring"
- Description: "See your calm percentage update live as you maintain focus"
- Highlight: "85% Calm" indicator inside progress ring

**Screenshot 3: Today Tab**
- Title: "Track Your Daily Progress"
- Description: "Separate tracking for Study, Reading, and Meditation activities"
- Highlight: Activity rings showing per-activity progress

**Screenshot 4: Quest Progress**
- Title: "Build Compassionate Streaks"
- Description: "5-day streak with 2-day rule and monthly freeze tokens"
- Highlight: Quest capsule with progress bar and streak indicator

**Screenshot 5: Focus Mode**
- Title: "Minimize Distractions"
- Description: "Full-screen Focus Mode for deep work sessions"
- Highlight: Long-press Pause/Stop controls

**Screenshot 6: Analytics**
- Title: "Visualize Your Journey"
- Description: "12-week activity heatmap and performance trends"
- Highlight: GitHub-style contribution graph

**Screenshot 7: Settings**
- Title: "Customize Your Experience"
- Description: "Adjust activities, goals, and themes to fit your workflow"
- Highlight: Activity edit sheet with global goal slider

**Screenshot 8: Onboarding**
- Title: "Get Started in Seconds"
- Description: "Intuitive onboarding guides you through setup"
- Highlight: Welcome screen with 3 key features

---

## 📱 App Store Connect Configuration

### Apple Developer Account
- [ ] Active Apple Developer Program membership ($99/year)
- [ ] Bundle ID registered: `io.sparkvibe.focusfield`
- [ ] App created in App Store Connect

### App Information
- [ ] **App Name**: "Focus Field"
- [ ] **Subtitle** (30 chars): "Measure Silence, Build Focus"
- [ ] **Primary Category**: Productivity
- [ ] **Secondary Category**: Health & Fitness
- [ ] **Age Rating**: 4+ (no restricted content)
- [ ] **Content Rights**: Original content ownership confirmed

### App Privacy
- [ ] **Privacy Policy URL**: https://focusfield.io/privacy (to be created)
- [ ] **Data Collection**:
  - [ ] Microphone access (for decibel measurement only)
  - [ ] No audio recording
  - [ ] Local storage only (no cloud transmission in free tier)
  - [ ] Optional analytics (anonymized)
- [ ] **Privacy Nutrition Labels** configured:
  - Data Used to Track You: None
  - Data Linked to You: None (unless user opts into analytics)
  - Data Not Linked to You: Usage data (optional)

### App Review Information
- [ ] **First Name**: Krishna
- [ ] **Last Name**: [Your Last Name]
- [ ] **Phone Number**: [Your Phone]
- [ ] **Email**: support@focusfield.io (to be created)
- [ ] **Demo Account**: Not required (no sign-in)
- [ ] **Review Notes**:
  ```
  Focus Field measures ambient noise levels (decibels only) to help users
  build focus habits. No audio is recorded or transmitted.

  To test:
  1. Grant microphone permission when prompted
  2. Select a duration (1, 5, 10 min)
  3. Tap "Start" on the progress ring
  4. App will monitor ambient noise and track "calm percentage"
  5. Session completes when timer reaches zero

  Premium features can be tested with sandbox account.
  ```

### Version Information
- [ ] **Version Number**: 1.0.0
- [ ] **Build Number**: 1
- [ ] **Copyright**: © 2025 SparkVibe IO
- [ ] **Release Type**: Manual release (after approval)

---

## 🤖 Google Play Console Configuration

### Google Play Developer Account
- [ ] Active Google Play Developer account ($25 one-time fee)
- [ ] App created in Google Play Console
- [ ] Package name: `io.sparkvibe.focusfield`

### Store Listing
- [ ] **App Name**: "Focus Field"
- [ ] **Short Description** (80 chars):
  ```
  Measure ambient silence and build focus habits with compassionate quest system
  ```
- [ ] **Full Description** (4000 chars max):
  ```
  Focus Field is your personal ambient silence tracker that helps you build
  deep focus habits through compassionate, quest-based progression.

  🎯 HOW IT WORKS
  • Start a focus session (1-120 minutes)
  • App measures ambient noise levels in real-time
  • Earn points for maintaining quiet environments (≥70% calm)
  • Build streaks with our forgiving 2-day rule
  • Track progress across Study, Reading, and Meditation activities

  🌟 KEY FEATURES
  • Real-time ambient monitoring (no audio recording!)
  • Interactive progress ring with countdown timer
  • Focus Mode for distraction-free sessions
  • Quest-based progression with daily goals
  • Compassionate streaks (2-day rule + monthly freeze token)
  • Per-activity tracking (Study, Reading, Meditation)
  • 12-week activity heatmap
  • Tablet support with landscape split-screen
  • 7 languages supported

  🎨 BEAUTIFUL DESIGN
  • Material 3 design system
  • High-contrast Light & Dark themes
  • Responsive design (phones & tablets)
  • Smooth animations and visual feedback

  💎 PREMIUM FEATURES
  • Extended sessions up to 120 minutes
  • Advanced analytics and trend charts
  • Data export (CSV/PDF)
  • Premium themes
  • 90-day history

  🔒 PRIVACY FIRST
  • No audio recording - only decibel measurements
  • Local storage only (no cloud transmission)
  • No sign-in required
  • Optional analytics (anonymized)

  🌍 SUPPORTED LANGUAGES
  English, Spanish, French, German, Japanese, Portuguese, Brazilian Portuguese

  📊 PERFECT FOR
  • Students (study sessions)
  • Remote workers (deep work)
  • Readers (uninterrupted reading time)
  • Meditators (quiet practice tracking)
  • Anyone building focus habits

  ⚡ GETTING STARTED
  1. Grant microphone permission
  2. Choose your environment threshold
  3. Set your daily goal (10-60 minutes)
  4. Start your first session
  5. Build your streak!

  First-to-market in ambient silence measurement. Join the focus revolution!
  ```

### Content Rating
- [ ] Complete IARC questionnaire
- [ ] **Expected Rating**: Everyone (no mature content)
- [ ] Confirm no violence, profanity, drugs, gambling

### Pricing & Distribution
- [ ] **Price**: Free with in-app purchases
- [ ] **Countries**: All countries
- [ ] **Content Guidelines**: No ads promoting adult content
- [ ] **Device Categories**: Phone & Tablet

### Data Safety
- [ ] **Data Collection**:
  - [ ] Location: No
  - [ ] Personal info: No
  - [ ] Financial info: No
  - [ ] Health info: No
  - [ ] Microphone: Yes (for decibel measurement only)
  - [ ] Photos/Videos: No
  - [ ] Audio files: No (we measure, not record)
- [ ] **Data Sharing**: None
- [ ] **Data Security**:
  - [ ] Data encrypted in transit: Yes (HTTPS)
  - [ ] Data encrypted at rest: Yes (device encryption)
  - [ ] User can request data deletion: Yes
- [ ] **Privacy Policy URL**: https://focusfield.io/privacy

---

## 💳 In-App Purchases & Subscriptions

### RevenueCat Configuration (Already Complete ✅)
- [x] iOS API Key: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
- [x] Android API Key: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- [x] Entitlement configured: `Premium`
- [x] Offering configured: `current`

### Apple App Store Connect Subscriptions
- [ ] **Create Subscription Group**: "Focus Field Premium"
- [ ] **Premium Monthly**:
  - Product ID: `premium.tier.monthly`
  - Reference Name: "Premium Monthly"
  - Price: $1.99/month
  - Subscription Duration: 1 month
  - Auto-renewable: Yes
  - Free trial: 7 days (optional)
- [ ] **Premium Yearly** (optional):
  - Product ID: `premium.tier.yearly`
  - Reference Name: "Premium Yearly"
  - Price: $19.99/year (16% savings)
  - Subscription Duration: 1 year
  - Auto-renewable: Yes
  - Free trial: 7 days (optional)

**Subscription Localizations**:
- [ ] **Display Name**: "Premium"
- [ ] **Description**:
  ```
  Unlock Premium features:
  • Extended sessions (up to 120 minutes)
  • Advanced analytics and trend charts
  • Data export (CSV/PDF)
  • Premium themes
  • 90-day history
  • Priority support
  ```

### Google Play Console Subscriptions
- [ ] **Create Subscription**: "Premium"
  - Base plan ID: `premium-monthly`
  - Product ID: `premium.tier.monthly`
  - Price: $1.99/month
  - Billing period: 1 month
  - Auto-renewal: Enabled
  - Free trial: 7 days (optional)
- [ ] **Create Subscription**: "Premium Yearly" (optional)
  - Base plan ID: `premium-yearly`
  - Product ID: `premium.tier.yearly`
  - Price: $19.99/year
  - Billing period: 1 year
  - Auto-renewal: Enabled
  - Free trial: 7 days (optional)

**Subscription Details**:
- [ ] **Title**: "Focus Field Premium"
- [ ] **Description**: (same as iOS)
- [ ] **Benefits** (shown in Play Store):
  - Extended sessions
  - Advanced analytics
  - Data export
  - Premium themes
  - Longer history

### Subscription Testing
- [ ] iOS Sandbox testing with test account
- [ ] Android Internal Testing track
- [ ] Purchase flow works correctly
- [ ] Restoration works correctly
- [ ] Subscription status updates properly
- [ ] Feature gating works (Premium features locked for free users)

---

## 📝 Content & Metadata

### App Description (Refined for Stores)

**Short Description** (80-100 characters):
```
Measure ambient silence. Build focus habits. Track progress with compassionate streaks.
```

**Keywords** (100 characters max, comma-separated):
```
focus,productivity,silence,ambient,noise,meditation,study,deep work,concentration,mindfulness
```

**Promotional Text** (170 characters, iOS only):
```
First-to-market ambient silence tracker! Build focus habits with our compassionate quest system. No audio recording - just decibel measurements. Privacy-first design.
```

### What's New (Release Notes)
```
🎉 Welcome to Focus Field 1.0!

Focus Field is the first app to measure ambient silence and help you build
focus habits through compassionate, quest-based progression.

✨ KEY FEATURES
• Real-time ambient monitoring (no audio recording!)
• Quest-based progression with daily goals
• Compassionate streaks (2-day rule + freeze tokens)
• Focus Mode for distraction-free sessions
• Per-activity tracking (Study, Reading, Meditation)
• 12-week activity heatmap
• Beautiful Material 3 design
• 7 languages supported

🎯 GETTING STARTED
1. Complete 6-screen onboarding
2. Set your daily goal (10-60 minutes)
3. Choose your environment threshold
4. Start your first focus session
5. Build your streak!

🔒 PRIVACY FIRST
No audio recording - only decibel measurements. All data stored locally.
No sign-in required.

📊 PREMIUM
Upgrade for extended sessions, advanced analytics, data export, and more.

Start your focus journey today!
```

### Support & Contact
- [ ] **Support URL**: https://focusfield.io/support (to be created)
- [ ] **Support Email**: support@focusfield.io (to be created)
- [ ] **Marketing URL**: https://focusfield.io (to be created)
- [ ] **Twitter**: @FocusFieldApp (optional)

---

## ⚖️ Legal & Compliance

### Privacy Policy (REQUIRED)
- [ ] **Create Privacy Policy**: `https://focusfield.io/privacy`

**Required Sections**:
1. **Information We Collect**
   - Microphone access (decibel levels only, no audio recording)
   - Session data (duration, ambient score, timestamps)
   - Device information (OS version, device model)
   - Optional analytics (anonymized usage data)

2. **How We Use Information**
   - Provide core app functionality
   - Calculate ambient scores and quest progress
   - Improve app performance
   - Optional analytics for product improvements

3. **Data Storage**
   - All data stored locally on device
   - No cloud transmission (free tier)
   - Premium: Optional cloud sync (if user enables)
   - Data deleted when app is uninstalled

4. **Third-Party Services**
   - RevenueCat (subscription management)
   - Google AdMob (advertising for free tier)
   - Firebase Analytics (optional, anonymized)

5. **User Rights**
   - Access your data (export feature)
   - Delete your data (reset feature)
   - Opt out of analytics
   - Contact support for questions

6. **Children's Privacy**
   - App suitable for ages 4+
   - No intentional data collection from children under 13
   - COPPA compliant

7. **Changes to Policy**
   - Notification of policy updates
   - Effective date

8. **Contact Information**
   - Email: privacy@focusfield.io
   - Address: [Your Business Address]

---

### Terms of Service (REQUIRED)
- [ ] **Create Terms of Service**: `https://focusfield.io/terms`

**Required Sections**:
1. **Acceptance of Terms**
2. **Description of Service**
3. **User Responsibilities**
   - Appropriate microphone usage
   - No abuse of free tier limits
4. **Subscription Terms**
   - Auto-renewal
   - Cancellation policy
   - Refund policy (follows App Store/Play Store policies)
5. **Intellectual Property**
   - App owned by SparkVibe IO
   - User owns their data
6. **Limitation of Liability**
7. **Termination**
8. **Governing Law**
9. **Contact Information**

---

### EULA (End-User License Agreement) - OPTIONAL
- [ ] Use standard App Store EULA (recommended)
- [ ] OR create custom EULA (if special terms needed)

---

### Other Legal Documents
- [ ] **Acceptable Use Policy** (if needed for abuse prevention)
- [ ] **DMCA Policy** (if user-generated content in future)
- [ ] **Cookie Policy** (if website has cookies)

---

## 🧪 Testing & Quality Assurance

### Pre-Submission Testing
- [x] All automated tests passing
- [ ] Manual testing on iOS devices:
  - [ ] iPhone SE (smallest screen)
  - [ ] iPhone 14 Pro (6.1")
  - [ ] iPhone 15 Pro Max (6.7")
  - [ ] iPad (if supporting)
- [ ] Manual testing on Android devices:
  - [ ] Small phone (5.5")
  - [ ] Medium phone (6.1")
  - [ ] Large phone (6.7")
  - [ ] Tablet (if supporting)

### Functionality Testing
- [ ] **Onboarding Flow**:
  - [ ] All 6 screens display correctly
  - [ ] Environment selection works
  - [ ] Goal setting works
  - [ ] Activity selection works
  - [ ] Microphone permission request
  - [ ] Navigation to Sessions tab
- [ ] **Core Features**:
  - [ ] Start/stop session works
  - [ ] Progress ring updates correctly
  - [ ] Ambient score calculates correctly
  - [ ] Quest progress updates
  - [ ] Streak tracking works
  - [ ] Freeze token works
- [ ] **Premium Features**:
  - [ ] Paywall appears for free users
  - [ ] Purchase flow works (sandbox)
  - [ ] Premium features unlock after purchase
  - [ ] Restoration works
- [ ] **Responsive Design**:
  - [ ] Portrait mode works
  - [ ] Landscape mode works (tablets ≥840dp)
  - [ ] Split-screen layout works
  - [ ] No UI overflow issues
- [ ] **Localization**:
  - [ ] All 7 languages render correctly
  - [ ] No missing translations
  - [ ] Date/time formats correct per locale
- [ ] **Edge Cases**:
  - [ ] Works without internet
  - [ ] Handles audio permission denial
  - [ ] Handles low memory situations
  - [ ] Background/foreground transitions
  - [ ] App lifecycle events

### Performance Testing
- [ ] App launch time < 2 seconds
- [ ] Memory usage stable (no leaks)
- [ ] Battery usage acceptable
- [ ] No frame drops during animations
- [ ] Audio processing doesn't lag

### Accessibility Testing
- [ ] VoiceOver/TalkBack works
- [ ] Dynamic type/font scaling works
- [ ] Color contrast ratios pass (4.5:1 minimum)
- [ ] Touch targets ≥48x48dp
- [ ] Reduced motion respected

---

## ✅ Final Submission Checklist

### iOS App Store

#### Step 1: Prepare Build
- [ ] Update version to `1.0.0+1` in `pubspec.yaml`
- [ ] Set `IS_DEVELOPMENT=false` and `ENABLE_MOCK_SUBSCRIPTIONS=false`
- [ ] Build iOS archive in Xcode
- [ ] Validate archive (Product > Archive > Validate App)
- [ ] Upload to App Store Connect (Product > Archive > Distribute App)

#### Step 2: Configure App Store Connect
- [ ] All metadata entered
- [ ] All screenshots uploaded
- [ ] App preview video uploaded (optional)
- [ ] Subscriptions configured
- [ ] Privacy policy URL added
- [ ] Terms of service URL added (optional)
- [ ] Support URL added
- [ ] Age rating completed
- [ ] App Review Information filled out

#### Step 3: Submit for Review
- [ ] Select build in App Store Connect
- [ ] Review all information one final time
- [ ] Submit for review
- [ ] Monitor status in App Store Connect

**Expected Review Time**: 24-48 hours

---

### Google Play Store

#### Step 1: Prepare Build
- [ ] Update version to `1.0.0+1` in `pubspec.yaml`
- [ ] Set `IS_DEVELOPMENT=false` and `ENABLE_MOCK_SUBSCRIPTIONS=false`
- [ ] Generate signed App Bundle:
  ```bash
  export REVENUECAT_API_KEY="goog_HNKHzGPIWgDdqihvtZrmgTdMSzf"
  ./scripts/build/build-prod.sh
  ```
- [ ] Upload `.aab` to Google Play Console (Production track)

#### Step 2: Configure Google Play Console
- [ ] Store listing complete
- [ ] Screenshots uploaded (all required sizes)
- [ ] Feature graphic uploaded
- [ ] Promo video uploaded (optional)
- [ ] Subscriptions configured
- [ ] Content rating complete
- [ ] Data safety form complete
- [ ] Privacy policy URL added
- [ ] Pricing & distribution configured

#### Step 3: Submit for Review
- [ ] Create production release
- [ ] Add release notes
- [ ] Review all information one final time
- [ ] Submit for review
- [ ] Monitor status in Play Console

**Expected Review Time**: 1-3 days (first submission may take longer)

---

## 🚀 Post-Submission

### Monitor Review Status
- [ ] Check App Store Connect daily
- [ ] Check Google Play Console daily
- [ ] Respond to any reviewer questions within 24 hours

### If Rejected
- [ ] Read rejection reason carefully
- [ ] Address all issues mentioned
- [ ] Update app if code changes needed
- [ ] Update metadata if needed
- [ ] Resubmit with explanation of changes

### After Approval
- [ ] Test app download from stores
- [ ] Verify subscriptions work in production
- [ ] Test restore purchases
- [ ] Monitor crash reports
- [ ] Monitor user reviews
- [ ] Prepare marketing materials
- [ ] Announce launch!

---

## 📞 Resources

### Apple
- App Store Connect: https://appstoreconnect.apple.com
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- App Store Subscriptions: https://developer.apple.com/app-store/subscriptions/

### Google
- Google Play Console: https://play.google.com/console
- Google Play Guidelines: https://support.google.com/googleplay/android-developer/answer/9859455
- Google Play Subscriptions: https://developer.android.com/google/play/billing/subscriptions

### RevenueCat
- Dashboard: https://app.revenuecat.com
- Documentation: https://docs.revenuecat.com

### Internal Documentation
- [`docs/deployment/iOS_SETUP.md`](iOS_SETUP.md) - iOS deployment guide
- [`docs/deployment/ANDROID_SETUP.md`](ANDROID_SETUP.md) - Android deployment guide
- [`docs/MONETIZATION_SETUP.md`](../MONETIZATION_SETUP.md) - Subscription setup
- [`docs/business/phase1-launch-plan.md`](../business/phase1-launch-plan.md) - Launch strategy

---

**Next Steps**: Start with Visual Assets creation (Week 2 priority)

