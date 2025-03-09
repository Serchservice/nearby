import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetBuilder, Obx;
import 'package:smart/smart.dart';

class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: ForgotPasswordSheet(),
      route: "/auth/forgot_password",
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
              text: "No need to worry!",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "Use your email address to recover your account.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Spacing.vertical(30),
            BannerAdLayout(
              expandChild: false,
              child: GetBuilder<ForgotPasswordController>(
                init: ForgotPasswordController(),
                builder: (controller) {
                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: controller.formKey,
                        child: Field(
                          hint: "stellmaris@gmail.com",
                          needLabel: true,
                          replaceHintWithLabel: false,
                          label: "Email Address",
                          inputConfigBuilder: (config) => config.copyWith(
                            labelColor: Theme.of(context).primaryColor,
                            labelSize: 14
                          ),
                          fillColor: Theme.of(context).appBarTheme.backgroundColor,
                          inputDecorationBuilder: (dec) => dec.copyWith(
                            enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                            focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          validator: InputValidator.email,
                          onTapOutside: (activity) => CommonUtility.unfocus(context),
                          controller: controller.emailController,
                        ),
                      ),
                      Obx(() => InteractiveButton(
                        text: "Verify email address",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.instance.color,
                        textColor: CommonColors.instance.lightTheme,
                        loading: controller.state.isLoading.value,
                        onClick: () => controller.auth(context),
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