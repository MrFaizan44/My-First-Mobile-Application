import 'package:flutter_test/flutter_test.dart';
import 'package:campus_os/models/course_model.dart';
import 'package:campus_os/models/task_model.dart';
import 'package:campus_os/models/attendance_model.dart';
import 'package:campus_os/theme/app_theme.dart';

void main() {
  group('CampusOS Models Tests', () {
    test('CourseModel instantiation test', () {
      final course = CourseModel(
        id: '1',
        code: 'CS301',
        title: 'Data Structures',
        instructor: 'Prof. Jenkins',
        room: '402B',
        scheduleTime: '10:00 AM',
        backgroundColor: AppTheme.pastelBlue,
        borderColor: AppTheme.pastelBlueBorder,
      );

      expect(course.code, equals('CS301'));
      expect(course.room, equals('402B'));
    });

    test('AttendanceModel percentage calculation test', () {
      final attendance = AttendanceModel(
        courseCode: 'CS301',
        courseTitle: 'Data Structures',
        attendedClasses: 18,
        totalClasses: 20,
      );

      expect(attendance.percentage, equals(90.0));
      expect(attendance.status, contains('Safe'));
    });

    test('TaskModel default completion state test', () {
      final task = TaskModel(
        id: '1',
        title: 'Assignment 1',
        courseCode: 'CS301',
        dueDate: DateTime.now(),
      );

      expect(task.isCompleted, isFalse);
      expect(task.priority, equals('Medium'));
    });
  });
}
