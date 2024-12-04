import 'package:drive/library.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

class InterstitialAdManager {
  String testKey = 'ca-app-pub-3940256099942544/5575463023';

  InterstitialAd? _interstitial;
  bool _isShowingAd = false;

  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = Duration(hours: 1);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _loadTime;

  /// Load an InterstitialAd.
  void loadAd() {
    InterstitialAd.load(
      adUnitId: Keys.admobInterstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _loadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          _loadStartAd();
          Logger.log('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  var startAppSdk = StartAppSdk();

  void _loadStartAd() {
    startAppSdk.setTestAdsEnabled(false);
    startAppSdk.loadInterstitialAd().then((interstitialAd) {
      _loadTime = DateTime.now();

      interstitialAd.show().then((shown) {
        return null;
      }).onError((error, stackTrace) {
        Logger.log("Error showing Interstitial ad: $error");
      });
    }).onError<StartAppException>((ex, stackTrace) {
      Logger.log("Error loading Interstitial ad: ${ex.message}");
    }).onError((error, stackTrace) {
      Logger.log("Error loading Interstitial ad: $error");
    });
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _interstitial != null;

  void load() {
    if(!isAdAvailable) {
      loadAd();
    } else {
      _loadStartAd();
    }
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      Logger.log('Tried to show ad before available.');

      load();
      return;
    }

    if (_isShowingAd) {
      Logger.log('Tried to show ad while already showing an ad.');

      return;
    }

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_loadTime!)) {
      Logger.log('Maximum cache duration exceeded. Loading another ad.');
      _interstitial?.dispose();
      _interstitial = null;

      load();
      return;
    }

    if(isAdAvailable) {
      // Set the fullScreenContentCallback and show the ad.
      _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
          Logger.log('$ad onAdShowedFullScreenContent');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          Logger.log('$ad onAdFailedToShowFullScreenContent: $error');
          _isShowingAd = false;
          ad.dispose();
          _interstitial = null;
        },
        onAdDismissedFullScreenContent: (ad) {
          Logger.log('$ad onAdDismissedFullScreenContent');
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