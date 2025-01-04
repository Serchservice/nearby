import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static final LocationUtils _instance = LocationUtils._internal();
  LocationUtils._internal();

  static LocationUtils get instance => _instance;

  String getDistanceInKm({
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatitude,
      pickupLongitude,
      destinationLatitude,
      destinationLongitude,
    );

    double distanceInKilometers = distanceInMeters / 1000;

    return "${distanceInKilometers.toStringAsFixed(2)} km";
  }
}