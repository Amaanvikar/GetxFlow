import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/bottom_nav.dart';
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.put(HomeScreenController());
    return Scaffold(
        drawer: DrawerWidget(),
        bottomNavigationBar: const BottomNavigation(),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFB42318),
          iconTheme: IconThemeData(color: Colors.white),
          title: Obx(
            () => Text(
              controller.title.value,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                        controller.isOnline.value = value;
                      },
                      activeColor: Colors.white60,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white24,
                    )),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: Center(
          child: Obx(() => Column(
                children: [Text(controller.message.value)],
              )),
        ));
  }
}
