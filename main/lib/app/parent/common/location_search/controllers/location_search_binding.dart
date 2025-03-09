import 'package:get/get.dart';

import 'location_search_controller.dart';

class LocationSearchBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => LocationSearchController())
    ];
  }
}