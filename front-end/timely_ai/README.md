# Timely.AI - Frontend

Flutter frontend for the Timely.AI academic timetable scheduling system.

## Quick Start

### Install Dependencies

```bash
flutter pub get
```

### Configure Backend URL

Edit `lib/config/app_config.dart` or use environment variables:

```bash
flutter run --dart-define=SERVER_URL=http://localhost:5000
```

**Platform-specific URLs:**
- **Desktop/Web**: `http://localhost:5000`
- **Android Emulator**: `http://10.0.2.2:5000`
- **iOS Simulator**: `http://localhost:5000`
- **Physical Device**: Use your computer's local IP (e.g., `http://192.168.1.100:5000`)

### Run the App

```bash
# Check available devices
flutter devices

# Run on specific platform
flutter run -d windows
flutter run -d edge
flutter run -d chrome
flutter run -d android
```

## Features

- 📊 Manage instructors, courses, rooms, and student groups
- 💾 Local data persistence with Hive
- 📅 Generate optimized timetables via backend API
- 📄 Export timetables to PDF
- ⚙️ Customizable scheduling preferences
- 🎨 Material Design 3 UI

## Project Structure

```
lib/
├── config/                 # App configuration
│   └── app_config.dart
├── features/              # Feature modules
│   ├── data_management/   # CRUD operations
│   ├── home/             # Home screen
│   ├── PDF_creation/     # PDF generation
│   ├── settings/         # Settings screen
│   └── timetable/        # Timetable viewing
├── models/               # Data models
│   ├── CourseModel.dart
│   ├── InstructorModel.dart
│   ├── RoomModel.dart
│   └── StudentGroupModel.dart
├── services/             # Services
│   └── storage_service.dart
└── main.dart            # Entry point
```

## Dependencies

- **flutter_riverpod**: State management
- **http**: API communication
- **hive**: Local storage
- **pdf**: PDF generation
- **printing**: PDF export

## Building for Release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release

# Web
flutter build web --release
```

## Troubleshooting

### Connection Issues
- Ensure backend server is running
- Check firewall settings
- Verify SERVER_URL configuration

### Build Issues
```bash
flutter clean
flutter pub get
```

For more information, see the main [README](../../README.md).
