import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerLogicController extends GetxController {
  var selectedIndex = 0.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    showLogoutConfirmationDialog();
  }

  Future<bool> showLogoutConfirmationDialog() async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text(
              "Confirmation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB42318),
              ),
            ),
            content: const Text(
              "Are you sure you want to sign out?",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Cancel",
                    style: TextStyle(color: Color(0xFFB42318))),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB42318)),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
