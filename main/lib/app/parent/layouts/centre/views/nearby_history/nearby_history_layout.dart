import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:smart/smart.dart';

import 'controllers/nearby_history_controller.dart';

class NearbyHistoryLayout extends GetResponsiveView<NearbyHistoryController> {
  static String get route => "/nearby/history";
  NearbyHistoryLayout({super.key});

  static void to() => Navigate.to(route);

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Nearby History"),
        appbar: AppBar(
          elevation: 0.5,
          title: TextBuilder(
            text: "Nearby History",
            size: Sizing.font(20),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
        ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Icon(Icons.info_outlined, color: CommonColors.instance.hint),
                Spacing.horizontal(4),
                Expanded(
                  child: TextBuilder(
                    text: "In-memory storage, uninstalling removes any stored data.",
                    size: Sizing.font(12),
                    color: Theme.of(context).primaryColor,
                    flow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
          BannerAdLayout(
            isExpanded: true,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Obx(() {
                if(controller.state.shopHistory.isNotEmpty) {
                  final groupedShops = controller.groupedShops();

                  final List<Widget> items = [];
                  groupedShops.forEach((title, shops) {
                    // Add a header for each category
                    items.add(TextBuilder(
                      text: title.capitalizeEach,
                      size: Sizing.font(14),
                      color: CommonColors.instance.hint
                    ));

                    // Add each shop under the category
                    items.addAll(shops.map((shop) {
                      return ShopSearchItem(
                        shop: shop,
                        pickup: Database.instance.address,
                        title:shop.shop.category.capitalizeEach,
                      );
                    }).toList());
                  });

                  return ListView.separated(
                    itemCount: items.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(6),
                    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return items[index]; // Render headers and items
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Icon(
                            Icons.insights_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 140,
                          ),
                        ),
                        Spacing.vertical(10),
                        TextBuilder(
                          text: "Your shop visits will appear here.",
                          size: Sizing.font(16),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    )
                  );
                }
              }),
            )
          ),
        ],
      ),
    );
  }
}