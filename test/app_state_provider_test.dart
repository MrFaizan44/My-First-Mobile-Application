import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:study_tasker/models/subject_model.dart';
import 'package:study_tasker/models/schedule_block_model.dart';
import 'package:study_tasker/models/class_note_model.dart';
import 'package:study_tasker/theme/app_theme.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('StudyTasker Models & Theme Tests', () {
    test('SubjectModel instantiation & color test', () {
      final subject = SubjectModel(
        id: 1,
        name: 'Data Structures',
        colorValue: AppTheme.subjectColors[0].toARGB32(),
        instructor: 'Dr. Smith',
      );

      expect(subject.name, equals('Data Structures'));
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
