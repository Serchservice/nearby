import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smart/smart.dart' show BoolExtensions;

class BannerAdWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const BannerAdWidget({super.key, this.height, this.width, this.margin});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();
  final bool _isPlatformPermitted = PlatformEngine.instance.isMobile;

  @override
  void initState() {
    if(_isPlatformPermitted && PlatformEngine.instance.debug.isFalse) {
      _loadAd();
    }

    super.initState();
  }

  void _loadAd() {
   try {
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
   } catch (e) {
     console.log('AppOpenAd failed to load', from: "[BANNER AD]");
     console.error(e, from: "[BANNER AD]");
   }
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
          height: widget.height ?? 50,
          width: widget.width ?? MediaQuery.sizeOf(context).width,
          margin: widget.margin ?? EdgeInsets.only(bottom: 10.0),
          child: adWidget,
        );
      }
    }

    return SizedBox.shrink();
  }
}