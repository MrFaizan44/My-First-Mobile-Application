import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subject_model.dart';
import '../models/assignment_model.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';

/// Modal bottom sheet form for creating or editing course assignments & due dates
class AddAssignmentBottomSheet extends StatefulWidget {
  final SubjectModel? preselectedCourse;
  final AssignmentModel? initialAssignment;
  final VoidCallback onSaved;

  const AddAssignmentBottomSheet({
    super.key,
    this.preselectedCourse,
    this.initialAssignment,
    required this.onSaved,
  });

  static void show(
    BuildContext context, {
    SubjectModel? preselectedCourse,
    AssignmentModel? initialAssignment,
    required VoidCallback onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddAssignmentBottomSheet(
        preselectedCourse: preselectedCourse,
        initialAssignment: initialAssignment,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AddAssignmentBottomSheet> createState() =>
      _AddAssignmentBottomSheetState();
}

class _AddAssignmentBottomSheetState
    extends State<AddAssignmentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  List<SubjectModel> _courses = [];
  SubjectModel? _selectedCourse;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDueDate;
  late TimeOfDay _selectedDueTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialAssignment?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialAssignment?.description ?? '');

    if (widget.initialAssignment != null) {
      _selectedDueDate = widget.initialAssignment!.dueDate;
      _selectedDueTime = TimeOfDay.fromDateTime(widget.initialAssignment!.dueDate);
    } else {
      _selectedDueDate = DateTime.now().add(const Duration(days: 2));
      _selectedDueTime = const TimeOfDay(hour: 23, minute: 59);
    }

    _loadUserCourses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCourses() async {
    final courses = await DatabaseHelper.instance.getSubjects();
    if (mounted) {
      setState(() {
        _courses = courses;
        if (courses.isNotEmpty) {
          if (widget.initialAssignment != null) {
            _selectedCourse = courses.firstWhere(
              (c) => c.id == widget.initialAssignment!.courseId,
              orElse: () => courses[0],
            );
          } else if (widget.preselectedCourse != null) {
            _selectedCourse = courses.firstWhere(
              (c) => c.id == widget.preselectedCourse!.id,
              orElse: () => courses[0],
            );
          } else {
            _selectedCourse = courses[0];
          }
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _pickDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime,
    );
    if (picked != null) {
      setState(() {
        _selectedDueTime = picked;
      });
    }
  }

  Future<void> _saveAssignment() async {
    if (_formKey.currentState!.validate() && _selectedCourse != null) {
      final combinedDueDateTime = DateTime(
        _selectedDueDate.year,
        _selectedDueDate.month,
        _selectedDueDate.day,
        _selectedDueTime.hour,
        _selectedDueTime.minute,
      );

      final assignment = AssignmentModel(
        id: widget.initialAssignment?.id,
        courseId: _selectedCourse!.id!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: combinedDueDateTime,
        isCompleted: widget.initialAssignment?.isCompleted ?? false,
      );

      int assignmentId;
      if (widget.initialAssignment == null) {
        assignmentId =
            await DatabaseHelper.instance.insertAssignment(assignment);
      } else {
        await DatabaseHelper.instance.updateAssignment(assignment);
        assignmentId = assignment.id!;
      }

      // Schedule Android local notification reminder
      final fullAssignment = AssignmentModel(
        id: assignmentId,
        courseId: _selectedCourse!.id!,
        title: assignment.title,
        description: assignment.description,
        dueDate: combinedDueDateTime,
        isCompleted: assignment.isCompleted,
        courseCode: _selectedCourse!.code,
        courseName: _selectedCourse!.name,
      );

      await NotificationService.instance
          .scheduleAssignmentNotification(fullAssignment);

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
              'Please create at least one course on the Home Dashboard before adding assignments.',
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

    final formattedDateStr =
        DateFormat('EEE, MMM d, y').format(_selectedDueDate);

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
                    widget.initialAssignment == null
                        ? 'Add Course Assignment'
                        : 'Edit Assignment',
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

              // Course Selector Dropdown
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
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Assignment Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Assignment Title *',
                  hintText: 'e.g. Lab Report 2 or Problem Set 3',
                  prefixIcon: const Icon(Icons.assignment_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter assignment title'
                    : null,
              ),
              const SizedBox(height: 12),

              // Description / Instructions
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Instructions / Notes',
                  hintText: 'e.g. Submit PDF on portal, pages 45-50...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              // Due Date & Time Pickers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDueDate,
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text('Due: $formattedDateStr'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDueTime,
                      icon: const Icon(Icons.access_time_rounded, size: 18),
                      label: Text('Time: ${_selectedDueTime.format(context)}'),
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
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveAssignment,
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    widget.initialAssignment == null
                        ? 'Save & Set Reminder'
                        : 'Update Assignment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedCourse?.color ?? AppTheme.primaryColor,
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
