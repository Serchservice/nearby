import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class MainConfiguration extends GetxController {
  MainConfiguration();

  static MainConfiguration get data => Get.find<MainConfiguration>();

  static void bind() {
    try {
      if(!MainConfiguration.data.initialized) {
        Get.put<MainConfiguration>(MainConfiguration());
      }
    } catch (_) {
      Get.put<MainConfiguration>(MainConfiguration());
    }
  }

  final AppService _appService = AppImplementation();

  StreamSubscription<Uri>? _linkSubscription;

  /// Current route information
  Rx<Routing> currentRoute = Routing().obs;

  @override
  void onInit() async {
    _linkSubscription = await _appService.initializeDeepLink();

    AppLifeCycle appLifeCycle = AppLifeCycle(
      onForeground: () async { },
      onPaused: () async { },
      onDetached: () async { },
      onInactive: () async { },
      onHidden: () async { }
    );
    WidgetsBinding.instance.addObserver(appLifeCycle);
    appLifeCycle.init();

    super.onInit();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void updateRoute(Routing? routing) {
    if(kDebugMode) {
      Logger.log(routing?.route);
    } else {
      AnalyticsEngine.logScreen(routing?.route?.settings.name ?? "", routing?.route?.settings.toString() ?? "");
    }
  }
}