import '../models/course_model.dart';
import '../models/task_model.dart';
import '../models/attendance_model.dart';

/// Data service providing offline student data for CampusOS
class CampusDataService {
  static final CampusDataService _instance = CampusDataService._internal();
  factory CampusDataService() => _instance;
  CampusDataService._internal();

  /// Fetch enrolled courses
  List<CourseModel> getCourses() {
    return [];
  }

  /// Fetch pending tasks
  List<TaskModel> getTasks() {
    return [];
  }

  /// Fetch attendance records
  List<AttendanceModel> getAttendance() {
    return [];
  }
}
