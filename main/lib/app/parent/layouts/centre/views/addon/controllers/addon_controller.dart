import 'dart:async';

import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'addon_state.dart';

class AddonController extends GetxController {
  AddonController();
  static AddonController get data {
    try {
      return Get.find<AddonController>();
    } catch (_) {
      Get.put(AddonController());
      return Get.find<AddonController>();
    }
  }

  final state = AddonState();

  final ConnectService _connect = Connect();

  final StreamController<String> _transactionController = StreamController<String>.broadcast();
  Stream<String> get transactionStream => _transactionController.stream;

  List<ButtonView> tabs = [
    ButtonView(header: "Mine"),
    ButtonView(header: "Others"),
  ];

  void updateCurrent(int index) {
    state.current.value = index;
  }

  @override
  void onInit() {
    if(Database.instance.auth.isLoggedIn) {
      fetchUserAddons();
      fetchOtherAddons();
    }

    super.onInit();
  }

  void fetchUserAddons() async {
    state.isFetchingMine.value = state.userAddons.isEmpty;

    Outcome response = await _connect.get(endpoint: "/go/addon/all");
    if(response.isSuccessful) {
      updateUserAddons(response.data);

      state.isFetchingMine.value = false;
    } else {
      state.isFetchingMine.value = false;
    }
  }

  void updateUserAddons(dynamic response) {
    List<dynamic> data = response;
    List<GoUserAddon> addons = data.map((e) => GoUserAddon.fromJson(e)).toList();
    state.userAddons.value = addons;

    List<GoCreditCard> cards = addons.flatten<GoCreditCard>((GoUserAddon e) => e.card).toList();
    state.userCards.value = cards;
  }

  void fetchOtherAddons() async {
    state.isFetchingOthers.value = state.otherAddons.isEmpty;

    Outcome response = await _connect.get(endpoint: "/go/addon");
    if(response.isSuccessful) {
      List<dynamic> data = response.data;
      List<GoAddon> addons = data.map((e) => GoAddon.fromJson(e)).toList();
      state.otherAddons.value = addons;

      state.isFetchingOthers.value = false;
    } else {
      state.isFetchingOthers.value = false;
    }
  }

  @override
  void onReady() {
    transactionStream.listen((String event) {
      if(event.isNotEmpty) {
        VerifyTransaction.open(event);
      }
    });

    super.onReady();
  }

  void registerReference(String? reference) {
    if(reference.isNotNull) {
      _transactionController.add(reference!);
    }
  }
}