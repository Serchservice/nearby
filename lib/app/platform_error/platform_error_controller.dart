import 'package:get/get.dart';
import 'package:drive/library.dart';

class PlatformErrorController extends GetxController {
  final String? error;
  PlatformErrorController({this.error});

  final state = PlatformErrorState();

  final args = Get.arguments;

  @override
  void onInit() {
    if(error != null) {
      state.message.value = error!;
    } else if(args != null && args is String) {
      state.message.value = args;
    } else {
      state.message.value = "A platform error just occurred on this Serch platform. If you feel like this is an error on our end, "
          "contact improve@serchservice.com to find what the problem is.";
    }

    super.onInit();
  }
}