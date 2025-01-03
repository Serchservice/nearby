import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class ShopResultController extends GetxController {
  final SearchShopResponse shop;
  final Address pickup;
  final String category;

  ShopResultController({required this.shop, required this.pickup, required this.category});
  final state = ShopResultState();

  List<ButtonView> get buttons => [
    ButtonView(header: "Directions", index: 1, icon: Icons.directions),
    ButtonView(header: "Ride with uber", index: 2, icon: Icons.arrow_forward_sharp),
    if(shop.shop.phone.isNotEmpty) ... [
      ButtonView(header: "Call ${shop.shop.name}", index: 3, icon: Icons.call),
    ],
    if(shop.isGoogle) ...[
      ButtonView(header: "More about this business", index: 4, icon: CupertinoIcons.viewfinder_circle_fill),
    ]
  ];

  void onClick(ButtonView view) {
    if(view.index == 1) {
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

  Address get destination => Address(
    latitude: shop.shop.latitude,
    longitude: shop.shop.longitude,
    place: shop.shop.address
  );

  List<ButtonView> get details => [
    ButtonView(body: shop.shop.address, icon: CupertinoIcons.location_north_fill),
    if(shop.shop.phone.isNotEmpty) ...[
      ButtonView(body: shop.shop.phone, icon: CupertinoIcons.phone_circle_fill),
    ],
    ButtonView(body: shop.shop.status, icon: CupertinoIcons.square_stack_fill),
  ];
}