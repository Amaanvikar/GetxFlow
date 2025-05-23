class ApiEndPoints {
  // ignore: constant_identifier_names
  static const String BASE_URL = 'https://windhans.com';
  // ignore: constant_identifier_names
  static const String SUB_DOMAIN = '/2022/hrcabs';

  static const String driverLogin = '$BASE_URL$SUB_DOMAIN/driverLogin';
  static const String driverProfile = '$BASE_URL$SUB_DOMAIN/driverProfile';
  static const String rideList = '$BASE_URL$SUB_DOMAIN/getDriverRideList';
  static const String getDriverVehicleStatus =
      '$BASE_URL$SUB_DOMAIN/getDriverVDStatus';
  static const String acceptRide = '$BASE_URL$SUB_DOMAIN/acceptRideDriver';
  static const String notifyUserDriverIsArriving =
      '$BASE_URL$SUB_DOMAIN/notifyUserDriverLeaveForPickup';
  static const String driverPickupCar = '$BASE_URL$SUB_DOMAIN/pickCarDriver';
  static const String driverDropCar = '$BASE_URL$SUB_DOMAIN/dropCarDriver';
  static const String driverVehicleLogStatus =
      '$BASE_URL$SUB_DOMAIN/getDriverStatus';
}
