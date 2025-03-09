import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

import '../widgets/summary_item.dart';

class ShopResultLayout extends StatelessWidget {
  final SearchShopResponse shop;
  final Address pickup;
  final String category;

  const ShopResultLayout({super.key, required this.shop, required this.pickup, required this.category});

  static void open({required SearchShopResponse shop, required Address pickup, required String category}) {
    Navigate.bottomSheet(
      sheet: ShopResultLayout(shop: shop, pickup: pickup, category: category),
      route: Navigate.appendRoute("/details"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryColor;
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = CommonColors.instance.hint;

    return ModalBottomSheet(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: GetBuilder<ShopResultController>(
        init: ShopResultController(shop: shop, pickup: pickup, category: category),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    MapView(
                      origin: pickup,
                      destination: controller.destination,
                      distance: shop.distanceInKm,
                      isTop: false,
                      height: 300,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: bgColor,
                          child: InkWell(
                            onTap: () => Navigate.close(),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.close, color: textColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildRecommended(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar.medium(avatar: shop.shop.image),
                          Expanded(
                            child: Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextBuilder(
                                        text: shop.shop.name.capitalizeEach,
                                        size: Sizing.space(14),
                                        weight: FontWeight.w600,
                                        color: textColor
                                      ),
                                      TextBuilder(text: category, size: Sizing.space(12), color: hintColor),
                                    ],
                                  ),
                                ),
                                RatingIcon(rating: shop.shop.rating, color: textColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: textColor),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(CupertinoIcons.circle_grid_hex_fill, color: bgColor),
                            ),
                          ),
                          Container(width: 2, height: 30, color: hintColor),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 60),
                              child: ListView.separated(
                                itemCount: controller.navigation.options.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 4);
                                },
                                itemBuilder: (context, index) {
                                  ButtonView view = controller.navigation.options[index];

                                  return InfoButton(
                                    tip: view.header,
                                    defaultIcon: view.icon,
                                    backgroundColor: WidgetStateProperty.resolveWith((state) => hintColor.lighten(35)),
                                    defaultIconColor: CommonColors.instance.darkTheme,
                                    onPressed: () => controller.navigation.onClick(view)
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: hintColor, width: 1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBuilder(
                                    text: "More details on this ${category.toLowerCase()}",
                                    color: textColor,
                                    size: Sizing.font(16),
                                    weight: FontWeight.bold
                                  ),
                                  Spacing.vertical(5),
                                  SummaryItem(title: "Provider", value: shop.isGoogle ? "Google" : "Serchservice"),
                                  SummaryItem(title: "Open for business", value: shop.shop.open ? "YES" : "NO"),
                                ]
                              )
                            ),
                            Divider(color: textColor),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                spacing: 12,
                                children: controller.details.map((item) {
                                  return Row(
                                    spacing: 12,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(item.icon, color: textColor),
                                      Expanded(
                                        child: TextBuilder(
                                          text: item.body.replaceAll("_", " ").capitalizeEach,
                                          size: Sizing.font(14),
                                          color: item.body.equalsIgnoreCase("open") ? CommonColors.instance.success : textColor
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      if(shop.shop.services.isNotEmpty) ...[
                        SizedBox(height: 10),
                        TextBuilder.center(
                          text: '${shop.shop.name} is very good with these skills:',
                          color: textColor,
                          size: 14
                        ),
                        Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          runSpacing: 5,
                          children: shop.shop.services.map((service) => Container(
                            padding: EdgeInsets.all(Sizing.space(6)),
                            decoration: BoxDecoration(
                              color: textColor,
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(CupertinoIcons.gift_fill, color: bgColor, size: 16),
                                TextBuilder(text: service.service, color: bgColor, size: 11, autoSize: false),
                              ],
                            ),
                          )).toList(),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildRecommended(BuildContext context) {
    if(!shop.isGoogle) {
      return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.only(left: 6, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CommonColors.instance.success)
        ),
        child: TextBuilder(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.instance.success),
      );
    }

    return Container();
  }
}