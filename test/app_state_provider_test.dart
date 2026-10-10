import 'package:flutter_test/flutter_test.dart';
import 'package:break_buddy/models/study_session.dart';
import 'package:break_buddy/services/app_state_provider.dart';

void main() {
  group('StudySession Model Tests', () {
    test('Should convert StudySession to and from JSON correctly', () {
      final now = DateTime.now();
      final session = StudySession(
        id: '12345',
        sessionType: 'study',
        durationMinutes: 25,
        timestamp: now,
        subject: 'Math Study',
      );

      final jsonStr = session.toJson();
      final decodedSession = StudySession.fromJson(jsonStr);

      expect(decodedSession.id, equals('12345'));
      expect(decodedSession.sessionType, equals('study'));
      expect(decodedSession.durationMinutes, equals(25));
      expect(decodedSession.displayType, equals('Study Focus'));
      expect(decodedSession.subject, equals('Math Study'));
    });
  });

  group('AppStateProvider Logic Tests', () {
    test('Default mode should be Study with 25 minutes', () {
      final appState = AppStateProvider();
      expect(appState.currentMode, equals(SessionMode.study));
      expect(appState.studyDurationMins, equals(25));
      expect(appState.formattedTime, equals('25:00'));
      expect(appState.timerStatus, equals(TimerStatus.idle));
    });

    test('Switching mode should update time and total duration', () {
      final appState = AppStateProvider();
      appState.setSessionMode(SessionMode.shortBreak);

      expect(appState.currentMode, equals(SessionMode.shortBreak));
      expect(appState.formattedTime, equals('05:00'));
      expect(appState.timerStatus, equals(TimerStatus.idle));
    });
  });
}
