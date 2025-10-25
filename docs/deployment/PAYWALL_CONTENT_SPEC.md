# Paywall Content Specification - Focus Field

**Last Updated**: October 19, 2025
**Purpose**: Define all content for in-app paywall and subscription management screens

---

## 📋 Table of Contents

1. [Paywall Screen Content](#paywall-screen-content)
2. [Subscription Details](#subscription-details)
3. [Feature Comparison](#feature-comparison)
4. [Store Listing Content](#store-listing-content)
5. [Legal Requirements](#legal-requirements)
6. [User Communication](#user-communication)

---

## 💎 Paywall Screen Content

### Primary Headline
```
Unlock Premium Features
```

### Secondary Headline
```
Extended sessions, advanced analytics, and more
```

### Feature List (Premium $1.99/mo)

#### 1. Extended Sessions ⏱️
**Title**: Extended Sessions
**Description**: Focus for up to 120 minutes (vs 30 min free)
**Icon**: Clock/Timer icon

#### 2. Advanced Analytics 📊
**Title**: Advanced Analytics
**Description**: 6 performance metrics, trend charts, moving averages
**Icon**: Chart/Graph icon

#### 3. Data Export 📁
**Title**: Data Export
**Description**: Export session history to CSV/PDF
**Icon**: Download/Export icon

#### 4. Extended History 📅
**Title**: 90-Day History
**Description**: Keep 90 days of sessions (vs 7 days free)
**Icon**: Calendar icon

#### 5. Premium Themes 🎨
**Title**: Premium Themes
**Description**: Exclusive color themes (Ocean, Forest, Cyber, etc.)
**Icon**: Palette icon

#### 6. Premium Durations ⭐
**Title**: Premium Durations
**Description**: Access 1h, 1.5h, and 2h session options
**Icon**: Star icon

#### 7. Priority Support 💬
**Title**: Priority Support
**Description**: Get help faster with priority email support
**Icon**: Support/Help icon

---

### Pricing Display

**Monthly Plan**
```
Premium
$1.99 / month

Billed monthly
Cancel anytime
```

**Yearly Plan** (Optional - 16% savings)
```
Premium Yearly
$19.99 / year

Save $4! ($1.67/month)
Billed annually
Cancel anytime
```

---

### Call-to-Action Buttons

**Primary Button**:
```
Start Free Trial (7 Days)
```

**Secondary Button** (if no trial):
```
Subscribe Now
```

**Tertiary Button**:
```
Restore Purchases
```

**Dismiss Button**:
```
Maybe Later
```

---

### Fine Print (Below buttons)

```
• Free trial for 7 days, then $1.99/month
• Auto-renews unless canceled 24hrs before period ends
• Cancel anytime in Settings
• Terms of Service | Privacy Policy
```

---

### Social Proof (Optional)

```
⭐⭐⭐⭐⭐ "Best focus app I've found!"
⭐⭐⭐⭐⭐ "The ambient scoring is genius"
⭐⭐⭐⭐⭐ "Finally, a productivity app that works"
```

---

## 📦 Subscription Details

### Product IDs

**iOS**:
- Monthly: `premium.tier.monthly`
- Yearly: `premium.tier.yearly` (optional)

**Android**:
- Monthly: `premium.tier.monthly`
- Yearly: `premium.tier.yearly` (optional)

**RevenueCat**:
- Entitlement: `Premium`
- Offering: `current`

---

### Pricing Strategy

**Base Pricing**:
- Monthly: $1.99 USD
- Yearly: $19.99 USD (16% savings vs monthly)

**Regional Pricing** (App Store Tier 2):
| Region | Monthly | Yearly |
|--------|---------|--------|
| US | $1.99 | $19.99 |
| UK | £1.99 | £19.99 |
| EU | €1.99 | €19.99 |
| CA | $2.79 CAD | $27.99 CAD |
| AU | $2.99 AUD | $29.99 AUD |
| JP | ¥300 | ¥3,000 |

*Note: Prices automatically adjusted by App Store/Play Store based on local currency*

---

### Free Trial Configuration

**Trial Period**: 7 days (recommended)

**Trial Messaging**:
```
Try Premium free for 7 days

Explore all features risk-free. Cancel anytime during trial
and you won't be charged.

Trial starts immediately after confirmation.
```

**Post-Trial**:
```
Your 7-day trial ended. Subscribe to continue using Premium features.
```

---

### Cancellation Policy

**Messaging**:
```
You can cancel your subscription anytime:

iOS: Settings > [Your Name] > Subscriptions > Focus Field > Cancel
Android: Play Store > Subscriptions > Focus Field > Cancel

Cancellation takes effect at end of current billing period.
You'll keep Premium until then.
```

---

## 🆚 Feature Comparison

### Free vs Premium Table

| Feature | Free | Premium ($1.99/mo) |
|---------|------|-------------------|
| **Session Length** | Up to 30 min | Up to 120 min |
| **Session History** | 7 days | 90 days |
| **Activity Tracking** | ✅ Study, Reading, Meditation | ✅ Study, Reading, Meditation |
| **Quest System** | ✅ Daily goals & streaks | ✅ Daily goals & streaks |
| **Focus Mode** | ✅ Full-screen overlay | ✅ Full-screen overlay |
| **Ambient Monitoring** | ✅ Real-time | ✅ Real-time |
| **Basic Analytics** | ✅ 7-day chart | ✅ 7-day chart |
| **Advanced Analytics** | ❌ | ✅ 6 metrics, trends, insights |
| **Data Export** | ❌ | ✅ CSV/PDF |
| **Premium Themes** | ❌ | ✅ 5+ themes |
| **Premium Durations** | ❌ | ✅ 1h, 1.5h, 2h options |
| **Ads** | ✅ Banner ads | ❌ Ad-free |
| **Support** | Standard email | Priority email |

---

## 🏪 Store Listing Content

### Subscription Group Name
```
Focus Field Premium
```

### Subscription Display Name (iOS)
```
Premium
```

### Subscription Description (Short - 45 chars)
```
Extended sessions and advanced analytics
```

### Subscription Description (Long - 170 chars)
```
Unlock extended focus sessions (up to 120 min), advanced analytics with 6 performance metrics, data export (CSV/PDF), premium themes, 90-day history, and priority support
```

### Subscription Benefits (Bullet Points)
```
• Extended sessions up to 120 minutes
• Advanced analytics with trend charts
• Export data to CSV or PDF
• 90-day session history
• Premium color themes
• 1h, 1.5h, 2h duration options
• Ad-free experience
• Priority email support
```

---

## ⚖️ Legal Requirements

### Terms of Service Link (REQUIRED)
```
https://focusfield.io/terms
```

**Button Text**: "Terms of Service"

---

### Privacy Policy Link (REQUIRED)
```
https://focusfield.io/privacy
```

**Button Text**: "Privacy Policy"

---

### Auto-Renewal Disclosure (REQUIRED)

**iOS**:
```
Payment will be charged to iTunes Account at confirmation of purchase.
Subscription automatically renews unless auto-renew is turned off at
least 24 hours before the end of the current period. Account will be
charged for renewal within 24 hours prior to the end of the current
period at the rate of the selected plan. Subscriptions and auto-renewal
may be managed by going to Account Settings after purchase.
```

**Android**:
```
Payment will be charged to Google Play Account at confirmation of purchase.
Subscription automatically renews unless auto-renew is turned off at least
24 hours before the end of the current period. Account will be charged for
renewal within 24 hours prior to the end of the current period. You can
manage and cancel your subscriptions by going to subscriptions in Google
Play Store.
```

---

### Refund Policy

**Apple App Store** (use default):
```
Refunds processed according to Apple's standard refund policy.
To request a refund, visit reportaproblem.apple.com
```

**Google Play Store** (use default):
```
Refunds processed according to Google Play's refund policy.
To request a refund, visit play.google.com/store/account/subscriptions
```

**Custom Policy** (optional, for your website):
```
Refund requests handled on case-by-case basis within first 7 days of
purchase. Contact support@focusfield.io with order details.
```

---

## 💬 User Communication

### Feature Gate Messages

#### When Free User Attempts Premium Feature

**Extended Sessions** (>30 min):
```
🔒 Premium Feature

Extended sessions (up to 120 min) are available with Premium.
Free tier limited to 30-minute sessions.

[Upgrade to Premium] [Cancel]
```

**Advanced Analytics**:
```
🔒 Premium Feature

Advanced analytics with 6 performance metrics, trend charts,
and data-driven insights available with Premium.

[Upgrade to Premium] [Cancel]
```

**Data Export**:
```
🔒 Premium Feature

Export your session history to CSV or PDF with Premium.

[Upgrade to Premium] [Cancel]
```

**Premium Durations** (1h, 1.5h, 2h):
```
🔒 Premium Feature

1-hour, 1.5-hour, and 2-hour sessions available with Premium.

[Upgrade to Premium] [Cancel]
```

**Premium Themes**:
```
🔒 Premium Feature

Unlock 5+ exclusive color themes with Premium.

[Upgrade to Premium] [Cancel]
```

---

### Success Messages

**After Successful Purchase**:
```
✅ Welcome to Premium!

All Premium features are now unlocked. Enjoy ad-free sessions,
extended durations, and advanced analytics!

[Get Started]
```

**After Successful Restore**:
```
✅ Premium Restored

Your Premium subscription has been restored. All features unlocked!

[Continue]
```

**After Cancellation** (shown at end of billing period):
```
⚠️ Premium Ending Soon

Your Premium subscription ends on [DATE]. After that, you'll
return to the Free tier.

Want to keep Premium benefits?

[Resubscribe] [Continue with Free]
```

---

### Error Messages

**Purchase Failed**:
```
❌ Purchase Failed

We couldn't complete your purchase. Please try again or check
your payment method.

[Retry] [Cancel]
```

**Restore Failed**:
```
❌ No Subscriptions Found

We couldn't find any active subscriptions for this account.
If you believe this is an error, contact support.

[Contact Support] [Cancel]
```

**Network Error**:
```
❌ Connection Error

Could not verify subscription status. Please check your internet
connection and try again.

[Retry] [Cancel]
```

---

### Settings Screen Content

#### Subscription Management Section

**Free User**:
```
Subscription: Free
Upgrade to Premium for extended sessions and analytics
[Upgrade to Premium]
```

**Premium User**:
```
Subscription: Premium ✨
Status: Active
Next billing: [DATE]
[Manage Subscription] [Cancel Subscription]
```

**Premium User (Cancelled)**:
```
Subscription: Premium (Ending)
Active until: [DATE]
[Resubscribe]
```

---

### Email Templates

#### Welcome Email (After Purchase)
**Subject**: Welcome to Focus Field Premium! 🎉

```
Hi [Name],

Welcome to Focus Field Premium! You now have access to:

✅ Extended sessions (up to 120 minutes)
✅ Advanced analytics with 6 metrics
✅ Data export (CSV/PDF)
✅ Premium themes
✅ 90-day history
✅ Ad-free experience

Get started: Open the app and try a 120-minute session!

Questions? Reply to this email or visit focusfield.io/support

Happy focusing!
The Focus Field Team
```

---

#### Renewal Reminder (3 days before)
**Subject**: Your Focus Field Premium renews in 3 days

```
Hi [Name],

Your Focus Field Premium subscription renews on [DATE] for $1.99.

Want to keep Premium? No action needed!
Want to cancel? Go to Settings > Subscriptions before [DATE].

Thanks for being a Premium member!
The Focus Field Team
```

---

#### Cancellation Confirmation
**Subject**: Focus Field Premium Cancelled

```
Hi [Name],

Your Premium subscription has been cancelled. You'll keep Premium
benefits until [DATE], then return to the Free tier.

Changed your mind? Resubscribe anytime in the app.

Thanks for trying Premium!
The Focus Field Team
```

---

## 📊 A/B Testing Ideas (Future)

### Headline Variations
1. "Unlock Your Full Potential" (aspirational)
2. "Go Premium, Stay Focused" (action-oriented)
3. "Upgrade for Better Focus" (benefit-focused)

### Pricing Display
1. Show yearly savings upfront
2. Emphasize monthly cost ($1.99/mo)
3. Highlight value ("Less than a coffee!")

### Feature Order
1. Lead with most popular feature
2. Lead with highest-value feature
3. Lead with newest feature

---

## ✅ Content Checklist

- [ ] All paywall text reviewed for clarity
- [ ] Legal disclosures complete and accurate
- [ ] Pricing verified across all regions
- [ ] Feature descriptions match actual functionality
- [ ] Error messages user-friendly
- [ ] Success messages celebratory
- [ ] Email templates professional
- [ ] Cancellation flow empathetic (not manipulative)
- [ ] All links functional
- [ ] Content localized for all 7 languages

---

**Next Steps**: Implement paywall UI with this content, then test purchase flows

