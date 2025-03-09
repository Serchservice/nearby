import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetView, Obx;
import 'package:drive/library.dart';
import 'package:smart/smart.dart' show ButtonView, ColorExtensions, InfoButton,
  PullToRefresh, Sizing, TExtensions, TextBuilder;
import 'package:smart/ui.dart' show FloatingConfig;

import 'dialog/account_centre/account_centre.dart';
import 'dialog/settings/settings_sheet.dart';
import 'widgets/bcaps_creating_box.dart';

class CentreLayout extends GetView<CentreController> {
  const CentreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Centre"),
      floatConfig: FloatingConfig(right: 10, bottom: 10),
      floater: Obx(() => InfoButton(
        icon: Icon(Icons.refresh_rounded, color: CommonColors.instance.bluish),
        backgroundColor: WidgetStateProperty.all(CommonColors.instance.bluish.lighten(44)),
        onPressed: controller.pagedController.refresh,
      )),
      child: Obx(() {
        GoAccount account = controller.state.account.value;
        List<GoBCapCreateUpload> uploads = controller.state.uploads.value;

        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(radius: 25, avatar: ParentController.data.avatar),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: ParentController.data.name,
                          weight: FontWeight.bold,
                          flow: TextOverflow.ellipsis,
                          size: Sizing.font(16),
                          color: Theme.of(context).primaryColor
                        ),
                        TextBuilder(
                        text: "Joined on: ${account.joinedOn}",
                        color: Theme.of(context).primaryColorLight,
                        flow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InfoButton(
                        onPressed: SettingsSheet.open,
                        defaultIcon: Icons.settings_outlined,
                        defaultIconColor: Theme.of(context).primaryColor,
                      ),
                      InfoButton(
                        onPressed: AccountCentre.open,
                        defaultIcon: Icons.account_circle_rounded,
                        defaultIconColor: Theme.of(context).primaryColor,
                      ),
                    ]
                  )
                ],
              ),
            ),
            if(uploads.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: BCapsCreatingBox(
                  uploads: uploads,
                  onRetried: controller.onGoCreateUploadRetry,
                  onDismissed: controller.onGoCreateUploadDismiss
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: controller.tabs.asMap().entries.map((item) {
                  ButtonView view = item.value;
                  final bool isSelected = view.index.equals(controller.state.current.value);

                  final Color baseColor = CommonColors.instance.bluish;
                  final Color bgColor = isSelected ? baseColor.lighten(45) : baseColor.lighten(90);
                  final Color txtColor = isSelected ? baseColor : baseColor.lighten(30);

                  Widget child;
                  if(view.image.isNotEmpty) {
                    child = Image(image: AssetUtility.image(view.image), width: 26, height: 26);
                  } else {
                    child = Icon(view.icon, color: txtColor);
                  }

                  return Expanded(
                    child: Tooltip(
                      message: view.header,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Material(
                          color: bgColor,
                          child: InkWell(
                            onTap: () => controller.change(view.index),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: child,
                            ),
                          )
                        ),
                      ),
                    ),
                  );
                }).toList()
              ),
            ),
            if(controller.state.current.value.equals(0)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.activityController.refresh(),
                  child: GoActivityListing(
                    id: "centre-activity",
                    controller: controller.activityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ] else if(controller.state.current.value.equals(1)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.upcomingActivityController.refresh(),
                  child: GoActivityListing(
                    id: "centre-upcoming-activity",
                    controller: controller.upcomingActivityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ] else if(controller.state.current.value.equals(2)) ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.ongoingActivityController.refresh(),
                  child: GoActivityListing(
                    id: "centre-ongoing-activity",
                    controller: controller.ongoingActivityController,
                    showAds: ParentController.data.state.showAds.value
                  ),
                )
              )
            ] else ...[
              Expanded(
                child: PullToRefresh(
                  onRefreshed: () => controller.bcapController.refresh(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: GoBCapListing(
                      controller: controller.bcapController,
                      id: "centre-bcap",
                      useGrid: true,
                      showAds: ParentController.data.state.showAds.value
                    ),
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