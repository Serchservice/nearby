import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceMiddleware extends GetMiddleware{
  DeviceMiddleware();

  @override
  RouteSettings? redirect(String? route) {
    AppService service = AppImplementation();
    service.verifyDevice();

    return null;
  }
}