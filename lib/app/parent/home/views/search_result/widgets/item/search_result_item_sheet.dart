import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class SearchResultItemSheet extends StatelessWidget {
  final String category;
  final Address pickup;
  final SearchShopResponse shop;
  final bool isBest;

  const SearchResultItemSheet({
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
      sheet: SearchResultItemSheet(category: category, pickup: pickup, shop: shop, isBest: isBest),
      route: "/home/result/${shop.shop.id}",
      isScrollable: true
    );
  }

  List<ButtonView> getOptions() => [
    ButtonView(header: "Details", index: 0, icon: CupertinoIcons.profile_circled),
    ButtonView(header: "Directions", index: 1, icon: Icons.directions),
    ButtonView(header: "Uber ride", index: 2, icon: Icons.arrow_forward_sharp),
    if(shop.shop.phone.isNotEmpty) ... [
      ButtonView(header: "Call", index: 3, icon: CupertinoIcons.phone_circle_fill),
    ],
    if(shop.isGoogle) ...[
      ButtonView(header: "More", index: 4, icon: CupertinoIcons.viewfinder_circle_fill),
    ]
  ];

  void onClick(ButtonView view) {
    if(view.index == 0) {
      ShopResultLayout.open(shop: shop, category: category, pickup: pickup);
    } else if(view.index == 1) {
      NavigationSheet.open(shop);
    } else if(view.index == 2) {
      RouteNavigator.openLink(url: "uber://riderequest?pickup"
          "[latitude]=${pickup.latitude}"
          "&pickup[longitude]=${pickup.longitude}"
          "&pickup[nickname]=${pickup.country}"
          "&pickup[formatted_address]=${pickup.place}"
          "&dropoff[latitude]=${shop.shop.latitude}"
          "&dropoff[longitude]=${shop.shop.longitude}"
          "&dropoff[nickname]=${shop.shop.address}"
          "&dropoff[formatted_address]=${shop.shop.address}"
      );
    } else if(view.index == 3) {
      RouteNavigator.callNumber(shop.shop.phone);
    } else {
      RouteNavigator.openLink(url: shop.shop.link);
    }
  }

  String get name => shop.shop.name;

  @override
  Widget build(BuildContext context) {
    String name = shop.shop.name;

    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(10),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getOptions().map((option) {
                    return SearchResultItemButton(option: option, onTap: () => onClick(option));
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(12),
              color: CommonUtility.lightenColor(CommonColors.allday, 45),
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
                            SText(
                              text: CommonUtility.capitalizeWords(name),
                              size: Sizing.font(14),
                              color: CommonColors.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                            SText(
                              text: category,
                              size: Sizing.font(12),
                              color: CommonColors.lightTheme,
                              flow: TextOverflow.ellipsis,
                            ),
                            SText(
                              text: shop.distanceInKm,
                              size: Sizing.font(12),
                              color: CommonColors.lightTheme,
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
          border: Border.all(color: CommonColors.success)
        ),
        child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success),
      );
    }

    return Container();
  }
}