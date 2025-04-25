import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationController extends GetxController {
  final Location _location = Location();
  final Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};

  LatLng? driverLatLng;
  LatLng? pickupLatLng;

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
