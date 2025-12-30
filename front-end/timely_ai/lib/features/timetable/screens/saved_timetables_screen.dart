import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely_ai/features/data_management/controller/timetable_controller.dart';
import 'package:timely_ai/features/PDF_creation/pdf_generation_service.dart';
import 'package:timely_ai/features/timetable/screens/timetable_view_screen.dart';
import 'package:timely_ai/models/SavedTimetableModel.dart';
import 'package:timely_ai/shared/widgets/glass_card.dart';
import 'package:timely_ai/shared/widgets/saas_scaffold.dart';

class SavedTimetablesScreen extends ConsumerStatefulWidget {
  const SavedTimetablesScreen({super.key});

  @override
  ConsumerState<SavedTimetablesScreen> createState() => _SavedTimetablesScreenState();
}

class _SavedTimetablesScreenState extends ConsumerState<SavedTimetablesScreen> {
  List<SavedTimetable> _savedTimetables = [];

  @override
  void initState() {
    super.initState();
    _loadTimetables();
  }

  void _loadTimetables() {
    final storage = ref.read(storageServiceProvider);
    setState(() {
      _savedTimetables = storage.loadSavedTimetables();
      // Sort by date, newest first
      _savedTimetables.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _viewTimetable(SavedTimetable timetable) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimetableViewScreen(
          schedule: timetable.schedule,
          savedTimetableName: timetable.name,
        ),
      ),
    );
  }

  void _deleteTimetable(SavedTimetable timetable) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timetable'),
        content: Text('Are you sure you want to delete "${timetable.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = ref.read(storageServiceProvider);
              await storage.deleteTimetable(timetable.id);
              Navigator.of(context).pop();
              _loadTimetables();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted "${timetable.name}"')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _renameTimetable(SavedTimetable timetable) {
    final controller = TextEditingController(text: timetable.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Timetable'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Timetable Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
                return;
              }
              final storage = ref.read(storageServiceProvider);
              final updated = timetable.copyWith(name: controller.text.trim());
              await storage.updateTimetable(updated);
              Navigator.of(context).pop();
              _loadTimetables();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Timetable renamed')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exportToPdf(SavedTimetable timetable) {
    final homeState = ref.read(homeControllerProvider);
    PdfGenerator.generateAndPreview(
      schedule: timetable.schedule,
      courses: homeState.courses,
      instructors: homeState.instructors,
      subtitle: 'Saved: ${DateFormat('MMM dd, yyyy').format(timetable.createdAt)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SaaSScaffold(
      title: 'Saved Timetables',
      body: _savedTimetables.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Saved Timetables',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate a timetable and save it for later',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedTimetables.length,
              itemBuilder: (context, index) {
                final timetable = _savedTimetables[index];
                final classCount = timetable.schedule.length;
                final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.blue[700],
                      ),
                    ),
                    title: Text(
                      timetable.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(timetable.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (timetable.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            timetable.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          '$classCount classes scheduled',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            _viewTimetable(timetable);
                            break;
                          case 'rename':
                            _renameTimetable(timetable);
                            break;
                          case 'export':
                            _exportToPdf(timetable);
                            break;
                          case 'delete':
                            _deleteTimetable(timetable);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 8),
                              Text('View'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'rename',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Rename'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'export',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, size: 20),
                              SizedBox(width: 8),
                              Text('Export PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _viewTimetable(timetable),
                  ),
                );
              },
            ),
    );
  }
}
