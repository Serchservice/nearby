import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ParentState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  Rx<CategorySection> category = CategorySection.empty().obs;

  Rx<Address> selectedAddress = Database.address.obs;

  RxList<SearchShopResponse> shopHistory = Database.recentSearch.obs;

  RxList<Address> addressHistory = Database.recentAddresses.obs;

  /// App Version
  RxString appVersion = "".obs;

  /// App Name
  RxString appName = "".obs;

  /// App Build Number
  RxString appBuildNumber = "".obs;

  /// App Package
  RxString appPackage = "".obs;
}