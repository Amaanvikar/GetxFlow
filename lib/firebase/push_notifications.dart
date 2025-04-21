import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getxflow/screens/notification_screen.dart';
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
            print('Notification tapped: ${response.payload}');
            final payload = jsonDecode(response.payload ?? '{}');

            final actionId = response.actionId;
            if (actionId == 'ACCEPT_RIDE') {
              print("User accepted the ride");
              _handleAcceptRide(payload);
            } else if (actionId == 'CANCEL_RIDE') {
              print("User cancelled the ride");
              _handleCancelRide(payload);
            } else {
              _handleDataNavigation(payload);
            }

            _handleDataNavigation(payload);
          } catch (e) {
            print('Notification tap handling error: $e');
          }
        },
      );

      // Create notification channel for Android

      // const androidChannel = AndroidNotificationChannel(
      //   'default_channel',
      //   'Default',
      //   importance: Importance.max,
      // );

      // await _flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(androidChannel);

      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Create default_channel
        const androidChannel = AndroidNotificationChannel(
          'default_channel',
          'Default',
          importance: Importance.max,
        );
        await androidPlugin.createNotificationChannel(androidChannel);

        const rideChannel = AndroidNotificationChannel(
          'ride_channel',
          'Ride Request Notifications',
          description: 'Channel for ride requests with actions',
          importance: Importance.max,
        );
        await androidPlugin.createNotificationChannel(rideChannel);
      }
    } catch (e) {
      print('Local notification setup failed: $e');
    }
  }

  static void _handleAcceptRide(Map<String, dynamic> data) {
    final notificationType = data['notification_type'];

    if (notificationType == 1) {
      // Proceed only if it's a Ride Request type
      print("Ride Request Accepted:");
      print("Pickup: ${data['pickup_location']}");
      print("Drop: ${data['drop_location']}");
      print("Total: ₹${data['approximate_total_amount']}");
      print("Trip Type: ${data['trip_type']}");

      // Navigate to ride details screen
      Get.toNamed('/notifications', arguments: {
        'driverId': data['driver_id'],
        'driverName':
            "${data['driver_first_name']} ${data['driver_last_name']}",
        'driverMobile': data['driver_mobile'],
        'driverProfilePic': data['driver_prof_pic'],
        'driverRating': data['driver_rating'],
        'vehicleId': data['vehicle_id'],
        'vehicleModel': data['vehicle_model'],
        'vehicleNumber': data['vehicle_registrationno'],
        'vehicleSegment': data['vehicle_segment'],
        'logId': data['vd_log_id'],
        'duration': data['duration'],
        'pickupLocation': data['pickup_location'],
        'pickupLat': data['pickup_lat'],
        'pickupLong': data['pickup_long'],
        'dropLocation': data['drop_location'],
        'dropLat': data['drop_lat'],
        'dropLong': data['drop_long'],
      });
    } else {
      print("Accept button tapped, but notification type is not Ride Request.");
    }
  }

  static void _handleCancelRide(Map<String, dynamic> data) {}

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
    } catch (e) {
      print('Notification listeners setup failed: $e');
    }
  }

  static void _handleIncomingMessage(RemoteMessage message) {
    try {
      if (message.notification != null || message.data.isNotEmpty) {
        final data = message.data;

        if (data['notification_type'] == '1' ||
            data['notification_type'] == 1) {
          showRideRequestNotification(
            title: message.notification?.title ?? 'Ride Request Scheduled',
            body: message.notification?.body ??
                'We have scheduled a driver for you',
            payload: jsonEncode(data),
          );
        } else {
          showSimpleNotification(
            title: message.notification?.title ?? 'New Notification',
            body: message.notification?.body ?? 'You have a new message',
            payload: jsonEncode(data),
          );
        }
        _handleDataNavigation(data);
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
    }
  }

  static void _handleDataNavigation(Map<String, dynamic> data) {
    final type = data['notification_type'];

    switch (type) {
      case 5: // Driver is reaching soon
        Get.toNamed(
          '/driverEnRoute',
          arguments: {
            'message': data['msg'],
          },
        );
        break;

      default:
        print("Unknown notification type: $type");
    }
  }

  static Future<void> showRideRequestNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'ride_channel',
      'Ride Request Notifications',
      channelDescription: 'Ride request notifications with action buttons',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'ACCEPT_RIDE',
          'Accept Ride',
        ),
        AndroidNotificationAction(
          'CANCEL_RIDE',
          'Cancel Ride',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(), // iOS actions need extensions
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription: 'This channel is used for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const notificationDetails = NotificationDetails(
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
