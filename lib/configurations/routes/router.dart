import 'package:get/get.dart';
import 'package:drive/library.dart';

class Routes {
  static List<GetPage> all = [
    GetPage(
      name: HomeLayout.route,
      page: () => HomeLayout(),
      binding: HomeBinding(),
      middlewares: [
        AuthMiddleware()
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: OnboardingLayout.route,
      page: () => OnboardingLayout(),
      binding: OnboardingBinding(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: LocationSearchLayout.route,
      page: () => LocationSearchLayout(),
      binding: LocationSearchBinding(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: WebLayout.route,
      page: () => const WebLayout(),
      binding: WebBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: ExploreLayout.route,
      page: () => ExploreLayout(),
      binding: ExploreBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PageNotFoundLayout.route,
      page: () => PageNotFoundLayout(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PlatformErrorLayout.route,
      page: () => PlatformErrorLayout(),
      binding: PlatformErrorBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: ResultLayout.route,
      page: () => ResultLayout(),
      binding: ResultBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: UpdateLayout.route,
      page: () => UpdateLayout(),
      binding: UpdateBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),
  ];
}