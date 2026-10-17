```dart
import 'dart:convert';

/// Represents a completed study or break session.
class StudySession {
// Session type constants
static const String study = 'study';
static const String shortBreak = 'short_break';
static const String longBreak = 'long_break';

final String id;
final String sessionType;
final int durationMinutes;
final DateTime timestamp;
final String subject;

const StudySession({
required this.id,
required this.sessionType,
required this.durationMinutes,
required this.timestamp,
this.subject = 'Focus Session',
});

/// Human-readable session title.
String get displayType {
switch (sessionType) {
case shortBreak:
return 'Short Break';
case longBreak:
return 'Long Break';
case study:
default:
return 'Study Focus';
}
}

/// Icon name can be selected based on the session type.
String get emoji {
switch (sessionType) {
case shortBreak:
return '☕';
case longBreak:
return '🌿';
case study:
default:
return '📚';
}
}

/// Whether this session is a study session.
bool get isStudy => sessionType == study;

/// Whether this session is a break.
bool get isBreak =>
sessionType == shortBreak || sessionType == longBreak;

/// Formatted duration.
String get formattedDuration {
if (durationMinutes < 60) {
return '$durationMinutes min';
}

final hours = durationMinutes ~/ 60;
final minutes = durationMinutes % 60;

if (minutes == 0) {
return '${hours}h';
}

return '${hours}h ${minutes}m';
}

/// Convert the session to a Map.
Map<String, dynamic> toMap() {
return {
'id': id,
'sessionType': sessionType,
'durationMinutes': durationMinutes,
'timestamp': timestamp.toIso8601String(),
'subject': subject,
};
}

/// Create a session from a Map.
factory StudySession.fromMap(Map<String, dynamic> map) {
final rawTimestamp = map['timestamp'];

return StudySession(
id: map['id']?.toString() ??
DateTime.now().millisecondsSinceEpoch.toString(),
sessionType: map['sessionType'] as String? ?? study,
durationMinutes: _parseDuration(map['durationMinutes']),
timestamp: rawTimestamp is String
? DateTime.tryParse(rawTimestamp) ?? DateTime.now()
    : DateTime.now(),
subject: map['subject'] as String? ?? 'Focus Session',
);
}

/// Safely parse the duration.
static int _parseDuration(dynamic value) {
if (value is int && value >= 0) {
return value;
}

if (value is String) {
return int.tryParse(value) ?? 25;
}

return 25;
}

/// Convert the session to JSON.
String toJson() => jsonEncode(toMap());

/// Create a session from JSON.
factory StudySession.fromJson(String source) {
final decoded = jsonDecode(source);

if (decoded is! Map<String, dynamic>) {
throw const FormatException(
'StudySession JSON must contain an object.',
);
}

return StudySession.fromMap(decoded);
}
}
```