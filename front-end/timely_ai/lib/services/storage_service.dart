import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timely_ai/config/app_config.dart';
import 'package:timely_ai/models/CourseModel.dart';
import 'package:timely_ai/models/InstructorModel.dart';
import 'package:timely_ai/models/RoomModel.dart';
import 'package:timely_ai/models/StudentGroupModel.dart';
import 'package:timely_ai/models/SavedTimetableModel.dart';

/// Service for managing local data persistence using Hive
class StorageService {
  static const String _boxName = 'timelyAIBox';
  late Box _box;

  /// Initialize Hive and open the storage box
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Save instructors to local storage
  Future<void> saveInstructors(List<Instructor> instructors) async {
    final jsonList = instructors.map((i) => jsonEncode(i.toJson())).toList();
    await _box.put(AppConfig.storageKeyInstructors, jsonList);
  }

  /// Load instructors from local storage
  List<Instructor> loadInstructors() {
    final jsonList = _box.get(AppConfig.storageKeyInstructors, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => _instructorFromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Save courses to local storage
  Future<void> saveCourses(List<Course> courses) async {
    final jsonList = courses.map((c) => jsonEncode(c.toJson())).toList();
    await _box.put(AppConfig.storageKeyCourses, jsonList);
  }

  /// Load courses from local storage
  List<Course> loadCourses() {
    final jsonList = _box.get(AppConfig.storageKeyCourses, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => _courseFromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Save rooms to local storage
  Future<void> saveRooms(List<Room> rooms) async {
    final jsonList = rooms.map((r) => jsonEncode(r.toJson())).toList();
    await _box.put(AppConfig.storageKeyRooms, jsonList);
  }

  /// Load rooms from local storage
  List<Room> loadRooms() {
    final jsonList = _box.get(AppConfig.storageKeyRooms, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => _roomFromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Save student groups to local storage
  Future<void> saveStudentGroups(List<StudentGroup> groups) async {
    final jsonList = groups.map((g) => jsonEncode(g.toJson())).toList();
    await _box.put(AppConfig.storageKeyStudentGroups, jsonList);
  }

  /// Load student groups from local storage
  List<StudentGroup> loadStudentGroups() {
    final jsonList = _box.get(AppConfig.storageKeyStudentGroups, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => _studentGroupFromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Save settings to local storage
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _box.put(AppConfig.storageKeySettings, settings);
  }

  /// Load settings from local storage
  Map<String, dynamic> loadSettings() {
    final settings = _box.get(AppConfig.storageKeySettings, defaultValue: <String, dynamic>{});
    return Map<String, dynamic>.from(settings);
  }

  /// Save the last generated schedule
  Future<void> saveLastSchedule(List<Map<String, dynamic>> schedule) async {
    final jsonList = schedule.map((s) => jsonEncode(s)).toList();
    await _box.put(AppConfig.storageKeyLastSchedule, jsonList);
  }

  /// Load the last generated schedule
  List<Map<String, dynamic>> loadLastSchedule() {
    final jsonList = _box.get(AppConfig.storageKeyLastSchedule, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => Map<String, dynamic>.from(jsonDecode(jsonStr)))
        .toList();
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Check if data exists
  bool hasStoredData() {
    return _box.isNotEmpty;
  }

  // ========== SAVED TIMETABLES MANAGEMENT ==========

  static const String _savedTimetablesKey = 'saved_timetables';

  /// Save a timetable with a name
  Future<void> saveTimetable(SavedTimetable timetable) async {
    final savedTimetables = loadSavedTimetables();
    savedTimetables.add(timetable);
    final jsonList = savedTimetables.map((t) => jsonEncode(t.toJson())).toList();
    await _box.put(_savedTimetablesKey, jsonList);
  }

  /// Load all saved timetables
  List<SavedTimetable> loadSavedTimetables() {
    final jsonList = _box.get(_savedTimetablesKey, defaultValue: <String>[]) as List<dynamic>;
    return jsonList
        .map((jsonStr) => SavedTimetable.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  /// Get a specific saved timetable by ID
  SavedTimetable? getSavedTimetable(String id) {
    final savedTimetables = loadSavedTimetables();
    try {
      return savedTimetables.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update a saved timetable
  Future<void> updateTimetable(SavedTimetable timetable) async {
    final savedTimetables = loadSavedTimetables();
    final index = savedTimetables.indexWhere((t) => t.id == timetable.id);
    if (index != -1) {
      savedTimetables[index] = timetable;
      final jsonList = savedTimetables.map((t) => jsonEncode(t.toJson())).toList();
      await _box.put(_savedTimetablesKey, jsonList);
    }
  }

  /// Delete a saved timetable
  Future<void> deleteTimetable(String id) async {
    final savedTimetables = loadSavedTimetables();
    savedTimetables.removeWhere((t) => t.id == id);
    final jsonList = savedTimetables.map((t) => jsonEncode(t.toJson())).toList();
    await _box.put(_savedTimetablesKey, jsonList);
  }

  /// Get count of saved timetables
  int getSavedTimetablesCount() {
    return loadSavedTimetables().length;
  }

  // Helper methods to reconstruct model objects from JSON

  Instructor _instructorFromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as String,
      name: json['name'] as String,
      availability: Map<String, List<int>>.from(
        (json['availability'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<int>.from(value)),
        ),
      ),
    );
  }

  Course _courseFromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      lectureHours: json['lectureHours'] as int,
      labHours: json['labHours'] as int,
      qualifiedInstructors: List<String>.from(json['qualifiedInstructors']),
      equipment: List<String>.from(json['equipment'] ?? []),
      credits: json['credits'] as int? ?? 4,
      ltp: json['ltp'] as String? ?? '3-0-2',
      labType: json['labType'] as String? ?? 'Computer Lab',
    );
  }

  Room _roomFromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      capacity: json['capacity'] as int,
      type: json['type'] as String,
      equipment: List<String>.from(json['equipment'] ?? []),
    );
  }

  StudentGroup _studentGroupFromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'] as String,
      size: json['size'] as int,
      enrolledCourses: List<String>.from(json['enrolledCourses']),
      instructorPreferences: Map<String, String>.from(json['instructorPreferences'] ?? {}),
      availability: Map<String, List<int>>.from(
        (json['availability'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<int>.from(value)),
        ),
      ),
    );
  }
}
