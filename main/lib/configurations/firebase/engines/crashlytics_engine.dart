import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:drive/library.dart";

class CrashlyticsEngine {
  static final _instance = FirebaseCrashlytics.instance;

  static void handle() async {
    FlutterError.onError = _instance.recordFlutterFatalError;

    FlutterError.onError = (errorDetails) {
      if(kDebugMode) {
        console.error(errorDetails, from: errorDetails.library);
      } else {
        _instance.recordFlutterFatalError(errorDetails);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if(kDebugMode) {
        console.error(error, from: stack.toString());
      } else {
        _instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
  }

  static void logError(String error, String from) {
    if(kDebugMode) {
      console.error(error, from: from);
    } else {
      _instance.setUserIdentifier(Database.instance.device.id);
      _instance.log("$from: => $error");
    }
  }
}