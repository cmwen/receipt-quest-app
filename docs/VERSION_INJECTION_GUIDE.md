# Version Injection Guide

This guide explains how version numbers are automatically injected into builds from git tags.

## Overview

The project now supports automatic version injection during builds, eliminating the need to manually update `pubspec.yaml` for every release. The version comes from git tags during CI/CD builds, and from either git tags or `pubspec.yaml` for local development.

## How It Works

### CI/CD Builds

**Release Workflow** (`release.yml`):
- Triggered by pushing a version tag (e.g., `v1.0.6`, `v1.0.7+12`)
- Automatically extracts version from the tag name
- Passes version to Flutter build commands via `--build-name` and `--build-number`

**Pre-Release Workflow** (`pre-release.yml`):
- Manually triggered with a version input
- Supports alpha, beta, and pre-release types
- Extracts version from user input and passes to build commands

### Version Format

Tags support two formats:

1. **Simple version**: `v1.0.0`
   - Version name: `1.0.0`
   - Build number: Auto-calculated as `1000000` (major * 1000000 + minor * 1000 + patch)

2. **Version with build number**: `v1.0.0+15`
   - Version name: `1.0.0`
   - Build number: `15`

### Build Number Calculation

When no explicit build number is provided in the tag, it's calculated as:
```
build_number = (major * 1000000) + (minor * 1000) + patch
```

Examples:
- `v1.0.0` → build number `1000000`
- `v1.2.3` → build number `1002003`
- `v2.0.0` → build number `2000000`
- `v1.0.0+15` → build number `15` (explicit)

This ensures build numbers always increase with version numbers.

## Local Development

### Using the Build Script

A convenient script is provided for local builds with automatic version injection:

```bash
# Build APK with version from git tag
./scripts/build-with-version.sh

# Build app bundle
./scripts/build-with-version.sh appbundle

# Build debug APK
./scripts/build-with-version.sh apk debug

# Build all platforms
./scripts/build-with-version.sh all release
```

**Script Features:**
- Automatically extracts version from latest git tag
- Falls back to `pubspec.yaml` if no tag exists
- Supports all Flutter platforms (apk, appbundle, ios, web)
- Supports all build types (debug, release, profile)
- Shows build output locations and file sizes
- Color-coded output for easy reading

### Manual Build Commands

You can also build manually with explicit version:

```bash
# From git tag
VERSION=$(git describe --tags --abbrev=0 | sed 's/^v//')
flutter build apk --release --build-name="1.0.6" --build-number="1000006"

# Custom version
flutter build apk --release --build-name="1.2.3" --build-number="1002003"
```

## Creating Releases

### 1. Standard Release

```bash
# Ensure code is committed
git add .
git commit -m "Release v1.0.7"

# Create and push tag
git tag v1.0.7
git push origin v1.0.7

# GitHub Actions will automatically:
# - Build APK, AAB, and Web with version 1.0.7 (build: 1000007)
# - Run tests
# - Create GitHub Release with artifacts
```

### 2. Release with Custom Build Number

```bash
# Use this when you need a specific build number (e.g., for hotfixes)
git tag v1.0.6+20
git push origin v1.0.6+20

# Builds with version 1.0.6, build number 20
```

### 3. Pre-Release (Beta/Alpha)

Use the manual workflow in GitHub Actions:
1. Go to Actions → "Create Pre-Release"
2. Click "Run workflow"
3. Enter version (e.g., `1.1.0-beta+5`) and select release type
4. GitHub will build and create a pre-release

## Verifying Version in Built APK

After building, you can verify the version:

```bash
# Extract version from APK
aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep version

# Output example:
# versionCode='1000006' versionName='1.0.6'
```

Or install and check in Android settings:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
# Go to Settings → Apps → Receipt Quest → Version
```

## Benefits

1. **No Manual Updates**: No need to update `pubspec.yaml` version before each release
2. **Version Control**: Version is tracked in git tags, not in code
3. **Consistency**: Same version across APK, AAB, and Web builds
4. **Automation**: CI/CD automatically uses correct version
5. **Traceability**: Easy to link builds to git tags/commits

## Workflow Files Updated

The following workflows now support version injection:

- `.github/workflows/release.yml` - Production releases from tags
- `.github/workflows/pre-release.yml` - Beta/alpha releases
- `scripts/build-with-version.sh` - Local development builds

## Migration Notes

### For Existing Projects

If migrating from manual version management:

1. **Keep `pubspec.yaml` version** - It serves as the default/fallback
2. **Use git tags for releases** - Create tags before pushing releases
3. **Update CI/CD** - The workflows are already updated in this template
4. **Test locally** - Use `./scripts/build-with-version.sh` to verify

### Version Bumping Strategy

Recommended approach:
1. Work on features without updating `pubspec.yaml`
2. When ready to release, create a git tag with the new version
3. Push the tag to trigger CI/CD
4. Optionally update `pubspec.yaml` to match (for local development reference)

## Troubleshooting

### "No git tag found" when building locally

**Solution**: Either create a tag or rely on `pubspec.yaml`:
```bash
# Create a tag
git tag v1.0.0

# Or just use the script (it falls back to pubspec.yaml)
./scripts/build-with-version.sh
```

### Build number conflict on Google Play

**Solution**: Use explicit build numbers:
```bash
git tag v1.0.6+21
git push origin v1.0.6+21
```

### Version mismatch between APK and AAB

**Cause**: Building separately with different commands

**Solution**: Always build all release artifacts together:
```bash
./scripts/build-with-version.sh all release
```

## Example Workflow

```bash
# 1. Develop feature
git checkout -b feature/new-feature
# ... make changes ...
git commit -m "Add new feature"

# 2. Merge to main
git checkout main
git merge feature/new-feature

# 3. Create release tag
git tag v1.1.0
git push origin main
git push origin v1.1.0

# 4. GitHub Actions automatically:
#    - Builds with version 1.1.0 (build: 1001000)
#    - Runs tests
#    - Creates GitHub Release
#    - Uploads APK, AAB, and Web artifacts

# 5. Download artifacts from GitHub Release page
```

## Related Documentation

- [GETTING_STARTED.md](GETTING_STARTED.md) - Initial setup
- [BUILD_OPTIMIZATION.md](BUILD_OPTIMIZATION.md) - Build performance
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contributing guidelines
