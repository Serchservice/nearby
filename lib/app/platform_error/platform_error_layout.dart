import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:drive/library.dart';

class PlatformErrorLayout extends GetResponsiveView<PlatformErrorController> {
  static String route = "/page/error/platform";

  final String? error;
  PlatformErrorLayout({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if(error != null) {
      return GetBuilder<PlatformErrorController>(
        init: PlatformErrorController(error: error),
        builder: (controller) => render(context, controller)
      );
    } else {
      return render(context, controller);
    }
  }

  Widget render(BuildContext context, PlatformErrorController controller) {
    List<ButtonView> buttons = [
      ButtonView(
        header: "Serch Help Center",
        body: "Learn why you might be getting platform error.",
        icon: Icons.rule_rounded,
        index: 0
      ),
      ButtonView(
        header: "Reach out to the team",
        icon: Icons.polymer_sharp,
        index: 1
      ),
    ];

    return MainLayout(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.logoSplashWhite,
              width: 100,
              color: Theme.of(context).primaryColor,
            ),
            LineHeader(
              header: "Oops! An error.",
              footer: "Platform error just happened",
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(Sizing.space(12)),
                      ),
                      child: Obx(() => SText(
                        text: controller.state.message.value,
                        size: Sizing.font(14),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ))
                  ),
                  const SizedBox(height: 30),
                  SText(text: "Quick actions", color: Theme.of(context).primaryColor),
                  const SizedBox(height: 30),
                  ...buttons.map((button) => Padding(
                    padding: EdgeInsets.only(bottom: Sizing.space(10)),
                    child: NavigatorButton(
                      header: button.header,
                      backgroundColor: Theme.of(context).splashColor,
                      detail: button.body,
                      prefixIcon: button.icon,
                      detailSize: 12,
                      onPressed: () {
                        if(button.index == 0) {
                          RouteNavigator.openLink(url: "https://help.serchservice.com");
                        } else {
                          RouteNavigator.mail("improve@serchservice.com");
                        }
                      },
                    )
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Image.asset(Assets.logoSmeBlack, width: 150, color: Theme.of(context).primaryColor),
              ),
            ),
            if(controller.bannerAdManager.banner() != null) ...[
              controller.bannerAdManager.banner()!
            ]
          ]
        ),
      )
    );
  }
}