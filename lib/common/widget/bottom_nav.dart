import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX controller instance
    final BottomNavController controller = Get.put(BottomNavController());
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) {
          controller.changeIndex(index);
          // Update the navigation using GetX
          switch (index) {
            case 0:
              Get.toNamed('/home');
              break;
            case 1:
              Get.toNamed('/search');
              break;
            case 2:
              Get.toNamed('/notifications');
              break;
            case 3:
              Get.toNamed('/settings');

              break;
            case 4:
              if (Get.currentRoute != '/profile') {
                Get.toNamed('/profile');
              }
              break;
            default:
              Get.toNamed('/home');
              break;
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType
            .fixed, // This ensures the labels are always visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'profile',
          ),
        ],
      );
    });
  }
}
