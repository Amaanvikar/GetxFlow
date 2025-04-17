import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getxflow/models/user_profile_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreenController extends GetxController {
  var title = 'HomeScreen'.obs;
  var message = "Welcome to HrCabDriver".obs;
  var profile = Rxn<DriverProfile>();
  var currentPosition = Rxn<Position>();
  var locationMessage = "Fetching location...".obs;

  GoogleMapController? mapController;

  final RxList<Marker> markers = <Marker>[].obs;
  final RxSet<Circle> circles = <Circle>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final List<LatLng> locationPoints = [
    LatLng(9.9975, 73.7898),
    LatLng(19.0760, 72.8777),
    LatLng(12.9716, 77.5946),
  ];

  final Rxn<LatLng> _mapLocation = Rxn<LatLng>();
  LatLng? get mapLocation => _mapLocation.value;

  final Location locationService = Location();

  // Future<void> getCurrentLocation() async {
  //   var locationPermission = await _locationService.hasPermission();
  //   if (locationPermission == PermissionStatus.denied) {
  //     locationPermission = await _locationService.requestPermission();
  //   }

  //   if (locationPermission == PermissionStatus.granted) {
  //     final currentLocation = await _locationService.getLocation();

  //     _mapLocation.value = LatLng(
  //       currentLocation.latitude ?? 0.0,
  //       currentLocation.longitude ?? 0.0,
  //     );

  //     locationMessage.value =
  //         "Current location: ${_mapLocation.value!.latitude}, ${_mapLocation.value!.longitude}";

  //     if (_mapController != null) {
  //       _mapController!.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(target: _mapLocation.value!, zoom: 15),
  //         ),
  //       );
  //     }

  //     _buildMapElements();
  //   } else {
  //     locationMessage.value = "Location permission denied.";
  //   }
  // }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _buildMapElements();
  }

  void _buildMapElements() {
    markers.clear();
    circles.clear();
    polylines.clear();

    for (var latLng in locationPoints) {
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(
            title: "Location",
            snippet: "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}",
          ),
        ),
      );

      circles.add(
        Circle(
          circleId: CircleId(latLng.toString()),
          center: latLng,
          radius: 5000,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.2),
        ),
      );
    }

    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: locationPoints,
        color: Colors.blue,
        width: 5,
      ),
    );
  }
}
