import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class LocationSearchState {
  /// List of Addresses
  RxList<Address> locations = <Address>[].obs;

  /// Picked address
  Rx<Address> location = Database.address.obs;

  /// Is Loading Search Result
  RxBool isSearching = RxBool(false);

  RxBool isSearchingLocation = RxBool(false);
}