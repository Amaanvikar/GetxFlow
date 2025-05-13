import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationController extends GetxController {
  final Location _location = Location();
  // final Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  GoogleMapController? mapController;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final Rx<LatLng?> currentLatLng = Rxn<LatLng>();
  final Rx<double?> currentHeading = Rxn<double>();

  Rxn<double> heading = Rxn<double>(); // Track heading for rotation
  List<LatLng> polylineCoordinates = [];
  LatLng initialLocation = LatLng(
    0,
    0,
  );
  Set<Marker> markers = {};

  LatLng? driverLatLng;
  LatLng? pickupLatLng;

  Rx<BitmapDescriptor> pickupMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen).obs;

  StreamSubscription<Position>? positionStream;
  bool hasArrivedAtPickup = false;
  double pickupRadius = 50.0;

  void checkProximityToPickup(LatLng currentPosition, LatLng pickupPosition) {
    double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      pickupPosition.latitude,
      pickupPosition.longitude,
    );
    debugPrint('Distance to pickup: ${distance.toStringAsFixed(2)} meters');

    if (distance <= pickupRadius && !hasArrivedAtPickup) {
      debugPrint('Driver arrived at pickup location!');
      updatePickupMarker(true);
      _showArrivalNotification();
    } else if (distance > pickupRadius && hasArrivedAtPickup) {
      debugPrint('Driver left pickup zone');
      updatePickupMarker(false);
    }
  }

  void updatePickupMarker(bool hasArrived) {
    hasArrivedAtPickup = hasArrived;
    pickupMarkerIcon.value = hasArrived
        ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
        : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    update();
  }

  void _showArrivalNotification() {
    // You can use GetX to show a snackbar or dialog
    Get.snackbar(
      'Arrival Notification',
      'You have arrived at the pickup location',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void startGeoFenceMonitoring(LatLng pickupPosition) {
    // Cancel any existing stream
    positionStream?.cancel();

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        // accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      checkProximityToPickup(
        LatLng(position.latitude, position.longitude),
        pickupPosition,
      );
    });
  }

  void stopGeoFenceMonitoring() {
    positionStream?.cancel();
    positionStream = null;
    hasArrivedAtPickup = false;
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    getPolyline();
  }

  final String googleAPIKey = 'AIzaSyDGnDHGbAKJl_B7A4O9hgc0LNpF_X9VGCs';

  void getDirections(LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey';

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      var points = json['routes'][0]['overview_polyline']['points'];
      polylineCoordinates.clear();

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(points);

      for (PointLatLng point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          width: 5,
          color: Colors.blue,
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(polylineCoordinates.first, 13),
      );
    } else {
      print("Error fetching directions: ${json['error_message']}");
    }
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
          if (newLocation.heading != null) {
            currentHeading.value = newLocation.heading;
            if (mapController != null) {
              mapController!.animateCamera(
                CameraUpdate.newLatLng(currentLatLng.value!),
              );
            }
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

  void startLocationUpdates() {
    Location location = Location();

    location.changeSettings(interval: 1000); // every 1 sec

    location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        currentLatLng.value =
            LatLng(locationData.latitude!, locationData.longitude!);
      }
    });
  }
}
