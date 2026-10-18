import 'package:intl/intl.dart';

/// User timetable schedule block model stored in SQLite
class ScheduleBlockModel {
  final int? id;
  final int subjectId;
  final int dayOfWeek; // 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
  final String startTime;
  final String endTime;
  final String room; // Room Number / Building / Online Link unique to this slot

  // Joined fields from Subject table
  final String? subjectName;
  final String? subjectInstructor;
  final int? subjectColorValue;

  ScheduleBlockModel({
    this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room = '',
    this.subjectName,
    this.subjectInstructor,
    this.subjectColorValue,
  });

  /// Day name string
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

  /// Parses a time string like "09:30 AM" or "14:30" into today's DateTime
  static DateTime? parseSlotTimeToday(String timeStr) {
    try {
      final now = DateTime.now();
      final cleanStr = timeStr.trim().toUpperCase();

      final isPm = cleanStr.contains('PM');
      final isAm = cleanStr.contains('AM');

      final partsOnly = cleanStr.replaceAll(RegExp(r'[A-Z]'), '').trim();
      final timeParts = partsOnly.split(':');
      if (timeParts.length < 2) return null;

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (isPm && hour < 12) hour += 12;
      if (isAm && hour == 12) hour = 0;

      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  /// Returns true if the end time of this class slot has passed today
  bool get isPassedToday {
    final endDateTime = parseSlotTimeToday(endTime);
    if (endDateTime == null) return false;
    return DateTime.now().isAfter(endDateTime);
  }

  /// Formatted start time with AM/PM
  String get formattedStartTime {
    final dt = parseSlotTimeToday(startTime);
    if (dt == null) return startTime;
    return DateFormat('hh:mm a').format(dt);
  }

  /// Formatted end time with AM/PM
  String get formattedEndTime {
    final dt = parseSlotTimeToday(endTime);
    if (dt == null) return endTime;
    return DateFormat('hh:mm a').format(dt);
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
      subjectInstructor: map['subjectInstructor'] as String?,
      subjectColorValue: map['subjectColorValue'] as int?,
    );
  }
}
