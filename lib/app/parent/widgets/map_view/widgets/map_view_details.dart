import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class MapViewDetails extends StatelessWidget {
  final MapViewController controller;

  const MapViewDetails({super.key, required this.controller});

  static void open(MapViewController controller) {
    Navigate.bottomSheet(
      sheet: MapViewDetails(controller: controller),
      route: "/map/view-details",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if(controller.state.isLoadingMap.value) {
              return LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          Container(
            padding: EdgeInsets.all(Sizing.space(12)),
            color: Theme.of(context).colorScheme.surface,
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Assets.mapUpRight, width: 30, color: Theme.of(context).primaryColorDark),
                const SizedBox(width: 10),
                Expanded(child: DashedDivider(color: Theme.of(context).primaryColorDark)),
                const SizedBox(width: 10),
                Image.asset(Assets.mapWorld, width: 40),
              ],
            ),
          ),
          Obx(() {
            if(controller.state.isLoadingMap.value) {
              return SizedBox.shrink();
            } else {
              return Container(
                width: Get.width,
                padding: EdgeInsets.all(Sizing.space(12)),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: "Trip Details",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                    const SizedBox(height: 10),
                    SteppingList(
                      steppings: [
                        Stepping(
                          content: Column(
                            children: [
                              Container(
                                height: 60,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: LocationView(address: controller.state.origin.value)
                              ),
                            ],
                          ),
                          icon: Icons.location_pin,
                        ),
                        if(controller.destination != null) ...[
                          Stepping(
                            content: Column(
                              children: [
                                Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  child: LocationView(address: controller.state.destination.value)
                                ),
                              ],
                            ),
                            icon: Icons.workspaces_rounded,
                          )
                        ]
                      ]
                    ),
                    if(controller.destination != null) ...[
                      Divider(color: Theme.of(context).primaryColorLight),
                      if(controller.state.timeLeft.isNotEmpty) ...[
                        SText(
                          text: "Estimated Arrival Time: ${controller.state.timeLeft.value}",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(14)
                        )
                      ],
                      if(controller.state.distanceLeft.isNotEmpty) ...[
                        SText(
                          text: "Distance: ${controller.state.distanceLeft.value}",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(14)
                        )
                      ]
                    ]
                  ],
                )
              );
            }
          }),
        ],
      ),
    );
  }
}