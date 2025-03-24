import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final mobileController = TextEditingController().obs;
  final notificationTokenController = TextEditingController().obs;

  RxBool isloading = false.obs;

  Future<void> registerApi() async {
    isloading.value = true;
    try {
      final response = await post(
        Uri.parse("https://windhans.com/2022/hrcabs/userRegistration"),
        body: {
          'user_lname': nameController.value.text,
          'reg_email': emailController.value.text,
          'reg_mobile': mobileController.value.text,
          'reg_notification_token': notificationTokenController.value.text,
        },
      );

      var data = jsonDecode(response.body);
      isloading.value = false;

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: $data');

      // Handle response from the API
      if (response.statusCode == 200 && data['result'] == true) {
        print('Registration Successful!');
        Get.snackbar('Registration Successful', data['reason']);
        Get.toNamed('/home'); // Navigate to home screen
      } else {
        print('Registration Failed: ${data['reason']}');
        Get.snackbar('Registration Failed', data['reason'] ?? 'Unknown Error');
      }
    } catch (e) {
      isloading.value = false;
      print('Exception: $e');
      Get.snackbar('Exception', e.toString());
    }
  }
}
