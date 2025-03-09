import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController();
  final state = ForgotPasswordState();

  GlobalKey<FormState> formKey = GlobalKey();
  final ConnectService _connect = Connect();
  TextEditingController emailController = TextEditingController();

  void auth(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState.isNotNull && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      state.isLoading.value = true;
      _connect.get(endpoint: "/auth/go/forgot_password?email_address=${emailController.text.trim()}").then((Outcome response) {
        state.isLoading.value = false;

        if(response.isSuccessful) {
          notify.success(message: response.message);

          Navigate.close(closeAll: false);
          VerifyResetTokenSheet.open(emailController.text.trim());
        } else {
          notify.error(message: response.message);
        }
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();

    super.onClose();
  }
}