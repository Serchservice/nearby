import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentLayout extends GetResponsiveView {
  static String get route => "/";

  ParentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<DynamicIconButtonView> tabs = [
      DynamicIconButtonView(
        icon: Icons.home_outlined,
        active: Icons.home_rounded,
        title: "Home",
        index: 0
      ),
      DynamicIconButtonView(
        icon: Icons.history_outlined,
        active: Icons.history_rounded,
        title: "Activity",
        index: 1,
      ),
      DynamicIconButtonView(
        icon: Icons.settings_outlined,
        active: Icons.settings_rounded,
        title: "Settings",
        index: 2
      ),
    ];

    return GetX<ParentController>(
      builder: (controller) {
        int current = controller.state.routeIndex.value;

        return MainLayout(
          theme: controller.state.theme.value,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            barColor: current != 0
              ? Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor
              : null,
          bottomNavbar: NavigationBar(
            selectedIndex: current,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            indicatorShape: CircleBorder(),
            onDestinationSelected: (index) => controller.selectRoute(index),
            indicatorColor: Theme.of(context).primaryColorDark,
            height: 60,
            elevation: 6,
            shadowColor: Theme.of(context).primaryColorDark,
            destinations: tabs.map((tab) => NavigationDestination(
              icon: Icon(tab.icon, color: Theme.of(context).primaryColor),
              selectedIcon: Icon(tab.active, color: Theme.of(context).scaffoldBackgroundColor),
              label: tab.title
            )).toList()
          ),
          child: IndexedStack(
            index: current,
            children: [
              HomeLayout(),
              HistoryLayout(),
              SettingsLayout(),
            ],
          )
        );
      }
    );
  }
}
