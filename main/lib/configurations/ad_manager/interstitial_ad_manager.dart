import 'package:drive/library.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smart/smart.dart' show BoolExtensions;

class InterstitialAdManager {
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();

  InterstitialAd? _interstitial;
  bool _isShowingAd = false;

  final bool _isPlatformPermitted = PlatformEngine.instance.isMobile;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 1);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _loadTime;

  /// Load an InterstitialAd.
  void loadAd() {
    if(_isPlatformPermitted && PlatformEngine.instance.debug.isFalse) {
      try {
        InterstitialAd.load(
          adUnitId: _configService.getAdmobInterstitialId(),
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _interstitial = ad;
              _loadTime = DateTime.now();
            },
            onAdFailedToLoad: (error) {
              console.log('InterstitialAd failed to load: $error');
            },
          ),
        );
      } catch (e) {
        console.log('AppOpenAd failed to load', from: "[INTERSTITIAL AD]");
        console.error(e, from: "[INTERSTITIAL AD]");
      }
    }
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _interstitial != null;

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

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_loadTime!)) {
      console.log('Maximum cache duration exceeded. Loading another ad.');
      _interstitial?.dispose();
      _interstitial = null;

      loadAd();
      return;
    }

    if(isAdAvailable) {
      // Set the fullScreenContentCallback and show the ad.
      _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
          console.log('$ad onAdShowedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          console.log('$ad onAdFailedToShowFullScreenContent: $error');
          _isShowingAd = false;
          ad.dispose();
          _interstitial = null;
        },
        onAdDismissedFullScreenContent: (ad) {
          console.log('$ad onAdDismissedFullScreenContent');
          _isShowingAd = false;
          ad.dispose();
          _interstitial = null;
          loadAd();
        },
      );

      _interstitial!.show();
    }
  }
}