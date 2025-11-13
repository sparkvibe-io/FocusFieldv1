#!/bin/bash
#
# Generate Android App Icons
#
# This script sets up and runs flutter_launcher_icons to generate
# Android launcher icons from a single source image.
#
# Prerequisites:
# 1. Your app icon at: assets/icon/app_icon.png (1024x1024)
# 2. (Optional) Foreground layer at: assets/icon/app_icon_foreground.png
#
# Usage:
#   ./scripts/tools/generate-android-icons.sh

set -e

echo "📱 Focus Field - Android Icon Generator"
echo "========================================"
echo ""

# Check if source icon exists
if [ ! -f "assets/icon/app_icon.png" ]; then
    echo "❌ Error: Source icon not found!"
    echo ""
    echo "Please create: assets/icon/app_icon.png (1024x1024 px)"
    echo ""
    echo "You can:"
    echo "  1. Create the folder: mkdir -p assets/icon"
    echo "  2. Copy your icon: cp /path/to/your/icon.png assets/icon/app_icon.png"
    echo "  3. Or use the iOS icon: cp ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon1024.png assets/icon/app_icon.png"
    echo ""
    exit 1
fi

echo "✅ Found source icon: assets/icon/app_icon.png"

# Check icon dimensions
if command -v file &> /dev/null; then
    dimensions=$(file assets/icon/app_icon.png | grep -o '[0-9]* x [0-9]*' | head -1)
    echo "   Dimensions: $dimensions"
fi

# Check if flutter_launcher_icons is in pubspec.yaml
if grep -q "flutter_launcher_icons" pubspec.yaml; then
    echo "✅ flutter_launcher_icons already in pubspec.yaml"
else
    echo "⚠️  Adding flutter_launcher_icons to pubspec.yaml..."

    # Add to dev_dependencies if not present
    if ! grep -q "dev_dependencies:" pubspec.yaml; then
        echo "" >> pubspec.yaml
        echo "dev_dependencies:" >> pubspec.yaml
    fi

    # Add the package
    sed -i '' '/dev_dependencies:/a\
  flutter_launcher_icons: ^0.13.1
' pubspec.yaml

    echo "✅ Added flutter_launcher_icons to dev_dependencies"
fi

# Check if configuration exists
if grep -q "flutter_launcher_icons:" pubspec.yaml; then
    echo "✅ flutter_launcher_icons configuration found"
else
    echo "⚠️  Adding flutter_launcher_icons configuration..."

    cat >> pubspec.yaml << 'EOF'

# App Icon Configuration
flutter_launcher_icons:
  android: true
  ios: false  # iOS icons managed in Xcode
  image_path: "assets/icon/app_icon.png"

  # Adaptive icon for Android 8.0+ (removes white background on some launchers)
  adaptive_icon_background: "#FFFFFF"  # Change to match your icon background
  # If you have a separate foreground layer, uncomment:
  # adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"

  remove_alpha_ios: false  # Keep iOS unchanged
EOF

    echo "✅ Added flutter_launcher_icons configuration"
fi

echo ""
echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "🎨 Generating Android icons..."
flutter pub run flutter_launcher_icons

echo ""
echo "✅ Android icons generated successfully!"
echo ""
echo "📋 Next steps:"
echo "  1. Rebuild the app:"
echo "     flutter clean"
echo "     flutter build appbundle --release"
echo ""
echo "  2. Test on a device:"
echo "     flutter install --release"
echo ""
echo "  3. Verify the icon matches your Play Store listing"
echo ""
echo "  4. Upload new APK/AAB to Google Play Console"
echo ""
echo "📄 For detailed instructions, see:"
echo "   docs/deployment/ANDROID_APP_ICON_FIX.md"
echo ""
