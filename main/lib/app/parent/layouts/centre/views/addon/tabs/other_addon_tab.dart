import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';
import 'package:get/get.dart' show Obx;

import '../widgets/go_addon_item_sheet.dart';
import '../widgets/go_addon_item.dart';

class OtherAddonTab extends StatelessWidget {
  final AddonController controller;
  const OtherAddonTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BannerAdLayout(
      child: Obx(() {
        if(controller.state.isFetchingOthers.value) {
          return _Loading();
        } else if(controller.state.otherAddons.isEmpty) {
          return _Empty(onRefresh: controller.fetchOtherAddons);
        } else {
          return PullToRefresh(
            onRefreshed: controller.fetchOtherAddons,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: controller.state.otherAddons.length,
              separatorBuilder: (BuildContext context, int index) => Spacing.vertical(10),
              itemBuilder: (BuildContext context, int index) {
                GoAddon addon = controller.state.otherAddons[index];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => GoAddonItemSheet.open(addon),
                    child: GoAddonItem(addon: addon)
                  )
                );
              }
            ),
          );
        }
      })
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LoadingShimmer(
        isDarkMode: Database.instance.isDarkTheme,
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 6.listGenerator.map((int index) {
                    return Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: CommonColors.instance.shimmerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }).toList(),
                )
              ),
              ...6.listGenerator.map((int index) {
                return Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: CommonColors.instance.shimmerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              })
            ],
          )
        )
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onRefresh;

  const _Empty({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.extension_off_rounded,
                color: Theme.of(context).primaryColor,
                size: 100
              )
            ),
            TextBuilder.center(
              text: "No addons found",
              autoSize: false,
              color: Theme.of(context).primaryColor,
            ),
            TextButton(
              onPressed: onRefresh,
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return CommonColors.instance.bluish.lighten(48);
                }),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: "Refresh",
                weight: FontWeight.bold,
                color: CommonColors.instance.bluish
              )
            )
          ],
        )
      )
    );
  }
}