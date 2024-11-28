import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:drive/library.dart';

class NavigationSheetController extends GetxController {
  final SearchShopResponse shop;
  NavigationSheetController({required this.shop});

  final state = NavigationSheetState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    _fetchList();

    super.onInit();
  }

  void _fetchList() async {
    state.isLoading.value = true;

    final maps = await MapLauncher.installedMaps;
    state.maps.value = maps;

    state.isLoading.value = false;
  }

  void onSelect(AvailableMap map) async {
    await MapLauncher.showDirections(
      mapType: map.mapType,
      destination: Coords(shop.shop.latitude, shop.shop.longitude),
      destinationTitle: shop.shop.name
    );
    _drive(shop.shop.id, Database.address);
    Navigate.till(ModalRoute.withName(HomeLayout.route));
  }

  void _drive(String shopId, Address address) async {
    await _connect.post(endpoint: "/shop/drive", body: {
      "shop_id": shopId,
      "address": address.place,
      "place_id": address.id,
      "latitude": address.latitude,
      "longitude": address.longitude
    });
  }
}