import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class HomeController extends GetxController {
  HomeController();
  static HomeController get data => Get.find<HomeController>();
  final state = HomeState();

  final AppService _appService = AppImplementation();
  final AccessService _accessService = AccessImplementation();
  final LocationService _locationService = LocationImplementation();

  late AppLifecycleReactor _appLifecycleReactor;
  BannerAdManager bannerAdManager = BannerAdManager()..loadAd();

  @override
  void onInit() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();

    super.onInit();
  }

  @override
  void onReady() {
    _appService.verifyDevice();
    _appService.checkUpdate();

    _launchDevice();

    super.onReady();
  }

  Future<void> _launchDevice() async {
    _appService.buildDeviceInformation(onSuccess: (device) {
      Database.saveDevice(device);
      _requestAccess(device.sdk, onSuccess: () {
        _fetchCurrentAddress();
      });

      AnalyticsEngine.logEvent("DEVICE_INFORMATION", parameters: device.toJson());
    });
  }

  Future<void> _requestAccess(int sdk, {Function()? onSuccess}) async {
    bool hasAccess = await _accessService.requestPermissions();
    if(hasAccess) {
      if(Platform.isAndroid || Platform.isIOS) {
        onSuccess?.call();
        return;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      _requestAccess(sdk, onSuccess: onSuccess);
    }
  }

  void _fetchCurrentAddress() {
    state.isSearchingLocation.value = true;

    _locationService.getAddress(onSuccess: (address, position) {
      state.isSearchingLocation.value = false;

      state.selectedAddress.value = address;
      Database.saveAddress(address);
    }, onError: (error) {
      state.isSearchingLocation.value = false;
      notify.error(message: error);
    });
  }

  List<ButtonView> options = [
    ButtonView(header: "Use current location", index: 0, icon: CupertinoIcons.location_solid),
    ButtonView(header: "Search location with address", index: 1, icon: CupertinoIcons.location_circle_fill)
  ];

  void onLocationSearch(ButtonView view) {
    Navigate.back();

    if(view.index == 1) {
      Navigate.to(LocationSearchLayout.route);
    } else {
      _fetchCurrentAddress();
    }
  }

  bool get canShowButton => state.category.value.type.isNotEmpty
      && state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0;

  void selectSection(CategorySection category) {
    state.category.value = category;
  }

  void clearSelection() {
    state.category.value = CategorySection.empty();
  }

  Category? category() {
    return Category.categories.firstWhereOrNull((c) {
      return c.sections.any((s) => s.type == state.category.value.type);
    });
  }

  void updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void search() {
    RequestSearch search = RequestSearch(category: state.category.value, pickup: state.selectedAddress.value);
    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
  }
}