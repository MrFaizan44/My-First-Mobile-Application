import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../models/assignment_model.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/assignment_card.dart';
import '../widgets/add_assignment_bottom_sheet.dart';

/// Assignments & Due Dates Tab for StudyTasker
class AssignmentsView extends StatefulWidget {
  const AssignmentsView({super.key});

  @override
  State<AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<AssignmentsView> {
  List<AssignmentModel> _assignments = [];
  List<SubjectModel> _courses = [];
  SubjectModel? _selectedCourseFilter;
  String _selectedStatusFilter = 'Pending'; // 'All', 'Pending', 'Completed'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignmentsAndCourses();
  }

  Future<void> _loadAssignmentsAndCourses() async {
    setState(() => _isLoading = true);

    final courses = await DatabaseHelper.instance.getSubjects();
    final assignments = await DatabaseHelper.instance.getAssignments(
      courseId: _selectedCourseFilter?.id,
      pendingOnly: _selectedStatusFilter == 'Pending' ? true : null,
    );

    if (mounted) {
      setState(() {
        _courses = courses;
        _assignments = assignments;
        _isLoading = false;
      });
    }
  }

  void _openAddAssignmentModal({AssignmentModel? assignment}) {
    AddAssignmentBottomSheet.show(
      context,
      preselectedCourse: _selectedCourseFilter,
      initialAssignment: assignment,
      onSaved: _loadAssignmentsAndCourses,
    );
  }

  Future<void> _toggleAssignmentCompletion(
      AssignmentModel assignment, bool? isCompleted) async {
    final updated = AssignmentModel(
      id: assignment.id,
      courseId: assignment.courseId,
      title: assignment.title,
      description: assignment.description,
      dueDate: assignment.dueDate,
      isCompleted: isCompleted ?? false,
    );

    await DatabaseHelper.instance.updateAssignment(updated);

    if (updated.isCompleted && assignment.id != null) {
      await NotificationService.instance.cancelNotification(assignment.id!);
    } else {
      await NotificationService.instance
          .scheduleAssignmentNotification(updated);
    }

    _loadAssignmentsAndCourses();
  }

  Future<void> _confirmDeleteAssignment(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Assignment?'),
        content: const Text(
            'Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await DatabaseHelper.instance.deleteAssignment(id);
              await NotificationService.instance.cancelNotification(id);
              _loadAssignmentsAndCourses();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAssignments = _assignments.where((a) {
      if (_selectedStatusFilter == 'Pending') return !a.isCompleted;
      if (_selectedStatusFilter == 'Completed') return a.isCompleted;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Course Assignments'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                // Status Filter Segment
                Row(
                  children: ['Pending', 'Completed', 'All'].map((status) {
                    final bool isSelected = _selectedStatusFilter == status;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Center(
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: AppTheme.backgroundColor,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedStatusFilter = status;
                              });
                              _loadAssignmentsAndCourses();
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Course Filter Chips
                if (_courses.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Courses'),
                          selected: _selectedCourseFilter == null,
                          selectedColor: AppTheme.primaryColor,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedCourseFilter == null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedCourseFilter == null
                                ? Colors.white
                                : AppTheme.textPrimary,
                          ),
                          onSelected: (val) {
                            setState(() {
                              _selectedCourseFilter = null;
                            });
                            _loadAssignmentsAndCourses();
                          },
                        ),
                        const SizedBox(width: 8),
                        ..._courses.map((course) {
                          final bool isSelected =
                              _selectedCourseFilter?.id == course.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(course.code),
                              selected: isSelected,
                              selectedColor: course.color,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                              onSelected: (val) {
                                setState(() {
                                  _selectedCourseFilter = val ? course : null;
                                });
                                _loadAssignmentsAndCourses();
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Assignments List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAssignments.isEmpty
                    ? _buildEmptyAssignmentsState()
                    : RefreshIndicator(
                        onRefresh: _loadAssignmentsAndCourses,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredAssignments.length,
                          itemBuilder: (context, index) {
                            final assignment = filteredAssignments[index];
                            return AssignmentCard(
                              assignment: assignment,
                              onToggleComplete: (val) =>
                                  _toggleAssignmentCompletion(assignment, val),
                              onEdit: () =>
                                  _openAddAssignmentModal(assignment: assignment),
                              onDelete: () =>
                                  _confirmDeleteAssignment(assignment.id!),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddAssignmentModal(),
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text(
          'Add Assignment',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAssignmentsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _selectedStatusFilter == 'Completed'
                  ? 'No Completed Assignments'
                  : 'No Pending Assignments',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "+ Add Assignment" below to track coursework, set due dates, and receive Android notification reminders.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
