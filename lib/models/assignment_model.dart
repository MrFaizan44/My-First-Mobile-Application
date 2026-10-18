/// User assignment model linked to a student course
class AssignmentModel {
  final int? id;
  final int courseId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  // Joined fields from Subject table
  final String? courseName;
  final String? courseCode;
  final int? courseColorValue;

  AssignmentModel({
    this.id,
    required this.courseId,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
    this.courseName,
    this.courseCode,
    this.courseColorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id'] as int?,
      courseId: map['courseId'] as int,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      dueDate: DateTime.tryParse(map['dueDate'] as String? ?? '') ?? DateTime.now(),
      isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      courseName: map['courseName'] as String?,
      courseCode: map['courseCode'] as String?,
      courseColorValue: map['courseColorValue'] as int?,
    );
  }
}
