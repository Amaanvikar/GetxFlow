class RideRequest {
  String rideRequestId;
  String rideBookingNumber;
  String userId;
  String pickupLocation;
  String? pickupCity;
  String pickupLat;
  String pickupLong;
  String dropLocation;
  String dropCity;
  String dropLat;
  String dropLong;
  String mapImage;
  String totalKm;
  String totalMin;
  String approximateTotalAmount;
  String pickupDatetime;
  String returnDatetime;
  String tripType;
  String bookingDatetime;
  String isBooked;
  String vdLogId;
  String driverId;
  String vehicleId;
  String segmentId;
  String assignedSegmentId;
  String isRideNow;
  String rideReturnLogId;
  String isDeleted;
  String isRideNotificationSendToDriver;
  String rideAssignToAdmin;
  String isSosAlert;
  String? sosBy;
  String sosLat;
  String sosLong;
  String rideDetailId;
  String rideId;
  String rideStartLat;
  String rideStartLong;
  String rideStartLocation;
  String rideStartCity;
  String rideEndCity;
  String rideStartMeterReading;
  String rideStartMeterReadingImg;
  String rideStartTime;
  String rideEndLat;
  String rideEndLong;
  String rideEndLocation;
  String rideEndMeterReading;
  String rideEndMeterReadingImg;
  String rideEndTime;
  String totalRideKm;
  String totalRideTime;
  String totalRideAmount;
  String amountFromWallet;
  String rideIsCompleted;
  String ridePaymentStatus;
  String driverNeedReturnTrip;
  String driverReturnTripCity;
  String createdOn;
  String tripId;
  String userFullName;
  String driverFullName;
  String ownerFullName;
  String userMobile;
  String driverProfilePic;
  String driverMobile;
  String ownerProfilePic;
  String ownerMobile;
  String? vehicleImage;
  String vehicleModelId;
  String vehicleRegistrationNo;
  String noOfTripRemain;
  String chargeableAmount;
  String noOfTripGiven;
  String modelName;
  String brandId;
  String modelImage;
  String brandName;
  String segmentName;
  String segmentImage;
  String? driverReview;
  String driverRating;
  String driverAverageRating;
  String bookingStatus;
  List<RideAdvance> advanceDetail;
  bool isReturn;
  CostingDetail costingDetail;

  RideRequest({
    required this.rideRequestId,
    required this.rideBookingNumber,
    required this.userId,
    required this.pickupLocation,
    this.pickupCity,
    required this.pickupLat,
    required this.pickupLong,
    required this.dropLocation,
    required this.dropCity,
    required this.dropLat,
    required this.dropLong,
    required this.mapImage,
    required this.totalKm,
    required this.totalMin,
    required this.approximateTotalAmount,
    required this.pickupDatetime,
    required this.returnDatetime,
    required this.tripType,
    required this.bookingDatetime,
    required this.isBooked,
    required this.vdLogId,
    required this.driverId,
    required this.vehicleId,
    required this.segmentId,
    required this.assignedSegmentId,
    required this.isRideNow,
    required this.rideReturnLogId,
    required this.isDeleted,
    required this.isRideNotificationSendToDriver,
    required this.rideAssignToAdmin,
    required this.isSosAlert,
    this.sosBy,
    required this.sosLat,
    required this.sosLong,
    required this.rideDetailId,
    required this.rideId,
    required this.rideStartLat,
    required this.rideStartLong,
    required this.rideStartLocation,
    required this.rideStartCity,
    required this.rideEndCity,
    required this.rideStartMeterReading,
    required this.rideStartMeterReadingImg,
    required this.rideStartTime,
    required this.rideEndLat,
    required this.rideEndLong,
    required this.rideEndLocation,
    required this.rideEndMeterReading,
    required this.rideEndMeterReadingImg,
    required this.rideEndTime,
    required this.totalRideKm,
    required this.totalRideTime,
    required this.totalRideAmount,
    required this.amountFromWallet,
    required this.rideIsCompleted,
    required this.ridePaymentStatus,
    required this.driverNeedReturnTrip,
    required this.driverReturnTripCity,
    required this.createdOn,
    required this.tripId,
    required this.userFullName,
    required this.driverFullName,
    required this.ownerFullName,
    required this.userMobile,
    required this.driverProfilePic,
    required this.driverMobile,
    required this.ownerProfilePic,
    required this.ownerMobile,
    this.vehicleImage,
    required this.vehicleModelId,
    required this.vehicleRegistrationNo,
    required this.noOfTripRemain,
    required this.chargeableAmount,
    required this.noOfTripGiven,
    required this.modelName,
    required this.brandId,
    required this.modelImage,
    required this.brandName,
    required this.segmentName,
    required this.segmentImage,
    this.driverReview,
    required this.driverRating,
    required this.driverAverageRating,
    required this.bookingStatus,
    required this.advanceDetail,
    required this.isReturn,
    required this.costingDetail,
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
      isBooked: map['is_booked'],
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
      driverAverageRating: map['driverAverageRating'],
      bookingStatus: map['booking_status'],
      advanceDetail: (map['advance_detail'] as List)
          .map((item) => RideAdvance.fromMap(item))
          .toList(),
      isReturn: map['is_return'],
      costingDetail: CostingDetail.fromMap(map['costing_detail']),
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
      'driverAverageRating': driverAverageRating,
      'booking_status': bookingStatus,
      'advance_detail': advanceDetail.map((item) => item.toMap()).toList(),
      'is_return': isReturn,
      'costing_detail': costingDetail.toMap(),
    };
  }
}

class RideAdvance {
  String rideAdvanceId;
  String rideId;
  String rideDetailId;
  String advanceAmount;
  String paymentType;
  String paidOn;

  RideAdvance({
    required this.rideAdvanceId,
    required this.rideId,
    required this.rideDetailId,
    required this.advanceAmount,
    required this.paymentType,
    required this.paidOn,
  });

  factory RideAdvance.fromMap(Map<String, dynamic> map) {
    return RideAdvance(
      rideAdvanceId: map['ride_advance_id'],
      rideId: map['ride_id'],
      rideDetailId: map['ride_detail_id'],
      advanceAmount: map['advance_amount'],
      paymentType: map['payment_type'],
      paidOn: map['paid_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ride_advance_id': rideAdvanceId,
      'ride_id': rideId,
      'ride_detail_id': rideDetailId,
      'advance_amount': advanceAmount,
      'payment_type': paymentType,
      'paid_on': paidOn,
    };
  }
}

class CostingDetail {
  String rideCostingId;
  String rideId;
  String baseCharges;
  String kmCharges;
  String minCharges;
  String commissionCharges;
  String discountCharges;
  String total;
  String actualBilling;
  String halfBilling;
  String gst;
  String grandTotal;
  String customerBill;
  String commissionGst;
  String adminCommission;
  String ownerNetEarnings;
  String perTripCharge;
  String tripType;

  CostingDetail({
    required this.rideCostingId,
    required this.rideId,
    required this.baseCharges,
    required this.kmCharges,
    required this.minCharges,
    required this.commissionCharges,
    required this.discountCharges,
    required this.total,
    required this.actualBilling,
    required this.halfBilling,
    required this.gst,
    required this.grandTotal,
    required this.customerBill,
    required this.commissionGst,
    required this.adminCommission,
    required this.ownerNetEarnings,
    required this.perTripCharge,
    required this.tripType,
  });

  factory CostingDetail.fromMap(Map<String, dynamic> map) {
    return CostingDetail(
      rideCostingId: map['ride_costing_id'],
      rideId: map['ride_id'],
      baseCharges: map['base_charges'],
      kmCharges: map['km_charges'],
      minCharges: map['min_charges'],
      commissionCharges: map['commission_charges'],
      discountCharges: map['discount_charges'],
      total: map['total'],
      actualBilling: map['actual_billing'],
      halfBilling: map['half_billing'],
      gst: map['gst'],
      grandTotal: map['grand_total'],
      customerBill: map['customer_bill'],
      commissionGst: map['commission_gst'],
      adminCommission: map['admin_commission'],
      ownerNetEarnings: map['owner_net_earnings'],
      perTripCharge: map['per_trip_charge'],
      tripType: map['trip_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ride_costing_id': rideCostingId,
      'ride_id': rideId,
      'base_charges': baseCharges,
      'km_charges': kmCharges,
      'min_charges': minCharges,
      'commission_charges': commissionCharges,
      'discount_charges': discountCharges,
      'total': total,
      'actual_billing': actualBilling,
      'half_billing': halfBilling,
      'gst': gst,
      'grand_total': grandTotal,
      'customer_bill': customerBill,
      'commission_gst': commissionGst,
      'admin_commission': adminCommission,
      'owner_net_earnings': ownerNetEarnings,
      'per_trip_charge': perTripCharge,
      'trip_type': tripType,
    };
  }
}
