import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const String actionMarkRead = 'mark_read';
  static const String actionView = 'view';
  static void Function(String actionId, String? payload)? onAction;

  
  static Future<void> init({
    void Function(String actionId, String? payload)? onNotificationAction,
  }) async {
    onAction = onNotificationAction;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'notification_actions',
          actions: [
            DarwinNotificationAction.plain(actionMarkRead, 'Mark as read'),
            DarwinNotificationAction.plain(
              actionView,
              'View',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    final settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print(
          '🔔 Notification tapped: ${response.payload}, action: ${response.actionId}',
        );
        final actionId = response.actionId ?? actionView;
        onAction?.call(actionId, response.payload);
      },
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.deleteNotificationChannel('default_channel');

    const channel = AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
    );
    await androidImpl?.createNotificationChannel(channel);

    await androidImpl?.requestNotificationsPermission();
  }

  static Future<void> show({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: const DrawableResourceAndroidBitmap('duong_chhiv_logo'),
      actions: const [
        AndroidNotificationAction(actionMarkRead, 'Mark as read'),
        AndroidNotificationAction(actionView, 'View'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'notification_actions',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }
}
