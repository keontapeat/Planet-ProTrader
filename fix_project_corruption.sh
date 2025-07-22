#!/bin/bash

echo "🚀 PLANET PROTRADER PROJECT CORRUPTION FIXER"
echo "============================================="

PROJECT_PATH="/Users/keonta/Documents/Planet ProTrader"
PROJECT_NAME="Planet ProTrader"

cd "$PROJECT_PATH"

echo "📍 Working in: $(pwd)"

# 1. Close Xcode completely
echo "🛑 Closing Xcode..."
pkill -f Xcode 2>/dev/null || true
sleep 2

# 2. Clean Derived Data
echo "🧹 Cleaning Derived Data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
echo "✅ Derived Data cleaned"

# 3. Clean Xcode caches
echo "🧹 Cleaning Xcode Caches..."
rm -rf ~/Library/Caches/com.apple.dt.Xcode*
echo "✅ Xcode caches cleaned"

# 4. Remove package resolved files and caches
echo "🧹 Cleaning Package Dependencies..."
find . -name "Package.resolved" -delete 2>/dev/null || true
find . -name "*.xcworkspace" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "xcuserdata" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✅ Package dependencies cleaned"

# 5. Clean project user data
echo "🧹 Cleaning Project User Data..."
rm -rf "$PROJECT_NAME.xcodeproj/xcuserdata" 2>/dev/null || true
rm -rf "$PROJECT_NAME.xcodeproj/project.xcworkspace/xcuserdata" 2>/dev/null || true
echo "✅ Project user data cleaned"

# 6. Reset SPM cache
echo "🧹 Resetting SPM Cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm* 2>/dev/null || true
rm -rf ~/Library/org.swift.swiftpm* 2>/dev/null || true
echo "✅ SPM cache reset"

# 7. Create a backup and validate project.pbxproj
echo "💾 Creating backup of project.pbxproj..."
cp "$PROJECT_NAME.xcodeproj/project.pbxproj" "$PROJECT_NAME.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d_%H%M%S)"

echo "✅ Backup created"

# 8. Validate and fix project file syntax
echo "🔍 Validating project file..."
plutil -lint "$PROJECT_NAME.xcodeproj/project.pbxproj" 2>/dev/null && echo "✅ Project file syntax is valid" || echo "⚠️  Project file has syntax issues"

echo ""
echo "🎉 PROJECT CLEANUP COMPLETE!"
echo "============================================="
echo "Now try opening your project in Xcode:"
echo "1. Open Terminal"
echo "2. Run: open '$PROJECT_PATH/$PROJECT_NAME.xcodeproj'"
echo "3. Let Xcode resolve packages automatically"
echo ""
echo "If the issue persists, run the advanced fix script."