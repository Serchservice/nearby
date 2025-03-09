/// Abstract class to define the base structure for a service that handles
/// requesting and checking permissions.
abstract class AccessService {
  /// Requests all necessary permissions.
  ///
  /// @return A `Future` that completes with a boolean indicating whether all permissions were granted.
  Future<bool> requestPermissions();

  /// Checks if the location permissions were granted. If not, requests for them.
  ///
  /// @return A `Future` that completes with a boolean indicating whether location permissions were granted.
  Future<bool> hasLocation();

  /// Checks if the user has storage or asks for permissions.
  ///
  /// @return A `Future` that completes with a boolean indicating whether all permissions were granted.
  Future<bool> checkForStorageOrAskPermission(int sdk);
}