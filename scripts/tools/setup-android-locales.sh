#!/bin/bash
# Setup Android localization folders and strings.xml for all supported languages

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Android localization...${NC}"

# Navigate to Android res directory
cd "$(dirname "$0")/../../android/app/src/main/res" || exit 1

# Create base strings.xml if missing
if [ ! -f "values/strings.xml" ]; then
    mkdir -p values
    cat > "values/strings.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
</resources>
EOF
    echo -e "${GREEN}✓${NC} Created values/strings.xml"
else
    echo -e "${BLUE}•${NC} values/strings.xml already exists"
fi

# Define locales and their folders
declare -A locales=(
    ["es"]="Spanish"
    ["fr"]="French"
    ["de"]="German"
    ["pt-rBR"]="Portuguese (Brazil)"
    ["ja"]="Japanese"
    ["zh"]="Chinese (Simplified)"
)

# Create locale-specific folders and strings.xml
for locale in "${!locales[@]}"; do
    folder="values-$locale"
    mkdir -p "$folder"

    cat > "$folder/strings.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Focus Field</string>
</resources>
EOF

    echo -e "${GREEN}✓${NC} Created $folder/strings.xml (${locales[$locale]})"
done

echo ""
echo -e "${GREEN}✅ Android localization setup complete!${NC}"
echo ""
echo "Created resource folders for:"
echo "  • English (default: values/)"
echo "  • Spanish (values-es/)"
echo "  • French (values-fr/)"
echo "  • German (values-de/)"
echo "  • Portuguese - Brazil (values-pt-rBR/)"
echo "  • Japanese (values-ja/)"
echo "  • Chinese Simplified (values-zh/)"
echo ""
echo "Next steps:"
echo "1. (Optional) Localize app_name in each strings.xml"
echo "2. (Optional) Add resConfigs to android/app/build.gradle"
echo "3. Commit changes: git add android/app/src/main/res/values*/strings.xml"
