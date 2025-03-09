import 'package:get/get.dart';

import 'account_update_controller.dart';

class AccountUpdateBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => AccountUpdateController())
    ];
  }
}