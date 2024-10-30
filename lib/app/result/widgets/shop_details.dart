import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class ShopDetails extends StatelessWidget {
  final SearchShopResponse shop;
  const ShopDetails({super.key, required this.shop});

  static void open(SearchShopResponse shop) {
    Navigate.bottomSheet(sheet: ShopDetails(shop: shop), route: "/shop?view=${shop.hashCode}");
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              Avatar.large(avatar: shop.shop.logo),
              const SizedBox(height: 10),
              SText(
                text: shop.shop.name,
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
                flow: TextOverflow.ellipsis
              ),
              SText(text: "Distance: ${shop.distanceInKm}", size: Sizing.font(12), color: Theme.of(context).primaryColor),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.all(12),
                        color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4),
                        child: SText(
                          text: "Address",
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColorLight,
                          flow: TextOverflow.ellipsis
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SText(
                          text: shop.shop.address,
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(shop.shop.services.isNotEmpty) ...[
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: EdgeInsets.all(12),
                          color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4),
                          child: SText(
                            text: "Services",
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColorLight,
                            flow: TextOverflow.ellipsis
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: shop.shop.services.map((service) {
                              return SText(
                                text: CommonUtility.capitalizeWords(service.service),
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      )
    );
  }
}
