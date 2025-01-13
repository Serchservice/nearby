import 'package:get/get.dart';
import 'package:drive/library.dart';

final parentPage = GetPage(
  name: ParentLayout.route,
  page: () => CookieConsentWrapper(child: ParentLayout()),
  binding: ParentBinding(),
  transition: Transition.circularReveal,
  middlewares: [
    AuthMiddleware(),
    DeviceMiddleware()
  ],
  transitionDuration: const Duration(milliseconds: 800),
);

class Routes {
  static List<GetPage> all = [
    parentPage,

    GetPage(
      name: OnboardingLayout.route,
      page: () => CookieConsentWrapper(child: OnboardingLayout()),
      binding: OnboardingBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: LocationSearchLayout.route,
      page: () => CookieConsentWrapper(child: LocationSearchLayout()),
      binding: LocationSearchBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: CategorySearchLayout.route,
      page: () => CookieConsentWrapper(child: CategorySearchLayout()),
      binding: CategorySearchBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: WebLayout.route,
      page: () => CookieConsentWrapper(child: WebLayout()),
      binding: WebBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PageNotFoundLayout.route,
      page: () => CookieConsentWrapper(child: PageNotFoundLayout()),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PlatformErrorLayout.route,
      page: () => CookieConsentWrapper(child: PlatformErrorLayout()),
      binding: PlatformErrorBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: ResultLayout.route,
      page: () => CookieConsentWrapper(child: ResultLayout()),
      binding: ResultBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 800),
    ),
  ];
}