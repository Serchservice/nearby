import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'controllers/location_search_controller.dart';

class LocationSearchLayout extends GetResponsiveView<LocationSearchController> {
  static String get route => "/search/location";

  static Future<T?>? to<T>() {
    return Navigate.to(route);
  }

  LocationSearchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Location Search"),
      appbar: AppBar(
        title: TextBuilder(
          text: "Location Search",
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(Sizing.space(10)),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Field(
              padding: const EdgeInsets.all(8),
              hint: "Enter your location",
              controller: controller.locationController,
            ),
          ),
          BannerAdLayout(
            isExpanded: true,
            child: Obx(() {
              if(controller.state.isSearching.value) {
                return LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  darkHighlightColor: CommonColors.instance.shimmerHigh.darken(66),
                  darkBaseColor: CommonColors.instance.shimmerHigh.darken(65),
                  content: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(vertical: Sizing.space(2)),
                        color: Theme.of(context).primaryColorLight,
                      );
                    },
                  ),
                );
              } else if(controller.state.locations.isNotEmpty) {
                return ListView.builder(
                  itemCount: controller.state.locations.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Address address = controller.state.locations[index];

                    return LocationView(
                      address: address,
                      withPadding: true,
                      fontSize: 14,
                      onSelect: (address) => controller.pick(address),
                    );
                  },
                );
              } else if(controller.state.addressHistory.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextBuilder(
                          text: "Recent visits",
                          size: Sizing.font(16),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ),
                      ListView.builder(
                        itemCount: controller.state.addressHistory.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Address address = controller.state.addressHistory[index];

                          return LocationView(
                            address: address,
                            withPadding: true,
                            fontSize: 14,
                            onSelect: (address) => controller.pick(address),
                          );
                        },
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
          ),
        ],
      )
    );
  }
}