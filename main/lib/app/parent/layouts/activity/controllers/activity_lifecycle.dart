import 'package:drive/library.dart';

class ActivityLifeCycle {
  static void onAuthenticated(GoAuthResponse auth) {
    ActivityController controller = ActivityController.data;

    controller.authController.add(auth);
  }

  static void onSignOut() {
    ActivityController controller = ActivityController.data;

    controller.authController.add(GoAuthResponse.empty());
  }

  static void onGoCreate(GoCreate create) {
    ActivityController controller = ActivityController.data;

    controller.createController.add(create);
  }

  static void onAccountReceived(GoAccount account, bool save) {
    ActivityController controller = ActivityController.data;

    controller.accountController.add(account);

    if(save) {
      ConnectService connect = Connect();
      connect.post(endpoint: "/go/account/update", body: account.toJson()).then((Outcome response) {
        if(response.isSuccessful) {
          GoAccount account = GoAccount.fromJson(response.data);
          ActivityLifeCycle.onAccountReceived(account, false);
        } else {
          notify.error(message: response.message);
        }
      });
    }
  }

  static void onLocationPermissionGranted() {
    final LocationService service = LocationImplementation();

    service.getAddress(
      onSuccess: (address, position) {
        try {
          ActivityLifeCycle.onAddressChanged(address);
          BCapLifeCycle.onAddressChanged(address);
        } catch (_) {}
      },
      onError: (error) {
        notify.tip(message: error, color: CommonColors.instance.error);
      }
    );
  }

  static void onAddressChanged(Address address) {
    ActivityController controller = ActivityController.data;

    controller.locationController.add(address);
  }
}