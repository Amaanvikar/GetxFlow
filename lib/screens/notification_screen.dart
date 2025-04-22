import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/utils.dart';
import 'package:getxflow/controller/accept_ride_controller.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert'; // For parsing the JSON string

class NotificationScreen extends StatefulWidget {
  final String? data;

  const NotificationScreen({Key? key, this.data}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final LocationController locationController = Get.put(LocationController());
  final AcceptRideController acceptRideController =
      Get.put(AcceptRideController());

  late Map<String, dynamic> notificationData;

  @override
  void initState() {
    super.initState();

    // Parse the incoming notification data if available
    if (widget.data != null) {
      notificationData = jsonDecode(widget.data!);
      print('Parsed Notification Data: $notificationData');
    } else {
      notificationData = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB42318),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
              height: MediaQuery.of(context).size.height * 0.45,
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

            // Display only selected details from notification
            notificationData.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${notificationData['approximate_total_amount'] ?? '--'} Rs',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.black87),
                            SizedBox(width: 4),
                            Text("4.81", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.circle,
                                    size: 12, color: Colors.black),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                const Icon(Icons.square,
                                    size: 12, color: Colors.black),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${notificationData['msg'] ?? 'pickup_datetime'} (${notificationData['total_km'] ?? '--'} km) away",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notificationData['pickup_location'] ?? '--',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${notificationData['total_km'] ?? '--'} km trip",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notificationData['drop_location'] ?? '--',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF008080),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    acceptRideController.acceptRide(
                                        vdLogId: '',
                                        duration: '',
                                        rideReturnLogId: '',
                                        rideRequestId: '');
                                  },
                                  child: const Text("Confirm",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 12), // Spacing between buttons
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFB42318),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Handle Decline
                                  },
                                  child: const Text(
                                    "Decline",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const Center(child: Text('No notification data available')),
          ],
        );
      }),
    );
  }
}
