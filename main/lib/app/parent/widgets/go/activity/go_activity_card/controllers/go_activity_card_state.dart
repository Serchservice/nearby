import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoActivityCardState {
  Rx<GoActivity> activity = Rx(GoActivity.empty());

  RxList<GoUser> attendingUsers = RxList<GoUser>([]);

  RxInt currentImageIndex = RxInt(0);

  RxInt totalImageCount = RxInt(0);

  RxString startTiming = RxString("");

  RxString endTiming = RxString("");
}