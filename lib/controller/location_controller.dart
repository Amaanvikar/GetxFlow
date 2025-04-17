import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final Location _location = Location();
  final Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    if (permission == PermissionStatus.granted) {
      LocationData? locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        currentLatLng.value =
            LatLng(locationData.latitude!, locationData.longitude!);
      }

      _location.onLocationChanged.listen((newLocation) {
        if (newLocation.latitude != null && newLocation.longitude != null) {
          currentLatLng.value =
              LatLng(newLocation.latitude!, newLocation.longitude!);
          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newLatLng(currentLatLng.value!),
            );
          }
        }
      });
    } else {
      print("Permission not granted");
    }
  }
}
