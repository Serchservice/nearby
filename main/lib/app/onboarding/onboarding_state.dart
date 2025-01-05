import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OnboardingState {
  RxBool isNew = RxBool(Database.preference.isNew);
}