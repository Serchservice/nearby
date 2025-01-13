import 'package:drive/library.dart';
import 'package:get/get.dart';

class LocationSearchBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => LocationSearchController())
    ];
  }
}