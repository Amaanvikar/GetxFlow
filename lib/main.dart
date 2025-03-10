import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/screens/home.dart';
import 'package:getxflow/screens/splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
    );
  }
}
