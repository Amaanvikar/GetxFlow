import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxflow/controller/location_controller.dart';
import 'package:getxflow/models/accept_ride_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AcceptRideController extends GetxController {
  final LocationController locationController = Get.put(LocationController());

  var isLoading = false.obs;

  // Add to your controller
  var polylineCoordinates = <LatLng>[].obs;
  var pickupLocation = LatLng(0, 0).obs;

  Future<void> acceptRide({
    required String vdLogId,
    required String rideReturnLogId,
    required String rideRequestId,
    required String duration,
  }) async {
    if (vdLogId.isEmpty ||
        rideReturnLogId.isEmpty ||
        rideRequestId.isEmpty ||
        duration.isEmpty) {
      Get.snackbar(
        "Error",
        "Invalid ride information",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final url = Uri.parse("https://windhans.com/2022/hrcabs/acceptRideDriver");
    final body = {
      'vd_log_id': vdLogId,
      'ride_return_log_id': rideReturnLogId,
      'ride_request_id': rideRequestId,
      'duration': duration,
    };

    try {
      final response =
          await http.post(url, body: body).timeout(const Duration(seconds: 30));
      isLoading.value = false;

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final acceptRideResponse = AcceptRideRequest.fromJson(data);

          if (acceptRideResponse.result) {
            Get.snackbar(
              "Success",
              "Ride accepted successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            // You might want to navigate to another screen here
          } else {
            Get.snackbar(
              "Failed",
              acceptRideResponse.reason.isNotEmpty
                  ? acceptRideResponse.reason
                  : "Ride could not be accepted. It might have been taken by another driver.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            "Failed to parse server response",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server responded with status code: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Failed to connect to server: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> showRouteToPickup({
    required LatLng currentPosition,
    required double pickupLat,
    required double pickupLng,
  }) async {
    try {
      pickupLocation.value = LatLng(pickupLat, pickupLng);

      // Get route between points
      final directions = await _getRouteDirections(
        currentPosition,
        pickupLocation.value,
      );

      // Update polyline
      polylineCoordinates.value = directions;

      // Update map view
      locationController.animateCameraToBounds(
        currentPosition.latitude,
        currentPosition.longitude,
        pickupLat,
        pickupLng,
      );
    } catch (e) {
      debugPrint("Error showing route: $e");
    }
  }

  Future<List<LatLng>> _getRouteDirections(
      LatLng origin, LatLng destination) async {
    // Here you would typically call a Directions API like Google Maps Directions
    // For now, we'll just return a straight line between points

    return [origin, destination];
  }
}
