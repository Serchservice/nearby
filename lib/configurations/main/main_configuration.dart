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
      onForeground: () async {
        log("FOREGROUND", from: "LifeCycle - Main Configuration");
      },
      onPaused: () async {
        log("PAUSED", from: "LifeCycle - Main Configuration");
      },
      onDetached: () async {
        log("DETACHED", from: "LifeCycle - Main Configuration");
      },
      onInactive: () async {
        log("INACTIVE", from: "LifeCycle - Main Configuration");
      },
      onHidden: () async {
        log("HIDDEN", from: "LifeCycle - Main Configuration");
      }
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