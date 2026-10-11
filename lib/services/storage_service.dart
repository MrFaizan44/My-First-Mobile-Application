
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_session.dart';

/// Handles persistent local storage using SharedPreferences.
class StorageService {
  static const String _keyStudyDuration = 'study_duration_mins';
  static const String _keyShortBreakDuration =
      'short_break_duration_mins';
  static const String _keyLongBreakDuration =
      'long_break_duration_mins';
  static const String _keyUserName = 'user_name';
  static const String _keyNotificationsEnabled =
      'notifications_enabled';
  static const String _keyHydrationRemindersEnabled =
      'hydration_reminders_enabled';
  static const String _keySessionsHistory = 'sessions_history';
  static const String _keyWaterGlasses = 'water_glasses_today';
  static const String _keyWaterDate = 'water_date';

  // Save timer durations after validating the values.
  Future<void> saveDurations({
    required int studyMins,
    required int shortBreakMins,
    required int longBreakMins,
  }) async {
    if (studyMins <= 0 ||
        shortBreakMins <= 0 ||
        longBreakMins <= 0) {
      throw ArgumentError('Timer durations must be greater than zero.');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyStudyDuration, studyMins);
    await prefs.setInt(_keyShortBreakDuration, shortBreakMins);
    await prefs.setInt(_keyLongBreakDuration, longBreakMins);
  }

  // Load settings with default values.
  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'studyMins': _validDuration(
        prefs.getInt(_keyStudyDuration),
        25,
      ),
      'shortBreakMins': _validDuration(
        prefs.getInt(_keyShortBreakDuration),
        5,
      ),
      'longBreakMins': _validDuration(
        prefs.getInt(_keyLongBreakDuration),
        15,
      ),
      'userName': prefs.getString(_keyUserName) ?? 'Scholar',
      'notificationsEnabled':
      prefs.getBool(_keyNotificationsEnabled) ?? true,
      'hydrationRemindersEnabled':
      prefs.getBool(_keyHydrationRemindersEnabled) ?? true,
    };
  }

  int _validDuration(int? value, int fallback) {
    return value != null && value > 0 ? value : fallback;
  }

  // Save user preferences.
  Future<void> saveUserSettings({
    required String userName,
    required bool notificationsEnabled,
    required bool hydrationRemindersEnabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyUserName,
      userName.trim().isEmpty ? 'Scholar' : userName.trim(),
    );

    await prefs.setBool(
      _keyNotificationsEnabled,
      notificationsEnabled,
    );

    await prefs.setBool(
      _keyHydrationRemindersEnabled,
      hydrationRemindersEnabled,
    );
  }

  // Load completed study sessions.
  // Skip invalid records so one corrupt entry does not crash the app.
  Future<List<StudySession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keySessionsHistory);

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    final sessions = <StudySession>[];

    for (final item in jsonList) {
      try {
        final decoded = json.decode(item);

        if (decoded is Map<String, dynamic>) {
          sessions.add(StudySession.fromMap(decoded));
        }
      } catch (e) {
        // Ignore malformed session records.
      }
    }

    return sessions;
  }

  // Save a newly completed study session.
  Future<void> saveSession(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await loadSessions();

    sessions.add(session);

    final jsonList = sessions
        .map((item) => json.encode(item.toMap()))
        .toList();

    await prefs.setStringList(_keySessionsHistory, jsonList);
  }

  // Clear completed session history.
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionsHistory);
  }

  // Load today's water intake.
  // Automatically reset the count when the date changes.
  Future<int> loadWaterGlassesToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final savedDate = prefs.getString(_keyWaterDate);

    if (savedDate != today) {
      await prefs.setString(_keyWaterDate, today);
      await prefs.setInt(_keyWaterGlasses, 0);
      return 0;
    }

    final count = prefs.getInt(_keyWaterGlasses) ?? 0;
    return count < 0 ? 0 : count;
  }

  // Save today's water intake.
  Future<void> saveWaterGlassesToday(int count) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyWaterDate, _todayString());
    await prefs.setInt(
      _keyWaterGlasses,
      count < 0 ? 0 : count,
    );
  }

  String _todayString() {
    final now = DateTime.now();

    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  // Reset all data stored by this app in SharedPreferences.
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
