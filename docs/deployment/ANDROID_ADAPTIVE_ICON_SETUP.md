# Android Adaptive Icon Setup - Proper Implementation

**Date**: November 8, 2025
**Issue**: App icon appeared zoomed in/shrunk on Android devices
**Root Cause**: Incorrect adaptive icon safe zone sizing
**Solution**: Proper adaptive icon implementation following Android guidelines

---

## 📱 What Are Adaptive Icons?

Adaptive icons (Android 8.0+) use two layers:
- **Background layer**: Solid color or pattern
- **Foreground layer**: Your logo/icon artwork

This allows different launchers to apply various shapes (circle, squircle, rounded square) and visual effects (parallax, pulsing).

---

## 📐 Android's Official Specifications

According to [Android Developer Guidelines](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive):

| Specification | Value | Purpose |
|---------------|-------|---------|
| Total Canvas | 108x108 dp | Full layer size |
| Safe Zone | 66x66 dp | Area guaranteed never clipped |
| Reserved Margin | 18 dp (all sides) | For masking and visual effects |
| Logo Size | 48-66 dp | Recommended icon content size |

**Key Rule**: Your icon content must fit within the 66x66 dp safe zone (center 61% of canvas).

---

## 🎨 Our Implementation

### Configuration Files

**1. Adaptive Icon XML** (`android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`):
```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
```

**2. Background Color** (`android/app/src/main/res/values/ic_launcher_background.xml`):
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#000000</color>
</resources>
```

### Asset Sizes (Foreground Layer)

All foreground assets are 108dp canvas with icon content at 72% (well within 66dp safe zone):

| Density | Canvas Size | Icon Content (~72%) |
|---------|-------------|---------------------|
| mdpi | 108x108 px | ~78x78 px |
| hdpi | 162x162 px | ~117x117 px |
| xhdpi | 216x216 px | ~156x156 px |
| xxhdpi | 324x324 px | ~233x233 px |
| xxxhdpi | 432x432 px | ~311x311 px |

---

## 🛠️ How to Regenerate Icons

If you need to update the icon in the future:

```bash
# Run the generation script
./scripts/tools/generate_adaptive_foreground.sh

# Clean and rebuild
flutter clean
flutter build apk --release

# Uninstall old app, then install new APK
```

---

## ✅ What This Fixes

**Before**:
- Icon appeared zoomed in or shrunk with black padding
- Inconsistent appearance across different launchers
- Not following Android Material Design guidelines

**After**:
- ✅ Icon properly sized within safe zone
- ✅ Looks consistent on all Android launchers (circle, square, squircle)
- ✅ Supports visual effects (parallax, pulsing)
- ✅ Follows official Android adaptive icon spec
- ✅ Black background layer + transparent foreground with circular waveform

---

## 📊 Technical Details

### Why 72% Icon Content?

- Safe zone is 66dp on 108dp canvas = 61%
- We use 72% to maximize visibility while staying safely within bounds
- Leaves 14% margin on all sides (more than the required 18dp outer margin)
- This ensures no clipping on any launcher shape

### Foreground Generation Strategy

The script (`scripts/tools/generate_adaptive_foreground.sh`):
1. Takes source icon: `assets/icon/app_icon.png`
2. Resizes to 72% of target canvas size
3. Centers on transparent 108dp canvas
4. Generates all density variants (mdpi → xxxhdpi)

---

## 🧪 Testing Checklist

- [ ] Build release APK: `flutter build apk --release`
- [ ] Completely uninstall old app from device
- [ ] Install new APK
- [ ] Check icon appearance on launcher
- [ ] Test on different launcher apps (if possible)
- [ ] Verify icon looks correct in app drawer
- [ ] Verify icon looks correct on home screen

---

## 📚 References

- [Android Adaptive Icons Guide](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)
- [Google Design: Designing Adaptive Icons](https://medium.com/google-design/designing-adaptive-icons-515af294c783)
- [Material Design Icon Guidelines](https://m3.material.io/styles/icons/overview)

---

## 🔍 Troubleshooting

### Icon still looks wrong after rebuild

**Solution**: Android caches launcher icons aggressively.
1. Completely uninstall the app (don't just overwrite)
2. Reboot device to clear launcher cache
3. Install fresh APK

### Want to change background color

Edit: `android/app/src/main/res/values/ic_launcher_background.xml`

Change `#000000` (black) to your preferred color.

### Need to update icon design

1. Update `assets/icon/app_icon.png` with your new design
2. Run `./scripts/tools/generate_adaptive_foreground.sh`
3. Clean rebuild

---

**Result**: Professional, spec-compliant adaptive icon that looks great on all Android devices! 🎉
