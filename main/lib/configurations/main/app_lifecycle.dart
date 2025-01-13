import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class AppLifeCycle extends WidgetsBindingObserver {
  final AsyncCallback onForeground;
  final AsyncCallback onPaused;
  final AsyncCallback onDetached;
  final AsyncCallback onInactive;
  final AsyncCallback onHidden;

  AppLifeCycle({
    required this.onForeground,
    required this.onPaused,
    required this.onDetached,
    required this.onInactive,
    required this.onHidden,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch(state) {
      case AppLifecycleState.resumed:
        await onForeground();
        break;
      case AppLifecycleState.inactive:
        await onInactive();
        break;
      case AppLifecycleState.detached:
        await onDetached();
        break;
      case AppLifecycleState.paused:
        await onPaused();
        break;
      case AppLifecycleState.hidden:
        await onHidden();
        break;
      }
  }

  Future<void> init() async {
    log("Listening from AppLifeCycle");
  }
}