import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ResultState {
  /// Is Searching
  RxBool isSearching = RxBool(true);

  /// Specialization (For Skill Search)
  Rx<RequestSearch> search = RequestSearch(pickup: Database.address, category: "").obs;

  /// Title text
  RxString title = RxString("Search Result");

  /// Current filter index
  RxInt filter = RxInt(0);

  /// Range radius
  RxDouble radius = RxDouble(5000.0);

  /// List of shop search
  RxList<SearchShopResponse> shops = <SearchShopResponse>[].obs;

  /// List of sorted shop search
  RxList<SearchShopResponse> sortedShops = <SearchShopResponse>[].obs;
}