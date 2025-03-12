import 'package:get/get.dart';

// Controller to manage selected index
class BottomNavController extends GetxController {
  // Observable variable to track the selected index
  var selectedIndex = 0.obs;

  // Method to change the selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
