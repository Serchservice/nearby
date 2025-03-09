import 'package:get/get.dart';

import 'category_search_controller.dart';

class CategorySearchBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<CategorySearchController>(() => CategorySearchController())
    ];
  }
}