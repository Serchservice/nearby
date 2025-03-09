import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AddonState {
  RxDouble searchRadius = RxDouble(Database.instance.account.searchRadius);

  RxBool isFetchingOthers = RxBool(true);

  RxBool isFetchingMine = RxBool(true);

  RxInt current = RxInt(0);

  RxList<GoAddon> otherAddons = RxList<GoAddon>([]);

  RxList<GoUserAddon> userAddons = RxList<GoUserAddon>([]);

  RxList<GoCreditCard> userCards = RxList<GoCreditCard>([]);
}