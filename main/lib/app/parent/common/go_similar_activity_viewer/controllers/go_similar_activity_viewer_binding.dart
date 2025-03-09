import 'package:get/get.dart';

import 'go_similar_activity_viewer_controller.dart';

class GoSimilarActivityViewerBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<GoSimilarActivityViewerController>(() => GoSimilarActivityViewerController()),
    ];
  }
}