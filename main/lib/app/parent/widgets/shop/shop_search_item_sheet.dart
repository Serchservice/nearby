import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class ShopSearchItemSheet extends StatelessWidget {
  final String category;
  final Address pickup;
  final SearchShopResponse shop;
  final bool isBest;

  const ShopSearchItemSheet({
    super.key,
    required this.category,
    required this.pickup,
    required this.shop,
    this.isBest = false
  });

  static void open({
    String category = "",
    required Address pickup,
    required SearchShopResponse shop,
    bool isBest = false
  }) {
    Navigate.bottomSheet(
      sheet: ShopSearchItemSheet(category: category, pickup: pickup, shop: shop, isBest: isBest),
      route: Navigate.appendRoute("/${shop.shop.id}"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = shop.shop.name;

    EasyNavigation<SearchShopResponse> navigation = EasyNavigation<SearchShopResponse>(
      response: shop,
      showDetails: true,
      pickupLocation: pickup
    );

    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: const EdgeInsets.all(10),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(Sizing.space(2)),
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            Spacing.vertical(20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: navigation.options.map((option) {
                    return SizedButton(option: option, onTap: () => navigation.onClick(option));
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(12),
              color: CommonColors.instance.allDay.lighten(45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBuilder(
                              text: name.capitalizeEach,
                              size: Sizing.font(14),
                              color: CommonColors.instance.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                            TextBuilder(
                              text: category,
                              size: Sizing.font(12),
                              color: CommonColors.instance.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                            TextBuilder(
                              text: shop.distanceInKm,
                              size: Sizing.font(12),
                              color: CommonColors.instance.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Avatar.medium(avatar: shop.shop.image)
                    ],
                  ),
                  _buildRecommended(context)
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildRecommended(BuildContext context) {
    if(!shop.isGoogle) {
      return Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(top: 10),
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