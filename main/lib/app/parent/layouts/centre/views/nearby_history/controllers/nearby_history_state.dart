import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NearbyHistoryState {
  RxList<SearchShopResponse> shopHistory = Database.instance.recentSearch.obs;

  RxList<Address> addressHistory = Database.instance.recentAddresses.obs;
}