# Hotel Booking App - Pratical Shubhangi

A modern Flutter application for browsing and searching hotels with Google Sign-In authentication. Built using GetX for state management and following clean architecture principles.

## 📱 Features

### 1. **Splash Screen**
- Animated app logo and branding
- Automatic login check on startup
- Smooth transitions to login or home
- Beautiful gradient background
- 2-second display duration

### 2. **Google Sign-In Authentication**
- Secure Google OAuth integration
- Frontend-only implementation
- Beautiful gradient UI with app branding
- Persistent login with local storage
- Auto-login on app restart

### 3. **Hotel Listing (Home Page)**
- Display featured hotels with images, ratings, and prices
- Pull-to-refresh functionality
- Cached network images for optimal performance
- Search bar for quick hotel discovery
- Empty state handling with retry option
- User avatar with initials fallback

### 4. **Search Results with Pagination**
- Real-time hotel search by name, city, state, or country
- Infinite scroll pagination
- Page indicator and result counter
- Smooth loading states with shimmer effects
- Error handling with user-friendly messages

## 🏗️ Project Structure

```
lib/
├── core/                           # Core application files
│   ├── constants/
│   │   ├── app_constants.dart      # API URLs, tokens, and constants
│   │   └── app_colors.dart         # Color palette and theme colors
│   └── utils/
│       └── storage_manager.dart    # Local storage manager
│
├── data/                           # Data layer
│   ├── models/
│   │   ├── hotel_model.dart        # Hotel data model with JSON serialization
│   │   └── user_model.dart         # User data model
│   └── services/
│       └── api_service.dart        # API client using Dio
│
├── modules/                        # Feature modules (GetX pattern)
│   ├── splash/                     # Splash screen module
│   │   ├── controllers/
│   │   │   └── splash_controller.dart   # Splash logic & auth check
│   │   └── views/
│   │       └── splash_page.dart         # Splash UI with animations
│   │
│   ├── auth/                       # Authentication module
│   │   ├── controllers/
│   │   │   └── auth_controller.dart     # Google Sign-In logic
│   │   └── views/
│   │       └── login_page.dart          # Login UI
│   │
│   ├── home/                       # Home module
│   │   ├── controllers/
│   │   │   └── home_controller.dart     # Home page logic
│   │   └── views/
│   │       └── home_page.dart           # Hotel list UI
│   │
│   └── search/                     # Search module
│       ├── controllers/
│       │   └── search_controller.dart   # Search & pagination logic
│       └── views/
│           └── search_page.dart         # Search results UI
│
├── routes/                         # Navigation
│   ├── app_routes.dart            # Route constants
│   └── app_pages.dart             # GetX page bindings
│
├── firebase_options.dart          # Firebase configuration
└── main.dart                      # Application entry point
```

## 🛠️ Technologies Used

### Core Dependencies
- **Flutter SDK**: ^3.5.1
- **Dart SDK**: ^3.5.1

### State Management & Navigation
- **GetX** (^4.6.6): Lightweight state management, dependency injection, and routing

### Authentication
- **google_sign_in** (^6.2.1): Google OAuth authentication

### Networking
- **dio** (^5.4.0): Powerful HTTP client with interceptors and error handling

### UI Components
- **cached_network_image** (^3.3.1): Image caching and loading
- **shimmer** (^3.0.0): Skeleton loading animations
- **cupertino_icons** (^1.0.8): iOS-style icons

### Local Storage
- **shared_preferences** (^2.2.2): Local data persistence

### Firebase
- **firebase_core** (^4.2.0): Firebase SDK for iOS & Android

## 📐 Architecture

This project follows **Clean Architecture** principles with **GetX** pattern:

### Layers:
1. **Presentation Layer** (Views)
   - UI components
   - User interaction handling
   - Reactive widgets with Obx

2. **Business Logic Layer** (Controllers)
   - State management
   - Business rules
   - API calls coordination

3. **Data Layer** (Models & Services)
   - API integration
   - Data models
   - Data transformation

### GetX Pattern:
- **Controllers**: Manage state and business logic
- **Bindings**: Lazy-load dependencies
- **Routes**: Type-safe navigation
- **Reactive State**: Automatic UI updates with `.obs`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.1 or higher)
- Dart SDK (3.5.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd pratical_flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Google Sign-In** (Optional for production)
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing
   - Enable Google Sign-In API
   - Configure OAuth consent screen
   - Download and add `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)

4. **Run the app**
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode
flutter run

# Run in release mode
flutter run --release
```

### Build

**Android APK**
```bash
# Debug APK
flutter build apk --debug

# Release APK (requires signing)
flutter build apk --release
```

**iOS** (macOS only)
```bash
flutter build ios
```

## 🔧 Configuration

### API Configuration
Located in `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';
  static const int pageSize = 10; // Results per page
}
```

### Android Configuration
- **Gradle Version**: 8.9
- **Android Gradle Plugin**: 8.7.0
- **Kotlin Version**: 2.1.0
- **Java Version**: 11
- **Min SDK**: 21
- **Target SDK**: 36
- **Compile SDK**: 36

### Permissions
The app requires the following permissions (already configured):
- `INTERNET`: For API calls
- `ACCESS_NETWORK_STATE`: For network status monitoring

## 📊 API Integration

### Base URL
```
https://api.mytravaly.com/public/v1/
```

### Authentication
All requests include the Bearer token in headers:
```
Authorization: Bearer 71523fdd8d26f585315b4233e39d9263
```

### Endpoints

#### 1. Get All Hotels
```
GET /hotels?page=1&limit=20
```

#### 2. Search Hotels
```
GET /hotels/search?query=<search_term>&page=1&limit=10
```

**Query Parameters:**
- `query`: Search term (hotel name, city, state, country)
- `page`: Page number (default: 1)
- `limit`: Results per page (default: 10)

## 🎨 UI/UX Features

### Design Elements
- **Material 3 Design**: Modern Material Design components
- **Custom Color Scheme**: Blue gradient theme
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Splash screen, page transitions, and loading states
- **Error Handling**: User-friendly error messages
- **Empty States**: Informative empty state screens
- **Loading States**: Shimmer effects and progress indicators

### User Experience
- Animated splash screen with auto-login
- Pull-to-refresh on lists
- Infinite scroll pagination
- Cached images for faster loading
- Real-time search
- Persistent login (stays logged in)
- User avatar with initials fallback
- Logout functionality
- Smooth navigation transitions

## 📝 Code Documentation

All classes and methods are documented with Dart documentation comments:

```dart
/// Controller for Search Results Page
/// Handles hotel search with pagination functionality
class HotelSearchController extends GetxController {

  /// Perform hotel search with the given query
  /// Resets pagination and clears previous results
  Future<void> performSearch({String? query}) async {
    // Implementation
  }
}
```

## 🧪 Testing

Run tests with:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

## 🐛 Troubleshooting

### Common Issues

1. **Gradle Build Fails**
   ```bash
   flutter clean
   cd android && ./gradlew clean
   cd .. && flutter pub get
   flutter run
   ```

2. **Google Sign-In Not Working**
   - Ensure SHA-1 fingerprint is added to Firebase Console
   - Check package name matches in `build.gradle`
   - Verify `google-services.json` is in `android/app/`

3. **API Calls Failing**
   - Check internet connection
   - Verify API token in `app_constants.dart`
   - Check API endpoint availability

## 📦 Dependencies Update

Check for outdated packages:
```bash
flutter pub outdated
```

Update dependencies:
```bash
flutter pub upgrade
```

## 🔐 Security Notes

- **API Token**: Currently hardcoded for demo purposes. In production, use secure storage or environment variables
- **Google Sign-In**: Frontend-only implementation. For production, implement backend verification
- **Network Security**: Uses HTTPS for all API calls

## 📄 License

This project is created for practical assessment purposes.

## 👤 Author

**Shubhangi**

## 📞 Support

For issues or questions, please create an issue in the repository.

---

## 🚦 Development Status

- ✅ Animated Splash Screen
- ✅ Auto-login Check
- ✅ Local Storage (SharedPreferences)
- ✅ Google Sign-In Authentication
- ✅ Persistent Login
- ✅ Hotel List Display
- ✅ Search Functionality
- ✅ Pagination Implementation
- ✅ API Integration
- ✅ Error Handling
- ✅ Code Documentation
- ✅ Clean Architecture
- ✅ Firebase Setup (iOS & Android)

## 🎯 Application Flow

```
App Launch → Splash Screen (2s animated)
                ↓
         Check Login Status
         (StorageManager)
                ↓
    ┌───────────┴───────────┐
    ↓                       ↓
Not Logged In          Logged In
    ↓                       ↓
Login Page            Home Page
    ↓                       ↓
Google Sign-In     Hotel List + Search
    ↓                       ↓
Save to Storage       Search Results
    ↓                 with Pagination
Home Page
```

## 🔑 Key Features

1. **Persistent Login**: User stays logged in across app restarts
2. **Smart Splash**: Automatically navigates based on login status
3. **Local Storage**: User data cached with SharedPreferences
4. **Offline Ready**: User info available without network
5. **Clean Architecture**: Separated concerns with GetX pattern
6. **Firebase Ready**: Configured for iOS & Android
7. **Smooth UX**: Animated transitions and loading states

## 📈 Future Enhancements

- [ ] Hotel details page
- [ ] Booking functionality
- [ ] Favorites/Wishlist
- [ ] Filter options (price, rating, amenities)
- [ ] Map view integration
- [ ] User reviews and ratings
- [ ] Backend authentication
- [ ] Offline support
- [ ] Multi-language support
- [ ] Dark mode

---

**Built with ❤️ using Flutter & GetX**
