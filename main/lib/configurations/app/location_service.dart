import 'package:geolocator/geolocator.dart';
import 'package:drive/library.dart';

/// Abstract class to define the base structure for a service that handles
/// location-based operations, such as fetching the user's current address.
abstract class LocationService {
  /// Retrieves the current address of the user.
  ///
  /// @param onSuccess The callback function to be called with the address and position upon successful retrieval.
  /// @param onError The callback function to be called with an error message if the retrieval fails.
  ///
  /// @return A `Future` that completes when the address retrieval operation is finished.
  Future<void> getAddress({
    required Function(Address address, Position position) onSuccess,
    required Function(String error) onError,
  });
}