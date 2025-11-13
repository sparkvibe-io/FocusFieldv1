# Android Icon Issue: Transparent Corners

## The Problem

Your app icon (`assets/icon/app_icon.png`) is a **circle with transparent corners**:
- The gradient circle with gold ring fills most of the space
- The four corners outside the circle are **transparent**
- When displayed on Android launchers with white backgrounds, these transparent corners show as **white padding**

## Why This Happens

1. Your icon: `[transparent corner] [gradient circle] [transparent corner]`
2. Android launcher (white background): Shows through transparent areas
3. Result: Circle looks smaller with white padding around it

## Your Options

### Option 1: Create a Square Icon (RECOMMENDED)
Make the icon fill the entire 1024x1024 space with no transparent areas.

**Three approaches:**
1. **Extend the gradient to corners** - Make the gradient fill the entire square
2. **Add black background** - Put your circle on a solid black square background
3. **Add pattern background** - Use a subtle pattern in the corners

### Option 2: Accept Transparent Corners
Keep the current design and accept that:
- Some launchers will show white/colored backgrounds through corners
- Icon will look different on different launchers
- This is how Instagram, Spotify work (they have square backgrounds in their icons)

### Option 3: Proper Adaptive Icons (Complex)
Create separate foreground and background layers:
- **Foreground**: Just the waveform and gold ring (transparent background)
- **Background**: The gradient fill
- Android will composite them and mask to different shapes

## Quick Test

To see if this is the issue, temporarily add a black square background to your icon:
1. Open `assets/icon/app_icon.png` in an image editor
2. Add a black layer behind the circle
3. Save and regenerate icons
4. Test on device

If the "white padding" becomes "black background filling the space", then transparent corners are definitely the issue.

## Recommendation

**Best solution**: Update your icon design to fill the entire square space.
- Either extend the gradient to corners
- Or add a solid color background (black matches your aesthetic)
- This ensures consistent appearance across all Android launchers
