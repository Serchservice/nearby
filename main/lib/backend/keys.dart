import 'package:drive/library.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  /// Serch api key
  static const String _apiKey = "API_KEY";
  static final String apiKey = PlatformEngine.instance.isWeb
      ? const String.fromEnvironment(_apiKey)
      : dotenv.env[_apiKey] ?? "";

  /// Serch secret key
  static const String _secretKey = "SECRET_KEY";
  static final String secretKey = PlatformEngine.instance.isWeb
      ? const String.fromEnvironment(_secretKey)
      : dotenv.env[_secretKey] ?? "";

  /// Serch signature
  static const String _signature = "SIGNATURE";
  static final String signature = PlatformEngine.instance.isWeb
      ? const String.fromEnvironment(_signature)
      : dotenv.env[_signature] ?? "";

  /// Google map api key
  static String get googleMapApiKey {
    if(PlatformEngine.instance.isWeb) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_WEB"] ?? "";
    } else if(PlatformEngine.instance.isAndroid) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_ANDROID"] ?? "";
    } else if(PlatformEngine.instance.isIOS) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_IOS"] ?? "";
    } else {
      return "";
    }
  }
}