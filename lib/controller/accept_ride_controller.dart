import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AcceptRideController extends GetxController {
  var isLoading = false.obs;

  Future<void> acceptRide({
    required String vdLogId,
    required String rideReturnLogId,
    required String rideRequestId,
    required String duration,
  }) async {
    isLoading.value = true;

    final url = Uri.parse("https://windhans.com/2022/hrcabs/acceptRideDriver");
    final body = {
      'vd_log_id': vdLogId,
      'ride_return_log_id': rideReturnLogId,
      'ride_request_id': rideRequestId,
      'duration': duration,
    };

    try {
      final response = await http.post(url, body: body);
      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == true) {
          Get.snackbar("Success", "Ride accepted successfully");
        } else {
          Get.snackbar("Failed", data['reason']);
        }
      } else {
        Get.snackbar("Error", "Something went wrong: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Exception", e.toString());
    }
  }
}
