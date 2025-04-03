import 'package:flutter/material.dart';
import 'package:getxflow/models/ride_request_model.dart';

class RideListDetailsScreen extends StatelessWidget {
  final RideRequest ride; // Accepting a single ride as parameter

  const RideListDetailsScreen({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('Ride Details', style: TextStyle(fontWeight: FontWeight.bold)),
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
                _buildRow("Ride No:", ride.rideBookingNumber ?? ''),
                _buildRow("Pickup:",
                    "${ride.pickupLocation ?? ''}, ${ride.pickupCity ?? ''}"),
                _buildRow("Drop:",
                    "${ride.dropLocation ?? ''}, ${ride.dropCity ?? ''}"),
                _buildRow("Total Distance:", "${ride.totalKm ?? ''} km"),
                _buildRow(
                    "Estimated Fare:", "₹${ride.approximateTotalAmount ?? ''}"),
                _buildRow(
                  "Booking Status:",
                  ride.bookingStatus ?? '',
                ),
                Divider(),
                Text("Driver Details",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildRow("Driver Name:", ride.driverFullName ?? ''),
                _buildRow("Driver Contact:", ride.driverMobile ?? ''),
                _buildRow("Driver Rating:", ride.driverAverageRating ?? ''),
                Divider(),
                Text("Vehicle Details",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildRow("Model:",
                    "${ride.modelName ?? ''} (${ride.brandName ?? ''})"),
                _buildRow("Segment:", ride.segmentName ?? ''),
                _buildRow("Registration No:", ride.vehicleRegistrationNo ?? ''),
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
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
