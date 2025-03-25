import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/driver_ride_controller.dart';

class DriverRideListScreen extends StatefulWidget {
  const DriverRideListScreen({super.key});

  @override
  State<DriverRideListScreen> createState() => _DriverRideListScreenState();
}

class _DriverRideListScreenState extends State<DriverRideListScreen> {
  final DriverRideController controller = Get.put(DriverRideController());

  // List of status options
  final List<String> statusOptions = [
    'All',
    'Pending',
    'Scheduled',
    'Started',
    'Ended',
    'Canceled'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Rides")),
      body: Column(
        children: [
          // DropdownButton for status selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: controller.selectedStatus.value,
              items: statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedStatus.value = newValue;
                  controller.filterRides(newValue);
                }
              },
            ),
          ),
          // ListView displaying filtered rides
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount:
                    controller.filteredRideList.length, // Use filtered list
                itemBuilder: (context, index) {
                  var ride = controller.filteredRideList[index];

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

          // Obx(() {
          //   return ListView.builder(
          //     itemCount: controller.rideList.length,
          //     itemBuilder: (context, index) {
          //       var ride = controller.rideList[index];
          //       return Card(
          //         elevation: 4,
          //         margin: EdgeInsets.all(10),
          //         child: ListTile(
          //           title: Text(
          //             "is_booking",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           subtitle: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text("Pending: "),
          //               Text("Scheduled: "),
          //               Text("Started: "),
          //               Text("Ended: "),
          //               Text("Cancelled: "),
          //               Text("All: "),
          //               Text("Driver Arriving: "),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   );
          // }),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
