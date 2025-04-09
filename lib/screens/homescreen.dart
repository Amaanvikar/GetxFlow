import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/home_screen_controller.dart';
import 'package:getxflow/models/driver_status_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.put(HomeScreenController());

    // Fetch the driver's status when the screen loads
    controller.fetchDriverStatus();

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFB42318),
        iconTheme: IconThemeData(color: Colors.white),
        title: Obx(
          () => Text(
            controller.title.value,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          Row(
            children: [
              Obx(() => Text(
                    controller.isOnline.value ? "Online" : "Offline",
                    style: const TextStyle(color: Colors.white),
                  )),
              Obx(() => Switch(
                    value: controller.isOnline.value,
                    onChanged: (value) {
                      if (controller.driverStatus.value != null) {
                        // Update the driver status dynamically before toggling
                        DriverStatus updatedStatus = DriverStatus(
                          vdLogId: controller.driverStatus.value!.vdLogId,
                          status: value,
                          currentVdLat:
                              controller.driverStatus.value!.currentVdLat,
                          currentVdLon:
                              controller.driverStatus.value!.currentVdLon,
                          reason: controller.driverStatus.value!.reason,
                          currentStatus:
                              controller.driverStatus.value!.currentStatus,
                        );
                        controller.toggleDriverStatus(updatedStatus);
                      }
                    },
                    activeColor: Colors.white60,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white24,
                  )),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.driverStatus.value == null) {
            return CircularProgressIndicator();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.driverStatus.value!.reason),
                Text(
                    "Current Status: ${controller.driverStatus.value!.currentStatus}"),
                Text(
                    "Latitude: ${controller.driverStatus.value!.currentVdLat}"),
                Text(
                    "Longitude: ${controller.driverStatus.value!.currentVdLon}"),
              ],
            );
          }
        }),
      ),
    );
  }
}
