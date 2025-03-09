import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class LoginController extends GetxController {
  LoginController();
  final state = LoginState();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ConnectService _connect = Connect();
  final LocationService _locationService = LocationImplementation();
  final FirebaseMessagingService _messagingService = FirebaseMessagingImplementation();

  void login(BuildContext context) {
    CommonUtility.unfocus(context);

    if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state.isLoading.value = true;
      if(Database.instance.address.hasAddress.isFalse) {
        _locationService.getAddress(
          onSuccess: (address, position) {
            _login(address);
          },
          onError: (error) {
            state.isLoading.value = false;
            notify.warn(message: error);

            return;
          }
        );
      } else {
        _login(Database.instance.address);
      }
    }
  }

  void _login(Address address) async {
    String fcmToken = await _messagingService.getFcmToken();
    String timezone = await CommonUtility.getTimezone();

    JsonMap payload = {
      "email_address": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "address": address.toJson(),
      "device": PlatformEngine.instance.device.toJson(),
      "fcm_token": fcmToken,
      "timezone": timezone
    };

    _connect.post(endpoint: "/auth/go/login", body: payload).then((Outcome response) {
      state.isLoading.value = false;

      if(response.isSuccessful) {
        GoAuthResponse auth = GoAuthResponse.fromJson(response.data);

        ActivityLifeCycle.onAuthenticated(auth);
        BCapLifeCycle.onAuthenticated(auth);

        Navigate.close();
        if(response.message.equalsIgnoreCase("S96")) {
          SelectInterestSheet.open(emailController.text.trim());
        } else {
          Navigate.all(ParentLayout.route);
        }
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
    passwordController.dispose();

    super.onClose();
  }
}