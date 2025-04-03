import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/screens/driver_ride_list_screen.dart';
import 'package:getxflow/screens/events_screen.dart';
import 'package:getxflow/screens/homescreen.dart';
import 'package:getxflow/screens/user_profile_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomeScreen(),
    DriverRideListScreen(),
    EventScreen(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          )),
    );
  }
}
