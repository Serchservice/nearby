import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoActivityCardSheetState {
  Rx<GoActivity> activity = Rx(GoActivity.empty());

  Rx<GoBCap> cap = GoBCap.empty().obs;

  RxList<GoActivityComment> comments = <GoActivityComment>[].obs;

  RxList<GoActivityRating> ratings = <GoActivityRating>[].obs;

  RxList<GoActivity> otherCreatorsActivities = <GoActivity>[].obs;

  RxList<GoActivity> creatorActivities = <GoActivity>[].obs;

  RxBool isEnding = false.obs;

  RxBool isStarting = false.obs;
}