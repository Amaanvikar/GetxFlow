import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/controller/driver_ride_controller.dart';
import 'package:getxflow/screens/ride_list_details_screen.dart';

class DriverRideListScreen extends StatefulWidget {
  const DriverRideListScreen({super.key});

  @override
  State<DriverRideListScreen> createState() => _DriverRideListScreenState();
}

class _DriverRideListScreenState extends State<DriverRideListScreen> {
  final DriverRideController controller = Get.put(DriverRideController());
  final BottomNavController bottomNavController =
      Get.find<BottomNavController>();

  // Status Mapping
  final Map<String, String> statusMap = {
    'All': '5',
    'Pending': '0',
    'Scheduled': '1',
    'Started': '2',
    'Ended': '3',
    'Cancelled': '4',
    'Driver Arriving': '6',
  };

  Widget buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Obx(() => Text(
                  'Showing results for: ${controller.searchQuery.value}'))),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.filter_list,
                color:
                    controller.showFilters.value ? Colors.green : Colors.grey),
            onPressed: controller.toggleFilters,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(),
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Driver Rides", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: BackButton(onPressed: () {
          bottomNavController.selectedIndex.value = 0;
          Get.back();
        }),
      ),
      body: Column(
        children: [
          // DropdownButton for status selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return DropdownButton<String>(
                value: statusMap.keys.firstWhere(
                  (key) => statusMap[key] == controller.selectedStatus.value,
                  orElse: () => 'All', // Default to "All" if no match
                ),
                items: statusMap.keys.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedStatus.value = statusMap[newValue]!;
                    print(
                        "Selected Status: ${controller.selectedStatus.value}");

                    controller.fetchDriverRides();
                  }
                },
              );
            }),
          ),
          // ListView displaying filtered rides
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.rideList.length,
                itemBuilder: (context, index) {
                  var ride = controller.rideList[index];

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        "Ride No: ${ride.rideBookingNumber}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pickup: ${ride.pickupLocation}"),
                          Text("Drop: ${ride.dropLocation}"),
                          Text("Status: ${ride.bookingStatus}",
                              style: TextStyle(
                                  color: ride.isBooked == 3
                                      ? Colors.green
                                      : ride.isBooked == 4
                                          ? Colors.red
                                          : Colors.orange)),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Get.to(
                            RideListDetailsScreen(
                              ride: controller.rideList[index],
                            ),
                            arguments: ride,
                          );
                          print("Ride ID: ${ride.rideBookingNumber}");
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
