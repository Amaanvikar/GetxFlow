import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/controller/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.put(HomeScreenController());
    return Scaffold(
        bottomNavigationBar: const BottomNavigation(),
        appBar: AppBar(
          centerTitle: true,
          title: Obx(
            () => Text(
              controller.title.value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Center(
          child: Obx(() => Column(
                children: [Text(controller.message.value)],
              )),
        ));
  }
}
