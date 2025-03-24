import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class LoginController extends GetxController {
  final mobileController = TextEditingController().obs;
  RxBool isloading = false.obs;

  Future<void> loginApi() async {
    isloading.value = true;
    try {
      final response = await post(
        Uri.parse("https://windhans.com/2022/hrcabs/userLoginOTP"),
        body: {
          'reg_mobile': mobileController.value.text,
        },
      );

      var data = jsonDecode(response.body);
      isloading.value = false;

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: $data');

      // Check if response is successful and contains the required data
      if (response.statusCode == 200 && data['result'] == true) {
        print('OTP Sent, navigating to OTP Screen.');

        // Navigate to OTP Screen and pass mobile number
        Get.toNamed('/otp', arguments: {
          'mobile': mobileController.value.text,
        });

        Get.snackbar('OTP Sent', data['reason'],
            snackPosition: SnackPosition.BOTTOM);

        // print('Login Successful, navigating to Home Page.');
        // Get.snackbar('Login Successful', data['reason']); // Show OTP reason
        // Get.toNamed('/home'); // Navigate to home screen
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
}
