import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  RxBool isloading = false.obs;

  Future<void> loginApi() async {
    isloading.value = true;
    try {
      final response = await post(Uri.parse("https://reqres.in/api/register"),
          body: {
            'email': emailController.value.text,
            'password': passwordController.value.text
          });

      var data = jsonDecode(response.body);
      isloading.value = false;
      print(response.statusCode);
      print(data);

      if (response.statusCode == 200) {
        isloading.value = false;
        Get.snackbar('Login Succesfull', 'Congratulations');
      } else {
        isloading.value = false;
        Get.snackbar('Login Failed', data['error']);
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }
}
