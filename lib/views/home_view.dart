import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject_model.dart';
import '../models/schedule_block_model.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_card.dart';
import '../widgets/timeline_schedule_card.dart';
import '../widgets/add_course_bottom_sheet.dart';
import '../widgets/course_details_bottom_sheet.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/study_tasker_logo.dart';

/// Home Dashboard Tab for StudyTasker
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _studentName = 'Alex Rivers';
  List<SubjectModel> _courses = [];
  List<ScheduleBlockModel> _todaySchedule = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('student_name') ?? 'Alex Rivers';

    final courses = await DatabaseHelper.instance.getSubjects();
    final todayWeekday = DateTime.now().weekday; // 1 = Mon, 7 = Sun
    final todaySchedule =
        await DatabaseHelper.instance.getScheduleBlocksForDay(todayWeekday);

    if (mounted) {
      setState(() {
        _studentName = savedName;
        _courses = courses;
        _todaySchedule = todaySchedule;
        _isLoading = false;
      });
    }
  }

  void _openAddCourseModal({SubjectModel? course}) {
    AddCourseBottomSheet.show(
      context,
      initialCourse: course,
      onSaved: _loadDashboardData,
    );
  }

  void _openCourseDetails(SubjectModel course) {
    CourseDetailsBottomSheet.show(
      context,
      course: course,
      onEdit: () => _openAddCourseModal(course: course),
      onDelete: () => _confirmDeleteCourse(course.id!),
    );
  }

  void _openEditProfileDialog() {
    EditProfileDialog.show(
      context,
      currentName: _studentName,
      onSaved: _loadDashboardData,
    );
  }

  Future<void> _confirmDeleteCourse(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Course?'),
        content: const Text(
            'Are you sure you want to delete this course and its schedule blocks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await DatabaseHelper.instance.deleteSubject(id);
              _loadDashboardData();
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
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const StudyTaskerLogo(size: 26),
        actions: [
          // Quick Dark Mode Toggle Button
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                themeController.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                key: ValueKey<bool>(themeController.isDark),
                color: themeController.isDark ? Colors.amber : AppTheme.primaryColor,
              ),
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => themeController.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Personalized Header Card with Student Avatar & Dark Mode Toggle
                    Card(
                      elevation: 2,
                      color: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _openEditProfileDialog,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      _getInitials(_studentName),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppTheme.brandIndigo,
                                      child: const Icon(Icons.edit_rounded,
                                          size: 10, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Hello, $_studentName 👋',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.edit_note_rounded,
                                            color: Colors.white70,
                                            size: 22),
                                        onPressed: _openEditProfileDialog,
                                        tooltip: 'Edit Name',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_courses.length} Enrolled Courses • ${todayScheduleText(_todaySchedule.length)}',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. Section Header: My Courses & Prominent + Add Course Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Courses (${_courses.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _openAddCourseModal(),
                          icon: const Icon(Icons.add_rounded,
                              size: 20, color: Colors.white),
                          label: const Text(
                            'Add Course',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandIndigo,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 3. Grid View displaying user-added courses
                    if (_courses.isEmpty)
                      _buildEmptyStateCard(
                        icon: Icons.menu_book_rounded,
                        title: 'No Courses Added Yet',
                        message:
                            'Tap the "+ Add Course" button above to create your courses with custom color themes!',
                        actionLabel: '+ Add Course',
                        onAction: () => _openAddCourseModal(),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return SubjectCard(
                            subject: course,
                            onTap: () => _openCourseDetails(course),
                            onEdit: () => _openAddCourseModal(course: course),
                            onDelete: () => _confirmDeleteCourse(course.id!),
                          );
                        },
                      ),

                    const SizedBox(height: 28),

                    // 4. Quick Summary Section: Today's Schedule
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today\'s Schedule',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getTodayDayName(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : AppTheme.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_todaySchedule.isEmpty)
                      _buildEmptyStateCard(
                        icon: Icons.event_available_rounded,
                        title: 'No Classes Scheduled Today',
                        message:
                            'No classes scheduled today. Time to relax or head over to the "My Schedule" tab to set up timetable blocks.',
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _todaySchedule.length,
                        itemBuilder: (context, index) {
                          final block = _todaySchedule[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TimelineScheduleCard(
                              block: block,
                              onEdit: () {},
                              onDelete: () {},
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyStateCard({
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(icon, size: 44, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.brandIndigo,
                  side: const BorderSide(color: AppTheme.brandIndigo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'S';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String todayScheduleText(int count) {
    if (count == 0) return 'No classes today';
    if (count == 1) return '1 class today';
    return '$count classes today';
  }

  String _getTodayDayName() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[DateTime.now().weekday - 1];
  }
}
