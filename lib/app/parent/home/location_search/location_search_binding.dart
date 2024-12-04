import 'package:drive/library.dart';
import 'package:get/get.dart';

class LocationSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationSearchController());
  }
}