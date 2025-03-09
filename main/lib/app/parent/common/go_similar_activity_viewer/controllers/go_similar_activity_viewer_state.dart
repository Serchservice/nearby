import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoSimilarActivityViewerState{
  RxBool isOthers = RxBool(false);

  RxBool isLoading = RxBool(true);

  Rx<GoActivity> activity = Rx<GoActivity>(GoActivity.empty());
}