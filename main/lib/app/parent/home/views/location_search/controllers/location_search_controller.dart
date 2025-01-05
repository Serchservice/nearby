import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class LocationSearchController extends GetxController {
  LocationSearchController();
  final state = LocationSearchState();

  final ConnectService _connect = Connect(useToken: false);

  final TextEditingController locationController = TextEditingController();

  @override
  void onInit() {
    List<Address> recent = Database.recentAddresses.take(5).toList();
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

    ApiResponse response = await _connect.get(endpoint: "/location/search?q=${locationController.text.trim()}");

    state.isSearching.value = false;
    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      state.locations.value = result.map((location) => Address.fromJson(location)).toList();
    }
  }

  void pick(Address address) {
    Navigate.back(result: address);
  }
}