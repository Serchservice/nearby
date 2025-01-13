import 'package:get/get.dart';
import 'package:drive/library.dart';

class OnboardingController extends GetxController {
  OnboardingController();
  final state = OnboardingState();

  List<int> items = CommonUtility.generateList(8);

  void getStarted() {
    Database.savePreference(Database.preference.copyWith(isNew: false));
    Navigate.all(HomeLayout.route);
  }
}