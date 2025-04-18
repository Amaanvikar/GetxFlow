import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFB42318),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Location Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        final position = locationController.currentLatLng.value;
        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Map container
            Container(
              height: MediaQuery.of(context).size.height *
                  0.45, // 65% of screen height
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GoogleMap(
                  onMapCreated: locationController.setMapController,
                  initialCameraPosition: CameraPosition(
                    target: position,
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),

            // Placeholder for future features
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.navigation),
                      label: const Text("Navigate to Location"),
                    ),
                    // Add more widgets here

                    //          RefreshIndicator(
                    //   onRefresh: notificationController.refreshNotifications,
                    //   child: notificationController.notifications.isEmpty
                    //       ? const Center(
                    //           child: Text("No notifications yet.",
                    //               style: TextStyle(fontSize: 16)),
                    //         )
                    //       : ListView.builder(
                    //           padding: const EdgeInsets.all(10),
                    //           itemCount: notificationController.notifications.length,
                    //           itemBuilder: (context, index) {
                    //             final item =
                    //                 notificationController.notifications[index];
                    //             return Card(
                    //               elevation: 2,
                    //               margin: const EdgeInsets.symmetric(vertical: 6),
                    //               child: ListTile(
                    //                 leading: const Icon(Icons.notifications_active),
                    //                 title: Text(item['title'] ?? 'No title'),
                    //                 subtitle: Text(item['body'] ?? 'No message'),
                    //                 trailing: Text(item['timestamp'] ?? '',
                    //                     style: const TextStyle(fontSize: 12)),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
