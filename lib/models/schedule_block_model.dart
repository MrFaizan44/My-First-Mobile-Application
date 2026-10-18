/// User-defined timetable / schedule block model stored in SQLite
class ScheduleBlockModel {
  final int? id;
  final int subjectId;
  final int dayOfWeek; // 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
  final String startTime;
  final String endTime;
  final String room;

  // Joined fields from Subject table
  final String? subjectName;
  final String? subjectCode;
  final int? subjectColorValue;

  ScheduleBlockModel({
    this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room = '',
    this.subjectName,
    this.subjectCode,
    this.subjectColorValue,
  });

  /// Day name string (e.g., "Monday")
  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
    };
  }

  factory ScheduleBlockModel.fromMap(Map<String, dynamic> map) {
    return ScheduleBlockModel(
      id: map['id'] as int?,
      subjectId: map['subjectId'] as int,
      dayOfWeek: map['dayOfWeek'] as int,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      room: (map['room'] as String?) ?? '',
      subjectName: map['subjectName'] as String?,
      subjectCode: map['subjectCode'] as String?,
      subjectColorValue: map['subjectColorValue'] as int?,
    );
  }
}
