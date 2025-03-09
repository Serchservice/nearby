import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:drive/library.dart';

class MainConfiguration extends GetxController {
  MainConfiguration();

  static MainConfiguration get data => Get.find<MainConfiguration>();

  static void bind() {
    NotificationController.instance.register();

    try {
      if(!MainConfiguration.data.initialized) {
        Get.put<MainConfiguration>(MainConfiguration());
      }
    } catch (_) {
      Get.put<MainConfiguration>(MainConfiguration());
    }
  }

  final AppService _appService = AppImplementation();
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();

  StreamSubscription<Uri>? _linkSubscription;

  /// Current route information
  Rx<Routing> currentRoute = Routing().obs;

  /// Whether the app is in the background
  RxBool isBackground = RxBool(false);

  /// List of cameras in the device
  RxList<CameraDescription> cameras = RxList.empty();

  @override
  void onInit() async {
    _linkSubscription = await _appService.initializeDeepLink();
    _configService.init();

    WidgetsBinding.instance.addObserver(AppLifeCycle());

    super.onInit();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void updateRoute(Routing? routing) {
    if(kDebugMode) {
      console.log(routing?.route);
    } else {
      AnalyticsEngine.logScreen(routing?.route?.settings.name ?? "", routing?.route?.settings.toString() ?? "");
    }
  }

  RxBool showLoading = RxBool(false);
}