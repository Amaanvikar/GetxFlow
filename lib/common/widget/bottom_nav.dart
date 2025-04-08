import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              Get.toNamed('/booking');
              break;
            case 2:
              Get.toNamed('/event');
              break;
            case 3:
              Get.toNamed('/profile');
              break;
            default:
              Get.offAll('/home');
              break;
          }
        },
        type: BottomNavigationBarType
            .fixed, // This ensures the labels are always visible
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(controller.selectedIndex.value == 0
                ? 'assets/images/img_nav_home_selected.svg'
                : 'assets/images/img_nav_home.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(controller.selectedIndex.value == 1
                ? 'assets/images/img_nav_booking_selected.svg'
                : 'assets/images/img_nav_booking.svg'),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(controller.selectedIndex.value == 2
                ? 'assets/images/img_nav_event_selected.svg'
                : 'assets/images/img_nav_event.svg'),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(controller.selectedIndex.value == 3
                ? 'assets/images/img_nav_profile_selected.svg'
                : 'assets/images/img_nav_profile.svg'),
            label: 'Profile',
          ),
        ],
      );
    });
  }
}
