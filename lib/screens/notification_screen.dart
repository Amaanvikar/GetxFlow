import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:getxflow/controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());
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
      body: RefreshIndicator(
        onRefresh: notificationController.refreshNotifications,
        child: notificationController.notifications.isEmpty
            ? const Center(
                child: Text("No notifications yet.",
                    style: TextStyle(fontSize: 16)),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: notificationController.notifications.length,
                itemBuilder: (context, index) {
                  final item = notificationController.notifications[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: Text(item['title'] ?? 'No title'),
                      subtitle: Text(item['body'] ?? 'No message'),
                      trailing: Text(item['timestamp'] ?? '',
                          style: const TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
