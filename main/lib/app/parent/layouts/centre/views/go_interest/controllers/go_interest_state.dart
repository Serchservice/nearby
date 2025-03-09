import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GoInterestState {
  RxInt current = RxInt(0);

  RxBool isFetchingCategories = false.obs;

  RxBool isSaving = false.obs;

  Rx<Address> address = Database.instance.address.obs;

  RxList<GoInterestCategory> categories = <GoInterestCategory>[].obs;

  RxList<GoInterest> selected = <GoInterest>[].obs;

  RxList<GoInterest> removal = <GoInterest>[].obs;

  RxList<GoInterestCategory> goCategories = RxList(Database.instance.interestCategories);
}