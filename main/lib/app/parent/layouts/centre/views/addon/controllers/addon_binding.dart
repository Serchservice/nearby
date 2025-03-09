import 'package:get/get.dart';

import 'addon_controller.dart';

class AddonBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => AddonController())
    ];
  }
}