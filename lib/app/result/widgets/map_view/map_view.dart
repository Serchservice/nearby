import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drive/library.dart';

class MapView extends StatelessWidget {
  final Address origin;
  final Address? destination;
  final double? height;
  final String distance;
  final bool isTop;

  const MapView({
    super.key,
    required this.origin,
    this.destination,
    this.distance = "",
    this.height,
    this.isTop = false
  });

  @override
  Widget build(BuildContext context) {
    return GetX<MapViewController>(
      init: MapViewController(
        origin: origin,
        destination: destination,
        distance: distance
      ),
      builder: (controller) {
        CameraPosition initialCameraPosition = CameraPosition(target: controller.getOrigin, zoom: 13.0);
        Set<Marker> markers = controller.state.markers.values.toSet();

        return SizedBox(
          height: height ?? Get.height,
          width: Get.width,
          child: Stack(
            children: [
              GoogleMap(
                style: controller.state.style.value.isNotEmpty ? controller.state.style.value : null,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: markers,
                polylines: Set<Polyline>.of(controller.state.polyline),
                onMapCreated: (GoogleMapController mapController) async {
                  controller.googleMapsController.complete(mapController);
                },
              ),
              Positioned(
                top: isTop ? 10 : null,
                bottom: isTop ? null: 30,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircledButton(
                    title: "View details",
                    icon: Icons.info_outline_rounded,
                    iconColor: Theme.of(context).primaryColor,
                    onClick: () => MapViewDetails.open(controller),
                    backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
                  ),
                )
              )
            ],
          ),
        );
      }
    );
  }
}

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
          const SizedBox(height: 10),
          Obx(() {
            if(controller.state.isLoadingMap.value) {
              return LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
              );
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
