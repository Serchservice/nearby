import 'package:get/get.dart';

import 'go_bcap_viewer_controller.dart';

class GoBCapViewerBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<GoBCapViewerController>(() => GoBCapViewerController()),
    ];
  }
}