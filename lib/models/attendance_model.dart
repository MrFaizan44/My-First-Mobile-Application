/// Data model representing course attendance record
class AttendanceModel {
  final String courseCode;
  final String courseTitle;
  final int attendedClasses;
  final int totalClasses;

  AttendanceModel({
    required this.courseCode,
    required this.courseTitle,
    required this.attendedClasses,
    required this.totalClasses,
  });

  /// Attendance percentage fraction (0.0 to 100.0)
  double get percentage {
    if (totalClasses == 0) return 0.0;
    return (attendedClasses / totalClasses) * 100;
  }

  /// Status badge label
  String get status {
    if (percentage >= 85) return 'Safe 🟢';
    if (percentage >= 75) return 'Warning 🟡';
    return 'Critical 🔴';
  }
}
