# Timely.AI - AI-Powered Timetable Scheduler

Timely.AI is an intelligent academic timetable scheduling application that uses constraint programming to automatically generate optimized schedules. It consists of a Flutter frontend for data management and visualization, and a Python Flask backend powered by Google OR-Tools CP-SAT solver.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python)

## 🌟 Features

### Core Functionality
- **Automated Scheduling**: Uses advanced constraint programming to generate conflict-free timetables
- **Multi-Platform Support**: Runs on Windows, macOS, Linux, iOS, Android, and Web
- **Local Data Persistence**: All data saved locally using Hive database
- **PDF Export**: Generate professional printable timetables
- **Detailed Error Reporting**: Get specific diagnostics when scheduling fails

### Constraint Management
- ✅ Instructor and student group availability
- ✅ Room type constraints (Classroom vs Lab)
- ✅ No conflicting assignments
- ✅ Consecutive 2-hour lab sessions
- ✅ Maximum labs per day limits
- ✅ Instructor preferences by student group
- ✅ No repeat lectures per day
- ✅ Lunch break handling
- ✅ Fair workload distribution (optional)
- ✅ Preferred morning classes (optional)

## 📋 Prerequisites

### Frontend (Flutter)
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Backend (Python)
- Python 3.8 or higher
- pip (Python package manager)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Timely.AI.git
cd Timely.AI
```

### 2. Backend Setup

#### Navigate to server directory
```bash
cd server
```

#### Create a virtual environment (recommended)
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

#### Install Python dependencies
```bash
pip install flask flask-cors ortools
```

### 3. Frontend Setup

#### Navigate to Flutter project
```bash
cd ../front-end/timely_ai
```

#### Install Flutter dependencies
```bash
flutter pub get
```

#### Configure Server URL

The app uses `http://localhost:5000` by default. To change the backend URL:

**Option 1: Environment Variable (Recommended for different environments)**
```bash
# Run with custom server URL
flutter run --dart-define=SERVER_URL=http://your-server-ip:5000
```

**Option 2: Edit Configuration File**

Edit `lib/config/app_config.dart`:
```dart
static const String serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://YOUR_IP:5000', // Change this
);
```

**Important**: If running on a physical device or emulator:
- **Android Emulator**: Use `http://10.0.2.2:5000`
- **iOS Simulator**: Use `http://localhost:5000`
- **Physical Device**: Use your computer's local IP (e.g., `http://192.168.1.100:5000`)
- **Web/Desktop**: Use `http://localhost:5000`

## 🎯 Running the Application

### Start the Backend Server

```bash
cd server
python app.py
```

The server will start on `http://0.0.0.0:5000`

You should see:
```
* Running on http://0.0.0.0:5000
* Restarting with stat
```

### Start the Flutter App

In a new terminal:

```bash
cd front-end/timely_ai
```

**Run on specific platform:**

```bash
# Windows
flutter run -d windows

# Web (Chrome/Edge)
flutter run -d chrome
# or
flutter run -d edge

# Android (with emulator/device connected)
flutter run -d android

# iOS (macOS only, with simulator running)
flutter run -d ios

# Check available devices
flutter devices
```

## 📖 Usage Guide

### 1. Data Management

#### Add Instructors
1. Click **"Manage Instructors"**
2. Fill in instructor details (ID, Name)
3. Configure availability grid (green = available, red = unavailable)
4. Save

#### Add Courses
1. Click **"Manage Courses"**
2. Enter course details:
   - ID, Name, Credits
   - Lecture hours (per week)
   - Lab hours (per week)
   - Lab type (Computer/Hardware)
   - Select qualified instructors
3. Save

#### Add Rooms
1. Click **"Manage Rooms"**
2. Enter room details:
   - ID, Capacity
   - Type (Classroom/Computer Lab/Hardware Lab)
   - Equipment available
3. Save

#### Add Student Groups
1. Click **"Manage Student Groups"**
2. Enter group details:
   - Group ID, Size
   - Select enrolled courses
   - (Optional) Set instructor preferences per course
   - (Optional) Configure availability
3. Save

### 2. Configure Settings

Click **"Settings"** to customize:
- ☑️ Minimize idle time between classes
- ☑️ Fair workload distribution
- ☑️ Preferred morning classes (select courses)

### 3. Generate Timetable

1. Click **"Generate Timetable"** from home screen
2. Wait for solver to find solution (max 30 seconds)
3. View generated schedule by:
   - Day
   - Student Group
   - Instructor

### 4. Export to PDF

From the timetable view:
1. Click **"Download PDF"** icon
2. Choose save location
3. Open professional PDF timetable

## 🔧 Configuration

### Timeslots and Days

Edit `lib/config/app_config.dart` to customize default schedule structure:

```dart
static const List<String> defaultDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday', // Remove if not needed
];

static const List<String> defaultTimeslots = [
  '08:30 AM - 09:30 AM',
  '09:30 AM - 10:30 AM',
  '11:00 AM - 12:00 PM',
  '12:00 PM - 01:00 PM', // Lunch break
  '02:00 PM - 03:00 PM',
  '03:00 PM - 04:00 PM',
  '04:00 PM - 05:00 PM',
];
```

### Solver Timeout

Edit `server/app.py` to adjust maximum solving time:

```python
solver.parameters.max_time_in_seconds = 30.0  # Change as needed
```

## 🏗️ Architecture

```
Timely.AI/
├── front-end/
│   └── timely_ai/
│       ├── lib/
│       │   ├── config/         # App configuration
│       │   ├── features/       # Feature modules
│       │   │   ├── data_management/
│       │   │   ├── home/
│       │   │   ├── PDF_creation/
│       │   │   ├── settings/
│       │   │   └── timetable/
│       │   ├── models/         # Data models
│       │   ├── services/       # Storage service
│       │   └── shared/         # Shared widgets
│       └── pubspec.yaml
│
└── server/
    ├── app.py              # Flask API + CP-SAT solver
    └── tests/              # Unit tests
```

## 🐛 Troubleshooting

### "Failed to connect to the server"
- Ensure backend is running (`python app.py`)
- Check firewall settings
- Verify SERVER_URL in configuration matches backend address
- For physical devices, use your computer's local IP address

### "No solution found"
Check the detailed error report for:
- Insufficient rooms for the number of classes
- Instructor availability too restrictive
- Missing qualified instructors for courses
- Lab rooms unavailable for required hours
- Student groups with no enrolled courses

### Data not persisting
- Ensure app has write permissions
- Check Hive initialization in `main.dart`
- Clear app data and restart if corrupted

### Build errors after updating dependencies
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing

### Backend Tests

```bash
cd server/tests
python -m unittest discover
```

Available tests:
- `test_availability.py` - Instructor availability constraints
- `test_lab_continuity.py` - Consecutive lab scheduling
- `test_faculty_break.py` - Break time handling
- `test_faculty_group_assignment.py` - Instructor-group assignments

### Frontend Tests

```bash
cd front-end/timely_ai
flutter test
```

## 📊 Performance

- **Small schedules** (< 20 courses): < 5 seconds
- **Medium schedules** (20-50 courses): 5-20 seconds
- **Large schedules** (50+ courses): May timeout or require constraint relaxation

## 🛣️ Roadmap

### High Priority
- [x] Configuration management for server URL
- [x] Local data persistence
- [x] Detailed constraint violation reporting
- [x] Update deprecated dependencies
- [ ] Authentication and multi-user support

### Medium Priority
- [ ] Schedule conflict visualization
- [ ] Manual schedule editing
- [ ] Schedule comparison and versioning
- [ ] Export to CSV/Excel
- [ ] Dark mode theme

### Low Priority
- [ ] Dashboard with statistics
- [ ] Undo/redo functionality
- [ ] Mobile-optimized UI
- [ ] Cloud backup

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👥 Authors

- **Your Name** - Initial work

## 🙏 Acknowledgments

- Google OR-Tools for constraint programming solver
- Flutter team for the amazing framework
- Contributors and testers

## 📞 Support

For issues and questions:
- **Issues**: [GitHub Issues](https://github.com/yourusername/Timely.AI/issues)
- **Email**: shashankhu2024@gmail.com
- **Documentation**: [Wiki](https://github.com/yourusername/Timely.AI/wiki)

---

**Made with ❤️ using Flutter and Python**
