import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();
  final bool _isPlatformPermitted = PlatformEngine.instance.isMobile;

  @override
  void initState() {
    if(_isPlatformPermitted) {
      _loadAd();
    }

    super.initState();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: _configService.getAdmobBannerId(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _loadAd();
        },
        onAdLoaded: (ad) {
          setState(() {});
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_isPlatformPermitted) {
      Widget? adWidget;

      if (_bannerAd != null && _bannerAd!.responseInfo != null) {
        adWidget = AdWidget(ad: _bannerAd!);
      }

      if (adWidget != null) {
        return Container(
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          margin: EdgeInsets.only(bottom: 10.0),
          child: adWidget,
        );
      }
    }

    return SizedBox.shrink();
  }
}