import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoBCapCardState {
  Rx<GoBCap> cap = GoBCap.empty().obs;

  Rx<GoActivity> activity = GoActivity.empty().obs;

  RxList<GoActivityComment> comments = <GoActivityComment>[].obs;

  RxList<GoActivityRating> ratings = <GoActivityRating>[].obs;

  RxInt currentContentIndex = RxInt(0);

  RxInt totalContentCount = RxInt(0);
}