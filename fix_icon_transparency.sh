#!/bin/bash
#
# Fix Android Icon Transparency Issue
#
# This script converts your icon from RGBA (with transparency) to RGB (solid background)
# to prevent Android from adding white padding around the icon.
#

echo "🔧 Focus Field - Icon Transparency Fix"
echo "======================================"
echo ""

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not installed"
    echo ""
    echo "Please install ImageMagick:"
    echo "  brew install imagemagick"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "✅ ImageMagick found"
echo ""

# Backup original icon
echo "📦 Creating backup..."
cp assets/icon/app_icon.png assets/icon/app_icon_backup.png
echo "✅ Backup saved to: assets/icon/app_icon_backup.png"
echo ""

# Convert icon: flatten transparency with black background
echo "🎨 Converting icon (flattening transparency with black background)..."
convert assets/icon/app_icon.png -background black -alpha remove -alpha off assets/icon/app_icon_temp.png

# Replace original
mv assets/icon/app_icon_temp.png assets/icon/app_icon.png

echo "✅ Icon converted successfully"
echo ""

# Check result
file assets/icon/app_icon.png

echo ""
echo "📋 Next steps:"
echo "  1. Run: dart run flutter_launcher_icons"
echo "  2. Run: flutter clean"
echo "  3. Uninstall app from device"
echo "  4. Run: flutter run --release"
echo ""
echo "If icon still has issues, restore backup:"
echo "  cp assets/icon/app_icon_backup.png assets/icon/app_icon.png"
echo ""
