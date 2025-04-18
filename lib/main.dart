import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/drawer_controller.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:getxflow/firebase/firebase_initializer.dart';
import 'package:getxflow/screens/driver_ride_list_screen.dart';
import 'package:getxflow/screens/events_screen.dart';
import 'package:getxflow/screens/homescreen.dart';
import 'package:getxflow/screens/location_screen.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:getxflow/screens/login.dart';
import 'package:getxflow/screens/notification_screen.dart';
import 'package:getxflow/screens/user_profile_screen.dart';
import 'package:getxflow/screens/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.android,
  // );
  // await PushNotifications.init();
  // FirebaseMessaging.onBackgroundMessage(
  //     _firebaseMessagingBackgroundHandler); // Register background message handler

  // await FirebaseInitializer.initialize(); // Initialize other services like notification setup

  // Inject controllers using GetX
  Get.put(LoginController()); // Login controller
  Get.put(DrawerLogicController()); //drawer controller
  runApp(const MyApp());
}

// Handle background FCM messages
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/booking', page: () => DriverRideListScreen()),
        GetPage(name: '/event', page: () => EventScreen()),
        GetPage(name: '/profile', page: () => UserProfilePage()),
        GetPage(name: '/location', page: () => LocationScreen()),
        GetPage(name: '/notifications', page: () => NotificationScreen()),
        // GetPage(name: '/driverEndRoute', page: () => DriverEndRoute())
      ],
    );
  }
}
