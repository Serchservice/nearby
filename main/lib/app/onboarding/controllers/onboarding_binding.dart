import 'package:drive/library.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => OnboardingController())
    ];
  }
}