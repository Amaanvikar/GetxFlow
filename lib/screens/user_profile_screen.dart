import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:HrCabDriver/controller/user_profile_controller.dart';
import 'package:HrCabDriver/screens/homescreen.dart';
import 'package:HrCabDriver/screens/login.dart';
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
  // final BottomNavController bottomNavController =
  //     Get.find<BottomNavController>();

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
        backgroundColor: const Color(0xFFB42318),
        centerTitle: true,
        title: const Text('Driver Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAll(() => HomeScreen()),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.driverProfile.value;
        if (profile == null) {
          return const Center(child: Text("Fetching profile..."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // PROFILE IMAGE
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (profile.prof_pic.isNotEmpty
                            ? NetworkImage(
                                'https://windhans.com/2022/hrcabs/images/${profile.prof_pic}')
                            : null) as ImageProvider?,
                    backgroundColor: Colors.grey[300],
                    child: (profile.prof_pic.isEmpty && _profileImage == null)
                        ? const Icon(Icons.account_circle,
                            size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.black87, size: 22),
                      ),
                    ),
                  ),
                ],
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

              // LOGOUT BUTTON
              ElevatedButton.icon(
                onPressed: () async {
                  final shouldLogout =
                      await controller.showLogoutConfirmationDialog();
                  if (shouldLogout) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.offAll(() => const LoginPage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB42318),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        );
      }),
      // bottomNavigationBar: const BottomNavigation(),
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
