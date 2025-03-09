import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoActivityState {
  Rx<GoInterest> filter = GoInterest.empty().obs;

  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

  RxInt current = RxInt(0);
}