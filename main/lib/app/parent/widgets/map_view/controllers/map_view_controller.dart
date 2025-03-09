import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:connectify/connectify.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class MapViewController extends GetxController with GetTickerProviderStateMixin {
  final Address origin;
  final Address? destination;
  final String distance;

  MapViewController({
    required this.origin,
    this.destination,
    this.distance = ""
  });

  final state = MapViewState();

  Completer<GoogleMapController> googleMapsController = Completer();
  Animation<double>? animation;

  @override
  void onInit() {
    state.origin.value = origin;

    if(destination != null) {
      state.destination.value = destination!;
    }

    _loadStyle();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeMap();
    });
    super.onInit();
  }

  LatLng get getDestination => LatLng(state.destination.value.latitude, state.destination.value.longitude);
  LatLng get getOrigin => LatLng(state.origin.value.latitude, state.origin.value.longitude);

  void _loadStyle() async {
    if(Database.instance.isDarkTheme) {
      try {
        String json = await rootBundle.loadString('asset/common/google_map_style.json');
        state.style.value = json;
      } catch (_) { }
    }
  }

  void _initializeMap() async {
    state.isLoadingMap.value = true;
    DirectionsService.init(Keys.googleMapApiKey);

    _addOrUpdateMarker(getOrigin, false);
    _moveMapCamera(getOrigin);

    if(destination != null) {
      _addOrUpdateMarker(getDestination, true);
      await _drawRoute(getOrigin);
      _getTotalDistanceAndTime(getOrigin, getDestination);
    }

    state.isLoadingMap.value = false;
  }

  void _addOrUpdateMarker(LatLng position, bool isDestination, {String? asset}) async {
    final Uint8List markerIcon = await _getBytesFromAsset(
      asset ?? (isDestination ? Assets.mapDestination : Assets.mapCurrent),
      isDestination ? 32 : 32,
      isDestination ? 32 : 32
    );
    MarkerId id = MarkerId(isDestination ? "destination" : "current");
    Marker marker = Marker(
        markerId: id,
        position: position,
        rotation: 0,
        visible: true,
        icon: BitmapDescriptor.bytes(markerIcon)
    );

    Map<MarkerId, Marker> markers = Map.from(state.markers);
    if(markers.containsKey(id)) {
      markers[id] = marker;
    } else {
      markers.putIfAbsent(id, () => marker);
    }

    state.markers.value = markers;
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future _moveMapCamera(LatLng target, {double zoom = 24, double bearing = 0}) async {
    CameraPosition newCameraPosition = CameraPosition(target: target, zoom: zoom, bearing: bearing);

    final GoogleMapController controller = await googleMapsController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> _drawRoute(LatLng position) async {
    if (state.polyline.isNotEmpty) {
      state.polyline.clear();
      state.polylineCoordinates.clear();
      update();
    }
    if(state.gettingRoute.value) return;

    state.gettingRoute.value = true;

    final directionsService = DirectionsService();

    final request = DirectionsRequest(
      origin: GeoCoord(position.latitude, position.longitude),
      destination: "${getDestination.latitude},${getDestination.longitude}",
      travelMode: TravelMode.driving,
    );

    await directionsService.route(request, (DirectionsResult response, status) {
      console.log(status);
      if (status == DirectionsStatus.ok && response.routes != null && response.routes!.asMap().values.single.overviewPath != null) {
        for (GeoCoord value in response.routes!.asMap().values.single.overviewPath!) {
          state.polylineCoordinates.add(LatLng(value.latitude, value.longitude));
        }
      }
    });

    PolylineId id = const PolylineId('route');

    Polyline myPolyline = Polyline(
      width: 4,
      visible: true,
      polylineId: id,
      color: CommonColors.instance.darkTheme,
      points: state.polylineCoordinates
    );
    state.polyline.add(myPolyline);
    await _positionCameraToRoute();

    state.gettingRoute.value = false;
  }

  Future<void> _positionCameraToRoute() async {
    try {
      double minLat = state.polyline.first.points.first.latitude;
      double minLng = state.polyline.first.points.first.longitude;
      double maxLat = state.polyline.first.points.first.latitude;
      double maxLng = state.polyline.first.points.first.longitude;

      for (var poly in state.polyline) {
        for (var point in poly.points) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLng) minLng = point.longitude;
          if (point.longitude > maxLng) maxLng = point.longitude;
        }
      }

      // Create bounds from the calculated min/max points
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      // Animate the camera to fit the bounds with extra padding
      var c = await googleMapsController.future;
      c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 20));
    } catch (e) {
      // ignore: empty_catches
      console.error(e, from: "POSITION CAMERA ROUTE");
    }
  }

  void _getTotalDistanceAndTime(LatLng position, LatLng destination) async {
    double distance = 0.0;
    double duration = 0.0;

    List<dynamic> elements = await ConnectifyUtils.instance.getTotalDistanceAndTime(
      originLatitude: position.latitude,
      originLongitude: position.longitude,
      destinationLatitude: destination.latitude,
      destinationLongitude: destination.longitude,
      googleMapApiKey: Keys.googleMapApiKey
    );

    console.log(elements, from: "GET TOTAL DISTANCE AND TIME");

    if(elements.any((e) => (e["status"] as String).equals("ZERO_RESULTS"))) {
      state.distanceLeft.value = this.distance;
      state.timeLeft.value = "Within close range"; // in minutes
    } else {
      for (var i = 0; i < elements.length; i++) {
        distance = distance + elements[i]['distance']['value'];
        duration = duration + elements[i]['duration']['value'];
      }

      state.distanceLeft.value = "${(distance / 1000).toStringAsFixed(2)} km"; // in kilometers
      state.timeLeft.value = "${(duration / 60).toStringAsFixed(2)} minutes"; // in minutes
    }
  }
}