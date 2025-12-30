import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely_ai/features/PDF_creation/pdf_generation_service.dart';
import 'package:timely_ai/features/data_management/controller/timetable_controller.dart';
import 'package:timely_ai/features/timetable/screens/saved_timetables_screen.dart';
import 'package:timely_ai/models/SavedTimetableModel.dart';
import 'package:timely_ai/shared/widgets/glass_card.dart';
import 'package:timely_ai/shared/widgets/saas_scaffold.dart';

class TimetableViewScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> schedule;
  final String? savedTimetableName;

  const TimetableViewScreen({
    super.key,
    required this.schedule,
    this.savedTimetableName,
  });

  @override
  ConsumerState<TimetableViewScreen> createState() =>
      _TimetableViewScreenState();
}

class _TimetableViewScreenState extends ConsumerState<TimetableViewScreen> {
  String _filterType = 'Show All'; // Show All, Instructor, Room, Student Group
  String? _selectedFilterValue;
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final List<String> _timeSlots = [
    '08:30 AM - 09:30 AM',
    '09:30 AM - 10:30 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
  ];

  void _saveTimetable(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1E293B).withOpacity(0.95),
                const Color(0xFF0F172A).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[600]!, Colors.green[800]!],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save Timetable',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Store this timetable for future access',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Name field
                const Text(
                  'Timetable Name *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'e.g., Fall 2025 Semester',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[400]!, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.label_outline,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description field
                const Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Add notes about this timetable...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[400]!, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12),
                      child: Icon(
                        Icons.notes_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Save button
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter a timetable name'),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        final storage = ref.read(storageServiceProvider);
                        final savedTimetable = SavedTimetable(
                          name: nameController.text.trim(),
                          schedule: widget.schedule,
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        );

                        await storage.saveTimetable(savedTimetable);
                        
                        if (mounted) {
                          Navigator.of(context).pop();
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text('Saved "${savedTimetable.name}"'),
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 5),
                              backgroundColor: Colors.green[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: 'View All',
                                textColor: Colors.white,
                                onPressed: () {
                                  // Close the snackbar first
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  // Navigate to saved timetables
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const SavedTimetablesScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text(
                        'Save Timetable',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[600],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Extract unique values for filters
    final instructors =
        widget.schedule.map((e) => e['instructor'] as String).toSet().toList()
          ..sort();
    final rooms =
        widget.schedule.map((e) => e['room'] as String).toSet().toList()
          ..sort();

    // For groups, we need to handle the comma-separated strings
    final Set<String> uniqueGroups = {};
    for (var item in widget.schedule) {
      final groupStr = item['group'] as String;
      if (groupStr.contains(',')) {
        final parts = groupStr.split(',').map((e) => e.trim()).toList();
        uniqueGroups.addAll(parts);
      } else {
        uniqueGroups.add(groupStr);
      }
    }
    final groups = uniqueGroups.toList()..sort();

    // 2. Filter the schedule
    List<Map<String, dynamic>> filteredSchedule = widget.schedule;
    if (_filterType != 'Show All' && _selectedFilterValue != null) {
      if (_selectedFilterValue != 'All') {
        filteredSchedule = widget.schedule.where((item) {
          if (_filterType == 'Instructor') {
            return item['instructor'] == _selectedFilterValue;
          } else if (_filterType == 'Room') {
            return item['room'] == _selectedFilterValue;
          } else if (_filterType == 'Student Group') {
            // Check if the item's group string contains the selected group
            final groupString = item['group'].toString();
            return groupString.contains(_selectedFilterValue!);
          }
          return true;
        }).toList();
      }
    }

    return SaaSScaffold(
      title: widget.savedTimetableName ?? 'Generated Timetable',
      actions: [
        if (widget.savedTimetableName == null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => _saveTimetable(context),
              icon: const Icon(Icons.save, size: 18, color: Colors.white),
              label: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              final homeState = ref.read(homeControllerProvider);
              PdfGenerator.generateAndPreview(
                schedule: filteredSchedule,
                courses: homeState.courses,
                instructors: homeState.instructors,
                subtitle:
                    _filterType != 'Show All' && _selectedFilterValue != null
                    ? '$_filterType: $_selectedFilterValue'
                    : '',
              );
            },
            icon: const Icon(Icons.download, size: 18, color: Colors.black),
            label: const Text(
              'Export PDF',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
      body: Column(
        children: [
          // Filters Section
          GlassCard(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Filter By Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter by:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _filterType,
                            dropdownColor: const Color(0xFF1A1A1A),
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items:
                                [
                                  'Show All',
                                  'Instructor',
                                  'Room',
                                  'Student Group',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _filterType = newValue!;
                                _selectedFilterValue = 'All';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Select Value Dropdown
                if (_filterType != 'Show All')
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select $_filterType:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedFilterValue,
                              dropdownColor: const Color(0xFF1A1A1A),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items:
                                  [
                                    'All',
                                    if (_filterType == 'Instructor')
                                      ...instructors,
                                    if (_filterType == 'Room') ...rooms,
                                    if (_filterType == 'Student Group')
                                      ...groups,
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedFilterValue = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_filterType == 'Show All') const Spacer(),
              ],
            ),
          ),

          // Timetable Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Column
                  Column(
                    children: [
                      const SizedBox(height: 50), // Header offset
                      ..._timeSlots.map(
                        (time) => Container(
                          height: 130,
                          width: 140,
                          padding: const EdgeInsets.only(right: 16, top: 16),
                          child: Text(
                            time,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Days Columns
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _days.map((day) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                // Day Header
                                Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Slots
                                ..._timeSlots.map((time) {
                                  // Find class for this slot
                                  final classInfo = filteredSchedule.firstWhere(
                                    (element) =>
                                        element['day'] == day &&
                                        element['timeslot'] == time,
                                    orElse: () => {},
                                  );

                                  if (classInfo.isEmpty) {
                                    return Container(
                                      height: 130,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white10,
                                        ),
                                      ),
                                    );
                                  }

                                  final isLab = classInfo['type'] == 'lab';

                                  return Container(
                                    height: 130,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isLab
                                          ? const Color(0xFF7F00FF).withOpacity(
                                              0.2,
                                            ) // Neon Violet
                                          : const Color(
                                              0xFF00C6FF,
                                            ).withOpacity(0.2), // Neon Cyan
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isLab
                                            ? const Color(
                                                0xFF7F00FF,
                                              ).withOpacity(0.5)
                                            : const Color(
                                                0xFF00C6FF,
                                              ).withOpacity(0.5),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          classInfo['course'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          classInfo['instructor'],
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 10,
                                              color: isLab
                                                  ? const Color(0xFF7F00FF)
                                                  : const Color(0xFF00C6FF),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              classInfo['room'],
                                              style: const TextStyle(
                                                color: Colors.white60,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.groups,
                                              size: 10,
                                              color: Colors.white60,
                                            ),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                classInfo['group'],
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
