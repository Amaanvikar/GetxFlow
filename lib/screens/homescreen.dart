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
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/driver_status_controller.dart';

class HomeScreen extends StatelessWidget {
  final DriverStatusController driverStatusController =
      Get.put(DriverStatusController());

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
                  isOnline ? "Online" : "Offline",
                  style: const TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isOnline,
                  onChanged: (value) {
                    driverStatusController.updateStatus(value ? '1' : '0');
                  },
                  activeColor: Colors.white,
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: driverStatusController.driverStatus.length,
          itemBuilder: (context, index) {
            final status = driverStatusController.driverStatus[index];
            return ListTile(
              title: Text(status.status),
              subtitle: Text(status.message),
            );
          },
        );
      }),
    );
  }
}
