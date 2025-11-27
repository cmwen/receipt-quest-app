# Receipt Quest App Icon Guide

## Icon Concept

The Receipt Quest app icon should represent:
- Receipt/document tracking
- Tax savings/financial benefit
- Gamification/achievement

## Recommended Design

### Primary Concept: Receipt with Checkmark/Star
- **Base**: A simplified receipt or document shape
- **Color**: Green (#4CAF50) to represent money/savings
- **Accent**: Gold star or checkmark to represent achievement/completion
- **Style**: Flat design with slight gradient for depth

### Alternative Concepts:
1. **Receipt + Coin/Dollar**: Receipt with a coin or dollar symbol overlay
2. **Quest Trophy**: Trophy shape made from receipt paper
3. **Receipt Scanner**: Stylized camera with receipt icon

## Icon Specifications

### For AI Image Generation:
```
Create an app icon for a receipt tracking application called "Receipt Quest"

Design specifications:
- 1024x1024 pixels
- Flat design style with subtle gradient
- Primary color: Green (#4CAF50)
- Accent color: Gold/Yellow (#FFC107)
- Icon concept: A simplified receipt document with a gold star or checkmark badge
- Background: Solid green or gradient from light to darker green
- Style: Modern, clean, friendly
- No text in the icon

The icon should convey:
- Financial tracking/savings
- Achievement/gamification
- Professional yet approachable
```

## Using flutter_launcher_icons Package

To generate platform-specific icons from a 1024x1024 PNG:

1. Add the package to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1
```

2. Configure icon generation in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#4CAF50"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

3. Place your 1024x1024 icon at:
   - `assets/icon/app_icon.png`
   - `assets/icon/app_icon_foreground.png` (for Android adaptive icon)

4. Run the generator:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Manual Icon Placement

If not using the generator package, place icons at:

### Android:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

### iOS:
Update icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Color Palette

- **Primary Green**: #4CAF50 (Material Green 500)
- **Dark Green**: #388E3C (Material Green 700)
- **Light Green**: #81C784 (Material Green 300)
- **Accent Gold**: #FFC107 (Material Amber 500)
- **White/Background**: #FFFFFF

## Testing the Icon

After generating icons:
1. Clean build: `flutter clean`
2. Rebuild: `flutter build apk` or `flutter build ios`
3. Install on device/emulator to verify icon appearance
4. Check different home screen backgrounds (light/dark)

## AI Image Generation Prompts

### Prompt 1: Modern Flat Design
```
Create a mobile app icon, 1024x1024px, flat design style. 
Show a stylized receipt document in white/light colors on a gradient green background (#81C784 to #388E3C).
Add a gold star badge (#FFC107) in the top-right corner.
Clean, minimal, modern design with rounded corners.
```

### Prompt 2: 3D-ish Design
```
Create a mobile app icon, 1024x1024px, slightly 3D style.
Feature a receipt with subtle shadow and depth on solid green background (#4CAF50).
Include a gold checkmark or trophy icon overlaying the receipt.
Professional, polished, app store ready.
```

### Prompt 3: Playful Design
```
Create a mobile app icon, 1024x1024px, friendly and playful style.
Design a smiling receipt character with a gold star or badge.
Use green (#4CAF50) as primary color with gold (#FFC107) accents.
Fun, approachable, gamified aesthetic.
```
