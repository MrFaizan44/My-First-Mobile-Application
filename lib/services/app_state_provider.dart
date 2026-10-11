
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/study_session.dart';
import 'storage_service.dart';
import 'notification_service.dart';

enum SessionMode { study, shortBreak, longBreak }
enum TimerStatus { idle, running, paused, completed }

/// Application state provider managing study timers, user preferences,
/// session history, and water intake.
class AppStateProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  // Timer Configuration (in minutes)
  int _studyDurationMins = 25;
  int _shortBreakDurationMins = 5;
  int _longBreakDurationMins = 15;

  // Active Timer State
  SessionMode _currentMode = SessionMode.study;
  TimerStatus _timerStatus = TimerStatus.idle;
  int _secondsRemaining = 25 * 60;
  int _totalSeconds = 25 * 60;
  Timer? _timer;

  // User Profile & Preferences
  String _userName = 'Scholar';
  bool _notificationsEnabled = true;
  bool _hydrationRemindersEnabled = true;

  // Hydration Tracker
  int _waterGlassesToday = 0;

  // Session History
  List<StudySession> _sessionHistory = [];

  // Completion dialog flag
  bool _justCompleted = false;

  // Getters
  int get studyDurationMins => _studyDurationMins;
  int get shortBreakDurationMins => _shortBreakDurationMins;
  int get longBreakDurationMins => _longBreakDurationMins;

  SessionMode get currentMode => _currentMode;
  TimerStatus get timerStatus => _timerStatus;
  int get secondsRemaining => _secondsRemaining;
  int get totalSeconds => _totalSeconds;

  String get userName => _userName;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get hydrationRemindersEnabled => _hydrationRemindersEnabled;

  int get waterGlassesToday => _waterGlassesToday;
  List<StudySession> get sessionHistory =>
      List.unmodifiable(_sessionHistory);
  bool get justCompleted => _justCompleted;

  // Timer progress from 0.0 to 1.0
  double get progressFraction {
    if (_totalSeconds <= 0) return 0.0;

    return (1.0 - (_secondsRemaining / _totalSeconds))
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // Initialize application state
  Future<void> init() async {
    await _notificationService.initialize();

    final settings = await _storageService.loadSettings();

    _studyDurationMins = settings['studyMins'] ?? 25;
    _shortBreakDurationMins = settings['shortBreakMins'] ?? 5;
    _longBreakDurationMins = settings['longBreakMins'] ?? 15;
    _userName = settings['userName'] ?? 'Scholar';
    _notificationsEnabled =
        settings['notificationsEnabled'] ?? true;
    _hydrationRemindersEnabled =
        settings['hydrationRemindersEnabled'] ?? true;

    _sessionHistory = await _storageService.loadSessions();
    _waterGlassesToday =
    await _storageService.loadWaterGlassesToday();

    _resetTimerValueForCurrentMode();
    notifyListeners();
  }

  // Format remaining time as MM:SS
  String get formattedTime {
    final minutes =
    (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds =
    (_secondsRemaining % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  // Current session label
  String get modeLabel {
    switch (_currentMode) {
      case SessionMode.study:
        return 'Focus Time 🧠';
      case SessionMode.shortBreak:
        return 'Short Break ☕';
      case SessionMode.longBreak:
        return 'Long Break 🌴';
    }
  }

  // Start timer
  void startTimer() {
    if (_timerStatus == TimerStatus.running) return;

    if (_secondsRemaining <= 0) {
      _resetTimerValueForCurrentMode();
    }

    _cancelTimer();
    _timerStatus = TimerStatus.running;
    _justCompleted = false;

    if (_notificationsEnabled) {
      _notificationService.requestPermissions();
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
          notifyListeners();
        } else {
          _secondsRemaining = 0;
          _cancelTimer();
          _handleTimerCompletion();
        }
      },
    );

    notifyListeners();
  }

  // Pause timer
  void pauseTimer() {
    if (_timerStatus == TimerStatus.running) {
      _cancelTimer();
      _timerStatus = TimerStatus.paused;
      notifyListeners();
    }
  }

  // Resume paused timer
  void resumeTimer() {
    if (_timerStatus == TimerStatus.paused) {
      startTimer();
    }
  }

  // Reset timer
  void resetTimer() {
    _cancelTimer();
    _timerStatus = TimerStatus.idle;
    _justCompleted = false;
    _resetTimerValueForCurrentMode();
    notifyListeners();
  }

  // Switch between study and break modes
  void setSessionMode(SessionMode mode) {
    if (_currentMode == mode &&
        _timerStatus == TimerStatus.idle) {
      return;
    }

    _cancelTimer();
    _currentMode = mode;
    _timerStatus = TimerStatus.idle;
    _justCompleted = false;
    _resetTimerValueForCurrentMode();
    notifyListeners();
  }

  // Handle timer completion
  Future<void> _handleTimerCompletion() async {
    if (_timerStatus != TimerStatus.running) return;

    _cancelTimer();
    _timerStatus = TimerStatus.completed;
    _justCompleted = true;

    String notifTitle;
    String notifBody;

    final now = DateTime.now();

    if (_currentMode == SessionMode.study) {
      notifTitle = 'Focus Session Complete! 🎉';
      notifBody =
      'Awesome job! Time to take a well-deserved break and drink some water 💧';

      final session = StudySession(
        id: now.millisecondsSinceEpoch.toString(),
        sessionType: 'study',
        durationMinutes: _studyDurationMins,
        timestamp: now,
        subject: 'Focus Session',
      );

      _sessionHistory.add(session);
      await _storageService.saveSession(session);
    } else {
      notifTitle = 'Break Completed! 🚀';
      notifBody =
      'Feeling refreshed? Ready to get back into focus mode!';

      final session = StudySession(
        id: now.millisecondsSinceEpoch.toString(),
        sessionType: _currentMode == SessionMode.shortBreak
            ? 'short_break'
            : 'long_break',
        durationMinutes:
        _currentMode == SessionMode.shortBreak
            ? _shortBreakDurationMins
            : _longBreakDurationMins,
        timestamp: now,
        subject: 'Break Time',
      );

      _sessionHistory.add(session);
      await _storageService.saveSession(session);
    }

    if (_notificationsEnabled) {
      await _notificationService.showTimerCompleteNotification(
        title: notifTitle,
        body: notifBody,
      );
    }

    notifyListeners();
  }

  // Dismiss completion dialog
  void dismissCompletionDialog() {
    _justCompleted = false;
    notifyListeners();
  }

  // Add one glass of water
  Future<void> addWaterGlass() async {
    _waterGlassesToday++;
    await _storageService.saveWaterGlassesToday(
      _waterGlassesToday,
    );
    notifyListeners();
  }

  // Reset water counter
  Future<void> resetWaterGlasses() async {
    _waterGlassesToday = 0;
    await _storageService.saveWaterGlassesToday(0);
    notifyListeners();
  }

  // Update timer durations
  Future<void> updateTimerDurations({
    required int studyMins,
    required int shortBreakMins,
    required int longBreakMins,
  }) async {
    if (studyMins <= 0 ||
        shortBreakMins <= 0 ||
        longBreakMins <= 0) {
      throw ArgumentError(
        'All timer durations must be greater than zero.',
      );
    }

    _studyDurationMins = studyMins;
    _shortBreakDurationMins = shortBreakMins;
    _longBreakDurationMins = longBreakMins;

    await _storageService.saveDurations(
      studyMins: studyMins,
      shortBreakMins: shortBreakMins,
      longBreakMins: longBreakMins,
    );

    if (_timerStatus == TimerStatus.idle ||
        _timerStatus == TimerStatus.completed) {
      _resetTimerValueForCurrentMode();
    }

    notifyListeners();
  }

  // Update user settings
  Future<void> updateUserSettings({
    required String userName,
    required bool notificationsEnabled,
    required bool hydrationRemindersEnabled,
  }) async {
    _userName = userName;
    _notificationsEnabled = notificationsEnabled;
    _hydrationRemindersEnabled = hydrationRemindersEnabled;

    await _storageService.saveUserSettings(
      userName: userName,
      notificationsEnabled: notificationsEnabled,
      hydrationRemindersEnabled: hydrationRemindersEnabled,
    );

    notifyListeners();
  }

  // Clear session history
  Future<void> clearSessionHistory() async {
    _sessionHistory.clear();
    await _storageService.clearHistory();
    notifyListeners();
  }

  // Reset all app data
  Future<void> resetAllAppData() async {
    _cancelTimer();
    _timerStatus = TimerStatus.idle;
    _justCompleted = false;

    await _storageService.resetAllData();
    await init();
  }

  // Set timer value according to selected mode
  void _resetTimerValueForCurrentMode() {
    int durationMins;

    switch (_currentMode) {
      case SessionMode.study:
        durationMins = _studyDurationMins;
        break;
      case SessionMode.shortBreak:
        durationMins = _shortBreakDurationMins;
        break;
      case SessionMode.longBreak:
        durationMins = _longBreakDurationMins;
        break;
    }

    _totalSeconds = durationMins * 60;
    _secondsRemaining = _totalSeconds;
  }

  // Cancel active timer
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Today's study time in minutes
  int get todayStudyMinutes {
    final now = DateTime.now();

    return _sessionHistory
        .where((s) =>
    s.sessionType == 'study' &&
        s.timestamp.year == now.year &&
        s.timestamp.month == now.month &&
        s.timestamp.day == now.day)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // Today's completed study sessions
  int get todayCompletedSessionsCount {
    final now = DateTime.now();

    return _sessionHistory
        .where((s) =>
    s.sessionType == 'study' &&
        s.timestamp.year == now.year &&
        s.timestamp.month == now.month &&
        s.timestamp.day == now.day)
        .length;
  }

  // Study time during the last seven days
  int get weeklyStudyMinutes {
    final sevenDaysAgo =
    DateTime.now().subtract(const Duration(days: 7));

    return _sessionHistory
        .where((s) =>
    s.sessionType == 'study' &&
        s.timestamp.isAfter(sevenDaysAgo))
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // Completed study sessions during the last seven days
  int get weeklyCompletedSessionsCount {
    final sevenDaysAgo =
    DateTime.now().subtract(const Duration(days: 7));

    return _sessionHistory
        .where((s) =>
    s.sessionType == 'study' &&
        s.timestamp.isAfter(sevenDaysAgo))
        .length;
  }

  // Total study time
  int get totalStudyMinutesAllTime {
    return _sessionHistory
        .where((s) => s.sessionType == 'study')
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
