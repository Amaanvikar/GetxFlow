import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationController extends GetxController {
  final Location _location = Location();
  // final Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  GoogleMapController? mapController;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final Rx<LatLng?> currentLatLng = Rxn<LatLng>();

  LatLng? driverLatLng;
  LatLng? pickupLatLng;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    getPolyline();
  }

  Future<void> getPolyline() async {
    print("Current location: ${currentLatLng.value}");

    if (currentLatLng.value == null) return;

    // Example: Let's assume we want to get a polyline between the current location and a destination
    LatLng destination = LatLng(
        12.9716, 77.5946); // Example destination, change it to dynamic data

    // Initialize PolylinePoints instance
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(
                currentLatLng.value!.latitude, currentLatLng.value!.longitude),
            destination:
                PointLatLng(destination.latitude, destination.longitude),
            mode: TravelMode.driving));

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      // Clear old polyline and add new one
      // polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          width: 5,
          color: Colors.blue,
        ),
      );
    }
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

      _location.enableBackgroundMode(
          enable:
              true); // Enables background tracking the app recieves countinue updates even when it is in background

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

  void animateCameraToBounds(
      double pickupLat, double pickupLng, double dropLat, double dropLng) {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(pickupLat < dropLat ? pickupLat : dropLat,
          pickupLng < dropLng ? pickupLng : dropLng),
      northeast: LatLng(pickupLat > dropLat ? pickupLat : dropLat,
          pickupLng > dropLng ? pickupLng : dropLng),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void getRoutePolyline(LatLng pickupLatLng) async {
    final LatLng? driverLatLng = currentLatLng.value;
    if (driverLatLng == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
      origin: PointLatLng(driverLatLng.latitude, driverLatLng.longitude),
      destination: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      mode: TravelMode.driving,
    ));

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId("pickup_to_driver"),
          color: Colors.red,
          width: 4,
          points: polylineCoordinates,
        ),
      );
    }
  }
}
