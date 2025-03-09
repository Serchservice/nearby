import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx;
import 'package:smart/smart.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: SettingsSheet(),
      route: Navigate.appendRoute("/settings"),
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsController controller = SettingsController.data;

    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.zero,
      height: MediaQuery.sizeOf(context).height / 1.5,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Database.instance.isLightTheme ? Brightness.dark : Brightness.light,
      ),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(PlatformEngine.instance.isWeb) ...[
            GoBack(onTap: () => Navigate.close(closeAll: false)),
          ] else ...[
            ModalBottomSheetIndicator(
              showButton: false,
              color: CommonColors.instance.darkTheme2,
              backgroundColor: CommonColors.instance.lightTheme2,
            )
          ],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextBuilder(
                      text: "Settings",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
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
      )
    );
  }
}