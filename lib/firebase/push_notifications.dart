import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getxflow/utils/pref_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();
    print(" FCM Token hr cabs: $token");
    await PrefUtils.setFcmToken(token!);
    print(token);
    setupListeners();
  }

  static Future<void> localNotiInit() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print(" Notification tapped: ${response.payload}");
        final payload = jsonDecode(response.payload ?? '{}');
        _handleDataNavigation(payload);
        // You can navigate here if needed using response.payload
        // Example:
        // final data = jsonDecode(response.payload ?? '{}');
        // navigateToScreen(data);
      },
    );
  }

  static Future<void> setupListeners() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String payloadData = jsonEncode(message.data);
        showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData,
        );
      }
    });

    // When app is opened via a notification (from background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message);
    });

    // When app is launched from terminated state via a notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationNavigation(message);
      }
    });
  }

  static Future<void> _handleNotificationNavigation(
      RemoteMessage message) async {
    if (message.notification != null) {
      final data = message.data;
      _handleDataNavigation(data);
      // if (type == 'booking') {
      //   final bookingId = data['bookingId'];
      //   Get.toNamed('/bookingDetails', arguments: bookingId);
      // } else if (type == 'chat') {
      //   final chatId = data['chatId'];
      //   Get.toNamed('/chat', arguments: chatId);
      // } else if (type == 'offer') {
      //   Get.toNamed('/offers');
      // } else {
      //   Get.toNamed('/notifications');
      // }
    }
  }

  static void _handleDataNavigation(Map<String, dynamic> data) {
    final type = data['notification_type'];

    // switch (type) {
    //   case '1': // Schedule Ride Notification
    //     Get.toNamed(
    //       '/scheduleRide',
    //       arguments: {
    //         'driverId': data['driver_id'],
    //         'driverName': "${data['driver_first_name']} ${data['driver_last_name']}",
    //         'driverMobile': data['driver_mobile'],
    //         'driverProfilePic': data['driver_prof_pic'],
    //         'vehicleId': data['vehicle_id'],
    //         'vehicleModel': data['vehicle_model'],
    //         'dropUp': data['drop_up'],
    //         'pickLat': data['pick_lat'],
    //         'pickLong': data['pick_long'],
    //       },
    //     );
    //     break;
    //
    //   case '5': // Driver is reaching soon
    //     Get.toNamed(
    //       '/driverEnRoute',
    //       arguments: {
    //         'message': data['msg'],
    //       },
    //     );
    //     break;
    //
    //   default:
    //     print(" Unknown notification_type: $type");
    //     // Optional fallback screen
    //     Get.toNamed('/notifications');
    // }
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
