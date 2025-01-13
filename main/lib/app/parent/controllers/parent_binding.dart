import 'package:drive/library.dart';
import 'package:get/get.dart';

class ParentBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ParentController()),
      Bind.put<HomeController>(HomeController()),
      Bind.put<HistoryController>(HistoryController()),
      Bind.put<SettingsController>(SettingsController())
    ];
  }
}