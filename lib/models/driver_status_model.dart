class DriverStatus {
  final String vdLogId;
  final bool status; // 0 for online, 1 for offline
  final double currentVdLat;
  final double currentVdLon;
  final String reason;
  final String currentStatus;

  DriverStatus({
    required this.vdLogId,
    required this.status,
    required this.currentVdLat,
    required this.currentVdLon,
    required this.reason,
    required this.currentStatus,
  });

  // Factory constructor to parse data from API response
  factory DriverStatus.fromJson(Map<String, dynamic> json) {
    return DriverStatus(
      vdLogId: json['vd_log_id'].toString(),
      status: json['status'] == 0, // if status is 0, it's online
      currentVdLat: json['current_vd_lat'] as double,
      currentVdLon: json['current_vd_lon'] as double,
      reason: json['reason'],
      currentStatus: json['current_status'],
    );
  }

  // Method to convert DriverStatus to a map (for API request)
  Map<String, String> toMap() {
    return {
      'vd_log_id': vdLogId,
      'status': status ? '0' : '1',
      'current_vd_lat': currentVdLat.toString(),
      'current_vd_lon': currentVdLon.toString(),
    };
  }
}
