import 'package:drive/library.dart';

/// A service interface for managing Firebase Remote Config interactions.
/// This abstract class provides methods to initialize the service and fetch AdMob ad unit IDs
/// dynamically from Firebase Remote Config.
abstract class FirebaseRemoteConfigService {

  /// Initializes the Firebase Remote Config service.
  ///
  /// This method should be called before accessing any configuration values.
  /// It typically includes fetching remote configurations and activating them.
  void init();

  /// Retrieves the AdMob banner ad unit ID from Firebase Remote Config.
  ///
  /// This method returns the ID as a `String`, which is used to display banner ads in the app.
  ///
  /// Example use case:
  /// ```dart
  /// String bannerId = remoteConfigService.getAdmobBannerId();
  /// ```
  String getAdmobBannerId();

  /// Retrieves the AdMob interstitial ad unit ID from Firebase Remote Config.
  ///
  /// This method returns the ID as a `String`, which is used to display interstitial ads in the app.
  ///
  /// Example use case:
  /// ```dart
  /// String interstitialId = remoteConfigService.getAdmobInterstitialId();
  /// ```
  String getAdmobInterstitialId();

  /// Retrieves the AdMob app open ad unit ID from Firebase Remote Config.
  ///
  /// This method returns the ID as a `String`, which is used to display app open ads.
  ///
  /// Example use case:
  /// ```dart
  /// String appOpenId = remoteConfigService.getAdmobAppOpenId();
  /// ```
  String getAdmobAppOpenId();

  /// Retrieves the promotional item from Firebase Remote Config.
  ///
  /// This method returns the ID as a `HomeItem`, which is used for onesignal authentication.
  ///
  /// Example use case:
  /// ```dart
  /// HomeItem item = remoteConfigService.getSeasonPromotion();
  /// ```
  List<Suggestion> getSeasonPromotion();
}