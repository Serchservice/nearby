import 'package:get/get.dart';

import 'search_result_controller.dart';

class ResultBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ResultController())
    ];
  }
}