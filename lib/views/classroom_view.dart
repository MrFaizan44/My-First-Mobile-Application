import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../theme/app_theme.dart';
import '../widgets/course_card.dart';

/// Classroom & Timetable Tab for CampusOS
class ClassroomView extends StatefulWidget {
  const ClassroomView({super.key});

  @override
  State<ClassroomView> createState() => _ClassroomViewState();
}

class _ClassroomViewState extends State<ClassroomView> {
  String _selectedDay = 'Monday';

  final List<CourseModel> _sampleCourses = [
    CourseModel(
      id: '1',
      code: 'CS301',
      title: 'Data Structures & Algorithms',
      instructor: 'Prof. Sarah Jenkins',
      room: 'Room 402B',
      scheduleTime: '10:00 AM - 11:30 AM',
      backgroundColor: AppTheme.pastelPurple,
      borderColor: AppTheme.pastelPurpleBorder,
    ),
    CourseModel(
      id: '2',
      code: 'CS304',
      title: 'Database Management Systems',
      instructor: 'Dr. Michael Chang',
      room: 'Lab 105',
      scheduleTime: '01:00 PM - 02:30 PM',
      backgroundColor: AppTheme.pastelBlue,
      borderColor: AppTheme.pastelBlueBorder,
    ),
    CourseModel(
      id: '3',
      code: 'SE202',
      title: 'Software Engineering Principles',
      instructor: 'Prof. Emily Watson',
      room: 'Hall A',
      scheduleTime: '03:00 PM - 04:30 PM',
      backgroundColor: AppTheme.pastelGreen,
      borderColor: AppTheme.pastelGreenBorder,
    ),
    CourseModel(
      id: '4',
      code: 'MATH201',
      title: 'Linear Algebra & Multivariable Calculus',
      instructor: 'Dr. Robert Vance',
      room: 'Room 210',
      scheduleTime: '09:00 AM - 10:30 AM',
      backgroundColor: AppTheme.pastelAmber,
      borderColor: AppTheme.pastelAmberBorder,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Classroom & Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Days Selector Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    .map((day) {
                  final bool isSelected = _selectedDay == day;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        day,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedDay = day;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Classes for $_selectedDay',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${_sampleCourses.length} Courses',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Courses Grid/List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sampleCourses.length,
              itemBuilder: (context, index) {
                final course = _sampleCourses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: CourseCard(
                    course: course,
                    onTap: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
