import 'package:get/get.dart';
import 'package:drive/library.dart';

class PlatformErrorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatformErrorController>(() => PlatformErrorController());
  }
}