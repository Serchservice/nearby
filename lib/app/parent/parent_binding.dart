import 'package:drive/library.dart';
import 'package:get/get.dart';

class ParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParentController());
  }
}