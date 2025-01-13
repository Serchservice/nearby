import 'package:drive/library.dart';
import 'package:get/get.dart';

class ResultBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ResultController())
    ];
  }
}