import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetching the passed user data from Get.arguments
    final Map<String, dynamic>? userDetails = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'HomeScreen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (userDetails != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://windhans.com/uploads/${userDetails['profile_pic']}",
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome, ${userDetails['name']}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Email: ${userDetails['email']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                "Mobile: ${userDetails['mobile']}",
                style: const TextStyle(fontSize: 18),
              ),
            ] else
              const Center(child: Text('No user data available')),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
