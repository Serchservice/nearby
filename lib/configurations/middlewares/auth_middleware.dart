import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if(Database.preference.isNew) {
      return RouteSettings(name: OnboardingLayout.route);
    }

    return super.redirect(route);
  }
}