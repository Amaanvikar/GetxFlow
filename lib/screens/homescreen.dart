import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:HrCabDriver/common/widget/drawer_widget.dart';
import 'package:HrCabDriver/controller/driver_status_controller.dart';
import 'package:HrCabDriver/controller/location_controller.dart';
import 'package:HrCabDriver/Api/models/ride_request_model.dart';
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
  final DriverStatusController driverStatusController = Get.put(
    DriverStatusController(),
  );
  final LocationController locationController = Get.put(LocationController());
  GoogleMapController? mapController;
  final String googleAPIKey = 'AIzaSyDGnDHGbAKJl_B7A4O9hgc0LNpF_X9VGCs';

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  LatLng? pickupLatLng;
  LatLng? driverLatLng;
  bool isLoading = false;
  bool _isExpanded = true;

  BitmapDescriptor? carIcon;
  BitmapDescriptor? pickupIcon;
  Marker? carMarker;
  RxBool hasArrivedAtPickup = false.obs;

  Set<Circle> get geoFenceCircles {
    if (pickupLatLng == null) return {};

    return {
      Circle(
        circleId: const CircleId('pickupZone'),
        center: pickupLatLng!,
        radius: locationController.pickupRadius,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.15),
      ),
    };
  }

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

        locationController.startGeoFenceMonitoring(
          pickupLatLng!,
        ); //start geo-fencing
      }
    }

    // Listen for location updates to update car marker
    locationController.currentLatLng.listen((position) {
      if (position != null) {
        _updateCarMarker(position);
        if (pickupLatLng != null) {
          getDirections(position, pickupLatLng!);
        }
        mapController?.animateCamera(CameraUpdate.newLatLng(position));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ride != null) {
        // _showRideDetailsDialog(widget.ride);
      }
    });
  }

  @override
  void dispose() {
    locationController.stopGeoFenceMonitoring();
    super.dispose();
  }

  void _loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(18, 18)),
      'assets/images/redcar.png',
    );
  }

  void _updateCarMarker(LatLng position) {
    if (carIcon == null) return;

    if (driverLatLng != null &&
        _calculateDistance(driverLatLng!, position) < 5) {
      return;
    }

    setState(() {
      driverLatLng = position;
      carMarker = Marker(
        markerId: const MarkerId('car'),
        position: position,
        icon: carIcon!,
        anchor: const Offset(0.5, 0.5),
        rotation: locationController.currentHeading.value!,
        infoWindow: const InfoWindow(title: 'Your Car'),
      );
    });
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    // Simple distance calculation (in meters)
    return Geolocator.distanceBetween(
      pos1.latitude,
      pos1.longitude,
      pos2.latitude,
      pos2.longitude,
    );
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
            width: 6,
            color: Colors.blueAccent,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap,
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
      flat: true,
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
          "Driver Ryde",
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                  bearing: locationController.currentHeading.value ?? 0.0,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: true,
                polylines: polylines,
                markers: {
                  if (carMarker != null) carMarker!,
                  if (pickupLatLng != null)
                    Marker(
                      markerId: const MarkerId('pickup'),
                      position: pickupLatLng!,
                      icon: locationController.pickupMarkerIcon.value,
                      flat: true,
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
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        _isExpanded ? 20 : 50,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(_isExpanded ? 16 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with minimize/maximize button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: locationController.hasArrivedAtPickup
                                        ? Colors.green
                                        : Colors.black87,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.directions_car,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Ride #${widget.ride!.rideBookingNumber}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: locationController.hasArrivedAtPickup
                                        ? Colors.green
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: Colors.grey,
                              size: 28,
                            ),
                          ],
                        ),

                        if (_isExpanded) ...[
                          const SizedBox(height: 16),

                          // Arrival Status Indicator
                          if (locationController.hasArrivedAtPickup)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Arrived at pickup location',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Pickup Location
                          _buildLocationRow(
                            icon: Icons.circle,
                            iconColor: locationController.hasArrivedAtPickup
                                ? Colors.green
                                : Colors.grey,
                            text: widget.ride!.pickupLocation ??
                                "Pickup location",
                            isFirst: true,
                          ),

                          // Vertical connector line
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Container(
                              height: 20,
                              width: 2,
                              color: Colors.grey[300],
                            ),
                          ),

                          // Drop Location
                          _buildLocationRow(
                            icon: Icons.location_on,
                            iconColor: Colors.redAccent,
                            text: widget.ride!.dropLocation ?? "Drop location",
                            isFirst: false,
                          ),

                          const SizedBox(height: 16),
                          // Fare and button
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.currency_rupee,
                                      color: Colors.black87,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${widget.ride!.approximateTotalAmount}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: _onStartRidePressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        locationController.hasArrivedAtPickup
                                            ? Colors.green
                                            : Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        locationController.hasArrivedAtPickup
                                            ? Icons.check
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        locationController.hasArrivedAtPickup
                                            ? 'Start Ride'
                                            : 'Approaching',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

Widget _buildLocationRow({
  required IconData icon,
  required Color iconColor,
  required String text,
  required bool isFirst,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: isFirst ? 18 : 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );
}
