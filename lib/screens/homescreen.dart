// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getxflow/common/widget/bottom_nav.dart';
// import 'package:getxflow/common/widget/drawer_widget.dart';
// import 'package:getxflow/controller/home_screen_controller.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeScreenController controller = Get.put(HomeScreenController());
//     return Scaffold(
//         drawer: DrawerWidget(),
//         // bottomNavigationBar: const BottomNavigation(),
//         appBar: AppBar(
//           centerTitle: true,
//           automaticallyImplyLeading: true,
//           backgroundColor: Color(0xFFB42318),
//           iconTheme: IconThemeData(color: Colors.white),
//           title: Obx(
//             () => Text(
//               controller.title.value,
//               style:
//                   TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//           actions: [
//             Row(
//               children: [
//                 Obx(() => Text(
//                       controller.isOnline.value ? "Online" : "Offline",
//                       style: const TextStyle(color: Colors.white),
//                     )),
//                 Obx(() => Switch(
//                       value: controller.isOnline.value,
//                       onChanged: (value) {
//                         controller.isOnline.value = value;
//                       },
//                       activeColor: Colors.white60,
//                       inactiveThumbColor: Colors.grey,
//                       inactiveTrackColor: Colors.white24,
//                     )),
//               ],
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//           ],
//         ),
//         body: Center(
//           child: Obx(() => Column(
//                 children: [Text(controller.message.value)],
//               )),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/driver_status_controller.dart';

class HomeScreen extends StatelessWidget {
  final DriverStatusController driverStatusController =
      Get.put(DriverStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Status"),
      ),
      body: Obx(() {
        if (driverStatusController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the status from the response (this should be based on the fetched driver status)
        var currentStatus = driverStatusController.selectedStatus.value == '1'
            ? "Online"
            : "Offline";

        // Print the current status to the terminal
        print("Current Status: $currentStatus");

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status toggle switch (Online / Offline)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current Status: $currentStatus"),
                  Switch(
                    value: driverStatusController.selectedStatus.value == '1',
                    onChanged: (value) {
                      driverStatusController.updateStatus(value ? '1' : '0');
                    },
                  ),
                ],
              ),

              // Display the status message from the fetched data
              Expanded(
                child: ListView.builder(
                  itemCount: driverStatusController.driverStatus.length,
                  itemBuilder: (context, index) {
                    final status = driverStatusController.driverStatus[index];
                    return ListTile(
                      title: Text(status.status),
                      subtitle: Text(status.message),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
