import 'package:geolocator/geolocator.dart';
import 'package:smart/smart.dart' show DoubleExtensions;

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

    return distanceInMeters.distance;
  }
}