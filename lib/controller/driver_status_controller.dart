import 'dart:convert';
import 'package:HrCabDriver/Api/ApiEndPoints/api_end_points.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class DriverStatusController extends GetxController {
  Rx<DriverStatus> driverStatus = DriverStatus(status: '', message: '').obs;
  var selectedStatus = '1'.obs;
  var selectedLogId = ''.obs;
  var isLoading = true.obs;
  var showFilters = false.obs;

  var currentLatitude = ''.obs;
  var currentLongitude = ''.obs;
  var driverId = ''.obs;

  @override
  void onInit() {
    fetchDriverStatus();
    super.onInit();
  }

  Future<void> fetchDriverStatus() async {
    try {
      isLoading(true);

      await updateCurrentLocation();

      var url = Uri.parse(ApiEndPoints.driverVehicleLogStatus);
      // Uri.parse("https://windhans.com/2022/hrcabs/getDriverStatus");
      print({
        'status': selectedStatus.value,
        'current_vd_lat': currentLatitude.value,
        'current_vd_lng': currentLongitude.value,
      });

      var response = await http.post(url, body: {
        'vd_log_id': selectedLogId.value,
        'status': selectedStatus.value,
        'current_vd_lat': currentLatitude.value,
        'current_vd_long': currentLongitude.value,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('success');
        print(data);
        if (data['result'] == true && data['current_status'] != null) {
          var statuses = DriverStatus.fromMap(data);
          driverStatus.value = statuses;
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

  Future<void> updateCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatitude.value = position.latitude.toString();
      currentLongitude.value = position.longitude.toString();

      print('Location updated: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  // Function to toggle filters for status
  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  Future<void> updateStatus(String status) async {
    selectedStatus.value = status;

    // If going online, update location first
    if (status == '0') {
      await updateCurrentLocation();
    }

    await fetchDriverStatus();
  }
}

class DriverStatus {
  final String status;
  final String? message;

  DriverStatus({
    required this.status,
    required this.message,
  });

  // Factory method to create DriverStatus object from map
  factory DriverStatus.fromMap(Map<String, dynamic> map) {
    return DriverStatus(
      status: map['current_status'],
      message: map['message'] ?? map['reason'] ?? '',
    );
  }
}
