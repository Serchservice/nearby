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
      ButtonView(header: "View directions on map", index: 1, icon: Icons.arrow_forward_sharp),
      ButtonView(header: "Drive with uber", index: 2, icon: Icons.arrow_forward_sharp),
      ButtonView(header: "Call ${shop.shop.name}", index: 3, icon: Icons.call),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CommonColors.shimmer)
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
                  ShopDetails.open(shop);
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
                } else {
                  RouteNavigator.callNumber(shop.shop.phone);
                }
              }
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                  child: _buildContent(
                    context: context,
                    image: shop.shop.logo,
                    name: shop.shop.name,
                    distance: shop.distanceInKm,
                    rating: shop.shop.rating,
                    category: shop.shop.category
                  ),
                ),
                MapView(
                  origin: controller.state.search.value.pickup,
                  destination: Address(latitude: shop.shop.latitude, longitude: shop.shop.longitude, place: shop.shop.address),
                  distance: shop.distanceInKm,
                  isTop: false,
                  height: 200,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required String image,
    required String name,
    required String distance,
    required double rating,
    required String category
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar.small(avatar: image),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: name,
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  SText(text: distance, size: Sizing.font(12), color: Theme.of(context).primaryColor),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: category,
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColorLight,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  RatingIcon(rating: rating, iconSize: 14, textSize: 10),
                ],
              ),
            ],
          )
        ),
      ],
    );
  }
}