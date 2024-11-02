import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationSearchLayout extends GetResponsiveView<LocationSearchController> {
  static String get route => "/search";

  LocationSearchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      layoutKey: Key("Location Search"),
      appbar: AppBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(Sizing.space(16)),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Field(
                  padding: const EdgeInsets.all(8),
                  hintText: "Enter your location",
                  controller: controller.locationController,
                ),
                Obx(() => LocationView(
                  address: controller.state.location.value,
                  isSearching: controller.state.isSearchingLocation.value,
                  onSearch: () => controller.fetchCurrentAddress(),
                )),
              ],
            ),
          ),
          Obx(() {
            if(controller.state.isSearching.value) {
              return Expanded(
                child: LoadingShimmer(
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
                ),
              );
            } else if(controller.state.locations.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
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
                ),
              );
            } else {
              return Container();
            }
          }),
          if(controller.bannerAdManager.banner() != null) ...[
            controller.bannerAdManager.banner()!
          ]
        ],
      )
    );
  }
}