import 'package:drive/library.dart';

class BCapLifeCycle {
  static void onAuthenticated(GoAuthResponse auth) {
    BCapController controller = BCapController.data;

    controller.authController.add(auth);
  }

  static void onAddressChanged(Address address) {
    BCapController controller = BCapController.data;

    controller.locationController.add(address);
  }

  static void onSignOut() {
    BCapController controller = BCapController.data;

    controller.authController.add(GoAuthResponse.empty());
  }
}