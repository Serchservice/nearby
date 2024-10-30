import 'dart:async';
import 'dart:io' show Platform, NetworkInterface;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:safe_device/safe_device.dart';
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
    // bool isJailBroken = await SafeDevice.isJailBroken;
    // bool isRealDevice = await SafeDevice.isRealDevice;
    // bool isMockLocation = await SafeDevice.isMockLocation;
    // bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    //
    // if(isJailBroken) {
    //   throw SerchException(
    //     "Device not supported. Review your device settings to make sure you're not violating any real device setup.",
    //     isPlatformNotSupported: true
    //   );
    // } else if(!isRealDevice) {
    //   throw SerchException(
    //     "The Serch platform can only run on real devices. Verify your device setup and try again.",
    //     isPlatformNotSupported: true
    //   );
    // } else if(isMockLocation) {
    //   throw SerchException(
    //       "You are either using a mock location or location service is not enabled on this device. As such, you cannot continue.",
    //     isPlatformNotSupported: true
    //   );
    // } else if(isDevelopmentModeEnable) {
    //   throw SerchException(
    //     "You seem to be running your device in developer mode. Switch it off to continue usage of the Serch platform.",
    //     isPlatformNotSupported: true
    //   );
    // }
  }
}