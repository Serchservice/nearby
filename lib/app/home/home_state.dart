import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  RxString selectedCategory = RxString("");

  Rx<Address> selectedAddress = Address.empty().obs;
}