import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsLayout extends GetResponsiveView<ParentController> {
  SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
      child: Obx(() {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        ButtonView(
                          header: "Update Log",
                          index: 1,
                          icon: Icons.update_rounded,
                          path: UpdateLayout.route
                        ),
                        ButtonView(
                          header: "Explore",
                          index: 2,
                          icon: Icons.view_compact_rounded,
                          path: ExploreLayout.route
                        ),
                        ButtonView(
                          header: "Rate app",
                          index: 3,
                          icon: Icons.star,
                          path: ""
                        )
                      ].map((view) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24)
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if(view.index == 3) {
                                    controller.appStoreReview();
                                  } else {
                                    Navigate.to(view.path);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(view.icon, color: Theme.of(context).primaryColor),
                                      const SizedBox(width: 10),
                                      SText(
                                        text: view.header,
                                        size: Sizing.font(14),
                                        color: Theme.of(context).primaryColor
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      AppThemeSection(),
                      const SizedBox(height: 10),
                      AppInformationSection(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SText(
                              text: "v${controller.state.appVersion.value}+${controller.state.appBuildNumber.value}",
                              color: Theme.of(context).primaryColorDark,
                              size: Sizing.font(14),
                            ),
                            Spacer(),
                            Wrap(
                              runAlignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              runSpacing: 5,
                              children: controller.connect.map((connect) {
                                return Tooltip(
                                  message: connect.header,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Material(
                                      color: Theme.of(context).appBarTheme.backgroundColor,
                                      child: InkWell(
                                        onTap: () {
                                          if(connect.index == 0) {
                                            RouteNavigator.mail(connect.path);
                                          } else if(connect.index == 1) {
                                            RouteNavigator.callNumber(connect.path);
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(Sizing.space(8)),
                                          child: Icon(
                                            connect.icon,
                                            color: Theme.of(context).primaryColor,
                                            size: Sizing.space(16),
                                          ),
                                        )
                                      )
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            controller.settingsBannerAdManager.banner(),
          ],
        );
      }),
    );
  }
}
