import 'package:get/get.dart';
import 'package:getxflow/models/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var title = 'HomeScreen'.obs;
  var message = "Welcome to HrCabDriver".obs;
  var profile = Rxn<DriverProfile>();
}
