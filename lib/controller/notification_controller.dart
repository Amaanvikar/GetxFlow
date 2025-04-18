import 'package:get/get.dart';

class NotificationController extends GetxController {
  List<Map<String, String>> notifications = [
    {
      'title': 'Ride Scheduled',
      'body': 'Your ride to Mumbai is scheduled at 5:30 PM.',
      'timestamp': 'Just now',
    },
    {
      'title': 'Driver Reaching Soon',
      'body': 'Your driver is 5 minutes away!',
      'timestamp': '10 mins ago',
    },
  ];

  Future<void> refreshNotifications() async {
    // You can replace this with real API or database call
    await Future.delayed(const Duration(seconds: 2));
    // For example, reverse the list to simulate a refresh
    notifications = List.from(notifications.reversed);
  }
}
