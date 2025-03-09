import 'package:get/get.dart';
import 'package:drive/library.dart';

final parentPage = GetPage(
  name: ParentLayout.route,
  page: () => ConsentWrapper(child: ParentLayout()),
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
      page: () => ConsentWrapper(child: OnboardingLayout()),
      binding: OnboardingBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: LocationSearchLayout.route,
      page: () => ConsentWrapper(child: LocationSearchLayout()),
      binding: LocationSearchBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: CategorySearchLayout.route,
      page: () => ConsentWrapper(child: CategorySearchLayout()),
      binding: CategorySearchBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: WebLayout.route,
      page: () => ConsentWrapper(child: WebLayout()),
      binding: WebBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PageNotFoundLayout.route,
      page: () => ConsentWrapper(child: PageNotFoundLayout()),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: PlatformErrorLayout.route,
      page: () => ConsentWrapper(child: PlatformErrorLayout()),
      binding: PlatformErrorBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: ResultLayout.route,
      page: () => ConsentWrapper(child: ResultLayout()),
      binding: ResultBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: AccountUpdateLayout.route,
      page: () => ConsentWrapper(child: AccountUpdateLayout()),
      binding: AccountUpdateBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: AddonLayout.route,
      page: () => ConsentWrapper(child: AddonLayout()),
      binding: AddonBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.cupertinoDialog,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: GoActivityLayout.route,
      page: () => ConsentWrapper(child: GoActivityLayout()),
      binding: GoActivityBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: GoInterestLayout.route,
      page: () => ConsentWrapper(child: GoInterestLayout()),
      binding: GoInterestBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: NearbyHistoryLayout.route,
      page: () => ConsentWrapper(child: NearbyHistoryLayout()),
      binding: NearbyHistoryBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: GoActivityViewerLayout.route,
      page: () => ConsentWrapper(child: GoActivityViewerLayout()),
      binding: GoActivityViewerBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: GoBCapViewerLayout.route,
      page: () => ConsentWrapper(child: GoBCapViewerLayout()),
      binding: GoBCapViewerBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: GoSimilarActivityViewerLayout.route,
      page: () => ConsentWrapper(child: GoSimilarActivityViewerLayout()),
      binding: GoSimilarActivityViewerBinding(),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: VerifyTransaction.route,
      page: () => ConsentWrapper(child: VerifyTransaction()),
      middlewares: [
        DeviceMiddleware(),
      ],
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}