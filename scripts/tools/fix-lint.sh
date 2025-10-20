#!/bin/bash
# Focus Field - Lint Issues Quick Fix Script
# Run this script to automatically fix most remaining lint issues

echo "🔧 Focus Field Lint Issues Quick Fix"
echo "===================================="

# Check current status
echo "📊 Current status:"
flutter analyze --no-preamble 2>&1 | grep "issues found"

echo ""
echo "🚀 Applying automatic fixes..."

# Step 1: Fix package imports (critical)
echo "Step 1: Fixing package imports..."
find lib/ test/ -name "*.dart" -exec sed -i '' 's/package:silence_score\//package:focus_field\//g' {} \;
echo "✅ Package imports updated"

# Step 2: Comment out print statements
echo "Step 2: Commenting out print statements..."
find lib/ test/ -name "*.dart" -exec sed -i '' 's/^[[:space:]]*print(/\/\/ print(/g' {} \;
echo "✅ Print statements commented out"

# Step 3: Clean and rebuild
echo "Step 3: Cleaning and rebuilding..."
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
echo "✅ Project cleaned and rebuilt"

# Step 4: Apply dart fixes
echo "Step 4: Applying automatic dart fixes..."
dart fix --apply > /dev/null 2>&1
echo "✅ Dart fixes applied"

echo ""
echo "🎯 Final status:"
flutter analyze --no-preamble 2>&1 | grep "issues found"

echo ""
echo "📝 Remaining issues (if any) require manual review:"
echo "   - BuildContext async gaps (add mounted checks)"
echo "   - Any remaining undefined identifiers"
echo "   - Unused variables in tests"

echo ""
echo "📖 For detailed breakdown, see:"
echo "   - docs/LINT_ISSUES_STATUS.md"
echo "   - docs/DETAILED_LINT_BREAKDOWN.md"

echo ""
echo "✨ Quick fix script completed!"