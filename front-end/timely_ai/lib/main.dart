import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely_ai/features/data_management/controller/timetable_controller.dart';
import 'package:timely_ai/features/home/screens/home_screen.dart';
import 'package:timely_ai/services/storage_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = StorageService();
  await storage.initialize();

  // ProviderScope is the widget that stores the state of all your providers.
  // It must be at the root of your application.
  runApp(
    ProviderScope(
      overrides: [
        // Override the storage service provider with the initialized instance
        storageServiceProvider.overrideWithValue(storage),
        // Override the controller provider
        homeControllerProvider.overrideWith(() => HomeController(storage)),
      ],
      child: const TimelyAIApp(),
    ),
  );
}

class TimelyAIApp extends StatelessWidget {
  const TimelyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timely.AI',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

