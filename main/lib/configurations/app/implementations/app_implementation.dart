import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:device_safety_info/device_safety_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:drive/library.dart';

class AppImplementation implements AppService {
  final AppLinks _appLinks = AppLinks();
  final ConnectService _connect = Connect();
  final FirebaseMessagingService _messagingService = FirebaseMessagingImplementation();

  @override
  Future<StreamSubscription<Uri>> initializeDeepLink() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      log('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    StreamSubscription<Uri> subscription = _appLinks.uriLinkStream.listen((uri) {
      log('onAppLink: $uri');
      openAppLink(uri);
    });
    return subscription;
  }

  @override
  void openAppLink(Uri uri) {
    log(uri.fragment);
  }

  @override
  void verifyDevice() async {
    if(!PlatformEngine.instance.isWeb) {
      bool isJailBroken = await DeviceSafetyInfo.isRootedDevice;
      if (isJailBroken) {
        throw SerchException(isPlatformNotSupported: true, [
          "Your device appears to be jail broken or rooted.",
          "This indicates that restrictions imposed by the manufacturer or operating system have been bypassed.",
          "Such modifications compromise the device's security, exposing it to potential malware and attacks.",
          "For security reasons, Serch does not allow its application to run on modified devices."
        ].join(" "));
      }

      bool isRealDevice = await DeviceSafetyInfo.isRealDevice;
      if (!isRealDevice) {
        throw SerchException(isPlatformNotSupported: true, [
          "It seems like you're using an emulator or virtual device.",
          "Serch requires a real physical device to ensure optimal performance and security.",
          "Please switch to a compatible device to continue using the application."
        ].join(" "));
      }

      bool isDeveloperMode = await DeviceSafetyInfo.isDeveloperMode;
      if (isDeveloperMode) {
        throw SerchException(isPlatformNotSupported: true, [
          "Developer mode is currently enabled on your device which may expose your device",
          "to vulnerabilities and interfere with Serch's functionality.",
          "Please disable developer mode to proceed."
        ].join(" "));
      }
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

  @override
  void checkUpdate() async {
    if(!PlatformEngine.instance.isWeb) {
      InAppUpdate.checkForUpdate().then((AppUpdateInfo info) {
        if(info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((AppUpdateResult result) {
            if(result == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      });
    }
  }

  @override
  void registerDevice() async {
    String fcmToken = await _messagingService.getFcmToken();
    Device device = PlatformEngine.instance.device;

    ApiResponse response = await _connect.post(endpoint: "/auth/nearby/register", body: {
      "id": Database.preference.id.isEmpty ? null : Database.preference.id,
      "fcm_token": fcmToken,
      "device": device.id,
      "name": device.name,
      "host": device.host,
      "platform": device.platform,
      "operating_system": device.operatingSystem,
      "operating_system_version": device.operatingSystemVersion,
      "local_host": device.localHostName,
      "ip_address": device.ipAddress
    });

    if(response.isSuccessful) {
      Database.savePreference(Database.preference.copyWith(id: response.data));
    }
  }
}