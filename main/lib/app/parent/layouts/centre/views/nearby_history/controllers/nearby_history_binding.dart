import 'package:get/get.dart';

import 'nearby_history_controller.dart';

class NearbyHistoryBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => NearbyHistoryController())
    ];
  }
}