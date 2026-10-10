import 'dart:convert';

/// Represents a single study or break session completed by the user.
class StudySession {
  final String id;
  final String sessionType; // 'study', 'short_break', or 'long_break'
  final int durationMinutes;
  final DateTime timestamp;
  final String subject; // Optional study topic or notes

  StudySession({
    required this.id,
    required this.sessionType,
    required this.durationMinutes,
    required this.timestamp,
    this.subject = 'Focus Session',
  });

  /// Human-readable title for display
  String get displayType {
    switch (sessionType) {
      case 'short_break':
        return 'Short Break';
      case 'long_break':
        return 'Long Break';
      case 'study':
      default:
        return 'Study Focus';
    }
  }

  /// Convert object to Map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionType': sessionType,
      'durationMinutes': durationMinutes,
      'timestamp': timestamp.toIso8601String(),
      'subject': subject,
    };
  }

  /// Create object from Map (JSON decoding)
  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      sessionType: map['sessionType'] ?? 'study',
      durationMinutes: map['durationMinutes'] ?? 25,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      subject: map['subject'] ?? 'Focus Session',
    );
  }

  /// Encode to JSON string
  String toJson() => json.encode(toMap());

  /// Decode from JSON string
  factory StudySession.fromJson(String source) =>
      StudySession.fromMap(json.decode(source));
}
