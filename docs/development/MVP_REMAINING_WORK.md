# MVP Remaining Work - Focus Field

**Last Updated**: October 20, 2025
**Status**: Technical implementation complete, platform configuration pending

---

## 🎯 Critical Path to Launch (Week 2-3)

### Week 2: Platform Configuration & Visual Assets

#### 1. App Store Connect Setup
**Owner**: Krishna
**Estimated Time**: 2-3 hours

- [ ] Create Focus Field app entry in App Store Connect
- [ ] Configure subscription products:
  - [ ] Premium ($1.99/month, $19.99/year)
  - [ ] Premium Plus ($3.99/month, $39.99/year)
- [ ] Link RevenueCat API key: `appl_qoFokYDCMBFZLyKXTulaPFkjdME`
- [ ] Set up App Privacy details (microphone usage)
- [ ] Configure age rating (4+)

#### 2. Google Play Console Setup
**Owner**: Krishna
**Estimated Time**: 2-3 hours

- [ ] Create Focus Field app entry in Google Play Console
- [ ] Configure subscription products (same pricing as iOS)
- [ ] Link RevenueCat API key: `goog_HNKHzGPIWgDdqihvtZrmgTdMSzf`
- [ ] Set up app permissions (RECORD_AUDIO explanation)
- [ ] Configure content rating (ESRB: Everyone)

#### 3. Visual Assets Creation
**Owner**: Krishna/Designer
**Estimated Time**: 4-6 hours

**App Icon** (required):
- [ ] 1024x1024px for iOS App Store
- [ ] Adaptive icon for Android (108x108dp foreground + background)
- [ ] Design: Focus Field logo with ambient noise wave visualization
- [ ] Color scheme: Teal/cyan (matches app theme)

**Store Screenshots** (5 required per platform):
1. [ ] Home screen with "Sessions" tab (progress ring, duration selectors)
2. [ ] Focus Mode full-screen overlay (countdown timer, calm %)
3. [ ] Today tab with activity heatmap and streak display
4. [ ] Settings screen showing FAQ and Help & Support
5. [ ] Onboarding screen 1 (Welcome with 3 key features)

**Screenshot Specs**:
- iOS: 6.7" (iPhone 14 Pro Max) - 1290 x 2796 pixels
- Android: 16:9 aspect ratio - minimum 1080 x 1920 pixels

#### 4. Legal Documents
**Owner**: Krishna/Legal Review
**Estimated Time**: 3-4 hours

- [ ] Privacy Policy (host at: `https://focusfield.app/privacy`)
  - [ ] Microphone data usage (decibel levels only, no recording)
  - [ ] RevenueCat subscription data handling
  - [ ] AdMob advertising identifiers
  - [ ] Analytics data (Firebase/Google Analytics)
  - [ ] User data deletion process
- [ ] Terms of Service (host at: `https://focusfield.app/terms`)
  - [ ] Subscription terms (auto-renewal, cancellation)
  - [ ] Refund policy (7-day trial period)
  - [ ] Acceptable use policy
  - [ ] Intellectual property rights
- [ ] Update app constants:
  ```dart
  // lib/constants/app_constants.dart
  static const String privacyPolicyUrl = 'https://focusfield.app/privacy';
  static const String termsOfServiceUrl = 'https://focusfield.app/terms';
  ```

---

### Week 3: Store Submission

#### 5. App Store Listing (iOS)
**Owner**: Krishna
**Estimated Time**: 2 hours

- [ ] App name: "Focus Field - Ambient Focus Timer"
- [ ] Subtitle: "Build deep work habits with silence"
- [ ] Keywords: "focus,productivity,ambient,timer,meditation,study,concentration,deep work,pomodoro,silence"
- [ ] Description (4000 char max):
  - [ ] Opening hook (what problem it solves)
  - [ ] Key features (Ambient Score, streaks, Focus Mode)
  - [ ] Premium benefits
  - [ ] User testimonials (if available)
- [ ] Promotional text: "Track your focus with ambient noise monitoring"
- [ ] Support URL: `https://focusfield.app/support` or email
- [ ] Marketing URL: `https://focusfield.app`

#### 6. Google Play Listing (Android)
**Owner**: Krishna
**Estimated Time**: 2 hours

- [ ] App title: "Focus Field - Ambient Focus Timer"
- [ ] Short description (80 char): "Build deep work habits by monitoring ambient silence in your environment"
- [ ] Full description (4000 char max) - same as iOS
- [ ] Categorization: Productivity
- [ ] Content rating questionnaire
- [ ] Feature graphic: 1024 x 500 pixels
- [ ] Promo video (optional): YouTube link

#### 7. Build & Upload
**Owner**: Krishna
**Estimated Time**: 1-2 hours

**iOS**:
- [ ] Update version to 1.0.0 in `pubspec.yaml`
- [ ] Run production build: `./scripts/build/build-prod.sh --ios`
- [ ] Archive in Xcode: Product > Archive
- [ ] Upload to App Store Connect via Xcode Organizer
- [ ] Submit for review

**Android**:
- [ ] Update version to 1.0.0 in `pubspec.yaml`
- [ ] Run production build: `./scripts/build/build-prod.sh --android`
- [ ] Sign APK with release keystore
- [ ] Upload to Google Play Console (Internal Testing → Production)
- [ ] Submit for review

---

## 🚫 Explicitly NOT Blocking Launch

### Technical Deferrals (P2)
These are nice-to-have improvements that can be added after launch based on user feedback:

1. **iOS Live Activities**
   - Android ongoing notification fully functional
   - Can add iOS Dynamic Island support post-launch
   - Docs: `docs/development/iOS_Live_Activities_Plan.md`

2. **FAQ Translations**
   - English FAQ complete (20 comprehensive entries)
   - Sufficient for MVP (80%+ users are English-speaking)
   - Can translate based on user demand per language

3. **Focus Mode P2/P3 Enhancements**
   - Current P1 Focus Mode fully functional
   - Breathing animation, themes, lock mode are polish features
   - Can add after validating core value proposition

4. **Custom Activity Creation**
   - 3 default profiles (Study, Reading, Meditation) cover 90% of use cases
   - Custom activities add complexity without proven demand
   - Can add when users request specific activity types

5. **71 Hardcoded UI Strings**
   - Non-critical text elements (e.g., "Edit", "Start", "Error")
   - Have English fallback text
   - Can systematically replace in maintenance sprints

### Feature Flags (Disabled)
- `FF_ACTIVE_PROFILES = false` (fitness, family activities)
- `FF_HEALTH_SYNC = false` (Apple Health integration)
- `FF_CALENDAR_EXPORT = false` (calendar event creation)

---

## ✅ Already Complete (No Action Needed)

### Technical Implementation
- ✅ Core app functionality (noise monitoring, sessions, scoring)
- ✅ Ambient Quests system (daily goals, streaks, freeze tokens)
- ✅ Focus Mode (full-screen overlay with completion states)
- ✅ Monetization (RevenueCat + AdMob fully integrated)
- ✅ Responsive design (phone + tablet with landscape support)
- ✅ Onboarding flow (6 comprehensive screens)
- ✅ FAQ system (20 Q&A entries with search)
- ✅ Localization (7 languages: EN, ES, DE, FR, JA, PT, PT_BR)
- ✅ All 52 tests passing
- ✅ Zero critical bugs or analyzer errors

### Code Quality
- ✅ Flutter analyzer clean (only 12 optional const suggestions)
- ✅ All deprecated APIs migrated (Color.withOpacity, Share.share, etc.)
- ✅ Proper resource disposal (streams, controllers, animations)
- ✅ Riverpod best practices (no anti-patterns)
- ✅ Debug logging optimized (tree-shaken in release builds)

---

## 📅 Timeline Summary

| Week | Focus | Deliverables | Owner |
|------|-------|--------------|-------|
| **Week 2** | Platform Setup | App Store Connect, Google Play Console, Visual Assets, Legal Docs | Krishna |
| **Week 3** | Store Submission | Listings, Screenshots, Build Upload, Submit for Review | Krishna |
| **Week 4-6** | Launch & Marketing | User acquisition, feedback monitoring, bug fixes | Krishna |

**Target Launch Date**: Week 3 completion (~November 10, 2025)

---

## 🎯 Success Metrics (Post-Launch)

### Week 1 Metrics
- [ ] 100+ downloads (organic + initial marketing)
- [ ] <1% crash rate
- [ ] >4.0 star rating (if reviews come in)
- [ ] 1-2 premium conversions (validate monetization)

### Month 1 Goals
- [ ] 1,000 downloads
- [ ] 50 premium subscribers ($100 MRR)
- [ ] 5 user testimonials
- [ ] Feature parity (iOS + Android both stable)

---

## 🔧 Technical Debt (Post-Launch Cleanup)

### P1 (First Maintenance Sprint)
1. Address remaining 12 const constructor suggestions
2. Migrate 71 hardcoded strings to localization files
3. Add FAQ translations for top 3 languages (ES, DE, FR)
4. Set up automated screenshot testing

### P2 (Second Maintenance Sprint)
1. iOS Live Activities implementation
2. Focus Mode breathing animation
3. Advanced analytics dashboard polish
4. Performance optimization (reduce app startup time)

---

## 📞 Support Resources

### During Launch Week
- **Email**: focusfield@sparkvibe.io (monitored daily)
- **In-App**: FAQ (20 entries) + Contact Support form
- **Documentation**: This file + CLAUDE.md for developers

### Post-Launch
- Consider setting up:
  - Discord community for power users
  - Knowledge base (Notion/Intercom)
  - Reddit community (r/FocusField)

---

## ✨ Launch Checklist (Final Verification)

**48 Hours Before Submission**:
- [ ] Run full test suite: `./scripts/testing/test.sh --coverage`
- [ ] Verify both platform builds: `./scripts/build/build-prod.sh`
- [ ] Test premium subscription flow (production keys)
- [ ] Test onboarding flow (fresh install)
- [ ] Test FAQ search functionality
- [ ] Verify all 4 Help & Support buttons work
- [ ] Check privacy policy & terms links
- [ ] Test AdMob ads (real ads, not test units)
- [ ] Screenshot capture for store listings

**24 Hours Before Submission**:
- [ ] Final build number increment
- [ ] Git tag release: `v1.0.0`
- [ ] Push to main branch
- [ ] Create release notes
- [ ] Archive build artifacts

**Submission Day**:
- [ ] Upload iOS build to App Store Connect
- [ ] Upload Android build to Google Play Console
- [ ] Submit for review (both platforms)
- [ ] Monitor review status daily
- [ ] Prepare marketing materials for launch announcement

---

**Document Owner**: Krishna
**Next Review**: Week 2 completion (after platform configuration)
**Questions/Updates**: Update this file as work progresses
