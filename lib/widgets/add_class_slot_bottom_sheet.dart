import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../models/schedule_block_model.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';

/// Modal Bottom Sheet form for creating or editing user timetable class slots
class AddClassSlotBottomSheet extends StatefulWidget {
  final int defaultDayOfWeek;
  final ScheduleBlockModel? initialBlock;
  final VoidCallback onSaved;

  const AddClassSlotBottomSheet({
    super.key,
    required this.defaultDayOfWeek,
    this.initialBlock,
    required this.onSaved,
  });

  static void show(
    BuildContext context, {
    required int defaultDayOfWeek,
    ScheduleBlockModel? initialBlock,
    required VoidCallback onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddClassSlotBottomSheet(
        defaultDayOfWeek: defaultDayOfWeek,
        initialBlock: initialBlock,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AddClassSlotBottomSheet> createState() =>
      _AddClassSlotBottomSheetState();
}

class _AddClassSlotBottomSheetState extends State<AddClassSlotBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  List<SubjectModel> _courses = [];
  SubjectModel? _selectedCourse;
  late int _selectedDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 30);
  final TextEditingController _roomController = TextEditingController();
  bool _isLoading = true;

  final List<Map<String, dynamic>> _days = const [
    {'name': 'Monday', 'value': 1},
    {'name': 'Tuesday', 'value': 2},
    {'name': 'Wednesday', 'value': 3},
    {'name': 'Thursday', 'value': 4},
    {'name': 'Friday', 'value': 5},
    {'name': 'Saturday', 'value': 6},
    {'name': 'Sunday', 'value': 7},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialBlock?.dayOfWeek ?? widget.defaultDayOfWeek;
    _roomController.text = widget.initialBlock?.room ?? '';
    _loadUserCourses();
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCourses() async {
    final courses = await DatabaseHelper.instance.getSubjects();
    if (mounted) {
      setState(() {
        _courses = courses;
        if (courses.isNotEmpty) {
          if (widget.initialBlock != null) {
            _selectedCourse = courses.firstWhere(
              (c) => c.id == widget.initialBlock!.subjectId,
              orElse: () => courses[0],
            );
          } else {
            _selectedCourse = courses[0];
            if (_roomController.text.isEmpty) {
              _roomController.text = _selectedCourse!.location;
            }
          }
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveClassSlot() async {
    if (_formKey.currentState!.validate() && _selectedCourse != null) {
      final block = ScheduleBlockModel(
        id: widget.initialBlock?.id,
        subjectId: _selectedCourse!.id!,
        dayOfWeek: _selectedDay,
        startTime: _startTime.format(context),
        endTime: _endTime.format(context),
        room: _roomController.text.trim(),
      );

      if (widget.initialBlock == null) {
        await DatabaseHelper.instance.insertScheduleBlock(block);
      } else {
        await DatabaseHelper.instance.updateScheduleBlock(block);
      }

      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (_isLoading) {
      return Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_courses.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No Courses Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Please add at least one course on the Home Dashboard before creating class timetable slots.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialBlock == null
                        ? 'Add Class Slot'
                        : 'Edit Class Slot',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Course Selection Dropdown
              DropdownButtonFormField<SubjectModel>(
                initialValue: _selectedCourse,
                decoration: InputDecoration(
                  labelText: 'Select Course *',
                  prefixIcon: const Icon(Icons.book_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                items: _courses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: course.color, radius: 6),
                        const SizedBox(width: 8),
                        Text('${course.code} - ${course.name}',
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCourse = val;
                      if (_roomController.text.isEmpty) {
                        _roomController.text = val.location;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Day of Week Dropdown
              DropdownButtonFormField<int>(
                initialValue: _selectedDay,
                decoration: InputDecoration(
                  labelText: 'Day of Week *',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                items: _days.map((day) {
                  return DropdownMenuItem<int>(
                    value: day['value'] as int,
                    child: Text(day['name'] as String),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedDay = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Time Range Pickers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(true),
                      icon: const Icon(Icons.access_time_rounded, size: 18),
                      label: Text('Start: ${_startTime.format(context)}'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(false),
                      icon: const Icon(Icons.access_time_filled_rounded, size: 18),
                      label: Text('End: ${_endTime.format(context)}'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Specific Room Number or Meeting Link
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(
                  labelText: 'Room Number / Online Link',
                  hintText: 'e.g. Room 302 or Zoom / Meet Link',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveClassSlot,
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    widget.initialBlock == null
                        ? 'Add to Schedule'
                        : 'Save Class Slot',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCourse?.color ?? AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
