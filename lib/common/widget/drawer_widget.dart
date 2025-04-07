import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/drawer_controller.dart';
import 'package:getxflow/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DrawerLogicController controller = Get.put(DrawerLogicController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text('Aman Pathan'),
            accountEmail: Text('amanp@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text('A', style: TextStyle(color: Colors.white)),
            ),
          ),
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
              onTap: () async {
                bool shouldLogout =
                    await controller.showLogoutConfirmationDialog();

                if (shouldLogout) {
                  // Clear shared preferences and navigate to login
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();

                  Get.offAll(() =>
                      LoginPage()); // Navigate to login screen and remove all previous routes
                }
              })
        ],
      ),
    );
  }
}
