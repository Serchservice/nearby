import 'package:drive/library.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  static HomeController get data => Get.find<HomeController>();

  final state = HomeState();

  final OneSignalService _oneSignalService = OneSignalImplementation();
  final LocationService _locationService = LocationImplementation();

  @override
  void onInit() {
    getCurrentLocation();

    super.onInit();
  }

  void getCurrentLocation() {
    state.isGettingCurrentLocation.value = true;

    _locationService.getAddress(onSuccess: (address, position) {
      state.isGettingCurrentLocation.value = false;

      Database.saveAddress(address);
      state.currentLocation.value = address;
    }, onError: (error) {
      state.isGettingCurrentLocation.value = false;

      notify.error(message: error);
    });
  }

  bool get hasCurrentLocation => state.currentLocation.value.hasAddress;

  bool get canUseCurrentLocation => state.useCurrentLocation.value && hasCurrentLocation;

  bool get showSwitch => state.isGettingCurrentLocation.isFalse && hasCurrentLocation;

  bool get hasSelectedLocation => state.selectedAddress.value.hasAddress;

  bool get hasLocation => hasSelectedLocation || canUseCurrentLocation;

  bool get hasCategory => state.category.value.type.isNotEmpty;

  bool get canShowButton => hasCategory && hasSelectedLocation;

  bool get hasDetails => category() != null || hasSelectedLocation;

  Category? category() {
    return Category.categories.firstWhereOrNull((c) {
      return c.sections.any((s) => s.type == state.category.value.type);
    });
  }

  List<FakeField> fields(CategorySection selected) => [
    FakeField(
      onTap: _handleLocationSearch,
      searchText: "Where is your starting point?",
      buttonText: "Search"
    ),
    FakeField(
      onTap: () => _handleCategorySearch(selected),
      searchText: "What nearby place are you looking for?",
      showSearch: false,
      buttonText: "Around"
    )
  ];

  void _handleLocationSearch() async {
    dynamic result = await LocationSearchLayout.to();
    if(result != null && result is Address) {
      _updateAddress(result);

      if(hasCategory) {
        search();
      }
    }
  }

  void _updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void search() {
    Address pickup = canUseCurrentLocation ? state.currentLocation.value : state.selectedAddress.value;

    RequestSearch search = RequestSearch(category: state.category.value, pickup: pickup);
    _oneSignalService.addSearchTag(state.category.value);
    _oneSignalService.addLocationTag(pickup);

    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
    clearSelection();
  }

  void clearSelection() {
    state.category.value = CategorySection.empty();
    state.selectedAddress.value = Address.empty();
  }

  void _handleCategorySearch(CategorySection selected) async {
    dynamic result = await CategorySearchLayout.to(section: selected);
    if(result != null && result is CategorySection) {
      _selectSection(result);

      if(hasLocation) {
        search();
      }
    }
  }

  void _selectSection(CategorySection category) {
    state.category.value = category;
  }

  void handleQuickOption(CategorySection section) {
    _selectSection(section);

    if(hasLocation) {
      search();
    } else {
      _handleLocationSearch();
    }
  }

  void onCurrentLocationChanged(bool value) {
    Database.savePreference(Database.preference.copyWith(useCurrentLocation: value));

    state.useCurrentLocation.value = value;

    if(hasCategory && value) {
      search();
    }
  }

  List<HomeItem> items = [
    HomeItem(title: "Suggestions", sections: Category.suggestions),
    HomeItem(title: "Emergencies", sections: Category.emergencies),
    HomeItem(title: "Services", sections: Category.services),
  ];
}

class HomeItem {
  final String title;
  final List<CategorySection> sections;

  HomeItem({required this.title, required this.sections});
}