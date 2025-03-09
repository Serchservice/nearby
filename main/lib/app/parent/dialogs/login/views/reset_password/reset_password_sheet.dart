import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

class ResetPasswordSheet extends StatelessWidget {
  final String emailAddress;

  const ResetPasswordSheet({super.key, required this.emailAddress});

  static void open(String emailAddress) {
    Navigate.bottomSheet(
      sheet: ResetPasswordSheet(emailAddress: emailAddress),
      route: Navigate.appendRoute("/auth/reset_password"),
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
              text: "Setup your password!",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "Let's get you back with a new set of keys.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Spacing.vertical(30),
            BannerAdLayout(
              expandChild: false,
              child: GetX<ResetPasswordController>(
                init: ResetPasswordController(emailAddress),
                builder: (controller) {
                  bool showPassword = controller.state.showPassword.value;
                  bool showConfirmPassword = controller.state.showConfirmPassword.value;

                  return Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmartField.builder(
                        formKey: controller.formKey,
                        items: [
                          FieldItem(
                            hint: "#@asdaser1232",
                            label: "Password",
                            isPassword: true,
                            validator: InputValidator.password,
                            obscureText: showPassword,
                            onVisibilityTapped: controller.state.showPassword.toggle,
                            controller: controller.passwordController,
                          ),
                          FieldItem(
                            hint: "#@asdaser1232",
                            label: "Confirm Password",
                            isPassword: true,
                            validator: (String? value) {
                              if(value != controller.passwordController.text) {
                                return "Password does not match";
                              }

                              return null;
                            },
                            obscureText: showConfirmPassword,
                            onVisibilityTapped: controller.state.showConfirmPassword.toggle,
                            controller: controller.confirmPasswordController,
                          ),
                        ],
                        itemBuilder: (context, field, metadata) {
                          return field.copyWith(
                            hint: metadata.item.hint,
                            needLabel: true,
                            replaceHintWithLabel: false,
                            label: metadata.item.label,
                            fillColor: Theme.of(context).appBarTheme.backgroundColor,
                            inputConfigBuilder: (config) => config.copyWith(
                              labelColor: Theme.of(context).primaryColor,
                              labelSize: 14
                            ),
                            validator: metadata.item.validator,
                            obscureText: metadata.item.obscureText,
                            onPressed: metadata.item.onVisibilityTapped,
                            inputDecorationBuilder: (dec) => dec.copyWith(
                              enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                              focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            onTapOutside: (activity) => CommonUtility.unfocus(context),
                            controller: metadata.item.controller,
                          );
                        }
                      ),
                      InteractiveButton(
                        text: "Reset password",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.instance.color,
                        textColor: CommonColors.instance.lightTheme,
                        onClick: () => controller.reset(context),
                        loading: controller.state.isLoading.value,
                      ),
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