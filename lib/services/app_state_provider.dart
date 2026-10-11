
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_session.dart';
import 'storage_service.dart';
import 'notification_service.dart';

enum SessionMode { study, shortBreak, longBreak }
enum TimerStatus { idle, running, paused, completed }

/// Application state provider managing study timers, user preferences,
/// study subjects, ambient sounds, daily goals, and session history.
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
  int _dailyGoalSessions = 4;
  String _themePreset = 'blue';
  String _selectedSubject = 'General Focus 🧠';

  // Ambient Sound Simulation
  String _activeAmbientSound = 'None';

  // Hydration Tracker
  int _waterGlassesToday = 0;

  // Session History
  List<StudySession> _sessionHistory = [];

  // Completion dialog flag
  bool _justCompleted = false;

  // Motivational Quotes
  final List<String> _quotes = [
    '“Focus turns ambition into achievement.” ✨',
    '“Small steps every day lead to big results.” 🚀',
    '“The secret of getting ahead is getting started.” 💡',
    '“Stay present, stay hydrated, stay curious.” 💧',
    '“Success is the sum of small efforts repeated daily.” 🎓',
  ];
  int _quoteIndex = 0;

  // Available Subject Tags
  final List<String> availableSubjects = const [
    'General Focus 🧠',
    'Math 📐',
    'Coding 💻',
    'Reading 📚',
    'Science 🔬',
    'Exam Prep 📝',
  ];

  // Available Ambient Focus Sounds
  final List<String> availableAmbientSounds = const [
    'None',
    'Rain 🌧️',
    'Forest 🌲',
    'Waves 🌊',
    'Cafe ☕',
  ];

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
  int get dailyGoalSessions => _dailyGoalSessions;
  String get themePreset => _themePreset;
  String get selectedSubject => _selectedSubject;
  String get activeAmbientSound => _activeAmbientSound;

  int get waterGlassesToday => _waterGlassesToday;
  List<StudySession> get sessionHistory =>
      List.unmodifiable(_sessionHistory);
  bool get justCompleted => _justCompleted;
  String get currentQuote => _quotes[_quoteIndex % _quotes.length];

  /// Get primary theme color according to selected theme preset
  Color get primaryThemeColor {
    switch (_themePreset) {
      case 'green':
        return const Color(0xFF2E7D32);
      case 'purple':
        return const Color(0xFF7B1FA2);
      case 'amber':
        return const Color(0xFFE65100);
      case 'blue':
      default:
        return const Color(0xFF0288D1);
    }
  }

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
<<<<<<< HEAD
    _notificationsEnabled =
        settings['notificationsEnabled'] ?? true;
    _hydrationRemindersEnabled =
        settings['hydrationRemindersEnabled'] ?? true;
=======
    _notificationsEnabled = settings['notificationsEnabled'] ?? true;
    _hydrationRemindersEnabled = settings['hydrationRemindersEnabled'] ?? true;
    _dailyGoalSessions = settings['dailyGoalSessions'] ?? 4;
    _themePreset = settings['themePreset'] ?? 'blue';
    _selectedSubject = settings['selectedSubject'] ?? 'General Focus 🧠';
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c

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

<<<<<<< HEAD
  // Start timer
=======
  /// Rotate to next motivational quote
  void nextQuote() {
    _quoteIndex = (_quoteIndex + 1) % _quotes.length;
    notifyListeners();
  }

  /// Set subject tag for upcoming focus session
  Future<void> setSelectedSubject(String subject) async {
    _selectedSubject = subject;
    await _storageService.saveUserSettings(
      userName: _userName,
      notificationsEnabled: _notificationsEnabled,
      hydrationRemindersEnabled: _hydrationRemindersEnabled,
      dailyGoalSessions: _dailyGoalSessions,
      themePreset: _themePreset,
      selectedSubject: subject,
    );
    notifyListeners();
  }

  /// Set ambient focus sound simulation
  void setAmbientSound(String sound) {
    _activeAmbientSound = sound;
    notifyListeners();
  }

  /// Start timer counting down
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
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
<<<<<<< HEAD
      notifBody =
      'Awesome job! Time to take a well-deserved break and drink some water 💧';
=======
      notifBody = 'Awesome job! You completed a study session in $_selectedSubject. Time to rest and drink water 💧';
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c

      final session = StudySession(
        id: now.millisecondsSinceEpoch.toString(),
        sessionType: 'study',
        durationMinutes: _studyDurationMins,
<<<<<<< HEAD
        timestamp: now,
        subject: 'Focus Session',
=======
        timestamp: DateTime.now(),
        subject: _selectedSubject,
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
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

<<<<<<< HEAD
    if (_timerStatus == TimerStatus.idle ||
        _timerStatus == TimerStatus.completed) {
=======
    if (_timerStatus == TimerStatus.idle || _timerStatus == TimerStatus.completed) {
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
      _resetTimerValueForCurrentMode();
    }

    notifyListeners();
  }

  // Update user settings
  Future<void> updateUserSettings({
    required String userName,
    required bool notificationsEnabled,
    required bool hydrationRemindersEnabled,
    required int dailyGoalSessions,
    required String themePreset,
  }) async {
    _userName = userName;
    _notificationsEnabled = notificationsEnabled;
    _hydrationRemindersEnabled = hydrationRemindersEnabled;
    _dailyGoalSessions = dailyGoalSessions;
    _themePreset = themePreset;

    await _storageService.saveUserSettings(
      userName: userName,
      notificationsEnabled: notificationsEnabled,
      hydrationRemindersEnabled: hydrationRemindersEnabled,
      dailyGoalSessions: dailyGoalSessions,
      themePreset: themePreset,
      selectedSubject: _selectedSubject,
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

<<<<<<< HEAD
  // Set timer value according to selected mode
=======
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
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

<<<<<<< HEAD
  // Cancel active timer
=======
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

<<<<<<< HEAD
  // Today's study time in minutes
=======
  // --- Statistics & Goal Helpers ---

  /// Today's study time in minutes
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
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

<<<<<<< HEAD
  // Study time during the last seven days
=======
  /// Progress fraction towards daily goal (0.0 to 1.0)
  double get dailyGoalProgress {
    if (_dailyGoalSessions == 0) return 0.0;
    return (todayCompletedSessionsCount / _dailyGoalSessions).clamp(0.0, 1.0);
  }

  /// Calculate active study streak in days
  int get studyStreakDays {
    if (_sessionHistory.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (true) {
      final bool hasSessionOnDate = _sessionHistory.any((s) =>
          s.sessionType == 'study' &&
          s.timestamp.year == checkDate.year &&
          s.timestamp.month == checkDate.month &&
          s.timestamp.day == checkDate.day);

      if (hasSessionOnDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // If today has no session yet, check if yesterday had a session to keep streak active
        if (streak == 0 &&
            checkDate.year == DateTime.now().year &&
            checkDate.month == DateTime.now().month &&
            checkDate.day == DateTime.now().day) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  /// Weekly study time in minutes (last 7 days)
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
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
