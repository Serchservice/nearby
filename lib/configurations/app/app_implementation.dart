import 'dart:async';
import 'dart:io' show Platform, NetworkInterface;
import 'package:device_safety_info/device_safety_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:drive/library.dart';

class AppImplementation implements AppService {
  final AppLinks _appLinks = AppLinks();

  Future<String> get ipAddress async {
    if(kIsWeb) {
      return "";
    } else {
      var networks = await NetworkInterface.list();
      if(networks.isNotEmpty) {
        var addresses = networks.first.addresses;
        if(addresses.isNotEmpty) {
          return addresses.first.address;
        }
      }
    }
    return "";
  }

  @override
  void buildDeviceInformation({required Function(Device device) onSuccess}) async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    String ip = await ipAddress;
    Device device = Device.empty();
    device = device.copyWith(ipAddress: ip);

    if(kIsWeb) {
      WebBrowserInfo web = await info.webBrowserInfo;
      device = device.copyWith(
        id: web.userAgent,
        name: web.browserName.name,
        host: web.appCodeName,
        platform: "Web"
      );
      onSuccess.call(device);
    } else if(Platform.isAndroid) {
      AndroidDeviceInfo android = await info.androidInfo;
      device = device.copyWith(
        sdk: android.version.sdkInt,
        id: android.id,
        name: android.model,
        host: android.host,
        platform: "Android"
      );
      onSuccess.call(device);
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await info.iosInfo;
      device = device.copyWith(
        id: ios.identifierForVendor,
        name: ios.utsname.machine,
        host: ios.utsname.nodename,
        platform: "iOS"
      );
      onSuccess.call(device);
    } else if(Platform.isLinux) {
      LinuxDeviceInfo linux = await info.linuxInfo;
      device = device.copyWith(
        id: linux.id,
        name: linux.prettyName,
        host: linux.versionCodename,
        platform: "Linux"
      );
      onSuccess.call(device);
    } else if(Platform.isMacOS) {
      MacOsDeviceInfo macOs = await info.macOsInfo;
      device = device.copyWith(
        id: macOs.kernelVersion,
        name: macOs.model,
        host: macOs.hostName,
        platform: "MacOs"
      );
      onSuccess.call(device);
    } else if(Platform.isWindows) {
      WindowsDeviceInfo windows = await info.windowsInfo;
      device = device.copyWith(
        id: windows.deviceId,
        name: windows.productName,
        host: windows.computerName,
        platform: "Windows"
      );
      onSuccess.call(device);
    } else {
      throw SerchException("Platform not supported", isPlatformNotSupported: true);
    }
  }

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