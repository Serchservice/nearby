import 'package:geolocator/geolocator.dart';
import 'package:drive/library.dart';

class AccessImplementation implements AccessService {
  @override
  Future<bool> hasLocation() async {
    LocationPermission permit = await Geolocator.checkPermission();
    return permit == LocationPermission.always || permit == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      throw SerchException("Location service is not enabled on this device", isPlatformNotSupported: true);
    }

    var locationPermission = await Geolocator.requestPermission();
    bool isLocationGranted = locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;

    return !isLocationGranted;
  }
}