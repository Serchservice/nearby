import 'package:drive/library.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smart/smart.dart' show BoolExtensions;

class AppOpenAdManager {
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  final bool _isPlatformPermitted = PlatformEngine.instance.isMobile;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Load an AppOpenAd.
  void loadAd() {
    if(_isPlatformPermitted && PlatformEngine.instance.debug.isFalse) {
      try {
        AppOpenAd.load(
          adUnitId: _configService.getAdmobAppOpenId(),
          request: AdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              _appOpenAd = ad;
              _appOpenLoadTime = DateTime.now();
            },
            onAdFailedToLoad: (error) {
              console.log('AppOpenAd failed to load: $error');
            },
          ),
        );
      } catch (e) {
        console.log('AppOpenAd failed to load', from: "[APP OPEN AD]");
        console.error(e, from: "[APP OPEN AD]");
      }
    }
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _appOpenAd != null;

  void showAdIfAvailable() {
    if(!_isPlatformPermitted) {
      return;
    }

    if (!isAdAvailable) {
      console.log('Tried to show ad before available.');
      loadAd();

      return;
    }

    if (_isShowingAd) {
      console.log('Tried to show ad while already showing an ad.');

      return;
    }

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      console.log('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();

      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        console.log('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        console.log('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        console.log('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    _appOpenAd!.show();
  }
}