# 🌊 HushSense

> **The World's Largest Decentralized Urban Noise Mapping Platform**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.3-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.3-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-13.0.0-orange.svg)](https://firebase.google.com)
[![Hedera](https://img.shields.io/badge/Hedera-Blockchain-blue.svg)](https://hedera.com)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

HushSense is a revolutionary **DePIN (Decentralized Physical Infrastructure Network)** mobile application that transforms every smartphone into a sophisticated urban noise sensor. Built with Flutter, this platform creates the world's most comprehensive real-time noise pollution database while rewarding users for their contributions through gamification and blockchain incentives.

<p align="center">
  <img src="assets/images/logo.jpeg" alt="HushSense Logo" width="200"/>
</p>

---

## 🎯 Vision & Mission

### **Vision**
To build the world's largest, most accurate, real-time urban noise map, empowering communities and organizations to create quieter, healthier, and more livable cities.

### **Mission**
Transform urban noise monitoring through community participation, turning every smartphone user into a citizen scientist contributing to a global noise pollution database.

### **Core Innovation**
- **Software DePIN Model**: No proprietary hardware required - leverages existing smartphones
- **Gamified Contribution**: Engaging user experience that rewards data collection
- **Privacy-First Architecture**: Users own and control their data through "Honest Data Approach"
- **Dual-Sided Marketplace**: Connects data contributors with data consumers (businesses, municipalities)

---

## 🏗️ Architecture Overview

### **Clean Architecture Pattern**

```
lib/
├── core/                    # Core business logic & services
│   ├── animations/         # Custom animations & visualizers
│   ├── constants/          # App constants & configuration
│   ├── services/           # Core services (audio, location, etc.)
│   ├── theme/             # Material Design 3 theming
│   ├── utils/             # Utility functions & helpers
│   └── widgets/           # Reusable UI components
├── domain/                 # Business logic & data models
│   └── models/            # Hive-enabled data models
└── presentation/          # UI & state management
    ├── providers/         # Riverpod state management
    ├── screens/           # Feature screens & navigation
    └── widgets/           # Screen-specific widgets
```

### **Technology Stack**

#### **Frontend Framework**
- **Flutter 3.24+** - Cross-platform mobile development
- **Dart 3.5+** - Type-safe programming language
- **Material Design 3** - Modern design system with custom HushSense theming

#### **State Management**
- **Riverpod 2.6+** - Reactive state management with dependency injection
- **Riverpod Annotations** - Code generation for providers

#### **Backend & Database**
- **Firebase Suite**:
  - **Firebase Auth** - User authentication & management
  - **Cloud Firestore** - NoSQL database for real-time data
  - **Firebase Storage** - File storage for media assets
  - **Firebase Messaging** - Push notifications
  - **Cloud Functions** - Serverless backend logic

#### **Local Storage**
- **Hive 2.2+** - Fast, lightweight NoSQL database for offline functionality
- **Shared Preferences** - Simple key-value storage

#### **Real-Time Services**
- **Audio Processing**:
  - **noise_meter 5.0+** - Real-time decibel measurement
  - Custom calibration algorithms for smartphone microphones
- **Location Services**:
  - **geolocator 13.0+** - GPS positioning
  - **geocoding 3.0+** - Address resolution
  - **google_maps_flutter 2.9+** - Interactive mapping

#### **Blockchain Integration**
- **Hedera Network** - Decentralized data anchoring
- **HashConnect SDK** - Wallet connectivity for Web3 features
- **Cryptographic Proofs** - Data integrity verification

#### **Additional Features**
- **Lottie 3.1+** - Vector animations
- **Flutter Animate 4.5+** - Advanced animations
- **Shimmer 3.0+** - Loading effects
- **Connectivity Plus 6.0+** - Network status monitoring

---

## ✨ Key Features

### **🎙️ Core Measurement Experience**
- **Real-time decibel meter** with beautiful animated visualizer
- **Active Mode**: 30-second measurement sessions with GPS coordinates
- **Passive Mode**: Background measurements (battery-optimized, opt-in)
- **Multi-device calibration** for consistent readings across smartphones

### **🗺️ Interactive Noise Map**
- **Heatmap visualization** showing urban sound intensity
- **Venue markers** with average noise levels and user ratings
- **Time-based filtering** (hour, day, week, month)
- **Custom map styling** optimized for noise data visualization

### **🏢 Facility Check-in System**
- **Venue search** via Places API integration
- **Location-based measurements** at specific venues
- **Qualitative feedback** with tags (#quiet, #lively, #background-music)
- **Higher rewards** for venue-specific data contributions

### **🎮 Gamification & Rewards**
- **$HUSH Token System** - Rewards for data contributions
- **Achievement badges** and progress tracking
- **Daily streaks** and leaderboards
- **Level progression** with experience points
- **In-app marketplace** for redeeming rewards

### **📊 Analytics & Insights**
- **Personal dashboard** with contribution statistics
- **Noise trend analysis** over time
- **Health impact indicators** based on noise levels
- **Community impact metrics** for collective contributions

### **🔒 Privacy & Data Control**
- **Honest Data Approach** - Users own their data
- **Granular privacy settings** for data sharing
- **Data anonymization** and precision reduction options
- **Consent withdrawal** capabilities
- **Transparent data usage** explanations

---

## 🚀 Getting Started

### **Prerequisites**

- **Flutter SDK** 3.24.3 or later
- **Dart SDK** 3.5.3 or later
- **Android Studio** (for Android development)
- **Xcode** (for iOS development)
- **Firebase Account** with project configured
- **Hedera Testnet Account** (for blockchain features)

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/HushSense/hush-sense-mobile-app.git
   cd hush-sense-mobile-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication, Firestore, Storage, and Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place configuration files in appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Configure Google Maps**
   - Get API key from [Google Cloud Console](https://console.cloud.google.com)
   - Enable Maps SDK for Android and iOS
   - Add API key to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
     ```

5. **Set up local development**
   ```bash
   # Generate Hive adapters
   flutter pub run build_runner build

   # Run code generation
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

### **Running the Application**

#### **Development Mode**
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device_id>

# Run on web (for testing)
flutter run -d chrome
```

#### **Build Commands**
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release

# Web
flutter build web --release
```

### **Environment Configuration**

Create environment files for different configurations:

#### **Development** (`lib/core/constants/env.dart`)
```dart
class Environment {
  static const String name = 'development';
  static const String apiUrl = 'https://dev-api.hushsense.com';
  static const bool enableLogging = true;
  static const bool enableCrashReporting = false;
}
```

#### **Production** (`lib/core/constants/env.dart`)
```dart
class Environment {
  static const String name = 'production';
  static const String apiUrl = 'https://api.hushsense.com';
  static const bool enableLogging = false;
  static const bool enableCrashReporting = true;
}
```

---

## 📱 User Experience Flow

### **Onboarding Journey**
1. **Welcome Screen** - Introduction to HushSense mission
2. **Permission Requests** - Microphone, location, notifications
3. **Wallet Setup** - Hedera wallet connection (optional)
4. **Tutorial** - How to take measurements and earn rewards
5. **Profile Setup** - Username, preferences, privacy settings

### **Main Navigation**
- **🎯 Measure** (Primary) - Real-time noise measurement with visualizer
- **🏠 Home** - Dashboard with statistics and quick actions
- **🗺️ Map** - Interactive noise map with heatmaps and venues
- **🎁 Rewards** - Token balance, achievements, and marketplace
- **👤 Profile** - User settings, data control, and activity history

### **Measurement Types**
1. **General Noise** - Ambient sound measurement
2. **Venue Check-in** - Location-specific measurements
3. **Noise Reports** - Community complaints (non-rewarded)

---

## 🔧 Development Guidelines

### **Code Style & Standards**

#### **File Naming Convention**
- **Screens**: `screen_name_screen.dart` (e.g., `home_screen.dart`)
- **Widgets**: `component_name_widget.dart`
- **Services**: `service_name_service.dart`
- **Models**: `model_name.dart`
- **Providers**: `feature_name_provider.dart`

#### **Import Organization**
```dart
// Flutter/Dart imports
import 'package:flutter/material.dart';

// Third-party packages (alphabetical)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports (relative paths)
import '../../core/constants/app_constants.dart';
import '../models/user_profile.dart';
```

#### **State Management Patterns**
- Use **Riverpod** for all state management
- **StateNotifier** for complex state logic
- **StreamProvider** for real-time data streams
- **FutureProvider** for async operations

### **Testing Strategy**

#### **Unit Tests**
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/noise_measurement_test.dart
```

#### **Integration Tests**
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### **Performance Optimization**

#### **Memory Management**
- Use `const` constructors where possible
- Implement proper `dispose()` methods
- Monitor memory usage with Flutter DevTools
- Use `ListView.builder` for large lists

#### **Battery Optimization**
- Minimize background location updates
- Use efficient audio processing algorithms
- Implement app lifecycle management
- Optimize map rendering performance

#### **Network Efficiency**
- Implement offline-first architecture
- Use Firebase offline persistence
- Batch API requests where possible
- Implement intelligent sync strategies

---

## 🌐 Deployment & Distribution

### **Android Deployment**
1. **Build Release APK/AAB**
   ```bash
   flutter build appbundle --release
   ```

2. **Code Signing**
   - Configure signing in `android/app/build.gradle`
   - Generate upload key and keystore

3. **Play Store**
   - Create app listing on Google Play Console
   - Upload AAB file for review
   - Configure store listing with screenshots and descriptions

### **iOS Deployment**
1. **Build Release IPA**
   ```bash
   flutter build ios --release
   ```

2. **Code Signing**
   - Configure certificates and provisioning profiles
   - Set up App Store Connect

3. **App Store**
   - Create app record in App Store Connect
   - Upload IPA file for review
   - Manage TestFlight beta testing

### **Continuous Integration**
```yaml
# .github/workflows/ci.yml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: flutter-actions/setup-flutter@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

---

## 🤝 Contributing

### **Development Setup**
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Make changes and test thoroughly
4. Run tests: `flutter test`
5. Run linter: `flutter analyze`
6. Commit changes: `git commit -m 'Add amazing feature'`
7. Push to branch: `git push origin feature/amazing-feature`
8. Open Pull Request

### **Code Review Process**
- All submissions require review
- Code must pass all tests and linting
- Documentation must be updated
- Feature branches should be kept up-to-date with main

### **Community Guidelines**
- Be respectful and inclusive
- Focus on constructive feedback
- Help new contributors learn and grow
- Maintain high code quality standards

---

## 📞 Support & Contact

### **Community**
- **Discord**: [Join HushSense Community](https://discord.gg/hushsense)
- **Twitter**: [@HushSenseApp](https://twitter.com/hushsenseapp)
- **GitHub Issues**: [Report bugs & request features](https://github.com/HushSense/hush-sense-mobile-app/issues)


### **Business Inquiries**
- **Partnerships**: partnerships@hushsense.com
- **Enterprise Sales**: enterprise@hushsense.com
- **Media Relations**: press@hushsense.com

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

### **Open Source Contributions**
HushSense is committed to open source development. All contributions are welcome under the following guidelines:

- Code must be original and properly licensed
- Contributions should align with project goals
- Maintainers reserve right to accept/reject contributions
- All contributors must follow the Code of Conduct

---

## 🙏 Acknowledgments

### **Built With**
- **Flutter Team** - Amazing cross-platform framework
- **Firebase Team** - Robust backend services
- **Hedera Network** - Decentralized infrastructure
- **Open Source Community** - Countless packages and tools

### **Special Thanks**
- **Early Adopters** - For believing in our vision
- **Beta Testers** - For valuable feedback and bug reports
- **Open Source Contributors** - For improving the codebase
- **Research Partners** - For acoustic science collaboration

---

**Made with ❤️ by the HushSense Team**

*"Building quieter cities, one measurement at a time"*