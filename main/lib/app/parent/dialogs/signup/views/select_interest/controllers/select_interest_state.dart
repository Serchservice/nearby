import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SelectInterestState {
  RxList<GoInterestCategory> categories = RxList([]);

  RxList<GoInterest> selected = RxList([]);

  Rx<Address> address = Database.instance.address.obs;

  RxBool isFetchingCategories = RxBool(false);

  RxBool isLoading = RxBool(false);

  RxBool canPop = RxBool(false);
}