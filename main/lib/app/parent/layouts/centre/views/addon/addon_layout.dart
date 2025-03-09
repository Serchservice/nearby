import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'tabs/other_addon_tab.dart';
import 'tabs/user_addon_tab.dart';

class AddonLayout extends GetView<AddonController> {
  static String get route => "/account/addons";

  const AddonLayout({super.key});

  static void to() => Navigate.to(route);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: LayoutWrapper(
        layoutKey: Key(route),
        appbar: AppBar(
          title: TextBuilder(
            text: "Addons",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(22),
            weight: FontWeight.bold,
          ),
          bottom: TabBar.secondary(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColorLight,
            unselectedLabelColor: CommonColors.instance.hint,
            dividerColor: Colors.transparent,
            onTap: controller.updateCurrent,
            tabs: controller.tabs.map((tab) => Tab(text: tab.header)).toList()
          ),
          actions: [
            Obx(() => InfoButton(
              defaultIcon: Icons.refresh_rounded,
              tip: "Refresh",
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              backgroundColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(43)),
              defaultIconColor: CommonColors.instance.bluish,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: WidgetStatePropertyAll(Size(30, 30)),
              onPressed: controller.state.current.value.equals(0) ? controller.fetchUserAddons : controller.fetchOtherAddons,
            )),
            Spacing.horizontal(10)
          ],
        ),
        child: TabBarView(
          children: [
            UserAddonTab(controller: controller),
            OtherAddonTab(controller: controller),
          ]
        ),
      ),
    );
  }
}