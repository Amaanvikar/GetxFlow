import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/controller/user_profile_controller.dart';
import 'package:getxflow/screens/homescreen.dart';
import 'package:getxflow/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final UserProfileController controller = Get.put(UserProfileController());

  // Fetch the existing BottomNavController instance
  final BottomNavController bottomNavController =
      Get.find<BottomNavController>();

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

  // Logout function to clear session
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored session data
    Get.offAllNamed(
        '/login'); // Navigate to login screen and remove all previous routes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('User Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: BackButton(onPressed: () {
          bottomNavController.selectedIndex.value = 0;
          Get.offAll(HomeScreen());
        }), // Uses system behavior
      ),
      body: Obx(() {
        if (controller.isLoading.value) {}

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
                              "https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg?semt=ais_hybrid}"),
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
                onPressed: () async {
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB42318),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const BottomNavigation(),
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
