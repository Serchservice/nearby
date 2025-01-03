import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HistoryState {
  RxList<SearchShopResponse> shopHistory = Database.recentSearch.obs;

  RxList<Address> addressHistory = Database.recentAddresses.obs;
}