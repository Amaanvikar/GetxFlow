import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/http/utils/body_decoder.dart';
import 'package:getxflow/models/user_profile_model.dart';
import 'package:getxflow/screens/homescreen.dart';
import 'package:getxflow/screens/login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var driverProfile = Rxn<DriverProfile>();
  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserSession();
  }

  Future<void> loginApi() async {
    isloading.value = true;
    try {
      print(
        {
          'login_name': emailController.text,
          'login_pass': passwordController.text,
          'notification_token': 'asasasasa5sa5sa5sa5ss5',
        },
      );
      final response = await post(
        Uri.parse("https://windhans.com/2022/hrcabs/driverLogin"),
        body: {
          'login_name': emailController.text,
          'login_pass': passwordController.text,
          'notification_token': 'asasasasa5sa5sa5sa5ss5',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (data['result'] == true) {
        Get.snackbar('Login Successful', data['reason']);
        await saveUserSession(data);
        Get.toNamed('/home');
      } else {
        Get.snackbar('Login Failed', data['reason'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Network Error', e.toString());
    } finally {
      isloading.value = false;
    }
  }

  // Save user session
  Future<void> saveUserSession(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', emailController.text);

    if (data.containsKey('token') && data['token'] != null) {
      await prefs.setString('userToken', data['token']);
    } else if (data['user_details'] != null &&
        data['user_details'].containsKey('reg_id')) {
      print("No token received, using reg_id instead.");
      await prefs.setString(
          'userToken', data['user_details']['reg_id'].toString());
    }
  }

  // Check if user is logged in
  Future<void> checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('userToken'); // Retrieves stored token or reg_id

    print("Stored Token (reg_id as fallback): $token"); // Debugging

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => HomeScreen());
    } else {
      print("User not logged in.");
    }
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => LoginPage());
  }

  Future<void> showLogoutConfirmation(BuildContext context) async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await logout();
    }
  }
}
