# MyProject Platform App

A simple, reusable Flutter application that displays a splash screen and opens a configurable URL in a full-screen in-app browser. This app works seamlessly across iOS, Android, and desktop platforms.

## Features

- **Splash Screen**: Displays your custom logo and app name
- **In-App Browser**: Opens web content in full-screen WebView
- **Easy Configuration**: Change URL, logo, and app name without rebuilding
- **Cross-Platform**: Works on iOS, Android, Windows, macOS, and Linux
- **Error Handling**: Gracefully handles network errors with retry functionality
- **Pull to Refresh**: Users can refresh the web content

## Configuration

All app settings are stored in local files that can be easily modified:

### 1. Change URL and App Name

Edit `assets/config.json`:

```json
{
  "appName": "SkyProperty",
  "url": "https://skypropertyksa.com/projects"
}
```

### 2. Change Logo

Replace the logo file at:
```
assets/images/logo.png
```

After replacing the logo, update the reference in `pubspec.yaml` if the filename changes:

```yaml
flutter:
  assets:
    - assets/config.json
    - assets/images/YOUR_NEW_LOGO_FILENAME.png
```

### 3. Change App Display Name

**For Android**: Edit `android/app/src/main/AndroidManifest.xml`
```xml
<application android:label="Your App Name" ...>
```

**For iOS**: Edit `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Desktop (Windows):**
```bash
flutter build windows --release
```

**Desktop (macOS):**
```bash
flutter build macos --release
```

**Desktop (Linux):**
```bash
flutter build linux --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── app_config.dart       # Configuration data model
├── services/
│   └── config_service.dart   # Configuration loader
└── screens/
    ├── splash_screen.dart    # Splash screen with logo
    └── webview_screen.dart   # Full-screen WebView

assets/
├── config.json               # App configuration
└── images/
    └── logo.png  # App logo
```

## Reusing This App

This app is designed to be easily reusable for different projects:

1. **Change the configuration** in `assets/config.json`
2. **Replace the logo** in `assets/images/`
3. **Update app name** in platform-specific files
4. **Rebuild the app** with `flutter build`

That's it! You now have a branded app pointing to your desired URL.

## Dependencies

- `webview_flutter: ^4.4.2` - WebView support
- `webview_flutter_android: ^3.12.1` - Android WebView implementation
- `webview_flutter_wkwebview: ^3.9.4` - iOS WebView implementation

## Platform Support

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Troubleshooting

### App shows blank screen
- Check your internet connection
- Verify the URL in `assets/config.json` is correct and accessible
- Pull down to refresh or restart the app

### Logo not displaying
- Ensure the logo file path in `pubspec.yaml` matches the actual file location
- Run `flutter clean` and `flutter pub get`

### WebView not loading
- Check that internet permissions are properly configured
- For Android: Verify `AndroidManifest.xml` has `INTERNET` permission
- For iOS: Verify `Info.plist` has `NSAppTransportSecurity` configured

## License

This project is open source and available for personal and commercial use.

## Test Configuration

Current test setup:
- **App Name**: SkyProperty
- **URL**: https://skypropertyksa.com
- **Logo**: logo.png
