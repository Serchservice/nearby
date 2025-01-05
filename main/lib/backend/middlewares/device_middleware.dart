import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceMiddleware extends GetMiddleware{
  int? _priority = 0;

  @override
  int? get priority => _priority;

  @override
  set priority(int? value) {
    _priority = value;
  }

  DeviceMiddleware({
    int? priority
  }) : _priority = priority;

  @override
  RouteSettings? redirect(String? route) {
    AppService service = AppImplementation();
    service.verifyDevice();

    return null;
  }
}