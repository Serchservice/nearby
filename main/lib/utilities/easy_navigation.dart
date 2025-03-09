import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class EasyNavigation<T> {
  final T response;
  final bool showDetails;
  final Address pickupLocation;
  final String category;

  EasyNavigation({
    required this.response,
    required this.showDetails,
    required this.pickupLocation,
    this.category = ""
  });

  Address currentLocation = Database.instance.address;
  final LocationService _locationService = LocationImplementation();

  void _initLocation() async {
    _locationService.getAddress(
      onSuccess: (address, position) {
        currentLocation = address;
      },
      onError: (error) {
        notify.warn(message: error);
      }
    );
  }

  List<ButtonView> get options {
    _initLocation();

    if(response.instanceOf<SearchShopResponse>()) {
      SearchShopResponse result = response as SearchShopResponse;

      return [
        if(showDetails) ...[
          ButtonView(header: "Details", index: 0, icon: CupertinoIcons.profile_circled),
        ],
        ButtonView(header: "Directions", index: 1, icon: Icons.directions),
        ButtonView(header: "Book a ride", index: 2, icon: Icons.arrow_forward_sharp),
        if(result.shop.phone.isNotEmpty) ...[
          ButtonView(header: "Call", index: 3, icon: CupertinoIcons.phone_circle_fill),
        ],
        if(result.isGoogle) ...[
          ButtonView(header: "More", index: 4, icon: CupertinoIcons.viewfinder_circle_fill),
        ]
      ];
    } else if(response.instanceOf<GoActivity>()) {
      GoActivity result = response as GoActivity;

      return [
        if(showDetails) ...[
          ButtonView(header: "Details", index: 0, icon: CupertinoIcons.profile_circled),
        ],
        ButtonView(header: "Directions", index: 1, icon: Icons.directions),
        ButtonView(header: "Book a ride", index: 2, icon: Icons.arrow_forward_sharp),
        if(result.user!.contact.isNotEmpty) ...[
          ButtonView(header: "Call", index: 3, icon: CupertinoIcons.phone_circle_fill),
        ],
      ];
    } else {
      return [
        ButtonView(header: "Directions", index: 1, icon: Icons.directions),
        ButtonView(header: "Book a ride", index: 2, icon: Icons.arrow_forward_sharp),
      ];
    }
  }

  void onClick(ButtonView view) {
    if(response.instanceOf<SearchShopResponse>()) {
      SearchShopResponse result = response as SearchShopResponse;

      if(view.index.equals(0) && showDetails) {
        ShopResultLayout.open(shop: result, category: category, pickup: pickupLocation);
      } else if(view.index.equals(1)) {
        NavigationSheet.open(result, pickupLocation);
      } else if(view.index.equals(2)) {
        String url = _uberUrl(
          result.shop.latitude,
          result.shop.longitude,
          result.shop.address,
          result.shop.address
        );

        RouteNavigator.openLink(url: url);
      } else if(view.index.equals(3)) {
        RouteNavigator.callNumber(result.shop.phone);
      } else {
        RouteNavigator.openLink(url: result.shop.link);
      }
    } else if(response.instanceOf<GoActivity>()) {
      GoActivity result = response as GoActivity;

      if(view.index.equals(0) && showDetails) {
        // GoActivityViewerLayout.open(activity: result);
      } else if(view.index.equals(1)) {
        NavigationSheet.open(result, pickupLocation);
      } else if(view.index.equals(2)) {
        String url = _uberUrl(
          result.location!.latitude,
          result.location!.longitude,
          result.location!.place,
          result.location!.place
        );

        RouteNavigator.openLink(url: url);
      } else if(view.index.equals(3)) {
        RouteNavigator.callNumber(result.user!.contact);
      }
    }
  }

  String _uberUrl(double latitude, double longitude, String nickname, String address) {
    return "uber://riderequest?pickup"
        "[latitude]=${pickupLocation.latitude}"
        "&pickup[longitude]=${pickupLocation.longitude}"
        "&pickup[nickname]=${pickupLocation.country}"
        "&pickup[formatted_address]=${pickupLocation.place}"
        "&dropoff[latitude]=$latitude"
        "&dropoff[longitude]=$longitude"
        "&dropoff[nickname]=$nickname"
        "&dropoff[formatted_address]=$address";
  }
}