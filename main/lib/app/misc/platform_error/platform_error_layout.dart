import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class PlatformErrorLayout extends GetResponsiveView<PlatformErrorController> {
  static String route = "/page/error/platform";

  final String? error;
  PlatformErrorLayout({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if(error.isNotNull && error!.isNotEmpty) {
      return GetBuilder<PlatformErrorController>(
        init: PlatformErrorController(error: error),
        builder: (controller) => render(context, controller)
      );
    } else {
      return render(context, controller);
    }
  }

  Widget render(BuildContext context, PlatformErrorController controller) {
    List<ButtonView> buttons = LinkUtils.instance.platformErrorSupport(
      app: SmartApp.nearby,
      showWebApp: PlatformEngine.instance.isWeb
    );

    return LayoutWrapper(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(20)),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logoLogo,
                  width: 70,
                  color: Theme.of(context).primaryColor,
                ),
                Spacer(),
                Image.asset(
                  Assets.logoFavicon,
                  width: 30,
                )
              ]
            ),
            SizedBox(height: 10),
            TextBuilder(
              text: "Oops! An error.",
              size: Sizing.font(40),
              weight: FontWeight.w700,
              color: Theme.of(context).primaryColor
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      )
                    ),
                    child: Obx(() => TextBuilder(
                      text: controller.state.message.value,
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor
                    ))
                  ),
                  Spacing.vertical(30),
                  TextBuilder(text: "Quick actions", color: Theme.of(context).primaryColor),
                  ...buttons.map((button) => SmartButton(
                    tab: button,
                    backgroundColor: Theme.of(context).splashColor,
                    onTap: () {
                      if(button.index.equals(1)) {
                        RouteNavigator.mail(button.path);
                      } else {
                        RouteNavigator.openLink(url: button.path);
                      }
                    },
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  Assets.logoInfo,
                  width: 150,
                  color: Theme.of(context).primaryColor
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}