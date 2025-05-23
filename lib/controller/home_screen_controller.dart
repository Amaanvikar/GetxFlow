import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:HrCabDriver/Api/models/ride_request_model.dart';
import 'package:HrCabDriver/Api/models/user_profile_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// class HomeScreenController extends GetxController {
//   var title = 'HomeScreen'.obs;
//   final RideRequest ride;
//   HomeScreenController({required this.ride});

//   var message = "Welcome to HrCabDriver".obs;
//   var profile = Rxn<DriverProfile>();
//   var currentPosition = Rxn<Position>();
//   var locationMessage = "Fetching location...".obs;

//   GoogleMapController? mapController;

//   final RxList<Marker> markers = <Marker>[].obs;
//   final RxSet<Circle> circles = <Circle>{}.obs;
//   final RxSet<Polyline> polylines = <Polyline>{}.obs;
//   Map<String, dynamic> rideDataMap = {};

//   final List<LatLng> locationPoints = [
//     LatLng(9.9975, 73.7898),
//     LatLng(19.0760, 72.8777),
//     LatLng(12.9716, 77.5946),
//   ];

//   final Rxn<LatLng> _mapLocation = Rxn<LatLng>();
//   LatLng? get mapLocation => _mapLocation.value;

//   final Location locationService = Location();

//   List<LatLng> polylineCoordinates = [];

//   LatLng? driverLatLng;
//   LatLng? pickupLatLng;
//   LatLng? dropLatLng;

//   @override
//   void onInit() {
//     super.onInit();

//     rideDataMap = rideRequestToMap(ride);
//     driverLatLng = LatLng(
//       double.tryParse(ride.rideStartLat ?? '') ?? 0.0,
//       double.tryParse(ride.rideStartLong ?? '') ?? 0.0,
//     );
//     pickupLatLng = LatLng(
//       double.tryParse(ride.pickupLat ?? '') ?? 0.0,
//       double.tryParse(ride.pickupLong ?? '') ?? 0.0,
//     );
//     dropLatLng = LatLng(
//       double.tryParse(ride.dropLat ?? '') ?? 0.0,
//       double.tryParse(ride.dropLong ?? '') ?? 0.0,
//     );

//     getPolyline();
//   }

//   // Ensure polyline is updated
//   Future<void> getPolyline() async {
//     if (pickupLatLng == null || dropLatLng == null) {
//       return;
//     }

//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         request: PolylineRequest(
//             origin:
//                 PointLatLng(driverLatLng!.latitude, driverLatLng!.longitude),
//             destination:
//                 PointLatLng(pickupLatLng!.latitude, pickupLatLng!.longitude),
//             mode: TravelMode.driving));

//     if (result.points.isNotEmpty) {
//       polylineCoordinates.clear();
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }

//       // Update the polylines
//       polylines.clear(); // Clear previous polylines if any
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId('route'),
//           points: polylineCoordinates,
//           width: 5,
//           color: Colors.blue,
//         ),
//       );
//     }
//   }

//   Map<String, dynamic> rideRequestToMap(RideRequest ride) {
//     return {
//       'Ride Request ID': ride.rideRequestId,
//       'Booking Number': ride.rideBookingNumber,
//       'User ID': ride.userId,
//       'Pickup Location': ride.pickupLocation,
//       'Pickup City': ride.pickupCity,
//       'Pickup Lat': ride.pickupLat,
//       'Pickup Long': ride.pickupLong,
//       'Drop Location': ride.dropLocation,
//       'Drop City': ride.dropCity,
//       'Drop Lat': ride.dropLat,
//       'Drop Long': ride.dropLong,
//       'Map Image': ride.mapImage,
//       'Total KM': ride.totalKm,
//       'Total Minutes': ride.totalMin,
//       'Approximate Fare': ride.approximateTotalAmount,
//       'Pickup DateTime': ride.pickupDatetime,
//       'Return DateTime': ride.returnDatetime,
//       'Trip Type': ride.tripType,
//       'Booking DateTime': ride.bookingDatetime,
//       'Is Booked': ride.isBooked,
//       'VD Log ID': ride.vdLogId,
//       'Driver ID': ride.driverId,
//       'Vehicle ID': ride.vehicleId,
//       'Segment ID': ride.segmentId,
//       'Assigned Segment ID': ride.assignedSegmentId,
//       'Is Ride Now': ride.isRideNow,
//       'Ride Return Log ID': ride.rideReturnLogId,
//       'Is Deleted': ride.isDeleted,
//       'Is Ride Notified To Driver': ride.isRideNotificationSendToDriver,
//       'Ride Assigned to Admin': ride.rideAssignToAdmin,
//       'SOS Alert': ride.isSosAlert,
//       'SOS By': ride.sosBy,
//       'SOS Lat': ride.sosLat,
//       'SOS Long': ride.sosLong,
//       'Ride Detail ID': ride.rideDetailId,
//       'Ride ID': ride.rideId,
//       'Ride Start Lat': ride.rideStartLat,
//       'Ride Start Long': ride.rideStartLong,
//       'Ride Start Location': ride.rideStartLocation,
//       'Ride Start City': ride.rideStartCity,
//       'Ride End City': ride.rideEndCity,
//       'Start Meter Reading': ride.rideStartMeterReading,
//       'Start Meter Image': ride.rideStartMeterReadingImg,
//       'Ride Start Time': ride.rideStartTime,
//       'Ride End Lat': ride.rideEndLat,
//       'Ride End Long': ride.rideEndLong,
//       'Ride End Location': ride.rideEndLocation,
//       'End Meter Reading': ride.rideEndMeterReading,
//       'End Meter Image': ride.rideEndMeterReadingImg,
//       'Ride End Time': ride.rideEndTime,
//       'Total Ride KM': ride.totalRideKm,
//       'Total Ride Time': ride.totalRideTime,
//       'Total Ride Amount': ride.totalRideAmount,
//       'Amount From Wallet': ride.amountFromWallet,
//       'Ride Completed': ride.rideIsCompleted,
//       'Payment Status': ride.ridePaymentStatus,
//       'Return Trip Needed': ride.driverNeedReturnTrip,
//       'Return Trip City': ride.driverReturnTripCity,
//       'Created On': ride.createdOn,
//       'Trip ID': ride.tripId,
//       'User Name': ride.userFullName,
//       'Driver Name': ride.driverFullName,
//       'Owner Name': ride.ownerFullName,
//       'User Mobile': ride.userMobile,
//       'Driver Mobile': ride.driverMobile,
//       'Owner Mobile': ride.ownerMobile,
//       'Vehicle Image': ride.vehicleImage,
//       'Vehicle Model ID': ride.vehicleModelId,
//       'Registration No': ride.vehicleRegistrationNo,
//       'Remaining Trips': ride.noOfTripRemain,
//       'Chargeable Amount': ride.chargeableAmount,
//       'Trips Given': ride.noOfTripGiven,
//       'Model Name': ride.modelName,
//       'Brand ID': ride.brandId,
//       'Model Image': ride.modelImage,
//       'Brand Name': ride.brandName,
//       'Segment Name': ride.segmentName,
//       'Segment Image': ride.segmentImage,
//       'Driver Review': ride.driverReview,
//       'Driver Rating': ride.driverRating,
//       'Driver Avg Rating': ride.driverAverageRating,
//       'Booking Status': ride.bookingStatus,
//       'Is Return': ride.isReturn == true ? 'Yes' : 'No',
//     };
//   }
// }

class HomeScreenController extends GetxController {
  var title = 'HomeScreen'.obs;
  final RideRequest ride;
  HomeScreenController({required this.ride});

  var message = "Welcome to HrCabDriver".obs;
  var profile = Rxn<DriverProfile>();
  var currentPosition = Rxn<Position>();
  var locationMessage = "Fetching location...".obs;

  GoogleMapController? mapController;

  final RxList<Marker> markers = <Marker>[].obs;
  final RxSet<Circle> circles = <Circle>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  Map<String, dynamic> rideDataMap = {};

  final List<LatLng> locationPoints = [
    LatLng(9.9975, 73.7898),
    LatLng(19.0760, 72.8777),
    LatLng(12.9716, 77.5946),
  ];

  final Rxn<LatLng> _mapLocation = Rxn<LatLng>();
  LatLng? get mapLocation => _mapLocation.value;

  final Location locationService = Location();

  List<LatLng> polylineCoordinates = [];

  LatLng? driverLatLng;
  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  @override
  void onInit() {
    super.onInit();

    rideDataMap = rideRequestToMap(ride);
    driverLatLng = LatLng(
      double.tryParse(ride.rideStartLat ?? '') ?? 0.0,
      double.tryParse(ride.rideStartLong ?? '') ?? 0.0,
    );
    pickupLatLng = LatLng(
      double.tryParse(ride.pickupLat ?? '') ?? 0.0,
      double.tryParse(ride.pickupLong ?? '') ?? 0.0,
    );
    dropLatLng = LatLng(
      double.tryParse(ride.dropLat ?? '') ?? 0.0,
      double.tryParse(ride.dropLong ?? '') ?? 0.0,
    );

    getPolyline();
  }

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

  // Future<void> getPolyline() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     request: PolylineRequest(
  //       origin: PointLatLng(driverLatLng!.latitude, driverLatLng!.longitude),
  //       destination:
  //           PointLatLng(pickupLatLng!.latitude, pickupLatLng!.longitude),
  //       mode: TravelMode.driving,
  //     ),
  //   );

  //   if (result.points.isNotEmpty) {
  //     polylineCoordinates.clear();
  //     for (var point in result.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }

  //     polylines.add(
  //       Polyline(
  //         polylineId: PolylineId('route'),
  //         points: polylineCoordinates,
  //         width: 5,
  //         color: Colors.blue,
  //       ),
  //     );
  //   }
  // }

  Future<void> getPolyline() async {
    if (pickupLatLng == null || dropLatLng == null) {
      return;
    }

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(driverLatLng!.latitude, driverLatLng!.longitude),
        destination: PointLatLng(
          pickupLatLng!.latitude,
          pickupLatLng!.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

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

  Map<String, dynamic> rideRequestToMap(RideRequest ride) {
    return {
      'Ride Request ID': ride.rideRequestId,
      'Booking Number': ride.rideBookingNumber,
      'User ID': ride.userId,
      'Pickup Location': ride.pickupLocation,
      'Pickup City': ride.pickupCity,
      'Pickup Lat': ride.pickupLat,
      'Pickup Long': ride.pickupLong,
      'Drop Location': ride.dropLocation,
      'Drop City': ride.dropCity,
      'Drop Lat': ride.dropLat,
      'Drop Long': ride.dropLong,
      'Map Image': ride.mapImage,
      'Total KM': ride.totalKm,
      'Total Minutes': ride.totalMin,
      'Approximate Fare': ride.approximateTotalAmount,
      'Pickup DateTime': ride.pickupDatetime,
      'Return DateTime': ride.returnDatetime,
      'Trip Type': ride.tripType,
      'Booking DateTime': ride.bookingDatetime,
      'Is Booked': ride.isBooked,
      'VD Log ID': ride.vdLogId,
      'Driver ID': ride.driverId,
      'Vehicle ID': ride.vehicleId,
      'Segment ID': ride.segmentId,
      'Assigned Segment ID': ride.assignedSegmentId,
      'Is Ride Now': ride.isRideNow,
      'Ride Return Log ID': ride.rideReturnLogId,
      'Is Deleted': ride.isDeleted,
      'Is Ride Notified To Driver': ride.isRideNotificationSendToDriver,
      'Ride Assigned to Admin': ride.rideAssignToAdmin,
      'SOS Alert': ride.isSosAlert,
      'SOS By': ride.sosBy,
      'SOS Lat': ride.sosLat,
      'SOS Long': ride.sosLong,
      'Ride Detail ID': ride.rideDetailId,
      'Ride ID': ride.rideId,
      'Ride Start Lat': ride.rideStartLat,
      'Ride Start Long': ride.rideStartLong,
      'Ride Start Location': ride.rideStartLocation,
      'Ride Start City': ride.rideStartCity,
      'Ride End City': ride.rideEndCity,
      'Start Meter Reading': ride.rideStartMeterReading,
      'Start Meter Image': ride.rideStartMeterReadingImg,
      'Ride Start Time': ride.rideStartTime,
      'Ride End Lat': ride.rideEndLat,
      'Ride End Long': ride.rideEndLong,
      'Ride End Location': ride.rideEndLocation,
      'End Meter Reading': ride.rideEndMeterReading,
      'End Meter Image': ride.rideEndMeterReadingImg,
      'Ride End Time': ride.rideEndTime,
      'Total Ride KM': ride.totalRideKm,
      'Total Ride Time': ride.totalRideTime,
      'Total Ride Amount': ride.totalRideAmount,
      'Amount From Wallet': ride.amountFromWallet,
      'Ride Completed': ride.rideIsCompleted,
      'Payment Status': ride.ridePaymentStatus,
      'Return Trip Needed': ride.driverNeedReturnTrip,
      'Return Trip City': ride.driverReturnTripCity,
      'Created On': ride.createdOn,
      'Trip ID': ride.tripId,
      'User Name': ride.userFullName,
      'Driver Name': ride.driverFullName,
      'Owner Name': ride.ownerFullName,
      'User Mobile': ride.userMobile,
      'Driver Mobile': ride.driverMobile,
      'Owner Mobile': ride.ownerMobile,
      'Vehicle Image': ride.vehicleImage,
      'Vehicle Model ID': ride.vehicleModelId,
      'Registration No': ride.vehicleRegistrationNo,
      'Remaining Trips': ride.noOfTripRemain,
      'Chargeable Amount': ride.chargeableAmount,
      'Trips Given': ride.noOfTripGiven,
      'Model Name': ride.modelName,
      'Brand ID': ride.brandId,
      'Model Image': ride.modelImage,
      'Brand Name': ride.brandName,
      'Segment Name': ride.segmentName,
      'Segment Image': ride.segmentImage,
      'Driver Review': ride.driverReview,
      'Driver Rating': ride.driverRating,
      'Driver Avg Rating': ride.driverAverageRating,
      'Booking Status': ride.bookingStatus,
      'Is Return': ride.isReturn == true ? 'Yes' : 'No',
    };
  }
}
