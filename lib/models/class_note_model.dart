/// User-created class note / resource model stored in SQLite
class ClassNoteModel {
  final int? id;
  final int subjectId;
  final String title;
  final String content;
  final DateTime createdAt;

  // Joined fields from Subject table
  final String? subjectName;
  final int? subjectColorValue;

  ClassNoteModel({
    this.id,
    required this.subjectId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.subjectName,
    this.subjectColorValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClassNoteModel.fromMap(Map<String, dynamic> map) {
    return ClassNoteModel(
      id: map['id'] as int?,
      subjectId: map['subjectId'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      subjectName: map['subjectName'] as String?,
      subjectColorValue: map['subjectColorValue'] as int?,
    );
  }
}
