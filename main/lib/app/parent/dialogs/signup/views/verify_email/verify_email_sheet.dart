import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class VerifyEmailSheet extends StatelessWidget {
  final String emailAddress;
  const VerifyEmailSheet({super.key, required this.emailAddress});

  static void open(String emailAddress) {
    Navigate.bottomSheet(
      sheet: VerifyEmailSheet(emailAddress: emailAddress),
      route: Navigate.appendRoute("/auth/signup/verify"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModalBottomSheetIndicator(showButton: false, margin: 0),
            GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
            TextBuilder(
              text: "Get the token!",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "Confirm your identity by using the otp sent to your email address.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Spacing.vertical(30),
            BannerAdLayout(
              expandChild: false,
              child: GetBuilder<VerifyEmailController>(
                init: VerifyEmailController(emailAddress),
                builder: (controller) {
                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OtpField.box(
                        controller: controller.otpController,
                        focusNode: controller.focus,
                        onCompleted: controller.verify,
                        onChanged: (code) => controller.state.otp.value = code,
                      ),
                      if(controller.showUi) ...[
                        Obx(() {
                          if(controller.state.isCounting.value) {
                            return TextBuilder(
                              text: "Request another in: ${controller.state.timeout.value} seconds",
                              size: Sizing.font(14),
                              color: Theme.of(context).primaryColor,
                            );
                          } else {
                            return TextButton(
                              onPressed: controller.resend,
                              style: ButtonStyle(
                                overlayColor: WidgetStateProperty.resolveWith((states) {
                                  return CommonColors.instance.bluish.lighten(68);
                                }),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
                              ),
                              child: TextBuilder(
                                text: controller.state.isResending.value ? "Resending..." : "Resend",
                                weight: FontWeight.bold,
                                color: CommonColors.instance.bluish
                              )
                            );
                          }
                        })
                      ],
                      Obx(() => InteractiveButton(
                        text: "Verify identity",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.instance.color,
                        textColor: CommonColors.instance.lightTheme,
                        onClick: () => controller.verify(controller.state.otp.value),
                        loading: controller.state.isVerifying.value,
                      )),
                    ],
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}