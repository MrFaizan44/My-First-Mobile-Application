import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/subject_model.dart';
import '../models/schedule_block_model.dart';
import '../models/class_note_model.dart';
import '../models/assignment_model.dart';

/// Local SQLite Database Helper for StudyTasker offline persistence
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'studytasker_student.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON;');

    // Table 1: User-Defined Subjects / Courses
    await db.execute('''
      CREATE TABLE subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        colorValue INTEGER NOT NULL,
        instructor TEXT,
        location TEXT
      );
    ''');

    // Table 2: Schedule / Timetable Blocks
    await db.execute('''
      CREATE TABLE schedule_blocks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subjectId INTEGER NOT NULL,
        dayOfWeek INTEGER NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        room TEXT,
        FOREIGN KEY (subjectId) REFERENCES subjects (id) ON DELETE CASCADE
      );
    ''');

    // Table 3: Class Notes & Resources
    await db.execute('''
      CREATE TABLE class_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subjectId INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (subjectId) REFERENCES subjects (id) ON DELETE CASCADE
      );
    ''');

    // Table 4: Course Assignments & Due Dates
    await db.execute('''
      CREATE TABLE assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (courseId) REFERENCES subjects (id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS assignments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          courseId INTEGER NOT NULL,
          title TEXT NOT NULL,
          description TEXT,
          dueDate TEXT NOT NULL,
          isCompleted INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (courseId) REFERENCES subjects (id) ON DELETE CASCADE
        );
      ''');
    }
  }

  // ==========================================
  // SUBJECT CRUD OPERATIONS
  // ==========================================

  Future<int> insertSubject(SubjectModel subject) async {
    final db = await database;
    return await db.insert('subjects', subject.toMap());
  }

  Future<List<SubjectModel>> getSubjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('subjects', orderBy: 'name ASC');
    return maps.map((map) => SubjectModel.fromMap(map)).toList();
  }

  Future<int> updateSubject(SubjectModel subject) async {
    final db = await database;
    return await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<int> deleteSubject(int id) async {
    final db = await database;
    return await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // SCHEDULE BLOCK CRUD OPERATIONS
  // ==========================================

  Future<int> insertScheduleBlock(ScheduleBlockModel block) async {
    final db = await database;
    return await db.insert('schedule_blocks', block.toMap());
  }

  Future<List<ScheduleBlockModel>> getScheduleBlocksForDay(int dayOfWeek) async {
    final db = await database;
    final String query = '''
      SELECT 
        s.id,
        s.subjectId,
        s.dayOfWeek,
        s.startTime,
        s.endTime,
        s.room,
        sub.name AS subjectName,
        sub.code AS subjectCode,
        sub.colorValue AS subjectColorValue
      FROM schedule_blocks s
      INNER JOIN subjects sub ON s.subjectId = sub.id
      WHERE s.dayOfWeek = ?
      ORDER BY s.startTime ASC;
    ''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, [dayOfWeek]);
    return maps.map((map) => ScheduleBlockModel.fromMap(map)).toList();
  }

  Future<List<ScheduleBlockModel>> getAllScheduleBlocks() async {
    final db = await database;
    final String query = '''
      SELECT 
        s.id,
        s.subjectId,
        s.dayOfWeek,
        s.startTime,
        s.endTime,
        s.room,
        sub.name AS subjectName,
        sub.code AS subjectCode,
        sub.colorValue AS subjectColorValue
      FROM schedule_blocks s
      INNER JOIN subjects sub ON s.subjectId = sub.id
      ORDER BY s.dayOfWeek ASC, s.startTime ASC;
    ''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return maps.map((map) => ScheduleBlockModel.fromMap(map)).toList();
  }

  Future<int> updateScheduleBlock(ScheduleBlockModel block) async {
    final db = await database;
    return await db.update(
      'schedule_blocks',
      block.toMap(),
      where: 'id = ?',
      whereArgs: [block.id],
    );
  }

  Future<int> deleteScheduleBlock(int id) async {
    final db = await database;
    return await db.delete(
      'schedule_blocks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // CLASS NOTES CRUD OPERATIONS
  // ==========================================

  Future<int> insertClassNote(ClassNoteModel note) async {
    final db = await database;
    return await db.insert('class_notes', note.toMap());
  }

  Future<List<ClassNoteModel>> getClassNotes({int? subjectId}) async {
    final db = await database;
    String query = '''
      SELECT 
        n.id,
        n.subjectId,
        n.title,
        n.content,
        n.createdAt,
        sub.name AS subjectName,
        sub.colorValue AS subjectColorValue
      FROM class_notes n
      INNER JOIN subjects sub ON n.subjectId = sub.id
    ''';

    List<dynamic> whereArgs = [];
    if (subjectId != null) {
      query += ' WHERE n.subjectId = ?';
      whereArgs.add(subjectId);
    }

    query += ' ORDER BY n.createdAt DESC;';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
    return maps.map((map) => ClassNoteModel.fromMap(map)).toList();
  }

  Future<int> updateClassNote(ClassNoteModel note) async {
    final db = await database;
    return await db.update(
      'class_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteClassNote(int id) async {
    final db = await database;
    return await db.delete(
      'class_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // ASSIGNMENTS CRUD OPERATIONS
  // ==========================================

  Future<int> insertAssignment(AssignmentModel assignment) async {
    final db = await database;
    return await db.insert('assignments', assignment.toMap());
  }

  Future<List<AssignmentModel>> getAssignments({
    int? courseId,
    bool? pendingOnly,
  }) async {
    final db = await database;
    String query = '''
      SELECT 
        a.id,
        a.courseId,
        a.title,
        a.description,
        a.dueDate,
        a.isCompleted,
        sub.name AS courseName,
        sub.code AS courseCode,
        sub.colorValue AS courseColorValue
      FROM assignments a
      INNER JOIN subjects sub ON a.courseId = sub.id
    ''';

    List<String> conditions = [];
    List<dynamic> whereArgs = [];

    if (courseId != null) {
      conditions.add('a.courseId = ?');
      whereArgs.add(courseId);
    }

    if (pendingOnly == true) {
      conditions.add('a.isCompleted = 0');
    }

    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }

    query += ' ORDER BY a.dueDate ASC;';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
    return maps.map((map) => AssignmentModel.fromMap(map)).toList();
  }

  Future<int> updateAssignment(AssignmentModel assignment) async {
    final db = await database;
    return await db.update(
      'assignments',
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<int> deleteAssignment(int id) async {
    final db = await database;
    return await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
