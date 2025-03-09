import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoActivityRatingSheetState{
  RxBool isRating = RxBool(false);

  RxDouble rating = RxDouble(0.0);

  RxString info = RxString("");
}