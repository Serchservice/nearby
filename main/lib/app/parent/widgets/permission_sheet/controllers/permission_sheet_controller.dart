import 'package:get/get.dart';
import 'package:drive/library.dart';

class PermissionSheetController extends GetxController {
  final int sdk;

  PermissionSheetController({required this.sdk});
  final state = PermissionSheetState();

  final AccessService _accessService = AccessImplementation();

  void grant() {
    state.canPop.value = false;

    requestAccess(onSuccess: () async {
      state.canPop.value = true;
      Navigate.back();
    });
  }

  Future<void> requestAccess({Function()? onSuccess}) async {
    bool hasAccess = await _accessService.requestPermissions();
    if(hasAccess) {
      onSuccess?.call();
      return;
    } else {
      requestAccess(onSuccess: onSuccess);
    }
  }

}