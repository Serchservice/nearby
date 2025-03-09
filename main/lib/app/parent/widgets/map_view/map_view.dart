import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drive/library.dart';
import 'package:smart/ui.dart';

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
    if(PlatformEngine.instance.isWeb) {
      return SizedBox.shrink();
    }

    return GetX<MapViewController>(
      init: MapViewController(
        origin: origin,
        destination: destination,
        distance: distance
      ),
      builder: (controller) {
        CameraPosition initialCameraPosition = CameraPosition(target: controller.getOrigin, zoom: 12.0);
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
                  child: InfoButton(
                    tip: "View details",
                    defaultIcon: Icons.info_outline_rounded,
                    defaultIconColor: Theme.of(context).primaryColor,
                    onPressed: () => MapViewDetails.open(controller),
                    backgroundColor: WidgetStateProperty.resolveWith((state) {
                      return Theme.of(context).textSelectionTheme.selectionColor;
                    }),
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