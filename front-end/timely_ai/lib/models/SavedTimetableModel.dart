import 'package:uuid/uuid.dart';

class SavedTimetable {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<Map<String, dynamic>> schedule;
  final String? description;

  SavedTimetable({
    String? id,
    required this.name,
    DateTime? createdAt,
    required this.schedule,
    this.description,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'schedule': schedule,
      'description': description,
    };
  }

  factory SavedTimetable.fromJson(Map<String, dynamic> json) {
    return SavedTimetable(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      schedule: List<Map<String, dynamic>>.from(
        (json['schedule'] as List).map((item) => Map<String, dynamic>.from(item)),
      ),
      description: json['description'] as String?,
    );
  }

  SavedTimetable copyWith({
    String? name,
    String? description,
  }) {
    return SavedTimetable(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      schedule: schedule,
      description: description ?? this.description,
    );
  }
}
