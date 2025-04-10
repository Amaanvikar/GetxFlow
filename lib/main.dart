import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:getxflow/firebase_options.dart';
import 'package:getxflow/screens/driver_ride_list_screen.dart';
import 'package:getxflow/screens/events_screen.dart';
import 'package:getxflow/screens/homescreen.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:getxflow/screens/login.dart';
import 'package:getxflow/screens/user_profile_screen.dart';
import 'package:getxflow/screens/splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  // await GetStorage.init();
  Get.put(LoginController()); // Ensure controller is initialized
  Get.lazyPut(() => BottomNavController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
