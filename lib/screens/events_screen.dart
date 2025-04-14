import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getxflow/controller/event_screen_controller.dart';
import 'package:getxflow/screens/homescreen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventScreenController _controller = Get.put(EventScreenController());
  // final BottomNavController bottomNavController =
  //     Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB42318),
        centerTitle: true,
        title: Obx(
          () => Text(
            _controller.title.value,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/img_ic_down.svg',
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              // bottomNavController.selectedIndex.value = 0;
              Get.offAll(() => HomeScreen());
            }),
      ),
      body: Center(
        child: Obx(
          () => Column(
            children: [
              Text(_controller.message.value),
            ],
          ),
        ),
      ),
    );
  }
}
