import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:drive/library.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationImplementation implements LocationService {
  final AccessService _accessService = AccessImplementation();

  @override
  Future<void> getAddress({
    required Function(Address address, Position position) onSuccess,
    required Function(String error) onError
  }) async {
    if(await _accessService.hasLocation()) {
      late LocationSettings locationSettings;

      if (PlatformEngine.instance.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          intervalDuration: const Duration(seconds: 10),
        );
      } else if (PlatformEngine.instance.isIOS || PlatformEngine.instance.isMacOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 100,
        );
      } else if (PlatformEngine.instance.isWeb) {
        locationSettings = WebSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          maximumAge: Duration(minutes: 5),
        );
      } else {
        locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
      }

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      try {
        List<Placemark> marks = await placemarkFromCoordinates(position.latitude, position.longitude);
        String place = "";

        String country = marks.last.country.toString();
        String state = marks.last.administrativeArea.toString();
        String localGovernmentArea = marks.last.subAdministrativeArea.toString();
        String city = marks.last.locality.toString();
        String streetNumber = marks.last.subThoroughfare.toString();
        String streetName = marks.reversed.last.thoroughfare.toString();

        place = getPlaceAddress(
          country: country,
          state: state,
          lga: localGovernmentArea,
          city: city,
          streetName: streetName,
          streetNumber: streetNumber
        );

        final address = Address(
          latitude: position.latitude,
          longitude: position.longitude,
          place: place,
          country: country,
          city: city,
          state: state,
          localGovernmentArea: localGovernmentArea,
          streetNumber: streetNumber,
          streetName: streetName
        );
        onSuccess.call(address, position);
        return;
      } catch (e) {
        var address = await ConnectifyUtils.instance.getLocationInformation(position.latitude, position.longitude);
        address = address.copyWith(lat: position.latitude.toString(), lon: position.longitude.toString());

        onSuccess.call(address.toAddress(), position);
        return;
      }
    } else {
      onError.call("Location permission needs to be granted.");
      return;
    }
  }

  String getPlaceAddress({
    String country = "", String state = "",
    String lga = "", String city = "",
    String streetNumber = "", String streetName = ""
  }) {
    String newStreetNumber = "";
    if(streetNumber.isNotEmpty) {
      newStreetNumber = "$streetNumber, ";
    }

    String newStreetName = "";
    if(streetName.isNotEmpty) {
      newStreetName = "$streetName, ";
    }

    String newCity = "";
    if(city.isNotEmpty) {
      newCity = "$city, ";
    }

    String newLga = "";
    if(lga.isNotEmpty) {
      newLga = "$lga. ";
    }

    String newState = "";
    if(state.isNotEmpty) {
      newState = "$state. ";
    }

    String newCountry = "";
    if(country.isNotEmpty) {
      newCountry = "$country.";
    }

    return "$newStreetNumber$newStreetName$newCity$newLga$newState$newCountry";
  }
}

extension on LocationInformation {
  Address toAddress() {
    return Address(
      latitude: double.parse(lat),
      longitude: double.parse(lon),
      place: displayName,
      country: address.country,
      city: address.county,
      state: address.state,
      localGovernmentArea: address.district,
      streetNumber: address.postcode,
      streetName: address.road
    );
  }
}