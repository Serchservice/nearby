import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class GoActivityLayout extends GetView<GoActivityController> {
  static String get route => "/account/go-activity";

  const GoActivityLayout({super.key});

  static void to() => Navigate.to(route);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: LayoutWrapper(
        layoutKey: Key("Go Activities"),
        appbar: AppBar(
          title: TextBuilder(
            text: "Go Activities",
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
        ),
        child: TabBarView(
          children: [
            Obx(() => GoActivityListing(
              showAds: ParentController.data.state.showAds.value,
              controller: controller.attendingController,
              id: "go-attending-activity"
            )),
            Obx(() => GoActivityListing(
              showAds: ParentController.data.state.showAds.value,
              controller: controller.attendedController,
              id: "go-attended-activity"
            )),
          ],
        ),
      ),
    );
  }
}