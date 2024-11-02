import 'dart:io';

import 'package:get/get.dart';
import 'package:drive/library.dart';

class HomeController extends GetxController {
  HomeController();
  static HomeController get data => Get.find<HomeController>();
  final state = HomeState();

  final AppService appService = AppImplementation();
  final AccessService accessService = AccessImplementation();
  final ConnectService _connect = Connect(useToken: false);

  late AppLifecycleReactor _appLifecycleReactor;
  BannerAdManager bannerAdManager = BannerAdManager()..loadAd();

  @override
  void onInit() {
    _launchDevice();

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    super.onInit();
  }

  @override
  void onReady() {
    _loadCategories();

    super.onReady();
  }

  void _loadCategories() async {
    state.isFetchingCategories.value = true;
    var response = await _connect.get(endpoint: "/shop/drive/categories");
    state.isFetchingCategories.value = false;

    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      state.categories.value = result.map((d) => DriveCategoryResponse.fromJson(d)).toList();
    }
  }

  Future<void> _launchDevice() async {
    appService.buildDeviceInformation(onSuccess: (device) {
      Database.saveDevice(device);
      _requestAccess(device.sdk);

      AnalyticsEngine.logEvent("DEVICE_INFORMATION", parameters: device.toJson());
    });
  }

  Future<void> _requestAccess(int sdk, {Function()? onSuccess}) async {
    bool hasAccess = await accessService.requestPermissions();
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

  bool get canShowButton => state.selectedCategory.value.isNotEmpty
      && state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0;

  void selectCategory(String category) {
    state.selectedCategory.value = category;
  }

  void updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void search() {
    RequestSearch search = RequestSearch(category: state.selectedCategory.value, pickup: state.selectedAddress.value);
    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
  }
}