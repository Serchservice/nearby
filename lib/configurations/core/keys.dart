import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  /// Serch api key
  static final String apiKey = dotenv.env["API_KEY"] ?? "";

  /// Serch secret key
  static final String secretKey = dotenv.env["SECRET_KEY"] ?? "";

  /// Serch signature
  static final String signature = dotenv.env["SIGNATURE"] ?? "";

  /// Google map api key
  static String get googleMapApiKey {
    if(Platform.isAndroid) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_ANDROID"] ?? "";
    } else if(Platform.isIOS) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_IOS"] ?? "";
    } else {
      return "";
    }
  }

  static String get admobBannerId {
    if(Platform.isAndroid) {
      return dotenv.env["ANDROID_BANNER_ADMOB_ID"] ?? "";
    } else {
      return "";
    }
  }

  static String get admobAppOpenId {
    if(Platform.isAndroid) {
      return dotenv.env["ANDROID_APP_OPEN_ADMOB_ID"] ?? "";
    } else {
      return "";
    }
  }

  static String get admobInterstitialId {
    if(Platform.isAndroid) {
      return dotenv.env["ANDROID_INTERSTITIAL_ADMOB_ID"] ?? "";
    } else {
      return "";
    }
  }
}