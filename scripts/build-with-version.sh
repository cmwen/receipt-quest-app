#!/bin/bash
# Build script that automatically extracts version from git tags
# Usage: ./scripts/build-with-version.sh [platform] [build-type]
#   platform: apk (default), appbundle, ios, web, all
#   build-type: debug, release (default), profile

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PLATFORM="${1:-apk}"
BUILD_TYPE="${2:-release}"

# Get version from git tag
GIT_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$GIT_TAG" ]; then
    echo -e "${YELLOW}⚠ No git tag found. Using version from pubspec.yaml${NC}"
    # Extract from pubspec.yaml
    VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
else
    echo -e "${GREEN}✓ Found git tag: $GIT_TAG${NC}"
    VERSION="${GIT_TAG#v}"
fi

# Extract version name and build number
VERSION_NAME=$(echo "$VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$VERSION" | cut -d'+' -f2)

# If no build number in version, calculate from version
if [ "$VERSION_NAME" = "$BUILD_NUMBER" ]; then
    IFS='.' read -r major minor patch <<< "$VERSION_NAME"
    # Remove any non-numeric characters from patch (e.g., 1.0.0-beta -> 1.0.0)
    patch=$(echo "$patch" | sed 's/[^0-9].*//g' || echo "0")
    BUILD_NUMBER=$((major * 1000000 + minor * 1000 + ${patch:-0}))
fi

echo -e "${GREEN}Building with version: $VERSION_NAME (build: $BUILD_NUMBER)${NC}"
echo ""

# Build function
build_platform() {
    local platform=$1
    local type=$2
    
    echo -e "${YELLOW}Building $platform ($type)...${NC}"
    
    case $platform in
        apk)
            flutter build apk --$type \
                --build-name="$VERSION_NAME" \
                --build-number="$BUILD_NUMBER"
            ;;
        appbundle)
            flutter build appbundle --$type \
                --build-name="$VERSION_NAME" \
                --build-number="$BUILD_NUMBER"
            ;;
        ios)
            flutter build ios --$type \
                --build-name="$VERSION_NAME" \
                --build-number="$BUILD_NUMBER"
            ;;
        web)
            flutter build web --$type \
                --build-name="$VERSION_NAME" \
                --build-number="$BUILD_NUMBER"
            ;;
        *)
            echo -e "${RED}Unknown platform: $platform${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ $platform build completed${NC}"
    echo ""
}

# Build requested platform(s)
if [ "$PLATFORM" = "all" ]; then
    build_platform "apk" "$BUILD_TYPE"
    build_platform "appbundle" "$BUILD_TYPE"
    build_platform "web" "$BUILD_TYPE"
else
    build_platform "$PLATFORM" "$BUILD_TYPE"
fi

# Show build output location
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "Version: $VERSION_NAME (build: $BUILD_NUMBER)"
echo ""

case $PLATFORM in
    apk|all)
        if [ -f "build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk" ]; then
            SIZE=$(du -h "build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk" | cut -f1)
            echo "APK: build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk ($SIZE)"
        fi
        ;;
esac

case $PLATFORM in
    appbundle|all)
        if [ -f "build/app/outputs/bundle/${BUILD_TYPE}/app-${BUILD_TYPE}.aab" ]; then
            SIZE=$(du -h "build/app/outputs/bundle/${BUILD_TYPE}/app-${BUILD_TYPE}.aab" | cut -f1)
            echo "AAB: build/app/outputs/bundle/${BUILD_TYPE}/app-${BUILD_TYPE}.aab ($SIZE)"
        fi
        ;;
esac

case $PLATFORM in
    web|all)
        if [ -d "build/web" ]; then
            SIZE=$(du -sh "build/web" | cut -f1)
            echo "Web: build/web/ ($SIZE)"
        fi
        ;;
esac

echo ""
echo -e "${YELLOW}To install on device: adb install build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk${NC}"
echo -e "${YELLOW}To run on device: flutter run --$BUILD_TYPE${NC}"
