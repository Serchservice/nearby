import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ServicesState {
  RxList<Suggestion> promotionalItem = <Suggestion>[].obs;

  RxList<Suggestion> interestSuggested = <Suggestion>[].obs;
}