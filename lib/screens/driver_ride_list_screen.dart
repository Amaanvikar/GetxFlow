import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/bottom_nav_controller.dart';
import 'package:getxflow/controller/driver_ride_controller.dart';
import 'package:getxflow/screens/homescreen.dart';
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

  final TextEditingController searchController = TextEditingController();

  final Map<String, String> statusMap = {
    'All': '5',
    'Pending': '0',
    'Scheduled': '1',
    'Started': '2',
    'Ended': '3',
    'Cancelled': '4',
    'Driver Arriving': '6',
  };

  @override
  void initState() {
    super.initState();
    controller.fetchDriverRides();
    searchController.addListener(() {
      controller.searchQuery.value = searchController.text;
    });
  }

  List<dynamic> getFilteredRides() {
    final query = controller.searchQuery.value.toLowerCase();
    final selectedStatus = controller.selectedStatus.value;

    return controller.rideList.where((ride) {
      final matchesSearch =
          ride.rideBookingNumber.toString().toLowerCase().contains(query);
      final matchesStatus =
          selectedStatus == '5' || ride.isBooked.toString() == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Driver Rides",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: BackButton(onPressed: () {
          bottomNavController.selectedIndex.value = 0;
          Get.off(HomeScreen());
        }),
      ),
      body: Column(
        children: [
          // Search with Filter Toggle
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() => TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search by Ride No",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/images/img_ic_search.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: controller.showFilters.value
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: controller.toggleFilters,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )),
          ),

          // Dropdown Filter (if shown)
          Obx(() => controller.showFilters.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: statusMap.keys.firstWhere(
                      (key) =>
                          statusMap[key] == controller.selectedStatus.value,
                      orElse: () => 'All',
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
                        controller.fetchDriverRides();
                      }
                    },
                  ),
                )
              : const SizedBox()),

          // Ride List
          Expanded(
            child: Obx(() {
              var filteredRides = getFilteredRides();
              if (filteredRides.isEmpty) {
                return const Center(child: Text("No rides found"));
              }
              return ListView.builder(
                itemCount: filteredRides.length,
                itemBuilder: (context, index) {
                  var ride = filteredRides[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        "Ride No: ${ride.rideBookingNumber}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pickup: ${ride.pickupLocation}"),
                          Text("Drop: ${ride.dropLocation}"),
                          Text(
                            "Status: ${ride.bookingStatus}",
                            style: TextStyle(
                              color: ride.isBooked == 3
                                  ? Colors.green
                                  : ride.isBooked == 4
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Get.to(
                            RideListDetailsScreen(ride: ride),
                            arguments: ride,
                          );
                        },
                        child: const Icon(
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
