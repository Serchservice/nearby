import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingLayout extends GetResponsiveView<OnboardingController> {
  static String get route => "/onboarding";

  OnboardingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Onboarding"),
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.logoLogo,
              width: 120,
              height: 70,
              fit: BoxFit.contain,
              color: Theme.of(context).primaryColor
            ),
            const SizedBox(height: 15),
            SText(
              text: "Making your nearest search and movement, faster and better.",
              size: Sizing.font(34),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
            const SizedBox(height: 20),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(carReverseImage, width: 180,)
              ],
            ),
            ...controller.items.map((index) {
              return Container(
                margin: index != controller.items.length - 1 ? EdgeInsets.only(bottom: Sizing.space(6)) : null,
                width: MediaQuery.sizeOf(context).width,
                height: 2,
                color: Theme.of(context).primaryColor,
              );
            }),
            Spacer(),
            LoadingButton(
              padding: EdgeInsets.all(Sizing.space(12)),
              width: MediaQuery.sizeOf(context).width,
              text: "Get started",
              textColor: Theme.of(context).scaffoldBackgroundColor,
              buttonColor: Theme.of(context).primaryColor,
              borderRadius: 24,
              onClick: controller.getStarted,
            )
          ],
        ),
      )
    );
  }
}