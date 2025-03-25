import 'dart:convert';
import 'package:get/get.dart';
import 'package:getxflow/models/user_profile_model.dart';
import 'package:http/http.dart' as http;

class UserProfileController extends GetxController {
  var driverProfile = Rxn<DriverProfile>(); // Observable driver profile
  var isLoading = false.obs; // Observable loading state

  Future<void> fetchProfileData() async {
    isLoading.value = true; // Show loading indicator

    try {
      final response = await http.post(
        Uri.parse('https://windhans.com/2022/hrcabs/driverProfile'),
        body: {'driver_id': '8'},
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['result'] == true &&
            jsonResponse['driver_profile'] != null) {
          driverProfile.value =
              DriverProfile.fromJson(jsonResponse['driver_profile']);
        } else {
          Get.snackbar("Error", "Profile not found");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile data");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }
}
