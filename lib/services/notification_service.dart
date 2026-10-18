import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/assignment_model.dart';

/// Android-only local notification service for StudyTasker assignment due date reminders
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize Android local notification settings & timezone
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    try {
      await _notificationsPlugin.initialize(settings: initSettings);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
    }
  }

  /// Request notification permission for Android 13+
  Future<bool> requestPermissions() async {
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
      return false;
    }
  }

  /// Schedule a local notification for an assignment due date
  Future<void> scheduleAssignmentNotification(AssignmentModel assignment) async {
    if (!_isInitialized) await initialize();
    if (assignment.id == null || assignment.isCompleted) return;

    if (assignment.dueDate.isBefore(DateTime.now())) return;

    await requestPermissions();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'study_tasker_assignment_channel',
      'StudyTasker Reminders',
      channelDescription: 'Notifications for upcoming assignment due dates',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final scheduledDate = tz.TZDateTime.from(assignment.dueDate, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        id: assignment.id!,
        title: 'Assignment Due Soon: ${assignment.title}',
        body: 'Course: ${assignment.courseCode ?? 'Course'} • Due at ${assignment.dueDate.hour}:${assignment.dueDate.minute.toString().padLeft(2, '0')}',
        scheduledDate: scheduledDate,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling assignment notification: $e');
      }
    }
  }

  /// Cancel scheduled notification for an assignment
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id: id);
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling notification: $e');
      }
    }
  }
}
