import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class LocationSearchController extends GetxController {
  LocationSearchController();
  final state = LocationSearchState();

  final ConnectService _connect = Connect(useToken: false);
  final LocationService _locationService = LocationImplementation();
  BannerAdManager bannerAdManager = BannerAdManager()..loadAd();

  final TextEditingController locationController = TextEditingController();

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

  void fetchCurrentAddress() {
    state.isSearchingLocation.value = true;

    _locationService.getAddress(onSuccess: (address, position) {
      state.isSearchingLocation.value = false;

      Database.saveAddress(address);
      pick(address);
    }, onError: (error) {
      state.isSearchingLocation.value = false;

      notify.error(message: error);
    });
  }

  void pick(Address address) {
    HomeController.data.updateAddress(address);
    Navigate.back();
  }
}