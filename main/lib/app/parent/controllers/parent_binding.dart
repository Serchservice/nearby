import 'package:drive/library.dart';
import 'package:get/get.dart';

class ParentBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ParentController()),
      Bind.put<ActivityController>(ActivityController()),
      Bind.put<BCapController>(BCapController()),
      Bind.put<ServicesController>(ServicesController()),
      Bind.put<CentreController>(CentreController()),
      Bind.put<SettingsController>(SettingsController()),
      Bind.put<AddonController>(AddonController()),
    ];
  }
}