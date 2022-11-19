import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("ureportlogo.png"));

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage remoteMessage) async {
    final id = DateTime.now().microsecondsSinceEpoch ~/ 100;

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("noor", "u report chanel",
          channelDescription: "this,is our chanel",
          importance: Importance.max,
          priority: Priority.high),
    );

    await _flutterLocalNotificationsPlugin.show(
        id,
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
        notificationDetails);
  }
}
