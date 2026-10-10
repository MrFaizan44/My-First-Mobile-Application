import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_session.dart';

/// Handles persistent local storage using SharedPreferences.
class StorageService {
  static const String _keyStudyDuration = 'study_duration_mins';
  static const String _keyShortBreakDuration = 'short_break_duration_mins';
  static const String _keyLongBreakDuration = 'long_break_duration_mins';
  static const String _keyUserName = 'user_name';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyHydrationRemindersEnabled = 'hydration_reminders_enabled';
  static const String _keySessionsHistory = 'sessions_history';
  static const String _keyWaterGlasses = 'water_glasses_today';
  static const String _keyWaterDate = 'water_date';

  /// Save timer durations in minutes
  Future<void> saveDurations({
    required int studyMins,
    required int shortBreakMins,
    required int longBreakMins,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStudyDuration, studyMins);
    await prefs.setInt(_keyShortBreakDuration, shortBreakMins);
    await prefs.setInt(_keyLongBreakDuration, longBreakMins);
  }

  /// Load user settings with fallback default values
  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'studyMins': prefs.getInt(_keyStudyDuration) ?? 25,
      'shortBreakMins': prefs.getInt(_keyShortBreakDuration) ?? 5,
      'longBreakMins': prefs.getInt(_keyLongBreakDuration) ?? 15,
      'userName': prefs.getString(_keyUserName) ?? 'Scholar',
      'notificationsEnabled': prefs.getBool(_keyNotificationsEnabled) ?? true,
      'hydrationRemindersEnabled': prefs.getBool(_keyHydrationRemindersEnabled) ?? true,
    };
  }

  /// Save user profile / preference settings
  Future<void> saveUserSettings({
    required String userName,
    required bool notificationsEnabled,
    required bool hydrationRemindersEnabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, userName);
    await prefs.setBool(_keyNotificationsEnabled, notificationsEnabled);
    await prefs.setBool(_keyHydrationRemindersEnabled, hydrationRemindersEnabled);
  }

  /// Load completed sessions history
  Future<List<StudySession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_keySessionsHistory);
    if (jsonList == null) return [];

    return jsonList
        .map((item) => StudySession.fromMap(json.decode(item)))
        .toList();
  }

  /// Add a newly completed session to local storage
  Future<void> saveSession(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final List<StudySession> currentSessions = await loadSessions();
    currentSessions.add(session);

    final List<String> jsonList =
        currentSessions.map((s) => json.encode(s.toMap())).toList();
    await prefs.setStringList(_keySessionsHistory, jsonList);
  }

  /// Clear session history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySessionsHistory);
  }

  /// Water intake tracking today
  Future<int> loadWaterGlassesToday() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastDate = prefs.getString(_keyWaterDate);
    final String todayStr = DateTime.now().toIso8601String().split('T')[0];

    // Reset water count if new day
    if (lastDate != todayStr) {
      await prefs.setString(_keyWaterDate, todayStr);
      await prefs.setInt(_keyWaterGlasses, 0);
      return 0;
    }

    return prefs.getInt(_keyWaterGlasses) ?? 0;
  }

  /// Update today's water glasses count
  Future<void> saveWaterGlassesToday(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final String todayStr = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString(_keyWaterDate, todayStr);
    await prefs.setInt(_keyWaterGlasses, count);
  }

  /// Reset all stored application data
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
