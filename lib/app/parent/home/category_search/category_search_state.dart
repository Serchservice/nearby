import 'package:drive/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CategorySearchState {
  RxList<Category> categories = Category.categories.obs;

  RxList<CategorySection> filtered = RxList();
}