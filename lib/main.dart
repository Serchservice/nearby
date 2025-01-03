import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'library.dart';

bool isCurrentRoute(String route) => Get.currentRoute == route;

void _loadPlatformChannel() {
  const platform = MethodChannel('com.serchservice.drive/apiKey');
  platform.setMethodCallHandler((call) async {
    if (call.method == 'getMapApiKey') {
      return Keys.googleMapApiKey;
    }
    return null;
  });
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  _loadPlatformChannel();
  Get.updateLocale(const Locale('en'));
  MainConfiguration.bind();

  return await Database.initialize();
}

@pragma("vm:entry-point")
Future<void> _backgroundRemoteMessagingHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  _initializeApp().then((_) {
    MainConfiguration.bind();

    FirebaseMessagingService messaging = FirebaseMessagingImplementation();
    messaging.background(message);

    usePathUrlStrategy();
    runApp(const Main());
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  MobileAds.instance.initialize();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  FirebaseMessaging.onBackgroundMessage(_backgroundRemoteMessagingHandler);

  Get.updateLocale(const Locale('en'));
  _initializeApp().then((_) {
    usePathUrlStrategy();
    runApp(const Main());
  });
}