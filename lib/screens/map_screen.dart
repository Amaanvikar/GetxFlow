import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getxflow/screens/homescreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteMapScreen extends StatefulWidget {
  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  GoogleMapController? mapController;
  LatLng initialLocation = LatLng(19.9975, 73.7898); // Nashik center

  final String googleAPIKey = 'AIzaSyDGnDHGbAKJl_B7A4O9hgc0LNpF_X9VGCs';

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  Set<Marker> markers = {};
  LatLng? startLocation;
  LatLng? endLocation;

  void getDirectionsFromLatLng(LatLng start, LatLng end) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$googleAPIKey";

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      var points = json['routes'][0]['overview_polyline']['points'];
      polylineCoordinates.clear();

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(points);

      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

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
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              start.latitude < end.latitude ? start.latitude : end.latitude,
              start.longitude < end.longitude ? start.longitude : end.longitude,
            ),
            northeast: LatLng(
              start.latitude > end.latitude ? start.latitude : end.latitude,
              start.longitude > end.longitude ? start.longitude : end.longitude,
            ),
          ),
          50,
        ),
      );
    } else {
      print("Error fetching directions: ${json['error_message']}");
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      if (startLocation == null) {
        startLocation = tappedPoint;
        markers.add(Marker(markerId: MarkerId('start'), position: tappedPoint));
      } else if (endLocation == null) {
        endLocation = tappedPoint;
        markers.add(Marker(markerId: MarkerId('end'), position: tappedPoint));

        // Fetch directions now that both points are set
        getDirectionsFromLatLng(startLocation!, endLocation!);
      } else {
        // Reset if tapped a third time
        startLocation = tappedPoint;
        endLocation = null;
        markers.clear();
        polylines.clear();
        markers.add(Marker(markerId: MarkerId('start'), position: tappedPoint));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB42318),
        centerTitle: true,
        title: const Text("RouteMapScreen ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/img_ic_down.svg',
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              //   bottomNavController.selectedIndex.value = 0;
              Get.offAll(() => HomeScreen());
            }),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: markers,
        polylines: polylines,
        onTap: _onMapTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
