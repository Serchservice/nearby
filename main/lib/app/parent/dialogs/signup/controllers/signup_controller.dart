import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class SignupController extends GetxController {
  SignupController();
  final state = SignupState();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final ConnectService _connect = Connect();
  final LocationService _locationService = LocationImplementation();
  final FirebaseMessagingService _messagingService = FirebaseMessagingImplementation();

  void signup(BuildContext context) {
    CommonUtility.unfocus(context);

    if(passwordController.text.notEquals(confirmPasswordController.text)) {
      notify.warn(message: "Password does not match");
      return;
    }

    String fullName = fullNameController.text;
    String firstName = fullName.split(" ")[0];
    String lastName = fullName.split(" ")[1];

    if((firstName.isEmpty || firstName.length.isLessThan(3)) || (lastName.isEmpty || lastName.length.isLessThan(3))) {
      notify.warn(message: "Full name should be in this format: Stella Maris. Separate your names with a white space");
      return;
    }

    if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state.isLoading.value = true;
      if(Database.instance.address.hasAddress.isFalse) {
        _locationService.getAddress(
          onSuccess: (address, position) {
            _signup(fullName, address);
          },
          onError: (error) {
            state.isLoading.value = false;
            notify.warn(message: error);

            return;
          }
        );
      } else {
        _signup(fullName, Database.instance.address);
      }
    }
  }

  void _signup(String fullName, Address address) async {
    String fcmToken = await _messagingService.getFcmToken();
    String timezone = await CommonUtility.getTimezone();

    JsonMap payload = {
      "first_name": fullName.split(" ")[0],
      "last_name": fullName.split(" ")[1],
      "email_address": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "address": address.toJson(),
      "device": PlatformEngine.instance.device.toJson(),
      "fcm_token": fcmToken,
      "timezone": timezone
    };

    _connect.post(endpoint: "/auth/go/signup", body: payload).then((Outcome response) {
      state.isLoading.value = false;

      if(response.isSuccessful) {
        Navigate.close(closeAll: false);
        VerifyEmailSheet.open(emailController.text.trim());
      } else if(response.isEmailNotVerified) {
        Navigate.close(closeAll: false);
        notify.info(message: response.message);
        VerifyEmailSheet.open(emailController.text.trim());
      } else {
        notify.error(message: response.message);
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}