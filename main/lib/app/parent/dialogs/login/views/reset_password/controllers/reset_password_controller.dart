import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class ResetPasswordController extends GetxController {
  final String emailAddress;

  ResetPasswordController(this.emailAddress);
  final state = ResetPasswordState();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ConnectService _connect = Connect();
  final FirebaseMessagingService _messagingService = FirebaseMessagingImplementation();
  final LocationService _locationService = LocationImplementation();

  bool _continue = true;

  @override
  void onReady() {
    if(emailAddress.isEmpty) {
      notify.warn(message: "An error occurred while processing your request");
      _continue = false;
    }
    
    super.onReady();
  }

  void reset(BuildContext context) {
    if(_continue) {
      CommonUtility.unfocus(context);

      if(passwordController.text.notEquals(confirmPasswordController.text)) {
        notify.warn(message: "Password does not match");
        return;
      }

      if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
        formKey.currentState!.save();

        state.isLoading.value = true;
        if(Database.instance.address.hasAddress.isFalse) {
          _locationService.getAddress(
            onSuccess: (address, position) {
              _resetPassword(address);
            },
            onError: (error) {
              state.isLoading.value = false;
              notify.warn(message: error);

              return;
            }
          );
        } else {
          _resetPassword(Database.instance.address);
        }
      }
    }
  }

  void _resetPassword(Address address) async {
    String fcmToken = await _messagingService.getFcmToken();
    String timezone = await CommonUtility.getTimezone();

    JsonMap payload = {
      "email_address": emailAddress,
      "password": passwordController.text.trim(),
      "address": address.toJson(),
      "device": PlatformEngine.instance.device.toJson(),
      "fcm_token": fcmToken,
      "timezone": timezone
    };

    _connect.post(endpoint: "/auth/go/reset_password", body: payload).then((Outcome response) {
      state.isLoading.value = false;

      if(response.isSuccessful) {
        Navigate.close(closeAll: false);
        LoginSheet.open();
      } else {
        notify.error(message: response.message);
      }
    });
  }

  @override
  void onClose() {
    confirmPasswordController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}