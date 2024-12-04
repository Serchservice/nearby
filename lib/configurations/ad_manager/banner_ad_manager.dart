import 'dart:io' show Platform;

import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  final adUnitId = Platform.isAndroid
      ? Keys.admobBannerId
      : 'ca-app-pub-3940256099942544/2934735716';

  BannerAd? bannerAd;

  void loadAd() {
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdLoaded: (ad) {
          Logger.log(ad);
        }
      ),
      request: const AdRequest()
    )..load();
  }

  Widget banner() {
    if(bannerAd != null && bannerAd!.responseInfo != null) {
      return Container(
        height: 50,
        margin: EdgeInsets.only(bottom: Sizing.space(10)),
        child: AdWidget(ad: bannerAd!)
      );
    }

    return Container();
  }
}