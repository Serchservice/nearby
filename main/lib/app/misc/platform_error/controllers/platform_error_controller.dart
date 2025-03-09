import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart' show TExtensions;

class PlatformErrorController extends GetxController {
  final String? error;
  PlatformErrorController({this.error});

  final state = PlatformErrorState();

  dynamic args = Get.arguments;

  @override
  void onInit() {
    if(error.isNotNull) {
      state.message.value = error!;
    } else if(args.isNotNull && args.instanceOf(String)) {
      state.message.value = args;
    } else {
      state.message.value = "A platform error just occurred on this Serch platform. If you feel like this is an error on our end, "
          "contact improve@serchservice.com to find what the problem is.";
    }

    super.onInit();
  }
}