import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:getxflow/screens/driver_ride_list_screen.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:getxflow/screens/home.dart';
import 'package:getxflow/screens/login.dart';
import 'package:getxflow/screens/otp_screen.dart';
import 'package:getxflow/screens/user_profile_screen.dart';
import 'package:getxflow/screens/splash.dart';
import 'package:getxflow/screens/user_registeration_screen.dart';

void main() async {
  // await GetStorage.init();
  Get.put(LoginController()); // Ensure controller is initialized

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
        GetPage(name: '/otp', page: () => OtpScreen()),
        GetPage(name: '/register', page: () => UserRegistrationPage()),

        GetPage(name: '/home', page: () => DriverRideListScreen()),
        GetPage(name: '/profile', page: () => UserProfilePage()),

        // GetPage(name: '/search', page: () => SearchScreen()),
      ],
    );
  }
}
