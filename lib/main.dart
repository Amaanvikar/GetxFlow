import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/controller/drawer_controller.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:getxflow/firebase/firebase_initializer.dart';
import 'package:getxflow/firebase/firebase_options.dart';
import 'package:getxflow/screens/driver_ride_list_screen.dart';
import 'package:getxflow/screens/events_screen.dart';
import 'package:getxflow/screens/homescreen.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:getxflow/screens/login.dart';
import 'package:getxflow/screens/user_profile_screen.dart';
import 'package:getxflow/screens/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handle background FCM messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize other services like notification setup
  await FirebaseInitializer.initialize();

  // Inject controllers using GetX
  Get.put(LoginController()); // Login controller
  // Get.lazyPut(() => BottomNavController()); // Bottom navigation controller
  Get.put(DrawerLogicController);
  runApp(const MyApp());
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

        // GetPage(name: '/search', page: () => SearchScreen()),
      ],
    );
  }
}
