import 'dart:async';

import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/platform.dart';

class DeviceMiddleware extends GetMiddleware {
  // Shared cache for all instances of this middleware
  static final Map<String, DeviceValidator?> _cache = {};

  final DeviceValidatorService validator = DeviceValidatorImplementation();

  DeviceMiddleware();

  @override
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    MainConfiguration.data.showLoading.value = true;

    // Check if there's a cached result for every validation type
    if(_cache.entries.isNotEmpty) {
      for (MapEntry<String, DeviceValidator?> entry in _cache.entries) {
        DeviceValidator? result = entry.value;

        if (result != null && !result.isValid) {
          MainConfiguration.data.showLoading.toggle();
          return _fromRoute(PlatformErrorLayout.route, arguments: result.message);
        }
      }

      /// Run checks again in background for future updates
      Future.microtask(() async {
        for (MapEntry<String, ValidatorCallback> entry in _validators.entries) {
          String key = entry.key;
          ValidatorCallback check = entry.value;

          DeviceValidator result = await check();
          _cache.update(key, (DeviceValidator? value) => result, ifAbsent: () => result);
        }
      });

      MainConfiguration.data.showLoading.toggle();
      return route;
    } else {
      /// Run checks again in background for future updates
      Future.microtask(() async {
        for (MapEntry<String, ValidatorCallback> entry in _validators.entries) {
          String key = entry.key;
          ValidatorCallback check = entry.value;

          DeviceValidator result = await check();
          _cache.update(key, (DeviceValidator? value) => result, ifAbsent: () => result);

          if(!result.isValid) {
            Navigate.all(PlatformErrorLayout.route, arguments: result.message);
          }
        }
      });

      MainConfiguration.data.showLoading.toggle();
      return route;
    }
  }

  // Validation functions with unique keys
  DeviceValidation get _validators {
    DeviceValidation validation = {
      'isJailBroken': () => validator.isJailBroken(),
      'isMockedLocation': () => validator.isMockedLocation(),
      'isRealDevice': () => validator.isRealDevice(),
    };

    if(!PlatformEngine.instance.debug) {
      validation.putIfAbsent('isDeveloperMode', () => validator.isDeveloperMode);
    }

    return validation;
  }

  RouteDecoder _fromRoute(String location, {Object? arguments}) {
    Uri uri = Uri.parse(location);
    PageSettings args = PageSettings(uri, arguments);
    RouteDecoder decoder = (Get.rootController.rootDelegate).matchRoute(location, arguments: args);

    decoder.route = decoder.route?.copyWith(
      completer: null,
      arguments: args,
      parameters: args.params,
    );

    return decoder;
  }
}