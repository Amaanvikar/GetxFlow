import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getxflow/models/ride_request_model.dart';

class RideListDetailsScreen extends StatefulWidget {
  final RideRequest ride; // Accepting a single ride as parameter

  const RideListDetailsScreen({super.key, required this.ride});

  @override
  State<RideListDetailsScreen> createState() => _RideListDetailsScreenState();
}

class _RideListDetailsScreenState extends State<RideListDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('Ride Details', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/img_ic_down.svg',
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4, // Adds shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWidgetRow(
                  "Driver Profile",
                  widget.ride.driverProfilePic != null &&
                          widget.ride.driverProfilePic!.isNotEmpty
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://windhans.com/2022/hrcabs/images/${widget.ride.driverProfilePic}'),
                          backgroundColor: Colors.grey[300],
                        )
                      : Icon(Icons.account_circle,
                          size: 50, color: Colors.grey),
                ),
                Divider(),
                _buildRow("Driver Name:", widget.ride.driverFullName ?? ''),
                _buildRow("Driver Contact:", widget.ride.driverMobile ?? ''),
                _buildRow(
                    "Driver Rating:", widget.ride.driverAverageRating ?? ''),
                Divider(),
                Text("Vehicle Details",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildRow("Model:",
                    "${widget.ride.modelName ?? ''} (${widget.ride.brandName ?? ''})"),
                _buildRow("Segment:", widget.ride.segmentName ?? ''),
                _buildRow("Registration No:",
                    widget.ride.vehicleRegistrationNo ?? ''),
                Divider(),
                _buildRow("Ride No:", widget.ride.rideBookingNumber ?? ''),
                _buildRow("Pickup:",
                    "${widget.ride.pickupLocation ?? ''}, ${widget.ride.pickupCity ?? ''}"),
                _buildRow("Drop:",
                    "${widget.ride.dropLocation ?? ''}, ${widget.ride.dropCity ?? ''}"),
                _buildRow("Total Distance:", "${widget.ride.totalKm ?? ''} km"),
                _buildRow("Estimated Fare:",
                    "₹${widget.ride.approximateTotalAmount ?? ''}"),
                _buildRow(
                  "Booking Status:",
                  widget.ride.bookingStatus ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function for Row Layout
Widget _buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0), // Spacing between rows
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    ),
  );
}

Widget _buildWidgetRow(String title, Widget value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Spacer(),
        value,
      ],
    ),
  );
}
