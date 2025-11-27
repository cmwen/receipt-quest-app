# Receipt Quest 🎯

A gamified, privacy-first mobile app that transforms tax deduction tracking from a chore into an engaging habit by providing **immediate visual feedback** on potential tax savings for each scanned receipt.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.10.1+-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-lightgrey)

## 🌟 Features

### MVP (Current Implementation)

- ✅ **User Profile Setup**: Configure income bracket and filing status for personalized tax estimates
- ✅ **Receipt Scanning**: Capture receipts via camera or photo gallery
- ✅ **On-Device OCR**: Extract vendor name and amount using Google ML Kit (privacy-first)
- ✅ **Immediate Tax Savings**: See potential tax savings instantly after scanning
- ✅ **Local-First Storage**: All data stored securely on your device using SQLite
- ✅ **Dashboard**: Track total potential savings and recent receipts
- ✅ **Gamified Rewards**: Celebration screen with animated feedback after each scan
- ✅ **Educational Tips**: Learn about tax deductions contextually

### Coming Soon (Post-MVP)

- 🚧 Expense categorization (business meals, equipment, etc.)
- 🚧 Advanced gamification (achievements, streaks, milestones)
- 🚧 Data export for tax time (CSV/PDF reports)
- 🚧 Cloud sync (optional, user-controlled)
- 🚧 Multi-year tracking

## 📱 Screenshots

_Screenshots coming soon_

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.1+
- Dart 3.10.1+
- Java 17+ (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/receipt-quest-app.git
   cd receipt-quest-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   ```

### Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🏗️ Architecture

### Tech Stack

- **Framework**: Flutter 3.10.1+
- **Language**: Dart 3.10.1+
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)
- **Secure Storage**: flutter_secure_storage
- **OCR**: Google ML Kit Text Recognition
- **Image Handling**: image_picker, path_provider

### Project Structure

```
lib/
├── core/
│   ├── database/          # SQLite database helper
│   ├── models/            # Data models (Receipt, UserProfile)
│   ├── providers/         # State management (ReceiptProvider)
│   └── utils/             # OCR service, storage service
├── features/
│   ├── onboarding/        # User profile setup
│   ├── dashboard/         # Main dashboard screen
│   ├── scanner/           # Receipt scanning & confirmation
│   └── receipt_detail/    # Receipt detail view
├── shared/                # Shared widgets
└── main.dart              # App entry point
```

### Data Flow

```
User → Camera/Gallery → OCR Service → Confirmation Screen
                                              ↓
                                    ReceiptProvider
                                              ↓
                                    SQLite Database
                                              ↓
                                    Dashboard (UI Update)
```

## 📊 Key Features Explained

### Privacy-First Architecture

All data processing happens on-device:
- OCR uses Google ML Kit (runs locally, no cloud calls)
- Data stored in local SQLite database
- User profile in secure local storage
- No data transmission to external servers

### Tax Savings Calculation

Conservative estimates based on:
- User's income bracket (12%, 22%, or 24% tax rate)
- Total expense amount
- Formula: `Potential Savings = Amount × Tax Rate`

**Disclaimer**: These are estimates only, not professional tax advice.

### Gamification Strategy

Designed to encourage habit formation:
1. **Immediate Reward**: Animated celebration screen after each scan
2. **Progress Tracking**: Visual dashboard showing cumulative savings
3. **Educational Content**: Contextual tips about tax deductions
4. **Achievement System**: (Coming soon) Milestones and streaks

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 🎨 Customization

### App Icon

See [docs/APP_ICON_GUIDE.md](docs/APP_ICON_GUIDE.md) for detailed instructions on:
- Icon design concepts
- AI image generation prompts
- Using flutter_launcher_icons package
- Platform-specific icon requirements

### Theme Colors

Primary theme color is Material Green (#4CAF50). To customize:

```dart
// lib/main.dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Change here
  useMaterial3: true,
),
```

## 📚 Documentation

- [Vision Document](docs/vision.md) - Problem statement and project goals
- [Design Document](docs/design.md) - Architecture and technical design
- [Product Backlog](docs/product_backlog.md) - Features and user stories
- [App Icon Guide](docs/APP_ICON_GUIDE.md) - Icon generation guide
- [AI Prompting Guide](AI_PROMPTING_GUIDE.md) - AI development workflow
- [Build Optimization](BUILD_OPTIMIZATION.md) - Performance tuning

## 🤝 Contributing

Contributions are welcome! This is an open-source project designed to be community-driven.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 🐛 Known Issues

- OCR accuracy varies with receipt quality (faded text, crumpled paper)
- Image file cleanup not yet implemented (receipts accumulate in storage)
- Test coverage incomplete for provider and database layers

## 🗺️ Roadmap

### Q1 2025
- [ ] Enhanced OCR accuracy with preprocessing
- [ ] Expense categorization
- [ ] Achievement system
- [ ] Dark mode support

### Q2 2025
- [ ] Data export (CSV/PDF)
- [ ] Cloud sync (optional)
- [ ] Multi-year tracking
- [ ] Advanced analytics

### Q3 2025
- [ ] iOS App Store release
- [ ] Android Play Store release
- [ ] Community feature voting
- [ ] Tax tip library expansion

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- OCR powered by [Google ML Kit](https://developers.google.com/ml-kit)
- Icons from [Material Design Icons](https://fonts.google.com/icons)
- Template originally from [min_flutter_template](https://github.com/cmwen/min-flutter-template)

## 📞 Support

- 📧 Email: your-email@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/receipt-quest-app/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/receipt-quest-app/discussions)

## ⚠️ Disclaimer

Receipt Quest provides tax savings **estimates only**. These calculations are not professional tax advice. Consult with a qualified tax professional for advice specific to your situation. The accuracy of estimates depends on the accuracy of information you provide and current tax laws.

---

**Made with ❤️ for freelancers, side hustlers, and anyone who wants to maximize their tax deductions**
