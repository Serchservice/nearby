import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  Rx<CategorySection> category = CategorySection.empty().obs;

  Rx<Address> selectedAddress = Database.address.obs;

  RxBool isSearchingLocation = RxBool(false);
}