import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final ResultController controller;
  final SearchShopResponse shop;

  const ResultView({super.key, required this.controller, required this.shop});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(header: "View shop details", index: 0, icon: Icons.details_rounded),
      ButtonView(header: "Directions", index: 1, icon: Icons.directions),
      ButtonView(header: "Ride with uber", index: 2, icon: Icons.arrow_forward_sharp),
      if(shop.shop.phone.isNotEmpty) ... [
        ButtonView(header: "Call ${shop.shop.name}", index: 3, icon: Icons.call),
      ],
      if(shop.isGoogle) ...[
        ButtonView(header: "More about this business", index: 4, icon: Icons.view_compact),
      ]
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor ?? CommonColors.shimmer)
      ),
      width: MediaQuery.sizeOf(context).width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => AppInformationSheet.open(
              options: options,
              onTap: (view) {
                if(view.index == 0) {
                  ShopDetails.open(shop, controller);
                } else if(view.index == 1) {
                  NavigationSheet.open(shop);
                } else if(view.index == 2) {
                  RouteNavigator.openLink(url: "uber://riderequest?pickup"
                      "[latitude]=${controller.state.search.value.pickup.latitude}"
                      "&pickup[longitude]=${controller.state.search.value.pickup.longitude}"
                      "&pickup[nickname]=${controller.state.search.value.pickup.country}"
                      "&pickup[formatted_address]=${controller.state.search.value.pickup.place}"
                      "&dropoff[latitude]=${shop.shop.latitude}"
                      "&dropoff[longitude]=${shop.shop.longitude}"
                      "&dropoff[nickname]=${shop.shop.address}"
                      "&dropoff[formatted_address]=${shop.shop.address}"
                  );
                } else if(view.index == 3) {
                  RouteNavigator.callNumber(shop.shop.phone);
                } else if(view.index == 4) {
                  RouteNavigator.openLink(url: shop.shop.category);
                }
              }
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                  child: _buildContent(context),
                ),
                if(!shop.isGoogle) ...[
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CommonColors.success,)
                    ),
                    child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success,),
                  ),
                  const SizedBox(height: 10)
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Avatar.medium(avatar: shop.shop.logo),
            Positioned(right: 0, top: 10, child: buildNotifier())
          ],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: shop.shop.name,
                size: Sizing.font(16),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: "${shop.distanceInKm} away",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  RatingIcon(rating: shop.shop.rating, iconSize: 22, textSize: 14),
                ],
              ),
            ],
          )
        ),
      ],
    );
  }

  Widget buildNotifier() {
    if(shop.shop.open) {
      return HeartBeating(
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: CommonColors.success,
            borderRadius: BorderRadius.circular(50)
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: CommonColors.yellow,
          borderRadius: BorderRadius.circular(50)
        ),
      );
    }
  }
}