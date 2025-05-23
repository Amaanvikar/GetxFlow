class RideRequest {
  String? rideRequestId;
  String? rideBookingNumber;
  String? userId;
  String? pickupLocation;
  String? pickupCity;
  String? pickupLat;
  String? pickupLong;
  String? dropLocation;
  String? dropCity;
  String? dropLat;
  String? dropLong;
  String? mapImage;
  String? totalKm;
  String? totalMin;
  String? approximateTotalAmount;
  String? pickupDatetime;
  String? returnDatetime;
  String? tripType;
  String? bookingDatetime;
  int? isBooked;
  String? vdLogId;
  String? driverId;
  String? vehicleId;
  String? segmentId;
  String? assignedSegmentId;
  String? isRideNow;
  String? rideReturnLogId;
  String? isDeleted;
  String? isRideNotificationSendToDriver;
  String? rideAssignToAdmin;
  String? isSosAlert;
  String? sosBy;
  String? sosLat;
  String? sosLong;
  String? rideDetailId;
  String? rideId;
  String? rideStartLat;
  String? rideStartLong;
  String? rideStartLocation;
  String? rideStartCity;
  String? rideEndCity;
  String? rideStartMeterReading;
  String? rideStartMeterReadingImg;
  String? rideStartTime;
  String? rideEndLat;
  String? rideEndLong;
  String? rideEndLocation;
  String? rideEndMeterReading;
  String? rideEndMeterReadingImg;
  String? rideEndTime;
  String? totalRideKm;
  String? totalRideTime;
  String? totalRideAmount;
  String? amountFromWallet;
  String? rideIsCompleted;
  String? ridePaymentStatus;
  String? driverNeedReturnTrip;
  String? driverReturnTripCity;
  String? createdOn;
  String? tripId;
  String? userFullName;
  String? driverFullName;
  String? ownerFullName;
  String? userMobile;
  String? driverProfilePic;
  String? driverMobile;
  String? ownerProfilePic;
  String? ownerMobile;
  String? vehicleImage;
  String? vehicleModelId;
  String? vehicleRegistrationNo;
  String? noOfTripRemain;
  String? chargeableAmount;
  String? noOfTripGiven;
  String? modelName;
  String? brandId;
  String? modelImage;
  String? brandName;
  String? segmentName;
  String? segmentImage;
  String? driverReview;
  String? driverRating;
  String? driverAverageRating;
  String? bookingStatus;
  bool? isReturn;

  RideRequest({
    this.rideRequestId,
    this.rideBookingNumber,
    this.userId,
    this.pickupLocation,
    this.pickupCity,
    this.pickupLat,
    this.pickupLong,
    this.dropLocation,
    this.dropCity,
    this.dropLat,
    this.dropLong,
    this.mapImage,
    this.totalKm,
    this.totalMin,
    this.approximateTotalAmount,
    this.pickupDatetime,
    this.returnDatetime,
    this.tripType,
    this.bookingDatetime,
    this.isBooked,
    this.vdLogId,
    this.driverId,
    this.vehicleId,
    this.segmentId,
    this.assignedSegmentId,
    this.isRideNow,
    this.rideReturnLogId,
    this.isDeleted,
    this.isRideNotificationSendToDriver,
    this.rideAssignToAdmin,
    this.isSosAlert,
    this.sosBy,
    this.sosLat,
    this.sosLong,
    this.rideDetailId,
    this.rideId,
    this.rideStartLat,
    this.rideStartLong,
    this.rideStartLocation,
    this.rideStartCity,
    this.rideEndCity,
    this.rideStartMeterReading,
    this.rideStartMeterReadingImg,
    this.rideStartTime,
    this.rideEndLat,
    this.rideEndLong,
    this.rideEndLocation,
    this.rideEndMeterReading,
    this.rideEndMeterReadingImg,
    this.rideEndTime,
    this.totalRideKm,
    this.totalRideTime,
    this.totalRideAmount,
    this.amountFromWallet,
    this.rideIsCompleted,
    this.ridePaymentStatus,
    this.driverNeedReturnTrip,
    this.driverReturnTripCity,
    this.createdOn,
    this.tripId,
    this.userFullName,
    this.driverFullName,
    this.ownerFullName,
    this.userMobile,
    this.driverProfilePic,
    this.driverMobile,
    this.ownerProfilePic,
    this.ownerMobile,
    this.vehicleImage,
    this.vehicleModelId,
    this.vehicleRegistrationNo,
    this.noOfTripRemain,
    this.chargeableAmount,
    this.noOfTripGiven,
    this.modelName,
    this.brandId,
    this.modelImage,
    this.brandName,
    this.segmentName,
    this.segmentImage,
    this.driverReview,
    this.driverRating,
    this.driverAverageRating,
    this.bookingStatus,
    this.isReturn,
  });

  factory RideRequest.fromMap(Map<String, dynamic> map) {
    return RideRequest(
      rideRequestId: map['ride_request_id'],
      rideBookingNumber: map['ride_booking_number'],
      userId: map['user_id'],
      pickupLocation: map['pickup_location'],
      pickupCity: map['pickup_city'],
      pickupLat: map['pickup_lat'],
      pickupLong: map['pickup_long'],
      dropLocation: map['drop_location'],
      dropCity: map['drop_city'],
      dropLat: map['drop_lat'],
      dropLong: map['drop_long'],
      mapImage: map['map_image'],
      totalKm: map['total_km'],
      totalMin: map['total_min'],
      approximateTotalAmount: map['approximate_total_amount'],
      pickupDatetime: map['pickup_datetime'],
      returnDatetime: map['return_datetime'],
      tripType: map['trip_type'],
      bookingDatetime: map['booking_datetime'],
      isBooked: map['is_booked'] != null
          ? int.parse(map['is_booked'].toString())
          : null,
      vdLogId: map['vd_log_id'],
      driverId: map['driver_id'],
      vehicleId: map['vehicle_id'],
      segmentId: map['segment_id'],
      assignedSegmentId: map['assigned_segment_id'],
      isRideNow: map['is_ride_now'],
      rideReturnLogId: map['ride_return_log_id'],
      isDeleted: map['is_deleted'],
      isRideNotificationSendToDriver:
          map['is_ride_notification_send_to_driver'],
      rideAssignToAdmin: map['ride_assign_to_admin'],
      isSosAlert: map['is_sos_alert'],
      sosBy: map['sos_by'],
      sosLat: map['sos_lat'],
      sosLong: map['sos_long'],
      rideDetailId: map['ride_detail_id'],
      rideId: map['ride_id'],
      rideStartLat: map['ride_start_lat'],
      rideStartLong: map['ride_start_long'],
      rideStartLocation: map['ride_start_location'],
      rideStartCity: map['ride_start_city'],
      rideEndCity: map['ride_end_city'],
      rideStartMeterReading: map['ride_start_meter_reading'],
      rideStartMeterReadingImg: map['ride_start_meter_reading_img'],
      rideStartTime: map['ride_start_time'],
      rideEndLat: map['ride_end_lat'],
      rideEndLong: map['ride_end_long'],
      rideEndLocation: map['ride_end_location'],
      rideEndMeterReading: map['ride_end_meter_reading'],
      rideEndMeterReadingImg: map['ride_end_meter_reading_img'],
      rideEndTime: map['ride_end_time'],
      totalRideKm: map['total_ride_km'],
      totalRideTime: map['total_ride_time'],
      totalRideAmount: map['total_ride_amount'],
      amountFromWallet: map['amount_from_wallet'],
      rideIsCompleted: map['ride_is_completed'],
      ridePaymentStatus: map['ride_payment_status'],
      driverNeedReturnTrip: map['driver_need_return_trip'],
      driverReturnTripCity: map['driver_return_trip_city'],
      createdOn: map['created_on'],
      tripId: map['trip_id'],
      userFullName: map['userFullName'],
      driverFullName: map['driverFullName'],
      ownerFullName: map['ownerFullName'],
      userMobile: map['user_mobile'],
      driverProfilePic: map['driver_profile_pic'],
      driverMobile: map['driver_mobile'],
      ownerProfilePic: map['owner_profile_pic'],
      ownerMobile: map['owner_mobile'],
      vehicleImage: map['vehicle_image'],
      vehicleModelId: map['vehicle_model_id'],
      vehicleRegistrationNo: map['vehicle_registrationno'],
      noOfTripRemain: map['no_of_trip_remain'],
      chargeableAmount: map['chargeable_amount'],
      noOfTripGiven: map['no_of_trip_given'],
      modelName: map['model_name'],
      brandId: map['brand_id'],
      modelImage: map['model_image'],
      brandName: map['brand_name'],
      segmentName: map['segment_name'],
      segmentImage: map['segment_image'],
      driverReview: map['driver_review'],
      driverRating: map['driver_rating'],
      driverAverageRating: map['driver_average_rating'],
      bookingStatus: map['booking_status'],
      isReturn: map['is_return'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ride_request_id': rideRequestId,
      'ride_booking_number': rideBookingNumber,
      'user_id': userId,
      'pickup_location': pickupLocation,
      'pickup_city': pickupCity,
      'pickup_lat': pickupLat,
      'pickup_long': pickupLong,
      'drop_location': dropLocation,
      'drop_city': dropCity,
      'drop_lat': dropLat,
      'drop_long': dropLong,
      'map_image': mapImage,
      'total_km': totalKm,
      'total_min': totalMin,
      'approximate_total_amount': approximateTotalAmount,
      'pickup_datetime': pickupDatetime,
      'return_datetime': returnDatetime,
      'trip_type': tripType,
      'booking_datetime': bookingDatetime,
      'is_booked': isBooked,
      'vd_log_id': vdLogId,
      'driver_id': driverId,
      'vehicle_id': vehicleId,
      'segment_id': segmentId,
      'assigned_segment_id': assignedSegmentId,
      'is_ride_now': isRideNow,
      'ride_return_log_id': rideReturnLogId,
      'is_deleted': isDeleted,
      'is_ride_notification_send_to_driver': isRideNotificationSendToDriver,
      'ride_assign_to_admin': rideAssignToAdmin,
      'is_sos_alert': isSosAlert,
      'sos_by': sosBy,
      'sos_lat': sosLat,
      'sos_long': sosLong,
      'ride_detail_id': rideDetailId,
      'ride_id': rideId,
      'ride_start_lat': rideStartLat,
      'ride_start_long': rideStartLong,
      'ride_start_location': rideStartLocation,
      'ride_start_city': rideStartCity,
      'ride_end_city': rideEndCity,
      'ride_start_meter_reading': rideStartMeterReading,
      'ride_start_meter_reading_img': rideStartMeterReadingImg,
      'ride_start_time': rideStartTime,
      'ride_end_lat': rideEndLat,
      'ride_end_long': rideEndLong,
      'ride_end_location': rideEndLocation,
      'ride_end_meter_reading': rideEndMeterReading,
      'ride_end_meter_reading_img': rideEndMeterReadingImg,
      'ride_end_time': rideEndTime,
      'total_ride_km': totalRideKm,
      'total_ride_time': totalRideTime,
      'total_ride_amount': totalRideAmount,
      'amount_from_wallet': amountFromWallet,
      'ride_is_completed': rideIsCompleted,
      'ride_payment_status': ridePaymentStatus,
      'driver_need_return_trip': driverNeedReturnTrip,
      'driver_return_trip_city': driverReturnTripCity,
      'created_on': createdOn,
      'trip_id': tripId,
      'userFullName': userFullName,
      'driverFullName': driverFullName,
      'ownerFullName': ownerFullName,
      'user_mobile': userMobile,
      'driver_profile_pic': driverProfilePic,
      'driver_mobile': driverMobile,
      'owner_profile_pic': ownerProfilePic,
      'owner_mobile': ownerMobile,
      'vehicle_image': vehicleImage,
      'vehicle_model_id': vehicleModelId,
      'vehicle_registrationno': vehicleRegistrationNo,
      'no_of_trip_remain': noOfTripRemain,
      'chargeable_amount': chargeableAmount,
      'no_of_trip_given': noOfTripGiven,
      'model_name': modelName,
      'brand_id': brandId,
      'model_image': modelImage,
      'brand_name': brandName,
      'segment_name': segmentName,
      'segment_image': segmentImage,
      'driver_review': driverReview,
      'driver_rating': driverRating,
      'driver_average_rating': driverAverageRating,
      'booking_status': bookingStatus,
      'is_return': isReturn,
    };
  }
}
