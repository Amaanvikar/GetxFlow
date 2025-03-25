import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/user_profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final UserProfileController controller = Get.put(UserProfileController());
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    controller.fetchProfileData();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _logout() {
    controller.driverProfile.value = null;
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = controller.driverProfile.value;
        if (profile == null) {
          return Center(
            child: Text("Fetching profile..."),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : NetworkImage(
                              "https://windhans.com/2022/hrcabs/uploads/${profile.profileImage}"),
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt,
                            color: Colors.blue, size: 30),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // User Details
              buildProfileDetail(
                  "Name", "${profile.firstName} ${profile.lastName}"),
              buildProfileDetail("Mobile", profile.mobile),
              buildProfileDetail("Email", profile.email),
              buildProfileDetail("Permanent Address", profile.permanentAddress),
              buildProfileDetail("Present Address", profile.presentAddress),
              buildProfileDetail("Gender", profile.gender),
              buildProfileDetail("Date of Birth", profile.dob),
              buildProfileDetail(
                  "Driving License No", profile.drivingLicenseNo),
              buildProfileDetail("License Expiry", profile.licenseExpiry),
              buildProfileDetail("Badge Number", profile.badgeNumber),

              const SizedBox(height: 20),

              // Vehicle Details
              Text("Vehicle Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              buildProfileDetail("Model", profile.vehicleModel),
              buildProfileDetail("Registration No", profile.vehicleNumber),

              const SizedBox(height: 20),

              // Logout Button
              ElevatedButton(
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
