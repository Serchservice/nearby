import 'package:drive/library.dart';
import 'package:get/get.dart';

class CategorySearchBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<CategorySearchController>(() => CategorySearchController())
    ];
  }
}