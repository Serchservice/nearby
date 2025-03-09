import 'dart:async';

import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class VerifyEmailController extends GetxController {
  final String emailAddress;

  VerifyEmailController(this.emailAddress);
  final state = VerifyEmailState();

  Timer? _timer;
  final TextEditingController otpController = TextEditingController();
  final FocusNode focus = FocusNode();

  final ConnectService _connect = Connect();

  bool _continue = true;

  @override
  void onReady() {
    if(emailAddress.isNotEmpty) {
      startTimer();
    } else {
      notify.warn(message: "An error occurred while processing your request");
      _continue = false;
    }

    super.onReady();
  }

  bool get showUi => _continue;

  void startTimer() {
    if(state.timeout.value != 59) {
      _timer?.cancel();
      state.timeout.value = 59;

      updateTimer();
    } else {
      updateTimer();
    }
  }

  void updateTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timer = timer;

      if(state.timeout.value.equals(0)) {
        timer.cancel();
        state.isCounting.value = false;
      } else {
        state.timeout.value--;
        state.isCounting.value = true;
      }
    });
  }

  void resend() async {
    if(_continue) {
      state.isResending.value = true;

      _connect.get(endpoint: "/auth/go/resend?email_address=$emailAddress&is_signup=${true}").then((Outcome response) {
        state.isResending.value = false;

        if(response.isSuccessful) {
          startTimer();
          return;
        } else {
          notify.error(message: response.message);
          return;
        }
      });
    }
  }

  void verify(String code) async {
    if(_continue) {
      state.otp.value = code;

      if(state.otp.isEmpty || state.otp.value.length < 6) {
        notify.error(message: "Incorrect token");
        return;
      }

      JsonMap payload = {
        "email_address": emailAddress,
        "token": state.otp.value,
      };

      state.isVerifying.value = true;
      _connect.post(endpoint: "/auth/go/signup/verify", body: payload).then((Outcome response) {
        state.isVerifying.value = false;

        if(response.isOk) {
          GoAuthResponse auth = GoAuthResponse.fromJson(response.data);

          ActivityLifeCycle.onAuthenticated(auth);
          BCapLifeCycle.onAuthenticated(auth);

          Navigate.close(closeAll: false);
          SelectInterestSheet.open(emailAddress);
        } else {
          notify.error(message: response.message);
          return;
        }
      }).onError((error, trace) {
        state.isVerifying.value = false;
        notify.error(message: "Couldn't complete request");
      });
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    focus.dispose();
    _timer?.cancel();
    
    super.onClose();
  }
}