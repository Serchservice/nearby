import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsLayout extends GetResponsiveView<SettingsController> {
  SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Settings"),
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Settings",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsThemeSection(controller: controller),
                    SettingsInformationSection(controller: controller),
                    SettingsHelpAndSupportSection(controller: controller),
                    SettingsMoreSection(controller: controller),
                    SettingsAppDownloadSection(controller: controller),
                    Center(
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => SText(
                            text: "v${controller.state.appVersion.value}+${controller.state.appBuildNumber.value}",
                            color: Theme.of(context).primaryColorDark,
                            size: Sizing.font(14),
                          )),
                          Image.asset(
                            Assets.logoInfo,
                            width: 90,
                            height: 50,
                            fit: BoxFit.contain,
                            color: Theme.of(context).primaryColor
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BannerAdWidget(),
        ],
      ),
    );
  }
}