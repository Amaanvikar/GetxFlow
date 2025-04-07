import 'package:get/get.dart';
import 'package:getxflow/models/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var title = 'HomeScreen'.obs;
  var message = "This is HomeScreen".obs;
  var profile = Rxn<DriverProfile>();
}
