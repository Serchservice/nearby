import 'package:get/get_rx/src/rx_types/rx_types.dart';

class VerifyEmailState {
  /// Timeout count
  RxInt timeout = 59.obs;

  /// To toggle the counting state
  RxBool isCounting = true.obs;

  /// The OTP
  RxString otp = "".obs;

  /// Check if the OTP is being resent
  RxBool isResending = false.obs;

  /// Check if the OTP is being resent
  RxBool isVerifying = false.obs;
}