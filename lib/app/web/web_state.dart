import 'package:get/get.dart';

class WebState {
  /// The URL or Route of the Website
  RxString route = "".obs;

  /// Header of the URL Website
  RxString header = "Serch".obs;

  /// Integer loading percentage
  RxInt loadingPercentage = 0.obs;

  /// Error message to show
  RxString errorMessage = "".obs;

  /// For feedback when required
  Rx<dynamic> response = "".obs;
}