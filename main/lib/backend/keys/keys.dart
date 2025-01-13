import 'package:drive/library.dart';
import 'package:envied/envied.dart';

part 'keys.g.dart';

@Envied(path: '.env')
abstract class Keys {
  @EnviedField(varName: "API_KEY", obfuscate: true)
  static String apiKey = _Keys.apiKey;

  @EnviedField(varName: "SECRET_KEY", obfuscate: true)
  static String secretKey = _Keys.secretKey;

  @EnviedField(varName: "SIGNATURE", obfuscate: true)
  static String signature = _Keys.signature;

  @EnviedField(varName: "GOOGLE_MAPS_API_KEY_WEB", obfuscate: true)
  static String googleMapsApiKeyWeb = _Keys.googleMapsApiKeyWeb;

  @EnviedField(varName: "GOOGLE_MAPS_API_KEY_ANDROID", obfuscate: true)
  static String googleMapsApiKeyAndroid = _Keys.googleMapsApiKeyAndroid;

  @EnviedField(varName: "GOOGLE_MAPS_API_KEY_IOS", obfuscate: true)
  static String googleMapsApiKeyIos = _Keys.googleMapsApiKeyIos;

  /// Google map api key
  static String get googleMapApiKey {
    if(PlatformEngine.instance.isWeb) {
      return googleMapsApiKeyWeb;
    } else if(PlatformEngine.instance.isAndroid) {
      return googleMapsApiKeyAndroid;
    } else if(PlatformEngine.instance.isIOS) {
      return googleMapsApiKeyIos;
    } else {
      return "";
    }
  }
}