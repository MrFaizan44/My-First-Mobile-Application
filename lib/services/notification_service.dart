
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service responsible for managing local notifications and permissions.
class NotificationService {
  static final NotificationService _instance =
  NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize local notification settings.
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

    const InitializationSettings initSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
      );

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('NotificationService initialized successfully.');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Notification initialization failed: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  /// Request notification permission.
  Future<bool> requestPermissions() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_isInitialized) return false;

      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted = await androidImplementation
            .requestNotificationsPermission();

        return granted ?? false;
      }

      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final granted = await iosImplementation
            .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        return granted ?? false;
      }

      // Other platforms may not require this permission.
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Notification permission error: $e');
      }
      return false;
    }
  }

  /// Show timer completion notification.
  Future<void> showTimerCompleteNotification({
    required String title,
    required String body,
  }) async {
    await _showNotification(
      id: 0,
      channelId: 'break_buddy_timer_channel',
      channelName: 'Study & Break Timers',
      channelDescription:
      'Alerts when focus sessions or breaks complete',
      title: title,
      body: body,
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  /// Show hydration reminder notification.
  Future<void> showHydrationReminder() async {
    await _showNotification(
      id: 1,
      channelId: 'break_buddy_hydration_channel',
      channelName: 'Hydration Reminders',
      channelDescription:
      'Friendly reminders to stay hydrated while studying',
      title: 'Time to Hydrate! 💧',
      body: 'Take a sip of water to stay fresh and focused!',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
  }

  /// Common notification display method.
  Future<void> _showNotification({
    required int id,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
    required Importance importance,
    required Priority priority,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (!_isInitialized) return;

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
        playSound: true,
        enableVibration: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error showing notification: $e');
      }
    }
  }
}
