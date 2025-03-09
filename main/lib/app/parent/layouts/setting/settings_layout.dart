import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class SettingsLayout extends GetResponsiveView<SettingsController> {
  SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Settings"),
      child: BannerAdLayout(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBuilder(
                text: "Settings",
                size: Sizing.font(30),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsThemeSection(controller: controller),
                      SettingsInformationSection(controller: controller),
                      SettingsHelpAndSupportSection(controller: controller),
                      AppExplore(
                        app: SmartApp.nearby,
                        isWeb: PlatformEngine.instance.isWeb,
                        onAppClicked: controller.handleMore,
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Image.asset(
                          Assets.logoInfo,
                          width: 90,
                          height: 20,
                          fit: BoxFit.contain,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                      Obx(() => SocialMediaConnect(
                        isCentered: true,
                        title: "v${controller.state.appVersion.value}+${controller.state.appBuildNumber.value}",
                        padding: EdgeInsets.zero,
                        onSocialClicked: (String url) => RouteNavigator.openLink(url: url)
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}