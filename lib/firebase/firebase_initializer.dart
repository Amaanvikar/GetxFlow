import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getxflow/firebase/firebase_options.dart';
import 'push_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
//   // No need to initialize Firebase here, it should be initialized already.

//   if (message.notification != null) {
//     print(
//       "BG MESSAGE => ${message.notification!.title} - ${message.notification!.body}",
//     );
//   }

//   if (message.data.isNotEmpty) {
//     print("BG DATA PAYLOAD: ${message.data}");
//     await PushNotifications.showSimpleNotification(
//       title: message.notification?.title ?? 'New Notification',
//       body: message.notification?.body ?? '',
//       payload: jsonEncode(message.data),
//     );
//   }
// }

// class FirebaseInitializer {
//   static Future<void> initialize() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

//     await PushNotifications.init(); // Ask permissions + get token
//     await PushNotifications.localNotiInit(); // Setup local notifications
//   }
// }

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase
      .initializeApp(); // Required when app is in background/terminated

  if (message.notification != null) {
    print(
      "BG MESSAGE => ${message.notification!.title} - ${message.notification!.body}",
    );
  }

  if (message.data.isNotEmpty) {
    final data = message.data;

    if (data['notification_type'] == '1' || data['notification_type'] == 1) {
      await PushNotifications.showRideRequestNotification(
        title: message.notification?.title ?? 'Ride Request Scheduled',
        body:
            message.notification?.body ?? 'We have scheduled a driver for you',
        payload: jsonEncode(data),
      );
    } else {
      await PushNotifications.showSimpleNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: jsonEncode(data),
      );
    }
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
