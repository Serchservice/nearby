import 'package:drive/library.dart';
import 'package:get/get.dart';

import 'nearby_history_state.dart';

class NearbyHistoryController extends GetxController {
  NearbyHistoryController();
  static NearbyHistoryController get data => Get.find<NearbyHistoryController>();

  final state = NearbyHistoryState();

  Map<String, List<SearchShopResponse>> groupedShops() {
    Map<String, List<SearchShopResponse>> groupedShops = {};

    for (var shop in state.shopHistory) {
      String category = shop.shop.category;
      groupedShops.putIfAbsent(category, () => []).add(shop);
    }

    return groupedShops;
  }
}