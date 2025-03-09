import 'dart:async';

import 'package:drive/library.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int get priority => 1;

  @override
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route) {
    if(!PlatformEngine.instance.isWeb && Database.instance.preference.isNew) {
      return RouteDecoder.fromRoute(OnboardingLayout.route);
    }

    return route;
  }
}