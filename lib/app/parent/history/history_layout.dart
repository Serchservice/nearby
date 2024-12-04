import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryLayout extends GetResponsiveView<ParentController> {
  HistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      layoutKey: Key("Activity"),
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Activity",
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
                Icon(Icons.info_outlined, color: CommonColors.hint),
                const SizedBox(width: 4),
                Expanded(
                  child: SText(
                    text: "In-memory storage, uninstalling removes any stored data.",
                    size: Sizing.font(12),
                    color: Theme.of(context).primaryColor,
                    flow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: buildView(context),
            ),
          ),
          BannerAdWidget(),
        ],
      ),
    );
  }

  Widget buildView(BuildContext context) {
    return Obx(() {
      if(controller.state.shopHistory.isNotEmpty) {
        final groupedShops = controller.groupedShops();

        final List<Widget> items = [];
        groupedShops.forEach((title, shops) {
          // Add a header for each category
          items.add(SText(
            text: CommonUtility.capitalizeWords(title),
            size: Sizing.font(14),
            color: CommonColors.hint
          ));

          // Add each shop under the category
          items.addAll(shops.map((shop) {
            return ShopView(
              shop: shop,
              pickup: controller.state.selectedAddress.value,
              title: CommonUtility.capitalizeWords(shop.shop.category),
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
              const SizedBox(height: 10),
              SText(
                text: "Your shop visits will appear here.",
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
              ),
            ],
          )
        );
      }
    });
  }
}
