import 'package:get/get.dart';
import 'package:getxflow/models/ride_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverRideController extends GetxController {
  var rideList = <RideRequest>[].obs;
  var filteredRideList =
      <RideRequest>[].obs; // List to store filtered rides based on status
  var selectedStatus = 'All'.obs; // Default value is 'All'

  var isLoading = true.obs;
  var isBooking = true.obs;

  @override
  void onInit() {
    fetchDriverRides();
    super.onInit();
  }

  void fetchDriverRides() async {
    try {
      isLoading(true);
      var url = Uri.parse("https://windhans.com/2022/hrcabs/getDriverRideList");
      var response = await http.post(url, body: {
        'driver_id': '8',
        'is_book': '3',
        'page': '1',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['result'] == true && data['rides'] != null) {
          var rides = List<RideRequest>.from(
              data['rides'].map((x) => RideRequest.fromMap(x)));
          rideList.assignAll(rides);
        } else {
          print("No rides found");
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

  // Function to filter rides based on selected status
  void filterRides(String status) {
    if (status == 'All') {
      filteredRideList.assignAll(rideList);
    } else {
      filteredRideList.assignAll(
          rideList.where((ride) => ride.bookingStatus == status).toList());
    }
  }
}
