import 'dart:async';

import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class AppLifeCycle extends WidgetsBindingObserver {
  AppLifeCycle();

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _init();

    switch(state) {
      case AppLifecycleState.resumed:
        return await _onForeground();
      case AppLifecycleState.inactive:
        return await _onInactive();
      case AppLifecycleState.detached:
        return await _onDetached();
      case AppLifecycleState.paused:
        return await _onPaused();
      case AppLifecycleState.hidden:
        return await _onHidden();
    }
  }

  Future<void> _init() async {
    console.log("Listening from AppLifeCycle");
  }

  void _updateBackground(bool isBackground) {
    try {
      MainConfiguration.data.isBackground.value = isBackground;
    } catch (_) {}
  }

  Future<void> _onForeground() async {
    NotificationController.instance.register();

    console.log("FOREGROUND", from: "LifeCycle - Main Configuration");
    _updateBackground(false);
  }

  Future<void> _onInactive() async {
    NotificationController.instance.register();

    console.log("INACTIVE", from: "LifeCycle - Main Configuration");
    _updateBackground(true);
  }

  Future<void> _onDetached() async {
    console.log("DETACHED", from: "LifeCycle - Main Configuration");
    _updateBackground(true);
  }

  Future<void> _onPaused() async {
    NotificationController.instance.register();

    console.log("PAUSED", from: "LifeCycle - Main Configuration");
    _updateBackground(true);
  }

  Future<void> _onHidden() async {
    NotificationController.instance.register();

    console.log("HIDDEN", from: "LifeCycle - Main Configuration");
    _updateBackground(true);
  }
}