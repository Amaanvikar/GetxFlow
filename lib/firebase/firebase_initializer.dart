import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getxflow/firebase/firebase_options.dart';
import 'push_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase
      .initializeApp(); // Required when app is in background/terminated

  if (message.notification != null) {
    print(
      "BG MESSAGE => ${message.notification!.title} - ${message.notification!.body}",
    );
  }

  if (message.data.isNotEmpty) {
    print("BG DATA PAYLOAD: ${message.data}");
    // You might want to show a local notification here
    await PushNotifications.showSimpleNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }
}

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

    await PushNotifications.init(); // Ask permissions + get token
    await PushNotifications.localNotiInit(); // Setup local notifications
  }
}
