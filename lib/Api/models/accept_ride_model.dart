class AcceptRideRequest {
  final bool result;
  final String reason;

  AcceptRideRequest({
    required this.result,
    required this.reason,
  });

  // Factory constructor to create an instance from JSON
  factory AcceptRideRequest.fromJson(Map<String, dynamic> json) {
    return AcceptRideRequest(
      result: json['result'] as bool,
      reason: json['reason'] as String,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'reason': reason,
    };
  }
}
