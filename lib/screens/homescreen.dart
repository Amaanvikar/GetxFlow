import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/driver_status_controller.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  final DriverStatusController driverStatusController =
      Get.put(DriverStatusController());
  final LocationController locationController = Get.put(LocationController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFB42318),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Driver Status",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            if (driverStatusController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            final isOffline =
                driverStatusController.selectedStatus.value == '1';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  // Toggle status: 0 = online, 1 = offline
                  driverStatusController.updateStatus(isOffline ? '0' : '1');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOffline ? Colors.blueGrey : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOffline ? Icons.wifi_off : Icons.wifi,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOffline ? 'Go Online' : 'Go Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final position = locationController.currentLatLng.value;

        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: GoogleMap(
            onMapCreated: locationController.setMapController,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        );
      }),
    );
  }
}
