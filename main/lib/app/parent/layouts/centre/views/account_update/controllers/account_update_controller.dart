import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart' show FormState, GlobalKey, TextEditingController;
import 'package:get/get.dart';
import 'package:smart/smart.dart' show JsonMap, MapExtensions, StringExtensions, TExtensions;

import 'account_update_state.dart';

class AccountUpdateController extends GetxController {
  AccountUpdateController();
  final state = AccountUpdateState();

  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    firstNameController.text = Database.instance.account.firstName;
    lastNameController.text = Database.instance.account.lastName;
    contactController.text = Database.instance.account.contact;
    state.searchRadius.value = Database.instance.account.searchRadius;

    super.onInit();
  }

  void save() {
    if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
      GoAccount account = Database.instance.account;
      account = account.copyWith(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        contact: contactController.text.trim(),
        searchRadius: state.searchRadius.value,
        location: Database.instance.address
      );

      JsonMap payload = account.toJson();
      payload.add("upload", {
        "path": state.media.value.path,
        "bytes": state.media.value.data,
        "media": state.media.value.media.type
      });

      state.isSaving.value = true;
      _connect.post(endpoint: "/go/account/update", body: payload).then((Outcome response) {
        state.isSaving.value = false;

        if(response.isSuccessful) {
          GoAccount account = GoAccount.fromJson(response.data);
          ActivityLifeCycle.onAccountReceived(account, false);
          notify.success(message: "Account updated successfully");
        } else {
          notify.error(message: response.message);
        }
      });
    }
  }

  bool get showButton => firstNameController.text.notEqualsIgnoreCase(Database.instance.account.firstName)
      || lastNameController.text.notEqualsIgnoreCase(Database.instance.account.lastName)
      || contactController.text.notEqualsIgnoreCase(Database.instance.account.contact)
      || state.searchRadius.value.notEquals(Database.instance.account.searchRadius)
      || state.avatar.value.notEquals(Database.instance.account.avatar);

  void changeSearchRadius(double value) {
    state.searchRadius.value = (value * 100);
  }

  void changeAvatar() {
    Multimedia.open(
      onReceived: (result) {
        state.media.value = result;
        state.avatar.value = result.path;
      },
      onlyPhoto: true,
      title: "Pick your profile picture",
      route: Navigate.appendRoute("/avatar")
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactController.dispose();

    super.onClose();
  }

  double get maxRadius => 100;
}