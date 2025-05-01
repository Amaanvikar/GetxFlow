import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:getxflow/common/widget/drawer_widget.dart';
import 'package:getxflow/controller/driver_status_controller.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:getxflow/models/ride_request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  final RideRequest? ride;
  const HomeScreen({super.key, this.ride});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DriverStatusController driverStatusController =
      Get.put(DriverStatusController());
  final LocationController locationController = Get.put(LocationController());
  GoogleMapController? mapController;
  final String googleAPIKey = 'AIzaSyDGnDHGbAKJl_B7A4O9hgc0LNpF_X9VGCs';

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  LatLng? pickupLatLng;
  LatLng? driverLatLng;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.ride != null) {
      pickupLatLng = LatLng(
        double.tryParse(widget.ride!.pickupLat ?? '0')!,
        double.tryParse(widget.ride!.pickupLong ?? '0')!,
      );

      if (pickupLatLng != null) {
        getDirections(null, pickupLatLng!);
      }
    }
  }

  void getDirections(LatLng? origin, LatLng destination) async {
    setState(() {
      isLoading = true;
    });
    final Location location = Location();
    if (origin == null) {
      print("Getting current location, ${origin}");
      origin = await location.getLocation().then((value) {
        return LatLng(value.latitude!, value.longitude!);
      });
      setState(() {
        driverLatLng = origin;
      });
    }
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin?.latitude},${origin?.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey';

    print("URL: $url");
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    print("Response from API : $json");
    if (json['status'] == 'OK') {
      var points = json['routes'][0]['overview_polyline']['points'];
      polylineCoordinates.clear();

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(points);

      for (PointLatLng point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            width: 5,
            color: Colors.blue,
          ),
        );
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(polylineCoordinates.first, 13),
      );
    } else {
      print("Error fetching directions: ${json['error_message']}");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFB42318),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Driver Status",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            if (driverStatusController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            final isOffline =
                driverStatusController.selectedStatus.value == '1';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  driverStatusController.updateStatus(isOffline ? '0' : '1');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOffline ? Colors.blueGrey : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOffline ? Icons.wifi_off : Icons.wifi,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOffline ? 'Go Online' : 'Go Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final position = locationController.currentLatLng.value;

        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: GoogleMap(
            onMapCreated: locationController.setMapController,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: polylines,
            markers: {
              if (driverLatLng != null)
                Marker(
                  markerId: const MarkerId('Driver'),
                  position: driverLatLng!,
                  icon: BitmapDescriptor.defaultMarker,
                ),
              if (pickupLatLng != null)
                Marker(
                  markerId: const MarkerId('Pick up'),
                  position: pickupLatLng!,
                  icon: BitmapDescriptor.defaultMarker,
                ),
            },
          ),
        );
      }),
    );
  }
}
