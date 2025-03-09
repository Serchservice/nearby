import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' show CarouselController, ScrollController;
import 'package:smart/smart.dart';

import 'go_bcap_viewer_state.dart';

class GoBCapViewerController extends GetxController {
  GoBCapViewerController();
  final state = GoBCapViewerState();

  final ConnectService _connect = Connect();

  EasyNavigation<GoBCap>? navigate;

  final CarouselController carouselController = CarouselController(initialItem: 0);
  final ScrollController scrollController = ScrollController();

  Map<String, String?> params = Get.parameters;
  dynamic args = Get.arguments;

  GoBCapUpdated? onUpdate;

  @override
  void onInit() {
    if(args != null && Instance.of<GoBCap>(args["cap"])) {
      state.cap.value = args["cap"];
    } else {
      state.isLoading.value = false;
    }

    if(args != null && Instance.of<GoBCapUpdated>(args["on_updated"])) {
      onUpdate = args["on_updated"];
    }

    super.onInit();
  }

  @override
  void onReady() {
    if(params.containsKey("id") && params["id"].isNotNull) {
      if(state.cap.value.hasBCap) {
        state.isLoading.value = false;
      } else {
        _fetch(params["id"]!);
      }
    }

    super.onReady();
  }

  void _fetch(String id) async {
    state.isLoading.value = true;
    Outcome response = await _connect.get(endpoint: "/go/bcap?id=$id");
    if(response.isSuccessful) {
      state.isLoading.value = false;

      GoBCap cap = GoBCap.fromJson(response.data);
      state.cap.value = cap;
      onUpdated(cap);
    } else {
      notify.error(message: response.message);
    }
  }

  bool get showLoading => state.isLoading.value;

  GoBCapUpdated get onUpdated => onUpdate ?? (GoBCap cap) {};
}