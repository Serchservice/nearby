import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:safe_device/safe_device.dart';

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

void runChecks() async {
  bool isJailBroken = await SafeDevice.isJailBroken;
  if (isJailBroken) {
    throw SerchException(isPlatformNotSupported: true, [
      "Your device appears to be jailbroken or rooted.",
      "This indicates that restrictions imposed by the manufacturer or operating system have been bypassed.",
      "Such modifications compromise the device's security, exposing it to potential malware and attacks.",
      "For security reasons, Serch does not allow its application to run on modified devices."
    ].join(" "));
  }

  bool isRealDevice = await SafeDevice.isRealDevice;
  if (!isRealDevice) {
    throw SerchException(isPlatformNotSupported: true, [
      "It seems like you're using an emulator or virtual device.",
      "Serch requires a real physical device to ensure optimal performance and security.",
      "Please switch to a compatible device to continue using the application."
    ].join(" "));
  }

  bool isDevelopmentMode = await SafeDevice.isDevelopmentModeEnable;
  if (isDevelopmentMode) {
    throw SerchException(isPlatformNotSupported: true, [
      "Developer mode is currently enabled on your device.",
      "This mode may expose your device to vulnerabilities and interfere with Serch's functionality.",
      "Please disable developer mode to proceed."
    ].join(" "));
  }

  bool isMockedLocation = (await Geolocator.getCurrentPosition()).isMocked;
  if (isMockedLocation) {
    throw SerchException(isPlatformNotSupported: true, [
      "Your device seems to be using mock locations.",
      "This feature can compromise the integrity of location-based services.",
      "Serch requires accurate location data to function correctly. Please disable mock location to continue."
    ].join(" "));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  MobileAds.instance.initialize();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  Get.updateLocale(const Locale('en'));
  _initializeApp().then((_) => {
    runApp(const Main())
  });
}