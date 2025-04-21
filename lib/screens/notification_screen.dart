import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Use a Map to store all arguments
  late Map<String, dynamic> notificationData;

  @override
  void initState() {
    super.initState();

    // Initialize with an empty map initially
    notificationData = {};

    // Check for direct arguments passed via Get.arguments
    if (Get.arguments != null) {
      notificationData.addAll(Get.arguments as Map<String, dynamic>);
    }

    // Also check for any pending notification data
    _checkForPendingNotifications();
  }

  Future<void> _checkForPendingNotifications() async {
    // Check if there's any initial message when app is opened from a terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      setState(() {
        notificationData.addAll(initialMessage.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the received notification data
            Text('Driver Name: ${notificationData['driverName'] ?? 'Unknown'}'),
            Text(
                'Driver Mobile: ${notificationData['driverMobile'] ?? 'Unknown'}'),
            Text(
                'Pickup Location: ${notificationData['pickupLocation'] ?? 'Unknown'}'),
            Text(
                'Drop Location: ${notificationData['dropLocation'] ?? 'Unknown'}'),
            Text('Pickup Lat: ${notificationData['pickupLat'] ?? 'Unknown'}'),
            Text('Pickup Long: ${notificationData['pickupLong'] ?? 'Unknown'}'),
            Text('Drop Lat: ${notificationData['dropLat'] ?? 'Unknown'}'),
            Text('Drop Long: ${notificationData['dropLong'] ?? 'Unknown'}'),
            Text('Duration: ${notificationData['duration'] ?? 'Unknown'}'),
            Text(
                'Vehicle Model: ${notificationData['vehicleModel'] ?? 'Unknown'}'),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
