import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class OnboardingController extends GetxController {
  OnboardingController();
  final state = OnboardingState();

  List<int> items = 8.listGenerator;

  void getStarted() {
    Database.instance.savePreference(Database.instance.preference.copyWith(isNew: false));
    Navigate.all(ServicesLayout.route);
  }
}