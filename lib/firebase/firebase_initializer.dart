import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getxflow/firebase/firebase_options.dart';
import 'push_notifications.dart';

// Called when app is in background or terminated
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "🔥 BG MESSAGE: ${message.notification?.title} - ${message.notification?.body}");
}

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

    await PushNotifications.init();
    await PushNotifications.localNotiInit();
  }
}
