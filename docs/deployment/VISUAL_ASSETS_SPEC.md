# Visual Assets Specification - Focus Field

**Last Updated**: October 19, 2025
**Purpose**: Complete specification for all visual assets needed for App Store submission

---

## 📋 Table of Contents

1. [App Icons](#app-icons)
2. [Screenshots](#screenshots)
3. [Promotional Graphics](#promotional-graphics)
4. [Design Guidelines](#design-guidelines)
5. [Production Checklist](#production-checklist)

---

## 🎨 App Icons

### iOS Icon Requirements

| Size | Usage | Filename | Resolution |
|------|-------|----------|------------|
| 1024x1024 | App Store | `AppIcon-AppStore.png` | @1x |
| 180x180 | iPhone 3x | `AppIcon-60@3x.png` | @3x |
| 120x120 | iPhone 2x | `AppIcon-60@2x.png` | @2x |
| 167x167 | iPad Pro | `AppIcon-83.5@2x.png` | @2x |
| 152x152 | iPad 2x | `AppIcon-76@2x.png` | @2x |
| 76x76 | iPad 1x | `AppIcon-76.png` | @1x |
| 60x60 | iPhone Spotlight | `AppIcon-Spotlight-60@3x.png` | @3x |
| 40x40 | iPhone Spotlight | `AppIcon-Spotlight-40@2x.png` | @2x |

**Technical Requirements**:
- Format: PNG (24-bit or 32-bit)
- Color Space: sRGB or Display P3
- No alpha channel for 1024x1024
- Alpha channel OK for smaller sizes
- No rounded corners (iOS adds automatically)

---

### Android Icon Requirements

| Size | Usage | Folder | Filename |
|------|-------|--------|----------|
| 512x512 | Play Store | N/A | `icon-512.png` |
| 192x192 | xxxhdpi | `mipmap-xxxhdpi/` | `ic_launcher.png` |
| 144x144 | xxhdpi | `mipmap-xxhdpi/` | `ic_launcher.png` |
| 96x96 | xhdpi | `mipmap-xhdpi/` | `ic_launcher.png` |
| 72x72 | hdpi | `mipmap-hdpi/` | `ic_launcher.png` |
| 48x48 | mdpi | `mipmap-mdpi/` | `ic_launcher.png` |

**Additional Android Assets**:
- [ ] Adaptive Icon Foreground (108x108dp) - `ic_launcher_foreground.xml`
- [ ] Adaptive Icon Background (108x108dp) - `ic_launcher_background.xml`
- [ ] Feature Graphic (1024x500) - `feature-graphic.png`

**Technical Requirements**:
- Format: PNG (32-bit with alpha)
- Color Space: sRGB
- Safe zone: 66x66dp for adaptive icons
- Round icon support: `ic_launcher_round.png`

---

### Icon Design Concept

**Primary Concept**: "Ambient Silence Measurement"

**Visual Elements**:
1. **Progress Ring** - Main element
   - Circular ring (Focus Field's signature UI)
   - Gradient: Teal (#009688) to Cyan (#00BCD4)
   - Subtle glow effect

2. **Center Symbol** - One of:
   - **Option A**: Decibel icon (dB) - Technical, clear
   - **Option B**: Sound wave (minimal) - Recognizable
   - **Option C**: "FF" monogram - Brand-focused

3. **Color Palette**:
   - Primary: Teal (#009688)
   - Accent: Cyan (#00BCD4)
   - Background: White or subtle gradient
   - For dark mode icon: Dark slate background

**Style Guidelines**:
- Modern, minimal design
- Material 3 aesthetic
- Works well at 40x40px minimum
- Recognizable silhouette
- No text except optional "FF"

---

### Icon Variants to Design

1. **Light Version** - White/light background
2. **Dark Version** - Dark background (for iOS)
3. **Rounded Version** - For Android round icons
4. **Adaptive Version** - Foreground + background layers

---

## 📸 Screenshots

### iOS Screenshot Requirements

#### 6.7" Display (iPhone 14/15 Pro Max) - REQUIRED
**Dimensions**: 1290 x 2796 pixels

**Required Screenshots** (8 total):

1. **Home Screen - Start Session**
   - File: `ios-67-01-home.png`
   - Show: Progress ring, duration selector, "Start" button
   - Text Overlay: "Start Your Focus Session"
   - Highlight: Duration chips (1, 5, 10, 30 min)

2. **Active Session - Ambient Monitoring**
   - File: `ios-67-02-session.png`
   - Show: Progress ring with 10:00 remaining, "85% Calm" indicator
   - Text Overlay: "Real-Time Ambient Monitoring"
   - Highlight: Live calm percentage

3. **Today Tab - Activity Progress**
   - File: `ios-67-03-today.png`
   - Show: Activity rings (Study 8/10, Reading 5/10, Meditation 7/10)
   - Text Overlay: "Track Your Daily Progress"
   - Highlight: Per-activity tracking

4. **Quest Progress - Streak System**
   - File: `ios-67-04-quest.png`
   - Show: Quest capsule with 5-day streak, progress bar
   - Text Overlay: "Build Compassionate Streaks"
   - Highlight: Streak counter + freeze token

5. **Focus Mode - Minimal Distractions**
   - File: `ios-67-05-focus.png`
   - Show: Full-screen Focus Mode overlay
   - Text Overlay: "Minimize Distractions"
   - Highlight: Long-press Pause/Stop controls

6. **Analytics - 12-Week Heatmap**
   - File: `ios-67-06-analytics.png`
   - Show: GitHub-style heatmap + trend charts
   - Text Overlay: "Visualize Your Journey"
   - Highlight: 12-week activity visualization

7. **Settings - Customization**
   - File: `ios-67-07-settings.png`
   - Show: Activity edit sheet with goal slider
   - Text Overlay: "Customize Your Experience"
   - Highlight: Activity toggles + goal adjustment

8. **Onboarding - Getting Started**
   - File: `ios-67-08-onboarding.png`
   - Show: Welcome screen with 3 key features
   - Text Overlay: "Get Started in Seconds"
   - Highlight: Clean, guided setup

---

#### 5.5" Display (iPhone 8 Plus) - REQUIRED
**Dimensions**: 1242 x 2208 pixels

- [ ] Same 8 screenshots, scaled down
- [ ] Files: `ios-55-01.png` through `ios-55-08.png`

---

#### 12.9" iPad Pro (Optional)
**Dimensions**: 2048 x 2732 pixels

- [ ] Same 8 screenshots, tablet-optimized
- [ ] Show landscape split-screen for relevant screens
- [ ] Files: `ipad-129-01.png` through `ipad-129-08.png`

---

### Android Screenshot Requirements

#### Phone (REQUIRED)
**Dimensions**: 1080 x 1920 pixels minimum (9:16 aspect ratio)

- [ ] Same 8 screenshots as iOS
- [ ] Files: `android-phone-01.png` through `android-phone-08.png`
- [ ] Show Android Material 3 styling
- [ ] Include Android navigation buttons

---

#### 7" Tablet (Optional)
**Dimensions**: 1200 x 1920 pixels

- [ ] 4-6 key screenshots
- [ ] Files: `android-tablet7-01.png` through `android-tablet7-06.png`

---

#### 10" Tablet (Optional)
**Dimensions**: 1920 x 1200 pixels (landscape)

- [ ] 4-6 key screenshots showing split-screen
- [ ] Files: `android-tablet10-01.png` through `android-tablet10-06.png`

---

### Screenshot Design Guidelines

**Layout Structure**:
```
┌─────────────────────┐
│                     │  ← 10% padding
│   [Device Frame]    │
│                     │
│   App Screenshot    │  ← 70% actual screenshot
│                     │
│   "Headline Text"   │  ← 15% text overlay
│                     │
│   Feature Highlight │  ← 5% subtle indicator
└─────────────────────┘
```

**Text Overlay Specifications**:
- Font: SF Pro Display (iOS) or Roboto (Android)
- Size: 48-60pt for headline
- Color: White text with 50% black shadow/gradient backdrop
- Position: Bottom third of image
- Max 2 lines, center-aligned

**Screenshot Content Rules**:
- Use realistic data (not Lorem Ipsum)
- Show populated UI (sessions, progress)
- Light mode preferred (better contrast)
- Include status bar (time: 9:41 AM)
- Hide sensitive info (if any)

---

## 🎬 Promotional Graphics

### App Preview Video (iOS - Optional)

**Specifications**:
- Duration: 15-30 seconds
- Resolution: 1920 x 1080 (1080p) minimum
- Frame rate: 30 fps
- Format: .mov or .mp4 (H.264 codec)
- Audio: Optional background music (royalty-free)
- File size: Max 500MB

**Script Outline** (30 seconds):

```
0:00-0:03  App opens → Home screen with progress ring
0:03-0:08  User selects 10-minute session → Taps "Start"
0:08-0:12  Progress ring animates → Shows "85% Calm" indicator
0:12-0:16  Quick transition → Today tab showing activity rings
0:16-0:20  Quest capsule → Shows 5-day streak + progress bar
0:20-0:24  Analytics screen → 12-week heatmap visualization
0:24-0:28  Focus Mode → Full-screen minimal overlay
0:28-0:30  End card → "Focus Field | Download Today"
```

**Visual Style**:
- Screen recording with device frame
- Smooth transitions (0.5s crossfades)
- Highlight interactions (subtle glow on taps)
- Text annotations (minimal, key features)
- Brand colors throughout

---

### Promo Video (Android - Optional)

**Specifications**:
- Duration: 30 seconds max
- Resolution: 1920 x 1080 (16:9)
- Frame rate: 30 fps
- Format: .mp4 or .avi
- File size: Max 200MB

**Same script as iOS**, optimized for Android UI

---

### Feature Graphic (Android - REQUIRED)

**Specifications**:
- Dimensions: 1024 x 500 pixels
- Format: PNG or JPEG (24-bit, no alpha)
- File size: Max 1MB
- Color space: sRGB

**Content**:
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  [App Icon]  Focus Field                           │
│              Measure Silence, Build Focus          │
│                                                     │
│              [Progress Ring Visual]                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Design Elements**:
- App icon on left (20% width)
- App name + tagline (center)
- Hero visual: Progress ring or heatmap
- Brand gradient background (teal → cyan)
- High contrast for thumbnail visibility

**File**: `feature-graphic.png`

---

## 🎨 Design Guidelines

### Brand Colors

```css
/* Primary Palette */
--teal-primary: #009688;
--cyan-accent: #00BCD4;
--teal-light: #4DB6AC;
--teal-dark: #00796B;

/* Neutral */
--white: #FFFFFF;
--background-light: #F5F5F5;
--background-dark: #121212;
--card-dark: #1E1E1E;

/* Semantic */
--success: #4CAF50;
--warning: #FF9800;
--error: #F44336;
```

---

### Typography

**Primary Font**: SF Pro Display (iOS) | Roboto (Android)

**Hierarchy**:
- Headlines: 48-60pt, Bold
- Subheads: 32-40pt, Medium
- Body: 16-18pt, Regular
- Captions: 12-14pt, Regular

---

### Iconography

**Style**: Material 3 Icons (outlined variant)
- Study: `school_outlined`
- Reading: `menu_book_outlined`
- Meditation: `self_improvement_outlined`
- Analytics: `bar_chart_outlined`
- Settings: `settings_outlined`

**Size**: 24dp minimum

---

### Spacing

**Padding**:
- Screen edges: 16dp
- Between sections: 24dp
- Between elements: 8-12dp

**Corner Radius**:
- Cards: 12dp
- Buttons: 8dp
- Bottom sheets: 20dp (top corners)
- Progress ring: Full circle

---

### Shadows & Elevation

**Material 3 Elevation**:
- Level 0: No shadow (background)
- Level 1: 1dp shadow (cards)
- Level 2: 3dp shadow (floating buttons)
- Level 3: 6dp shadow (modals)

---

## ✅ Production Checklist

### Icon Assets
- [ ] 1024x1024 App Store icon (iOS)
- [ ] All iOS icon sizes generated
- [ ] 512x512 Play Store icon (Android)
- [ ] All Android icon sizes generated
- [ ] Adaptive icon foreground/background
- [ ] Round icon variant (Android)
- [ ] Icons tested on light/dark backgrounds

---

### Screenshots
- [ ] 8 screenshots @ 6.7" (iOS, REQUIRED)
- [ ] 8 screenshots @ 5.5" (iOS, REQUIRED)
- [ ] 8 screenshots @ 1080p (Android, REQUIRED)
- [ ] Tablet screenshots (optional but recommended)
- [ ] Text overlays added
- [ ] Device frames applied
- [ ] Screenshots exported in correct formats
- [ ] Screenshot order finalized

---

### Promotional Assets
- [ ] Feature graphic 1024x500 (Android, REQUIRED)
- [ ] App preview video (iOS, optional)
- [ ] Promo video (Android, optional)
- [ ] Social media assets (optional):
  - [ ] 1200x628 Facebook/Twitter card
  - [ ] 1080x1080 Instagram post
  - [ ] 1200x675 LinkedIn share

---

### Quality Checks
- [ ] All assets meet dimension requirements
- [ ] File sizes within limits
- [ ] No pixelation or artifacts
- [ ] Colors consistent across assets
- [ ] Text legible at all sizes
- [ ] Brand guidelines followed
- [ ] Tested on various displays
- [ ] Accessibility contrast ratios pass (4.5:1)

---

### File Organization

```
assets/store/
├── icons/
│   ├── ios/
│   │   ├── AppIcon-1024.png
│   │   ├── AppIcon-180.png
│   │   └── ... (all iOS sizes)
│   └── android/
│       ├── icon-512.png
│       ├── mipmap-xxxhdpi/
│       └── ... (all Android sizes)
├── screenshots/
│   ├── ios/
│   │   ├── 6.7/
│   │   │   ├── 01-home.png
│   │   │   └── ... (8 total)
│   │   └── 5.5/
│   │       └── ... (8 total)
│   └── android/
│       ├── phone/
│       │   └── ... (8 total)
│       └── tablet/
│           └── ... (optional)
├── promotional/
│   ├── feature-graphic.png
│   ├── preview-video.mov (optional)
│   └── promo-video.mp4 (optional)
└── source-files/
    ├── icon-master.sketch
    ├── icon-master.figma
    ├── screenshot-templates.sketch
    └── README.md
```

---

## 🎬 Production Tools

### Recommended Software

**Icon Design**:
- Figma (free for personal use)
- Sketch (Mac only, paid)
- Adobe Illustrator
- Inkscape (free, open-source)

**Screenshot Creation**:
- Figma Device Mockups
- Sketch + Angle plugin
- Screenshots.pro (online tool)
- Rotato (Mac, 3D device mockups)

**Video Creation**:
- iMovie (Mac, free)
- DaVinci Resolve (free, professional)
- Adobe Premiere Pro
- Screen recording + device frame

**Batch Processing**:
- ImageMagick (command-line)
- Photoshop Actions
- Sketch exporters

---

## 📐 Asset Generation Scripts

### iOS Icon Generator (ImageMagick)

```bash
#!/bin/bash
# Generate iOS icons from 1024x1024 master

MASTER="icon-1024.png"

convert $MASTER -resize 180x180 AppIcon-60@3x.png
convert $MASTER -resize 120x120 AppIcon-60@2x.png
convert $MASTER -resize 167x167 AppIcon-83.5@2x.png
convert $MASTER -resize 152x152 AppIcon-76@2x.png
convert $MASTER -resize 76x76 AppIcon-76.png
convert $MASTER -resize 60x60 AppIcon-Spotlight-60@3x.png
convert $MASTER -resize 40x40 AppIcon-Spotlight-40@2x.png

echo "✅ iOS icons generated"
```

---

### Android Icon Generator

```bash
#!/bin/bash
# Generate Android icons from 512x512 master

MASTER="icon-512.png"

mkdir -p mipmap-xxxhdpi mipmap-xxhdpi mipmap-xhdpi mipmap-hdpi mipmap-mdpi

convert $MASTER -resize 192x192 mipmap-xxxhdpi/ic_launcher.png
convert $MASTER -resize 144x144 mipmap-xxhdpi/ic_launcher.png
convert $MASTER -resize 96x96 mipmap-xhdpi/ic_launcher.png
convert $MASTER -resize 72x72 mipmap-hdpi/ic_launcher.png
convert $MASTER -resize 48x48 mipmap-mdpi/ic_launcher.png

echo "✅ Android icons generated"
```

---

**Next Steps**:
1. Design app icon (Priority 1)
2. Create screenshot templates
3. Capture app screenshots
4. Add text overlays
5. Export in required formats

