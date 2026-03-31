# Acting Academy App 🎭

A Flutter-based mobile application for an acting academy, providing students with courses, community interaction, and learning resources. Built following clean architecture principles with MVVM pattern.

## 📱 Features

- **User Authentication**: Login, registration, and OTP verification
- **Onboarding Flow**: Guided introduction for new users
- **Course Management**: Browse courses, access class materials, video player
- **Community Features**: Posts, comments, reactions
- **Profile Management**: Personal information and account settings

## 🏗️ Architecture

The app follows **MVVM (Model-View-ViewModel)** pattern with a clean separation of concerns:

### Project Structure
lib/
├── core/ # Global configurations & infrastructure
│ ├── constants/ # API endpoints, app constants
│ ├── di/ # Dependency injection setup
│ ├── network/ # API error handling, network utilities
│ ├── routes/ # App routing & navigation
│ ├── services/ # Dio client, socket, storage services
│ ├── theme/ # App theme, colors, styles
│ └── utils/ # Helper functions, utilities
│
├── presentation/ # Global presentation layer
│ ├── viewmodels/ # Shared business logic
│ │ ├── auth/ # Login, register viewmodels
│ │ ├── community/ # Post viewmodel
│ │ ├── course/ # Course viewmodel
│ │ ├── home/ # Home viewmodel
│ │ ├── onboarding/ # Onboarding viewmodel
│ │ └── profile/ # Profile viewmodel
│ └── app_providers.dart # ViewModel registration
│
└── views/ # Feature-specific views
├── auth/ # Authentication feature
│ ├── login/ # Login screen
│ │ ├── data/ # Login model, repository impl
│ │ ├── domain/ # Login entity, usecases
│ │ └── presentation/
│ │ ├── screen/ # Login screen UI
│ │ └── widgets/# Login-specific widgets
│ ├── register/ # Registration screen
│ └── otp_verify/ # OTP verification screen
│
├── community/ # Community feature
│ ├── data/ # Models, repositories
│ ├── domain/ # Entities, usecases
│ └── presentation/
│ ├── screen/ # Community, comment screens
│ └── widgets/ # Post card, reaction buttons
│
└── course_screen/ # Course & classroom feature
├── model/ # Course models
└── screens/
├── my_class/ # Classroom screens
└── my_course/ # Course content screens

text

## 🔄 MVVM Workflow

### Model (Data Layer)
Located in `views/*/data/` folders
- JSON parsers and DTOs
- Repository implementations
- Data sources (local/remote)

### ViewModel (Business Logic Layer)
Located in `presentation/viewmodels/`
- Calls UseCases or Repositories
- Manages UI states (loading, error, success)
- Notifies UI about state changes

### View (UI Layer)
Located in `views/*/presentation/screen/`
- Flutter widgets
- Observes ViewModels
- Renders UI based on state
- Dispatches user actions to ViewModels

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator or Android Emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/acting-academy-app.git
cd acting-academy-app
Install dependencies

bash
flutter pub get
Set up environment variables

bash
# Create a .env file in the root directory
cp .env.example .env
# Add your API keys and configuration
Run the app

bash
flutter run
📦 Dependencies
Core
get_it: Dependency injection

provider: State management

dio: HTTP client

shared_preferences: Local storage

socket_io_client: WebSocket communication

UI
flutter_svg: SVG support

cached_network_image: Image caching

video_player: Video playback

Utilities
equatable: Value equality

logger: Logging

flutter_native_splash: Splash screen

flutter_launcher_icons: App icons

🔧 Configuration
API Endpoints
Configure API endpoints in lib/core/constants/api_endpoints.dart

Theme
Customize app theme in lib/core/theme/app_theme.dart

Routes
Add new routes in lib/core/routes/route_names.dart and app_routes.dart

📝 Code Structure Guidelines
Adding a New Feature
Create feature folder under lib/views/

text
views/new_feature/
├── data/
│   ├── new_feature_model.dart
│   └── new_feature_repository_impl.dart
├── domain/
│   ├── new_feature_entity.dart
│   └── new_feature_usecase.dart
└── presentation/
    ├── screen/
    │   └── new_feature_screen.dart
    └── widgets/
        └── custom_widget.dart
Create ViewModel in presentation/viewmodels/

dart
class NewFeatureViewModel extends ChangeNotifier {
  // Business logic here
}
Register ViewModel in presentation/app_providers.dart

dart
final newFeatureViewModel = NewFeatureViewModel();
Add route in core/routes/route_names.dart

dart
class RouteNames {
  static const String newFeature = '/new-feature';
}
🧪 Testing
Unit Tests
bash
flutter test test/
Widget Tests
bash
flutter test test/widgets/
📱 Build & Release
Android
bash
# Generate keystore
keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
iOS
bash
# Build IPA
flutter build ios --release
# Open in Xcode for distribution
open ios/Runner.xcworkspace
🤝 Contributing
Fork the repository

Create your feature branch (git checkout -b feature/AmazingFeature)

Commit your changes (git commit -m 'Add some AmazingFeature')

Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request

Coding Standards
Follow the Flutter Style Guide

Use meaningful variable and function names

Add comments for complex logic

Write tests for new features

📄 License
This project is proprietary and confidential. Unauthorized copying, distribution, or use is strictly prohibited.

📞 Support
For support, email support@actingacademy.com or create an issue in the repository.

📊 Project Status
Authentication Module

Onboarding Flow

Course Management

Community Features

Video Streaming Optimization

Push Notifications

Offline Mode

Built with ❤️ using Flutter | Version 1.0.0

text

This README provides a comprehensive overview of your project structure, architecture, setup instructions, and contribution guidelines. It's organized to help new developers quickly understand the codebase and start contributing effectively.
