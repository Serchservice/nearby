import 'dart:io';

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
      if(Platform.isAndroid || Platform.isIOS) {
        onSuccess?.call();
        return;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      requestAccess(onSuccess: onSuccess);
    }
  }

}