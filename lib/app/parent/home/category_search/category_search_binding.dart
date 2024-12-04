import 'package:drive/library.dart';
import 'package:get/get.dart';

class CategorySearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategorySearchController>(() => CategorySearchController());
  }
}