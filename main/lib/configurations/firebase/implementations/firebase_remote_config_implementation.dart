import 'dart:convert';

import 'package:drive/library.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigImplementation implements FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

  @override
  void init() async {
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _config.fetchAndActivate();

    // _config.onConfigUpdated.listen((activity) async {
    //   await _config.activate();
    //
    // });
  }

  @override
  String getAdmobAppOpenId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return _config.getString("ANDROID_APP_OPEN_ADMOB_ID");
    } else {
      return "ca-app-pub-3940256099942544/5575463023";
    }
  }

  @override
  String getAdmobBannerId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return _config.getString("ANDROID_BANNER_ADMOB_ID");
    } else {
      return "ca-app-pub-3940256099942544/2934735716";
    }
  }

  @override
  String getAdmobInterstitialId() {
    if(PlatformEngine.instance.isWeb) {
      return "";
    } else if(PlatformEngine.instance.isAndroid) {
      return _config.getString("ANDROID_INTERSTITIAL_ADMOB_ID");
    } else {
      return 'ca-app-pub-3940256099942544/5575463023';
    }
  }

  @override
  List<Suggestion> getSeasonPromotion() {
    List<Suggestion> items = [];

    try {
      RemoteConfigValue response = _config.getValue("NEARBY_SEASONAL");
      dynamic json = jsonDecode(response.asString());

      if(json is Map) {
        items.add(Suggestion.fromJson(json as Map<String, dynamic>));
      } else if(json is List) {
        items = json.map((i) => Suggestion.fromJson(i)).toList();
      }

    } catch (_) { }
    
    return items;
  }
}