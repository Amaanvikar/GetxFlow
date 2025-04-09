import 'package:get/get.dart';
import 'package:getxflow/models/driver_status_model.dart';
import 'package:getxflow/models/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreenController extends GetxController {
  var title = 'HomeScreen'.obs;
  var message = "Welcome to HrCabDriver".obs;
  var profile = Rxn<DriverProfile>();

  var isOnline = true.obs;
  var driverStatus = Rxn<DriverStatus>(); // Store the dynamic DriverStatus

  // Fetch driver status from the API
  Future<void> fetchDriverStatus() async {
    final String url = 'https://windhans.com/2022/hrcabs/getDriverStatus';
    try {
      // Make the POST request (this is an example, you'd send relevant data like vd_log_id, etc.)
      final response = await http.post(
        Uri.parse(url),
        body: {
          'vd_log_id': '2', // Replace with actual dynamic VD Log ID
          'status': '0', // Initially assuming the driver is online
          'current_vd_lat':
              '19.9977379', // Current latitude (you can fetch this dynamically)
          'current_vd_lon':
              '73.7833659', // Current longitude (you can fetch this dynamically)
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['result'] == true) {
          // Parse the response into DriverStatus
          driverStatus.value = DriverStatus.fromJson(data);
          // Update the UI message
          message.value = driverStatus.value!.reason;
          isOnline.value = driverStatus.value!.status;
        } else {
          message.value = "Failed to fetch driver status";
        }
      } else {
        message.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      message.value = "Error: $e";
    }
  }

  // Function to toggle driver status with dynamic parameters
  Future<void> toggleDriverStatus(DriverStatus status) async {
    final String url = 'https://windhans.com/2022/hrcabs/getDriverStatus';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: status.toMap(), // Use the dynamic status data
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['result'] == true) {
          // Update the status and message based on the response
          driverStatus.value =
              DriverStatus.fromJson(data); // Parse updated driver status
          message.value = driverStatus.value!.reason;
          isOnline.value = !isOnline.value; // Toggle the online status
        } else {
          message.value = "Failed to change status";
        }
      } else {
        message.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      message.value = "Error: $e";
    }
  }
}
