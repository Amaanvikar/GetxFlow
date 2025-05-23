class ApiResponse {
  final bool result;
  final String reason;
  final String currentStatus;

  ApiResponse({
    required this.result,
    required this.reason,
    required this.currentStatus,
  });

  // Factory constructor for creating an instance from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      result: json['result'],
      reason: json['reason'],
      currentStatus: json['current_status'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'reason': reason,
      'current_status': currentStatus,
    };
  }
}
