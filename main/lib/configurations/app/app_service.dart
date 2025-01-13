import 'dart:async';

/// Abstract class to define the base structure for an application service that handles
/// deep linking, device information, and fetching data such as a list of countries.
abstract class AppService {
  /// Initializes deep linking and returns a `StreamSubscription` for handling incoming deep links.
  ///
  /// @return A `Future` that completes with a `StreamSubscription` of `Uri` for handling deep links.
  Future<StreamSubscription<Uri>> initializeDeepLink();

  /// Opens the application using the specified deep link URI.
  ///
  /// @param uri The deep link URI to open the application with.
  void openAppLink(Uri uri);

  /// Verifies the safeness of the device
  void verifyDevice();

  /// Checks for app update and updates the app version
  void checkUpdate();

  /// Registers the device to the server
  void registerDevice();
}