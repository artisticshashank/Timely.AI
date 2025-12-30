import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:timely_ai/config/app_config.dart';
import 'package:timely_ai/features/data_management/controller/timetable_controller.dart';

// Provider for the repository, making it easy to access from other parts of the app.
final timetableRepositoryProvider = Provider((ref) {
  return TimetableRepository(ref: ref);
});

class TimetableRepository {
  final Ref _ref;
  TimetableRepository({required Ref ref}) : _ref = ref;

  // This method sends the entire app state to the backend for solving.
  Future<Map<String, dynamic>> generateTimetable() async {
    // Use the server URL from configuration
    final String serverUrl = AppConfig.timetableGenerationUrl;

    // Get the current state (all our lists of data) from the HomeController.
    final homeState = _ref.read(homeControllerProvider);

    // Convert all the Dart data model objects into a JSON format that the Python server understands.
    final requestBody = jsonEncode({
      'instructors': homeState.instructors.map((e) => e.toJson()).toList(),
      'courses': homeState.courses.map((e) => e.toJson()).toList(),
      'rooms': homeState.rooms.map((e) => e.toJson()).toList(),
      'student_groups': homeState.studentGroups.map((e) => e.toJson()).toList(),

      'days': homeState.days,
      'timeslots': homeState.timeslots,
      'settings': homeState.settings,
    });

    try {
      final response = await http
          .post(
            Uri.parse(serverUrl),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(AppConfig.networkTimeout);

      if (response.statusCode == 200) {
        // If the server returns a success response, parse and return the data.
        return jsonDecode(response.body);
      } else {
        // If the server returns an error, parse the message and throw an exception.
        final errorData = jsonDecode(response.body);
        throw TimetableGenerationException(
          message: errorData['message'] ?? 'An unknown server error occurred.',
          details: errorData['details'],
        );
      }
    } on http.ClientException catch (e) {
      throw TimetableGenerationException(
        message: 'Network error: ${e.message}',
        details: 'Please check your internet connection and server URL in configuration.',
      );
    } on TimeoutException catch (_) {
      throw TimetableGenerationException(
        message: 'Request timeout',
        details: 'The server took too long to respond. Try simplifying the schedule or increasing timeout.',
      );
    } catch (e) {
      // Handle network errors (e.g., the server is not running).
      throw TimetableGenerationException(
        message: 'Failed to connect to the server',
        details: 'Please ensure the backend server is running at: $serverUrl',
      );
    }
  }
}

/// Custom exception for timetable generation errors
class TimetableGenerationException implements Exception {
  final String message;
  final String? details;

  TimetableGenerationException({
    required this.message,
    this.details,
  });

  @override
  String toString() {
    if (details != null) {
      return '$message\n\nDetails: $details';
    }
    return message;
  }
}
