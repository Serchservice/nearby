import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityState {
  RxList<GoCreateUpload> uploads = RxList([]);

  Rx<GoInterest> filter = GoInterest.empty().obs;

  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

  RxBool hideSearchButton = false.obs;

  RxString search = RxString("");

  RxInt currentTab = RxInt(0);
}