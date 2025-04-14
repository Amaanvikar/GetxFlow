import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/driver_status_controller.dart';

class HomeScreen extends StatelessWidget {
  final DriverStatusController driverStatusController =
      Get.put(DriverStatusController());

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
          style: TextStyle(color: Colors.white),
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
                        color: Colors.white, strokeWidth: 2),
                  ),
                ),
              );
            }

            final isOnline = driverStatusController.selectedStatus.value == '1';

            return Row(
              children: [
                Text(
                  isOnline ? "Offline" : "Online",
                  style: const TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isOnline,
                  onChanged: (value) {
                    driverStatusController.updateStatus(value ? '1' : '0');
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.green,
                ),
              ],
            );
          }),
        ],
      ),
      body: Center(),
    );
  }
}
