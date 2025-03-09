import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:notify/notify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart/smart.dart';

import 'library.dart';

Future<void> main() async {
  _init();
  FirebaseMessaging.onBackgroundMessage(_backgroundRemoteMessagingHandler);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  return _initializeApp().then((v) => run(true, false));
}

void _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
}

@pragma("vm:entry-point")
Future<void> _backgroundRemoteMessagingHandler(RemoteMessage message) async {
  _init();
  return _initializeApp().then((_) async {
    FirebaseMessagingService messaging = FirebaseMessagingImplementation();
    messaging.background(message);
    runNotification();
  });
}

Future<void> _initializeApp() async {
  const platform = MethodChannel('com.serchservice.drive/apiKey');
  platform.setMethodCallHandler((call) async {
    if (call.method.equalsIgnoreCase('getMapApiKey')) {
      return Keys.googleMapApiKey;
    }
    return null;
  });

  Get.updateLocale(const Locale('en'));
  PlatformEngine.instance.initialize();
  return await Database.instance.initialize();
}

void run(bool checkUpdate, bool isBackground) {
  MainConfiguration.bind();
  // usePathUrlStrategy();
  runApp(Main(checkUpdate: checkUpdate, isBackground: isBackground));
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  _init();
  _initializeApp().then((v) {
    Notify.instance.handleNotificationResponse(response, handler: NotificationHandler.instance.process);
  });
}