import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  Rx<CategorySection> category = CategorySection.empty().obs;

  Rx<Address> selectedAddress = Address.empty().obs;

  Rx<Address> currentLocation = Database.address.obs;

  RxBool isGettingCurrentLocation = RxBool(true);

  RxBool useCurrentLocation = Database.preference.useCurrentLocation.obs;

  Rx<HomeItem> promotionalItem = HomeItem(title: "", sections: []).obs;
}