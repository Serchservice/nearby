import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class ShopResultLayout extends StatelessWidget {
  final SearchShopResponse shop;
  final Address pickup;
  final String category;

  const ShopResultLayout({super.key, required this.shop, required this.pickup, required this.category});

  static void open({required SearchShopResponse shop, required Address pickup, required String category}) {
    Navigate.bottomSheet(
      sheet: ShopResultLayout(shop: shop, pickup: pickup, category: category),
      route: "/shop/${shop.shop.id}",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryColor;
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = CommonColors.hint;

    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      safeArea: true,
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
                            onTap: () => Navigate.back(),
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
                                      SText(
                                        text: CommonUtility.capitalizeWords(shop.shop.name),
                                        size: Sizing.space(14),
                                        weight: FontWeight.w600,
                                        color: textColor
                                      ),
                                      SText(text: category, size: Sizing.space(12), color: hintColor),
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
                                itemCount: controller.buttons.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 4);
                                },
                                itemBuilder: (context, index) {
                                  ButtonView view = controller.buttons[index];

                                  return CircledButton(
                                    title: view.header,
                                    icon: view.icon,
                                    backgroundColor: CommonUtility.lightenColor(hintColor, 35),
                                    iconColor: CommonColors.darkTheme,
                                    onClick: () => controller.onClick(view)
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
                                  SText(
                                    text: "More details on this ${category.toLowerCase()}",
                                    color: textColor,
                                    size: Sizing.font(16),
                                    weight: FontWeight.bold
                                  ),
                                  const SizedBox(height: 5),
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
                                        child: SText(
                                          text: CommonUtility.capitalizeWords(item.body.replaceAll("_", " ")),
                                          size: Sizing.font(14),
                                          color: item.body.toLowerCase() == "open" ? CommonColors.success : textColor
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
                        SText.center(
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
                                SText(text: service.service, color: bgColor, size: 11, autoSize: false),
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
          border: Border.all(color: CommonColors.success)
        ),
        child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success),
      );
    }

    return Container();
  }
}