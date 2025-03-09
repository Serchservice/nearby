import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx, GetView;
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class BCapsLayout extends GetView<BCapController> {
  const BCapsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("BCaps"),
      child: Obx(() {
        bool isAuth = ParentController.data.state.isAuthenticated.value;

        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextBuilder(
                    text: "BCaps",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(22),
                    weight: FontWeight.bold,
                  ),
                  Spacing.flexible(),
                  ...controller.actions(isAuth).map((item) {
                    return InfoButton(
                      defaultIcon: item.icon,
                      tip: item.header,
                      padding: WidgetStateProperty.resolveWith((state) => EdgeInsets.zero),
                      backgroundColor: WidgetStateProperty.resolveWith((state) {
                        return CommonColors.instance.bluish.lighten(43);
                      }),
                      defaultIconColor: CommonColors.instance.bluish,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.resolveWith((state) => Size(30, 30)),
                      onPressed: item.onClick.isNotNull ? item.onClick! : () {},
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: PullToRefresh(
                onRefreshed: () => controller.bcapController.refresh(),
                child: GoBCapListing(
                  id: "bcap",
                  controller: controller.bcapController,
                  showAds: ParentController.data.state.showAds.value
                ),
              )
            )
          ],
        );
      }),
    );
  }
}