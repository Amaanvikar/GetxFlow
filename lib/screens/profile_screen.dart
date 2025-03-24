import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/login_controller.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  // Controller to store user data and image
  final LoginController controller = Get.find<LoginController>();
  File? _profileImage;

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Logout function
  void _logout() {
    // Clear stored user data (e.g., SharedPreferences or GetStorage)
    // For example, clear controller or local data.
    controller.emailController.value.clear();

    // Navigate back to the Login screen
    Get.offAllNamed('/login'); // Navigate to Login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _profileImage == null
                        ? AssetImage('assets/default_profile.png')
                        : FileImage(_profileImage!) as ImageProvider,
                    backgroundColor: Colors.grey[300],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // User email display
            Text(
              controller.emailController.value.text.isEmpty
                  ? 'No email provided'
                  : 'Number: ${controller.emailController.value.text}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
