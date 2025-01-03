import 'package:drive/library.dart';
import 'package:get/get.dart';

class ParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParentController());

    Get.put<HomeController>(HomeController());
    Get.put<HistoryController>(HistoryController());
    Get.put<SettingsController>(SettingsController());
  }
}