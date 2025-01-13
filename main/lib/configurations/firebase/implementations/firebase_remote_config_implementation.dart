import 'dart:convert';

import 'package:drive/library.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigImplementation implements FirebaseRemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void init() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.fetchAndActivate();

    // remoteConfig.onConfigUpdated.listen((event) async {
    //   await remoteConfig.activate();
    //
    // });
  }

  @override
  String getAdmobAppOpenId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return remoteConfig.getString("ANDROID_APP_OPEN_ADMOB_ID");
    } else {
      return "ca-app-pub-3940256099942544/5575463023";
    }
  }

  @override
  String getAdmobBannerId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return remoteConfig.getString("ANDROID_BANNER_ADMOB_ID");
    } else {
      return "ca-app-pub-3940256099942544/2934735716";
    }
  }

  @override
  String getAdmobInterstitialId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return remoteConfig.getString("ANDROID_INTERSTITIAL_ADMOB_ID");
    } else {
      return 'ca-app-pub-3940256099942544/5575463023';
    }
  }

  @override
  String getOneSignalId() {
    return remoteConfig.getString("ONESIGNAL_ID");
  }

  @override
  HomeItem getSeasonPromotion() {
    try {
      RemoteConfigValue response = remoteConfig.getValue("NEARBY_SEASONAL");
      Map<String, dynamic> json = jsonDecode(response.asString());

      if(json["can_publish"]) {
        return HomeItem(
          title: json["season"] ?? "",
          sections: (json["sections"] as List<dynamic>).map((i) {
            return CategorySection.fromJsonWithColorStrings(i);
          }).toList(),
        );
      }
    } catch (_) { }
    
    return HomeItem(title: "", sections: []);
  }
}