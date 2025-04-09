import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DriverStatusController extends GetxController {
  var driverStatus = <DriverStatus>[].obs;
  var selectedStatus = '1'.obs;
  var isLoading = true.obs;
  var showFilters = false.obs;

  var currentLatitude = ''.obs;
  var currentLongitude = ''.obs;

  @override
  void onInit() {
    fetchDriverStatus();
    super.onInit();
  }

  void fetchDriverStatus() async {
    String status = selectedStatus.value.toString();
    try {
      isLoading(true);
      var url = Uri.parse("https://windhans.com/2022/hrcabs/getDriverStatus");
      var response = await http.post(url, body: {
        'd_log_id': '2',
        'status': selectedStatus.value.toString(),
        'current_vd_lat': currentLatitude.value.toString(),
        'current_vd_lng': currentLongitude.value.toString(),
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['result'] == true && data['status'] != null) {
          var statuses = List<DriverStatus>.from(
              data['status'].map((x) => DriverStatus.fromMap(x)));
          driverStatus.assignAll(statuses);
        } else {
          print("No status data found");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  // Function to toggle filters for status
  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  // Function to update the selected status
  void updateStatus(String status) {
    selectedStatus.value = status;
    fetchDriverStatus(); // Re-fetch status when selection changes
  }
}

class DriverStatus {
  final String status;
  final String message;

  DriverStatus({
    required this.status,
    required this.message,
  });

  // Factory method to create DriverStatus object from map
  factory DriverStatus.fromMap(Map<String, dynamic> map) {
    return DriverStatus(
      status: map['status'],
      message: map['message'],
    );
  }
}
