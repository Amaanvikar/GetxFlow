import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getxflow/models/ride_request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

class RideListDetailsScreen extends StatefulWidget {
  final RideRequest ride;

  const RideListDetailsScreen({super.key, required this.ride});

  @override
  State<RideListDetailsScreen> createState() => _RideListDetailsScreenState();
}

class _RideListDetailsScreenState extends State<RideListDetailsScreen> {
  Map<String, dynamic> _rideDataMap = {};
  bool isEditMode = false;
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  LatLng? driverLatLng;
  LatLng? pickupLatLng;

  @override
  void initState() {
    super.initState();
    _rideDataMap = _rideRequestToMap(widget.ride);

    driverLatLng = LatLng(
      double.tryParse(widget.ride.rideStartLat ?? '') ?? 0.0,
      double.tryParse(widget.ride.rideStartLong ?? '') ?? 0.0,
    );
    pickupLatLng = LatLng(
      double.tryParse(widget.ride.pickupLat ?? '') ?? 0.0,
      double.tryParse(widget.ride.pickupLong ?? '') ?? 0.0,
    );

    getPolyline();
  }

  Future<void> getPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(driverLatLng!.latitude, driverLatLng!.longitude),
        destination:
            PointLatLng(pickupLatLng!.latitude, pickupLatLng!.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            width: 5,
            color: Colors.blue,
          ),
        );
      });
    }
  }

  // Convert the RideRequest object into a map for dynamic display
  Map<String, dynamic> _rideRequestToMap(RideRequest ride) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB42318),
        centerTitle: true,
        title: Text('Ride Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/img_ic_down.svg',
              color: Colors.white, height: 24, width: 24),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon:
                Icon(isEditMode ? Icons.save : Icons.edit, color: Colors.white),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(),
          SizedBox(
            height: 300,
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: driverLatLng ?? LatLng(0, 0),
                zoom: 12,
              ),
              polylines: polylines,
              markers: {
                Marker(
                  markerId: MarkerId('driver'),
                  position: driverLatLng!,
                  infoWindow: InfoWindow(title: "Driver Location"),
                ),
                Marker(
                  markerId: MarkerId('pickup'),
                  position: pickupLatLng!,
                  infoWindow: InfoWindow(title: "Pickup Location"),
                ),
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _rideDataMap.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final entry = _rideDataMap.entries.elementAt(index);
                return _buildRow(entry.key, entry.value?.toString() ?? '');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        if (widget.ride.driverProfilePic != null &&
            widget.ride.driverProfilePic!.isNotEmpty)
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://windhans.com/2022/hrcabs/images/${widget.ride.driverProfilePic}',
            ),
            backgroundColor: Colors.grey[300],
          )
        else
          Icon(Icons.account_circle, size: 60, color: Colors.grey),
        const SizedBox(height: 8),
        Text(
          widget.ride.driverFullName ?? 'Driver Name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (widget.ride.driverMobile != null)
          Text(widget.ride.driverMobile!, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: isEditMode
                ? TextFormField(
                    initialValue: value,
                    onChanged: (newVal) {
                      setState(() {
                        _rideDataMap[title] = newVal;
                      });
                    },
                  )
                : Text(value, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
