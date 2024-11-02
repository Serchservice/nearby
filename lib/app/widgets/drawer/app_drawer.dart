import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.sizeOf(context).width - 80,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: GetX<AppDrawerController>(
          init: AppDrawerController(),
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(carDriveReverseImage, width: 160),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                ButtonView(
                                  header: "Home",
                                  index: 0,
                                  icon: Icons.space_dashboard_rounded,
                                  path: HomeLayout.route
                                ),
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
                                return ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomLeft: Radius.circular(24)
                                  ),
                                  child: Material(
                                    color: isCurrentRoute(view.path) && view.path.isNotEmpty
                                      ? Theme.of(context).textSelectionTheme.selectionColor
                                      : Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        mainLayoutKey.currentState?.closeEndDrawer();

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
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AppDrawerThemeSection(controller: controller),
                          const SizedBox(height: 10),
                          AppDrawerInformationSection(controller: controller)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}