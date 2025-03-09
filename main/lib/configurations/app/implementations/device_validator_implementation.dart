import 'package:drive/library.dart';
import 'package:device_safety_info/device_safety_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart/platform.dart';

class DeviceValidatorImplementation implements DeviceValidatorService {
  @override
  Future<DeviceValidator> isJailBroken() async {
    if(PlatformEngine.instance.isWeb) {
      return DeviceValidator.valid();
    } else {
      bool value = await DeviceSafetyInfo.isRootedDevice;

      if(value) {
        return DeviceValidator.invalid([
          "Your device appears to be jail broken or rooted.",
          "This indicates that restrictions imposed by the manufacturer or operating system have been bypassed.",
          "Such modifications compromise the device's security, exposing it to potential malware and attacks.",
          "For security reasons, Nearby does not allow its application to run on modified devices."
        ].join(" "));
      } else {
        return DeviceValidator.valid();
      }
    }
  }

  @override
  Future<DeviceValidator> isDeveloperMode() async {
    if(PlatformEngine.instance.isWeb) {
      return DeviceValidator.valid();
    } else {
      bool value = await DeviceSafetyInfo.isDeveloperMode;

      if(value) {
        return DeviceValidator.invalid([
          "Developer mode is currently enabled on your device which may expose your device",
          "to vulnerabilities and interfere with Nearby's functionality.",
          "Please disable developer mode to proceed."
        ].join(" "));
      } else {
        return DeviceValidator.valid();
      }
    }
  }

  @override
  Future<DeviceValidator> isMockedLocation() async {
    if(PlatformEngine.instance.isWeb) {
      return DeviceValidator.valid();
    } else {
      try {
        bool value = (await Geolocator.getCurrentPosition()).isMocked;

        if (value) {
          return DeviceValidator.invalid([
            "Your device seems to be using mock locations.",
            "This feature can compromise the integrity of location-based services.",
            "Nearby requires accurate location data to function correctly. Please disable mock location to continue."
          ].join(" "));
        } else {
          return DeviceValidator.valid();
        }
      } catch (_) {
        return DeviceValidator.valid();
      }
    }
  }

  @override
  Future<DeviceValidator> isRealDevice() async {
    if(PlatformEngine.instance.isWeb) {
      return DeviceValidator.valid();
    } else {
      bool value = await DeviceSafetyInfo.isRealDevice;

      if(!value) {
        return DeviceValidator.invalid([
          "It seems like you're using an emulator or virtual device.",
          "Nearby requires a real physical device to ensure optimal performance and security.",
          "Please switch to a compatible device to continue using the application."
        ].join(" "));
      } else {
        return DeviceValidator.valid();
      }
    }
  }
}