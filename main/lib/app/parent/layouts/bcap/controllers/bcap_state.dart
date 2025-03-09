import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BCapState {
  Rx<GoInterest> filter = GoInterest.empty().obs;

  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

  Rx<bool> continuousLooping = Rx<bool>(Database.instance.goPreference.loopBCapVideos);
}