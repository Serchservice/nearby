import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AccountUpdateState {
  RxDouble searchRadius = RxDouble(Database.instance.account.searchRadius);

  RxBool isSaving = RxBool(false);

  RxString avatar = RxString(Database.instance.account.avatar);

  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;
}