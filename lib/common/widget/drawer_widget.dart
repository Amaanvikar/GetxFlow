import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/drawer_controller.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:getxflow/controller/user_profile_controller.dart';
import 'package:getxflow/models/user_profile_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final LoginController loginController = Get.put(LoginController());
  final DrawerLogicController controller = Get.put(DrawerLogicController());
  final UserProfileController driverProfileController =
      Get.put(UserProfileController());
  Rxn<DriverProfile> driverProfile = Rxn<DriverProfile>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Obx(() {
            final profile = driverProfileController.driverProfile.value;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: SvgPicture.asset(
                      'assets/images/img_nav_profile.svg',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile?.email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ],
              ),
            );
          }),
          // Drawer Items
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.home),
            onTap: () => Get.back(),
          ),
          ListTile(
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.person),
            onTap: () => Get.toNamed('/profile'),
          ),
          ListTile(
            title: Text(
              'Ride Booking',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.book_online),
            onTap: () => Get.toNamed('/booking'),
          ),
          ListTile(
            title: Text(
              'Notification',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.notification_add),
            onTap: () => Get.toNamed('/notifications'),
          ),
          ListTile(
            title: Text(
              'Event',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.event),
            onTap: () => Get.toNamed('/event'),
          ),
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.settings),
            onTap: () => Get.toNamed('/settings'),
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 16),
            ),
            leading: Icon(Icons.logout),
            onTap: () => loginController.showLogoutConfirmation(context),
          ),

          Spacer(),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Divider(),
                Image.asset(
                  'assets/images/cabicon.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Powered by Windhans Technology',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
