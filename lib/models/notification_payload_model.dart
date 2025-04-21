// Define a model for the notification payload

class NotificationPayload {
  final String rideRequestId;
  final String pickupLocation;
  final String dropLocation;
  final String userFullName;
  final String pickupDatetime;
  final String fareAmount;
  final String driverId;

  NotificationPayload({
    required this.rideRequestId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.userFullName,
    required this.pickupDatetime,
    required this.fareAmount,
    required this.driverId,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      rideRequestId: json['ride_request_id'] ?? 'N/A',
      pickupLocation: json['pickup_location'] ?? 'Unknown',
      dropLocation: json['drop_location'] ?? 'Unknown',
      userFullName: json['user_full_name'] ?? 'Unknown',
      pickupDatetime: json['pickup_datetime'] ?? 'N/A',
      fareAmount: json['fare_amount'] ?? '0.0',
      driverId: json['driver_id'] ?? 'N/A',
    );
  }
}
