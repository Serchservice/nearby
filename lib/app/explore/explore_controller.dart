import 'dart:io';

import 'package:get/get.dart';
import 'package:drive/library.dart';

class ExploreController extends GetxController {
  ExploreController();
  final state = ExploreState();

  BannerAdManager bannerAdManager = BannerAdManager()..loadAd();

  List<ButtonView> apps = [
    ButtonView(
      header: "Serch | Provider/Associate",
      body: "Do more as a skilled provider with Serch. Increase your earnings, grow your skills and even get certified!",
      asset: Assets.appProvider,
      index: 0,
    ),
    ButtonView(
      header: "Serch | User",
      body: "Request for services, drive to any shop location, speak with a provider and get the fix you want!",
      asset: Assets.appUser,
      index: 1,
    ),
    ButtonView(
      header: "Serch | Business",
      body: "Grow your business, track and manage your providers' growth, increase your revenue and get more visibility!",
      asset: Assets.appBusiness,
      index: 2,
    )
  ];

  void open(int index) {
    if(index == 0) {
      if(Platform.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.provider");
      }
    } else if(index == 1) {
      if(Platform.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.user");
      }
    } else {
      if(Platform.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.business");
      }
    }
  }
}