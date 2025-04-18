import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getxflow/utils/pref_utils.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      // Request permissions with more control
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false, // For iOS
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      // Get and handle token
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        await PrefUtils.setFcmToken(token);

        // Handle token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          print('FCM Token refreshed: $newToken');
          PrefUtils.setFcmToken(newToken);
          // Send to your server if needed
        });
      }

      await setupListeners();
    } catch (e) {
      print('Notification initialization failed: $e');
    }
  }

  static Future<void> localNotiInit() async {
    try {
      // Android setup
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS setup (if needed)
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          try {
            final payload =
                response.payload != null ? jsonDecode(response.payload!) : {};

            // Handle specific action buttons
            switch (response.actionId) {
              case 'accept_action':
                print('User accepted the request.');
                // TODO: Add accept logic here
                break;

              case 'reject_action':
                print('User rejected the request.');
                // TODO: Add reject logic here
                break;

              default:
                print('Notification tapped. Payload: $payload');
                _handleDataNavigation(payload);
            }
          } catch (e) {
            print('Error handling notification response: $e');
          }

          // if (response.actionId == 'accept_action') {
          //   // Handle accept logic
          //   print('User accepted the request.');
          // } else if (response.actionId == 'reject_action') {
          //   // Handle reject logic
          //   print('User rejected the request.');
          // } else {
          //   final payload = jsonDecode(response.payload ?? '{}');
          //   _handleDataNavigation(payload);
          // }

          // try {
          //   print('Notification tapped: ${response.payload}');
          //   final payload = jsonDecode(response.payload ?? '{}');
          //   _handleDataNavigation(payload);
          // } catch (e) {
          //   print('Notification tap handling error: $e');
          // }
        },
      );

      // Create notification channel for Android
      const androidChannel = AndroidNotificationChannel(
          'default_channel', 'input channels',
          description: 'channel for income call notification',
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('ringtone'));

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    } catch (e) {
      print('Local notification setup failed: $e');
    }
  }

  static Future<void> setupListeners() async {
    try {
      // Foreground messages
      FirebaseMessaging.onMessage.listen((message) {
        print('Foreground message received');
        _handleIncomingMessage(message);
      });

      // Background/opened app
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('App opened from notification');
        _handleNotificationNavigation(message);
      });

      // Terminated state
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print('App launched from terminated state');
        _handleNotificationNavigation(initialMessage);
      }

      // Background notifications (when the app is in the background but not terminated)
      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        print('Background message received: ${message.notification?.title}');
        _handleIncomingMessage(message);
      });
    } catch (e) {
      print('Notification listeners setup failed: $e');
    }
  }

  static void _handleIncomingMessage(RemoteMessage message) {
    try {
      if (message.notification != null || message.data.isNotEmpty) {
        Get.toNamed('/home');
        // Get.toNamed('/notifications',arguments: payload);
        showSimpleNotification(
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? 'You have a new message',
          payload: jsonEncode(message.data),
        );
      }
    } catch (e) {
      print('Message handling error: $e');
    }
  }

  static Future<void> _handleNotificationNavigation(
    RemoteMessage message,
  ) async {
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

    switch (type) {
      case '1': // Schedule Ride Notification
        Get.toNamed(
          '/scheduleRide',
          arguments: {
            'driverId': data['driver_id'],
            'driverName':
                "${data['driver_first_name']} ${data['driver_last_name']}",
            'driverMobile': data['driver_mobile'],
            'driverProfilePic': data['driver_prof_pic'],
            'vehicleId': data['vehicle_id'],
            'vehicleModel': data['vehicle_model'],
            'dropUp': data['drop_up'],
            'pickLat': data['pick_lat'],
            'pickLong': data['pick_long'],
          },
        );
        break;

      case '5': // Driver is reaching soon
        Get.toNamed(
          '/driverEndRoute',
          arguments: {
            'message': data['msg'],
          },
        );
        break;

      default:
        print(" Unknown notification_type: $type");
        // Optional fallback screen
        Get.toNamed('/notifications');
    }
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
          'default_channel', // Must match channel ID
          'Default Notifications',
          channelDescription:
              'This channel is used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.call,
          actions: [
            AndroidNotificationAction('accept_action', 'Accept'),
            AndroidNotificationAction('reject_action', 'Reject'),
          ],
          ticker: 'ticker',
          showWhen: true,
          enableVibration: true,
          playSound: true,
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
          ));

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(), // Add iOS specifics if needed
      );

      // Use unique ID for each notification
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      print('Notification display failed: $e');
    }
  }
}
