import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoActivityViewerState {
  RxBool isLoading = RxBool(true);

  Rx<GoActivity> activity = GoActivity.empty().obs;

  Rx<Address> currentLocation = Database.instance.address.obs;

  RxBool isGettingCurrentLocation = RxBool(true);

  RxDouble appbarHeight = RxDouble(0);

  RxInt currentImageIndex = RxInt(0);

  RxInt totalImageCount = RxInt(0);

  RxList<GoUser> attendingUsers = RxList<GoUser>([]);
}