import 'package:get/get.dart';
import 'package:drive/library.dart';

class ResultController extends GetxController {
  ResultController();
  final state = ResultState();

  final ConnectService _connect = Connect(useToken: false);

  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null && args is Map<String, dynamic>) {
      state.search.value = RequestSearch.fromJson(args);
    }

    updateTitle();
    super.onInit();
  }

  @override
  void onReady() {
    fetchShopList();

    super.onReady();
  }

  void updateTitle() {
    state.title.value = "Showing results for nearby ${CommonUtility.capitalizeWords(state.search.value.category)}shops";

    AnalyticsEngine.logSearchResults(state.title.value, state.search.value.toJson());
  }

  String noResult() => "No ${state.search.value.category.toLowerCase()} shops found";

  String shopEndpoint({double? radius}) {
    String query = state.search.value.category;
    double longitude = state.search.value.pickup.longitude;
    double latitude = state.search.value.pickup.latitude;

    if(radius != null) {
      return "/shop/search?c=$query&lng=$longitude&lat=$latitude&radius=$radius";
    } else {
      return "/shop/search?c=$query&lng=$longitude&lat=$latitude";
    }
  }

  void fetchShopList({double? radius}) async {
    state.isSearching.value = true;

    var response = await _connect.get(endpoint: shopEndpoint(radius: radius));
    state.isSearching.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SearchShopResponse> list = result.map((item) => SearchShopResponse.fromJson(item)).toList();
      state.shops.value = list;
      state.sortedShops.value = list;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  List<ButtonView> driveFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4)
  ];

  void updateSearch(double? radius, int? index) {
    if(radius != null) {
      state.radius.value = radius;
      fetchShopList(radius: radius);
    } else if(index != null) {
      filter(index);
    }
  }

  void filter(int index) {
    state.filter.value = index;
    if(index == 0) {
      sortByAll();
    } else if(index == 1 || index == 2) {
      return;
    } else if(index == 3) {
      sortByDistance();
    } else if(index == 4) {
      sortByRating();
    }
  }

  void sortByAll() => state.sortedShops.value = state.shops;

  void sortByDistance() {
    state.sortedShops.value = state.shops;
    state.sortedShops.sort((a, b) => a.distance.compareTo(b.distance));
  }

  void sortByRating() {
    state.sortedShops.value = state.shops;
    state.sortedShops.sort((a, b) => a.shop.rating.compareTo(b.shop.rating));
  }
}