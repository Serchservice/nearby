import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drive/library.dart';

class MapViewState {
  /// User location
  Rx<Address> origin = Address.empty().obs;

  /// User destination
  Rx<Address> destination = Address.empty().obs;

  /// Map Style
  RxString style = RxString("");

  /// The distance left in the navigation
  RxString distanceLeft = RxString("");

  /// The time left in the navigation
  RxString timeLeft = RxString("");

  /// Whether the map is being loaded
  RxBool isLoadingMap = RxBool(false);

  /// Whether the route is being prepared
  RxBool gettingRoute = RxBool(false);

  /// The markers in the map
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  /// List of [LatLng] coordinates
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;

  /// Set of poly lines
  RxSet<Polyline> polyline = <Polyline>{}.obs;
}