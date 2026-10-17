import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

/// Attendance Tracker Tab for CampusOS
class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AttendanceModel> attendanceRecords = [
      AttendanceModel(
        courseCode: 'CS301',
        courseTitle: 'Data Structures & Algorithms',
        attendedClasses: 18,
        totalClasses: 20,
      ),
      AttendanceModel(
        courseCode: 'CS304',
        courseTitle: 'Database Management Systems',
        attendedClasses: 16,
        totalClasses: 18,
      ),
      AttendanceModel(
        courseCode: 'SE202',
        courseTitle: 'Software Engineering Principles',
        attendedClasses: 14,
        totalClasses: 18,
      ),
      AttendanceModel(
        courseCode: 'MATH201',
        courseTitle: 'Linear Algebra & Calculus',
        attendedClasses: 19,
        totalClasses: 20,
      ),
    ];

    final int totalAttended = attendanceRecords.fold(0, (sum, a) => sum + a.attendedClasses);
    final int totalClasses = attendanceRecords.fold(0, (sum, a) => sum + a.totalClasses);
    final double overallPercentage = totalClasses > 0 ? (totalAttended / totalClasses) * 100 : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Attendance Card
            CustomCard(
              backgroundColor: AppTheme.primaryColor,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OVERALL ATTENDANCE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${overallPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalAttended / $totalClasses Total Lectures Attended',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: overallPercentage / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Course Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Course Attendance List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceRecords[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${record.courseCode} - ${record.courseTitle}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              record.status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${record.attendedClasses} / ${record.totalClasses} Attended',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              '${record.percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: record.percentage / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              record.percentage >= 75
                                  ? AppTheme.pastelGreenBorder
                                  : AppTheme.pastelRoseBorder,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.check_rounded, color: Colors.white),
        label: const Text('Log Class', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
