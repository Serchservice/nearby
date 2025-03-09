import 'package:drive/library.dart';
import 'package:get/get.dart';

import 'services_state.dart';

class ServicesController extends GetxController {
  ServicesController();
  static ServicesController get data {
    try {
      return Get.find<ServicesController>();
    } catch (_) {
      Get.put(ServicesController());
      return Get.find<ServicesController>();
    }
  }

  final state = ServicesState();

  final FirebaseRemoteConfigService _remoteConfigService = FirebaseRemoteConfigImplementation();

  @override
  void onInit() {
    getPromotionalItem();

    super.onInit();
  }

  void getPromotionalItem() {
    state.promotionalItem.value = _remoteConfigService.getSeasonPromotion();
  }

  List<Suggestion> get suggestions => [
    if(state.promotionalItem.isNotEmpty) ...[
      ...state.promotionalItem.value,
    ],

    if(state.interestSuggested.isNotEmpty) ...[
      ...state.interestSuggested.value,
    ],

    Suggestion(title: "Suggestions", sections: Category.suggestions),
    Suggestion(title: "Emergencies", sections: Category.emergencies),
    Suggestion(title: "Services", sections: Category.services),
  ].where((item) => item.canPublish).toList();
}