import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'controllers/go_interest_controller.dart';

class GoInterestLayout extends GetView<GoInterestController> {
  static String get route => "/account/go-interests";

  const GoInterestLayout({super.key});

  static void to() => Navigate.to(route);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: LayoutWrapper(
        layoutKey: Key("Your Interests"),
        appbar: AppBar(
          title: TextBuilder(
            text: "Your Interests",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(22),
            weight: FontWeight.bold,
          ),
          bottom: TabBar.secondary(
            controller: controller.tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColorLight,
            unselectedLabelColor: CommonColors.instance.hint,
            dividerColor: Colors.transparent,
            onTap: controller.updateCurrent,
            tabs: controller.tabs.map((tab) => Tab(text: tab.header)).toList()
          ),
          actions: [
            Obx(() {
              Color color = controller.isAdd ? CommonColors.instance.bluish : CommonColors.instance.error;

              if(controller.showButton) {
                return TextButton.icon(
                  onPressed: controller.process,
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      return color.lighten(48);
                    }),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
                  ),
                  icon: controller.state.isSaving.value
                    ? Loading.circular(color: color)
                    : Icon(controller.isAdd ? Icons.upload : Icons.delete, color: color),
                  label: Row(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextBuilder(
                        text: controller.buttonText,
                        weight: FontWeight.bold,
                        color: color
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: TextBuilder(
                          text: controller.count.toString(),
                          size: Sizing.font(12),
                          color: CommonColors.instance.lightTheme,
                          weight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            Spacing.horizontal(6),
          ],
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: [
            _UserInterests(controller: controller),
            _GoInterests(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _UserInterests extends StatelessWidget {
  final GoInterestController controller;

  const _UserInterests({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BannerAdLayout(
      expandChild: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          List<GoInterest> selected = controller.state.removal.value;

          return InterestSelector(
            isLoading: controller.state.isFetchingCategories.value,
            categories: controller.state.goCategories.value,
            selected: selected,
            isMultipleAllowed: true,
            isScrollable: true,
            goInterestListener: (interests) {
              controller.state.removal.value = interests;
            },
            buttonText: "Remove",
            buttonColor: CommonColors.instance.error,
          );
        }),
      ),
    );
  }
}

class _GoInterests extends StatelessWidget {
  final GoInterestController controller;

  const _GoInterests({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BannerAdLayout(
      expandChild: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              List<GoInterest> selected = controller.state.selected.value;

              return InterestSelector(
                isLoading: controller.state.isFetchingCategories.value,
                isMultipleAllowed: true,
                categories: controller.state.categories.value,
                selected: selected,
                isScrollable: true,
                goInterestListener: (interests) {
                  controller.state.selected.value = interests;
                }
              );
            }),
          ],
        ),
      ),
    );
  }
}