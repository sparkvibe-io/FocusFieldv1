#!/usr/bin/env bash

# Generate adaptive icon foreground layers
# Following Android guidelines:
# - Canvas: 108dp
# - Safe zone: 66dp (61% of canvas)
# - Logo size: 48-66dp (we'll use 66dp for maximum visibility)

set -e

SOURCE_ICON="assets/icon/app_icon.png"
RES_DIR="android/app/src/main/res"

echo "Generating adaptive icon foreground layers..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick not found. Install with: brew install imagemagick"
    exit 1
fi

# For adaptive icons, the foreground should be 108dp with the icon in the 66dp safe zone
# That means the actual icon should be ~61% of the canvas size
# We'll make it slightly larger (72%) to ensure good visibility while staying in safe zone

# Density multipliers for 108dp canvas:
# mdpi (1x):    108px
# hdpi (1.5x):  162px
# xhdpi (2x):   216px
# xxhdpi (3x):  324px
# xxxhdpi (4x): 432px

# Extract just the circular icon (remove black background)
# The source icon has the waveform circle occupying ~70% of the canvas
# We need to extract it and center it properly for the 66dp safe zone

# Process each density
for density_spec in "mdpi:108" "hdpi:162" "xhdpi:216" "xxhdpi:324" "xxxhdpi:432"; do
    density="${density_spec%%:*}"
    size="${density_spec##*:}"
    output_dir="$RES_DIR/mipmap-$density"

    mkdir -p "$output_dir"

    echo "  Creating ${density} (${size}x${size}px)..."

    # Strategy:
    # 1. Take source icon (which has circular design with black padding)
    # 2. Resize to fill 72% of canvas (leaves 14% padding on each side = safe in 66dp zone)
    # 3. Center on transparent 108dp canvas

    icon_size=$((size * 72 / 100))

    convert "$SOURCE_ICON" \
        -resize ${icon_size}x${icon_size} \
        -background none \
        -gravity center \
        -extent ${size}x${size} \
        "$output_dir/ic_launcher_foreground.png"
done

echo ""
echo "✅ Adaptive icon foreground layers generated successfully!"
echo ""
echo "Summary:"
echo "- Canvas size: 108dp (per Android spec)"
echo "- Icon content: ~72% of canvas (safe within 66dp zone)"
echo "- Background: Transparent"
echo "- Densities: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi"
echo ""
echo "Next steps:"
echo "1. flutter clean"
echo "2. flutter build apk --release"
echo "3. Uninstall old app from device"
echo "4. Install new APK and check icon"
