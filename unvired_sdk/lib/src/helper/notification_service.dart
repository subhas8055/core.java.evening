import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:unvired_sdk/src/authentication_service.dart';

class NotificationService {
  NotificationService();

  FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await localNotifications.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    List<String> channelIds =
        AuthenticationService().getAndroidPushChannelIds();

    if (channelIds.length == 0) {
      // Setting default channel name as 'System'.
      channelIds.add("System");
    }

    for (String channelId in channelIds) {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelId + "_title", // title
        description: 'This channel is used for notifications.', // description
        importance: Importance.high,
      );
      await localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void selectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      behaviorSubject.add(payload);
    }
  }

  showNotification(
      {required String title,
      required String body,
      required String channelId}) async {
    Logger.logInfo(
        "NotificationService", "showNotification", "Notification call...");
    var android = AndroidNotificationDetails(
      channelId,
      channelId + "_title",
      channelDescription: 'This channel is used for notifications.',
      priority: Priority.max,
      importance: Importance.max,
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await localNotifications.show(0, title, body, platform);
  }
}
