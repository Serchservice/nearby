import 'package:drive/library.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  static HomeController get data => Get.find<HomeController>();

  final state = HomeState();

  final OneSignalService _oneSignalService = OneSignalImplementation();

  List<FakeField> fields(CategorySection selected) => [
    FakeField(
      onTap: () {
        dynamic result = LocationSearchLayout.to();
        if(result != null && result is Address) {
          updateAddress(result);
        }
      },
      searchText: "Where is your starting point?",
      buttonText: "Search"
    ),
    FakeField(
      onTap: () {
        dynamic result = CategorySearchLayout.to(section: selected);
        if(result != null && result is CategorySection) {
          selectSection(result);
        }
      },
      searchText: "What nearby place are you looking for?",
      showSearch: false,
      buttonText: "Around"
    )
  ];

  List<HomeItem> items = [
    HomeItem(title: "Suggestions", sections: Category.suggestions),
    HomeItem(title: "Emergencies", sections: Category.emergencies),
    HomeItem(title: "Services", sections: Category.services),
  ];

  bool get canShowButton => state.category.value.type.isNotEmpty
      && state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0;

  void selectSection(CategorySection category) {
    state.category.value = category;
  }

  void clearSelection() {
    state.category.value = CategorySection.empty();
    state.selectedAddress.value = Address.empty();
  }

  void updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void handleQuickOption(CategorySection section) {
    selectSection(section);
    if(hasAddress) {
      search();
    } else {
      Navigate.to(LocationSearchLayout.route);
    }
  }

  bool get hasAddress => state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0
      && state.selectedAddress.value.place.isNotEmpty;

  bool get hasDetails => category() != null || hasAddress;

  Category? category() {
    return Category.categories.firstWhereOrNull((c) {
      return c.sections.any((s) => s.type == state.category.value.type);
    });
  }

  void search() {
    RequestSearch search = RequestSearch(category: state.category.value, pickup: state.selectedAddress.value);
    _oneSignalService.addSearchTag(state.category.value);
    _oneSignalService.addLocationTag(state.selectedAddress.value);

    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
    clearSelection();
  }
}

class HomeItem {
  final String title;
  final List<CategorySection> sections;

  HomeItem({required this.title, required this.sections});
}