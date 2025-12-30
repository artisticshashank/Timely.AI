import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely_ai/config/app_config.dart';
import 'package:timely_ai/models/CourseModel.dart';
import 'package:timely_ai/models/InstructorModel.dart';
import 'package:timely_ai/models/RoomModel.dart';
import 'package:timely_ai/models/StudentGroupModel.dart';
import 'package:timely_ai/services/storage_service.dart';

// The state class that holds all our application data.
class HomeState {
  final List<Instructor> instructors;
  final List<Course> courses;
  final List<Room> rooms;
  final List<StudentGroup> studentGroups;
  final List<String> days;
  final List<String> timeslots;
  final Map<String, dynamic> settings;
  final List<Map<String, dynamic>> lastGeneratedSchedule;

  HomeState({
    required this.instructors,
    required this.courses,
    required this.rooms,
    required this.studentGroups,
    required this.days,
    required this.timeslots,
    this.settings = const {},
    this.lastGeneratedSchedule = const [],
  });

  // A copyWith method to easily create a new state object with updated values.
  HomeState copyWith({
    List<Instructor>? instructors,
    List<Course>? courses,
    List<Room>? rooms,
    List<StudentGroup>? studentGroups,
    Map<String, dynamic>? settings,
    List<Map<String, dynamic>>? lastGeneratedSchedule,
  }) {
    return HomeState(
      instructors: instructors ?? this.instructors,
      courses: courses ?? this.courses,
      rooms: rooms ?? this.rooms,
      studentGroups: studentGroups ?? this.studentGroups,
      days: days,
      timeslots: timeslots,
      settings: settings ?? this.settings,
      lastGeneratedSchedule: lastGeneratedSchedule ?? this.lastGeneratedSchedule,
    );
  }
}

// The Notifier class that manages our HomeState.
class HomeController extends Notifier<HomeState> {
  final StorageService _storage;

  HomeController(this._storage);

  @override
  HomeState build() {
    // Initializes the state with data from storage or defaults.
    // Try to load from storage first
    final instructors = _storage.loadInstructors();
    final courses = _storage.loadCourses();
    final rooms = _storage.loadRooms();
    final studentGroups = _storage.loadStudentGroups();
    final settings = _storage.loadSettings();
    final lastSchedule = _storage.loadLastSchedule();

    return HomeState(
      instructors: instructors,
      courses: courses,
      rooms: rooms,
      studentGroups: studentGroups,
      days: AppConfig.defaultDays,
      timeslots: AppConfig.defaultTimeslots,
      settings: settings,
      lastGeneratedSchedule: lastSchedule,
    );
  }

  // --- METHODS FOR INSTRUCTOR MANIPULATION ---
  void addInstructor(Instructor instructor) {
    state = state.copyWith(instructors: [...state.instructors, instructor]);
    _storage.saveInstructors(state.instructors);
  }

  void updateInstructor(Instructor updatedInstructor) {
    state = state.copyWith(
      instructors: [
        for (final instructor in state.instructors)
          if (instructor.id == updatedInstructor.id)
            updatedInstructor
          else
            instructor,
      ],
    );
    _storage.saveInstructors(state.instructors);
  }

  void deleteInstructor(int index) {
    final newList = List<Instructor>.from(state.instructors)..removeAt(index);
    state = state.copyWith(instructors: newList);
    _storage.saveInstructors(state.instructors);
  }

  // --- METHODS FOR COURSE MANIPULATION ---
  void addCourse(Course course) {
    state = state.copyWith(courses: [...state.courses, course]);
    _storage.saveCourses(state.courses);
  }

  void updateCourse(Course updatedCourse) {
    state = state.copyWith(
      courses: [
        for (final course in state.courses)
          if (course.id == updatedCourse.id) updatedCourse else course,
      ],
    );
    _storage.saveCourses(state.courses);
  }

  void deleteCourse(int index) {
    final newList = List<Course>.from(state.courses)..removeAt(index);
    state = state.copyWith(courses: newList);
    _storage.saveCourses(state.courses);
  }

  // --- METHODS FOR ROOM MANIPULATION ---
  void addRoom(Room room) {
    state = state.copyWith(rooms: [...state.rooms, room]);
    _storage.saveRooms(state.rooms);
  }

  void updateRoom(Room updatedRoom) {
    state = state.copyWith(
      rooms: [
        for (final room in state.rooms)
          if (room.id == updatedRoom.id) updatedRoom else room,
      ],
    );
    _storage.saveRooms(state.rooms);
  }

  void deleteRoom(int index) {
    final newList = List<Room>.from(state.rooms)..removeAt(index);
    state = state.copyWith(rooms: newList);
    _storage.saveRooms(state.rooms);
  }

  // --- METHODS FOR STUDENT GROUP MANIPULATION ---
  void addStudentGroup(StudentGroup group) {
    state = state.copyWith(studentGroups: [...state.studentGroups, group]);
    _storage.saveStudentGroups(state.studentGroups);
  }

  void updateStudentGroup(StudentGroup updatedGroup) {
    state = state.copyWith(
      studentGroups: [
        for (final group in state.studentGroups)
          if (group.id == updatedGroup.id) updatedGroup else group,
      ],
    );
    _storage.saveStudentGroups(state.studentGroups);
  }

  void deleteStudentGroup(int index) {
    final newList = List<StudentGroup>.from(state.studentGroups)
      ..removeAt(index);
    state = state.copyWith(studentGroups: newList);
    _storage.saveStudentGroups(state.studentGroups);
  }

  // --- METHODS FOR SETTINGS MANIPULATION ---
  void updateSettings(Map<String, dynamic> newSettings) {
    state = state.copyWith(settings: newSettings);
    _storage.saveSettings(state.settings);
  }

  // --- METHODS FOR SCHEDULE MANAGEMENT ---
  void saveGeneratedSchedule(List<Map<String, dynamic>> schedule) {
    state = state.copyWith(lastGeneratedSchedule: schedule);
    _storage.saveLastSchedule(schedule);
  }

  List<Map<String, dynamic>> getLastGeneratedSchedule() {
    return state.lastGeneratedSchedule;
  }

  bool hasGeneratedSchedule() {
    return state.lastGeneratedSchedule.isNotEmpty;
  }
}

// Provider for storage service
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in ProviderScope');
});

// The provider that makes the HomeController available throughout the app.
final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  () {
    throw UnimplementedError('HomeController must be overridden in ProviderScope');
  },
);
