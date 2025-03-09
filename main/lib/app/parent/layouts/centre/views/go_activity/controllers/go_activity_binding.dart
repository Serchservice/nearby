import 'package:get/get.dart';

import 'go_activity_controller.dart';

class GoActivityBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => GoActivityController())
    ];
  }
}