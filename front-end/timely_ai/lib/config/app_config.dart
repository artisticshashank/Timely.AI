/// Application configuration settings
class AppConfig {
  // Server URL configuration
  // Change this to your backend server URL
  // For local development:
  //   - Android Emulator: http://10.0.2.2:5000
  //   - iOS Simulator: http://localhost:5000
  //   - Physical device: http://YOUR_LOCAL_IP:5000
  //   - Web/Desktop: http://localhost:5000
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'http://localhost:5000',
  );

  static const String generateTimetableEndpoint = '/generate-timetable';

  /// Get the full API URL for timetable generation
  static String get timetableGenerationUrl =>
      '$serverUrl$generateTimetableEndpoint';

  // Timeout configurations
  static const Duration networkTimeout = Duration(seconds: 60);
  static const Duration solverTimeout = Duration(seconds: 30);

  // App metadata
  static const String appName = 'Timely.AI';
  static const String appVersion = '1.0.0';

  // Default days for timetable
  static const List<String> defaultDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Default timeslots for timetable
  static const List<String> defaultTimeslots = [
    '08:30 AM - 09:30 AM',
    '09:30 AM - 10:30 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
  ];

  // Storage keys for local persistence
  static const String storageKeyInstructors = 'instructors';
  static const String storageKeyCourses = 'courses';
  static const String storageKeyRooms = 'rooms';
  static const String storageKeyStudentGroups = 'student_groups';
  static const String storageKeySettings = 'settings';
  static const String storageKeyLastSchedule = 'last_schedule';
}
