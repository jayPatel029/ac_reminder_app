import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: DarwinInitializationSettings(),
    );

    _notification.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  static Future<void> scheduledNotification(
      String title, String body, DateTime scheduledDate) async {
    const androidDetails = AndroidNotificationDetails(
      'imp_noti',
      'MyChannel',
      priority: Priority.high,
      importance: Importance.max,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
