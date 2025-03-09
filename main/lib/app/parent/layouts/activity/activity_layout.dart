import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'views/nearby_place_search/nearby_place_search.dart';
import 'widgets/activity_creating_box.dart';
import 'widgets/activity_search_field.dart';

class ActivityLayout extends GetView<ActivityController> {
  const ActivityLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Activity"),
      floatConfig: FloatingConfig(right: 10, bottom: 10),
      floater: Obx(() {
        bool hideSearch = controller.state.hideSearchButton.value;
        Color buttonColor = CommonColors.instance.bluish;
        Color buttonIconColor = CommonColors.instance.bluish.lighten(44);

        return Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(controller.state.search.value.isNotEmpty) ...[
              InfoButton(
                icon: Icon(Icons.clear_rounded, color: buttonColor),
                backgroundColor: WidgetStateProperty.all(buttonIconColor),
                onPressed: controller.onSearchCleared,
              )
            ],
            InfoButton(
              icon: Icon(Icons.refresh_rounded, color: buttonColor),
              backgroundColor: WidgetStateProperty.all(buttonIconColor),
              onPressed: controller.pagedController.refresh,
            ),
            ActivitySearchField(
              searchController: controller.searchController,
              hideSearchButton: hideSearch,
              onClosed: controller.onSearchPressed,
              animation: controller.animation,
              buttonColor: buttonColor,
              buttonIconColor: buttonIconColor
            ),
          ],
        );
      }),
      child: Obx(() {
        List<GoCreateUpload> uploads = controller.state.uploads.value;
        bool showTabSelector = controller.state.search.value.isEmpty || controller.hasFilter.isFalse;
        int currentTab = controller.state.currentTab.value;

        return Column(
          spacing: 5,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoLink(),
                      Spacing.flexible(),
                      ...controller.actions.map((item) {
                        return InfoButton(
                          defaultIcon: item.icon,
                          tip: item.header,
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(43)),
                          defaultIconColor: CommonColors.instance.bluish,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: WidgetStatePropertyAll(Size(30, 30)),
                          onPressed: item.onClick.isNotNull ? item.onClick! : () {},
                        );
                      }),
                    ],
                  ),
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    onPressed: () => NearbyPlaceSearch.open(
                      useCurrentLocation: ParentController.data.state.useCurrentLocation.value,
                      currentLocation: ParentController.data.state.currentLocation.value
                    ),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        return CommonColors.instance.bluish.lighten(48);
                      }),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.all(Size(double.infinity, 40)),
                      backgroundColor: WidgetStateProperty.all(CommonColors.instance.bluish.lighten(30)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 12))
                    ),
                    icon: Icon(Icons.arrow_forward_rounded, size: 20, color: CommonColors.instance.bluish),
                    label: TextBuilder(
                      text: "Find nearby places around you here!",
                      weight: FontWeight.bold,
                      color: CommonColors.instance.bluish
                    )
                  ),
                  if(uploads.isNotEmpty) ...[
                    ActivityCreatingBox(
                      uploads: uploads,
                      onRetried: controller.onGoCreateUploadRetry,
                      onDismissed: controller.onGoCreateUploadDismiss
                    ),
                  ],
                  if(showTabSelector) ...[
                    SearchFilter.short(
                      list: controller.tabs,
                      selectedIndex: controller.state.currentTab.value,
                      onSelect: (ButtonView tab) {
                        if(tab.onClick.isNotNull) {
                          tab.onClick!();
                        }
                      }
                    )
                  ]
                ],
              )
            ),
            if(currentTab.equals(0)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.activityController.refresh(),
                  child: GoActivityListing(
                    id: "activity",
                    controller: controller.activityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ] else if(currentTab.equals(1)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.upcomingActivityController.refresh(),
                  child: GoActivityListing(
                    id: "upcoming-activity",
                    controller: controller.upcomingActivityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ] else if(currentTab.equals(2)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.ongoingActivityController.refresh(),
                  child: GoActivityListing(
                    id: "ongoing-activity",
                    controller: controller.ongoingActivityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ]
          ],
        );
      }),
    );
  }
}