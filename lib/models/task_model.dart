/// Data model representing a student assignment or task
class TaskModel {
  final String id;
  final String title;
  final String courseCode;
  final DateTime dueDate;
  final bool isCompleted;
  final String priority; // 'High', 'Medium', 'Low'

  TaskModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 'Medium',
  });
}
