class DriverProfile {
  final String regId;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final String permanentAddress;
  final String presentAddress;
  final String gender;
  final String dob;
  final String drivingLicenseNo;
  final String licenseExpiry;
  final String badgeNumber;
  final String profileImage;
  final String vehicleModel;
  final String vehicleNumber;
  final String prof_pic;

  DriverProfile({
    required this.regId,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.permanentAddress,
    required this.presentAddress,
    required this.gender,
    required this.dob,
    required this.drivingLicenseNo,
    required this.licenseExpiry,
    required this.badgeNumber,
    required this.profileImage,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.prof_pic,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      regId: json['reg_id'] ?? '',
      mobile: json['reg_mobile'] ?? '',
      email: json['reg_email'] ?? '',
      firstName: json['prof_first_name'] ?? '',
      lastName: json['prof_last_name'] ?? '',
      permanentAddress: json['prof_permanent_address'] ?? '',
      presentAddress: json['prof_present_address'] ?? '',
      gender: json['prof_gender'] ?? '',
      dob: json['prof_dob'] ?? '',
      drivingLicenseNo: json['prof_driving_tr_licence_no'] ?? '',
      licenseExpiry: json['prof_driving_licence_expiry_date'] ?? '',
      badgeNumber: json['prof_badge_number'] ?? '',
      profileImage: json['prof_pic'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      vehicleNumber: json['vehicle_registrationno'] ?? '',
      prof_pic: json['prof_pic'] ?? '',
    );
  }
}
