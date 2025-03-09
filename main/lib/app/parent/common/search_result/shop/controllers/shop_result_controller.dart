import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

import 'shop_result_state.dart';

class ShopResultController extends GetxController {
  final SearchShopResponse shop;
  final Address pickup;
  final String category;

  ShopResultController({required this.shop, required this.pickup, required this.category});
  final state = ShopResultState();

  EasyNavigation<SearchShopResponse> get navigation => EasyNavigation<SearchShopResponse>(
    response: shop,
    showDetails: false,
    pickupLocation: pickup
  );

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