import 'package:drive/library.dart' show Address, Database, GoAccount, GoBCapCreateUpload, GoInterest, GoInterestCategory, SearchShopResponse;
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CentreState {
  RxBool isFetchingInterests = RxBool(true);

  RxBool isFetchingInterestCategories = RxBool(true);

  RxBool isGettingAccount = RxBool(Database.instance.account.isEmpty);

  RxList<GoInterest> interests = RxList(Database.instance.interests);

  RxList<GoInterestCategory> categories = RxList(Database.instance.interestCategories);

  Rx<GoAccount> account = Rx<GoAccount>(Database.instance.account);

  RxList<SearchShopResponse> shopHistory = Database.instance.recentSearch.obs;

  RxList<Address> addressHistory = Database.instance.recentAddresses.obs;

  RxInt current = RxInt(0);

  RxList<GoBCapCreateUpload> uploads = RxList([]);
}