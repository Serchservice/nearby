import 'package:get/get.dart';

import 'go_interest_controller.dart';

class GoInterestBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => GoInterestController())
    ];
  }
}