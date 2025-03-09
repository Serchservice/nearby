import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

import 'search_result_state.dart';

class ResultController extends GetxController {
  ResultController();
  final state = ResultState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagedController<int, SearchShopResponse> shopController = PagedController(firstPageKey: 0);

  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null && args is Map<String, dynamic>) {
      state.search.value = RequestSearch.fromJson(args);

      CentreController.data.updateRecentAddresses(state.search.value.pickup);
    }

    updateTitle();

    shopController.addPageRequestListener((pageKey) {
      _fetchShops(pageKey);
    });

    super.onInit();
  }

  void updateTitle() {
    state.title.value = "Nearby ${state.search.value.category.title.replaceAllToLowerCase("_", " ")} locations";

    AnalyticsEngine.logSearchResults(state.title.value, state.search.value.toJson());
  }

  String noResult() => "No ${state.search.value.category.title.replaceAllToLowerCase("_", " ")} result in your location";

  void _fetchShops(int page) async {
    String query = state.search.value.category.type;
    double longitude = state.search.value.pickup.longitude;
    double latitude = state.search.value.pickup.latitude;

    String endpoint = "/shop/search?q=$query&lng=$longitude&lat=$latitude&radius=${state.radius.value}&page=$page&size=$_pageSize";
    var response = await _connect.get(endpoint: endpoint);

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SearchShopResponse> shops = result.map((data) => SearchShopResponse.fromJson(data)).toList();
      _updateShops(shops);
      final isLastPage = shops.length.isLessThan(_pageSize);

      if(isLastPage) {
        shopController.appendLastPage(shops);
      } else {
        shopController.appendPage(shops, page + 1);
      }

      _filter(state.filter.value);
    } else {
      shopController.error = response.message;
    }
  }

  List<SearchShopResponse> _updateShops(List<SearchShopResponse> shops) {
    StringSet existingShopIds = state.shops.map((SearchShopResponse shop) => shop.shop.id).toSet();
    List<SearchShopResponse> newShops = shops.where((SearchShopResponse shop) => !existingShopIds.contains(shop.shop.id)).toList();

    List<SearchShopResponse> updatedShops = List.from(state.shops)..addAll(newShops);
    state.shops.value = updatedShops;

    return updatedShops;
  }

  List<ButtonView> driveFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Open", index: 1),
    ButtonView(header: "Closed", index: 2),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4)
  ];

  void updateSearch(double? radius, int? index) {
    if(radius.isNotNull) {
      state.radius.value = radius!;
      shopController.refresh();
    } else if(index.isNotNull) {
      _filter(index!);
    }
  }

  void _filter(int index) {
    state.filter.value = index;
    if(index == 0) {
      _sortByAll();
    } else if(index == 1) {
      _sortByOpen();
    } else if(index == 2) {
      _sortByClosed();
    } else if(index == 3) {
      _sortByDistance();
    } else if(index == 4) {
      _sortByRating();
    }
  }

  void _sortByOpen() {
    List<SearchShopResponse> shops = List.from(state.shops);
    shops = shops.where((SearchShopResponse shop) => shop.shop.open).toList();
    shops.sort((SearchShopResponse a, SearchShopResponse b) => a.distance.compareTo(b.distance));

    shopController.itemList = shops;
  }

  void _sortByClosed() {
    List<SearchShopResponse> shops = List.from(state.shops);
    shops = shops.where((SearchShopResponse shop) => !shop.shop.open).toList();
    shops.sort((SearchShopResponse a, SearchShopResponse b) => a.distance.compareTo(b.distance));

    shopController.itemList = shops;
  }

  void _sortByAll() {
    List<SearchShopResponse> shops = List.from(state.shops);
    shopController.itemList = shops;
  }

  void _sortByDistance() {
    List<SearchShopResponse> shops = List.from(state.shops);
    shops.sort((SearchShopResponse a, SearchShopResponse b) => a.distance.compareTo(b.distance));

    shopController.itemList = shops;
  }

  void _sortByRating() {
    List<SearchShopResponse> shops = List.from(state.shops);
    shops.sort((SearchShopResponse a, SearchShopResponse b) => b.shop.rating.compareTo(a.shop.rating));

    shopController.itemList = shops;
  }
}