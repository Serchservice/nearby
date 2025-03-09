import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoBCapViewerState {
  RxBool isLoading = RxBool(true);

  Rx<GoBCap> cap = GoBCap.empty().obs;
}