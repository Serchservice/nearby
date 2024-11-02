import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  RxString selectedCategory = RxString("");

  RxBool isFetchingCategories = RxBool(true);

  RxList<DriveCategoryResponse> categories = RxList();

  Rx<Address> selectedAddress = Database.address.obs;

  RxBool isSearchingLocation = RxBool(false);
}