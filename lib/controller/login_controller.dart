import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getxflow/models/user_profile_model.dart';
import 'package:getxflow/screens/login.dart';
import 'package:getxflow/screens/user_profile_screen.dart';
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
      final response = await post(
        Uri.parse("https://windhans.com/2022/hrcabs/driverLogin"),
        body: {
          'login_name': emailController.text,
          'login_pass': passwordController.text,
          'notification_token': '',
        },
      );

      var data = jsonDecode(response.body);
      isloading.value = false;

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: $data');

      if (response.statusCode == 200 && data['result'] == true) {
        print('Login Successful, navigating to Home Page.');
        Get.snackbar('Login Successful', data['reason']);

        // Save session details
        await saveUserSession(data);

        Get.toNamed('/home');
      } else {
        print('Login Failed: ${data['reason']}');
        Get.snackbar('Login Failed', data['reason'] ?? 'Unknown Error');
      }
    } catch (e) {
      isloading.value = false;
      print('Exception: $e');
      Get.snackbar('Exception', e.toString());
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
      Get.offAll(() => UserProfilePage());
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
}
