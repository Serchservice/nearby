import 'package:drive/library.dart';

class CentreLifeCycle {
  static void onGoBCapCreate(GoBCapCreate create) {
    CentreController controller = CentreController.data;

    controller.createController.add(create);
  }
}