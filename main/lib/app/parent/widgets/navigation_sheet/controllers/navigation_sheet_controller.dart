import 'package:map_launcher/map_launcher.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart' show TExtensions;

class NavigationSheetController<T> extends GetxController {
  final T response;
  final Address pickup;

  NavigationSheetController({required this.response, required this.pickup});

  final state = NavigationSheetState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    _fetchList();

    super.onInit();
  }

  String get id => response.instanceOf<SearchShopResponse>()
      ? (response as SearchShopResponse).shop.id
      : (response as GoActivity).id;
  double get longitude => response.instanceOf<SearchShopResponse>()
      ? (response as SearchShopResponse).shop.longitude
      : (response as GoActivity).location!.longitude;
  double get latitude => response.instanceOf<SearchShopResponse>()
      ? (response as SearchShopResponse).shop.latitude
      : (response as GoActivity).location!.latitude;
  String get name => response.instanceOf<SearchShopResponse>()
      ? (response as SearchShopResponse).shop.name
      : (response as GoActivity).location!.place;

  void _fetchList() async {
    state.isLoading.value = true;

    if(PlatformEngine.instance.isWeb) {
      List<AvailableMap> maps = [
        AvailableMap(mapName: "Google map", mapType: MapType.google, icon: Assets.mapGoogleMaps),
        AvailableMap(mapName: "OpenStreet Map", mapType: MapType.amap, icon: Assets.mapOpenStreetMap),
        AvailableMap(mapName: "Bing map", mapType: MapType.apple, icon: Assets.mapBing),
      ];

      state.maps.value = maps;
    } else {
      final maps = await MapLauncher.installedMaps;
      state.maps.value = maps;
    }

    state.isLoading.value = false;
  }

  void onSelect(AvailableMap map) async {
    if(PlatformEngine.instance.isWeb) {
      double originLat = pickup.latitude;
      double originLng = pickup.longitude;
      double destinationLat = latitude;
      double destinationLng = longitude;

      String origin = "$originLat,$originLng";
      String destination = "$destinationLat,$destinationLng";

      Uri url;
      if(map.mapType == MapType.google) {
        url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',);
      } else if(map.mapType == MapType.apple) {
        url = Uri.parse('https://bing.com/maps/default.aspx?rtp=adr.$origin~adr.$destination',);
      } else {
        url = Uri.parse('https://www.openstreetmap.org/directions?engine=fossgis_osrm_car&route=$origin;$destination',);
      }

      RouteNavigator.openLink(uri: url);
    } else {
      await MapLauncher.showDirections(
        mapType: map.mapType,
        destination: Coords(latitude, longitude),
        destinationTitle: name
      );
    }

    if(response.instanceOf<SearchShopResponse>()) {
      _drive(id, Database.instance.address);
    }

    Navigate.till(parentPage);
  }

  void _drive(String shopId, Address address) async {
    await _connect.post(endpoint: "/shop/drive", body: {
      "shop_id": shopId,
      "address": address.place,
      "place_id": address.id,
      "latitude": address.latitude,
      "longitude": address.longitude
    });
  }
}