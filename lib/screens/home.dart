// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getxflow/common/widget/bottom_nav.dart';
// import 'package:getxflow/controller/home_screen_controller.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeScreenController controller = Get.put(HomeScreenController());
//     return Scaffold(
//         bottomNavigationBar: const BottomNavigation(),
//         appBar: AppBar(
//           backgroundColor: Color(0xFFB42318),
//           centerTitle: true,
//           title: Obx(
//             () => Text(
//               controller.title.value,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         body: Center(
//           child: Obx(() => Column(
//                 children: [Text(controller.message.value)],
//               )),
//         ));
//   }
// }
