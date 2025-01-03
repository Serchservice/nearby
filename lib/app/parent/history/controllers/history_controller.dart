import 'package:drive/library.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  HistoryController();
  static HistoryController get data => Get.find<HistoryController>();

  final state = HistoryState();

  final ConnectService _connect = Connect();

  Map<String, List<SearchShopResponse>> groupedShops() {
    Map<String, List<SearchShopResponse>> groupedShops = {};

    for (var shop in state.shopHistory) {
      String category = shop.shop.category;
      groupedShops.putIfAbsent(category, () => []).add(shop);
    }

    return groupedShops;
  }

  void updateRecentAddresses(Address address) {
    List<Address> update = List.from(Database.recentAddresses);
    if(!update.any((ad) => (ad.latitude == address.latitude && ad.longitude == address.longitude) || ad.place.toLowerCase() == address.place.toLowerCase())) {
      update.add(address);

      Database.saveRecentAddress(update);
      state.addressHistory.value = update;
    }
  }

  void updateRecentShops(SearchShopResponse shop, ButtonView option) async {
    List<SearchShopResponse> update = List.from(Database.recentSearch);
    if(!update.any((item) => item.shop.id == shop.shop.id)) {
      update.add(shop);

      Database.saveRecentSearch(update);
      state.shopHistory.value = update;
    }

    _connect.post(endpoint: "/nearby/drive", body: {
      "id": shop.shop.id,
      "type": shop.shop.category,
      "provider": shop.isGoogle ? "GOOGLE" : "SERCH",
      "option": option.header
    });
  }
}