import 'package:get/get.dart';
import 'package:getxflow/models/ride_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverRideController extends GetxController {
  var rideList = <RideRequest>[].obs;
  var filteredRideList =
      <RideRequest>[].obs; // List to store filtered rides based on status
  var selectedStatus = '5'.obs;
  var isLoading = true.obs;
  var isBooking = true.obs;
  var driverId = ''.obs;

  var showFilters = false.obs;
  var searchQuery = ''.obs;
  var allRides = <RideRequest>[].obs;

  @override
  void onInit() {
    fetchDriverRides();
    super.onInit();
  }

  void fetchDriverRides() async {
    String status = selectedStatus.value.toString();
    // print("Fetching rides for status: ${selectedStatus.value}");

    filteredRideList.value = allRides.where((ride) {
      String bookingStatus = ride.bookingStatus.toString();
      return bookingStatus == status || status == '5';
    }).toList();

    // print("Filtered List Length: ${filteredRideList.length}");

    try {
      isLoading(true);
      var url = Uri.parse("https://windhans.com/2022/hrcabs/getDriverRideList");
      var response = await http.post(url, body: {
        'driver_id': driverId.value,
        'is_book': selectedStatus.value.toString(),
        'page': '1',
      });

      if (response.statusCode == 200) {
        // print("API Response: ${response.body}");
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

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
