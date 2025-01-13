import 'package:get/get.dart';
import 'package:drive/library.dart';

class PlatformErrorBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<PlatformErrorController>(() => PlatformErrorController())
    ];
  }
}