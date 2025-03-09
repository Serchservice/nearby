import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SignupState {
  RxBool isLoading = RxBool(false);

  RxBool showPassword = RxBool(true);

  RxBool showConfirmPassword = RxBool(true);
}