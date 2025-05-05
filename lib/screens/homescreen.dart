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

  BitmapDescriptor? carIcon;
  BitmapDescriptor? pickupIcon;
  Marker? carMarker;

  @override
  void initState() {
    super.initState();
    locationController.startLocationUpdates();
    _loadCarIcon();

    if (widget.ride != null) {
      pickupLatLng = LatLng(
        double.tryParse(widget.ride!.pickupLat ?? '0')!,
        double.tryParse(widget.ride!.pickupLong ?? '0')!,
      );

      if (pickupLatLng != null) {
        getDirections(null, pickupLatLng!);
      }
    }

    // Listen for location updates to update car marker
    locationController.currentLatLng.listen((position) {
      if (position != null) {
        _updateCarMarker(position);
        if (pickupLatLng != null) {
          getDirections(position, pickupLatLng!);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ride != null) {
        // _showRideDetailsDialog(widget.ride);
      }
    });
  }

  void _loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/redcar.png',
    );
  }

  void _updateCarMarker(LatLng position) {
    if (carIcon == null) return;

    setState(() {
      driverLatLng = position;
      carMarker = Marker(
        markerId: const MarkerId('car'),
        position: position,
        icon: carIcon!,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Your Car'),
      );
    });
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

  void _onStartRidePressed() {
    if (driverLatLng == null || carIcon == null) return;

    final carMarker = Marker(
      markerId: const MarkerId('Car'),
      position: driverLatLng!,
      icon: carIcon!,
      infoWindow: const InfoWindow(title: 'Car is here'),
    );

    setState(() {
      // Remove old car marker if needed
      polylines = Set<Polyline>.from(polylines); // Keep current polylines
      mapController?.animateCamera(CameraUpdate.newLatLng(driverLatLng!));
      // Add car marker
      // locationController.setCarMarker(carMarker);
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

        return Stack(
          children: [
            SafeArea(
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
                  if (carMarker != null) carMarker!,
                  if (pickupLatLng != null)
                    Marker(
                      markerId: const MarkerId('pickup'),
                      position: pickupLatLng!,
                      icon: pickupIcon ??
                          BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                      infoWindow: const InfoWindow(title: 'Pickup Location'),
                    ),
                },
              ),
            ),

            // Optional Ride Summary Card
            if (widget.ride != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                  // onTap: () => _showRideDetailsDialog(widget.ride!),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_car,
                                  color: Colors.black87),
                              const SizedBox(width: 8),
                              Text(
                                "Ride #${widget.ride!.rideBookingNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.green),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.ride!.pickupLocation ??
                                      "Pickup location",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.flag, color: Colors.redAccent),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.ride!.dropLocation ?? "Drop location",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.currency_rupee,
                                  color: Colors.orange),
                              const SizedBox(width: 6),
                              Text(
                                "${widget.ride!.totalRideAmount}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _onStartRidePressed,
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              label: const Text(
                                'Start Ride',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      }),
    );
  }
}
