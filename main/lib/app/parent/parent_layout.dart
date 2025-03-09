import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class ParentLayout extends GetResponsiveView {
  static String get route => "/";

  ParentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil responsive = ResponsiveUtil(context);

    return GetX<ParentController>(
      builder: (controller) {
        int current = controller.state.routeIndex.value;
        bool isLoggedIn = controller.state.isAuthenticated.value;

        List<DynamicIconButtonView> tabs = [
          DynamicIconButtonView(
            icon: Icons.attractions_outlined,
            active: Icons.attractions_rounded,
            title: "Activities",
            path: "",
            index: 1,
          ),
          DynamicIconButtonView(
            icon: Icons.grid_view_outlined,
            active: Icons.grid_view_rounded,
            title: "Services",
            path: "",
            index: 2,
          ),
          DynamicIconButtonView(
            title: "BCaps",
            path: Assets.logoFavicon,
            index: 3
          ),
          if(isLoggedIn.isFalse) ...[
            DynamicIconButtonView(
              icon: Icons.settings_outlined,
              active: Icons.settings_rounded,
              title: "Settings",
              path: "",
              index: 4,
            )
          ],
          if(isLoggedIn) ...[
            DynamicIconButtonView(
              title: controller.initials,
              path: controller.avatar,
              index: 5
            ),
          ],
        ];

        Widget child = PageView(
          controller: controller.pageController,
          onPageChanged: controller.changeRoute,
          children: [
            ActivityLayout(),
            ServicesLayout(),
            BCapsLayout(),
            if(isLoggedIn.isFalse) ...[
              SettingsLayout()
            ] else ...[
              CentreLayout()
            ],
          ],
        );

        if(responsive.isDesktop) {
          return LayoutWrapper(
            theme: SettingsController.data.state.theme.value,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            barColor: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: current,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  indicatorShape: CircleBorder(),
                  onDestinationSelected: controller.selectRoute,
                  indicatorColor: CommonColors.instance.bluish.lighten(30),
                  elevation: 6,
                  groupAlignment: -0.9,
                  destinations: tabs.map((DynamicIconButtonView tab) => NavigationRailDestination(
                    icon: _buildIcon(tab, context),
                    selectedIcon: _buildActiveIcon(tab, context),
                    label: TextBuilder(
                      text: tab.title,
                      size: 12,
                      color: Theme.of(context).primaryColor
                    )
                  )).toList(),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(Assets.logoAppIcon, width: 45)
                  ),
                ),
                VerticalDivider(thickness: 1, width: 1, color: CommonColors.instance.color),
                Expanded(child: child)
              ],
            )
          );
        } else {
          return LayoutWrapper(
            theme: SettingsController.data.state.theme.value,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            barColor: Theme.of(context).scaffoldBackgroundColor,
            bottomNavbar: NavigationBar(
              selectedIndex: current,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              indicatorShape: CircleBorder(),
              onDestinationSelected: controller.selectRoute,
              indicatorColor: CommonColors.instance.bluish.lighten(30),
              height: 60,
              elevation: 6,
              shadowColor: CommonColors.instance.bluish.lighten(50),
              destinations: tabs.map((DynamicIconButtonView tab) => NavigationDestination(
                icon: _buildIcon(tab, context),
                selectedIcon: _buildActiveIcon(tab, context),
                label: tab.title
              )).toList()
            ),
            child: child
          );
        }
      }
    );
  }

  Widget _buildIcon(DynamicIconButtonView tab, BuildContext context) {
    if(tab.path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image(
          image: AssetUtility.image(tab.path),
          width: 26,
          height: 26,
          fit: tab.index.equals(5) ? BoxFit.cover : null,
        ),
      );
    } else {
      return Icon(tab.icon, color: CommonColors.instance.bluish.lighten(20));
    }
  }

  Widget _buildActiveIcon(DynamicIconButtonView tab, BuildContext context) {
    if(tab.path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image(
          image: AssetUtility.image(tab.path),
          width: 26,
          height: 26,
          fit: tab.index.equals(5) ? BoxFit.cover : null,
        ),
      );
    } else {
      return Icon(tab.active, color: CommonColors.instance.bluish);
    }
  }
}
