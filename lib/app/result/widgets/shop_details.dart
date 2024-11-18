import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class ShopDetails extends StatelessWidget {
  final SearchShopResponse shop;
  final ResultController controller;

  const ShopDetails({super.key, required this.shop, required this.controller});

  static void open(SearchShopResponse shop, ResultController controller) {
    Navigate.bottomSheet(
      sheet: ShopDetails(shop: shop, controller: controller),
      route: "/shop?view=${shop.hashCode}",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      height: MediaQuery.sizeOf(context).height,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 250,
              child: Image(
                image: AssetUtility.image(shop.shop.logo),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                fit: BoxFit.cover,
                errorBuilder: (context, obj, trace) {
                  return Image.asset(
                    Database.preference.isDarkTheme ? Assets.commonDriveWhite : Assets.commonDriveBlack,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SText(
                    text: shop.shop.name,
                    size: Sizing.font(18),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    flow: TextOverflow.ellipsis
                  ),
                  SText(
                    text: "Distance: ${shop.distanceInKm}",
                    size: Sizing.font(12),
                    color: Theme.of(context).primaryColorLight
                  ),
                ],
              ),
            ),
            Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: "Open for business",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  SText(
                    text: shop.shop.open ? "YES" : "NO",
                    size: Sizing.font(12),
                    color: shop.shop.open ? CommonColors.success : CommonColors.error,
                  ),
                ],
              ),
            ),
            Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: "Provider",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  SText(
                    text: shop.isGoogle ? "Google" : "Serchservice",
                    size: Sizing.font(14),
                    color: CommonColors.success,
                  ),
                ],
              ),
            ),
            Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            if(!shop.isGoogle) ...[
              Container(
                padding: EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CommonColors.success,)
                ),
                child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success,),
              ),
              Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Wrap(
                    runSpacing: 20,
                    children: [
                      ButtonView(body: shop.shop.address, icon: Icons.location_on_sharp),
                      ButtonView(body: shop.shop.phone, icon: Icons.call),
                      ButtonView(body: shop.shop.status, icon: Icons.data_exploration_rounded),
                      ButtonView(body: controller.state.search.value.category.title, icon: Icons.category)
                    ].map((view) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(view.icon, color: Theme.of(context).primaryColorLight),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SText(
                              text: CommonUtility.capitalizeWords(view.body.replaceAll("_", " ")),
                              size: Sizing.font(14),
                              color: view.body.toLowerCase() == "open" ? CommonColors.success : Theme.of(context).primaryColor
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            if(shop.shop.services.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
              Divider(color: CommonUtility.lightenColor(Theme.of(context).scaffoldBackgroundColor, 4)),
            ],
            MapView(
              origin: controller.state.search.value.pickup,
              destination: Address(latitude: shop.shop.latitude, longitude: shop.shop.longitude, place: shop.shop.address),
              distance: shop.distanceInKm,
              isTop: false,
              height: 200,
            )
          ],
        ),
      )
    );
  }
}
