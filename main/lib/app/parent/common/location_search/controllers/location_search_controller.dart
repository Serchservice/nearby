import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

import 'location_search_state.dart';

class LocationSearchController extends GetxController {
  LocationSearchController();
  final state = LocationSearchState();

  final ConnectService _connect = Connect();

  final TextEditingController locationController = TextEditingController();

  @override
  void onInit() {
    List<Address> recent = Database.instance.recentAddresses.take(5).toList();
    state.addressHistory.value = recent;

    super.onInit();
  }

  @override
  void onReady() {
    locationController.addListener(() {
      if(locationController.text.isNotEmpty) {
        searchLocation();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    locationController.dispose();
    super.onClose();
  }

  void searchLocation() async {
    state.isSearching.value = true;

    _connect.get(endpoint: "/location/search?q=${locationController.text.trim()}").then((Outcome response) {
      state.isSearching.value = false;
      if(response.isSuccessful) {
        List<dynamic> result = response.data;
        state.locations.value = result.map((location) => Address.fromJson(location)).toList();
      }
    });
  }

  void pick(Address address) {
    Navigate.back(result: address);
  }
}