import 'package:get/get.dart';

import 'go_activity_viewer_controller.dart';

class GoActivityViewerBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<GoActivityViewerController>(() => GoActivityViewerController()),
    ];
  }
}