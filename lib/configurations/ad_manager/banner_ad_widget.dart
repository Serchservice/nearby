import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:startapp_sdk/startapp.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final String testKey = 'ca-app-pub-3940256099942544/2934735716';
  BannerAd? _bannerAd;
  final StartAppSdk _startAppSdk = StartAppSdk();
  StartAppBannerAd? _startAppBannerAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: Keys.admobBannerId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          _loadStartAd();
          ad.dispose();
        },
        onAdLoaded: (ad) {
          setState(() {});
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void _loadStartAd() {
    _startAppSdk.setTestAdsEnabled(false);
    _startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
      setState(() {
        _startAppBannerAd = bannerAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _startAppBannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? adWidget() {
      if (_bannerAd != null && _bannerAd!.responseInfo != null) {
        return AdWidget(ad: _bannerAd!);
      } else if (_startAppBannerAd != null) {
        return StartAppBanner(_startAppBannerAd!);
      } else {
        return null;
      }
    }

    if (adWidget() != null) {
      return Container(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.only(bottom: 10.0),
        child: adWidget()!,
      );
    } else {
      return Container();
    }
  }
}