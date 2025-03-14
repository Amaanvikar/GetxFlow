import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DrawerController drawerController = Get.put(DrawerController(
    alignment: DrawerAlignment.start,
    child: Text('null'),
  ));

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
            title: Text('Home'),
            onTap: () {
              // Close the drawer and navigate to the home screen
              Navigator.pop(context);
              // Use GetX for navigation or any other navigation method
              Get.toNamed('/home');
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // Close the drawer and navigate to the profile screen
              Navigator.pop(context);
              Get.toNamed('/profile');
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Close the drawer and navigate to the settings screen
              Navigator.pop(context);
              Get.toNamed('/settings');
            },
          ),
          // More Drawer Items can go here
        ],
      ),
    );
  }
}
