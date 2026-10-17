import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:campus_os/models/subject_model.dart';
import 'package:campus_os/models/schedule_block_model.dart';
import 'package:campus_os/models/class_note_model.dart';
import 'package:campus_os/theme/app_theme.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('CampusOS Part 1 Models Tests', () {
    test('SubjectModel instantiation & color test', () {
      final subject = SubjectModel(
        id: 1,
        name: 'Data Structures',
        code: 'CS101',
        colorValue: AppTheme.subjectColors[0].toARGB32(),
        instructor: 'Dr. Smith',
        location: 'Room 402B',
      );

      expect(subject.name, equals('Data Structures'));
      expect(subject.code, equals('CS101'));
      expect(subject.instructor, equals('Dr. Smith'));
    });

    test('ScheduleBlockModel day name helper test', () {
      final block = ScheduleBlockModel(
        id: 10,
        subjectId: 1,
        dayOfWeek: 1, // Monday
        startTime: '09:00 AM',
        endTime: '10:30 AM',
        room: 'Lab 101',
        subjectName: 'Computer Science',
      );

      expect(block.dayName, equals('Monday'));
      expect(block.startTime, equals('09:00 AM'));
    });

    test('ClassNoteModel instantiation test', () {
      final note = ClassNoteModel(
        id: 100,
        subjectId: 1,
        title: 'Binary Search Trees',
        content: 'BST properties and traversal algorithms.',
        createdAt: DateTime.now(),
        subjectName: 'Computer Science',
      );

      expect(note.title, equals('Binary Search Trees'));
      expect(note.subjectName, equals('Computer Science'));
    });
  });
}
