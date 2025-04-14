import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/drawer_controller.dart';
import 'package:getxflow/controller/login_controller.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DrawerLogicController controller = Get.put(DrawerLogicController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/app_logo.png'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Viru V Savale',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'drivert@gmail.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
            onTap: () => loginController.showLogoutConfirmation(context),
          ),
        ],
      ),
    );
  }
}
