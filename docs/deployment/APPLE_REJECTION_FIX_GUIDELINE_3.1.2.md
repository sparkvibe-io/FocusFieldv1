# Apple App Store Rejection Fix - Guideline 3.1.2

**Rejection Date**: November 4, 2025
**Submission ID**: 525fc602-2630-4616-8a62-50efe450a4ad
**Issue**: Missing Terms of Use (EULA) for apps with auto-renewable subscriptions

---

## ❌ What Went Wrong

Apple rejected Focus Field 1.0 because apps offering **auto-renewable subscriptions** MUST include:

1. ✅ **Privacy Policy URL** (you have this)
2. ❌ **Terms of Use (EULA) URL** - **THIS IS MISSING**

---

## ✅ How to Fix (Two Options)

### Option 1: Use Apple's Standard EULA (RECOMMENDED - Quickest Fix)

This is the **fastest and easiest** solution. You don't need to host any document.

#### Step 1: Update App Description
Go to **App Store Connect** → Your App → **App Information** → **Description**

Add this line at the **end of your App Description**:

```
Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
```

#### Step 2: Resubmit
- Save the changes
- Go to **Version** → **Submit for Review**
- Add a note: "Added Terms of Use link to app description as requested"

**Done!** ✅ This should pass review immediately.

---

### Option 2: Use Custom EULA (More Control, Takes Longer)

If you want custom terms tailored to Focus Field, follow these steps:

#### Step 1: Host the EULA Document

You need to make the EULA publicly accessible at a URL. Options:

**A. GitHub Pages (Free, Easy)**
1. Create a new repository or use your existing one
2. Upload `docs/legal/TERMS_OF_USE.md` (already created for you)
3. Enable GitHub Pages in repository settings
4. Your URL will be: `https://[your-username].github.io/focusfield/TERMS_OF_USE.html`

**B. Your Own Website**
- Upload to: `https://focusfield.io/terms`
- Make sure it's publicly accessible (no login required)

**C. Simple Hosting (e.g., Netlify, Vercel)**
- Create a simple static site
- Host the Terms of Use page
- Get a public URL

#### Step 2: Add EULA to App Store Connect

Go to **App Store Connect** → Your App → **App Information** → **License Agreement**

**Options:**
- **Option A**: Add the link to your **App Description** (same as Option 1):
  ```
  Terms of Use: https://focusfield.io/terms
  ```

- **Option B**: Upload custom EULA in App Store Connect:
  1. Click "Add Custom License Agreement"
  2. Paste the full text from `docs/legal/TERMS_OF_USE.md`
  3. Save

#### Step 3: Resubmit
- Save all changes
- Go to **Version** → **Submit for Review**
- Add a note: "Added custom Terms of Use as requested"

---

## 📋 What Must Be in the Binary (Already Done ✅)

Apple also requires that subscription information appears **inside your app**. Let me verify you have this:

### Required in App Binary:
- [ ] **Title** of subscription (e.g., "Premium Monthly")
- [ ] **Length** of subscription (e.g., "1 month")
- [ ] **Price** of subscription (e.g., "$1.99/month")
- [ ] **Link to Privacy Policy** (clickable URL in app)
- [ ] **Link to Terms of Use** (clickable URL in app)

**Where to check**: Look at your paywall screen in the app. It should display all of the above.

If your app is missing any of these, you'll need to add them and resubmit a new binary.

---

## 🔍 Verification Checklist

Before resubmitting, verify:

### In App Store Connect:
- [ ] App Description includes Terms of Use link (at the end)
- [ ] Privacy Policy URL is filled in: `https://[your-privacy-url]`
- [ ] All subscription products are configured
- [ ] Screenshot captions mention subscription details

### In Your App Binary:
- [ ] Paywall screen shows subscription title
- [ ] Paywall screen shows subscription duration
- [ ] Paywall screen shows subscription price
- [ ] Paywall screen has clickable Privacy Policy link
- [ ] Paywall screen has clickable Terms of Use link

If ALL of the above are checked, you're ready to resubmit.

---

## 📱 Quick Paywall Check

Let me help you verify your paywall has the required information. Check these files:

1. **Paywall Screen**: `lib/widgets/paywall_modal.dart` or similar
2. **Subscription Display**: Look for RevenueCat offering display

**Required Elements**:
```dart
// Example of what Apple wants to see in your app:

"Premium Monthly"                    // ✅ Title
"$1.99 per month"                    // ✅ Price
"Renews automatically each month"   // ✅ Duration

TextButton(
  child: Text("Privacy Policy"),
  onPressed: () => launch("https://focusfield.io/privacy"),
),

TextButton(
  child: Text("Terms of Use"),
  onPressed: () => launch("https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"),
),
```

If your app doesn't have these links, you'll need to add them and submit a **new binary**.

---

## 🚀 Recommended Solution (Fastest Path to Approval)

**For fastest approval, do this:**

1. **Update App Description** (App Store Connect):
   - Add this line at the end: `Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
   - Save changes

2. **Verify In-App Links** (if needed, update binary):
   - Check paywall screen has Privacy Policy link
   - Check paywall screen has Terms of Use link
   - If missing, add them and resubmit new binary

3. **Resubmit for Review**:
   - Go to **Version** → **Submit for Review**
   - In "Review Notes" field, write:
     ```
     We have added the Terms of Use link to the app description as requested.

     Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/

     All subscription information (title, duration, price) is displayed in the app's
     paywall screen with links to Privacy Policy and Terms of Use.
     ```

4. **Wait for Approval** (usually 24-48 hours for resubmissions)

---

## 📚 Apple Resources Referenced

1. **Apple Developer Program License Agreement - Schedule 2**:
   https://developer.apple.com/programs/apple-developer-program-license-agreement/#S2

2. **Standard Apple EULA**:
   https://www.apple.com/legal/internet-services/itunes/dev/stdeula/

3. **Provide a Custom License Agreement**:
   https://developer.apple.com/help/app-store-connect/manage-app-information/provide-a-custom-license-agreement

---

## 🆘 If You Still Get Rejected

If Apple rejects again after adding the Terms of Use link, common reasons include:

1. **Missing In-App Links**:
   - Your paywall screen doesn't have clickable Privacy Policy or Terms links
   - **Fix**: Add TextButtons or Links to your paywall

2. **Links Not Working**:
   - The URLs return 404 or are not publicly accessible
   - **Fix**: Test all links in a browser before submitting

3. **Missing Subscription Info in App**:
   - Title, duration, or price not displayed in paywall
   - **Fix**: Update paywall to show all required info

4. **Wrong EULA Field**:
   - Link added to wrong place in App Store Connect
   - **Fix**: Must be in **App Description** or **License Agreement** field

---

## 📞 Need Help?

If you encounter issues:

1. **Apple Developer Support**: https://developer.apple.com/contact/
2. **App Review**: Use "Request Expedited Review" if urgent
3. **Resolution Center**: Reply to rejection in App Store Connect

---

## ✅ Success Criteria

Your resubmission will be approved when:

- ✅ App Description contains Terms of Use link
- ✅ Privacy Policy URL is filled in
- ✅ Paywall shows subscription title, duration, price
- ✅ Paywall has clickable Privacy Policy link
- ✅ Paywall has clickable Terms of Use link

**Expected approval time**: 24-48 hours for metadata-only changes

---

**Last Updated**: November 4, 2025
**Next Review**: After resubmission approval
