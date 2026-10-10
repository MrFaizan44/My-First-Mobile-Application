import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service responsible for managing local notifications and permissions.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize local notification settings
  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
      );
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationService: $e');
      }
    }
  }

  /// Request notification permissions for Android 13+ and iOS
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

  /// Show timer completion notification
  Future<void> showTimerCompleteNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'break_buddy_timer_channel',
      'Study & Break Timers',
      channelDescription: 'Alerts when focus sessions or breaks complete',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing timer notification: $e');
      }
    }
  }

  /// Show hydration reminder notification
  Future<void> showHydrationReminder() async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'break_buddy_hydration_channel',
      'Hydration Reminders',
      channelDescription: 'Friendly reminders to stay hydrated while studying',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        id: 1,
        title: 'Time to Hydrate! 💧',
        body: 'Take a sip of water to stay fresh and focused!',
        notificationDetails: platformDetails,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing hydration notification: $e');
      }
    }
  }
}
