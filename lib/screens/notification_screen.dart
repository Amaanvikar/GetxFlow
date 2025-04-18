import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:getxflow/controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;

  NotificationScreen({super.key, required this.payload});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final LocationController locationController = Get.put(LocationController());

  late String title;
  late String body;

  @override
  void initState() {
    super.initState();

    try {
      final Map<String, dynamic> data = jsonDecode(widget.payload);
      title = data['title']?.toString() ?? 'No title';
      body = data['body']?.toString() ?? 'No message';
    } catch (e) {
      title = 'Invalid';
      body = 'Failed to parse notification data.';
      print('Error decoding payload: $e');
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title: $title",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Message: $body",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
