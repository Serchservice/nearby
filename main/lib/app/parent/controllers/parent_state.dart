import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:smart/smart.dart';

class ParentState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Checks if the user has logged in or signed up
  RxBool isAuthenticated = Database.instance.auth.isLoggedIn.obs;

  /// Whether the user is using a premium version
  RxBool showAds = RxBool(Database.instance.auth.isLoggedIn.isFalse);

  Rx<Address> currentLocation = Database.instance.address.obs;

  RxBool isGettingCurrentLocation = RxBool(true);

  RxBool useCurrentLocation = Database.instance.preference.useCurrentLocation.obs;

  Rx<CategorySection> category = CategorySection.empty().obs;

  Rx<Address> selectedAddress = Address.empty().obs;

  Rx<GoAuthResponse> auth = Rx(Database.instance.auth);

  Rx<GoAccount> account = Rx(Database.instance.account);
}